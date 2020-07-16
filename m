Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D6CC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42930206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q0hleUJh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGPGpz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:45:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55922 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgGPGpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:45:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6g0ok160471
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xADnerR10e/e0NCZuTbI6Zjh8oHxHCmQC6w7w74YMuk=;
 b=Q0hleUJhxXczdAPdnIsQmkLUreyzD1PVY9oZt/76SEC+eNW3Jn2DVZF7hlOULXfrIqPk
 gKdYrACdg379pfq8xbFvWCcR14cMfyd5+Jy68Qu31q4swJV7ioAvQcxCp8XLoC5zrAcn
 Q+dh46ZIqcLrVz5S5L9fJRHptrS3CpE4mqVfhSY64lBiRXJSS+gxJVMTt3gFC18IfyO5
 2/kSMEcs+EATOrIvp/EA29C7yniwR0c4f5rG0xgxqs4uGztnLegOMCS95PjL4N59N5lO
 doq2KVsaUV6ilpiDWgJVU8VCV4Y/Tp4X9LJ+7gfPYV+4HGofUWHWal+/2qaYYJ60wHDG Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 327s65nrhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6heBG142868
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qba747h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:53 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06G6jqB2014698
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:45:52 -0700
Subject: [PATCH 05/11] xfs: refactor quota type testing
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:45:51 -0700
Message-ID: <159488195153.3813063.7311387972463609613.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Certain functions can only act upon one quota type, so refactor those
functions to use switch statements, in keeping with all the other high
level xfs quota api calls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   29 ++++++++++++++++++-----------
 fs/xfs/xfs_trans_dquot.c |   15 +++++++++++----
 2 files changed, 29 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4053e7e390f1..ce946d53bb61 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -171,6 +171,24 @@ xfs_qm_init_dquot_blk(
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
 
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		qflag = XFS_UQUOTA_CHKD;
+		blftype = XFS_BLF_UDQUOT_BUF;
+		break;
+	case XFS_DQTYPE_PROJ:
+		qflag = XFS_PQUOTA_CHKD;
+		blftype = XFS_BLF_PDQUOT_BUF;
+		break;
+	case XFS_DQTYPE_GROUP:
+		qflag = XFS_GQUOTA_CHKD;
+		blftype = XFS_BLF_GDQUOT_BUF;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
 	d = bp->b_addr;
 
 	/*
@@ -190,17 +208,6 @@ xfs_qm_init_dquot_blk(
 		}
 	}
 
-	if (type & XFS_DQTYPE_USER) {
-		qflag = XFS_UQUOTA_CHKD;
-		blftype = XFS_BLF_UDQUOT_BUF;
-	} else if (type & XFS_DQTYPE_PROJ) {
-		qflag = XFS_PQUOTA_CHKD;
-		blftype = XFS_BLF_PDQUOT_BUF;
-	} else {
-		qflag = XFS_GQUOTA_CHKD;
-		blftype = XFS_BLF_GDQUOT_BUF;
-	}
-
 	xfs_trans_dquot_buf(tp, bp, blftype);
 
 	/*
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 19d3e283aafa..518cf0347891 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -556,14 +556,21 @@ xfs_quota_warn(
 	struct xfs_dquot	*dqp,
 	int			type)
 {
-	enum quota_type qtype;
+	enum quota_type		qtype;
 
-	if (dqp->dq_flags & XFS_DQTYPE_PROJ)
+	switch (xfs_dquot_type(dqp)) {
+	case XFS_DQTYPE_PROJ:
 		qtype = PRJQUOTA;
-	else if (dqp->dq_flags & XFS_DQTYPE_USER)
+		break;
+	case XFS_DQTYPE_USER:
 		qtype = USRQUOTA;
-	else
+		break;
+	case XFS_DQTYPE_GROUP:
 		qtype = GRPQUOTA;
+		break;
+	default:
+		return;
+	}
 
 	quota_send_warning(make_kqid(&init_user_ns, qtype, dqp->q_id),
 			   mp->m_super->s_dev, type);

