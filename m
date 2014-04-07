Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C83077F9C
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 422CDAC013
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LSLu4LFcDbhOCs4H for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 12/19] xfs: remove unused mp arg from
	xfs_calc_dquots_per_chunk()
Date: Mon,  7 Apr 2014 14:58:59 -0500
Message-Id: <1396900746-22201-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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

And because this gets passed to xfs_bmap_local_to_extents()
as *init_fn(), change that prototype too.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_dquot_buf.c  |    5 ++---
 fs/xfs/xfs_qm.c         |    3 +--
 fs/xfs/xfs_quota_defs.h |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot_buf.c b/fs/xfs/xfs_dquot_buf.c
index d401457..a470668 100644
--- a/fs/xfs/xfs_dquot_buf.c
+++ b/fs/xfs/xfs_dquot_buf.c
@@ -35,7 +35,6 @@
 
 int
 xfs_calc_dquots_per_chunk(
-	struct xfs_mount	*mp,
 	unsigned int		nbblks)	/* basic block units */
 {
 	unsigned int	ndquots;
@@ -194,7 +193,7 @@ xfs_dquot_buf_verify_crc(
 	if (mp->m_quotainfo)
 		ndquots = mp->m_quotainfo->qi_dqperchunk;
 	else
-		ndquots = xfs_calc_dquots_per_chunk(mp,
+		ndquots = xfs_calc_dquots_per_chunk(
 					XFS_BB_TO_FSB(mp, bp->b_length));
 
 	for (i = 0; i < ndquots; i++, d++) {
@@ -225,7 +224,7 @@ xfs_dquot_buf_verify(
 	if (mp->m_quotainfo)
 		ndquots = mp->m_quotainfo->qi_dqperchunk;
 	else
-		ndquots = xfs_calc_dquots_per_chunk(mp, bp->b_length);
+		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
 
 	/*
 	 * On the first read of the buffer, verify that each dquot is valid.
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 348e4d2..23cc8dc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -870,8 +870,7 @@ xfs_qm_init_quotainfo(
 
 	/* Precalc some constants */
 	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
-	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(mp,
-							qinf->qi_dqchunklen);
+	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
diff --git a/fs/xfs/xfs_quota_defs.h b/fs/xfs/xfs_quota_defs.h
index b3b2b10..137e209 100644
--- a/fs/xfs/xfs_quota_defs.h
+++ b/fs/xfs/xfs_quota_defs.h
@@ -156,6 +156,6 @@ typedef __uint16_t	xfs_qwarncnt_t;
 
 extern int xfs_dqcheck(struct xfs_mount *mp, xfs_disk_dquot_t *ddq,
 		       xfs_dqid_t id, uint type, uint flags, char *str);
-extern int xfs_calc_dquots_per_chunk(struct xfs_mount *mp, unsigned int nbblks);
+extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 
 #endif	/* __XFS_QUOTA_H__ */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
