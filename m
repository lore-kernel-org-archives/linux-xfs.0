Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932073AbeFZAD6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jun 2018 20:03:58 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD6C0B9A62
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 00:03:58 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D1A9308BDA2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 00:03:58 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove deprecated barrier/nobarrier mount options
Message-ID: <56f0a68c-9c1b-712a-a0e8-e596f8272561@redhat.com>
Date: Mon, 25 Jun 2018 19:03:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The barrier mount options have been no-ops and deprecated since

4cf4573 xfs: deprecate barrier/nobarrier mount option

i.e. kernel 4.10 / December 2016, with a stated deprecation schedule
after v4.15.  Should be fair game to remove them now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 Documentation/filesystems/xfs.txt |    4 ++--
 fs/xfs/xfs_mount.h                |    1 -
 fs/xfs/xfs_super.c                |   34 ++++------------------------------
 3 files changed, 6 insertions(+), 33 deletions(-)


diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 4d9ff0a..07dbd4e 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -223,8 +223,6 @@ Deprecated Mount Options
 
   Name				Removal Schedule
   ----				----------------
-  barrier			no earlier than v4.15
-  nobarrier			no earlier than v4.15
 
 
 Removed Mount Options
@@ -236,6 +234,8 @@ Removed Mount Options
   ihashsize			v4.0
   irixsgid			v4.0
   osyncisdsync/osyncisosync	v4.0
+  barrier			v4.18
+  nobarrier			v4.18
 
 
 sysctls
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 245349d..0f9115c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -216,7 +216,6 @@ struct xfs_error_cfg {
 #define XFS_MOUNT_SMALL_INUMS	(1ULL << 14)	/* user wants 32bit inodes */
 #define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
 #define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
-#define XFS_MOUNT_BARRIER	(1ULL << 17)
 #define XFS_MOUNT_IKEEP		(1ULL << 18)	/* keep empty inode clusters*/
 #define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
 						 * allocation */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9d791f1..03c5677 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -65,11 +65,10 @@ enum {
 	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
 	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
 	Opt_mtpt, Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
-	Opt_allocsize, Opt_norecovery, Opt_barrier, Opt_nobarrier,
-	Opt_inode64, Opt_inode32, Opt_ikeep, Opt_noikeep,
-	Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2, Opt_filestreams,
-	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
-	Opt_uquota, Opt_gquota, Opt_pquota,
+	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
+	Opt_noikeep, Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2,
+	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
+	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
 	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
 };
@@ -118,14 +117,7 @@ enum {
 	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
 	{Opt_discard,	"discard"},	/* Discard unused blocks */
 	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
-
 	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
-
-	/* Deprecated mount options scheduled for removal */
-	{Opt_barrier,	"barrier"},	/* use writer barriers for log write and
-					 * unwritten extent conversion */
-	{Opt_nobarrier,	"nobarrier"},	/* .. disable */
-
 	{Opt_err,	NULL},
 };
 
@@ -209,7 +201,6 @@ enum {
 	 * Set some default flags that could be cleared by the mount option
 	 * parsing.
 	 */
-	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
 
 	/*
@@ -362,14 +353,6 @@ enum {
 			mp->m_flags |= XFS_MOUNT_DAX;
 			break;
 #endif
-		case Opt_barrier:
-			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
-			mp->m_flags |= XFS_MOUNT_BARRIER;
-			break;
-		case Opt_nobarrier:
-			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
-			mp->m_flags &= ~XFS_MOUNT_BARRIER;
-			break;
 		default:
 			xfs_warn(mp, "unknown mount option [%s].", p);
 			return -EINVAL;
@@ -487,7 +470,6 @@ struct proc_xfs_info {
 	static struct proc_xfs_info xfs_info_unset[] = {
 		/* the few simple ones we can get from the mount struct */
 		{ XFS_MOUNT_COMPAT_IOSIZE,	",largeio" },
-		{ XFS_MOUNT_BARRIER,		",nobarrier" },
 		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
 		{ 0, NULL }
 	};
@@ -1278,14 +1260,6 @@ struct proc_xfs_info {
 
 		token = match_token(p, tokens, args);
 		switch (token) {
-		case Opt_barrier:
-			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
-			mp->m_flags |= XFS_MOUNT_BARRIER;
-			break;
-		case Opt_nobarrier:
-			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
-			mp->m_flags &= ~XFS_MOUNT_BARRIER;
-			break;
 		case Opt_inode64:
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);

