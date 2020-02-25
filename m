Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C3FC35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CF6121D7E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ohy2oeP6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYAMC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:12:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59696 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:12:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08lKb130038;
        Tue, 25 Feb 2020 00:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=h569/jsMd9Xab8+xplmPO+/MVtezCXw+2am8/GLWZRg=;
 b=ohy2oeP6Bw3V3Hr+H4Smomzm0J582h1evH1L0UMnclLpdG61Emfo1RfORnKYNb58avA1
 dogKlpzUZqo65037vB3e7Jf7OFIYbAE9xpN9LftrAizWEoFpwkJEwCHZhVQFzSD3qeY9
 IEgpiZ21ug/NVCaV9nzMZ9/VXQt5WePOqLP3PiofjnkJ8lb6+pUl2v5+gttMhIqI/hdf
 Ialjw1bp2sntI1q4Re4cDhwQVl1it9fKkhIqKvkDxoUKy6VKh2Jc/qbQg9fB8BW27Ccm
 cUmDaxLQvYCTfC/BmspiJBdNWiL0TymWNmlxonPgQtDb6iB5jxJHqFG7tuSfe1QXDliX bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxrjrr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08822014518;
        Tue, 25 Feb 2020 00:11:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ybdshxx4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0BtFc031057;
        Tue, 25 Feb 2020 00:11:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:11:55 -0800
Subject: [PATCH 04/25] libxfs: replace libxfs_putbuf with libxfs_buf_relse
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:11:54 -0800
Message-ID: <158258951441.451378.363142934586674122.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=2 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change all the libxfs_putbuf calls to libxfs_buf_relse to match the
kernel interface, since one is a #define of the other.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c          |    4 ++--
 db/fsmap.c               |    6 +++---
 db/info.c                |    2 +-
 db/init.c                |    2 +-
 db/io.c                  |    2 +-
 libxfs/init.c            |    8 ++++----
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_io.h       |    4 ++--
 libxfs/libxfs_priv.h     |    1 -
 libxfs/rdwr.c            |   14 +++++++-------
 libxfs/trans.c           |   10 +++++-----
 repair/attr_repair.c     |   24 ++++++++++++------------
 repair/da_util.c         |   22 +++++++++++-----------
 repair/dino_chunks.c     |    8 ++++----
 repair/dinode.c          |    8 ++++----
 repair/dir2.c            |   14 +++++++-------
 repair/phase3.c          |    2 +-
 repair/phase6.c          |   36 ++++++++++++++++++------------------
 repair/prefetch.c        |   10 +++++-----
 repair/rmap.c            |    8 ++++----
 repair/rt.c              |    4 ++--
 repair/scan.c            |   18 +++++++++---------
 repair/xfs_repair.c      |    2 +-
 23 files changed, 105 insertions(+), 105 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 7f4615ac..3e519471 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -716,12 +716,12 @@ main(int argc, char **argv)
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 
 	/* Do it again, now with proper length and verifier */
-	libxfs_putbuf(sbp);
+	libxfs_buf_relse(sbp);
 	libxfs_purgebuf(sbp);
 	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			     1 << (sb->sb_sectlog - BBSHIFT),
 			     0, &xfs_sb_buf_ops);
-	libxfs_putbuf(sbp);
+	libxfs_buf_relse(sbp);
 
 	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
 	if (mp == NULL) {
diff --git a/db/fsmap.c b/db/fsmap.c
index 29f3827c..a6e61962 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -75,7 +75,7 @@ fsmap(
 
 		bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
 		if (!bt_cur) {
-			libxfs_putbuf(agbp);
+			libxfs_buf_relse(agbp);
 			dbprintf(_("Not enough memory.\n"));
 			return;
 		}
@@ -85,14 +85,14 @@ fsmap(
 				fsmap_fn, &info);
 		if (error) {
 			libxfs_btree_del_cursor(bt_cur, XFS_BTREE_ERROR);
-			libxfs_putbuf(agbp);
+			libxfs_buf_relse(agbp);
 			dbprintf(_("Error %d while querying fsmap btree.\n"),
 				error);
 			return;
 		}
 
 		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
-		libxfs_putbuf(agbp);
+		libxfs_buf_relse(agbp);
 
 		if (agno == start_ag)
 			low.rm_startblock = 0;
diff --git a/db/info.c b/db/info.c
index fc5ccfe7..5c941dc4 100644
--- a/db/info.c
+++ b/db/info.c
@@ -89,7 +89,7 @@ print_agresv_info(
 	length = be32_to_cpu(agf->agf_length);
 	free = be32_to_cpu(agf->agf_freeblks) +
 	       be32_to_cpu(agf->agf_flcount);
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 
 	printf("AG %d: length: %u free: %u reserved: %u used: %u",
 			agno, length, free, ask, used);
diff --git a/db/init.c b/db/init.c
index e5450d2b..15b4ec0c 100644
--- a/db/init.c
+++ b/db/init.c
@@ -123,7 +123,7 @@ init(
 
 	/* copy SB from buffer to in-core, converting architecture as we go */
 	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 	libxfs_purgebuf(bp);
 
 	sbp = &xmount.m_sb;
diff --git a/db/io.c b/db/io.c
index 6b66472e..a11b7bb1 100644
--- a/db/io.c
+++ b/db/io.c
@@ -96,7 +96,7 @@ pop_cur(void)
 		return;
 	}
 	if (iocur_top->bp) {
-		libxfs_putbuf(iocur_top->bp);
+		libxfs_buf_relse(iocur_top->bp);
 		iocur_top->bp = NULL;
 	}
 	if (iocur_top->bbmap) {
diff --git a/libxfs/init.c b/libxfs/init.c
index 485ab8f8..4efe1099 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -457,7 +457,7 @@ rtmount_init(
 			progname);
 		return -1;
 	}
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 	return 0;
 }
 
@@ -737,7 +737,7 @@ libxfs_mount(
 		if (!debugger)
 			return NULL;
 	} else
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 
 	if (mp->m_logdev_targp->dev &&
 	    mp->m_logdev_targp->dev != mp->m_ddev_targp->dev) {
@@ -752,7 +752,7 @@ libxfs_mount(
 				return NULL;
 		}
 		if (bp)
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 	}
 
 	/* Initialize realtime fields in the mount structure */
@@ -782,7 +782,7 @@ libxfs_mount(
 								progname);
 			sbp->sb_agcount = 1;
 		}
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 	}
 
 	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1a438e58..8bca7ddf 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -44,6 +44,7 @@
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
+#define xfs_buf_relse			libxfs_buf_relse
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 716db553..3ddfc0c8 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -148,7 +148,7 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_getbuf_flags(dev, daddr, len, flags) \
 	libxfs_trace_getbuf_flags(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len), (flags))
-#define libxfs_putbuf(buf) \
+#define libxfs_buf_relse(buf) \
 	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
 extern xfs_buf_t *libxfs_trace_readbuf(const char *, const char *, int,
@@ -180,7 +180,7 @@ extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
 extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
 			int, unsigned int);
-extern void	libxfs_putbuf (xfs_buf_t *);
+void	libxfs_buf_relse(struct xfs_buf *bp);
 
 #endif
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index fe08f96b..4bd3c462 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -377,7 +377,6 @@ roundup_64(uint64_t x, uint32_t y)
 	(len) = __bar; /* no set-but-unused warning */	\
 	NULL;						\
 })
-#define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
 #define xfs_buf_oneshot(bp)		((void) 0)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 45b535e4..02e19e1c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -48,7 +48,7 @@
  *
  * The result of this is that until the userspace code outside libxfs is cleaned
  * up, functions that release buffers from userspace control (i.e
- * libxfs_writebuf/libxfs_putbuf) need to zero bp->b_error to prevent
+ * libxfs_writebuf/libxfs_buf_relse) need to zero bp->b_error to prevent
  * propagation of stale errors into future buffer operations.
  */
 
@@ -387,7 +387,6 @@ libxfs_log_header(
 #undef libxfs_getbuf
 #undef libxfs_getbuf_map
 #undef libxfs_getbuf_flags
-#undef libxfs_putbuf
 
 xfs_buf_t	*libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
 				const struct xfs_buf_ops *);
@@ -399,7 +398,7 @@ xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int);
 xfs_buf_t	*libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t, int,
 				unsigned int);
-void		libxfs_putbuf (xfs_buf_t *);
+void		libxfs_buf_relse(struct xfs_buf *bp);
 
 #define	__add_trace(bp, func, file, line)	\
 do {						\
@@ -469,7 +468,7 @@ void
 libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
 {
 	__add_trace(bp, func, file, line);
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 }
 
 
@@ -844,7 +843,8 @@ libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 }
 
 void
-libxfs_putbuf(xfs_buf_t *bp)
+libxfs_buf_relse(
+	struct xfs_buf	*bp)
 {
 	/*
 	 * ensure that any errors on this use of the buffer don't carry
@@ -1183,7 +1183,7 @@ libxfs_writebuf(xfs_buf_t *bp, int flags)
 	bp->b_error = 0;
 	bp->b_flags &= ~LIBXFS_B_STALE;
 	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 	return 0;
 }
 
@@ -1520,7 +1520,7 @@ xfs_buf_delwri_submit(
 		error2 = libxfs_writebufr(bp);
 		if (!error)
 			error = error2;
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 	}
 
 	return error;
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 18b87d70..59cb897f 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -566,7 +566,7 @@ libxfs_trans_brelse(
 	ASSERT(bp->b_transp == tp);
 
 	if (!tp) {
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		return;
 	}
 
@@ -602,7 +602,7 @@ libxfs_trans_brelse(
 	xfs_buf_item_put(bip);
 
 	bp->b_transp = NULL;
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 }
 
 /*
@@ -839,7 +839,7 @@ inode_item_done(
 	if (error) {
 		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
 			progname, error);
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		goto free;
 	}
 
@@ -868,7 +868,7 @@ buf_item_done(
 	xfs_buf_item_put(bip);
 	if (hold)
 		return;
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 }
 
 static void
@@ -906,7 +906,7 @@ buf_item_unlock(
 	bip->bli_flags &= ~XFS_BLI_HOLD;
 	xfs_buf_item_put(bip);
 	if (!hold)
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 }
 
 static void
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 535fcfbb..ec068ba2 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -418,7 +418,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
 			do_warn(
 	_("Corrupt remote block for attributes of inode %" PRIu64 "\n"), ino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			clearit = 1;
 			break;
 		}
@@ -430,7 +430,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 		amountdone += length;
 		value += length;
 		i++;
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 	}
 	return (clearit);
 }
@@ -782,7 +782,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 			do_warn(
 	_("bad attribute leaf magic %#x for inode %" PRIu64 "\n"),
 				 leafhdr.magic, ino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			goto error_out;
 		}
 
@@ -793,7 +793,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		if (process_leaf_attr_block(mp, leaf, da_bno, ino,
 				da_cursor->blkmap, current_hashval,
 				&greatest_hashval, &repair))  {
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			goto error_out;
 		}
 
@@ -813,7 +813,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 			do_warn(
 	_("bad sibling back pointer for block %u in attribute fork for inode %" PRIu64 "\n"),
 				da_bno, ino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			goto error_out;
 		}
 
@@ -822,7 +822,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 
 		if (da_bno != 0) {
 			if (verify_da_path(mp, da_cursor, 0, XFS_ATTR_FORK)) {
-				libxfs_putbuf(bp);
+				libxfs_buf_relse(bp);
 				goto error_out;
 			}
 		}
@@ -838,7 +838,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		if (repair && !no_modify)
 			libxfs_writebuf(bp, 0);
 		else
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 	} while (da_bno != 0);
 
 	if (verify_final_da_path(mp, da_cursor, 0, XFS_ATTR_FORK))  {
@@ -992,7 +992,7 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
 	if (badness) {
 		*repair = 0;
 		/* the block is bad.  lose the attribute fork. */
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		return 1;
 	}
 
@@ -1001,7 +1001,7 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
 	if (*repair && !no_modify)
 		libxfs_writebuf(bp, 0);
 	else
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 
 	return 0;
 }
@@ -1045,7 +1045,7 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
 		*repair = 1;
 		libxfs_writebuf(bp, 0);
 	} else
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
 	if (error)
 		*repair = 0;
@@ -1107,7 +1107,7 @@ process_longform_attr(
 	/* is this block sane? */
 	if (__check_attr_header(mp, bp, ino)) {
 		*repair = 0;
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		return 1;
 	}
 
@@ -1130,7 +1130,7 @@ process_longform_attr(
 		do_warn(
 	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
 			be16_to_cpu(info->magic), ino);
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		*repair = 0;
 		return 1;
 	}
diff --git a/repair/da_util.c b/repair/da_util.c
index bf25f7f2..c02d621c 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -145,7 +145,7 @@ _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
 					da_cursor->ino, bno);
 			}
 			*rbno = 0;
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			return 1;
 		}
 
@@ -155,13 +155,13 @@ _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
 _("bad %s magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
 					FORKNAME(whichfork), nodehdr.magic,
 					da_cursor->ino, bno);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			goto error_out;
 		}
 
 		/* corrupt node; rebuild the dir. */
 		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			do_warn(
 _("corrupt %s tree block %u for inode %" PRIu64 "\n"),
 				FORKNAME(whichfork), bno, da_cursor->ino);
@@ -173,7 +173,7 @@ _("corrupt %s tree block %u for inode %" PRIu64 "\n"),
 _("bad %s record count in inode %" PRIu64 ", count = %d, max = %d\n"),
 				FORKNAME(whichfork), da_cursor->ino,
 				nodehdr.count, geo->node_ents);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			goto error_out;
 		}
 
@@ -186,7 +186,7 @@ _("bad %s record count in inode %" PRIu64 ", count = %d, max = %d\n"),
 				do_warn(
 _("bad header depth for directory inode %" PRIu64 "\n"),
 					da_cursor->ino);
-				libxfs_putbuf(bp);
+				libxfs_buf_relse(bp);
 				i = -1;
 				goto error_out;
 			}
@@ -197,7 +197,7 @@ _("bad header depth for directory inode %" PRIu64 "\n"),
 				do_warn(
 _("bad %s btree for inode %" PRIu64 "\n"),
 					FORKNAME(whichfork), da_cursor->ino);
-				libxfs_putbuf(bp);
+				libxfs_buf_relse(bp);
 				goto error_out;
 			}
 		}
@@ -222,7 +222,7 @@ _("bad %s btree for inode %" PRIu64 "\n"),
 
 error_out:
 	while (i > 1 && i <= da_cursor->active) {
-		libxfs_putbuf(da_cursor->level[i].bp);
+		libxfs_buf_relse(da_cursor->level[i].bp);
 		i++;
 	}
 
@@ -252,7 +252,7 @@ release_da_cursor_int(
 		}
 		ASSERT(error != 0);
 
-		libxfs_putbuf(cursor->level[level].bp);
+		libxfs_buf_relse(cursor->level[level].bp);
 		cursor->level[level].bp = NULL;
 	}
 
@@ -406,7 +406,7 @@ _("would correct bad hashval in non-leaf %s block\n"
 	if (cursor->level[this_level].dirty && !no_modify)
 		libxfs_writebuf(cursor->level[this_level].bp, 0);
 	else
-		libxfs_putbuf(cursor->level[this_level].bp);
+		libxfs_buf_relse(cursor->level[this_level].bp);
 
 	cursor->level[this_level].bp = NULL;
 
@@ -600,7 +600,7 @@ _("bad level %d in %s block %u for inode %" PRIu64 "\n"),
 #ifdef XR_DIR_TRACE
 			fprintf(stderr, "verify_da_path returns 1 (bad) #4\n");
 #endif
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			return 1;
 		}
 
@@ -622,7 +622,7 @@ _("bad level %d in %s block %u for inode %" PRIu64 "\n"),
 		if (cursor->level[this_level].dirty && !no_modify)
 			libxfs_writebuf(cursor->level[this_level].bp, 0);
 		else
-			libxfs_putbuf(cursor->level[this_level].bp);
+			libxfs_buf_relse(cursor->level[this_level].bp);
 
 		/* switch cursor to point at the new buffer we just read */
 		cursor->level[this_level].bp = bp;
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index dbf3d37a..863c4531 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -56,7 +56,7 @@ check_aginode_block(xfs_mount_t	*mp,
 	if (cnt)
 		bp->b_ops = &xfs_inode_buf_ops;
 
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 	return(cnt);
 }
 
@@ -670,7 +670,7 @@ process_inode_chunk(
 					M_IGEO(mp)->blocks_per_cluster));
 			while (bp_index > 0) {
 				bp_index--;
-				libxfs_putbuf(bplist[bp_index]);
+				libxfs_buf_relse(bplist[bp_index]);
 			}
 			free(bplist);
 			return(1);
@@ -759,7 +759,7 @@ process_inode_chunk(
 			*bogus = 1;
 			for (bp_index = 0; bp_index < cluster_count; bp_index++)
 				if (bplist[bp_index])
-					libxfs_putbuf(bplist[bp_index]);
+					libxfs_buf_relse(bplist[bp_index]);
 			free(bplist);
 			return(0);
 		}
@@ -942,7 +942,7 @@ process_inode_chunk(
 				if (dirty && !no_modify)
 					libxfs_writebuf(bplist[bp_index], 0);
 				else
-					libxfs_putbuf(bplist[bp_index]);
+					libxfs_buf_relse(bplist[bp_index]);
 			}
 			free(bplist);
 			break;
diff --git a/repair/dinode.c b/repair/dinode.c
index 0d9c96be..928698cb 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1234,7 +1234,7 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
 		if (writebuf && !no_modify)
 			libxfs_writebuf(bp, 0);
 		else
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 	}
 	return 0;
 }
@@ -1296,7 +1296,7 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 			do_warn(
 _("Corrupt symlink remote block %" PRIu64 ", inode %" PRIu64 ".\n"),
 				fsbno, lino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			return 1;
 		}
 		if (bp->b_error == -EFSBADCRC) {
@@ -1316,7 +1316,7 @@ _("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
 				do_warn(
 _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 					lino, i, fsbno);
-				libxfs_putbuf(bp);
+				libxfs_buf_relse(bp);
 				return 1;
 			}
 			src += sizeof(struct xfs_dsymlink_hdr);
@@ -1331,7 +1331,7 @@ _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n")
 		if (badcrc && !no_modify)
 			libxfs_writebuf(bp, 0);
 		else
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 	}
 	return 0;
 }
diff --git a/repair/dir2.c b/repair/dir2.c
index 723aee1f..769e341c 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1012,7 +1012,7 @@ _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n
 		*repair = 1;
 		libxfs_writebuf(bp, 0);
 	} else
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 	return rval;
 }
 
@@ -1131,7 +1131,7 @@ _("can't read file block %u for directory inode %" PRIu64 "\n"),
 			do_warn(
 _("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
 				leafhdr.magic, ino, da_bno);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			goto error_out;
 		}
 		buf_dirty = 0;
@@ -1141,7 +1141,7 @@ _("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
 		 */
 		if (process_leaf_block_dir2(mp, leaf, da_bno, ino,
 				current_hashval, &greatest_hashval)) {
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			goto error_out;
 		}
 		/*
@@ -1159,14 +1159,14 @@ _("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
 			do_warn(
 _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 				da_bno, ino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			goto error_out;
 		}
 		prev_bno = da_bno;
 		da_bno = leafhdr.forw;
 		if (da_bno != 0) {
 			if (verify_da_path(mp, da_cursor, 0, XFS_DATA_FORK)) {
-				libxfs_putbuf(bp);
+				libxfs_buf_relse(bp);
 				goto error_out;
 			}
 		}
@@ -1182,7 +1182,7 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 			*repair = 1;
 			libxfs_writebuf(bp, 0);
 		} else
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 	} while (da_bno != 0);
 	if (verify_final_da_path(mp, da_cursor, 0, XFS_DATA_FORK)) {
 		/*
@@ -1341,7 +1341,7 @@ _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" P
 			*repair = 1;
 			libxfs_writebuf(bp, 0);
 		} else
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 	}
 	if (good == 0)
 		return 1;
diff --git a/repair/phase3.c b/repair/phase3.c
index 161852e0..1c6929ac 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -49,7 +49,7 @@ process_agi_unlinked(
 	if (agi_dirty)
 		libxfs_writebuf(bp, 0);
 	else
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 }
 
 static void
diff --git a/repair/phase6.c b/repair/phase6.c
index 70135694..2464fe1a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1624,7 +1624,7 @@ longform_dir2_entry_check_data(
 			dir2_kill_block(mp, ip, da_bno, bp);
 		} else {
 			do_warn(_("would junk block\n"));
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 		}
 		freetab->ents[db].v = NULLDATAOFF;
 		*bpp = NULL;
@@ -2063,21 +2063,21 @@ longform_dir2_check_leaf(
 		do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
 			da_bno, ip->i_ino);
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		return 1;
 	}
 
 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
 		error = check_da3_header(mp, bp, ip->i_ino);
 		if (error) {
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			return error;
 		}
 	}
 
 	seeval = dir_hash_see_all(hashtab, ents, leafhdr.count, leafhdr.stale);
 	if (dir_hash_check(hashtab, ip, seeval)) {
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		return 1;
 	}
 	badtail = freetab->nents != be32_to_cpu(ltp->bestcount);
@@ -2089,10 +2089,10 @@ longform_dir2_check_leaf(
 		do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad tail\n"),
 			da_bno, ip->i_ino);
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		return 1;
 	}
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 	return fixit;
 }
 
@@ -2155,7 +2155,7 @@ longform_dir2_check_node(
 			do_warn(
 	_("unknown magic number %#x for block %u in directory inode %" PRIu64 "\n"),
 				leafhdr.magic, da_bno, ip->i_ino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			return 1;
 		}
 
@@ -2164,7 +2164,7 @@ longform_dir2_check_node(
 		    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
 			error = check_da3_header(mp, bp, ip->i_ino);
 			if (error) {
-				libxfs_putbuf(bp);
+				libxfs_buf_relse(bp);
 				return error;
 			}
 		}
@@ -2172,7 +2172,7 @@ longform_dir2_check_node(
 		/* ignore nodes */
 		if (leafhdr.magic == XFS_DA_NODE_MAGIC ||
 		    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			continue;
 		}
 
@@ -2186,12 +2186,12 @@ longform_dir2_check_node(
 			do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
 				da_bno, ip->i_ino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			return 1;
 		}
 		seeval = dir_hash_see_all(hashtab, ents,
 					leafhdr.count, leafhdr.stale);
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		if (seeval != DIR_HASH_CK_OK)
 			return 1;
 	}
@@ -2226,14 +2226,14 @@ longform_dir2_check_node(
 			do_warn(
 	_("free block %u for directory inode %" PRIu64 " bad header\n"),
 				da_bno, ip->i_ino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			return 1;
 		}
 
 		if (freehdr.magic == XFS_DIR3_FREE_MAGIC) {
 			error = check_dir3_header(mp, bp, ip->i_ino);
 			if (error) {
-				libxfs_putbuf(bp);
+				libxfs_buf_relse(bp);
 				return error;
 			}
 		}
@@ -2244,7 +2244,7 @@ longform_dir2_check_node(
 				do_warn(
 	_("free block %u entry %i for directory ino %" PRIu64 " bad\n"),
 					da_bno, i, ip->i_ino);
-				libxfs_putbuf(bp);
+				libxfs_buf_relse(bp);
 				return 1;
 			}
 			used += be16_to_cpu(bests[i]) != NULLDATAOFF;
@@ -2254,10 +2254,10 @@ longform_dir2_check_node(
 			do_warn(
 	_("free block %u for directory inode %" PRIu64 " bad nused\n"),
 				da_bno, ip->i_ino);
-			libxfs_putbuf(bp);
+			libxfs_buf_relse(bp);
 			return 1;
 		}
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 	}
 	for (i = 0; i < freetab->nents; i++) {
 		if ((freetab->ents[i].s == 0) &&
@@ -2433,14 +2433,14 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		dir_hash_dup_names(hashtab);
 		for (i = 0; i < num_bps; i++)
 			if (bplist[i])
-				libxfs_putbuf(bplist[i]);
+				libxfs_buf_relse(bplist[i]);
 		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
 		*num_illegal = 0;
 		*need_dot = 0;
 	} else {
 		for (i = 0; i < num_bps; i++)
 			if (bplist[i])
-				libxfs_putbuf(bplist[i]);
+				libxfs_buf_relse(bplist[i]);
 	}
 
 	free(bplist);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 8e3772ed..f7ea9c8f 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -129,7 +129,7 @@ pf_queue_io(
 			pf_read_inode_dirs(args, bp);
 		XFS_BUF_SET_PRIORITY(bp, XFS_BUF_PRIORITY(bp) +
 						CACHE_PREFETCH_PRIORITY);
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		return;
 	}
 	XFS_BUF_SET_PRIORITY(bp, flag);
@@ -286,13 +286,13 @@ pf_scan_lbtree(
 	 */
 	if (bp->b_error) {
 		bp->b_flags |= LIBXFS_B_UNCHECKED;
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		return 0;
 	}
 
 	rc = (*func)(XFS_BUF_TO_BLOCK(bp), level - 1, isadir, args);
 
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 
 	return rc;
 }
@@ -578,7 +578,7 @@ pf_batch_read(
 		if ((bplist[num - 1]->b_flags & LIBXFS_B_DISCONTIG)) {
 			libxfs_readbufr_map(mp->m_ddev_targp, bplist[num - 1], 0);
 			bplist[num - 1]->b_flags |= LIBXFS_B_UNCHECKED;
-			libxfs_putbuf(bplist[num - 1]);
+			libxfs_buf_relse(bplist[num - 1]);
 			num--;
 		}
 
@@ -612,7 +612,7 @@ pf_batch_read(
 				B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])) ? 'I' : 'M',
 				bplist[i], (long long)XFS_BUF_ADDR(bplist[i]),
 				args->agno);
-			libxfs_putbuf(bplist[i]);
+			libxfs_buf_relse(bplist[i]);
 		}
 		pthread_mutex_lock(&args->lock);
 		if (which != PF_SECONDARY) {
diff --git a/repair/rmap.c b/repair/rmap.c
index 2f99d35d..bc53e6c0 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -527,7 +527,7 @@ rmap_store_ag_btree_rec(
 		}
 		b++;
 	}
-	libxfs_putbuf(agflbp);
+	libxfs_buf_relse(agflbp);
 	agflbp = NULL;
 	bitmap_free(&own_ag_bitmap);
 
@@ -579,7 +579,7 @@ rmap_store_ag_btree_rec(
 	free_slab_cursor(&rm_cur);
 err:
 	if (agflbp)
-		libxfs_putbuf(agflbp);
+		libxfs_buf_relse(agflbp);
 	if (own_ag_bitmap)
 		bitmap_free(&own_ag_bitmap);
 	return error;
@@ -1082,7 +1082,7 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 	if (bt_cur)
 		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 	if (agbp)
-		libxfs_putbuf(agbp);
+		libxfs_buf_relse(agbp);
 	free_slab_cursor(&rm_cur);
 	return 0;
 }
@@ -1417,7 +1417,7 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
 		libxfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
 							XFS_BTREE_NOERROR);
 	if (agbp)
-		libxfs_putbuf(agbp);
+		libxfs_buf_relse(agbp);
 	free_slab_cursor(&rl_cur);
 	return 0;
 }
diff --git a/repair/rt.c b/repair/rt.c
index 7108e3d5..3319829c 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -222,7 +222,7 @@ process_rtbitmap(xfs_mount_t	*mp,
 				prevbit = 0;
 			}
 		}
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 		if (extno == mp->m_sb.sb_rextents)
 			break;
 	}
@@ -266,7 +266,7 @@ process_rtsummary(xfs_mount_t	*mp,
 		bytes = bp->b_un.b_addr;
 		memmove((char *)sumfile + sumbno * mp->m_sb.sb_blocksize, bytes,
 			mp->m_sb.sb_blocksize);
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 	}
 }
 #endif
diff --git a/repair/scan.c b/repair/scan.c
index 05707dd2..c961e843 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -82,7 +82,7 @@ scan_sbtree(
 
 	(*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1, root, agno, suspect,
 			isroot, magic, priv, ops);
-	libxfs_putbuf(bp);
+	libxfs_buf_relse(bp);
 }
 
 /*
@@ -154,7 +154,7 @@ scan_lbtree(
 	if ((dirty || badcrc) && !no_modify)
 		libxfs_writebuf(bp, 0);
 	else
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 
 	return(err);
 }
@@ -2142,7 +2142,7 @@ scan_freelist(
 
 	agcnts->fdblocks += state.count;
 
-	libxfs_putbuf(agflbuf);
+	libxfs_buf_relse(agflbuf);
 }
 
 static void
@@ -2432,12 +2432,12 @@ scan_ag(
 	if (agi_dirty && !no_modify)
 		libxfs_writebuf(agibuf, 0);
 	else
-		libxfs_putbuf(agibuf);
+		libxfs_buf_relse(agibuf);
 
 	if (agf_dirty && !no_modify)
 		libxfs_writebuf(agfbuf, 0);
 	else
-		libxfs_putbuf(agfbuf);
+		libxfs_buf_relse(agfbuf);
 
 	if (sb_dirty && !no_modify) {
 		if (agno == 0)
@@ -2445,7 +2445,7 @@ scan_ag(
 		libxfs_sb_to_disk(XFS_BUF_TO_SBP(sbbuf), sb);
 		libxfs_writebuf(sbbuf, 0);
 	} else
-		libxfs_putbuf(sbbuf);
+		libxfs_buf_relse(sbbuf);
 	free(sb);
 	PROG_RPT_INC(prog_rpt_done[agno], 1);
 
@@ -2455,11 +2455,11 @@ scan_ag(
 	return;
 
 out_free_agibuf:
-	libxfs_putbuf(agibuf);
+	libxfs_buf_relse(agibuf);
 out_free_agfbuf:
-	libxfs_putbuf(agfbuf);
+	libxfs_buf_relse(agfbuf);
 out_free_sbbuf:
-	libxfs_putbuf(sbbuf);
+	libxfs_buf_relse(sbbuf);
 out_free_sb:
 	free(sb);
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 38578121..a97f2803 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -479,7 +479,7 @@ guess_correct_sunit(
 		if (error)
 			continue;
 		libxfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
-		libxfs_putbuf(bp);
+		libxfs_buf_relse(bp);
 
 		calc_rootino = libxfs_ialloc_calc_rootino(mp, sb.sb_unit);
 		if (calc_rootino == mp->m_sb.sb_rootino)

