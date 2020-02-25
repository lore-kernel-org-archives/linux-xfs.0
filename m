Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561CEC35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1499520838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XQ0VWx8l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBYANa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:13:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57966 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbgBYANa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:13:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09HEZ033499;
        Tue, 25 Feb 2020 00:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Nd632GIALzk0fdtnKVF28aVJs6Gu8VFIT1/1zltIbZ4=;
 b=XQ0VWx8lCiFif+bZ0PKUQdU3AFMdr9y4WY6vTE8RmSfjNVdfa7zh8vWUC5jScHez2d/k
 v12N4wd9wZjJLveRwzPALpi83YlEw8YGWB4W2UdE9OBYWf3sw7deOjXc06OxuxqkAm5D
 ePDWemmLAUBAEfqvxNNl/vzI1di6Jo9dWOL0wRmv0PfHh9RiBUY4aBtEKm4Ah/baAMfY
 zoAwRMRwk8/W6Rwp6TXnZ+qz2Z5/mpvFvx4XWExLNL3ZkLcp6zKrKPHY9frg0F91zxMx
 CESNrW/VG9K2X1KTXi4G7VIKVWTAcUKqZdvRh6EnaPfpml3hk380SWuUqG3FiI+35z+J Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ycppr8gsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P06YSu098267;
        Tue, 25 Feb 2020 00:13:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ybduvg0ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:26 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0DPeR031549;
        Tue, 25 Feb 2020 00:13:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:13:25 -0800
Subject: [PATCH 18/25] libxfs: remove unused flags parameter to
 libxfs_buf_mark_dirty
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:13:23 -0800
Message-ID: <158258960303.451378.10926259135197727277.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=2 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Nobody uses the flags parameter, so get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h   |    8 ++++----
 libxfs/rdwr.c        |   14 ++++++--------
 libxfs/trans.c       |    2 +-
 mkfs/proto.c         |    2 +-
 mkfs/xfs_mkfs.c      |   14 +++++++-------
 repair/attr_repair.c |    6 +++---
 repair/da_util.c     |    4 ++--
 repair/dino_chunks.c |    3 +--
 repair/dinode.c      |    4 ++--
 repair/dir2.c        |    6 +++---
 repair/phase3.c      |    2 +-
 repair/phase5.c      |   28 ++++++++++++++--------------
 repair/rmap.c        |    2 +-
 repair/scan.c        |    8 ++++----
 repair/xfs_repair.c  |    2 +-
 15 files changed, 51 insertions(+), 54 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 51b1dc15..78ce989c 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -136,9 +136,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_readbuf_map(dev, map, nmaps, flags, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags), (ops))
-#define libxfs_buf_mark_dirty(buf, flags) \
+#define libxfs_buf_mark_dirty(buf) \
 	libxfs_trace_dirtybuf(__FUNCTION__, __FILE__, __LINE__, \
-			      (buf), (flags))
+			      (buf))
 #define libxfs_buf_get(dev, daddr, len) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len))
@@ -158,7 +158,7 @@ extern xfs_buf_t *libxfs_trace_readbuf_map(const char *, const char *, int,
 			struct xfs_buftarg *, struct xfs_buf_map *, int, int,
 			const struct xfs_buf_ops *);
 void libxfs_trace_dirtybuf(const char *func, const char *file, int line,
-			struct xfs_buf *bp, int flags);
+			struct xfs_buf *bp);
 struct xfs_buf *libxfs_trace_getbuf(const char *func, const char *file,
 			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
 			size_t len);
@@ -173,7 +173,7 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 
 extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
-void libxfs_buf_mark_dirty(struct xfs_buf *bp, int flags);
+void libxfs_buf_mark_dirty(struct xfs_buf *bp);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
 extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 16701bba..34693725 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -194,11 +194,10 @@ libxfs_trace_dirtybuf(
 	const char		*func,
 	const char		*file,
 	int			line,
-	struct xfs_buf		*bp,
-	int			flags)
+	struct xfs_buf		*bp)
 {
 	__add_trace(bp, func, file, line);
-	libxfs_buf_mark_dirty(bp, flags);
+	libxfs_buf_mark_dirty(bp);
 }
 
 struct xfs_buf *
@@ -999,8 +998,7 @@ libxfs_writebuf_int(xfs_buf_t *bp, int flags)
  */
 void
 libxfs_buf_mark_dirty(
-	struct xfs_buf	*bp,
-	int		flags)
+	struct xfs_buf	*bp)
 {
 #ifdef IO_DEBUG
 	printf("%lx: %s: dirty blkno=%llu(%llu)\n",
@@ -1014,7 +1012,7 @@ libxfs_buf_mark_dirty(
 	 */
 	bp->b_error = 0;
 	bp->b_flags &= ~LIBXFS_B_STALE;
-	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
+	bp->b_flags |= LIBXFS_B_DIRTY;
 }
 
 void
@@ -1416,7 +1414,7 @@ libxfs_log_clear(
 	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
 			  next, bp);
 	if (bp) {
-		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_mark_dirty(bp);
 		libxfs_buf_relse(bp);
 	}
 
@@ -1468,7 +1466,7 @@ libxfs_log_clear(
 		libxfs_log_header(ptr, fs_uuid, version, BBTOB(len), fmt, lsn,
 				  tail_lsn, next, bp);
 		if (bp) {
-			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_mark_dirty(bp);
 			libxfs_buf_relse(bp);
 		}
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 91001a93..ca1166ed 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -843,7 +843,7 @@ inode_item_done(
 		goto free;
 	}
 
-	libxfs_buf_mark_dirty(bp, 0);
+	libxfs_buf_mark_dirty(bp);
 	libxfs_buf_relse(bp);
 free:
 	xfs_inode_item_put(iip);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 7de76ca4..26a613fe 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -262,7 +262,7 @@ newfile(
 		if (logit)
 			libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
 		else {
-			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_mark_dirty(bp);
 			libxfs_buf_relse(bp);
 		}
 	}
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 75a90f3a..295deb86 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3462,7 +3462,7 @@ prepare_devices(
 	buf = alloc_write_buf(mp->m_ddev_targp, (xi->dsize - whack_blks),
 			whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
 	/*
@@ -3473,7 +3473,7 @@ prepare_devices(
 	 */
 	buf = alloc_write_buf(mp->m_ddev_targp, 0, whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
 	/* OK, now write the superblock... */
@@ -3482,7 +3482,7 @@ prepare_devices(
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
-	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
 	/* ...and zero the log.... */
@@ -3502,7 +3502,7 @@ prepare_devices(
 				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				BTOBB(cfg->blocksize));
 		memset(buf->b_addr, 0, cfg->blocksize);
-		libxfs_buf_mark_dirty(buf, 0);
+		libxfs_buf_mark_dirty(buf);
 		libxfs_buf_relse(buf);
 	}
 
@@ -3599,7 +3599,7 @@ rewrite_secondary_superblocks(
 		exit(1);
 	}
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
 	/* and one in the middle for luck if there's enough AGs for that */
@@ -3616,7 +3616,7 @@ rewrite_secondary_superblocks(
 		exit(1);
 	}
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 }
 
@@ -3964,7 +3964,7 @@ main(
 	if (!buf || buf->b_error)
 		exit(1);
 	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
-	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
 	/* Report failure if anything failed to get written to our new fs. */
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 476998eb..3cef3004 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -836,7 +836,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 			repair++;
 
 		if (repair && !no_modify) {
-			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_mark_dirty(bp);
 			libxfs_buf_relse(bp);
 		}
 		else
@@ -1001,7 +1001,7 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
 	*repair = *repair || repairlinks;
 
 	if (*repair && !no_modify)
-		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_mark_dirty(bp);
 	libxfs_buf_relse(bp);
 
 	return 0;
@@ -1044,7 +1044,7 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
 	/* must do this now, to release block 0 before the traversal */
 	if ((*repair || repairlinks) && !no_modify) {
 		*repair = 1;
-		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_mark_dirty(bp);
 	}
 	libxfs_buf_relse(bp);
 	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
diff --git a/repair/da_util.c b/repair/da_util.c
index 6a0e28a3..dc1e5bfe 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -404,7 +404,7 @@ _("would correct bad hashval in non-leaf %s block\n"
 		(cursor->level[this_level].dirty && !no_modify));
 
 	if (cursor->level[this_level].dirty && !no_modify) {
-		libxfs_buf_mark_dirty(cursor->level[this_level].bp, 0);
+		libxfs_buf_mark_dirty(cursor->level[this_level].bp);
 		libxfs_buf_relse(cursor->level[this_level].bp);
 	}
 	else
@@ -622,7 +622,7 @@ _("bad level %d in %s block %u for inode %" PRIu64 "\n"),
 			cursor->level[this_level].dirty = 1;
 
 		if (cursor->level[this_level].dirty && !no_modify) {
-			libxfs_buf_mark_dirty(cursor->level[this_level].bp, 0);
+			libxfs_buf_mark_dirty(cursor->level[this_level].bp);
 			libxfs_buf_relse(cursor->level[this_level].bp);
 		}
 		else
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 5b6f7fca..b2ed1112 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -940,8 +940,7 @@ process_inode_chunk(
 					XFS_BUF_ADDR(bplist[bp_index]), agno);
 
 				if (dirty && !no_modify) {
-					libxfs_buf_mark_dirty(bplist[bp_index],
-							0);
+					libxfs_buf_mark_dirty(bplist[bp_index]);
 					libxfs_buf_relse(bplist[bp_index]);
 				}
 				else
diff --git a/repair/dinode.c b/repair/dinode.c
index 39210f27..08521ac8 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1232,7 +1232,7 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
 		}
 
 		if (writebuf && !no_modify) {
-			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_mark_dirty(bp);
 			libxfs_buf_relse(bp);
 		}
 		else
@@ -1331,7 +1331,7 @@ _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n")
 		i++;
 
 		if (badcrc && !no_modify) {
-			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_mark_dirty(bp);
 			libxfs_buf_relse(bp);
 		}
 		else
diff --git a/repair/dir2.c b/repair/dir2.c
index 1384011b..cbbce601 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1010,7 +1010,7 @@ _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n
 		dirty = 1;
 	if (dirty && !no_modify) {
 		*repair = 1;
-		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_mark_dirty(bp);
 		libxfs_buf_relse(bp);
 	} else
 		libxfs_buf_relse(bp);
@@ -1181,7 +1181,7 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 		ASSERT(buf_dirty == 0 || (buf_dirty && !no_modify));
 		if (buf_dirty && !no_modify) {
 			*repair = 1;
-			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_mark_dirty(bp);
 			libxfs_buf_relse(bp);
 		} else
 			libxfs_buf_relse(bp);
@@ -1341,7 +1341,7 @@ _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" P
 		}
 		if (dirty && !no_modify) {
 			*repair = 1;
-			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_mark_dirty(bp);
 			libxfs_buf_relse(bp);
 		} else
 			libxfs_buf_relse(bp);
diff --git a/repair/phase3.c b/repair/phase3.c
index 4e7fe964..79dc65f8 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -47,7 +47,7 @@ process_agi_unlinked(
 	}
 
 	if (agi_dirty) {
-		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_mark_dirty(bp);
 		libxfs_buf_relse(bp);
 	}
 	else
diff --git a/repair/phase5.c b/repair/phase5.c
index e31dedca..7ec58f88 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -321,10 +321,10 @@ write_cursor(bt_status_t *curs)
 			fprintf(stderr, "writing bt prev block %u\n",
 						curs->level[i].prev_agbno);
 #endif
-			libxfs_buf_mark_dirty(curs->level[i].prev_buf_p, 0);
+			libxfs_buf_mark_dirty(curs->level[i].prev_buf_p);
 			libxfs_buf_relse(curs->level[i].prev_buf_p);
 		}
-		libxfs_buf_mark_dirty(curs->level[i].buf_p, 0);
+		libxfs_buf_mark_dirty(curs->level[i].buf_p);
 		libxfs_buf_relse(curs->level[i].buf_p);
 	}
 }
@@ -683,7 +683,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK) {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_mark_dirty(lptr->prev_buf_p);
 			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;;
@@ -873,7 +873,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_mark_dirty(lptr->prev_buf_p);
 				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
@@ -1050,7 +1050,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_mark_dirty(lptr->prev_buf_p);
 			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;;
@@ -1142,7 +1142,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		agi->agi_free_level = cpu_to_be32(finobt_curs->num_levels);
 	}
 
-	libxfs_buf_mark_dirty(agi_buf, 0);
+	libxfs_buf_mark_dirty(agi_buf);
 	libxfs_buf_relse(agi_buf);
 }
 
@@ -1305,7 +1305,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_mark_dirty(lptr->prev_buf_p);
 				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
@@ -1458,7 +1458,7 @@ prop_rmap_cursor(
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_mark_dirty(lptr->prev_buf_p);
 			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;
@@ -1669,7 +1669,7 @@ _("Insufficient memory to construct reverse-map cursor."));
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_mark_dirty(lptr->prev_buf_p);
 				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
@@ -1810,7 +1810,7 @@ prop_refc_cursor(
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_mark_dirty(lptr->prev_buf_p);
 			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;
@@ -1964,7 +1964,7 @@ _("Insufficient memory to construct refcount cursor."));
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_mark_dirty(lptr->prev_buf_p);
 				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
@@ -2153,7 +2153,7 @@ _("Insufficient memory saving lost blocks.\n"));
 		agf->agf_flcount = 0;
 	}
 
-	libxfs_buf_mark_dirty(agfl_buf, 0);
+	libxfs_buf_mark_dirty(agfl_buf);
 	libxfs_buf_relse(agfl_buf);
 
 	ext_ptr = findbiggest_bcnt_extent(agno);
@@ -2167,7 +2167,7 @@ _("Insufficient memory saving lost blocks.\n"));
 	ASSERT(be32_to_cpu(agf->agf_refcount_root) !=
 		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
 
-	libxfs_buf_mark_dirty(agf_buf, 0);
+	libxfs_buf_mark_dirty(agf_buf);
 	libxfs_buf_relse(agf_buf);
 
 	/*
@@ -2202,7 +2202,7 @@ sync_sb(xfs_mount_t *mp)
 	update_sb_version(mp);
 
 	libxfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
-	libxfs_buf_mark_dirty(bp, 0);
+	libxfs_buf_mark_dirty(bp);
 	libxfs_buf_relse(bp);
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index b0b9874e..a37efbe7 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1231,7 +1231,7 @@ _("setting reflink flag on inode %"PRIu64"\n"),
 	else
 		dino->di_flags2 &= cpu_to_be64(~XFS_DIFLAG2_REFLINK);
 	libxfs_dinode_calc_crc(mp, dino);
-	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
 	return 0;
diff --git a/repair/scan.c b/repair/scan.c
index 00c25bed..66b596db 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -152,7 +152,7 @@ scan_lbtree(
 	ASSERT(dirty == 0 || (dirty && !no_modify));
 
 	if ((dirty || badcrc) && !no_modify) {
-		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_mark_dirty(bp);
 		libxfs_buf_relse(bp);
 	}
 	else
@@ -2432,14 +2432,14 @@ scan_ag(
 	}
 
 	if (agi_dirty && !no_modify) {
-		libxfs_buf_mark_dirty(agibuf, 0);
+		libxfs_buf_mark_dirty(agibuf);
 		libxfs_buf_relse(agibuf);
 	}
 	else
 		libxfs_buf_relse(agibuf);
 
 	if (agf_dirty && !no_modify) {
-		libxfs_buf_mark_dirty(agfbuf, 0);
+		libxfs_buf_mark_dirty(agfbuf);
 		libxfs_buf_relse(agfbuf);
 	}
 	else
@@ -2449,7 +2449,7 @@ scan_ag(
 		if (agno == 0)
 			memcpy(&mp->m_sb, sb, sizeof(xfs_sb_t));
 		libxfs_sb_to_disk(XFS_BUF_TO_SBP(sbbuf), sb);
-		libxfs_buf_mark_dirty(sbbuf, 0);
+		libxfs_buf_mark_dirty(sbbuf);
 		libxfs_buf_relse(sbbuf);
 	} else
 		libxfs_buf_relse(sbbuf);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index c0b48407..425c6751 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1096,7 +1096,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
 	}
 
-	libxfs_buf_mark_dirty(sbp, 0);
+	libxfs_buf_mark_dirty(sbp);
 	libxfs_buf_relse(sbp);
 
 	/*

