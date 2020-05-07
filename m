Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C39C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C06C720735
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EQSHYdt3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgEGBB5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:01:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgEGBB5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:01:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470w4AT130682;
        Thu, 7 May 2020 01:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8YDVd7tVlmmIKmuJKxj+S/kExig2NCEwObG6lhKuf94=;
 b=EQSHYdt3VaAe/ZN/H5XbhPx52bj7/upsHleJE11WlTIcpVH8R2Fu3HPrqoYzLHoeumCr
 YtzD1KpGhk0xwjt8/x7FCAL9VPrpC9DBR9MfNKsm2cT4vFIa4WRc/8x/s73Yd5mL5FX4
 n/AMLv66dHKmTYE08wr891XChddj5eJxlI8lc30ba+eX4tWdUtbyyAmICcqaRJW7VZkk
 bpfNdCiVCut2SJHEv1a6eYKNfRUA4gNIPDeUdFZcUOMSRMWWnEqe5h0Mm+5QNhE4XTCL
 202tY1WU8Cg7dIT270aw/uW5xaT8Pg6GzvzRoKqrZC4EyJMBdESuKbzX0oMxFcFNPr48 Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gnda1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:01:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470uopl190066;
        Thu, 7 May 2020 01:01:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjdwssg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:01:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04711n5v028068;
        Thu, 7 May 2020 01:01:49 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:01:49 -0700
Subject: [PATCH 01/25] xfs: convert xfs_log_recover_item_t to struct
 xfs_log_recover_item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:01:45 -0700
Message-ID: <158881330585.189971.13699718949079990321.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the old typedefs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |    4 ++--
 fs/xfs/xfs_log_recover.c        |   26 ++++++++++++++------------
 2 files changed, 16 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 3bf671637a91..148e0cb5d379 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -22,13 +22,13 @@
 /*
  * item headers are in ri_buf[0].  Additional buffers follow.
  */
-typedef struct xlog_recover_item {
+struct xlog_recover_item {
 	struct list_head	ri_list;
 	int			ri_type;
 	int			ri_cnt;	/* count of regions found */
 	int			ri_total;	/* total regions */
 	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
-} xlog_recover_item_t;
+};
 
 struct xlog_recover {
 	struct hlist_node	r_list;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 320785115833..ed4ed76f8e9c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1841,7 +1841,7 @@ xlog_recover_reorder_trans(
 	struct xlog_recover	*trans,
 	int			pass)
 {
-	xlog_recover_item_t	*item, *n;
+	struct xlog_recover_item *item, *n;
 	int			error = 0;
 	LIST_HEAD(sort_list);
 	LIST_HEAD(cancel_list);
@@ -2056,7 +2056,7 @@ xlog_recover_buffer_pass1(
 STATIC int
 xlog_recover_do_inode_buffer(
 	struct xfs_mount	*mp,
-	xlog_recover_item_t	*item,
+	struct xlog_recover_item *item,
 	struct xfs_buf		*bp,
 	xfs_buf_log_format_t	*buf_f)
 {
@@ -2561,7 +2561,7 @@ xlog_recover_validate_buf_type(
 STATIC void
 xlog_recover_do_reg_buffer(
 	struct xfs_mount	*mp,
-	xlog_recover_item_t	*item,
+	struct xlog_recover_item *item,
 	struct xfs_buf		*bp,
 	xfs_buf_log_format_t	*buf_f,
 	xfs_lsn_t		current_lsn)
@@ -3759,7 +3759,7 @@ STATIC int
 xlog_recover_do_icreate_pass2(
 	struct xlog		*log,
 	struct list_head	*buffer_list,
-	xlog_recover_item_t	*item)
+	struct xlog_recover_item *item)
 {
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_icreate_log	*icl;
@@ -4134,9 +4134,9 @@ STATIC void
 xlog_recover_add_item(
 	struct list_head	*head)
 {
-	xlog_recover_item_t	*item;
+	struct xlog_recover_item *item;
 
-	item = kmem_zalloc(sizeof(xlog_recover_item_t), 0);
+	item = kmem_zalloc(sizeof(struct xlog_recover_item), 0);
 	INIT_LIST_HEAD(&item->ri_list);
 	list_add_tail(&item->ri_list, head);
 }
@@ -4148,7 +4148,7 @@ xlog_recover_add_to_cont_trans(
 	char			*dp,
 	int			len)
 {
-	xlog_recover_item_t	*item;
+	struct xlog_recover_item *item;
 	char			*ptr, *old_ptr;
 	int			old_len;
 
@@ -4171,7 +4171,8 @@ xlog_recover_add_to_cont_trans(
 	}
 
 	/* take the tail entry */
-	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
+	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
+			  ri_list);
 
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
@@ -4205,7 +4206,7 @@ xlog_recover_add_to_trans(
 	int			len)
 {
 	struct xfs_inode_log_format	*in_f;			/* any will do */
-	xlog_recover_item_t	*item;
+	struct xlog_recover_item *item;
 	char			*ptr;
 
 	if (!len)
@@ -4241,13 +4242,14 @@ xlog_recover_add_to_trans(
 	in_f = (struct xfs_inode_log_format *)ptr;
 
 	/* take the tail entry */
-	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
+	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
+			  ri_list);
 	if (item->ri_total != 0 &&
 	     item->ri_total == item->ri_cnt) {
 		/* tail item is in use, get a new one */
 		xlog_recover_add_item(&trans->r_itemq);
 		item = list_entry(trans->r_itemq.prev,
-					xlog_recover_item_t, ri_list);
+					struct xlog_recover_item, ri_list);
 	}
 
 	if (item->ri_total == 0) {		/* first region to be added */
@@ -4293,7 +4295,7 @@ STATIC void
 xlog_recover_free_trans(
 	struct xlog_recover	*trans)
 {
-	xlog_recover_item_t	*item, *n;
+	struct xlog_recover_item *item, *n;
 	int			i;
 
 	hlist_del_init(&trans->r_list);

