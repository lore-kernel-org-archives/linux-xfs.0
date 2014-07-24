Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63BA07F61
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 18:29:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2298F304067
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 16:29:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VYprz4UzwMWDOX1K for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 16:29:34 -0700 (PDT)
Message-ID: <53D196DE.4060602@sandeen.net>
Date: Thu, 24 Jul 2014 18:29:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: avoid false quotacheck after unclean shutdown
References: <53CE6415.8080607@excellency.fr> <53CE9AF6.3090401@sandeen.net>
In-Reply-To: <53CE9AF6.3090401@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: cbay@excellency.fr, xfs@oss.sgi.com

The commit

83e782e xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD

added a new function xfs_sb_quota_from_disk() which swaps
on-disk XFS_OQUOTA_* flags for in-core XFS_GQUOTA_* and XFS_PQUOTA_*
flags after the superblock is read.

However, if log recovery is required, the superblock is read again,
and the modified in-core flags are re-read from disk, so we have
XFS_OQUOTA_* flags in memory again.  This causes the 
XFS_QM_NEED_QUOTACHECK() test to be true, because the XFS_OQUOTA_CHKD
is still set, and not XFS_GQUOTA_CHKD or XFS_PQUOTA_CHKD.

Change xfs_sb_from_disk to call xfs_sb_quota_from disk and always
convert the disk flags to in-memory flags.

Add a lower-level function which can be called with "false" to
not convert the flags, so that the sb verifier can verify
exactly what was on disk, per Brian Foster's suggestion.

Reported-by: Cyril B. <cbay@excellency.fr>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Call xfs_sb_quota_from_disk from xfs_sb_from_disk,
unless we're the verifier, which wants to see what is
actually on-disk to verify it.  Thanks Brian!


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3507cd0..16d1671 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -324,7 +324,6 @@ reread:
 	 * Initialize the mount structure from the superblock.
 	 */
 	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
-	xfs_sb_quota_from_disk(sbp);
 
 	/*
 	 * If we haven't validated the superblock, do so now before we try
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 7703fa6..0f631d2 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -386,10 +386,11 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	}
 }
 
-void
-xfs_sb_from_disk(
+static void
+__xfs_sb_from_disk(
 	struct xfs_sb	*to,
-	xfs_dsb_t	*from)
+	xfs_dsb_t	*from,
+	bool		convert_xquota)
 {
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
 	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
@@ -445,6 +446,17 @@ xfs_sb_from_disk(
 	to->sb_pad = 0;
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
+	/* Convert on-disk flags to in-memory flags? */
+	if (convert_xquota)
+		xfs_sb_quota_from_disk(to);
+}
+
+void
+xfs_sb_from_disk(
+	struct xfs_sb	*to,
+	xfs_dsb_t	*from)
+{
+	__xfs_sb_from_disk(to, from, true);
 }
 
 static inline void
@@ -577,7 +589,11 @@ xfs_sb_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
 
-	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+	/*
+	 * Use call variant which doesn't convert quota flags from disk 
+	 * format, because xfs_mount_validate_sb checks the on-disk flags.
+	 */
+	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
 
 	/*
 	 * Only check the in progress field for the primary superblock as


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
