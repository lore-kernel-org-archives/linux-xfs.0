Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96627C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jun 2022 22:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiFZWD6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 18:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiFZWD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 18:03:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071FD2DC6
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 15:03:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE4D4B80DFB
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 22:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E6CC34114;
        Sun, 26 Jun 2022 22:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656281033;
        bh=NMxOEV9gasUPfQ48BQhN93q/n0LRZhlep5ewDFbn7PM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rT48M1O3gmCbjzmYwa+tGZwZ7HUwRZmXwlXrZyv5L/Pe4oqfLagnFv6pl85fO05Jw
         GEqUCTroDZ8RNdWHEx6HSGW/3uotK3JYE8JlxggkEnPhFWQstBMJ/wt76JVDVwhtCd
         V6ndXJEyURfyV9xZrkfEoPUjIRwD4nmEEKceGxScJjDJRZjaMSHSFAnf/nLA/F5oxG
         /LmAlqz62o7BHQqBTUes21rhPqIfQt3MHKzAeqmJSrGNC39x2Ra6hPpl/YqO+orFUg
         6SkTYdGAJeUz2fHqX7xRa6SXhEIF/rZesqk1BPag0vVovIp5t0UYgE4U+a016QCoDs
         Yk5UTmWGMc82A==
Subject: [PATCH 1/3] xfs: empty xattr leaf header blocks are not corruption
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 26 Jun 2022 15:03:53 -0700
Message-ID: <165628103299.4040423.12298502732701682950.stgit@magnolia>
In-Reply-To: <165628102728.4040423.16023948770805941408.stgit@magnolia>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then we get a corruption report from the kernel or
xfs_repair about empty leaf blocks in the extended attribute structure.
We've long thought that these shouldn't be possible, but prior to 5.18
one would shake loose in the recoveryloop fstests about once a month.

A new addition to the xattr leaf block verifier in 5.19-rc1 makes this
happen every 7 minutes on my testing cloud.  I added a ton of logging to
detect any time we set the header count on an xattr leaf block to zero.
This produced the following dmesg output on generic/388:

XFS (sda4): ino 0x21fcbaf leaf 0x129bf78 hdcount==0!
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 xfs_attr3_leaf_create+0x187/0x230
 xfs_attr_shortform_to_leaf+0xd1/0x2f0
 xfs_attr_set_iter+0x73e/0xa90
 xfs_xattri_finish_update+0x45/0x80
 xfs_attr_finish_item+0x1b/0xd0
 xfs_defer_finish_noroll+0x19c/0x770
 __xfs_trans_commit+0x153/0x3e0
 xfs_attr_set+0x36b/0x740
 xfs_xattr_set+0x89/0xd0
 __vfs_setxattr+0x67/0x80
 __vfs_setxattr_noperm+0x6e/0x120
 vfs_setxattr+0x97/0x180
 setxattr+0x88/0xa0
 path_setxattr+0xc3/0xe0
 __x64_sys_setxattr+0x27/0x30
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

So now we know that someone is creating empty xattr leaf blocks as part
of converting a sf xattr structure into a leaf xattr structure.  The
conversion routine logs any existing sf attributes in the same
transaction that creates the leaf block, so we know this is a setxattr
to a file that has no attributes at all.

Next, g/388 calls the shutdown ioctl and cycles the mount to trigger log
recovery.  I also augmented buffer item recovery to call ->verify_struct
on any attr leaf blocks and complain if it finds a failure:

XFS (sda4): Unmounting Filesystem
XFS (sda4): Mounting V5 Filesystem
XFS (sda4): Starting recovery (logdev: internal)
XFS (sda4): xattr leaf daddr 0x129bf78 hdrcount == 0!
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 xfs_attr3_leaf_verify+0x3b8/0x420
 xlog_recover_buf_commit_pass2+0x60a/0x6c0
 xlog_recover_items_pass2+0x4e/0xc0
 xlog_recover_commit_trans+0x33c/0x350
 xlog_recovery_process_trans+0xa5/0xe0
 xlog_recover_process_data+0x8d/0x140
 xlog_do_recovery_pass+0x19b/0x720
 xlog_do_log_recovery+0x62/0xc0
 xlog_do_recover+0x33/0x1d0
 xlog_recover+0xda/0x190
 xfs_log_mount+0x14c/0x360
 xfs_mountfs+0x517/0xa60
 xfs_fs_fill_super+0x6bc/0x950
 get_tree_bdev+0x175/0x280
 vfs_get_tree+0x1a/0x80
 path_mount+0x6f5/0xaa0
 __x64_sys_mount+0x103/0x140
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fc61e241eae

And a moment later, the _delwri_submit of the recovered buffers trips
the same verifier and recovery fails:

XFS (sda4): Metadata corruption detected at xfs_attr3_leaf_verify+0x393/0x420 [xfs], xfs_attr3_leaf block 0x129bf78
XFS (sda4): Unmount and run xfs_repair
XFS (sda4): First 128 bytes of corrupted metadata buffer:
00000000: 00 00 00 00 00 00 00 00 3b ee 00 00 00 00 00 00  ........;.......
00000010: 00 00 00 00 01 29 bf 78 00 00 00 00 00 00 00 00  .....).x........
00000020: a5 1b d0 02 b2 9a 49 df 8e 9c fb 8d f8 31 3e 9d  ......I......1>.
00000030: 00 00 00 00 02 1f cb af 00 00 00 00 10 00 00 00  ................
00000040: 00 50 0f b0 00 00 00 00 00 00 00 00 00 00 00 00  .P..............
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (sda4): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply+0x37f/0x3b0 [xfs] (fs/xfs/xfs_buf.c:1518).  Shutting down filesystem.
XFS (sda4): Please unmount the filesystem and rectify the problem(s)
XFS (sda4): log mount/recovery failed: error -117
XFS (sda4): log mount failed

I think I see what's going on here -- setxattr is racing with something
that shuts down the filesystem:

Thread 1				Thread 2
--------				--------
xfs_attr_sf_addname
xfs_attr_shortform_to_leaf
<create empty leaf>
xfs_trans_bhold(leaf)
xattri_dela_state = XFS_DAS_LEAF_ADD
<roll transaction>
					<flush log>
					<shut down filesystem>
xfs_trans_bhold_release(leaf)
<discover fs is dead, bail>

Thread 3
--------
<cycle mount, start recovery>
xlog_recover_buf_commit_pass2
xlog_recover_do_reg_buffer
<replay empty leaf buffer from recovered buf item>
xfs_buf_delwri_queue(leaf)
xfs_buf_delwri_submit
_xfs_buf_ioapply(leaf)
xfs_attr3_leaf_write_verify
<trip over empty leaf buffer>
<fail recovery>

As you can see, the bhold keeps the leaf buffer locked and thus prevents
the *AIL* from tripping over the ichdr.count==0 check in the write
verifier.  Unfortunately, it doesn't prevent the log from getting
flushed to disk, which sets up log recovery to fail.

So.  It's clear that the kernel has always had the ability to persist
attr leaf blocks with ichdr.count==0, which means that it's part of the
ondisk format now.  The original patch adding a check to the verifier
was therefore not correct, and the interim patches neutering the check
did not fix the problem completely.  Removing it was the correct
solution, but then the check was added back in 51e6104fdb95.  We clearly
suck at this, so this time replace the incorrect check with a tombstone
comment laying out the entire sad history.

Looking at the rest of the xattr code, it seems that files with empty
leaf blocks behave as expected -- listxattr reports no attributes;
getxattr on any xattr returns nothing as expected; removexattr does
nothing; and setxattr can add attributes just fine.

Original-bug: 517c22207b04 ("xfs: add CRCs to attr leaf blocks")
Still-not-fixed: 2e1d23370e75 ("xfs: ignore leaf attr ichdr.count in verifier during log replay")
Removed-in: f28cef9e4dac ("xfs: don't fail verifier on empty attr3 leaf block")
Fixes: 51e6104fdb95 ("xfs: detect empty attr leaf blocks in xfs_attr3_leaf_verify")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   48 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 37e7c33f6283..be7c216ec8f2 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -311,13 +311,49 @@ xfs_attr3_leaf_verify(
 		return fa;
 
 	/*
-	 * Empty leaf blocks should never occur;  they imply the existence of a
-	 * software bug that needs fixing. xfs_repair also flags them as a
-	 * corruption that needs fixing, so we should never let these go to
-	 * disk.
+	 * Empty leaf blocks can occur under the following circumstances:
+	 *
+	 * 1. setxattr adds a new extended attribute to a file;
+	 * 2. The file has zero existing attributes;
+	 * 3. The attribute is too large to fit in the attribute fork;
+	 * 4. The attribute is small enough to fit in a leaf block;
+	 * 5. A log flush occurs after committing the transaction that creates
+	 *    the (empty) leaf block; and
+	 * 6. The filesystem goes down after the log flush but before the new
+	 *    attribute can be committed to the leaf block.
+	 *
+	 * xfs_repair used to flag these empty leaf blocks as corruption, but
+	 * aside from wasting space, they are benign.  The rest of the xattr
+	 * code will happily add attributes to empty leaf blocks.  Hence this
+	 * comment serves as a tombstone to incorrect verifier code.
+	 *
+	 * Unfortunately, this check has been added and removed multiple times
+	 * throughout history.  It first appeared in[1] kernel 3.10 as part of
+	 * the early V5 format patches.  The check was later discovered to
+	 * break log recovery and hence disabled[2] during log recovery in
+	 * kernel 4.10.  Simultaneously, the check was added[3] to xfs_repair
+	 * 4.9.0 to try to weed out the empty leaf blocks.  This was still not
+	 * correct because log recovery would recover an empty attr leaf block
+	 * successfully only for regular xattr operations to trip over the
+	 * empty block during of the block during regular operation.
+	 * Therefore, the check was removed entirely[4] in kernel 5.7 but
+	 * removal of the xfs_repair check was forgotten.  The continued
+	 * complaints from xfs_repair lead to us mistakenly re-adding[5] the
+	 * verifier check for kernel 5.19, and has been removed once again.
+	 *
+	 * [1] 517c22207b04 ("xfs: add CRCs to attr leaf blocks")
+	 * [2] 2e1d23370e75 ("xfs: ignore leaf attr ichdr.count in verifier
+	 *                    during log replay")
+	 * [3] f7140161 ("xfs_repair: junk leaf attribute if count == 0")
+	 * [4] f28cef9e4dac ("xfs: don't fail verifier on empty attr3 leaf
+	 *                    block")
+	 * [5] 51e6104fdb95 ("xfs: detect empty attr leaf blocks in
+	 *                    xfs_attr3_leaf_verify")
+	 *
+	 * Normally this would go in the commit message, but as we've a history
+	 * of getting this wrong, this now goes in the code base as a gigantic
+	 * comment.
 	 */
-	if (ichdr.count == 0)
-		return __this_address;
 
 	/*
 	 * firstused is the block offset of the first name info structure.

