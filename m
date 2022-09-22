Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADDFC6FA90
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiIVFpT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiIVFpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E12674DCC
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3DwCV012277
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0SYxbNR+B9GHu8wHCJ6PTn/eM+p5WzeIQUAmMLLkvrE=;
 b=h5lyaewyR4e4Dbhst9QecifKW16hx0JaA7X/EwjrdgEqPX36AVP69nvKaXKJkDFM1HQF
 i+6nbw8Gc1qU73I0NUeg/H3//uJdwd0YcXBQO4+r1hOjY+aYntBnWo+3Z337DOh506/V
 deHSI+CQLC/KR27VamzYfZmhdG9BKYuEt8LTB94xDDUkXCHTQ/BT11nluJkTWIOrM9ep
 tLd6UwaB1mTlzM0G8iQrznQwvBdLQqsIsmsDhdD69rMpVulRmxggMu86O1fiAdbzZ1Sm
 EacKKj7FKTV/mBTFLSxSJevf0pmVktI+QRmYUMu7zWs/SGYfmmWtUeu4gam3Q8sK1IzH kQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68rm8fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M4FGoc038374
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:11 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39sd8u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ic0JO2iD0Ua5s9v9OcK8Wfy+2oGFsUywK0b0ABMxoXO4Z6p2Z6+TBYN/HeeytESzdq4h9Xe9vxnJOvLWk9Ewr7eIepLAb4Dc6oKT6G7JU9u+IrNgAY35OItmp5Nj2uOaKzSRbmfv5yXuRV1qX8HxNLpr7/bvw3s2waCLxbCILOLPuNUwAapYN+3ctql6te7PmWaPEKeqBIviydAQOiXLLKO9nTb4mAwa1JAy6euhu+3Op0J5fXkjmfAK7YLucO/TrD9sUGQBKZXU6+QVxg8ioILJkK3HbxkG8awUxVjPGbuK/B7n/fD0UxUVvShmWO1jeK3wNpqQrXFckYde9Ml+Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SYxbNR+B9GHu8wHCJ6PTn/eM+p5WzeIQUAmMLLkvrE=;
 b=HeNAOCUNaDz2nrJ7MuG+k3TCQcNmKXWuhA8MN6ZwYAr8E4/Nzu1VKle39wCMYjEtmtcAN+GZhcGXwkDMSVkXouiitjyhmB6Vfg2Qc/jYjjHERf9UvJWZS03LwrgKSuezn4s72KGHpxNXCUTqhoUX4h6Z5BOAPDfmOCkN2z7lsT1bsKMy00EfI2C/IlfXn6yS3bE5Pnyw7vLih/WWEXhyQ8Xouy6/aLqA8lfIuBJj/QWsdIqg29YrZ/7TgsSyVNDM1Zyb8DNhpSyTz4KXy+PFW3e8XP/m1uWq/HYENGjBT5bpoy0cw8buONUEh4pSxOTOz4QEO+JLP0TVE6GUrvhqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SYxbNR+B9GHu8wHCJ6PTn/eM+p5WzeIQUAmMLLkvrE=;
 b=GS0vkA4E+8oFRs/Hk3PIxdCISIgjyK6ptUa81ekcUcQzC/zrYupBkDhkq8ebsk49kXLIQSJ2QQO9hFeyIM4s8XQqxNqDSsa3hwAPsqrBEH7n0hPRrwl+Kfo1kGCprART5yNBERwcuktwxD2ZNjREC+VhE7QkHcDzOI9vq2mhkKc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:09 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 05/26] xfs: Hold inode locks in xfs_rename
Date:   Wed, 21 Sep 2022 22:44:37 -0700
Message-Id: <20220922054458.40826-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0167.namprd05.prod.outlook.com
 (2603:10b6:a03:339::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 949b8fd9-bf77-44ba-16cf-08da9c5d9c28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYPn987sycgahj6zVl8yaDlAu2ml0KobYitrPjq19MUz1ogFGi6IuRJGmoWzEvwrNqtE6xopwcFzodTIBw06lwlB7iE2X3HtQwPG2QSRA+CShM28BGKhdJJ+AkP+fmLnIuhBD8t2uL4e8NLnpBMJ+xXPOMbJJI+cYfXvq0PlsE2nTjE+XM2zAyw6Jzlgkn57k191sLMEA098cnmRFM9f/jZnat5qxtodkYhscv1q7a0PlTMalqRgp9nwgOLHaGlgeoMFDN3wsc3LTy02Z/XDPoCfK/aLSgTnsl8KIpDRrfka0jvrr9RtFSgF7SvWx7oMWHYz/+rz0SiPdCLDdQcT3fB1MElAvPYdtE4Uf2HiisZfYJ3HQc85C+IwSTugaDU6pO5lUNq2sU5ai99D+mK6BQO0cdyhKzsZrMYo/tFfudIp9R2abqvm2UoHoeRpyAFx+Lq42AuDkag29tsrYdXreQ1C31eeEzdTu0IABfoHbQxzSba3b2zd0iw26lANT4TgOVkF6rK3ZQBRIaRvk8lMzydcxymfa8Zkd4EemdOnum8tLTh7qMrVxlmfsdR3NvLoypVGykMiXYCGuO5n1Vu0wHHdLXDurwcMnZtoZiVqFy2QNOkONmfHb8LjIqikmVU0Wt56D+sWnjBOPvHNIlIgS/UH47dFRizM/rjR/G2KMXbokYi4ktxmWhg4J2t9fxZwR64cGp6rbIuFT1p1iXKgAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h+YJ5xXw3ND3SgJn2orOQtygzR9sUqiemZb2QxNovr3xXCFOg35TuPDG4b7/?=
 =?us-ascii?Q?rmgsdVDEz/EHxLfTI8fMbeipmw9jCJUMyFKpE/GdQkIH7V+HqK6xpMC+x2yL?=
 =?us-ascii?Q?SRzG7p8OYndbJ5cTILfAOS30XrmvxX0aeIamzZY9LcbUIb2i9s6yscNs0xDz?=
 =?us-ascii?Q?Mcv1VtxR7AC39mPbqqAv4oiqVQel65BAZfrS9OUnL7LB0Nxp9d7mhHZULVW/?=
 =?us-ascii?Q?Cz9NO+LqbjApthBKGOes8rSwzHxunvRakO6KN+OCwvu0ZrkNsMvNQ9wv4smh?=
 =?us-ascii?Q?TzqBYBa93d5SZFNV0JkUi45jnrgAVBND63eSHdzrOWOHIh7rKWWkOJGwRbc5?=
 =?us-ascii?Q?9nq26L06K78MX9qIwVA98eeGuoMX4TuNv444xaSwZ9K3O1BtMKZ86hNNw4RJ?=
 =?us-ascii?Q?hQvPtxhY0ZerIWwc+bzgF6HNS2SF9tAogKNFfjSBbhetSt9F4akc/VkaY9MZ?=
 =?us-ascii?Q?9QNVHbXbExuLBhFbZzjLAHeBu+PslBHEc9zkI/t5WjaYkapDIWl4rm5168gw?=
 =?us-ascii?Q?z83nATQOiD3HI+ych4sWyN2+XjAMSwcYarb3iSkChXWBi5XzM3V7dNHljNFy?=
 =?us-ascii?Q?Iv1YmcUHgnnMb44l6I9qj8gOjCf29ir2jVfE+A9O2uipHmEC4d4DlJef78e3?=
 =?us-ascii?Q?pCp1klOZkDTc//fxGVqPm0FmR58p57F9Xm3QhFYevvQYC0fGgnf4oHZW3d6U?=
 =?us-ascii?Q?g3lvNifagUkcXSqnR4yvtb8QXLU8/tdXtr0mq84VLD+EeBeWg8nD04jdLSuG?=
 =?us-ascii?Q?Hyx20Y55e/upwXjO7pPal68bLqO9gMc0BgqDxkPW8KUoomiTemCx4qv6SEo5?=
 =?us-ascii?Q?Qfwskqg7668uaz4H6gdzDkVwRQmVjpikf5MiwfEBxulefFhwB3Rf5dw8dEbm?=
 =?us-ascii?Q?Kn79hvl3gAy2/RD1HGKV6zJkgsM6x0ypTMXS/8KgHjWmJtsr3+vaHsGmFBgy?=
 =?us-ascii?Q?IiBmMDDU9Y/rtcGzjSLsI1kTCPTqBz0cM+32UJQFE/xyQiNMmhhD5RIFmRtP?=
 =?us-ascii?Q?4/vLn4TT+/rwR95dJDGJouV2bbE3OUcmLInaRKHTt5Z8n6xvdDsjhFDe862Q?=
 =?us-ascii?Q?OQNxgl+2yTtEyRNoXrq/dEL9TqXAwHGFPFIUdo/kcPaWaJ1YPndMrOhbfcUR?=
 =?us-ascii?Q?oa5U+dOjpyLSe+YmXgzb4LgxC3ZItAV19SC5cHl2N8NG9GHKBvrHU1J3Sf4k?=
 =?us-ascii?Q?A6bHf5kZeh1mVqbjt38hBoXQT2JL+63SKP/DslL2krx14bLPiDe+xNtUiq0q?=
 =?us-ascii?Q?ELpg8KADMatvdqMZlah/9+uwBg0OtCOnd9tNaNx7+xtAsvc3+hkuaQ/0ksEm?=
 =?us-ascii?Q?ru6YMPShvanzz1zjpRBZYG+SK8j2lKSi2wMbCQxvTCv+TdgzUfu+IRdboWYY?=
 =?us-ascii?Q?rW3HdJSymRYm+8UmPBjfrKZwmkKFKv7gewU1hv52X7yhuagbv9QsdBEe2MtY?=
 =?us-ascii?Q?qFtgSeU3G9txD7q8zXj37ywUdqhk7rzXHIFyxABqBwjGL3SQEPp+6h+qYKHJ?=
 =?us-ascii?Q?96BMKBfUcuNI7XyvK/hurbA4DVXJ7n0qgRHUw3eAsHrjA721MdlBD2++FKG7?=
 =?us-ascii?Q?g4NPtTIfZqo3d6oYzn3nDvwSIoD/7rzzWS7yWmKczS1fwEqK851OMQX63CUU?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949b8fd9-bf77-44ba-16cf-08da9c5d9c28
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:09.3048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyCIwZ36wZZ7b9tYsriPgNJ9ngavUAPWrvVQ+ZPKV5cdAxWPqRHSgcbr4FhDryJoYq6ag02utFpET4EBarxmfhYq6lpS5VgFf4f+QhONwtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-GUID: kUdNpUOnTms2N8U51OtJK8VIx1-OuKNi
X-Proofpoint-ORIG-GUID: kUdNpUOnTms2N8U51OtJK8VIx1-OuKNi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9a3174a8f895..4bfa4a1579f0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2837,18 +2837,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2862,10 +2860,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -3090,12 +3090,21 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	/* Unlock inodes in reverse order */
+	for (i = num_inodes - 1; i >= 0; i--) {
+		if (inodes[i])
+			xfs_iunlock(inodes[i], XFS_ILOCK_EXCL);
+
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (i && (inodes[i] == inodes[i - 1]))
+			i--;
+	}
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

