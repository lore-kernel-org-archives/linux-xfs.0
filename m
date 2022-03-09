Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7F2C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiCIFal (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiCIFak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:40 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CE423E5D2
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:41 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AA55710E2520
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H4u-DQ
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJWW-C4
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/16 v8] xfs: rework xlog_write()
Date:   Wed,  9 Mar 2022 16:29:21 +1100
Message-Id: <20220309052937.2696447-1-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62283b44
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=SarF3Khav3S-rVfkixYA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI folks,

This is the xlog_write() rework patchset again. It's unchanged from
the fully reviewed v7 patchset except for rebasing onto a more
recent kernel. I'm trying to untie this from the CIL scalability
patchset that has caused problems the last two times I've tried to
get this specific set of patches merged.

Cheers,

Dave.

----

xlog_write() is code that causes severe eye bleeding. It's extremely
difficult to understand the way it is structured, and extremely easy
to break because of all the weird parameters it passes between
functions that do very non-obvious things. state is set in
xlog_write_finish_copy() that is carried across both outer and inner
loop iterations that is used by xlog_write_setup_copy(), which also
sets state that xlog_write_finish_copy() needs. The way iclog space
was obtained affects the accounting logic that ends up being passed
to xlog_state_finish_copy(). The code that handles commit iclogs is
spread over multiple functions and is obfuscated by the set/finish
copy code.

It's just a mess.

It's also extremely inefficient.

For all the complexity created by having to keep track of partial
copy state for loop continuation, this is a *rare* occurrence. On a
256kB iclog buffer, we can copy a couple of thousand regions (e.g.
inode log format + inode core regions) without hitting the partial
copy case once. IOWs, we don't need to track partial copy state for
the vast majority of region copy operations we perform. It's all
unnecessary overhead.

Not to mention that before we even start the copy, we walk every log
vector and log iovec to count the op headers needed and the amount
of space consumed by the log vector chain despite having just done a
log item walk to construct the log vector chain.  This is all
unnecessary overhead given that the CIL code already counts the
vectors and can trivially count the size of the log vector chain at
the same time.

Then there is the opheaders that xlog_write() adds before every
region. This is why it needs to count headers, because we have
to account for this space they use in the journal. We've already
reserved this space when committing items to the CIL, but we still
require xlog_write() to add these fixed size headers to log regions
and account for the space in the CIL context log ticket.

Hence we have complexity tracking and reserving CIL space at
transaction commit time, as well as complexity formatting and
accounting for this space when the CIL writes them to the log. This
can be done much more efficiently by adding the opheaders to the log
regions at item formatting time, largely removing the need to do
anything but update opheader lengths and flags in xlog_write().

This opens up a bunch of other optimisations in the item formatting
code that can reduce the number of regions we need to track, but
that is not a topic this patch set tries to address.

The simplification of the accounting and reservation of space for
log opheaders during the transaction commit path allows for further
optimisations of that fast path. e.g. it makes it possible to
move to per-cpu accounting and tracking of the CIL.

Further, the simplifications in opheader management allow us to
implement a fast path for xlog_write() that does almost nothing but
iterate the log vector chain doing memcpy() and advancing the iclog
data pointer. The only time we need to worry about partial copies is
when a log vector will not wholly fit within the current iclog. By
writing a slow path that just handles a single log vector that needs
to be split across multiple iclogs, we get rid of all the difficult
to follow logic. That is what this patchset implements.

Overall, we go from 3 iterations of the log vector chain to two, the
majority of the copies hit the xlog_write_single() fast path, the
xlog_write() code is much simpler, the handling of iclog state is
much cleaner, and all the partial copy state is contained within a
single function. The fast path loops are much smaller and tighter,
the regions we memcpy() are larger, and so overall the code is much
more efficient.

Unfortunately, this code is complex and full of subtle stuff that
takes a *lot* of time and effort to understand. Hence I feel that
these changes aren't actually properly reviewable by anyone. If
someone else presented this patchset to me, I'd be pretty much say
the same thing, because to understand all the subtle corner cases in
xlog_write() takes weeks of bashing your head repeatedly into said
corner cases.

But, really, that's why I've rewritten the code. I think the code
I've written is much easier to understand and there's less of it.
The compiled code is smaller and faster. It passes fstests. And it
opens more avenues for future improvement of the log write code
that would otherwise have to do with the mess of xlog_write()....

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xlog-write-rework-3

Version 8:
- rebase on v5.17-rc4, otherwise unchanged.

Version 7:
- https://lore.kernel.org/linux-xfs/20211118231352.2051947-1-david@fromorbit.com/
- fixed th_tid endian issue, updated comment (patch 2).
- fixed bug not setting ophdr length for transaction header (patch 2).
  Bug hidden by xlog_write() always overwriting oh_len correctly.
- fixed oh_len endian issue in xlog_finish_iovec() (patch 7).
  Bug hidden by xlog_write() always overwriting oh_len correctly.
- don't overwrite oh_len in xlog_write_full() as xlog_finish_iovec() has already
  written it correctly (patch 11).
- removed spurious _ in patch subject (patch 12).

Version 6:
- https://lore.kernel.org/linux-xfs/20211109015055.1547604-1-david@fromorbit.com/
- split out from aggregated patchset
- rebase on linux-xfs/for-next
- include iclog->ic_datap type change patch from Christoph Hellwig
- rolled xlog_write_iovec()/xlog_write_full() improvements into the
  xlog_write_single() introduction (adaption from patches written by Christoph
  Hellwig)
- pass record_cnt and data_cnt into xlog_write_single() right from the start
  rather than modify the interface when xlog_write_partial() comes along.
- rolled the xlog_write_partial() and log vector iteration improvements into
  the xlog_write_partial() introduction (adaption from patches written by
  Christoph Hellwig).
- include remove xlog_verify_dest_ptr() patch from Christoph Hellwig

Version 5:
- https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/

