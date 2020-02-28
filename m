Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD08C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18D7D246AE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kRPkAWC+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgB1XiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:38:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1XiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:38:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWqAE028004;
        Fri, 28 Feb 2020 23:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7+9y6GYmpngO60Z27vlY7zLKuCrVFIlZKLNQ1cZ536I=;
 b=kRPkAWC+zBZ4c5c+QEzvIZsUNvRiQhUzQDe8DGlsrloxt9pbACBiJz2dcpH/6yXpcOUW
 dwUr4t68uSiFDTE8ff0wZIiu+W3EERrZ3nsfioag5TpFAnuLZoCtic3NoNpdN/1fFqC6
 ds2b3M9nn0clS0JAgAKNNowTFnJ/PVfmEHUYT7YJ0izacxgwZoa+jqPFuM/80N2w+h8e
 HqzYVzh0HfK9wnjKUQxv2vYaXQ3IVjr8ylLQw9flkuci/KfNFcU5ihIqEVO4B8PZzo1u
 OaRbfCDOFdvO5zij49+ZKbUzH/okNlY8NcuydBOpjV04Fk3etvso5Q7Q3PrCjgzmT7A+ /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ydct3nt54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcG73059496;
        Fri, 28 Feb 2020 23:38:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ydj4s33sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNc2cc013305;
        Fri, 28 Feb 2020 23:38:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:43 -0800
Subject: [PATCH 13/26] libxfs: move log functions for convenience
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 15:37:39 -0800
Message-ID: <158293305931.1549542.15554913817897978787.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=816 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=878 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move libxfs_log_clear and libxfs_log_header to the bottom of the file so
that we avoid having to create advance declarations of static functions
in the next patch.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |  473 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 237 insertions(+), 236 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3b470266..f76ac228 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -145,242 +145,6 @@ static char *next(
 	return ptr + offset;
 }
 
-/*
- * Format the log. The caller provides either a buftarg which is used to access
- * the log via buffers or a direct pointer to a buffer that encapsulates the
- * entire log.
- */
-int
-libxfs_log_clear(
-	struct xfs_buftarg	*btp,
-	char			*dptr,
-	xfs_daddr_t		start,
-	uint			length,		/* basic blocks */
-	uuid_t			*fs_uuid,
-	int			version,
-	int			sunit,		/* bytes */
-	int			fmt,
-	int			cycle,
-	bool			max)
-{
-	struct xfs_buf		*bp = NULL;
-	int			len;
-	xfs_lsn_t		lsn;
-	xfs_lsn_t		tail_lsn;
-	xfs_daddr_t		blk;
-	xfs_daddr_t		end_blk;
-	char			*ptr;
-
-	if (((btp && dptr) || (!btp && !dptr)) ||
-	    (btp && !btp->dev) || !fs_uuid)
-		return -EINVAL;
-
-	/* first zero the log */
-	if (btp)
-		libxfs_device_zero(btp, start, length);
-	else
-		memset(dptr, 0, BBTOB(length));
-
-	/*
-	 * Initialize the log record length and LSNs. XLOG_INIT_CYCLE is a
-	 * special reset case where we only write a single record where the lsn
-	 * and tail_lsn match. Otherwise, the record lsn starts at block 0 of
-	 * the specified cycle and points tail_lsn at the last record of the
-	 * previous cycle.
-	 */
-	len = ((version == 2) && sunit) ? BTOBB(sunit) : 2;
-	len = max(len, 2);
-	lsn = xlog_assign_lsn(cycle, 0);
-	if (cycle == XLOG_INIT_CYCLE)
-		tail_lsn = lsn;
-	else
-		tail_lsn = xlog_assign_lsn(cycle - 1, length - len);
-
-	/* write out the first log record */
-	ptr = dptr;
-	if (btp) {
-		bp = libxfs_getbufr(btp, start, len);
-		ptr = bp->b_addr;
-	}
-	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
-			  next, bp);
-	if (bp) {
-		bp->b_flags |= LIBXFS_B_DIRTY;
-		libxfs_putbufr(bp);
-	}
-
-	/*
-	 * There's nothing else to do if this is a log reset. The kernel detects
-	 * the rest of the log is zeroed and starts at cycle 1.
-	 */
-	if (cycle == XLOG_INIT_CYCLE)
-		return 0;
-
-	/*
-	 * Bump the record size for a full log format if the caller allows it.
-	 * This is primarily for performance reasons and most callers don't care
-	 * about record size since the log is clean after we're done.
-	 */
-	if (max)
-		len = BTOBB(BDSTRAT_SIZE);
-
-	/*
-	 * Otherwise, fill everything beyond the initial record with records of
-	 * the previous cycle so the kernel head/tail detection works correctly.
-	 *
-	 * We don't particularly care about the record size or content here.
-	 * It's only important that the headers are in place such that the
-	 * kernel finds 1.) a clean log and 2.) the correct current cycle value.
-	 * Therefore, bump up the record size to the max to use larger I/Os and
-	 * improve performance.
-	 */
-	cycle--;
-	blk = start + len;
-	if (dptr)
-		dptr += BBTOB(len);
-	end_blk = start + length;
-
-	len = min(end_blk - blk, len);
-	while (blk < end_blk) {
-		lsn = xlog_assign_lsn(cycle, blk - start);
-		tail_lsn = xlog_assign_lsn(cycle, blk - start - len);
-
-		ptr = dptr;
-		if (btp) {
-			bp = libxfs_getbufr(btp, blk, len);
-			ptr = bp->b_addr;
-		}
-		/*
-		 * Note: pass the full buffer length as the sunit to initialize
-		 * the entire buffer.
-		 */
-		libxfs_log_header(ptr, fs_uuid, version, BBTOB(len), fmt, lsn,
-				  tail_lsn, next, bp);
-		if (bp) {
-			bp->b_flags |= LIBXFS_B_DIRTY;
-			libxfs_putbufr(bp);
-		}
-
-		blk += len;
-		if (dptr)
-			dptr += BBTOB(len);
-		len = min(end_blk - blk, len);
-	}
-
-	return 0;
-}
-
-int
-libxfs_log_header(
-	char			*caddr,
-	uuid_t			*fs_uuid,
-	int			version,
-	int			sunit,
-	int			fmt,
-	xfs_lsn_t		lsn,
-	xfs_lsn_t		tail_lsn,
-	libxfs_get_block_t	*nextfunc,
-	void			*private)
-{
-	xlog_rec_header_t	*head = (xlog_rec_header_t *)caddr;
-	char			*p = caddr;
-	__be32			cycle_lsn;
-	int			i, len;
-	int			hdrs = 1;
-
-	if (lsn == NULLCOMMITLSN)
-		lsn = xlog_assign_lsn(XLOG_INIT_CYCLE, 0);
-	if (tail_lsn == NULLCOMMITLSN)
-		tail_lsn = lsn;
-
-	len = ((version == 2) && sunit) ? BTOBB(sunit) : 1;
-
-	memset(p, 0, BBSIZE);
-	head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
-	head->h_cycle = cpu_to_be32(CYCLE_LSN(lsn));
-	head->h_version = cpu_to_be32(version);
-	head->h_crc = cpu_to_le32(0);
-	head->h_prev_block = cpu_to_be32(-1);
-	head->h_num_logops = cpu_to_be32(1);
-	head->h_fmt = cpu_to_be32(fmt);
-	head->h_size = cpu_to_be32(max(sunit, XLOG_BIG_RECORD_BSIZE));
-
-	head->h_lsn = cpu_to_be64(lsn);
-	head->h_tail_lsn = cpu_to_be64(tail_lsn);
-
-	memcpy(&head->h_fs_uuid, fs_uuid, sizeof(uuid_t));
-
-	/*
-	 * The kernel expects to see either a log record header magic value or
-	 * the LSN cycle at the top of every log block. The first word of each
-	 * non-header block is copied to the record headers and replaced with
-	 * the cycle value (see xlog_[un]pack_data() and xlog_get_cycle() for
-	 * details).
-	 *
-	 * Even though we only ever write an unmount record (one block), we
-	 * support writing log records up to the max log buffer size of 256k to
-	 * improve log format performance. This means a record can require up
-	 * to 8 headers (1 rec. header + 7 ext. headers) for the packed cycle
-	 * data (each header supports 32k of data).
-	 */
-	cycle_lsn = CYCLE_LSN_DISK(head->h_lsn);
-	if (version == 2 && sunit > XLOG_HEADER_CYCLE_SIZE) {
-		hdrs = sunit / XLOG_HEADER_CYCLE_SIZE;
-		if (sunit % XLOG_HEADER_CYCLE_SIZE)
-			hdrs++;
-	}
-
-	/*
-	 * A fixed number of extended headers is expected based on h_size. If
-	 * required, format those now so the unmount record is located
-	 * correctly.
-	 *
-	 * Since we only write an unmount record, we only need one h_cycle_data
-	 * entry for the unmount record block. The subsequent record data
-	 * blocks are zeroed, which means we can stamp them directly with the
-	 * cycle and zero the rest of the cycle data in the extended headers.
-	 */
-	if (hdrs > 1) {
-		for (i = 1; i < hdrs; i++) {
-			p = nextfunc(p, BBSIZE, private);
-			memset(p, 0, BBSIZE);
-			/* xlog_rec_ext_header.xh_cycle */
-			*(__be32 *)p = cycle_lsn;
-		}
-	}
-
-	/*
-	 * The total length is the max of the stripe unit or 2 basic block
-	 * minimum (1 hdr blk + 1 data blk). The record length is the total
-	 * minus however many header blocks are required.
-	 */
-	head->h_len = cpu_to_be32(max(BBTOB(2), sunit) - hdrs * BBSIZE);
-
-	/*
-	 * Write out the unmount record, pack the first word into the record
-	 * header and stamp the block with the cycle.
-	 */
-	p = nextfunc(p, BBSIZE, private);
-	unmount_record(p);
-
-	head->h_cycle_data[0] = *(__be32 *)p;
-	*(__be32 *)p = cycle_lsn;
-
-	/*
-	 * Finally, zero all remaining blocks in the record and stamp each with
-	 * the cycle. We don't need to pack any of these blocks because the
-	 * cycle data in the headers has already been zeroed.
-	 */
-	len = max(len, hdrs + 1);
-	for (i = hdrs + 1; i < len; i++) {
-		p = nextfunc(p, BBSIZE, private);
-		memset(p, 0, BBSIZE);
-		*(__be32 *)p = cycle_lsn;
-	}
-
-	return BBTOB(len);
-}
-
 /*
  * Simple I/O (buffer cache) interface
  */
@@ -1601,3 +1365,240 @@ xfs_buf_delwri_submit(
 
 	return error;
 }
+
+/*
+ * Format the log. The caller provides either a buftarg which is used to access
+ * the log via buffers or a direct pointer to a buffer that encapsulates the
+ * entire log.
+ */
+int
+libxfs_log_clear(
+	struct xfs_buftarg	*btp,
+	char			*dptr,
+	xfs_daddr_t		start,
+	uint			length,		/* basic blocks */
+	uuid_t			*fs_uuid,
+	int			version,
+	int			sunit,		/* bytes */
+	int			fmt,
+	int			cycle,
+	bool			max)
+{
+	struct xfs_buf		*bp = NULL;
+	int			len;
+	xfs_lsn_t		lsn;
+	xfs_lsn_t		tail_lsn;
+	xfs_daddr_t		blk;
+	xfs_daddr_t		end_blk;
+	char			*ptr;
+
+	if (((btp && dptr) || (!btp && !dptr)) ||
+	    (btp && !btp->dev) || !fs_uuid)
+		return -EINVAL;
+
+	/* first zero the log */
+	if (btp)
+		libxfs_device_zero(btp, start, length);
+	else
+		memset(dptr, 0, BBTOB(length));
+
+	/*
+	 * Initialize the log record length and LSNs. XLOG_INIT_CYCLE is a
+	 * special reset case where we only write a single record where the lsn
+	 * and tail_lsn match. Otherwise, the record lsn starts at block 0 of
+	 * the specified cycle and points tail_lsn at the last record of the
+	 * previous cycle.
+	 */
+	len = ((version == 2) && sunit) ? BTOBB(sunit) : 2;
+	len = max(len, 2);
+	lsn = xlog_assign_lsn(cycle, 0);
+	if (cycle == XLOG_INIT_CYCLE)
+		tail_lsn = lsn;
+	else
+		tail_lsn = xlog_assign_lsn(cycle - 1, length - len);
+
+	/* write out the first log record */
+	ptr = dptr;
+	if (btp) {
+		bp = libxfs_getbufr(btp, start, len);
+		ptr = bp->b_addr;
+	}
+	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
+			  next, bp);
+	if (bp) {
+		bp->b_flags |= LIBXFS_B_DIRTY;
+		libxfs_putbufr(bp);
+	}
+
+	/*
+	 * There's nothing else to do if this is a log reset. The kernel detects
+	 * the rest of the log is zeroed and starts at cycle 1.
+	 */
+	if (cycle == XLOG_INIT_CYCLE)
+		return 0;
+
+	/*
+	 * Bump the record size for a full log format if the caller allows it.
+	 * This is primarily for performance reasons and most callers don't care
+	 * about record size since the log is clean after we're done.
+	 */
+	if (max)
+		len = BTOBB(BDSTRAT_SIZE);
+
+	/*
+	 * Otherwise, fill everything beyond the initial record with records of
+	 * the previous cycle so the kernel head/tail detection works correctly.
+	 *
+	 * We don't particularly care about the record size or content here.
+	 * It's only important that the headers are in place such that the
+	 * kernel finds 1.) a clean log and 2.) the correct current cycle value.
+	 * Therefore, bump up the record size to the max to use larger I/Os and
+	 * improve performance.
+	 */
+	cycle--;
+	blk = start + len;
+	if (dptr)
+		dptr += BBTOB(len);
+	end_blk = start + length;
+
+	len = min(end_blk - blk, len);
+	while (blk < end_blk) {
+		lsn = xlog_assign_lsn(cycle, blk - start);
+		tail_lsn = xlog_assign_lsn(cycle, blk - start - len);
+
+		ptr = dptr;
+		if (btp) {
+			bp = libxfs_getbufr(btp, blk, len);
+			ptr = bp->b_addr;
+		}
+		/*
+		 * Note: pass the full buffer length as the sunit to initialize
+		 * the entire buffer.
+		 */
+		libxfs_log_header(ptr, fs_uuid, version, BBTOB(len), fmt, lsn,
+				  tail_lsn, next, bp);
+		if (bp) {
+			bp->b_flags |= LIBXFS_B_DIRTY;
+			libxfs_putbufr(bp);
+		}
+
+		blk += len;
+		if (dptr)
+			dptr += BBTOB(len);
+		len = min(end_blk - blk, len);
+	}
+
+	return 0;
+}
+
+int
+libxfs_log_header(
+	char			*caddr,
+	uuid_t			*fs_uuid,
+	int			version,
+	int			sunit,
+	int			fmt,
+	xfs_lsn_t		lsn,
+	xfs_lsn_t		tail_lsn,
+	libxfs_get_block_t	*nextfunc,
+	void			*private)
+{
+	xlog_rec_header_t	*head = (xlog_rec_header_t *)caddr;
+	char			*p = caddr;
+	__be32			cycle_lsn;
+	int			i, len;
+	int			hdrs = 1;
+
+	if (lsn == NULLCOMMITLSN)
+		lsn = xlog_assign_lsn(XLOG_INIT_CYCLE, 0);
+	if (tail_lsn == NULLCOMMITLSN)
+		tail_lsn = lsn;
+
+	len = ((version == 2) && sunit) ? BTOBB(sunit) : 1;
+
+	memset(p, 0, BBSIZE);
+	head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
+	head->h_cycle = cpu_to_be32(CYCLE_LSN(lsn));
+	head->h_version = cpu_to_be32(version);
+	head->h_crc = cpu_to_le32(0);
+	head->h_prev_block = cpu_to_be32(-1);
+	head->h_num_logops = cpu_to_be32(1);
+	head->h_fmt = cpu_to_be32(fmt);
+	head->h_size = cpu_to_be32(max(sunit, XLOG_BIG_RECORD_BSIZE));
+
+	head->h_lsn = cpu_to_be64(lsn);
+	head->h_tail_lsn = cpu_to_be64(tail_lsn);
+
+	memcpy(&head->h_fs_uuid, fs_uuid, sizeof(uuid_t));
+
+	/*
+	 * The kernel expects to see either a log record header magic value or
+	 * the LSN cycle at the top of every log block. The first word of each
+	 * non-header block is copied to the record headers and replaced with
+	 * the cycle value (see xlog_[un]pack_data() and xlog_get_cycle() for
+	 * details).
+	 *
+	 * Even though we only ever write an unmount record (one block), we
+	 * support writing log records up to the max log buffer size of 256k to
+	 * improve log format performance. This means a record can require up
+	 * to 8 headers (1 rec. header + 7 ext. headers) for the packed cycle
+	 * data (each header supports 32k of data).
+	 */
+	cycle_lsn = CYCLE_LSN_DISK(head->h_lsn);
+	if (version == 2 && sunit > XLOG_HEADER_CYCLE_SIZE) {
+		hdrs = sunit / XLOG_HEADER_CYCLE_SIZE;
+		if (sunit % XLOG_HEADER_CYCLE_SIZE)
+			hdrs++;
+	}
+
+	/*
+	 * A fixed number of extended headers is expected based on h_size. If
+	 * required, format those now so the unmount record is located
+	 * correctly.
+	 *
+	 * Since we only write an unmount record, we only need one h_cycle_data
+	 * entry for the unmount record block. The subsequent record data
+	 * blocks are zeroed, which means we can stamp them directly with the
+	 * cycle and zero the rest of the cycle data in the extended headers.
+	 */
+	if (hdrs > 1) {
+		for (i = 1; i < hdrs; i++) {
+			p = nextfunc(p, BBSIZE, private);
+			memset(p, 0, BBSIZE);
+			/* xlog_rec_ext_header.xh_cycle */
+			*(__be32 *)p = cycle_lsn;
+		}
+	}
+
+	/*
+	 * The total length is the max of the stripe unit or 2 basic block
+	 * minimum (1 hdr blk + 1 data blk). The record length is the total
+	 * minus however many header blocks are required.
+	 */
+	head->h_len = cpu_to_be32(max(BBTOB(2), sunit) - hdrs * BBSIZE);
+
+	/*
+	 * Write out the unmount record, pack the first word into the record
+	 * header and stamp the block with the cycle.
+	 */
+	p = nextfunc(p, BBSIZE, private);
+	unmount_record(p);
+
+	head->h_cycle_data[0] = *(__be32 *)p;
+	*(__be32 *)p = cycle_lsn;
+
+	/*
+	 * Finally, zero all remaining blocks in the record and stamp each with
+	 * the cycle. We don't need to pack any of these blocks because the
+	 * cycle data in the headers has already been zeroed.
+	 */
+	len = max(len, hdrs + 1);
+	for (i = hdrs + 1; i < len; i++) {
+		p = nextfunc(p, BBSIZE, private);
+		memset(p, 0, BBSIZE);
+		*(__be32 *)p = cycle_lsn;
+	}
+
+	return BBTOB(len);
+}
+

