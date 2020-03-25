Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEF8C54FD2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 03:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACF6020724
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 03:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mkd+4Z62"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCYDYr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 23:24:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44388 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgCYDYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 23:24:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P3OOag064965
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GlHxJlaix5a/dTE6hZZd3Xo+t0WIEZKLd2OSegEgq7k=;
 b=Mkd+4Z62p9IAwg3jrIKCA6uG2WLmYgGIRhW7UxaDDHiFvJCRgmBSMk52Xtc2PGYqq4Cg
 TOEnS5Gdh1+UVgK0ijVQ1ajJJjJVMC5FAk2t0u4I853Zx+CSRR20kPX8ojEpc6uczYKy
 iqu+B8LKYRHR8YbULaNTx2uWi2ED5JaeVeeuZec6+GeK7Q8caRFoL92Mk/aZPzRQAm56
 3B5/WZkX7lwPyjBQd9UnU8Cp/22kL2xrSHCtoAatuIlJHqAcDofDiLmPHNOpN2L2NN/8
 4LZvMpcWenDadswL94XmDeqWEE0lfStuF25eaDy3mW7ZDd0IRiVDAWDTKYILpGNrYR5S KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yx8ac4j64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P3NvLr019761
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yxw93sp4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02P3OiKM000581
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 20:24:44 -0700
Subject: [PATCH 2/4] xfs: validate the realtime geometry in
 xfs_validate_sb_common
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 24 Mar 2020 20:24:43 -0700
Message-ID: <158510668306.922633.16796248628127177511.stgit@magnolia>
In-Reply-To: <158510667039.922633.6138311243444001882.stgit@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=1 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate the geometry of the realtime geometry when we mount the
filesystem, so that we don't abruptly shut down the filesystem later on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2f60fc3c99a0..dee0a1a594dc 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -328,6 +328,41 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
+	/* Validate the realtime geometry; stolen from xfs_repair */
+	if (unlikely(
+	    sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE	||
+	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)) {
+		xfs_notice(mp,
+			"realtime extent sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
+	if (sbp->sb_rblocks == 0) {
+		if (unlikely(
+		    sbp->sb_rextents != 0				||
+		    sbp->sb_rbmblocks != 0				||
+		    sbp->sb_rextslog != 0				||
+		    sbp->sb_frextents != 0)) {
+			xfs_notice(mp,
+				"realtime zeroed geometry sanity check failed");
+			return -EFSCORRUPTED;
+		}
+	} else {
+		xfs_rtblock_t	rexts;
+		uint32_t	temp;
+
+		rexts = div_u64_rem(sbp->sb_rblocks, sbp->sb_rextsize, &temp);
+		if (unlikely(
+		    rexts != sbp->sb_rextents				||
+		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents)	||
+		    sbp->sb_rbmblocks != howmany(sbp->sb_rextents,
+						NBBY * sbp->sb_blocksize))) {
+			xfs_notice(mp,
+				"realtime geometry sanity check failed");
+			return -EFSCORRUPTED;
+		}
+	}
+
 	if (sbp->sb_unit) {
 		if (!xfs_sb_version_hasdalign(sbp) ||
 		    sbp->sb_unit > sbp->sb_width ||

