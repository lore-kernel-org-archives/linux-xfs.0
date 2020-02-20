Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21807C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E078F21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jKTYNTBR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTBr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:47:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTBr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:47:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1h0sP092840;
        Thu, 20 Feb 2020 01:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1sQJlrMBRnKW49mEj4lyKPJ+1Pfu19sQGB2tLz0S1xE=;
 b=jKTYNTBRvEzTeGAfOiuXgBNBQKQzNVu1tbpOvuqXz1KlDURShXCVHbYStWUAFFlLgLT4
 o/UCFjBL23yL7TaRU2E/IYrclb1Tr+EAiD1PT8egpk5hFHNURq0Nei2KMbfZOAoVt/sD
 VkSOol6ZAK4nftEB6Tg7yERolcxUDdHg+eR4sEuzWSMxI4F+2PVtRl8vntpH2iWNkLTa
 Hme1UXt4NAWy2mSPALp8KCKIcoKEbL8P+LoOhh22H46fh7vRU1RYYXUb5CIeGQO1khgZ
 j38iiyxnoKyGjoEi1KxssZp94Jyoa6jUo7iZjaNZS/culL4ClvhFhm08uSJSkFbgn+aE bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y8udd6trx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:47:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gJ8g189105;
        Thu, 20 Feb 2020 01:45:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8ud9760v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:22 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1jLsl007198;
        Thu, 20 Feb 2020 01:45:21 GMT
Received: from localhost (/67.169.218.210) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Wed, 19 Feb 2020 17:44:28 -0800
USER-AGENT: StGit/0.17.1-dirty
MIME-Version: 1.0
Message-ID: <158216306760.602314.2873425161697294878.stgit@magnolia>
Date:   Wed, 19 Feb 2020 17:44:27 -0800 (PST)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/18] libxfs: rename libxfs_getbuf_map to libxfs_buf_get_map
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename this function to match the kernel function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    6 +++---
 libxfs/rdwr.c      |   16 ++++++++--------
 libxfs/trans.c     |    4 ++--
 repair/prefetch.c  |    2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 8e9af208..2a451ab2 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -144,7 +144,7 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_get(dev, daddr, len) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len))
-#define libxfs_getbuf_map(dev, map, nmaps, flags) \
+#define libxfs_buf_get_map(dev, map, nmaps, flags) \
 	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags))
 #define libxfs_buf_relse(buf) \
@@ -171,7 +171,7 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 extern xfs_buf_t *libxfs_buf_read_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
 void libxfs_buf_dirty(struct xfs_buf *bp, int flags);
-extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
+extern xfs_buf_t *libxfs_buf_get_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
 void	libxfs_buf_relse(struct xfs_buf *);
 
@@ -183,7 +183,7 @@ libxfs_buf_get(
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return libxfs_getbuf_map(target, &map, 1, 0);
+	return libxfs_buf_get_map(target, &map, 1, 0);
 }
 
 static inline struct xfs_buf*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 531f24e3..52674559 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -387,14 +387,14 @@ libxfs_log_header(
 
 #undef libxfs_buf_read_map
 #undef libxfs_writebuf
-#undef libxfs_getbuf_map
+#undef libxfs_buf_get_map
 
 xfs_buf_t	*libxfs_buf_read_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
 int		libxfs_writebuf(xfs_buf_t *, int);
 struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
 				size_t len);
-xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
+xfs_buf_t	*libxfs_buf_get_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int);
 void		libxfs_buf_relse(struct xfs_buf *);
 
@@ -450,7 +450,7 @@ libxfs_trace_getbuf(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	bp = libxfs_getbuf_map(target, &map, 1, 0);
+	bp = libxfs_buf_get_map(target, &map, 1, 0);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -460,7 +460,7 @@ libxfs_trace_getbuf_map(const char *func, const char *file, int line,
 		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		int flags)
 {
-	xfs_buf_t	*bp = libxfs_getbuf_map(btp, map, nmaps, flags);
+	xfs_buf_t	*bp = libxfs_buf_get_map(btp, map, nmaps, flags);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -805,7 +805,7 @@ reset_buf_state(
 }
 
 static struct xfs_buf *
-__libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
+__libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 		    int nmaps, int flags)
 {
 	struct xfs_bufkey key = {NULL};
@@ -827,12 +827,12 @@ __libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 }
 
 struct xfs_buf *
-libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
+libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 		  int nmaps, int flags)
 {
 	struct xfs_buf	*bp;
 
-	bp = __libxfs_getbuf_map(btp, map, nmaps, flags);
+	bp = __libxfs_buf_get_map(btp, map, nmaps, flags);
 	reset_buf_state(bp);
 	return bp;
 }
@@ -1036,7 +1036,7 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
 					flags, ops);
 
-	bp = __libxfs_getbuf_map(btp, map, nmaps, 0);
+	bp = __libxfs_buf_get_map(btp, map, nmaps, 0);
 	if (!bp)
 		return NULL;
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index f532e3d6..f4ce23a7 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -427,7 +427,7 @@ libxfs_trans_get_buf_map(
 	struct xfs_buf_log_item	*bip;
 
 	if (!tp)
-		return libxfs_getbuf_map(target, map, nmaps, 0);
+		return libxfs_buf_get_map(target, map, nmaps, 0);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -445,7 +445,7 @@ libxfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = libxfs_getbuf_map(target, map, nmaps, 0);
+	bp = libxfs_buf_get_map(target, map, nmaps, 0);
 	if (bp == NULL) {
 		return NULL;
 	}
diff --git a/repair/prefetch.c b/repair/prefetch.c
index a3858f9a..7f705cc0 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -120,7 +120,7 @@ pf_queue_io(
 	 * the lock holder is either reading it from disk himself or
 	 * completely overwriting it this behaviour is perfectly fine.
 	 */
-	bp = libxfs_getbuf_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK);
+	bp = libxfs_buf_get_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK);
 	if (!bp)
 		return;
 

