Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB955C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E51E21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nHbr38xs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTBoD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:44:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBoD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:44:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1cvBS039922;
        Thu, 20 Feb 2020 01:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=F/h4fO5JyMJp1JwLur4LstT0JlqqW0Ma/8WvZl96Afw=;
 b=nHbr38xsAl/VO30B+ZwLPdtA3pudiY46PJhzIBxi7mQ3Vs3qSCJrj2L6rwwefB0OwxYI
 T8qAjOUvvxn4DUXvd6T/QNJyHv1NFV2uUMJTOTC4GvJuYY6hMeiM325owrN7czFWnM6e
 etd+kgeYMiH/cS6ttL/0S1CdveRlBu3Ev6N1Dw5RYknC0e0ejaM5s2ulcth+4aYmyeP4
 FRdllXzYthZjgyPC6HBaVvJpBKrWU9IDFVLE4xFX/dzV7V7uGVw+TyyYQlHWY5whF8HR
 4I7NHaVJfnJOrbW61ew6PIB3mGoQ8EyxRJEY+Ccwx3sMnEIjoH/uPAMzTqt5fzcvrZ0f gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud16scr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1g7TL188816;
        Thu, 20 Feb 2020 01:43:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2y8ud973jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:57 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1hvMT003311;
        Thu, 20 Feb 2020 01:43:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:43:56 -0800
Subject: [PATCH 13/18] libxfs: straighten out libxfs_writebuf confusion
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:43:55 -0800
Message-ID: <158216303592.602314.4622638173533560298.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=2 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

libxfs_writebuf is not a well named function -- it marks the buffer
dirty and then releases the caller's reference.  The actual write comes
when the cache is flushed, either because someone explicitly told the
cache to flush or because we started buffer reclaim.

Make the buffer release explicit in the callers and rename the function
to say what it actually does -- it marks the buffer dirty outside of
transaction context.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h   |   10 +++++-----
 libxfs/rdwr.c        |   21 ++++++++++++++-------
 libxfs/trans.c       |    3 ++-
 mkfs/proto.c         |    6 ++++--
 mkfs/xfs_mkfs.c      |   21 ++++++++++++++-------
 repair/attr_repair.c |   17 +++++++++--------
 repair/da_util.c     |   12 ++++++++----
 repair/dino_chunks.c |    6 ++++--
 repair/dinode.c      |   12 ++++++++----
 repair/dir2.c        |    9 ++++++---
 repair/phase3.c      |    6 ++++--
 repair/phase5.c      |   42 ++++++++++++++++++++++++++++--------------
 repair/rmap.c        |    3 ++-
 repair/scan.c        |   21 ++++++++++++++-------
 repair/xfs_repair.c  |    3 ++-
 15 files changed, 124 insertions(+), 68 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 6598dba7..ad8acc1e 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -138,8 +138,8 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_readbuf_map(dev, map, nmaps, flags, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags), (ops))
-#define libxfs_writebuf(buf, flags) \
-	libxfs_trace_writebuf(__FUNCTION__, __FILE__, __LINE__, \
+#define libxfs_buf_dirty(buf, flags) \
+	libxfs_trace_dirtybuf(__FUNCTION__, __FILE__, __LINE__, \
 			      (buf), (flags))
 #define libxfs_buf_get(dev, daddr, len) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
@@ -159,8 +159,8 @@ struct xfs_buf *libxfs_trace_readbuf(const char *func, const char *file,
 extern xfs_buf_t *libxfs_trace_readbuf_map(const char *, const char *, int,
 			struct xfs_buftarg *, struct xfs_buf_map *, int, int,
 			const struct xfs_buf_ops *);
-extern int	libxfs_trace_writebuf(const char *, const char *, int,
-			xfs_buf_t *, int);
+void libxfs_trace_dirtybuf(const char *func, const char *file, int line,
+			struct xfs_buf *bp, int flags);
 struct xfs_buf *libxfs_trace_getbuf(const char *func, const char *file,
 			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
 			size_t len);
@@ -175,7 +175,7 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 
 extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
-extern int	libxfs_writebuf(xfs_buf_t *, int);
+void libxfs_buf_dirty(struct xfs_buf *bp, int flags);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
 extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 20a8b0ce..af363bef 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -425,11 +425,16 @@ libxfs_trace_readbuf(
 	return bp;
 }
 
-int
-libxfs_trace_writebuf(const char *func, const char *file, int line, xfs_buf_t *bp, int flags)
+void
+libxfs_trace_dirtybuf(
+	const char		*func,
+	const char		*file,
+	int			line,
+	struct xfs_buf		*bp,
+	int			flags)
 {
 	__add_trace(bp, func, file, line);
-	return libxfs_writebuf(bp, flags);
+	libxfs_buf_dirty(bp, flags);
 }
 
 struct xfs_buf *
@@ -1233,8 +1238,12 @@ libxfs_writebuf_int(xfs_buf_t *bp, int flags)
 	return 0;
 }
 
-int
-libxfs_writebuf(
+/*
+ * Mark a buffer dirty.  The dirty data will be written out when the cache
+ * is flushed (or at release time if the buffer is uncached).
+ */
+void
+libxfs_buf_dirty(
 	struct xfs_buf	*bp,
 	int		flags)
 {
@@ -1256,8 +1265,6 @@ libxfs_writebuf(
 	bp->b_error = 0;
 	bp->b_flags &= ~LIBXFS_B_STALE;
 	bp->b_flags |= bflags;
-	libxfs_buf_relse(bp);
-	return 0;
 }
 
 void
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 59cb897f..4c208422 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -843,7 +843,8 @@ inode_item_done(
 		goto free;
 	}
 
-	libxfs_writebuf(bp, 0);
+	libxfs_buf_dirty(bp, 0);
+	libxfs_buf_relse(bp);
 free:
 	xfs_inode_item_put(iip);
 }
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0025fa08..de5ae306 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -261,8 +261,10 @@ newfile(
 			memset((char *)bp->b_addr + len, 0, bp->b_bcount - len);
 		if (logit)
 			libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
-		else
-			libxfs_writebuf(bp, LIBXFS_WRITEBUF_FAIL_EXIT);
+		else {
+			libxfs_buf_dirty(bp, LIBXFS_WRITEBUF_FAIL_EXIT);
+			libxfs_buf_relse(bp);
+		}
 	}
 	ip->i_d.di_size = len;
 	return flags;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f58f235d..b50b8b3a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3462,7 +3462,8 @@ prepare_devices(
 	buf = get_write_buf(mp->m_ddev_targp, (xi->dsize - whack_blks),
 			whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_relse(buf);
 
 	/*
 	 * Now zero out the beginning of the device, to obliterate any old
@@ -3472,7 +3473,8 @@ prepare_devices(
 	 */
 	buf = get_write_buf(mp->m_ddev_targp, 0, whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_relse(buf);
 
 	/* OK, now write the superblock... */
 	buf = get_write_buf(mp->m_ddev_targp, XFS_SB_DADDR,
@@ -3480,7 +3482,8 @@ prepare_devices(
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
-	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_relse(buf);
 
 	/* ...and zero the log.... */
 	lsunit = sbp->sb_logsunit;
@@ -3499,7 +3502,8 @@ prepare_devices(
 				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				BTOBB(cfg->blocksize));
 		memset(buf->b_addr, 0, cfg->blocksize);
-		libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+		libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+		libxfs_buf_relse(buf);
 	}
 
 }
@@ -3591,7 +3595,8 @@ rewrite_secondary_superblocks(
 			XFS_FSS_TO_BB(mp, 1),
 			LIBXFS_READBUF_FAIL_EXIT, &xfs_sb_buf_ops);
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_relse(buf);
 
 	/* and one in the middle for luck if there's enough AGs for that */
 	if (mp->m_sb.sb_agcount <= 2)
@@ -3603,7 +3608,8 @@ rewrite_secondary_superblocks(
 			XFS_FSS_TO_BB(mp, 1),
 			LIBXFS_READBUF_FAIL_EXIT, &xfs_sb_buf_ops);
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_relse(buf);
 }
 
 static void
@@ -3951,7 +3957,8 @@ main(
 	if (!buf || buf->b_error)
 		exit(1);
 	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
-	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
+	libxfs_buf_relse(buf);
 
 	/* Make sure our new fs made it to stable storage. */
 	libxfs_flush_devices(mp, &d, &l, &r);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index cc20b1a1..fb64b0be 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -835,8 +835,10 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		if (!no_modify && bp->b_error == -EFSBADCRC)
 			repair++;
 
-		if (repair && !no_modify)
-			libxfs_writebuf(bp, 0);
+		if (repair && !no_modify) {
+			libxfs_buf_dirty(bp, 0);
+			libxfs_buf_relse(bp);
+		}
 		else
 			libxfs_buf_relse(bp);
 	} while (da_bno != 0);
@@ -999,9 +1001,8 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
 	*repair = *repair || repairlinks;
 
 	if (*repair && !no_modify)
-		libxfs_writebuf(bp, 0);
-	else
-		libxfs_buf_relse(bp);
+		libxfs_buf_dirty(bp, 0);
+	libxfs_buf_relse(bp);
 
 	return 0;
 }
@@ -1043,9 +1044,9 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
 	/* must do this now, to release block 0 before the traversal */
 	if ((*repair || repairlinks) && !no_modify) {
 		*repair = 1;
-		libxfs_writebuf(bp, 0);
-	} else
-		libxfs_buf_relse(bp);
+		libxfs_buf_dirty(bp, 0);
+	}
+	libxfs_buf_relse(bp);
 	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
 	if (error)
 		*repair = 0;
diff --git a/repair/da_util.c b/repair/da_util.c
index c02d621c..d1e17ec3 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -403,8 +403,10 @@ _("would correct bad hashval in non-leaf %s block\n"
 	ASSERT(cursor->level[this_level].dirty == 0 ||
 		(cursor->level[this_level].dirty && !no_modify));
 
-	if (cursor->level[this_level].dirty && !no_modify)
-		libxfs_writebuf(cursor->level[this_level].bp, 0);
+	if (cursor->level[this_level].dirty && !no_modify) {
+		libxfs_buf_dirty(cursor->level[this_level].bp, 0);
+		libxfs_buf_relse(cursor->level[this_level].bp);
+	}
 	else
 		libxfs_buf_relse(cursor->level[this_level].bp);
 
@@ -619,8 +621,10 @@ _("bad level %d in %s block %u for inode %" PRIu64 "\n"),
 		    cursor->level[this_level].bp->b_error == -EFSBADCRC)
 			cursor->level[this_level].dirty = 1;
 
-		if (cursor->level[this_level].dirty && !no_modify)
-			libxfs_writebuf(cursor->level[this_level].bp, 0);
+		if (cursor->level[this_level].dirty && !no_modify) {
+			libxfs_buf_dirty(cursor->level[this_level].bp, 0);
+			libxfs_buf_relse(cursor->level[this_level].bp);
+		}
 		else
 			libxfs_buf_relse(cursor->level[this_level].bp);
 
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 76e9f773..1378fc59 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -939,8 +939,10 @@ process_inode_chunk(
 					bplist[bp_index], (long long)
 					XFS_BUF_ADDR(bplist[bp_index]), agno);
 
-				if (dirty && !no_modify)
-					libxfs_writebuf(bplist[bp_index], 0);
+				if (dirty && !no_modify) {
+					libxfs_buf_dirty(bplist[bp_index], 0);
+					libxfs_buf_relse(bplist[bp_index]);
+				}
 				else
 					libxfs_buf_relse(bplist[bp_index]);
 			}
diff --git a/repair/dinode.c b/repair/dinode.c
index 848eac09..276dd2e1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1231,8 +1231,10 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
 			}
 		}
 
-		if (writebuf && !no_modify)
-			libxfs_writebuf(bp, 0);
+		if (writebuf && !no_modify) {
+			libxfs_buf_dirty(bp, 0);
+			libxfs_buf_relse(bp);
+		}
 		else
 			libxfs_buf_relse(bp);
 	}
@@ -1328,8 +1330,10 @@ _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n")
 		offset += byte_cnt;
 		i++;
 
-		if (badcrc && !no_modify)
-			libxfs_writebuf(bp, 0);
+		if (badcrc && !no_modify) {
+			libxfs_buf_dirty(bp, 0);
+			libxfs_buf_relse(bp);
+		}
 		else
 			libxfs_buf_relse(bp);
 	}
diff --git a/repair/dir2.c b/repair/dir2.c
index 769e341c..a8b8de58 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1010,7 +1010,8 @@ _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n
 		dirty = 1;
 	if (dirty && !no_modify) {
 		*repair = 1;
-		libxfs_writebuf(bp, 0);
+		libxfs_buf_dirty(bp, 0);
+		libxfs_buf_relse(bp);
 	} else
 		libxfs_buf_relse(bp);
 	return rval;
@@ -1180,7 +1181,8 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 		ASSERT(buf_dirty == 0 || (buf_dirty && !no_modify));
 		if (buf_dirty && !no_modify) {
 			*repair = 1;
-			libxfs_writebuf(bp, 0);
+			libxfs_buf_dirty(bp, 0);
+			libxfs_buf_relse(bp);
 		} else
 			libxfs_buf_relse(bp);
 	} while (da_bno != 0);
@@ -1339,7 +1341,8 @@ _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" P
 		}
 		if (dirty && !no_modify) {
 			*repair = 1;
-			libxfs_writebuf(bp, 0);
+			libxfs_buf_dirty(bp, 0);
+			libxfs_buf_relse(bp);
 		} else
 			libxfs_buf_relse(bp);
 	}
diff --git a/repair/phase3.c b/repair/phase3.c
index 886acd1f..396743a4 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -46,8 +46,10 @@ process_agi_unlinked(
 		}
 	}
 
-	if (agi_dirty)
-		libxfs_writebuf(bp, 0);
+	if (agi_dirty) {
+		libxfs_buf_dirty(bp, 0);
+		libxfs_buf_relse(bp);
+	}
 	else
 		libxfs_buf_relse(bp);
 }
diff --git a/repair/phase5.c b/repair/phase5.c
index cdbf6697..561a6b3f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -321,9 +321,11 @@ write_cursor(bt_status_t *curs)
 			fprintf(stderr, "writing bt prev block %u\n",
 						curs->level[i].prev_agbno);
 #endif
-			libxfs_writebuf(curs->level[i].prev_buf_p, 0);
+			libxfs_buf_dirty(curs->level[i].prev_buf_p, 0);
+			libxfs_buf_relse(curs->level[i].prev_buf_p);
 		}
-		libxfs_writebuf(curs->level[i].buf_p, 0);
+		libxfs_buf_dirty(curs->level[i].buf_p, 0);
+		libxfs_buf_relse(curs->level[i].buf_p);
 	}
 }
 
@@ -681,7 +683,8 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK) {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
+			libxfs_buf_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;;
 		lptr->prev_buf_p = lptr->buf_p;
@@ -870,7 +873,8 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
+				libxfs_buf_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
 			lptr->prev_agbno = lptr->agbno;
@@ -1046,7 +1050,8 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
+			libxfs_buf_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;;
 		lptr->prev_buf_p = lptr->buf_p;
@@ -1137,7 +1142,8 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		agi->agi_free_level = cpu_to_be32(finobt_curs->num_levels);
 	}
 
-	libxfs_writebuf(agi_buf, 0);
+	libxfs_buf_dirty(agi_buf, 0);
+	libxfs_buf_relse(agi_buf);
 }
 
 /*
@@ -1299,7 +1305,8 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
+				libxfs_buf_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
 			lptr->prev_agbno = lptr->agbno;
@@ -1451,7 +1458,8 @@ prop_rmap_cursor(
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
+			libxfs_buf_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;
 		lptr->prev_buf_p = lptr->buf_p;
@@ -1661,7 +1669,8 @@ _("Insufficient memory to construct reverse-map cursor."));
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
+				libxfs_buf_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
 			lptr->prev_agbno = lptr->agbno;
@@ -1801,7 +1810,8 @@ prop_refc_cursor(
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
+			libxfs_buf_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;
 		lptr->prev_buf_p = lptr->buf_p;
@@ -1954,7 +1964,8 @@ _("Insufficient memory to construct refcount cursor."));
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
+				libxfs_buf_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
 			lptr->prev_agbno = lptr->agbno;
@@ -2142,7 +2153,8 @@ _("Insufficient memory saving lost blocks.\n"));
 		agf->agf_flcount = 0;
 	}
 
-	libxfs_writebuf(agfl_buf, 0);
+	libxfs_buf_dirty(agfl_buf, 0);
+	libxfs_buf_relse(agfl_buf);
 
 	ext_ptr = findbiggest_bcnt_extent(agno);
 	agf->agf_longest = cpu_to_be32((ext_ptr != NULL) ?
@@ -2155,7 +2167,8 @@ _("Insufficient memory saving lost blocks.\n"));
 	ASSERT(be32_to_cpu(agf->agf_refcount_root) !=
 		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
 
-	libxfs_writebuf(agf_buf, 0);
+	libxfs_buf_dirty(agf_buf, 0);
+	libxfs_buf_relse(agf_buf);
 
 	/*
 	 * now fix up the free list appropriately
@@ -2189,7 +2202,8 @@ sync_sb(xfs_mount_t *mp)
 	update_sb_version(mp);
 
 	libxfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
-	libxfs_writebuf(bp, 0);
+	libxfs_buf_dirty(bp, 0);
+	libxfs_buf_relse(bp);
 }
 
 /*
diff --git a/repair/rmap.c b/repair/rmap.c
index bc53e6c0..c8c851a6 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1231,7 +1231,8 @@ _("setting reflink flag on inode %"PRIu64"\n"),
 	else
 		dino->di_flags2 &= cpu_to_be64(~XFS_DIFLAG2_REFLINK);
 	libxfs_dinode_calc_crc(mp, dino);
-	libxfs_writebuf(buf, 0);
+	libxfs_buf_dirty(buf, 0);
+	libxfs_buf_relse(buf);
 
 	return 0;
 }
diff --git a/repair/scan.c b/repair/scan.c
index f4e4fef5..8b91b27e 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -151,8 +151,10 @@ scan_lbtree(
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
 
-	if ((dirty || badcrc) && !no_modify)
-		libxfs_writebuf(bp, 0);
+	if ((dirty || badcrc) && !no_modify) {
+		libxfs_buf_dirty(bp, 0);
+		libxfs_buf_relse(bp);
+	}
 	else
 		libxfs_buf_relse(bp);
 
@@ -2429,13 +2431,17 @@ scan_ag(
 		sb_dirty += (sbbuf->b_error == -EFSBADCRC);
 	}
 
-	if (agi_dirty && !no_modify)
-		libxfs_writebuf(agibuf, 0);
+	if (agi_dirty && !no_modify) {
+		libxfs_buf_dirty(agibuf, 0);
+		libxfs_buf_relse(agibuf);
+	}
 	else
 		libxfs_buf_relse(agibuf);
 
-	if (agf_dirty && !no_modify)
-		libxfs_writebuf(agfbuf, 0);
+	if (agf_dirty && !no_modify) {
+		libxfs_buf_dirty(agfbuf, 0);
+		libxfs_buf_relse(agfbuf);
+	}
 	else
 		libxfs_buf_relse(agfbuf);
 
@@ -2443,7 +2449,8 @@ scan_ag(
 		if (agno == 0)
 			memcpy(&mp->m_sb, sb, sizeof(xfs_sb_t));
 		libxfs_sb_to_disk(XFS_BUF_TO_SBP(sbbuf), sb);
-		libxfs_writebuf(sbbuf, 0);
+		libxfs_buf_dirty(sbbuf, 0);
+		libxfs_buf_relse(sbbuf);
 	} else
 		libxfs_buf_relse(sbbuf);
 	free(sb);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8642c5cd..2189c9fd 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1126,7 +1126,8 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
 	}
 
-	libxfs_writebuf(sbp, 0);
+	libxfs_buf_dirty(sbp, 0);
+	libxfs_buf_relse(sbp);
 
 	/*
 	 * Done. Flush all cached buffers and inodes first to ensure all

