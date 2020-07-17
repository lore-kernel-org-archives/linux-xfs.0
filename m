Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3B1C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA5802076D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Eg9UlfqO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgGQBNB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:13:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59538 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgGQBNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:13:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06H1CMPr002450;
        Fri, 17 Jul 2020 01:12:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OsF/std80U8ji669u26zzZSXABra27mBSNww4V8iRr4=;
 b=Eg9UlfqO+Xc+czitayHcrcjYTIfd72nCDzuwVOu+kW3C32WXJ6sX4N8bvCKe0qTABHHq
 fK59uL49hY19tMCw0uetpCfDhTeTdzPPxghPy3lfyFKyzl6qnR4A5OlYemp4hta2hSAN
 4Ku6ZPYfuycXuRc4GpmCoaDkQrFw3EEGJ2CnvSYFXdjCYk1V9RaMtOQEQIAEgHYZOW6l
 p2ZhmHqAFmdTbHIlGfp0w0PluMA6yIjGi96l+uP1/84W+Qmx/ceS3e5Tq1twgt7eKhrr
 RuygOhIxiAlxHZBPyjEB4xel0aTq6HLZQLpEGdGQs+TcK1Y/OhEcJj0avastrLzINUp6 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 327s65tv83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 01:12:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06H17iiC078868;
        Fri, 17 Jul 2020 01:12:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qbd3pep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 01:12:57 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06H1Cuas000726;
        Fri, 17 Jul 2020 01:12:56 GMT
Received: from localhost (/10.159.154.157)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jul 2020 18:12:56 -0700
Date:   Thu, 16 Jul 2020 18:12:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 10/11] xfs: improve ondisk dquot flags checking
Message-ID: <20200717011255.GM3151642@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488198306.3813063.16348101518917273554.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488198306.3813063.16348101518917273554.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an XFS_DQTYPE_ANY mask for ondisk dquots flags, and use that to
ensure that we never accept any garbage flags when we're loading dquots.
While we're at it, restructure the quota type flag checking to use the
proper masking.

Note that I plan to add y2038 support soon, which will require a new
xfs_dqtype_t flag for extended timestamp support, hence all the work to
make the type masking work correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: amend commit message
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
