Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750904AbeDNBAV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Apr 2018 21:00:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 647FD356CB
        for <linux-xfs@vger.kernel.org>; Sat, 14 Apr 2018 01:00:21 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 35C185D9C9
        for <linux-xfs@vger.kernel.org>; Sat, 14 Apr 2018 01:00:21 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: notify user if free inodes contain errors
Message-ID: <c05f7e4f-8dc6-5d2f-4e9a-709de95012c9@redhat.com>
Date: Fri, 13 Apr 2018 20:00:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

xfs_repair checks allocated but unused (free) inodes in on-disk clusters,
and up until now silently repairs any errors, and as a result does not
alter exit status if errors are found.

The in-kernel verifiers will be noisy about these errors and instruct
the user to run repair, so it's best if repair is explicit about any
fixes it makes.

This also requires tweaking or removing some tests for free inode
state to match what the kernel does on either initial allocation or
eventual free after re-use.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/repair/dinode.c b/repair/dinode.c
index 9af4f05..1d7659f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -117,6 +117,15 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	return(1);
 }
 
+/*
+ * Clear the on-disk inode, and also test for inconsistencies along the way.
+ * In some cases this is to wipe out a bad inode, in other cases it is
+ * validating an unused but allocated inode on disk.
+ * The kernel leaves unused inodes on disk in slightly different states
+ * depending on whether it is freshly allocated or used and then freed,
+ * so this function only validates deterministic fields set by the
+ * kernel in i.e. xfs_ialloc_inode_init or  xfs_ifree.
+ */
 static int
 clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 {
@@ -159,17 +168,21 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 		dinoc->di_forkoff = 0;
 	}
 
-	if (dinoc->di_format != XFS_DINODE_FMT_EXTENTS)  {
+	/* Brand new allocated, never used inodes have format 0 */
+	if (dinoc->di_format &&
+	    dinoc->di_format != XFS_DINODE_FMT_EXTENTS)  {
 		__dirty_no_modify_ret(dirty);
 		dinoc->di_format = XFS_DINODE_FMT_EXTENTS;
 	}
 
-	if (dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
+	if (dinoc->di_aformat &&
+	    dinoc->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
 		__dirty_no_modify_ret(dirty);
 		dinoc->di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 
-	if (be64_to_cpu(dinoc->di_size) != 0)  {
+	if (S_ISREG(be16_to_cpu(dinoc->di_mode)) &&
+	    be64_to_cpu(dinoc->di_size) != 0)  {
 		__dirty_no_modify_ret(dirty);
 		dinoc->di_size = 0;
 	}
@@ -227,15 +240,7 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 		dinoc->di_flags2 = 0;
 	}
 
-	if (be64_to_cpu(dinoc->di_lsn) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_lsn = 0;
-	}
-
-	if (be64_to_cpu(dinoc->di_changecount) != 0)  {
-		__dirty_no_modify_ret(dirty);
-		dinoc->di_changecount = 0;
-	}
+	/* We leave di_lsn, di_changecount alone, as does the kernel */
 
 	return dirty;
 }
@@ -2358,7 +2363,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	}
 
 	/*
-	 * if not in verify mode, check to sii if the inode and imap
+	 * if not in verify mode, check to see if the inode and imap
 	 * agree that the inode is free
 	 */
 	if (!verify_mode && di_mode == 0) {
@@ -2369,10 +2374,17 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			/*
 			 * easy case, inode free -- inode and map agree, clear
 			 * it just in case to ensure that format, etc. are
-			 * set correctly
+			 * set correctly.  no_modify is tested in clear_dinode.
 			 */
-			if (!no_modify)
-				*dirty += clear_dinode(mp, dino, lino);
+			if (clear_dinode(mp, dino, lino) != 0) {
+				do_warn(
+	_("free inode %" PRIu64 " contains errors, "), lino);
+				if (!no_modify) {
+					do_warn(_("corrected\n"));
+					*dirty += 1;
+				} else
+					do_warn(_("would correct\n"));
+			}
 			*used = is_free;
 			return 0;
 		}


