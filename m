Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940BCC47257
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C9702082E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LCE8gECP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgEGBFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:05:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbgEGBFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:05:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470wnaA101478;
        Thu, 7 May 2020 01:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CVKh1+2uKwJgA5Cjud4x9MyTRn0ZapLCH1IvlbBHx+c=;
 b=LCE8gECPAs2v3h8j+1NKSRNrlBNrR/I7xMeWpLj+UiCQIuz0Q1k8w6JC2mrv4Mjecc4o
 R0dv5ehuYDYvMYHLe2pNlh0i/U9Pp1zWs/PIXr3/n77+iOTxVb4RGhKiuGDBUXWiaoD1
 vd5uELFQTBNWnJwMJSb2H/ioewP9dLh9kLkGRe1roodZAeM9NSLqy5X8/PPOPQrKi6r7
 8Cdex4HIMRzIXxz+ckHU/KkE5dfSJVLQtZKuXy3YE8z0GAz4aJMe6to4koQnGy8zqKVN
 ADsixZPMSn8hqtc28hzVPXZM9EFSu84B5hmU5WzNDMjT4hlE9ey68Ux88SffpKD/zLRv Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09rdgw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:05:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vxke010305;
        Thu, 7 May 2020 01:03:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30t1r96f3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:03:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 047139da028508;
        Thu, 7 May 2020 01:03:09 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:03:09 -0700
Subject: [PATCH 13/25] xfs: remove log recovery quotaoff item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:03:05 -0700
Message-ID: <158881338521.189971.386468696405305368.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Quotaoff doesn't actually do anything, so take advantage of the
commit_pass2 pointer being optional and get rid of the switch
statement clause.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot_item_recover.c |    1 +
 fs/xfs/xfs_log_recover.c        |   33 ++++++---------------------------
 2 files changed, 7 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 07ff943972a3..3400be4c88f0 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -197,4 +197,5 @@ xlog_recover_quotaoff_commit_pass1(
 const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
 	.item_type		= XFS_LI_QUOTAOFF,
 	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
+	/* nothing to commit in pass2 */
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1ed0bdabb9a4..02148e341760 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,31 +2034,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-STATIC int
-xlog_recover_commit_pass2(
-	struct xlog			*log,
-	struct xlog_recover		*trans,
-	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
-{
-	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
-
-	if (item->ri_ops->commit_pass2)
-		return item->ri_ops->commit_pass2(log, buffer_list, item,
-				trans->r_lsn);
-
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_QUOTAOFF:
-		/* nothing to do in pass2 */
-		return 0;
-	default:
-		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
-			__func__, ITEM_TYPE(item));
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-}
-
 STATIC int
 xlog_recover_items_pass2(
 	struct xlog                     *log,
@@ -2070,8 +2045,12 @@ xlog_recover_items_pass2(
 	int				error = 0;
 
 	list_for_each_entry(item, item_list, ri_list) {
-		error = xlog_recover_commit_pass2(log, trans,
-					  buffer_list, item);
+		trace_xfs_log_recover_item_recover(log, trans, item,
+				XLOG_RECOVER_PASS2);
+
+		if (item->ri_ops->commit_pass2)
+			error = item->ri_ops->commit_pass2(log, buffer_list,
+					item, trans->r_lsn);
 		if (error)
 			return error;
 	}

