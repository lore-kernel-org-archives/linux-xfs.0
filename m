Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13ACEC2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE33C20724
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kW8P7vAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDVCHL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:07:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVCHK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:07:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22du1074051
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SYjayO/pqA/4+aqn01DhweS/dPOD0ESt9+lODcrmztg=;
 b=kW8P7vADyM1yQvv2ZVb4ZsSFowSPEJNAY7F9fyyUW8GmYkTWAgSXA9Zj0j3E4ByOCbpk
 q9zjIqE3VVGgznt6lefWwxK2NgE7BvSYO/kC/pFD5H0eJNWD6bdZOx3r00jClrmFo8jJ
 yVqFzmY0AOB3kqJvGp9qzBo1K14i/cLU06z40ezlwxRU9kFjjxIAkEINMtbE0PRBVGJZ
 YbDbIwkpmkdS3p59gQzKSVtIhzytnDhm0J7GsgEEotCQWVBe/2B8ClYGzrYjHHoWbC+W
 NlPxonDUiqsYASCQBt/2Grbf2SfHKOHPW6snXVnZvmn5OFoYLbQZIq6zIn1Uj5UjUVhi xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n81jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M21cQ1065041
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3t4n1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M27807017755
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:07 -0700
Subject: [PATCH 10/19] xfs: refactor log recovery quotaoff item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:06 -0700
Message-ID: <158752122672.2140829.3691203963610665663.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=1 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the log quotaoff item pass2 commit code into the per-item source code
files and use the dispatch function to call it.  We do these one at a
time because there's a lot of code to move.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 18b797ca4a6c..5e7e5c66327e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2502,20 +2502,16 @@ xlog_recover_commit_pass2(
 {
 	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
 
-	if (item->ri_type && item->ri_type->commit_pass2_fn)
-		return item->ri_type->commit_pass2_fn(log, buffer_list, item,
-				trans->r_lsn);
-
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_QUOTAOFF:
-		/* nothing to do in pass2 */
-		return 0;
-	default:
+	if (!item->ri_type) {
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
+	if (!item->ri_type->commit_pass2_fn)
+		return 0;
+	return item->ri_type->commit_pass2_fn(log, buffer_list, item,
+			trans->r_lsn);
 }
 
 STATIC int

