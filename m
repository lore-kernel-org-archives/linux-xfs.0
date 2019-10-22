Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802ECCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50FC520B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XorJJr5y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732797AbfJVSwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:52:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52916 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731740AbfJVSwU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiCSZ089157;
        Tue, 22 Oct 2019 18:52:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=iuYNve5cdTQl5+IfvZ2cHADdtxwXIw/uYs7+rKT0qU8=;
 b=XorJJr5yA248G8XEVAGwDuo3zA2MTr0tm6sDa6CLP3tuSQIUyup8kULznyuw8yY8RUeA
 13AOjDFF+6neEUVMwFQAghlJ6me+n9s9tRnqPp9+DSyJrIESspmBLHFtAbC8gchy2zMi
 AbO4hj+wAqtae7SQQ5SpA6PIxy9DMTdZvupcUcmOOsklTMBtcFphFwp783yP58ehORrH
 2WumPPMIjIgd//UFvFCHDJCsmQmORmgkTytwGnt5W+QEqIRds1tyynQ2Ym15hq1hz8KL
 DUH+nsWO/ZbF9CaKRZJziTqjS6NP1t7WrjaTVBGt9qcIGAfqyU8zEf9s6YsdjMjbYkEE Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4qrktf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhm1i148157;
        Tue, 22 Oct 2019 18:52:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vsp4018b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:17 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIqGLi005410;
        Tue, 22 Oct 2019 18:52:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:52:16 -0700
Subject: [PATCH 17/18] xfs_scrub: remove XFS_ITERATE_INODES_ABORT from inode
 iterator
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:52:15 -0700
Message-ID: <157177033569.1461658.9402725042233856890.stgit@magnolia>
In-Reply-To: <157177022106.1461658.18024534947316119946.stgit@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
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
 scrub/inodes.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index a2aa6384..7b3284db 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -187,7 +187,7 @@ scan_ag_inodes(
 _("Changed too many times during scan; giving up."));
 				break;
 			}
-			case XFS_ITERATE_INODES_ABORT:
+			case ECANCELED:
 				error = 0;
 				/* fall thru */
 			default:
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 3affaa00..f0318045 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -10,12 +10,13 @@
  * Visit each space mapping of an inode fork.  Return 0 to continue iteration
  * or a positive error code to interrupt iteraton.  If ESTALE is returned,
  * iteration will be restarted from the beginning of the inode allocation
- * group.  Any other non zero value will stop iteration.
+ * group.  Any other non zero value will stop iteration.  The special return
+ * value ECANCELED can be used to stop iteration, because the inode iteration
+ * function never generates that error code on its own.
  */
 typedef int (*scrub_inode_iter_fn)(struct scrub_ctx *ctx,
 		struct xfs_handle *handle, struct xfs_bulkstat *bs, void *arg);
 
-#define XFS_ITERATE_INODES_ABORT	(-1)
 int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
 		void *arg);
 

