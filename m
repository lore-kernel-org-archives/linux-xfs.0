Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5477CC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D932469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LC+AhFdd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgB1XjI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:39:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53998 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1XjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:39:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXc5D069480;
        Fri, 28 Feb 2020 23:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bJfB+lANcpb8862vxfc63b7b8DfXDGssoBROWLinylA=;
 b=LC+AhFddMOxkynvqC9L5DyRkOeCP9NYSTSt0rAn2MQl2v6bbsQdp2NsxaRrrAzKsUqRH
 1XtEH5JUUDaELj0GU8DiVqsk5mNSwG/JG2d6J6jQryVSW2LHX8jureDK4aVH4cin5Dl8
 K9oiMepix4viR0G/TrV7ipLdeg/h11bZjTOe6Kq+qGUzFQrOnYnk5TSrppd3JlI6mfgx
 AKUqn8FAC4fkOXVVwDJINIyW6R1UM772gkoIY/uWTrrKVB2zVZIlWGJ/n2bAysqjzybf
 kET3qa0gLEPVUGYqOC/64Y1oZrwzLWpYpDy0FT6CLmoKJaWYyIMgmO00a4iXHQRfW6zB Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ydcsnwxg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWCdg165605;
        Fri, 28 Feb 2020 23:37:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ydj4s31ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNb1q1024294;
        Fri, 28 Feb 2020 23:37:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:01 -0800
Subject: [PATCH 07/26] libxfs: rename libxfs_writebufr to libxfs_bwrite
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:37:00 -0800
Message-ID: <158293302026.1549542.11606082894335329556.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename this function so that we have an API that matches the kernel
without a #define.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/io.c                  |    4 ++--
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_io.h       |    2 +-
 libxfs/libxfs_priv.h     |    1 -
 libxfs/rdwr.c            |   11 ++++++-----
 5 files changed, 10 insertions(+), 9 deletions(-)


diff --git a/db/io.c b/db/io.c
index 163ccc89..7c7a4624 100644
--- a/db/io.c
+++ b/db/io.c
@@ -426,7 +426,7 @@ write_cur_buf(void)
 {
 	int ret;
 
-	ret = -libxfs_writebufr(iocur_top->bp);
+	ret = -libxfs_bwrite(iocur_top->bp);
 	if (ret != 0)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
@@ -442,7 +442,7 @@ write_cur_bbs(void)
 {
 	int ret;
 
-	ret = -libxfs_writebufr(iocur_top->bp);
+	ret = -libxfs_bwrite(iocur_top->bp);
 	if (ret != 0)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 57cf5f83..df267c98 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -48,6 +48,7 @@
 #define xfs_buf_read			libxfs_buf_read
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_bunmapi			libxfs_bunmapi
+#define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
 #define xfs_da_get_buf			libxfs_da_get_buf
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 1b8318af..0370d685 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -220,7 +220,7 @@ extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
 extern void	libxfs_putbufr(xfs_buf_t *);
 
 extern int	libxfs_writebuf_int(xfs_buf_t *, int);
-extern int	libxfs_writebufr(struct xfs_buf *);
+int		libxfs_bwrite(struct xfs_buf *bp);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
 extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 0f26120f..5d6dd063 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -377,7 +377,6 @@ roundup_64(uint64_t x, uint32_t y)
 	(len) = __bar; /* no set-but-unused warning */	\
 	NULL;						\
 })
-#define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 
 #define XBRW_READ			LIBXFS_BREAD
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7b91ebf6..bbec1135 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1090,9 +1090,10 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
 }
 
 int
-libxfs_writebufr(xfs_buf_t *bp)
+libxfs_bwrite(
+	struct xfs_buf	*bp)
 {
-	int	fd = libxfs_device_to_fd(bp->b_target->dev);
+	int		fd = libxfs_device_to_fd(bp->b_target->dev);
 
 	/*
 	 * we never write buffers that are marked stale. This indicates they
@@ -1301,7 +1302,7 @@ libxfs_bflush(
 	struct xfs_buf		*bp = (struct xfs_buf *)node;
 
 	if (!bp->b_error && bp->b_flags & LIBXFS_B_DIRTY)
-		return libxfs_writebufr(bp);
+		return libxfs_bwrite(bp);
 	return bp->b_error;
 }
 
@@ -1309,7 +1310,7 @@ void
 libxfs_putbufr(xfs_buf_t *bp)
 {
 	if (bp->b_flags & LIBXFS_B_DIRTY)
-		libxfs_writebufr(bp);
+		libxfs_bwrite(bp);
 	libxfs_brelse((struct cache_node *)bp);
 }
 
@@ -1522,7 +1523,7 @@ xfs_buf_delwri_submit(
 
 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
 		list_del_init(&bp->b_list);
-		error2 = libxfs_writebufr(bp);
+		error2 = libxfs_bwrite(bp);
 		if (!error)
 			error = error2;
 		libxfs_buf_relse(bp);

