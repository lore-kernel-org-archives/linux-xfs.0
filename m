Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F65CC35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 751B121927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aNcgNk9g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgBYASD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:18:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40448 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYASC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:18:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08iwQ130032;
        Tue, 25 Feb 2020 00:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ieTXA5CuoKKlwYe63POT7HQgx1WVPmUYHc2KXvhChtM=;
 b=aNcgNk9gA3B7bNEDTA0gUI3VBlkZGhAy/FTrfXM0nUw9T9qLxjCn5WmlRKF1SOcuPcvv
 6PFgWvHbGYAAim2HT2fh/aVyAwTqozcTo7JfUcE+6zhSQEHrIV9fI6UqbRPWeDytNE8q
 VjNYMGxakhQhLtpEfCYW/jGro+fLKkkY6aLu7WQ9kX58ZRcGoK4B7P2gYCt3OlsO5STh
 q8y8ItCHu+LIAyEb62DjBXMgsoztVPJN6O5Ph2Jux160U6oyK9PXJFYaY+OdqGGXl0CY
 JElr9BG9ZcMw1uyh9MrtfixFzQt4mGREdR8uKXNqOOUahJcg03514VLltzd0B9L6q3t0 pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yavxrjs5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P0887r158211;
        Tue, 25 Feb 2020 00:13:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yby5e9peb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:57 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0DueC000743;
        Tue, 25 Feb 2020 00:13:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:13:55 -0800
Subject: [PATCH 23/25] libxfs: hide libxfs_getbuf_flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:13:55 -0800
Message-ID: <158258963505.451378.4733113816526643723.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=761 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=818
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
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
index e46f749c..4b33c20d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -150,7 +150,6 @@ static char *next(
 #undef libxfs_readbuf_map
 #undef libxfs_writebuf
 #undef libxfs_getbuf_map
-#undef libxfs_getbuf_flags
 
 xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
@@ -159,8 +158,6 @@ struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
 				size_t len);
 xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int);
-xfs_buf_t	*libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t, int,
-				unsigned int);
 void		libxfs_buf_relse(struct xfs_buf *bp);
 
 #define	__add_trace(bp, func, file, line)	\
@@ -229,15 +226,6 @@ libxfs_trace_getbuf_map(const char *func, const char *file, int line,
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
@@ -542,9 +530,12 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
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
 

