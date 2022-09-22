Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161D8C6FA8B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiIVFpo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIVFph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3887F089
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3DxgY019757
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=TUYCXmVu2rmd+qvGcTXASSlJWc7L5ZzRm/gISN29tLA=;
 b=Xu5zI1Q/9eprJS+hw+cAKEsCCCBf/7aOpbdKOnY6Pi3Hkij5us7OixUR3kS1rv9RHr9z
 2Szt2KTSIxESMO8KaOmunApbllRmmuWx6DNhC4Wre7pa7qZw6usoGnwzfxE/sT9VFQa2
 NlJkAN8Hs8hZFMtkFWC3BcPqLAukszz8RJCyG0ofYe12zJcTLSh0VIVDPnXw9sJEva/q
 uKwi8AZIWagIEpHpP4a07M/RHLMJtDMlK8O7WE2Km9M7faVYe1mVXL1gPDzr3QWef1Ib
 8JeXgGQ9dStnGjKiUWT6me7AGnJKksaGQj8J5eXiNBBNrnCDARyRazisU+vtYR4ptRGm tw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kvcht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M4edF4032444
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d46ycy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7ZjiFkrfhBs026o1FesY5mzGqiII/MWXvsHbQTkZCGyR/7rKMr1ddFFKsRBBIoy0fThQbiA8QYZc//tYq3HuviLd6TtPOAgMwBDlEJZC3lcaJeYepzUjDb0Ny2fUD4RFVs96wlIwV9CPkLIInHdlkTfRwwQBpEv4p5OelahJdFB+YSzX4mLErcu9oOqteIoTzwRFiORLn4jO/qb2cA00/qLMACvtN2OMsQB+HifwLN/5odrfzChtqF5dDDdZJUpY9ZmvlmGuKAmx3oK83A5hhLQjPErJyI79UWda719pgAWb5lmenBcbzy4tI/D9tbEbI/wMxXPFAq6/s6nr9+G1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUYCXmVu2rmd+qvGcTXASSlJWc7L5ZzRm/gISN29tLA=;
 b=Lkk1uZO0IdjLOFdswdmDaf1vwyqkWELpLTZa32zp34cQdxzoW5eFdJohQpb3dsNjildpCmf4yqC46mdPcUPLOpGwdFrgObUjxoBJwxn6967w6wVq6yAK9SP0eFbECEz/uu041Qi4hMy9PhQBReLMZtbxxxC+EXKtEu4N79lZ1tLwnRdsiTYE0Lt3RoL9H+Oz43tn/EDlmn9H9lwqhq+5BUallSvP14rxHMZhxqAcCDv3cheyUDmCxJHn0je0yIENa8bckTPbC3SJW9jqxmqx7MQEBQ9KosWbf9lzweMPuPw1Fe0rq6c1Q279cNGaLD/UdbIN8IZFq6PpuPwNuxU8SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUYCXmVu2rmd+qvGcTXASSlJWc7L5ZzRm/gISN29tLA=;
 b=xOL9XY2n0bdP9gIg3QgzLnCZX46fq7hFlzDJPyl8WxYQeLyphx3F+yEcK8QroBkHEmhs5pUrQDzGo0wVc6SQXM6BIT0GabradscXORxqC4/60VGRKhAnFAfP2Ou6+KUkAZZjIFTzCiTYQb37843KXgVCQrcmCIQtYwoMOVGiPqw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:33 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 23/26] xfs: Filter XFS_ATTR_PARENT for getfattr
Date:   Wed, 21 Sep 2022 22:44:55 -0700
Message-Id: <20220922054458.40826-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:40::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cacf05a-d85b-431c-762c-08da9c5daa7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GHKA7dvFT216TODrHH55KuJapETuneStHdW7ICO8EEcyBxBoZhH6EyGQTyXcmwek2Ni6O4zwpUfLfm8Mey+EmKZu3Q7/q0qChpfyry1c4XrEaARhIfD6joWnwpBcWS99wNni6TyI+QbgN/Y1/SWPjpAk9TWAP13+B6M6YVmcBxZvUXvVkaO6zSl56RsKtqPVi8P6AUJi4Pk7GuReaTemRxWbEmZe7fzFt2YgxnjzltCGWcwpoe1gMZLIpXOy6vHPUgTUmk7wD3rVrkkCLvUn8xEkjF3LnMspJORbeWAPm21CIQIYcaCRDSgz32YWRbQBWKtoEu5eVYbWWdju2UfdD2VIuhysqGa13SDsbHRKo4ZYBVKVV4Rct+7ZmqhkuzQU25cm+450Zeub/bXygv+idKSL5pSkE7riR5KYRJJwG9PjjRuOUCkZmwI4+O4ddr/IHsV/FynKP6o8/hTTetU3+gvicN1yOaC40nXTDtaaVZWNKcDQRtwWfnLa+2SVyixXeJF8uQ688aav2CmCmOYIalQWvRs1aq9UoZ4NFmE3pG/tOOgXNc5Rh7UWanv1HTsdj8MS0RXluacyQ2TxtQLtONdVorgY10t4hZS/bpe5lzcU2oXrpuIS90Uw1DUwxV72b1vJdqqYgXHiYue8AGSuojMrL+j/Xvuu5F9iGTOLlZmcs8qJ2UkGcDxH3uOfrYmJuGOY3Uca9BoSJ9wNTs+8RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5mMbxHUcVDjC7+OrRjg3YeRXqCgll6OielWoL8y/sgkKLyQYp+T+v1dUVU/r?=
 =?us-ascii?Q?UCIb1jwte8Av9THHltceFWRY93qNLtuiQtAVmN+qmASPDS4uNtNIYb+KGlg0?=
 =?us-ascii?Q?NTDedoT1jua5cYHaYJeIM5Do9TTsfrggnPZR42yVzvZmVviXbVgDmIP549mw?=
 =?us-ascii?Q?GiPJ6PhEqa9hE1uzfD/cp1/IIX68Lhe4PGbcmXMXFRyKmWi1tPwWZjkeAgSK?=
 =?us-ascii?Q?s1Xb/Q8v+rBlxECrL3nKQb3rLBFLD7Ml1Sp5D39ps8h8o9S0bugA1+o8Z0D0?=
 =?us-ascii?Q?A9jM5CptMuR81RpffvZ4xPL6ZUnE0VbwvMAfUqgnzutA/f8IH28tPS7T8UPq?=
 =?us-ascii?Q?3bOS3blKImGxFmDsEcRALoCjBsrUd4IvbH4E6LCjWIcsXxeE8wabuVJPmnOx?=
 =?us-ascii?Q?MyDqAN21sFR70q7k44S39HU8iRnKAgDRX3zPuOezbqbTooe4O7Z0quC5jw/c?=
 =?us-ascii?Q?lI+8Z7KWGmhkRwFK3s/pybpEJfAt/oAsL5m3nuDwlAnji/kzRIOLGLPv28Md?=
 =?us-ascii?Q?W4KF3zeprFpERhjiPqYtYqJJJHKTfeCWgsXbpLWuKYftiU95Y43f+sbSNGR5?=
 =?us-ascii?Q?8LyyvRXvKafmErVeDBQPflTk4vXWmzeHD7GE8ufRVJb1/9sDVOS7yrxAlGvY?=
 =?us-ascii?Q?vRYhjuc9nO1AoLm8LdLRz3ru8hrLXFm56MgHkdLiQKQijzjz/cLz+YL5xeO0?=
 =?us-ascii?Q?xMUvzjW0Jisj8ktQK/D0KBazbaYlPqCIYtdvaHn2NWnpbg3VDA/svOVOtJYP?=
 =?us-ascii?Q?g8Msia98vOtR9PYw7W6NRdWfX8sjhhWpl36mHhM3YFyuNgfvWPzW2hBhf1gt?=
 =?us-ascii?Q?FOvU2j7i4NLbRVp0Mfq10dQPZP2gb5HrQ0M6J2KUaHkkHMvQyoxmiLhU8TPQ?=
 =?us-ascii?Q?wuosN0fsgBDWbvWYDvqpDUUIwoAWaRGtAOegqVml89HUYMalqB7u8QcVFhdS?=
 =?us-ascii?Q?27638xcGevdrBW+RIQYnum02aH+yKi5WiUasrrmpCxwMfMY5f+0IxLjiBapg?=
 =?us-ascii?Q?yngbGPqrcnsfpuIY5sBgcR+6TdKJvhDGoAMPIG96Lmc0PQFYYmPaUTMekXj5?=
 =?us-ascii?Q?ghcTkfznlOLYcJGCocpLnbjoae6PP4HSgyp4G3UAgu7oC4WV3yAhOIR2y4P0?=
 =?us-ascii?Q?+hgx+veviRtMxtY/WgTy+9RUX5qIgDnX0lrKCnomgVEOw99I7TXN4+FqtqUd?=
 =?us-ascii?Q?gB00dxwVQpm3D4dqbVpEGyqWWj0SMeA4WDB4rs1ZqgoORwfAfQIC+FTGcxwU?=
 =?us-ascii?Q?l+Db+gfzwO+c8esaxue/970L1rcw1ra8aJ9as5ycAsdc5BOMVQz2FV3wQXu9?=
 =?us-ascii?Q?mC8Yiqwp2wcfW6ZKPT2rNYIs79xLCdxyfDR9MDDFOavu26No5Dw9duDKLtbz?=
 =?us-ascii?Q?w61tfiOxW5m8frp4qWQNnfxVm2cxtOnztyH70vLskZeBwljK5ssciEQOmUS/?=
 =?us-ascii?Q?aRB7zUR556Tr9UNgyqO1vze4xEikdBBLUmHvHHxX0DpsF7nXOxaf6A0/14zV?=
 =?us-ascii?Q?f3sHSa5wzRhjB6co//aCDXA+ssTNmCeJX3NlomIx0tH97o3XsEvhTcpyxGBp?=
 =?us-ascii?Q?tfw6C/baBOrax+W1dRjj39gcOUg5oYmNDOHjyhIzos5IHLCauWE3R3C7PTku?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cacf05a-d85b-431c-762c-08da9c5daa7b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:33.3393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4EILSvYmaUVRvckJqfsBiAKZnZzbtH+mSTxqMgwtxrwW0dxQsmIlEBKPxrTTK+MGJ0I+dcpQEz6pS6jArOZLNp5i29e67T5mq/ZfoxxdUh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: cyj6xAw7KNZF2TjKokfixrbR238xwZsL
X-Proofpoint-GUID: cyj6xAw7KNZF2TjKokfixrbR238xwZsL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_attr_list.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.h |  3 +++
 fs/xfs/xfs_attr_list.c        | 47 +++++++++++++++++++++++++++--------
 2 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b02b67f1999e..e9c323fab6f3 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -697,6 +697,9 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 #define XFS_ATTR_NSP_ONDISK_MASK \
 			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
+#define XFS_ATTR_ALL \
+	(XFS_ATTR_LOCAL_BIT | XFS_ATTR_ROOT | XFS_ATTR_SECURE | \
+	 XFS_ATTR_PARENT | XFS_ATTR_INCOMPLETE_BIT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a51f7f13a352..13de597c4996 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -39,6 +39,23 @@ xfs_attr_shortform_compare(const void *a, const void *b)
 	}
 }
 
+/*
+ * Returns true or false if the parent attribute should be listed
+ */
+static bool
+xfs_attr_filter_parent(
+	struct xfs_attr_list_context	*context,
+	int				flags)
+{
+	if (!(flags & XFS_ATTR_PARENT))
+		return true;
+
+	if (context->attr_filter & XFS_ATTR_PARENT)
+		return true;
+
+	return false;
+}
+
 #define XFS_ISRESET_CURSOR(cursor) \
 	(!((cursor)->initted) && !((cursor)->hashval) && \
 	 !((cursor)->blkno) && !((cursor)->offset))
@@ -90,11 +107,12 @@ xfs_attr_shortform_list(
 							       sfe->namelen,
 							       sfe->flags)))
 				return -EFSCORRUPTED;
-			context->put_listent(context,
-					     sfe->flags,
-					     sfe->nameval,
-					     (int)sfe->namelen,
-					     (int)sfe->valuelen);
+			if (xfs_attr_filter_parent(context, sfe->flags))
+				context->put_listent(context,
+						     sfe->flags,
+						     sfe->nameval,
+						     (int)sfe->namelen,
+						     (int)sfe->valuelen);
 			/*
 			 * Either search callback finished early or
 			 * didn't fit it all in the buffer after all.
@@ -185,11 +203,12 @@ xfs_attr_shortform_list(
 			error = -EFSCORRUPTED;
 			goto out;
 		}
-		context->put_listent(context,
-				     sbp->flags,
-				     sbp->name,
-				     sbp->namelen,
-				     sbp->valuelen);
+		if (xfs_attr_filter_parent(context, sbp->flags))
+			context->put_listent(context,
+					     sbp->flags,
+					     sbp->name,
+					     sbp->namelen,
+					     sbp->valuelen);
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
@@ -474,8 +493,10 @@ xfs_attr3_leaf_list_int(
 				   !xfs_attr_namecheck(mp, name, namelen,
 						       entry->flags)))
 			return -EFSCORRUPTED;
-		context->put_listent(context, entry->flags,
+		if (xfs_attr_filter_parent(context, entry->flags))
+			context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
+
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
@@ -539,6 +560,10 @@ xfs_attr_list(
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
+	if (context->attr_filter == 0)
+		context->attr_filter =
+			XFS_ATTR_ALL & ~XFS_ATTR_PARENT;
+
 	lock_mode = xfs_ilock_attr_map_shared(dp);
 	error = xfs_attr_list_ilocked(context);
 	xfs_iunlock(dp, lock_mode);
-- 
2.25.1

