Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5258C4708A
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B2EA61073
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhE0Exm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 00:53:42 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58526 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234387AbhE0Exk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 00:53:40 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id A593680AC20
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 14:52:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-005h18-Nd
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-004qgN-Cy
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/6] xfs: bunmapi needs updating for deferred freeing 
Date:   Thu, 27 May 2021 14:51:56 +1000
Message-Id: <20210527045202.1155628-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=1huTdFM_S752URy94qgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I pulled on a loose thread when I started looking into the 64kB
directory block size assert failure I was seeing while trying to
test the bulk page allocation changes.

I posted the first patch in the series separately - it fixed the
immediate assert failure (5.13-rc1 regression) I was seeing, but in
fixing that it only then dropped back to the previous assert failure
that g/538 was triggering with 64kb directory block sizes. This can
only be reproduced on 5.12, because that's when the error injection
that g/538 uses was added. So I went looking deeper.

It turns out that xfs_bunmapi() has some code in it to avoid locking
AGFs in the wrong order and this is what was triggering. Many of the
xfs_bunmapi() callers can not/do not handle partial unmaps that
return success, and that's what the directory code is tripping over
trying to free badly fragmented directory blocks.

This AGF locking order constraint was added to xfs_bunmapu in 2017
to avoid a deadlock in g/299. Sad thing is that shortly after this,
we converted xfs-bunmapi to use deferred freeing, so it never
actually locks AGFs anymore. But the deadlock avoiding landmine
remained. And xfs_bmap_finish() went away, too, and we now only ever
put one extent in any EFI we log for deferred freeing.

That means we now only free one extent per transaction via deferred
freeing, and there are no limitations on what order xfs_bunmapi()
can unmap extents. 64kB directories on a 1kB block size filesystem
already unmap 64 extents in a single loop, so there's no real
limitation here.

This means that the limitations of how many extents we can unmap per
loop in xfs_itruncate_extents_flags() goes away for data device
extents (and will eventually go away for RT devices, too, when
Darrick's RT EFI stuff gets merged).

This "one data deveice extent free per transaction" change now means
that all of the transaction reservations that include
"xfs_bmap_finish" based freeing reservations are wrong. These extent
frees are now done by deferred freeing, and so they only need a
single extent free reservation instead of up to 4 (as truncate was
reserving).

This series fixes the btree fork regression, the bunmapi partial
unmap regression from 2017, extends xfs_itruncate_extents to unmap
64 extents at a time for data device (AG) resident extents, and
reworks the transaction reservations to use a consistent and correct
reservation for allocation and freeing extents. The size of some
transaction reservations drops dramatically as a result.

The first two patches are -rcX candidates, the rest are for the next
merge cycle....

Cheers,

Dave.

