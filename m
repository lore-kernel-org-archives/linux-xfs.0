Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 25C1F7F37
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 14:19:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1622B304032
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 12:19:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RUo7E1QWnTCQXtUR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 May 2015 12:19:32 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t4FJJUUO007793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 15 May 2015 15:19:31 -0400
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4FJJU1W028228
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 15:19:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix broken i_nlink accounting for whiteout tmpfile inode
Date: Fri, 15 May 2015 15:19:28 -0400
Message-Id: <1431717568-27124-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

XFS uses the internal tmpfile() infrastructure for the whiteout inode
used for RENAME_WHITEOUT operations. For tmpfile inodes, XFS allocates
the inode, drops di_nlink, adds the inode to the agi unlinked list,
calls d_tmpfile() which correspondingly drops i_nlink of the vfs inode,
and then finishes the common inode setup (e.g., clear I_NEW and unlock).

The d_tmpfile() call was originally made inxfs_create_tmpfile(), but was
pulled up out of that function as part of the following commit to
resolve a deadlock issue:

	330033d6 xfs: fix tmpfile/selinux deadlock and initialize security

As a result, callers of xfs_create_tmpfile() are responsible for either
calling d_tmpfile() or fixing up i_nlink appropriately. The whiteout
tmpfile allocation helper does neither. As a result, the vfs ->i_nlink
becomes inconsistent with the on-disk ->di_nlink once xfs_rename() links
it back into the source dentry and calls xfs_bumplink().

Update the assert in xfs_rename() to help detect this problem in the
future and update xfs_rename_alloc_whiteout() to decrement the link
count as part of the manual tmpfile inode setup.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d6ebc85..e54eb05 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2883,7 +2883,13 @@ xfs_rename_alloc_whiteout(
 	if (error)
 		return error;
 
-	/* Satisfy xfs_bumplink that this is a real tmpfile */
+	/*
+	 * Prepare the tmpfile inode as if it were created through the VFS.
+	 * Otherwise, the link increment paths will complain about nlink 0->1.
+	 * Drop the link count as done by d_tmpfile(), complete the inode setup
+	 * and flag it as linkable.
+	 */
+	drop_nlink(VFS_I(tmpfile));
 	xfs_finish_inode_setup(tmpfile);
 	VFS_I(tmpfile)->i_state |= I_LINKABLE;
 
@@ -3151,7 +3157,7 @@ xfs_rename(
 	 * intermediate state on disk.
 	 */
 	if (wip) {
-		ASSERT(wip->i_d.di_nlink == 0);
+		ASSERT(VFS_I(wip)->i_nlink == 0 && wip->i_d.di_nlink == 0);
 		error = xfs_bumplink(tp, wip);
 		if (error)
 			goto out_trans_abort;
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
