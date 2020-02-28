Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15352C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD9882469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lwy285fC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB1Xkw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45584 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB1Xkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNclgr032343;
        Fri, 28 Feb 2020 23:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8I88JyBApAZND40q+nGXcr+SaCcfkIKyNNVXVrqgqws=;
 b=Lwy285fCUZzNimDhNKy2h4TnB+MiEn3MazUWUzk9ZceFRCen4emjK16lILvDwjKz5jZG
 ONvBcr2tAJBstiJH06qzuowY3mE1Gnr0Y0YYkusocYdJ28aJIwS1ltPZIj+dEOYHlir4
 +mkCnVHw5BMdhP60pAMSjIDfAo/JVGYRDISLTmY74Q0KYC/V0lqk4O63iR1UReOnMecK
 1o1oYrOWeIgA4ePQMi3ttcQ75vbIaFudphqhlfJBzMTx1XsvN/1I77gDM7eMF+sJSLVB
 NElMS6wXdP5+G3VWbUZ8FFT+yVVSLhCdE7d/84UY46NUqsIuk6yxsYw9lAJotJN3HO6B cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct3nt6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNamTn112437;
        Fri, 28 Feb 2020 23:38:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ydcsgema6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:47 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNcjsG025533;
        Fri, 28 Feb 2020 23:38:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:38:45 -0800
Subject: [PATCH 23/26] libxfs: hide libxfs_getbuf_flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:38:44 -0800
Message-ID: <158293312471.1549542.11650056882289358552.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=753 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=816 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hide this function since it's internal to rdwr.c.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h |    7 -------
 libxfs/rdwr.c      |   21 ++++++---------------
 2 files changed, 6 insertions(+), 22 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index c69eea97..7f513d86 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -144,9 +144,6 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_getbuf_map(dev, map, nmaps, flags) \
 	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags))
-#define libxfs_getbuf_flags(dev, daddr, len, flags) \
-	libxfs_trace_getbuf_flags(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (daddr), (len), (flags))
 #define libxfs_buf_relse(buf) \
 	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
@@ -163,8 +160,6 @@ struct xfs_buf *libxfs_trace_getbuf(const char *func, const char *file,
 			size_t len);
 extern xfs_buf_t *libxfs_trace_getbuf_map(const char *, const char *, int,
 			struct xfs_buftarg *, struct xfs_buf_map *, int, int);
-extern xfs_buf_t *libxfs_trace_getbuf_flags(const char *, const char *, int,
-			struct xfs_buftarg *, xfs_daddr_t, int, unsigned int);
 extern void	libxfs_trace_putbuf (const char *, const char *, int,
 			xfs_buf_t *);
 
@@ -175,8 +170,6 @@ extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 void libxfs_buf_mark_dirty(struct xfs_buf *bp);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
-extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
-			int, unsigned int);
 void	libxfs_buf_relse(struct xfs_buf *bp);
 
 static inline struct xfs_buf*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 82f15af9..549fe3c1 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -157,7 +157,6 @@ static char *next(
 #undef libxfs_readbuf_map
 #undef libxfs_writebuf
 #undef libxfs_getbuf_map
-#undef libxfs_getbuf_flags
 
 xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
@@ -166,8 +165,6 @@ struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
 				size_t len);
 xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int);
-xfs_buf_t	*libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t, int,
-				unsigned int);
 void		libxfs_buf_relse(struct xfs_buf *bp);
 
 #define	__add_trace(bp, func, file, line)	\
@@ -236,15 +233,6 @@ libxfs_trace_getbuf_map(const char *func, const char *file, int line,
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
@@ -549,9 +537,12 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
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
 

