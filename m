Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99B7C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D58F246AE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e6ziow/+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgB1XkR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44924 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB1XkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWjaq027748;
        Fri, 28 Feb 2020 23:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=U5ktNdLgVHmowdHnQiThly579PzfAp1tjVy9PH2P5ms=;
 b=e6ziow/+sN1jVXHmUwrPyEJxFlwOgemDg9dmBwhOVXRdFdi74zIhh0q4gz2gWISPw4pu
 UUP5crnzk1ptqFHGY+sWxPwMdTLP2TfsdvO9BgxdgijmwkD6DJ7SNBrzuwszH7nSl5nf
 FifAHp+XmpKHlR/esIc2flNXsZvis6UC/NtlQUwhyEbH5b9bAIbSTbaoRdSvMADM0+0Q
 EdzLpGj0EGD5gkwSP1yrllBacONUcoohSTjKQI87XF2nt/rqnkL8OxEp8CQjD/a6t4Y0
 QMiTk5zJik8eBxbaEfISBJGHfVB7XtKY5ihkxXoIzlV8OlXRdIGdhasG8JpMdVDksITS /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ydct3nt4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWL9c042106;
        Fri, 28 Feb 2020 23:38:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ydcs9vmnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:11 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNcAc9025370;
        Fri, 28 Feb 2020 23:38:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:38:07 -0800
Subject: [PATCH 17/26] libxfs: straighten out libxfs_writebuf naming
 confusion
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:38:06 -0800
Message-ID: <158293308678.1549542.13754890312687110440.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=2 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h   |   10 +++++-----
 libxfs/rdwr.c        |   35 ++++++++++++++++++++++++-----------
 libxfs/trans.c       |    3 ++-
 mkfs/proto.c         |    6 ++++--
 mkfs/xfs_mkfs.c      |   21 ++++++++++++++-------
 repair/attr_repair.c |   17 +++++++++--------
 repair/da_util.c     |   12 ++++++++----
 repair/dino_chunks.c |    7 +++++--
 repair/dinode.c      |   12 ++++++++----
 repair/dir2.c        |    9 ++++++---
 repair/phase3.c      |    6 ++++--
 repair/phase5.c      |   42 ++++++++++++++++++++++++++++--------------
 repair/rmap.c        |    3 ++-
 repair/scan.c        |   21 ++++++++++++++-------
 repair/xfs_repair.c  |    3 ++-
 15 files changed, 135 insertions(+), 72 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 1d30039a..51b1dc15 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -136,8 +136,8 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_readbuf_map(dev, map, nmaps, flags, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags), (ops))
-#define libxfs_writebuf(buf, flags) \
-	libxfs_trace_writebuf(__FUNCTION__, __FILE__, __LINE__, \
+#define libxfs_buf_mark_dirty(buf, flags) \
+	libxfs_trace_dirtybuf(__FUNCTION__, __FILE__, __LINE__, \
 			      (buf), (flags))
 #define libxfs_buf_get(dev, daddr, len) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
@@ -157,8 +157,8 @@ struct xfs_buf *libxfs_trace_readbuf(const char *func, const char *file,
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
@@ -173,7 +173,7 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 
 extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
-extern int	libxfs_writebuf(xfs_buf_t *, int);
+void libxfs_buf_mark_dirty(struct xfs_buf *bp, int flags);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
 extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 958f6c2c..192e3586 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -196,11 +196,16 @@ libxfs_trace_readbuf(
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
+	libxfs_buf_mark_dirty(bp, flags);
 }
 
 struct xfs_buf *
@@ -995,8 +1000,14 @@ libxfs_writebuf_int(xfs_buf_t *bp, int flags)
 	return 0;
 }
 
-int
-libxfs_writebuf(xfs_buf_t *bp, int flags)
+/*
+ * Mark a buffer dirty.  The dirty data will be written out when the cache
+ * is flushed (or at release time if the buffer is uncached).
+ */
+void
+libxfs_buf_mark_dirty(
+	struct xfs_buf	*bp,
+	int		flags)
 {
 #ifdef IO_DEBUG
 	printf("%lx: %s: dirty blkno=%llu(%llu)\n",
@@ -1011,8 +1022,6 @@ libxfs_writebuf(xfs_buf_t *bp, int flags)
 	bp->b_error = 0;
 	bp->b_flags &= ~LIBXFS_B_STALE;
 	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
-	libxfs_buf_relse(bp);
-	return 0;
 }
 
 void
@@ -1413,8 +1422,10 @@ libxfs_log_clear(
 	}
 	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
 			  next, bp);
-	if (bp)
-		libxfs_writebuf(bp, 0);
+	if (bp) {
+		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_relse(bp);
+	}
 
 	/*
 	 * There's nothing else to do if this is a log reset. The kernel detects
@@ -1463,8 +1474,10 @@ libxfs_log_clear(
 		 */
 		libxfs_log_header(ptr, fs_uuid, version, BBTOB(len), fmt, lsn,
 				  tail_lsn, next, bp);
-		if (bp)
-			libxfs_writebuf(bp, 0);
+		if (bp) {
+			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_relse(bp);
+		}
 
 		blk += len;
 		if (dptr)
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 59cb897f..91001a93 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -843,7 +843,8 @@ inode_item_done(
 		goto free;
 	}
 
-	libxfs_writebuf(bp, 0);
+	libxfs_buf_mark_dirty(bp, 0);
+	libxfs_buf_relse(bp);
 free:
 	xfs_inode_item_put(iip);
 }
diff --git a/mkfs/proto.c b/mkfs/proto.c
index c3813ea2..7de76ca4 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -261,8 +261,10 @@ newfile(
 			memset((char *)bp->b_addr + len, 0, bp->b_bcount - len);
 		if (logit)
 			libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
-		else
-			libxfs_writebuf(bp, 0);
+		else {
+			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_relse(bp);
+		}
 	}
 	ip->i_d.di_size = len;
 	return flags;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9b448394..525f256f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3462,7 +3462,8 @@ prepare_devices(
 	buf = alloc_write_buf(mp->m_ddev_targp, (xi->dsize - whack_blks),
 			whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_writebuf(buf, 0);
+	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_relse(buf);
 
 	/*
 	 * Now zero out the beginning of the device, to obliterate any old
@@ -3472,7 +3473,8 @@ prepare_devices(
 	 */
 	buf = alloc_write_buf(mp->m_ddev_targp, 0, whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_writebuf(buf, 0);
+	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_relse(buf);
 
 	/* OK, now write the superblock... */
 	buf = alloc_write_buf(mp->m_ddev_targp, XFS_SB_DADDR,
@@ -3480,7 +3482,8 @@ prepare_devices(
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
-	libxfs_writebuf(buf, 0);
+	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_relse(buf);
 
 	/* ...and zero the log.... */
 	lsunit = sbp->sb_logsunit;
@@ -3499,7 +3502,8 @@ prepare_devices(
 				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				BTOBB(cfg->blocksize));
 		memset(buf->b_addr, 0, cfg->blocksize);
-		libxfs_writebuf(buf, 0);
+		libxfs_buf_mark_dirty(buf, 0);
+		libxfs_buf_relse(buf);
 	}
 
 }
@@ -3595,7 +3599,8 @@ rewrite_secondary_superblocks(
 		exit(1);
 	}
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_writebuf(buf, 0);
+	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_relse(buf);
 
 	/* and one in the middle for luck if there's enough AGs for that */
 	if (mp->m_sb.sb_agcount <= 2)
@@ -3611,7 +3616,8 @@ rewrite_secondary_superblocks(
 		exit(1);
 	}
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_writebuf(buf, 0);
+	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_relse(buf);
 }
 
 static void
@@ -3958,7 +3964,8 @@ main(
 	if (!buf || buf->b_error)
 		exit(1);
 	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
-	libxfs_writebuf(buf, 0);
+	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_relse(buf);
 
 	/* Exit w/ failure if anything failed to get written to our new fs. */
 	error = -libxfs_umount(mp);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 7edf54ad..e9423aa1 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -835,8 +835,10 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		if (!no_modify && bp->b_error == -EFSBADCRC)
 			repair++;
 
-		if (repair && !no_modify)
-			libxfs_writebuf(bp, 0);
+		if (repair && !no_modify) {
+			libxfs_buf_mark_dirty(bp, 0);
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
+		libxfs_buf_mark_dirty(bp, 0);
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
+		libxfs_buf_mark_dirty(bp, 0);
+	}
+	libxfs_buf_relse(bp);
 	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
 	if (error)
 		*repair = 0;
diff --git a/repair/da_util.c b/repair/da_util.c
index c02d621c..6a0e28a3 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -403,8 +403,10 @@ _("would correct bad hashval in non-leaf %s block\n"
 	ASSERT(cursor->level[this_level].dirty == 0 ||
 		(cursor->level[this_level].dirty && !no_modify));
 
-	if (cursor->level[this_level].dirty && !no_modify)
-		libxfs_writebuf(cursor->level[this_level].bp, 0);
+	if (cursor->level[this_level].dirty && !no_modify) {
+		libxfs_buf_mark_dirty(cursor->level[this_level].bp, 0);
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
+			libxfs_buf_mark_dirty(cursor->level[this_level].bp, 0);
+			libxfs_buf_relse(cursor->level[this_level].bp);
+		}
 		else
 			libxfs_buf_relse(cursor->level[this_level].bp);
 
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 76e9f773..5b6f7fca 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -939,8 +939,11 @@ process_inode_chunk(
 					bplist[bp_index], (long long)
 					XFS_BUF_ADDR(bplist[bp_index]), agno);
 
-				if (dirty && !no_modify)
-					libxfs_writebuf(bplist[bp_index], 0);
+				if (dirty && !no_modify) {
+					libxfs_buf_mark_dirty(bplist[bp_index],
+							0);
+					libxfs_buf_relse(bplist[bp_index]);
+				}
 				else
 					libxfs_buf_relse(bplist[bp_index]);
 			}
diff --git a/repair/dinode.c b/repair/dinode.c
index aa7d479a..502114f8 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1231,8 +1231,10 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
 			}
 		}
 
-		if (writebuf && !no_modify)
-			libxfs_writebuf(bp, 0);
+		if (writebuf && !no_modify) {
+			libxfs_buf_mark_dirty(bp, 0);
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
+			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_relse(bp);
+		}
 		else
 			libxfs_buf_relse(bp);
 	}
diff --git a/repair/dir2.c b/repair/dir2.c
index 769e341c..1384011b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1010,7 +1010,8 @@ _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n
 		dirty = 1;
 	if (dirty && !no_modify) {
 		*repair = 1;
-		libxfs_writebuf(bp, 0);
+		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_relse(bp);
 	} else
 		libxfs_buf_relse(bp);
 	return rval;
@@ -1180,7 +1181,8 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 		ASSERT(buf_dirty == 0 || (buf_dirty && !no_modify));
 		if (buf_dirty && !no_modify) {
 			*repair = 1;
-			libxfs_writebuf(bp, 0);
+			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_relse(bp);
 		} else
 			libxfs_buf_relse(bp);
 	} while (da_bno != 0);
@@ -1339,7 +1341,8 @@ _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" P
 		}
 		if (dirty && !no_modify) {
 			*repair = 1;
-			libxfs_writebuf(bp, 0);
+			libxfs_buf_mark_dirty(bp, 0);
+			libxfs_buf_relse(bp);
 		} else
 			libxfs_buf_relse(bp);
 	}
diff --git a/repair/phase3.c b/repair/phase3.c
index 886acd1f..4e7fe964 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -46,8 +46,10 @@ process_agi_unlinked(
 		}
 	}
 
-	if (agi_dirty)
-		libxfs_writebuf(bp, 0);
+	if (agi_dirty) {
+		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_relse(bp);
+	}
 	else
 		libxfs_buf_relse(bp);
 }
diff --git a/repair/phase5.c b/repair/phase5.c
index cdbf6697..e31dedca 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -321,9 +321,11 @@ write_cursor(bt_status_t *curs)
 			fprintf(stderr, "writing bt prev block %u\n",
 						curs->level[i].prev_agbno);
 #endif
-			libxfs_writebuf(curs->level[i].prev_buf_p, 0);
+			libxfs_buf_mark_dirty(curs->level[i].prev_buf_p, 0);
+			libxfs_buf_relse(curs->level[i].prev_buf_p);
 		}
-		libxfs_writebuf(curs->level[i].buf_p, 0);
+		libxfs_buf_mark_dirty(curs->level[i].buf_p, 0);
+		libxfs_buf_relse(curs->level[i].buf_p);
 	}
 }
 
@@ -681,7 +683,8 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK) {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
+			libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;;
 		lptr->prev_buf_p = lptr->buf_p;
@@ -870,7 +873,8 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
+				libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
 			lptr->prev_agbno = lptr->agbno;
@@ -1046,7 +1050,8 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
+			libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;;
 		lptr->prev_buf_p = lptr->buf_p;
@@ -1137,7 +1142,8 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		agi->agi_free_level = cpu_to_be32(finobt_curs->num_levels);
 	}
 
-	libxfs_writebuf(agi_buf, 0);
+	libxfs_buf_mark_dirty(agi_buf, 0);
+	libxfs_buf_relse(agi_buf);
 }
 
 /*
@@ -1299,7 +1305,8 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
+				libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
 			lptr->prev_agbno = lptr->agbno;
@@ -1451,7 +1458,8 @@ prop_rmap_cursor(
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
+			libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;
 		lptr->prev_buf_p = lptr->buf_p;
@@ -1661,7 +1669,8 @@ _("Insufficient memory to construct reverse-map cursor."));
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
+				libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
 			lptr->prev_agbno = lptr->agbno;
@@ -1801,7 +1810,8 @@ prop_refc_cursor(
 #endif
 		if (lptr->prev_agbno != NULLAGBLOCK)  {
 			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
+			libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+			libxfs_buf_relse(lptr->prev_buf_p);
 		}
 		lptr->prev_agbno = lptr->agbno;
 		lptr->prev_buf_p = lptr->buf_p;
@@ -1954,7 +1964,8 @@ _("Insufficient memory to construct refcount cursor."));
 					lptr->prev_agbno);
 #endif
 				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
+				libxfs_buf_mark_dirty(lptr->prev_buf_p, 0);
+				libxfs_buf_relse(lptr->prev_buf_p);
 			}
 			lptr->prev_buf_p = lptr->buf_p;
 			lptr->prev_agbno = lptr->agbno;
@@ -2142,7 +2153,8 @@ _("Insufficient memory saving lost blocks.\n"));
 		agf->agf_flcount = 0;
 	}
 
-	libxfs_writebuf(agfl_buf, 0);
+	libxfs_buf_mark_dirty(agfl_buf, 0);
+	libxfs_buf_relse(agfl_buf);
 
 	ext_ptr = findbiggest_bcnt_extent(agno);
 	agf->agf_longest = cpu_to_be32((ext_ptr != NULL) ?
@@ -2155,7 +2167,8 @@ _("Insufficient memory saving lost blocks.\n"));
 	ASSERT(be32_to_cpu(agf->agf_refcount_root) !=
 		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
 
-	libxfs_writebuf(agf_buf, 0);
+	libxfs_buf_mark_dirty(agf_buf, 0);
+	libxfs_buf_relse(agf_buf);
 
 	/*
 	 * now fix up the free list appropriately
@@ -2189,7 +2202,8 @@ sync_sb(xfs_mount_t *mp)
 	update_sb_version(mp);
 
 	libxfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
-	libxfs_writebuf(bp, 0);
+	libxfs_buf_mark_dirty(bp, 0);
+	libxfs_buf_relse(bp);
 }
 
 /*
diff --git a/repair/rmap.c b/repair/rmap.c
index bc53e6c0..b0b9874e 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1231,7 +1231,8 @@ _("setting reflink flag on inode %"PRIu64"\n"),
 	else
 		dino->di_flags2 &= cpu_to_be64(~XFS_DIFLAG2_REFLINK);
 	libxfs_dinode_calc_crc(mp, dino);
-	libxfs_writebuf(buf, 0);
+	libxfs_buf_mark_dirty(buf, 0);
+	libxfs_buf_relse(buf);
 
 	return 0;
 }
diff --git a/repair/scan.c b/repair/scan.c
index d89a3076..b2749ae7 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -151,8 +151,10 @@ scan_lbtree(
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
 
-	if ((dirty || badcrc) && !no_modify)
-		libxfs_writebuf(bp, 0);
+	if ((dirty || badcrc) && !no_modify) {
+		libxfs_buf_mark_dirty(bp, 0);
+		libxfs_buf_relse(bp);
+	}
 	else
 		libxfs_buf_relse(bp);
 
@@ -2425,13 +2427,17 @@ scan_ag(
 		sb_dirty += (sbbuf->b_error == -EFSBADCRC);
 	}
 
-	if (agi_dirty && !no_modify)
-		libxfs_writebuf(agibuf, 0);
+	if (agi_dirty && !no_modify) {
+		libxfs_buf_mark_dirty(agibuf, 0);
+		libxfs_buf_relse(agibuf);
+	}
 	else
 		libxfs_buf_relse(agibuf);
 
-	if (agf_dirty && !no_modify)
-		libxfs_writebuf(agfbuf, 0);
+	if (agf_dirty && !no_modify) {
+		libxfs_buf_mark_dirty(agfbuf, 0);
+		libxfs_buf_relse(agfbuf);
+	}
 	else
 		libxfs_buf_relse(agfbuf);
 
@@ -2439,7 +2445,8 @@ scan_ag(
 		if (agno == 0)
 			memcpy(&mp->m_sb, sb, sizeof(xfs_sb_t));
 		libxfs_sb_to_disk(XFS_BUF_TO_SBP(sbbuf), sb);
-		libxfs_writebuf(sbbuf, 0);
+		libxfs_buf_mark_dirty(sbbuf, 0);
+		libxfs_buf_relse(sbbuf);
 	} else
 		libxfs_buf_relse(sbbuf);
 	free(sb);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ebd631e7..e297fe32 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1096,7 +1096,8 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
 	}
 
-	libxfs_writebuf(sbp, 0);
+	libxfs_buf_mark_dirty(sbp, 0);
+	libxfs_buf_relse(sbp);
 
 	/*
 	 * Done. Flush all cached buffers and inodes first to ensure all

