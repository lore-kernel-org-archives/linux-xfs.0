Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56ADDC636D7
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjBIICf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBIICd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B9C2DE77
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:32 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Pr4V011751
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0+eyhh3tfjPJPNr1iqM+fdcCGTKJN/EJNiTp++deJGw=;
 b=B13ut8QK5ttmn4CFFDugqX7YNJ4bJCLoVisRi6LjQVlASwo3ijSs73Ey/fJ29k96qo/h
 ORSYdkpcraotyrCRSkuMdIytDw8PVP75wak0trQo1LlELU+HJ/RRsiHgQohi2+PSgbWH
 8OQChTB8E43JW2D/Qg0kwGwE9I5VVUHJNZUrB3mkhOLmQEe8w3gs9VP2259zb6yzNvsl
 4THEiqgdI213AYE8d/uxQOK1RrkLzweaXUc+TPeKydodKamBLhP+IGuHVl2xCyhCFIlC
 O5wMVq6VvGvgYESUcN1g8rIdKgK9Zc7NmsfKg5Yr3jGDR3gKoXY36W9hbr/DCTQb1k/o 2w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1a76s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196KLvm021320
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dvja-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJFUMsOq1jotLpFwEifKw41PC6IeC/5pmf83VSIMZQBnbJGfLA4HDp5OZOazkt8gp3REtb+8fzbXkUiRwjOYI/BG7D11Rkf/RjLLYJDqOCSWp5Eb4Tl9BeAZO25B5xYRjSNR5dQW0tbgolNeGzV6FBwZYuxW85vEv2HsXRzoks6nz9ibtmL//Gzr9xgi4FOdHxxDsSdfkEPFCzo5iHgqEk0h51WWTCcZVl+BCRqEeBjSJqI3wfAPaRLFLqleJnjHxJDsiIg6uIHOcSmo6rec6eV/q9WdAh3xZ9gkSqxx0RQVu0VQly+3XmiNfYcNAcrIPaArAltQAjdBwZI5YifD9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+eyhh3tfjPJPNr1iqM+fdcCGTKJN/EJNiTp++deJGw=;
 b=gQV7VwYEkwHJj0jgHIqLlW62W01C+eUjs030yLKaJ8WYqvLkZhGiUbTzq6cUeVEb2vquz9s1aNt2J3rIayA1YCl3WQRT9MLLhnhne+UwEDMqBiuwHxxg+iES5lkP6QHFfUNDVy4bv5ZOoPfLxqJg5w/p1veWMMg+XzZjyy5qEcAfOI1eRI63YJ5qKPrDIoeu4Y/osmi0AkP9L+uM0v5lSJwwprmsQDbuemSz44FNFpW/wGI5anv60f4W+Ks/Q1Ffr+1Uf7DsiCRlk78KG+RL5fyxzQg1yGNCNL8TirI4QH+Rmk8LEIAEIzjRg6sD237rHdQ1y0HCXqmllCfc/SjXWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+eyhh3tfjPJPNr1iqM+fdcCGTKJN/EJNiTp++deJGw=;
 b=dRJK70dNq36ZIOuN4lJ2CgLAqYj1OOEZCMpxsgBFzoQ7DD+/rQomtSkSx2tJM2O3ual0Sry5TA69NNfYfR7JbMyAhCFfSrsfV/cSppwUTJFQKLO0iYpAlNTVHluZaqlQAB7Lzf6ahCf0SQQNkc3/ocyd75VtHaT+g+2zO5L0rmY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:26 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 20/28] xfs: Add parent pointers to rename
Date:   Thu,  9 Feb 2023 01:01:38 -0700
Message-Id: <20230209080146.378973-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 9230d3e6-2498-48e8-d0b2-08db0a73fb58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OkRZJ9PY9QY9rCarwwb5leDalD6dcGY7TL9PIl1HrjlUIhy6gR1nNWx/F7sgrd2b3rhwEheX/+sSqKECtHcg4n8Vapy2EwDZ2ZmCBbTjR1N7c0ulwdYuZPqc4KRYu6uDQwT8OmRPLFqFSXHFShTuxAsNDOiwV9XcIva3wkro6PuNKoSiT4LPbu9PNRFylvPo+7nfZiaP3TqSPv+mdaanYYdcIyVujL8wV5UxdL0G3Z7liJD38MZTYPbOwGmDLDHf2EBiALOnZCF1k1ofHfrxzaUVqlCZ/cLLuiyBEYmMN6fVE3/TxWkFJCh9dX/Y02P2MsPClAaHHnd9yovyofz+npRPRRaWOLeZ/oQ+8ssATn8AyK0uoHWA5zwxCd8eMSblKJqcv//M/gvXql/FqwnQq1/YyFYiLkFkDxv34tRig4QYBqT7da1g6U4nDwO5A0BDpUrWJCIlScDk5x9extuF9XvcRQdvUWg0eYRasO0zYHeNm6kz2GnwuQsSo0G1hr/WXkcaIQuj2U8ytHsV7lPdTSgwpp8qAqSH3HApuScvYEv1Xfvebqrq66QDunDXB9HyCmHEAFQF58PomRXy7bzzK5oMmzEEvb+FpGWD8UI8zg+A99DJnodw/Px4/oqqZ58//CTfoG2ttLg2p8FpV0qexw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(30864003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q/CjYaRGZXzu2e9lVGDJnvHdAXYRraacpbuiGsnzRsBaEgTATHU5BMNc5o/b?=
 =?us-ascii?Q?7TyiFU84SvXdLkKDEPs75mLcm8BqFZmrRZOCKWMicBeHGqLwM6GBBfU+ksm3?=
 =?us-ascii?Q?m7BhC3NPtVhLw6wL5iVJhZoIBtLxKiyEOOPkq4yY6hDhgxsm+BWQEHab4vYd?=
 =?us-ascii?Q?qYO6Y0IrGYysT9wajRRGObRzo+ETaGwYmLI+CRqePoCJ94yVPMM2U7ppPDGJ?=
 =?us-ascii?Q?O3KdAAM6HWovi7XnuEITaDZu7cKZD4gDFa1Jj0EHDHd5waB6S/GEKHRXxqoc?=
 =?us-ascii?Q?9rrFK3nIz/5lBda4QmzPtklL8miU2uhISCa5FD9asXjGf/TR+XMBw+GySh7s?=
 =?us-ascii?Q?D9LKSJJRkjjdhacRGFoAzqPEYy7Jn1AOS5qg0rjFugPHmdTpKxlJbMiShoH5?=
 =?us-ascii?Q?RrS4Lc4GU5N/m6R46WH4+HutXnkBBJjWYzXKmEHRNErVJapX8sgdrsnFahNd?=
 =?us-ascii?Q?CMSQCtM4Ear/xWmSLp2iZx4EozVgF2mDCYowVfn5ZD/No8LAx0fYBXPkME/+?=
 =?us-ascii?Q?DublpgWcH53xocUt9dkyy7L1GbfHlh3m+ybpjtL6U7wCwOGNKZQ89IpY7C0B?=
 =?us-ascii?Q?by2sEd6mdknm+l8D/+j6hjsSvQu/2IsWybF2j0LCkclEI7Xa4axmd7hTqsSY?=
 =?us-ascii?Q?8VM1obUJ2bAGVlZbEQg1Qx7oQli5toc+m5AU0j+vAOADwWuLKjDp361Afq/E?=
 =?us-ascii?Q?aPyMgAQ0JR2IbU2fqvfYQzcMjDUGLAbe63aGcqxqzwlofUdalS9oBrxMiAbK?=
 =?us-ascii?Q?/TXA5lR/52fIu53uO4lugtuQ5/uJBhMC4pOnR+ODOraI27SOKhyy2vrmJr4j?=
 =?us-ascii?Q?ofyVjn460d+sJn8r8HxdkfBFQXi5r/Myo9gjqMJhq1sCNNB/BbJQ0yDt5+9a?=
 =?us-ascii?Q?stbj6iWaSdwkke5Dke3oMUMsHvbyAMrGYL+z9c79OH6L4AJ3AW6/yyb77ZyY?=
 =?us-ascii?Q?51yA12sKurkER2k6QMNljZqOPfkXfEHix9QcfGht9u7fy3omf4r7ox11hZsK?=
 =?us-ascii?Q?2nfeSW3wOpwDSx1kdc0AfpRv6nXJtWI/LTmlK1nYUr3HLmU4hVW03RkWjwLp?=
 =?us-ascii?Q?R1pq4DPW6M/104uIqsSYXatRuKxx7g1wCdRrMLYhIqbXVpMXADXeOPvFaVsA?=
 =?us-ascii?Q?5JIjlMn8A/ruoMiFQHI7KsfCqm8tMeZEUhWAAstCBXYDH4NfWpiycKtNdN3a?=
 =?us-ascii?Q?JaspZBpgqxm1sX8Buc0Fe1XLUq/W4cnP4bg10Ibr68VhqvpADl+ias9Q8IMk?=
 =?us-ascii?Q?OKTyV0DPXHXcbKSsE9ZeCULJshciStQaqZFKr02mGpvgDuHn8+Uv/4wLP5Yt?=
 =?us-ascii?Q?J4dRfObSTZlrtQH3LloXDO9ofQthjp8PnX+yCO4JsQ5PBniYTR8wjGlQ442t?=
 =?us-ascii?Q?cyijBF/8BUv1+IZE+2xnxQC6GXFMQv/eiUpnwSkjV63jq8ruB/oLZv5YLy5Y?=
 =?us-ascii?Q?sMVJpy4s6Ql4+dUv3SnqbzujUyeo2/3NoShDFlcqJD+ITiV/OJPOYzmS7ECc?=
 =?us-ascii?Q?NKBAs+nZtHDJms1f35P8mlgi1XLCmICOZ2vr2TyYZu9BUGrmkrELRuXauOv0?=
 =?us-ascii?Q?l0Bq2ik1dlfdKr9nxTHLVWly2qnB3U9ARMNo9nLju3r5V4IPtvO+Pafv6sF5?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ux6KL3eYPPZg46A2PmZGlXhd2lyo7xJjM1P87APHJ5CBn/hTFlDd15NoEHZ35CO0cqitXG2Ol7Q8t+rP8uzwUG/k7ksqMkxOKZACyDL2o5xfubUgQ86biVYBRC4C1gcd423OhY/9ss0lSiT4yvN/AMFpxlLXT+3kbDaZblgERABergfRdJ1/dSr2UdV1jLKjzfFcSozk9QLJXww8M7IVm+dsN0RhhUeGmNpp6GpY+P6rMG0Kx7c8DieljLROkuBKRlzD1C3+TefnkGChmESVapZo2WeC8NAmU2DUcrXJJF9AarUDZwO6WgNqFtyfp0ThF1NDg0eDXRLHQv78ABys2gJCbH7w8r0COqc7eHXv/apHZUU6vfasdQVe5SZlc0FHrTKdLlbaBrgo+N3dXfDbKdg2KLWtmdaUF7zHF0z6uItrxadlyeszvhd6C7FuTZX+VLeAqG0s+A+1v2jkCLh4dyYlYwJPWqqHyFEyiFZdYyxKChG1nRSsS6dk3+mLLpHvhlviAsZWDSnZe2W8aPOgskVQvRWotVZ6uBqn12XPBE1WRK8fsHI48MDgCW4D8C2FjOHss8xt6QiP/lWqasCu4B4rLwMVLWCf8gH4cETQD0nsEsmjCkdDkpaVR3U9z5z9COWPtOuiEOymQ5rbwYdj2s1iLtd/3uFbjeSqQAw54VmYdFISkKBE6cNKORgrRphIhAz4HoEXtl4BRPhATwzm0hs7p5WPGPpF7tgAihXXR5QCF3CQIb56wIixOrARqMKD
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9230d3e6-2498-48e8-d0b2-08db0a73fb58
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:25.9519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wUl5+4JRSAvYBDzxkDyZXyWI0zUk+xHDGH3W0afA8AEZWtzGQZrZlL5rfU3wWGz4d1Wu3Dol+0+zmln8NBTAyvjEnS3sqmmNyy93XMhKeyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: oOSab8-osx6bNXaOSTeoJJyzbE7Nnm82
X-Proofpoint-ORIG-GUID: oOSab8-osx6bNXaOSTeoJJyzbE7Nnm82
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        |   2 +-
 fs/xfs/libxfs/xfs_attr.h        |   1 +
 fs/xfs/libxfs/xfs_parent.c      |  47 +++++++++++--
 fs/xfs/libxfs/xfs_parent.h      |  24 ++++++-
 fs/xfs/libxfs/xfs_trans_space.h |   2 -
 fs/xfs/xfs_inode.c              | 117 +++++++++++++++++++++++++++++---
 6 files changed, 174 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a8db44728b11..57080ea4c869 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -923,7 +923,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 033005542b9e..985761264d1f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 245855a5f969..629762701952 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -64,22 +64,27 @@ xfs_init_parent_name_rec(
 int
 __xfs_parent_init(
 	struct xfs_mount		*mp,
+	bool				grab_log,
 	struct xfs_parent_defer		**parentp)
 {
 	struct xfs_parent_defer		*parent;
 	int				error;
 
-	error = xfs_attr_grab_log_assist(mp);
-	if (error)
-		return error;
+	if (grab_log) {
+		error = xfs_attr_grab_log_assist(mp);
+		if (error)
+			return error;
+	}
 
 	parent = kmem_cache_zalloc(xfs_parent_intent_cache, GFP_KERNEL);
 	if (!parent) {
-		xfs_attr_rele_log_assist(mp);
+		if (grab_log)
+			xfs_attr_rele_log_assist(mp);
 		return -ENOMEM;
 	}
 
 	/* init parent da_args */
+	parent->have_log = grab_log;
 	parent->args.geo = mp->m_attr_geo;
 	parent->args.whichfork = XFS_ATTR_FORK;
 	parent->args.attr_filter = XFS_ATTR_PARENT;
@@ -132,12 +137,44 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+
+int
+xfs_parent_defer_replace(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*new_parent,
+	struct xfs_inode	*old_dp,
+	xfs_dir2_dataptr_t	old_diroffset,
+	struct xfs_name		*parent_name,
+	struct xfs_inode	*new_dp,
+	xfs_dir2_dataptr_t	new_diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &new_parent->args;
+
+	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp, old_diroffset);
+	xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_diroffset);
+	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
+	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
+	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	args->trans = tp;
+	args->dp = child;
+
+	ASSERT(parent_name != NULL);
+	new_parent->args.value = (void *)parent_name->name;
+	new_parent->args.valuelen = parent_name->len;
+
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_replace(args);
+}
+
 void
 __xfs_parent_cancel(
 	xfs_mount_t		*mp,
 	struct xfs_parent_defer *parent)
 {
-	xlog_drop_incompat_feat(mp->m_log);
+	if (parent->have_log)
+		xlog_drop_incompat_feat(mp->m_log);
 	kmem_cache_free(xfs_parent_intent_cache, parent);
 }
 
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 0f39d033d84e..039005883bb6 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -14,7 +14,9 @@ extern struct kmem_cache	*xfs_parent_intent_cache;
  */
 struct xfs_parent_defer {
 	struct xfs_parent_name_rec	rec;
+	struct xfs_parent_name_rec	old_rec;
 	struct xfs_da_args		args;
+	bool				have_log;
 };
 
 /*
@@ -23,7 +25,8 @@ struct xfs_parent_defer {
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      struct xfs_inode *ip,
 			      uint32_t p_diroffset);
-int __xfs_parent_init(struct xfs_mount *mp, struct xfs_parent_defer **parentp);
+int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
+		struct xfs_parent_defer **parentp);
 
 static inline int
 xfs_parent_start(
@@ -33,13 +36,30 @@ xfs_parent_start(
 	*pp = NULL;
 
 	if (xfs_has_parent(mp))
-		return __xfs_parent_init(mp, pp);
+		return __xfs_parent_init(mp, true, pp);
+	return 0;
+}
+
+static inline int
+xfs_parent_start_locked(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	**pp)
+{
+	*pp = NULL;
+
+	if (xfs_has_parent(mp))
+		return __xfs_parent_init(mp, false, pp);
 	return 0;
 }
 
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_replace(struct xfs_trans *tp,
+		struct xfs_parent_defer *new_parent, struct xfs_inode *old_dp,
+		xfs_dir2_dataptr_t old_diroffset, struct xfs_name *parent_name,
+		struct xfs_inode *new_ip, xfs_dir2_dataptr_t new_diroffset,
+		struct xfs_inode *child);
 int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
 			    struct xfs_parent_defer *parent,
 			    xfs_dir2_dataptr_t diroffset,
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index b5ab6701e7fb..810610a14c4d 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_RENAME_SPACE_RES(mp,nl)	\
-	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2d8f225cb57d..cdbd7df64ff0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2871,7 +2871,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+				   xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
@@ -2897,6 +2897,31 @@ xfs_rename_alloc_whiteout(
 	return 0;
 }
 
+static unsigned int
+xfs_rename_space_res(
+	struct xfs_mount	*mp,
+	struct xfs_name		*src_name,
+	struct xfs_parent_defer	*target_parent_ptr,
+	struct xfs_name		*target_name,
+	struct xfs_parent_defer	*new_parent_ptr,
+	struct xfs_inode	*wip)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
+			XFS_DIRENTER_SPACE_RES(mp, target_name->len);
+
+	if (new_parent_ptr) {
+		if (wip)
+			ret += xfs_pptr_calc_space_res(mp, src_name->len);
+		ret += 2 * xfs_pptr_calc_space_res(mp, target_name->len);
+	}
+	if (target_parent_ptr)
+		ret += xfs_pptr_calc_space_res(mp, target_name->len);
+
+	return ret;
+}
+
 /*
  * xfs_rename
  */
@@ -2923,6 +2948,11 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*src_ip_pptr = NULL;
+	struct xfs_parent_defer		*tgt_ip_pptr = NULL;
+	struct xfs_parent_defer		*wip_pptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2947,9 +2977,26 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+	error = xfs_parent_start(mp, &src_ip_pptr);
+	if (error)
+		goto out_release_wip;
+
+	if (wip) {
+		error = xfs_parent_start_locked(mp, &wip_pptr);
+		if (error)
+			goto out_src_ip_pptr;
+	}
+
+	if (target_ip) {
+		error = xfs_parent_start_locked(mp, &tgt_ip_pptr);
+		if (error)
+			goto out_wip_pptr;
+	}
+
 retry:
 	nospace_error = 0;
-	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
+	spaceres = xfs_rename_space_res(mp, src_name, tgt_ip_pptr,
+			target_name, src_ip_pptr, wip);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		nospace_error = error;
@@ -2958,14 +3005,26 @@ xfs_rename(
 				&tp);
 	}
 	if (error)
-		goto out_release_wip;
+		goto out_tgt_ip_pptr;
+
+	/*
+	 * We don't allow reservationless renaming when parent pointers are
+	 * enabled because we can't back out if the xattrs must grow.
+	 */
+	if (src_ip_pptr && nospace_error) {
+		error = nospace_error;
+		xfs_trans_cancel(tp);
+		goto out_tgt_ip_pptr;
+	}
 
 	/*
 	 * Attach the dquots to the inodes
 	 */
 	error = xfs_qm_vop_rename_dqattach(inodes);
-	if (error)
-		goto out_trans_cancel;
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_tgt_ip_pptr;
+	}
 
 	/*
 	 * Lock all the participating inodes. Depending upon whether
@@ -3032,6 +3091,15 @@ xfs_rename(
 			goto out_trans_cancel;
 	}
 
+	/*
+	 * We don't allow quotaless renaming when parent pointers are enabled
+	 * because we can't back out if the xattrs must grow.
+	 */
+	if (src_ip_pptr && nospace_error) {
+		error = nospace_error;
+		goto out_trans_cancel;
+	}
+
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
@@ -3122,7 +3190,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3143,7 +3211,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3216,14 +3284,38 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 
 	if (error)
 		goto out_trans_cancel;
 
+	if (wip_pptr) {
+		error = xfs_parent_defer_add(tp, wip_pptr,
+					     src_dp, src_name,
+					     old_diroffset, wip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (src_ip_pptr) {
+		error = xfs_parent_defer_replace(tp, src_ip_pptr, src_dp,
+				old_diroffset, target_name, target_dp,
+				new_diroffset, src_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (tgt_ip_pptr) {
+		error = xfs_parent_defer_remove(tp, target_dp,
+						tgt_ip_pptr,
+						new_diroffset, target_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3237,6 +3329,13 @@ xfs_rename(
 	xfs_trans_cancel(tp);
 out_unlock:
 	xfs_iunlock_rename(inodes, num_inodes);
+out_tgt_ip_pptr:
+	xfs_parent_finish(mp, tgt_ip_pptr);
+out_wip_pptr:
+	xfs_parent_finish(mp, wip_pptr);
+out_src_ip_pptr:
+	xfs_parent_finish(mp, src_ip_pptr);
+
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

