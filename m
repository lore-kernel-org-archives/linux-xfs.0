Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3908C4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 801CE23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLFXK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:10:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLFXK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:10:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N7fHr182974;
        Sun, 6 Dec 2020 23:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qgBZrxh1VPmPyuvb8FMOs4cdrExa6PoDtlhoJgnj2rg=;
 b=JpFH/LiS1yK6pZi+msz/D9IIXpx09E3l+Twf9MMqFAPCBv4mIJcDJflzT5N2Z3yEujBl
 o1e0bUxegbI7LMO9DHzQPgOqBRO0Gv3VgWZFzCqQ9oXiaEq10qYwpe1WFHr1DzP+YDc0
 26BSFeSsUC+gzu1zFEbNtl+fx9SgGgl6a03xiUonncmmNQOBZbmb6g0+ujpcvYcXwiBr
 mLIcuVUlgqHavaBVPcfVdUcM8Crxk8ORi4HYaWt8T6a2OIvPdJBYthK9pRs8SAuqFfLB
 fjCISWQKI5PzSnYZhdhYcB8WX9/uqERVlnw77NmRKXkAA1yxVped2rBvMCdSRqqkCu8+ wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825ktug4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:09:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N6MBs192742;
        Sun, 6 Dec 2020 23:09:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m3vpcr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:09:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B6N9ffG006996;
        Sun, 6 Dec 2020 23:09:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:09:40 -0800
Subject: [PATCH 3/3] xfs: enable the needsrepair feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, sandeen@sandeen.net, bfoster@redhat.com,
        david@fromorbit.com
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:09:39 -0800
Message-ID: <160729617967.1606994.16303813050126665103.stgit@magnolia>
In-Reply-To: <160729616025.1606994.13590463307385382944.stgit@magnolia>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make it so that libxfs recognizes the needsrepair feature.  Note that
the kernel will still refuse to mount these.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5d8ba609ac0b..f64eed3ccfed 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -473,7 +473,8 @@ xfs_sb_has_ro_compat_feature(
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
-		 XFS_SB_FEAT_INCOMPAT_BIGTIME)
+		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

