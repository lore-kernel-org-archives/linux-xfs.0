Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAE3C6FD1F
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Mar 2023 16:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjCSQzJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Mar 2023 12:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCSQyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Mar 2023 12:54:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFAB13D61
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 09:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35B34B80C87
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 16:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0D9C433D2;
        Sun, 19 Mar 2023 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679244879;
        bh=ph/PFUKzBv1P4mMVelz53lI7DqqnoelIze3LtQh7WmY=;
        h=Date:From:To:Cc:Subject:From;
        b=JOFbcHUwHfz8xAFF/9MtVVBFBRR7RVQH5lcnH4pm44hhEDcm09WoYY/qU9pLrAVu5
         ZprctX7/2FSD76q0kUn7FuazMr2F3LgIZ1aH7s+UQkqLj1OfkWI76msd8OIvWONLEQ
         KBNbdg0TAP/HI9a0vwKgphA9/j7y21RrM433l9N8vO2kXybziBB/1ShDzo+op7nSI0
         tLbV7Xq7sB8xv6fZ9XeTYpQZFYCVOPYusEc8U9gOS+ZmD0hSFtnlLY8QonKZ8fMHFN
         Qd1IpFZC/HMO9CxkKQPUznsDoOZ05zQPRikk0ooJqLJZC74NhUrvXX1Ny8jl4ViiMy
         lHH+/y/tinErQ==
Date:   Sun, 19 Mar 2023 09:54:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: pass the correct cursor to xfs_iomap_prealloc_size
Message-ID: <20230319165439.GY11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In xfs_buffered_write_iomap_begin, @icur is the iext cursor for the data
fork and @ccur is the cursor for the cow fork.  Pass in whichever cursor
corresponds to allocfork, because otherwise the xfs_iext_prev_extent
call can use the data fork cursor to walk off the end of the cow fork
structure.  Best case it returns the wrong results, worst case it does
this:

stack segment: 0000 [#1] PREEMPT SMP
CPU: 2 PID: 3141909 Comm: fsstress Tainted: G        W          6.3.0-rc2-xfsx #6.3.0-rc2 7bf5cc2e98997627cae5c930d890aba3aeec65dd
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014
RIP: 0010:xfs_iext_prev+0x71/0x150 [xfs]
RSP: 0018:ffffc90002233aa8 EFLAGS: 00010297
RAX: 000000000000000f RBX: 000000000000000e RCX: 000000000000000c
RDX: 0000000000000002 RSI: 000000000000000e RDI: ffff8883d0019ba0
RBP: 989642409af8a7a7 R08: ffffea0000000001 R09: 0000000000000002
R10: 0000000000000000 R11: 000000000000000c R12: ffffc90002233b00
R13: ffff8883d0019ba0 R14: 989642409af8a6bf R15: 000ffffffffe0000
FS:  00007fdf8115f740(0000) GS:ffff88843fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdf8115e000 CR3: 0000000357256000 CR4: 00000000003506e0
Call Trace:
 <TASK>
 xfs_iomap_prealloc_size.constprop.0.isra.0+0x1a6/0x410 [xfs 619a268fb2406d68bd34e007a816b27e70abc22c]
 xfs_buffered_write_iomap_begin+0xa87/0xc60 [xfs 619a268fb2406d68bd34e007a816b27e70abc22c]
 iomap_iter+0x132/0x2f0
 iomap_file_buffered_write+0x92/0x330
 xfs_file_buffered_write+0xb1/0x330 [xfs 619a268fb2406d68bd34e007a816b27e70abc22c]
 vfs_write+0x2eb/0x410
 ksys_write+0x65/0xe0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Found by xfs/538 in alwayscow mode, but this doesn't seem particular to
that test.

Fixes: 590b16516ef3 ("xfs: refactor xfs_iomap_prealloc_size")
Actually-Fixes: 66ae56a53f0e ("xfs: introduce an always_cow mode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 69dbe7814128..285885c308bd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1090,9 +1090,12 @@ xfs_buffered_write_iomap_begin(
 		 */
 		if (xfs_has_allocsize(mp))
 			prealloc_blocks = mp->m_allocsize_blocks;
-		else
+		else if (allocfork == XFS_DATA_FORK)
 			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
 						offset, count, &icur);
+		else
+			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
+						offset, count, &ccur);
 		if (prealloc_blocks) {
 			xfs_extlen_t	align;
 			xfs_off_t	end_offset;
