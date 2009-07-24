Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6OEXQ0b132827 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 09:33:26 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D414F382F9D
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 07:34:09 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id DnBmGoluCQBbNFxJ for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 07:34:09 -0700 (PDT)
Message-ID: <4A69C660.9000604@sandeen.net>
Date: Fri, 24 Jul 2009 09:34:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: check for null single-block dir buffer pointer
	in phase6
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This is for Bug 844 -  xfs_repair from git segfaults in stage 6
on oss.sgi.com's bugzilla:

Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
entry "stdio-common" in dir ino 2858345118 doesn't have a .. entry, will set it
in ino 3503084373.
empty data block 0 in directory inode 3503084373: junking block
<segfault>

longform_dir2_entry_check() calls longform_dir2_entry_check_data()
which issues that "junking block" message, and it sets *bpp (which
is bplist[0] passed in) to NULL.

(minor note, I think this leaks a bit of memory).

In this case it's a single-block directory, the dir was found to 
have no valid data, and so it was junked.  So there is no point in
checking the integrity of this block, and in fact trying to do
so is what segfaults, thanks to the NULL-setting above.

So a simple patch like this avoids the segfault.

However, there is still an issue where the problematic directory
is set to link count 1 in Phase 7, and a subsequent repair run
bumps it back up to 2.  But in the spirit of fixing one thing
at a time, here's a patch.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index becedbd..101df15 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2516,6 +2516,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			*num_illegal += 1;
 			continue;	/* try and read all "data" blocks */
 		}
+		/* Note, this may NULL out bplist[db] if it's junked */
 		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
 				irec, ino_offset, &bplist[db], hashtab,
 				&freetab, da_bno, isblock);
@@ -2524,7 +2525,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 
 	if (!dotdot_update) {
 		/* check btree and freespace */
-		if (isblock) {
+		if (isblock && bplist[0]) {
 			xfs_dir2_block_tail_t	*btp;
 			xfs_dir2_leaf_entry_t	*blp;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
