Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C13C4321E
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A5461151
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbhKIBxt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:53:49 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39231 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240487AbhKIBxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:53:46 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 1B534107019
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:50:58 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006ZXp-1C
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:50:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHp-006UcG-W5
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:50:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/16 v6] xfs: rework xlog_write()
Date:   Tue,  9 Nov 2021 12:50:39 +1100
Message-Id: <20211109015055.1547604-1-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6189d403
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=afZ3VLhyg-m26p0hK-wA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Time to try again for this code....

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

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xlog-write-rework

Version 6:
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

