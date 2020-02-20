Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C34C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAD5E21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TwnsVI2I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgBTBoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:44:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34582 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:44:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hJWI064443;
        Thu, 20 Feb 2020 01:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=C6jDziIBegjb8Uwoj/2XST1lr36u+2RT1EaUFeBV2T4=;
 b=TwnsVI2IKvDnX/XOhpuFIVZ03eywBo3ETa/FdNwL0m2r51+klXuErA4TXc2br/bOxdrN
 kQEQa+7VXgYdB6PFiVajzwjaWZ6stIIOOGQxu9jJXbtR6SX6T+Sqryfx+7d7tKsdD6gz
 854KZY/iBPGcm5Ihw207bknBxTZP54IzPW7tGO/lypzITd8KIw8IZmjZ5EbA3Guak8Pp
 O0NFfEvyFV3PebQ2rM6eqlDVhXs1Agac8ADlPOx13Kkxlsd7RnbLesgdOuVPnp1i8jHF
 VGOembOH/ydYtG4rsoH4CzxCryYBl6NT8YcV+IUEGsmI2UiWxOAvwFvDZOk20nVLmWxK WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8udket2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gRfn094696;
        Thu, 20 Feb 2020 01:44:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8udbmhrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:16 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1iGpF002612;
        Thu, 20 Feb 2020 01:44:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:44:16 -0800
Subject: [PATCH 16/18] libxfs: hide libxfs_getbuf_flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:44:15 -0800
Message-ID: <158216305519.602314.7497657265091013884.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=748 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=803 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hide this function since it's internal to rdwr.c.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    7 -------
 libxfs/rdwr.c      |   21 ++++++---------------
 2 files changed, 6 insertions(+), 22 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 7d96c2a3..32f8fde7 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -147,9 +147,6 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_getbuf_map(dev, map, nmaps, flags) \
 	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags))
-#define libxfs_getbuf_flags(dev, daddr, len, flags) \
-	libxfs_trace_getbuf_flags(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (daddr), (len), (flags))
 #define libxfs_buf_relse(buf) \
 	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
@@ -166,8 +163,6 @@ struct xfs_buf *libxfs_trace_getbuf(const char *func, const char *file,
 			size_t len);
 extern xfs_buf_t *libxfs_trace_getbuf_map(const char *, const char *, int,
 			struct xfs_buftarg *, struct xfs_buf_map *, int, int);
-extern xfs_buf_t *libxfs_trace_getbuf_flags(const char *, const char *, int,
-			struct xfs_buftarg *, xfs_daddr_t, int, unsigned int);
 extern void	libxfs_trace_putbuf (const char *, const char *, int,
 			xfs_buf_t *);
 
@@ -178,8 +173,6 @@ extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 void libxfs_buf_dirty(struct xfs_buf *bp, int flags);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
-extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
-			int, unsigned int);
 void	libxfs_buf_relse(struct xfs_buf *);
 
 static inline struct xfs_buf*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index bab70dfd..f46787a6 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -388,7 +388,6 @@ libxfs_log_header(
 #undef libxfs_readbuf_map
 #undef libxfs_writebuf
 #undef libxfs_getbuf_map
-#undef libxfs_getbuf_flags
 
 xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
@@ -397,8 +396,6 @@ struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
 				size_t len);
 xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int);
-xfs_buf_t	*libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t, int,
-				unsigned int);
 void		libxfs_buf_relse(struct xfs_buf *);
 
 #define	__add_trace(bp, func, file, line)	\
@@ -468,15 +465,6 @@ libxfs_trace_getbuf_map(const char *func, const char *file, int line,
 	return bp;
 }
 
-xfs_buf_t *
-libxfs_trace_getbuf_flags(const char *func, const char *file, int line,
-		struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, unsigned int flags)
-{
-	xfs_buf_t	*bp = libxfs_getbuf_flags(btp, blkno, len, flags);
-	__add_trace(bp, func, file, line);
-	return bp;
-}
-
 void
 libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
 {
@@ -780,9 +768,12 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 	return NULL;
 }
 
-struct xfs_buf *
-libxfs_getbuf_flags(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len,
-		unsigned int flags)
+static struct xfs_buf *
+libxfs_getbuf_flags(
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		blkno,
+	int			len,
+	unsigned int		flags)
 {
 	struct xfs_bufkey key = {NULL};
 

