Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA87C83013
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2212A20855
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P72HQJXZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgLADiV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39176 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgLADiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13TnfP147426;
        Tue, 1 Dec 2020 03:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eBhwj7IBc6uVXCtwWcVcrmh0CBWahvtDgw8dO33diQQ=;
 b=P72HQJXZHIrWCwpPXAXiTw2KFggy59+pFquOeWnf0DPgoEKdik5d7ABEgUhLNMO0evPh
 RIRql8bG3fZ25Aa2FMEAyiyFNEg+c9k5seYLDq5tos0NxhjP0sxwRK0KozM7tdPT3PeO
 LjT1CNGQ5OipjrcxyuQ3gQgycPkEE9EmjpCihNQStt7iuunaIel7uxkpCb1HnAZkhj4T
 XrIUiN4z+Z2k5COM51JWLRlBIjcLdMT5gfkhslryqz/um0hMeN1NVa9EjmKFmVZCuggn
 onN7Cp/PSOca8WYe1Y99HHXl+Ig4onlUSy1s38nYJ+bVgsZZ+fO28XaoAoAOegOSXjir CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 353egkgcqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 03:37:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13UNHx160699;
        Tue, 1 Dec 2020 03:37:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404mbvqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 03:37:38 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B13bcHI013729;
        Tue, 1 Dec 2020 03:37:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:38 -0800
Subject: [PATCH 3/3] xfs: enable the needsrepair feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:37 -0800
Message-ID: <160679385732.447856.1039349578089907881.stgit@magnolia>
In-Reply-To: <160679383892.447856.12907477074923729733.stgit@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make it so that libxfs recognizes the needsrepair feature.  Note that
the kernel will still refuse to mount these.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

