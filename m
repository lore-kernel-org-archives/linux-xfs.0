Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9785C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29EB206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OZkSPyRr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGPGq2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:46:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgGPGq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:46:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6gVNM079865
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=p0vGSKNvs/wBJ7ajP2OVwsYK57tExpnMDQ1em7bPErk=;
 b=OZkSPyRrEB8HGAV+78u7u4p6pQ0fSZokbP/QixYmWRwvUKX22nGn9lO8ltN9NoBAFbLH
 +RZ5TijacbfQqKzDE7Ve9mQ0Mw2zNaTMr6wWT+bxuHrd3s+r5d0rdT6Y/CuW/FX2mwtX
 HwYEHUXII7AbTnauM46J+/HdGaNz9GE7AKZEe+U3JNdKVVs8hh6pdhbR/o9Lr/AaWngB
 AZBLevSj8bqw+pmkhkvr59eWFLqEGf54oGiZm4WiPoQ4M0djCJRPd21CDFOm6pJhr+q5
 OkRKylaZaefk/JFkupUi0fMTUQ/LbonmLcAqAvSvE6MKXR/Afe/+wfzyE+K/Afx0HvnH /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274urfhef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6gj8S024615
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 327qc2jrvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:26 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06G6kPpA007473
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:46:25 -0700
Subject: [PATCH 10/11] xfs: improve ondisk dquot flags checking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:46:23 -0700
Message-ID: <159488198306.3813063.16348101518917273554.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an XFS_DQTYPE_ANY mask for ondisk dquots flags, and use that to
ensure that we never accept any garbage flags when we're loading dquots.
While we're at it, restructure the quota type flag checking to use the
proper masking.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c |   11 ++++++++---
 fs/xfs/libxfs/xfs_format.h    |    2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 75c164ed141c..39d64fbc6b87 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -39,6 +39,8 @@ xfs_dquot_verify(
 	struct xfs_disk_dquot	*ddq,
 	xfs_dqid_t		id)	/* used only during quotacheck */
 {
+	__u8			ddq_type;
+
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
 	 * 1. If we crash while deleting the quotainode(s), and those blks got
@@ -59,9 +61,12 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	if (ddq->d_flags != XFS_DQTYPE_USER &&
-	    ddq->d_flags != XFS_DQTYPE_PROJ &&
-	    ddq->d_flags != XFS_DQTYPE_GROUP)
+	if (ddq->d_flags & ~XFS_DQTYPE_ANY)
+		return __this_address;
+	ddq_type = ddq->d_flags & XFS_DQTYPE_REC_MASK;
+	if (ddq_type != XFS_DQTYPE_USER &&
+	    ddq_type != XFS_DQTYPE_PROJ &&
+	    ddq_type != XFS_DQTYPE_GROUP)
 		return __this_address;
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0fa969f6202c..29564bd32bef 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1158,6 +1158,8 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 				 XFS_DQTYPE_PROJ | \
 				 XFS_DQTYPE_GROUP)
 
+#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on

