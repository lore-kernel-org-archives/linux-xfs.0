Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE8C47F91
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 07:55:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E8AF8F8052
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 05:55:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QWiQ0bMMBSQJsBVB for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 05:55:06 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] repair: fix quota inode handling in secondary superblocks
Date: Tue,  1 Jul 2014 22:54:55 +1000
Message-Id: <1404219296-29302-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1404219296-29302-1-git-send-email-david@fromorbit.com>
References: <1404219296-29302-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Changes to support separate project quota inodes changed the way
quota inodes got written to the superblock. The current code is
tailored for the needs to the kernel, where the inodes should only
be written if certain falgs are set saying a quota type is enabled.

Unfortunately, when recovering a corrupt secondary superblock, we
need to unconditionally write the quota inode fields after we
unconditionally zero the quota flags field. The result of this bug
is that the bad quota inode fields cannot be cleared and hence
always are reported by bad by repair in subsequent runs.

Fix this by directly clearing the quota inodes in the superblock
buffers so that we do need to set special flags to get
xfs_sb_to_disk() to do the right thing as setting flags leave bad
flag values in the superblock instead of bad inode numbers....

Also, when clearing the inode numbers, write them as NULLFSINO
rather than 0 as this is what the kernel will write them as if quota
is turned off.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h    |  1 +
 libxfs/rdwr.c       |  4 ++--
 repair/agheader.c   | 52 ++++++++++++++++++++++++++++++++++------------------
 repair/sb.c         |  2 ++
 repair/scan.c       |  1 +
 repair/xfs_repair.c |  1 +
 6 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 7203d79..45a924f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -759,6 +759,7 @@ bool xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 /* xfs_sb.h */
 #define libxfs_mod_sb			xfs_mod_sb
 #define libxfs_sb_from_disk		xfs_sb_from_disk
+#define libxfs_sb_quota_from_disk	xfs_sb_quota_from_disk
 #define libxfs_sb_to_disk		xfs_sb_to_disk
 
 /* xfs_symlink.h */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 28f8f36..88f84ac 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -907,10 +907,10 @@ libxfs_writebufr(xfs_buf_t *bp)
 	}
 
 #ifdef IO_DEBUG
-	printf("%lx: %s: wrote %u bytes, blkno=%llu(%llu), %p\n",
+	printf("%lx: %s: wrote %u bytes, blkno=%llu(%llu), %p, error %d\n",
 			pthread_self(), __FUNCTION__, bp->b_bcount,
 			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
-			(long long)bp->b_bn, bp);
+			(long long)bp->b_bn, bp, error);
 #endif
 	if (!error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
diff --git a/repair/agheader.c b/repair/agheader.c
index fc5dac9..2b84aab 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -245,13 +245,17 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb)
  * superblocks, not just the secondary superblocks.
  */
 static int
-secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
-	xfs_agnumber_t i)
+secondary_sb_wack(
+	struct xfs_mount *mp,
+	struct xfs_buf	*sbuf,
+	struct xfs_sb	*sb,
+	xfs_agnumber_t	i)
 {
-	int do_bzero;
-	int size;
-	char *ip;
-	int rval;
+	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(sbuf);
+	int		do_bzero = 0;
+	int		size;
+	char		*ip;
+	int		rval = 0;;
 
 	rval = do_bzero = 0;
 
@@ -334,14 +338,22 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 	}
 
 	/*
-	 * quota inodes and flags in secondary superblocks
-	 * are never set by mkfs.  However, they could be set
-	 * in a secondary if a fs with quotas was growfs'ed since
-	 * growfs copies the new primary into the secondaries.
+	 * quota inodes and flags in secondary superblocks are never set by
+	 * mkfs.  However, they could be set in a secondary if a fs with quotas
+	 * was growfs'ed since growfs copies the new primary into the
+	 * secondaries. Also, the kernel now writes the quota inodes when unused
+	 * as NULLFSINO rather than zero, so rewrite the inodes if they are not
+	 * NULLFSINO and inprogress is set.
+	 *
+	 * Finally, the in-core inode flags now have different meaning to the
+	 * on-disk flags, and so libxfs_sb_to_disk cannot directly write the
+	 * sb_gquotino/sb_pquotino fields without specific sb_qflags being set.
+	 * Hence we need to zero it directly in the sb buffer here.
 	 */
-	if (sb->sb_inprogress == 1 && sb->sb_uquotino)  {
+
+	if (sb->sb_inprogress == 1 && sb->sb_uquotino != NULLFSINO)  {
 		if (!no_modify)
-			sb->sb_uquotino = 0;
+			sb->sb_uquotino = NULLFSINO;
 		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
 			rval |= XR_AG_SB;
 			do_warn(
@@ -352,9 +364,11 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 			rval |= XR_AG_SB_SEC;
 	}
 
-	if (sb->sb_inprogress == 1 && sb->sb_gquotino)  {
-		if (!no_modify)
-			sb->sb_gquotino = 0;
+	if (sb->sb_inprogress == 1 && sb->sb_gquotino != NULLFSINO)  {
+		if (!no_modify) {
+			sb->sb_gquotino = NULLFSINO;
+			dsb->sb_gquotino = cpu_to_be64(NULLFSINO);
+		}
 		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
 			rval |= XR_AG_SB;
 			do_warn(
@@ -365,9 +379,11 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 			rval |= XR_AG_SB_SEC;
 	}
 
-	if (sb->sb_inprogress == 1 && sb->sb_pquotino)  {
-		if (!no_modify)
-			sb->sb_pquotino = 0;
+	if (sb->sb_inprogress == 1 && sb->sb_pquotino != NULLFSINO)  {
+		if (!no_modify) {
+			sb->sb_pquotino = NULLFSINO;
+			dsb->sb_pquotino = cpu_to_be64(NULLFSINO);
+		}
 		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
 			rval |= XR_AG_SB;
 			do_warn(
diff --git a/repair/sb.c b/repair/sb.c
index 5e0b0f2..bc421cc 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -138,6 +138,7 @@ find_secondary_sb(xfs_sb_t *rsb)
 		for (i = 0; !done && i < bsize; i += BBSIZE)  {
 			c_bufsb = (char *)sb + i;
 			libxfs_sb_from_disk(&bufsb, (xfs_dsb_t *)c_bufsb);
+			libxfs_sb_quota_from_disk(&bufsb);
 
 			if (verify_sb(c_bufsb, &bufsb, 0) != XR_OK)
 				continue;
@@ -538,6 +539,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
 		do_error("%s\n", strerror(error));
 	}
 	libxfs_sb_from_disk(sbp, buf);
+	libxfs_sb_quota_from_disk(sbp);
 
 	rval = verify_sb((char *)buf, sbp, agno == 0);
 	free(buf);
diff --git a/repair/scan.c b/repair/scan.c
index 1b64d8b..f29ff8d 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1496,6 +1496,7 @@ scan_ag(
 		goto out_free_sb;
 	}
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
+	libxfs_sb_quota_from_disk(sb);
 
 	agfbuf = libxfs_readbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9eb2fa4..8a3e825 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -782,6 +782,7 @@ main(int argc, char **argv)
 	/* make sure the per-ag freespace maps are ok so we can mount the fs */
 	phase2(mp, phase2_threads);
 	timestamp(PHASE_END, 2, NULL);
+	libxfs_bcache_flush();
 
 	if (do_prefetch)
 		init_prefetch(mp);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
