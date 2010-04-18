Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3I091Gd096544 for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 19:09:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CC741DD6C6D
	for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:10:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZB2RfpxwubjnsYGJ for
	<xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:10:59 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O3I6E-0006s4-Vb
	for xfs@oss.sgi.com; Sun, 18 Apr 2010 00:10:59 +0000
Message-Id: <20100418001058.868700157@bombadil.infradead.org>
Date: Sat, 17 Apr 2010 20:10:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: remove dead XFS_LOUD_RECOVERY code
References: <20100418001041.865247520@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_LOUD_RECOVERY
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This can't be enabled through the build system and has been dead for
ages.  Note that the CRC patches add back log checksumming, but the
code is quite different from the version removed here anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-04-17 12:53:53.000000000 -0700
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-04-17 13:01:59.737026060 -0700
@@ -1331,9 +1331,6 @@ xfs_qm_qino_alloc(
 	 */
 	spin_lock(&mp->m_sb_lock);
 	if (flags & XFS_QMOPT_SBVERSION) {
-#if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
-		unsigned oldv = mp->m_sb.sb_versionnum;
-#endif
 		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
 		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
 				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
@@ -1346,11 +1343,6 @@ xfs_qm_qino_alloc(
 
 		/* qflags will get updated _after_ quotacheck */
 		mp->m_sb.sb_qflags = 0;
-#if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
-		cmn_err(CE_NOTE,
-			"Old superblock version %x, converting to %x.",
-			oldv, mp->m_sb.sb_versionnum);
-#endif
 	}
 	if (flags & XFS_QMOPT_UQUOTA)
 		mp->m_sb.sb_uquotino = (*ip)->i_ino;
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-04-17 12:52:10.542003500 -0700
+++ xfs/fs/xfs/xfs_log_recover.c	2010-04-17 13:03:11.364005944 -0700
@@ -3394,42 +3394,6 @@ xlog_pack_data(
 	}
 }
 
-#if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
-STATIC void
-xlog_unpack_data_checksum(
-	xlog_rec_header_t	*rhead,
-	xfs_caddr_t		dp,
-	xlog_t			*log)
-{
-	__be32			*up = (__be32 *)dp;
-	uint			chksum = 0;
-	int			i;
-
-	/* divide length by 4 to get # words */
-	for (i=0; i < be32_to_cpu(rhead->h_len) >> 2; i++) {
-		chksum ^= be32_to_cpu(*up);
-		up++;
-	}
-	if (chksum != be32_to_cpu(rhead->h_chksum)) {
-	    if (rhead->h_chksum ||
-		((log->l_flags & XLOG_CHKSUM_MISMATCH) == 0)) {
-		    cmn_err(CE_DEBUG,
-			"XFS: LogR chksum mismatch: was (0x%x) is (0x%x)\n",
-			    be32_to_cpu(rhead->h_chksum), chksum);
-		    cmn_err(CE_DEBUG,
-"XFS: Disregard message if filesystem was created with non-DEBUG kernel");
-		    if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-			    cmn_err(CE_DEBUG,
-				"XFS: LogR this is a LogV2 filesystem\n");
-		    }
-		    log->l_flags |= XLOG_CHKSUM_MISMATCH;
-	    }
-	}
-}
-#else
-#define xlog_unpack_data_checksum(rhead, dp, log)
-#endif
-
 STATIC void
 xlog_unpack_data(
 	xlog_rec_header_t	*rhead,
@@ -3453,8 +3417,6 @@ xlog_unpack_data(
 			dp += BBSIZE;
 		}
 	}
-
-	xlog_unpack_data_checksum(rhead, dp, log);
 }
 
 STATIC int
@@ -4009,10 +3971,6 @@ xlog_recover_check_summary(
 	xfs_agf_t	*agfp;
 	xfs_buf_t	*agfbp;
 	xfs_buf_t	*agibp;
-	xfs_buf_t	*sbbp;
-#ifdef XFS_LOUD_RECOVERY
-	xfs_sb_t	*sbp;
-#endif
 	xfs_agnumber_t	agno;
 	__uint64_t	freeblks;
 	__uint64_t	itotal;
@@ -4047,30 +4005,5 @@ xlog_recover_check_summary(
 			xfs_buf_relse(agibp);
 		}
 	}
-
-	sbbp = xfs_getsb(mp, 0);
-#ifdef XFS_LOUD_RECOVERY
-	sbp = &mp->m_sb;
-	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(sbbp));
-	cmn_err(CE_NOTE,
-		"xlog_recover_check_summary: sb_icount %Lu itotal %Lu",
-		sbp->sb_icount, itotal);
-	cmn_err(CE_NOTE,
-		"xlog_recover_check_summary: sb_ifree %Lu itotal %Lu",
-		sbp->sb_ifree, ifree);
-	cmn_err(CE_NOTE,
-		"xlog_recover_check_summary: sb_fdblocks %Lu freeblks %Lu",
-		sbp->sb_fdblocks, freeblks);
-#if 0
-	/*
-	 * This is turned off until I account for the allocation
-	 * btree blocks which live in free space.
-	 */
-	ASSERT(sbp->sb_icount == itotal);
-	ASSERT(sbp->sb_ifree == ifree);
-	ASSERT(sbp->sb_fdblocks == freeblks);
-#endif
-#endif
-	xfs_buf_relse(sbbp);
 }
 #endif /* DEBUG */
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-04-05 11:20:53.729004459 -0700
+++ xfs/fs/xfs/xfs_mount.c	2010-04-17 12:57:13.128256327 -0700
@@ -1405,13 +1405,6 @@ xfs_mountfs(
 		xfs_qm_mount_quotas(mp);
 	}
 
-#if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
-	if (XFS_IS_QUOTA_ON(mp))
-		xfs_fs_cmn_err(CE_NOTE, mp, "Disk quotas turned on");
-	else
-		xfs_fs_cmn_err(CE_NOTE, mp, "Disk quotas not turned on");
-#endif
-
 	/*
 	 * Now we are mounted, reserve a small amount of unused space for
 	 * privileged transactions. This is needed so that transaction

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
