Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC07EC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C0CC2077B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="os/KMvT7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgAORFx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:05:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37324 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAORFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:05:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhO4n193062;
        Wed, 15 Jan 2020 17:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kg511wtEgfWDulJG1z/7rrdLHyF2PdOTTqYdHd4pwTc=;
 b=os/KMvT7SgSDwhF4INpTXDIKiZ+dgRzDyUpGYPUh9oFIHI9mYKYHSMftXnBtJDrpq0CQ
 wvVdZXuFSuyNJWc+Ijz25oPp/SuqLZVg6JpZxP/ke26s92hC5zs5owvmu0o9dVSd7HxQ
 pR3NgLo4H72xxhlyNGjJBaZkpk0q7rj5+iNzsEZVR4Yx1r9u+Pa9ADzbZY9v6AM1YkSR
 jG0mld7yj/4AlfRQcIQW63nJIwc4O3pvl2X1OngtENrKZbjj8UNWJxd3sgqjjJJoYI0X
 XXuQM1FNIRaEIzohkJnDTZ6M/rJ/dCydlPgRxfFyM2zqT+3k7DxAxZdr9ebo0QeFQaYE xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73twbck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiKbG056633;
        Wed, 15 Jan 2020 17:03:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xhy21r3hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:39 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FH3c3p011792;
        Wed, 15 Jan 2020 17:03:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:38 -0800
Subject: [PATCH 7/7] xfs: check log iovec size to make sure it's plausibly a
 buffer log format
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 15 Jan 2020 09:03:37 -0800
Message-ID: <157910781732.2028015.2172618668264743349.stgit@magnolia>
In-Reply-To: <157910777330.2028015.5017943601641757827.stgit@magnolia>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When log recovery is processing buffer log items, we should check that
the incoming iovec actually describes a region of memory large enough to
contain the log format and the dirty map.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c    |   17 +++++++++++++++++
 fs/xfs/xfs_buf_item.h    |    1 +
 fs/xfs/xfs_log_recover.c |    6 ++++++
 3 files changed, 24 insertions(+)


diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index be691d1d9fad..5be8973a452c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -27,6 +27,23 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 
 STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
+/* Is this log iovec plausibly large enough to contain the buffer log format? */
+bool
+xfs_buf_log_check_iovec(
+	struct xfs_log_iovec		*iovec)
+{
+	struct xfs_buf_log_format	*blfp = iovec->i_addr;
+	char				*bmp_end;
+	char				*item_end;
+
+	if (offsetof(struct xfs_buf_log_format, blf_data_map) > iovec->i_len)
+		return false;
+
+	item_end = (char *)iovec->i_addr + iovec->i_len;
+	bmp_end = (char *)&blfp->blf_data_map[blfp->blf_map_size];
+	return bmp_end <= item_end;
+}
+
 static inline int
 xfs_buf_log_format_size(
 	struct xfs_buf_log_format *blfp)
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 4a054b11011a..30114b510332 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -61,6 +61,7 @@ void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 bool	xfs_buf_resubmit_failed_buffers(struct xfs_buf *,
 					struct list_head *);
+bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
 extern kmem_zone_t	*xfs_buf_item_zone;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 99ec3fba4548..0d683fb96396 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1934,6 +1934,12 @@ xlog_recover_buffer_pass1(
 	struct list_head	*bucket;
 	struct xfs_buf_cancel	*bcp;
 
+	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
+		xfs_err(log->l_mp, "bad buffer log item size (%d)",
+				item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * If this isn't a cancel buffer item, then just return.
 	 */

