Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A735C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0970921D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H5DzvZgB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfIYVj4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfIYVj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdRLA061516;
        Wed, 25 Sep 2019 21:39:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Aqy+Ppcr96Bgme/SQ7XpHm18n0ca6a7dibavawZZW38=;
 b=H5DzvZgBWm6l2uWObwqNgh3SXhzkvDlLmIK6gy3MI5srUZKgHBGo/XEhZYrbUI67w2KX
 tMahdQivIxhyeKNBxiIC4B4DuzqpJgyVeVHgO07v8MmExQafnX5ufZ/d6Pgly5IRklL8
 kKm5qye0Zj9+A+iCKiDU7EAC9uiloRY0wgaNbHAjYgMYu7HLu3dnk6pl7nOafF9uEi8r
 fWVRZJ0/iMp06/ieQDcR6piS+YqAo1beSeIcvkVHix+vSR5TUIXfSlawBjy0ZZPpISoD
 /EFgxMiltLYg/C0sZKrTF9Gd7YydaMVGJBzNWCmIdK3HdSQoG1JMQ4xOeGbf0Cnx1vCB kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v5b9tyhn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdJPh107695;
        Wed, 25 Sep 2019 21:39:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qam191-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:53 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLdqg6019294;
        Wed, 25 Sep 2019 21:39:52 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:39:52 -0700
Subject: [PATCH 17/18] xfs_scrub: remove XFS_ITERATE_INODES_ABORT from inode
 iterator
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:39:50 -0700
Message-ID: <156944759084.301514.10978048192484759234.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the _ABORT code since nobody uses it and we're slowly moving to
ECANCELED anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/inodes.c |    2 +-
 scrub/inodes.h |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 9fb9d1a5..142582eb 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -179,7 +179,7 @@ scan_ag_inodes(
 _("Changed too many times during scan; giving up."));
 				break;
 			}
-			case XFS_ITERATE_INODES_ABORT:
+			case ECANCELED:
 				error = 0;
 				/* fall thru */
 			default:
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 5bedd55b..e3662c09 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -6,10 +6,16 @@
 #ifndef XFS_SCRUB_INODES_H_
 #define XFS_SCRUB_INODES_H_
 
+/*
+ * Return codes for the inode iterator function are 0 to continue iterating,
+ * and non-zero to stop iterating.  Any non-zero value will be passed up to the
+ * iteration caller.  The special value ECANCELED can be used to stop
+ * iteration, because the inode iteration function never generates that error
+ * code on its own.
+ */
 typedef int (*scrub_inode_iter_fn)(struct scrub_ctx *ctx,
 		struct xfs_handle *handle, struct xfs_bulkstat *bs, void *arg);
 
-#define XFS_ITERATE_INODES_ABORT	(-1)
 int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
 		void *arg);
 

