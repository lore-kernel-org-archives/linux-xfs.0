Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF044C6379F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBIICD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBIICB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:01 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3362B196AC
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:01:58 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Q8Ox003920
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=1xoDYsuWG2SRerMtDZ+ug4VReqHwhjGAddR6C0EnDaI=;
 b=FkhVI7lpyq0SSQgZTVdv0VmzpEX8nLR2eQ7MF+sZNk3qnhVk4s3LhAlJyea3EMryxKHv
 /8uIJhOeon5wlwS/X1e2wKnOQUFKm28WsXRdhvzD74MjXeOvdQwpRw/gUxuWVlu2aFh6
 4EvTAQYGRHDgxVXlXpsKN2PfKZH49NPSeuy7ZiNJQrlM5s4jj3+n2N1VzV+Emjw3ro99
 5evp0dH8It+nnnZFD2LLxD9ohCQRouQhLfuKDC3kbi0PFP7v9q3gkCi8m0qgsvsMiy8z
 pOFVoRjEoqFwwugbLNUcd2h7BHuqxqJNvLeITNzCGaFPoqGJzR7Jyk8euA1BPY5nTlKx sA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8aa43m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196GX1f021554
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8duu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJ+ft1qRVhweRZ30WYp/8VIOq6RtsNicjLPTvXR5Dk/gf8iACSmjJUW5OqIRh7zQLmg8yg/wUTubGIIFk3DMfxB0jdnwpEM4UHbrawJxKq1Oiw86jZDU5sA1SPxg13WVE3JmYwlSv1laFc4W5VCNaI6sVEsQ+SB4alRQtX0d9Vj4ygVoF5Ocb/ZJdOUNIP8V8zNdY2Dx9O2LO4b8kD6cqTNABg28w/x8WuCmHyVxDm7l0uXw7Xctx0hSVHlxJf0ZQ7aiLIIDQTm/KLcZVY+ej6hYOorU+yUyIpjwGntyz7zgmQ/smd1XA9Vm3M9gPHJSbpp8mpqrJtHygkMws0fb9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xoDYsuWG2SRerMtDZ+ug4VReqHwhjGAddR6C0EnDaI=;
 b=LNQ8P+oYx1lieD1VNeoiqEGAZ5aD8ie0i+a7cop1l3qcDra9G3YOXU6xqMYPJRm/kIWMN45Wv6aGN8JON36T7LWSrWQwq8AbTt5JofjkijeAioBlU4Jm02Z2Mb+dqPYuXPSBzllwsAPGb5oISWBu/4U2Kez8sakOWyg9RxgV19P9Ta+94Bvh0jTHbozaJGza2i308dv5QFYXtp29DfHx5L/oJqNNp1JozshB/wHD+UL18wcPKyvJ8akV30koiN/Uy5pCqLihRlJetgplX5rL7HVoeU8tGO5WEOPaldRMpN44ElCK5AnrwL46ncuD7rV0XAJxuOwJPEzpEZXREpS08w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xoDYsuWG2SRerMtDZ+ug4VReqHwhjGAddR6C0EnDaI=;
 b=khz359vr7zlePRWquGNQW9DyLT012uVCw+W49BfWJpUOVms2AOuUrjCjdMZ7SPjJsY1OXwzCBTOZ4ZUdUY6Qjp1n/2yyFCA0VeEfS4uDpqZiX6l83CmBLf1XfNKpyd+KnfhZjghfvSZDgoMYZ96KVLniE+0jhIhwDD/ne92z9J0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 08:01:55 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:01:55 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 04/28] xfs: Hold inode locks in xfs_ialloc
Date:   Thu,  9 Feb 2023 01:01:22 -0700
Message-Id: <20230209080146.378973-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0365.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: 919a37b4-3e26-4ce4-59f4-08db0a73e92c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s139lcQ0bDbloQV0c4sT+r4Oo7drUieNzoaCnshiQ+i6TPGa/TBU6vD+CienMSfTgTBPnPfBJda/iajWlgNI+iXn+xpw7qtImBqnMoDLGyC8stOc6tsQnarmAbNDTbTLvUF5+bv2cFpidpGyiHPVpGTPCRSAdmNtfd+wpME9KXBSG0alJdU+MvcjpMWHYLcw8kY6KWhXIBKpXIjCKhHls/G5f4fM4PXESVtLmx28f8jNY0ZNntdfuBuO4VbWtAzw0SqEvek2AWXy5+RCJLvrEcvZ87l24jwD3ZzuSGYSKBwyJuUDEonAlKEmN2l2l63IiIYV0HMGuZAH/GICLVCNPyVgNC2mAymO7DIcXUDSLmG1IHfkHLouhqfSbb7AQ1XxtrflnNfVN+5Kzuw/5aHSAIh5hrHeJS/rxruS30+fk+Hpwj5f6x+3cz+tkhMA8z24o/Jx2DZTk1jDUElCn9hw1pG/hUyBLjF7MLPwjzur2ND6ZlWLhaFz5qb1GrY7NxoQe2SLJh9kK8wskiHhd/5HC9F3sAy3zp1q7w6dexBGJDc/GL7Yc9GJKdn+QqGtceJoRiTQ5gM36DiyVeOXwKuN9sVl1HG+MvNOVR+hYws2BFytVjb8kazHw476dnPYx3gG5Ne50tAX/TMCX8H/Ti06vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199018)(478600001)(186003)(6512007)(26005)(6666004)(9686003)(6486002)(316002)(83380400001)(2616005)(1076003)(6506007)(66556008)(66946007)(6916009)(41300700001)(5660300002)(38100700002)(8936002)(66476007)(8676002)(86362001)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sZ3fK5sL9eHJxo5Gv7ZQc2bB/B1cNPObsDm7ISHxHv22+E5tj/O5g/U1gKf+?=
 =?us-ascii?Q?jKthdqXzvo4O52wceYPBeUgqqaDB7n0NGcxh9G2+yw42ihGKi/dHEOmLamiV?=
 =?us-ascii?Q?cJ1gn78ygcsIcR6RcRdjVudhrjblCq+AZaK/PTDTZsxIHurpDruWV6GBZGbR?=
 =?us-ascii?Q?hJoTuLJZoCMFgujsKbZnSC9cQKUj0MNMkym2HNL3+QpCRPwQdkmPa1Hc8xX2?=
 =?us-ascii?Q?mDXxGzYVruMfpDzJ83V4B9lnH/mfnCuLcF4iBMA+mzfVrlYCeme1I3cuo3v2?=
 =?us-ascii?Q?huuRyV9ySj8zVYGkRpOHXINUhZfenPv4HTwDAkK87FOn7cKE7mPjHRg8dxV+?=
 =?us-ascii?Q?qVC+1ZZ7+38XdEu0EBfoB/fGf4vcydEsw1zgNLY6Wv7PIG7BU8K+5M1Q4J8E?=
 =?us-ascii?Q?2a9+LIhKDKKh6uyZZB/M7BUbXMo2BnDfCnfMB11MDkwquvdJsMCGP70yWZFP?=
 =?us-ascii?Q?AREVHtl+wSP8DYGRer6nHxN0QyqW7/UzJKNYbFO47rcdhV8ncFyYMWgvIZ8a?=
 =?us-ascii?Q?I6PikJk5X8LVDLR4SL8/6tJrdHk2cspNs4iSkg+Gu8Hwj02KGWf5yDeEUAGw?=
 =?us-ascii?Q?I2+4G93FaYCcNYmbQyVmRnKolwTdK87FKFtPKW+achHhTdoLcSn6J+S/mHzv?=
 =?us-ascii?Q?bXnsXo2amyj/Nzy193ADR/7unkVhZrG7B4+WxKndjdkawOqkupBNoKpacrnF?=
 =?us-ascii?Q?HVHvOaCiMRvURO2uXupfwBzGPAoDKeGRufsfkQyRGgG2QpgOCsLJQkbqUrw1?=
 =?us-ascii?Q?P97nbaulST1v6Lw0Ol/oZjKzuoF9eRdJndMjiVau3nn8+o4Hg5f1b6HP73D/?=
 =?us-ascii?Q?Hk/+jzzUTrCEYes6qK7CsSEt5+bWAqP9IBqsoysCvqz8TeM2JBz161QdI/zG?=
 =?us-ascii?Q?HyIGWbR5BpGBVEBMfI/REEbmcxJg5Teh1SfaOUt7YBFdhjZWrBBGs8uHGhJV?=
 =?us-ascii?Q?2bpY02MxYWFatx3siGUyOQ4FAS9zpwhTiOYhoOOSuQB3tAe4UgA+8powncDT?=
 =?us-ascii?Q?9Rr+bBBD51Kp2NdxVHDLhiRMHDO18/LdFdxCUzeRtDkFmpAwSwyD5KBNMVNA?=
 =?us-ascii?Q?4S7yWSurN3hlLViJLBiIdsPsloWrn5Zt9Q32/JvlnOWvBqUslBnZ8RRmnIgb?=
 =?us-ascii?Q?rQKKoXbwf6qvz+rjbzoUarrm05h3nqe+EBkqExunnbRCGNGxxq+dcntFLXSn?=
 =?us-ascii?Q?s3gFPp8UNQgoa/tUHaTKXyYv70khHLSi91zryiOd5sUkDz9JIbqL4mnQgcL4?=
 =?us-ascii?Q?WYSkLS95KKoPu62vpcAJ9VGbCdnbhulJz3K8QNwzuHkIPPRWm+JoSV/KKiVK?=
 =?us-ascii?Q?rjQJZvEPSndws1BUYD8f0KdJfQOJpdUec7ZZ/Pv3CxLUieoElFwiTL3aY7DG?=
 =?us-ascii?Q?fffRYvpACaRuaPpJZfgs6S2PM8LYkF+fR2ZuBLTdxxBd0upxoiG658Dvm5hv?=
 =?us-ascii?Q?kK3pILtHkDKgqJiMHPx266K6aTUkqKVg0Thzs7MauJ5gExOH815QlWmGQPLE?=
 =?us-ascii?Q?bIiCyTnd7AYz7e8KCdEbTUQZW+/XYpqNHMIAZDJt4zztWsVIXdSwRRbgB1zu?=
 =?us-ascii?Q?11Bd8hIwoa4OszZauVgMXUGLGTkbZBaMFLnawszLEYpNuygMFx1Ey79l27P9?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: D93h2/wMOauSliFb7UaDVsWU/8XZEVEQeXaOdytehrxOGOD31VyHDzg87uFAwcHT1sRENmmXuzSi7asWld+aJM21jW54yyLVfovQ4CyKMY0KN/TGjQkbOnM4N2ej4BNinF1yCXMcr2tTPe6Cxg69ob/leIVBUxsJDXLdWChvuySorsZGw4HWu5qCDSaVOHHqgV+eaRV/R/wsZVD8Q4/k+zwjCIZJ4ntEIucADOR3xmoT4sY44UDpTSyLrw0JepvaCpBzYi5J52kEnreb0LSRenNWrnSMVuJWjdpCEpOF7CDUQMHD7P5mNEU2+ou+lOdadiufL4TseczvzrcUFNJpCAlF6iX3OAqoIWG9mt4Vs00zJYalM1mZ5BHXyiyLKOEeWt4HExQkkwy3Llz1vvEz2+fHEhUa0Ajp0rGFHC3cubSWqVlFb2INzgb6ajnlgut63JFw0C+psRuY8uDdwvDk9vUVA5Y97XvcoTVcKaAL0p3uRjvyB5ZdzYM1urr3vShpXlc5cHvnRtnlNJUp09+8ayvEqwCJ1DwN6dRcEJiU3B/xC8qHNss3+jBQq5vS+u0j35L0u7274x8gZjQkTrtO1/RoKiJK9PB+prSdetFVv16t2UsiFSIF5Dl9/kFTYD7h48GJOrUZXDedM2YaLOanajTSC7sEV8hl5ST05na2yrlKi+MlIS7GZ1piHNqwM4VD8SoFa2gz2JK/BqoFyaUjrbkQpxYMyj/GH0mraKuksJqKaoxpA2Adl33gvQEtD9iL
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919a37b4-3e26-4ce4-59f4-08db0a73e92c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:01:55.3822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFp/fC0gfvIMOmI7vBvnb/E7bYJ+KQUo0FIYPJpwL+5izLfyezbpWLV2dOULogvi3OZ4tjzXsk1jyFP4U4XUdaUputqvmkNzyKixhQFCLJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: SfcELtKVgk_ECTFlF86UOnk5UOQIldGS
X-Proofpoint-GUID: SfcELtKVgk_ECTFlF86UOnk5UOQIldGS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c   | 8 +++++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 27532053a67b..772e3f105b7b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -774,6 +774,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -899,7 +901,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1076,6 +1078,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1089,6 +1092,7 @@ xfs_create(
 	if (ip) {
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
@@ -1172,6 +1176,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1185,6 +1190,7 @@ xfs_create_tmpfile(
 	if (ip) {
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e2c542f6dcd4..fbecf54d3b44 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -826,8 +826,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
 		xfs_finish_inode_setup(*ipp);
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8389f3ef88ef..d8e120913036 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -337,6 +337,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -358,6 +359,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.25.1

