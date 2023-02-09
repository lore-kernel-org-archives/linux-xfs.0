Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2C6C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBIICE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBIICD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CDA1351B
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:01 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197QeWD012323
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=qaNGI5HY7M26yc6xXQ6HQ5L8rSDjtUAzjw+adU2Iewk=;
 b=RGtgv+jWNQyIM5QIWWdavb/Hx7z+zWd/Clw3XqaVsloRatGi6XrJW1yqD11z5/zisd3d
 8jVBDQ6fe3Jrmx1f1G56JsgmdEgTBxi91+wbozOgl6TrFnnSADqF1/JtiFO1Of21UqUr
 T2UUJPIqe9j9NJ1LwYOz9sFGv1R/BFf187+e+ppvXTSVYVmk61UJdQfCPwPGBZWOkWfg
 uz430Swh6l428xxyfIjNFPKBwaqNEBbYKI+KL2BJRLjR45KHgncdiSBNI25Az2PR9nOO
 o+QZreWHHepymGe/qN1kCnaTJ+348FTkTD4UB38G79sZiDJh7EL1Jld2ZNwJttxhFdDI tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe53j50q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196eWWj031525
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3njrbcxu9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdR3c4wtT+K1Ovpe2D02oC8FAczoDdbuPKQTmNnhzZtRUvTq0b4QcrR9+6qE2N/3P5y7GyqRG7h8+mseWryXnWTi9H2OfstiOceoYiRw8rSICStdeMPmJ5WyELf/1wDVQrlOyzJoOqRi/7Fb90USAvJhaG7ActaKzHm7fozqyKN9tiLVuEgAIC/UOaZaZNnwsYvUqL6rDqrZknvMo2OzziT8YGGtYA462E+H7yr+LhKxWqwW3D7XZQivbX2IZLm9JU1tXb4QN3hncAtGZo2X531Wpmde5tnJF0llATNy5voXINMVqfRBYCvYksOrxMzJwM9/HXjExon0jSiSk6dedg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaNGI5HY7M26yc6xXQ6HQ5L8rSDjtUAzjw+adU2Iewk=;
 b=OQf0kJpzHiH63YZcOchxj5Avxgl4iW1/L+dyToTPp0jI1wmubEjejk10BTx7V5iJAc2jEKdZzMBhKzcS5ui3B7cMB8KQqwTD79/mKxGv4rcAEjDwaeRdKr4f9UZtA2dgornNk+8dX08QvG8pIM6xW0ZxkSRWCRxHxQ1uNPwNJZsveOXwQZ+5dEbeMxBERnh8GGuogxgjuoz/kXsGktPxwHaGH3IwsqGMR4kDCp4yKQOBoiwh79J0/bDFC2pfDLpzYNOKHl9Kme43S7Go1Vt7ik1G2fcHTHCYX3JlYXbP/yhDYu2u5nXbA7X/PZ1RlMjYxAZSBrXOrUUrgZjv5S3N8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaNGI5HY7M26yc6xXQ6HQ5L8rSDjtUAzjw+adU2Iewk=;
 b=VUibXXu8lWeli04W53SUUJZhow5/hadaDJ8A1uj35drFXJgGodgtXP/hcLsKtxfV85MJ2QFqRXJGYGFVXOG0wtY4deX7HdX67p1E6R84BVA/98KDrLUjg5yV/4QsKCEbrMtXvAvBrmVYHtJs0MgGRl0LCTjbFm4MKYktz/pNhSk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:01:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:01:56 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 05/28] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Thu,  9 Feb 2023 01:01:23 -0700
Message-Id: <20230209080146.378973-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0057.prod.exchangelabs.com (2603:10b6:a03:94::34)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eb0c771-e5cd-4809-9d0e-08db0a73ea0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RMlhv3GTpe/ASncetu9dKA5r6GzK8aecZK7p+5InaSXfcUC4pW8G3AJi179z3EL1cv3IFgm2gWXPIeB0nO7dOl/1pSKxPO0SqN4hj/2DTTuDiLmAG48XTCLaYT1Lz44p68fkmQOSNWv1yc3cr44NN53yqm2lk62FEEnb3dhZaeVL/uywZ9TM/FvaphysUTsVFy5rcvG7u6W8fJl6oGwpsbgBkjYdYhJ/ZZLv6RNDRk/UiwQC10RVYo/J/SyfNk1lu0Icj5nHuLetvnFXpAymIltRQwBMSOZ+urX0N2T2EV0JslAI8AXQ7fTi/OFqetKkjA0nUeEE9C9kNcnzJRUnNqL0XaQ6wJFpIBnWnfIyiZcRE/MJ/QyHN1ywmKxzK6hmCOGzRCa26loiw0MJIvd3UubuT/y2OIyzAoBYaHBjno5k2M1gABTgk5hIEUKC53P+h0chiC9gxhXYkNIQQHJxcDZ6N+2xC34lF/uUkfhqmckKOgc9cuf2p202N4NjjPjtRGDOFNVCAk1AhRi6KslbZhKyqVLXRqOyOV4eDygnWJ44Y/mxTo2xPP3ncsvsy9kbbV1dP/pL1C3qk1U0qC7JI7MmWPChFSpydU/JvQQUWgAQFMV4XXNhTmcTomAQ75Shy50ldvm92yyiVsMdZOHnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vL95bg/N21BhixRA/ryyQu9ZHlBZdV5ckixCwnVZRDKfP/fzC43Xo2dd8d88?=
 =?us-ascii?Q?g4L1i1VOSzQyWtLzXpWOUNJ9m35c0Otnvsgxfe7h9BOfz2R9RZIH8d/y08ob?=
 =?us-ascii?Q?dBHvx4W0syZ4T2KWKqYa4ZNPj5EUSPq8fYrPl2RQA5brW+QXU0/pzVImeHKR?=
 =?us-ascii?Q?SDdAN3QbQXGj7v0ksjVWdOz3Uctwx7ribHw2tCYaOpqd0eVs/ChAzaNxZw1H?=
 =?us-ascii?Q?JOK5ym7M59/LRlN7+DGSSIV6Bq8x957VzxUwWdiVie0+mSxR4w5n+FUbi/C/?=
 =?us-ascii?Q?tiSMwD3Rv4k8y4WnILXBRlLwqy/2jEBqUCruH4im5Go9M7IWQDlHqvFebLAs?=
 =?us-ascii?Q?Gv6qPFX+u6AE47kG2xQ37y5Aas72KyUREsUa7W0aUHETp4gbtEzw5dF+r5TO?=
 =?us-ascii?Q?552anZZpcNyAAfRQMAzcgura7t1uDytZu1xjIetnNZ33UKX/te2S528XECNl?=
 =?us-ascii?Q?dN1h1n4NmCddi6vs49OIoPje2iILBMGEhg9uV3TVKV+ye58DfO4sUI6Xttjt?=
 =?us-ascii?Q?bvk3NyYdP/l254iOxnTbKGbKS6SMbYzReYd3gVydm1VXPN7cvdM76qGaH4Ad?=
 =?us-ascii?Q?eYzw0R6rZKe5pMaLge6roGq8IKWPYYejJE5iBxh3QrIm6kmaAeQziK+Esxw0?=
 =?us-ascii?Q?9BHlJT0sZxcRDNP2T/WasZ1G7OH2u8438yXj93YrEvCBxc8HDSrERNQ+rDjc?=
 =?us-ascii?Q?EEPFzraEykQPUfSUlDduDtIrHZ4GEGv90CxkPQHfQqhKV/QgMN/eGsXpNMtN?=
 =?us-ascii?Q?J0jMnGMHVMi7WUKrMwpxMr6CWBaz+y99JKIkh7Rr5yoWfYWytG8DaUP5bwAq?=
 =?us-ascii?Q?LLZnPnba8UMJ6Raoc6qpsYelaIJi2DbGuC20dnugLvpAnuE6srBz7UP60PUL?=
 =?us-ascii?Q?AnP55T2e/0MKGyIPi2EIfkY3gYdMNJWXNbUm/fbG81HGl/vV5o+H96M6V7yZ?=
 =?us-ascii?Q?lFXmfY4+V2viwCcywQVCtdujJLu0EuLE/U0izqy7LGa80ufcLDEIB1pa/e1X?=
 =?us-ascii?Q?aYndA7nS12vKs+1reZfMvnicPXWDSnggc5RgTx4xhD201Vc84TGAwyXNgxRp?=
 =?us-ascii?Q?kiR+XTrklwD7s9qnN+g7/z/Hn9IsgEI6o9B1Lqua02IhK8+X/6aJwVv04VeU?=
 =?us-ascii?Q?Thq0GKNnbAIdmzQ8DMCujk3Xs7KBmWFEA0X6iGM6OTkm3+rp4Q1u0EOOye5k?=
 =?us-ascii?Q?fp+x/XY1O2s4/edGJ49SwAQDc/uVPXS6CeLo6OJGbXSU44oV2qR0TAkHTixq?=
 =?us-ascii?Q?rHVxAC4XmfzU2dmJiVAD7Rs+9xnJQuJi0js+Vz9Ktow5dWF+YHMl9MCrZ8S4?=
 =?us-ascii?Q?WbVmq0EH4BuuaZdAF+LDdOdHn8XG7YDzhG6meI37s3PYrWvDW1A35rpSK9d0?=
 =?us-ascii?Q?cNnft71Hmk8h2GtjLKaQCX6AxvMUVGlaji0Aka4JzQjzra1Dw/BlB3n7IfTx?=
 =?us-ascii?Q?5j835UZhN0iXkDd01fH1Dre/S5FBqbUg5Tz9qZ0/Y+dcmfIpcM8LdwZO4KJT?=
 =?us-ascii?Q?kag6cpxQSedPBkvWj54vksRBOcaF+TzcVo9IxPQe2WQtf39W0kx+Va4VOUqL?=
 =?us-ascii?Q?eIKAa958v/AZLo15YF/+1Uyb6KM5wkakKvRd6vVMax4s89LUOLIK9DWt6J58?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: P69qEspkuQWQ0NObqPWb+/FSx6AJSshpj9ZJezMFrhoAPiWWlb3cU1GiLVzuqEVZKS5aeCyhTUsQSiXcCV1+TAt2TAUbmkKmtG3zegrPr8Q03Kul9MyM11/g8zoBZZdKoNc/iSkuQQuv2r+ScBmczsk8HkY96xIz9EOaYqJQfUSM6vNCdxuiuv1SAFMfZYK6VoV/YOTIqUtnIa3HuR78bBGphH6IsHahpsozW5GR6BUvjZet/VTViXMScdtdlhWoBr7RHBxLrZBfjpNVwuCmHdhyeS+ySyGLA721UpZaX9fjKfxK0Rk8dmv8EaEnyE4mxBYotvrvEG5MyhG9wh/7jSYuiik3IOm41Y6VLupEpM4MWz9dmWyi/s9ysziq53Ups5CmSTNkKuJDiX8gvGI6bvFXJHlWr1Y9GrADRHA2Gd1gOIF27KMSila2MxzFW83f+GXfGDQC7ugCKXo7m5AUN+YNE4vmArsF942RwtBsQN7BMmhlcH330Awq8NHPskw3T2ja7UO76BTCvzkquBlou9lWAuuEOmFMgaPsx7r3eUjLd2w3ni85sa8Ntrpad/b7LroDZgEsJWzJN8bKKRNhCMRpEmuguWZSJO8hXoAh4SjakZCXP1mzk2lmrp8LrEiUJT8buqHkZUnbD91cE0jtERhm8nUmTKXNPX7FrlXx+ckXnPkC8+IOs5QgPIc8dRQ5lbiooVSW+I381tNCZOhIUIrntSVvP/7cHCIwq+7uexjHJ1KrPgUeJVKqIeLthuWD
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb0c771-e5cd-4809-9d0e-08db0a73ea0c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:01:56.8363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbm6tTIHjakkoVD+IVKxVLoME6PtuPmgs60NpRbh+Svq8HI3ekEKZFfujcMfpjL82EEmKjgTWA+1BVxw8Zrvkzk1rMTULfeZMP8WTOK9kdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: xiS7igrpoxow-a8A9RHCNw1qCh8JWQbX
X-Proofpoint-GUID: xiS7igrpoxow-a8A9RHCNw1qCh8JWQbX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++++--
 fs/xfs/xfs_trans.c |  9 +++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 772e3f105b7b..e292688ee608 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1279,10 +1279,15 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -2518,15 +2523,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..43f4b0943f49 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The ILOCKs will be dropped when the
  * transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
  */
 int
 xfs_trans_alloc_dir(
@@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
@@ -1410,6 +1412,9 @@ xfs_trans_alloc_dir(
 	if (error == -EDQUOT || error == -ENOSPC) {
 		if (!retried) {
 			xfs_trans_cancel(tp);
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			if (dp != ip)
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			xfs_blockgc_free_quota(dp, 0);
 			retried = true;
 			goto retry;
-- 
2.25.1

