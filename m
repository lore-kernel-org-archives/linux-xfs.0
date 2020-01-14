Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2675C33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752E520678
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EvswTNS1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgANGcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 01:32:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgANGcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 01:32:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6D1Ap133872;
        Tue, 14 Jan 2020 06:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LT6SORQZURtlnpboa9/4aZL0XTzFMqpRd6Ot6eblco4=;
 b=EvswTNS1/7hDcnKepdFzgoDrRrjBy+ggry2kojza2jSmjm5+CZZVSo6JFNzH+OaQC/bD
 YCou2eN4Xynt2X93Ddegg7R4gQ7pxk+qZzzTbQeAo/WbxUCncIsPpnIRc/GLYuIuD7ir
 /nyTh/GemL8Xl2VtqN74y3qlTVTkFXLlp3u3LjUaWxV57O0TdVUvHWbw/T1PQ7CYvHy2
 HgGiRsxCYz1LadGHhohjmyjDunc98jU/tS3tcLC9ZqO3/3838267AlIgyAFoS65Oi29K
 bYuRsFFkkVNkMph94GXofRYFB/O2JB5kHxUZBzq1XelT1y+tA5WZWU8YwEhkYibwgWpo WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73ybv6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:32:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6TC5r045446;
        Tue, 14 Jan 2020 06:32:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xh30yxet6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:32:11 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00E6WAHL032224;
        Tue, 14 Jan 2020 06:32:10 GMT
Received: from localhost (/10.159.236.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 22:32:10 -0800
Subject: [PATCH 6/6] xfs: check log iovec size to make sure it's plausibly a
 buffer log format
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 13 Jan 2020 22:32:09 -0800
Message-ID: <157898352983.1566005.3041225371468613382.stgit@magnolia>
In-Reply-To: <157898348940.1566005.3231891474158666998.stgit@magnolia>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=971
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140055
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When log recovery is processing buffer log items, we should check that
the incoming iovec actually describes a region of memory large enough to
contain the log format and the dirty map.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

