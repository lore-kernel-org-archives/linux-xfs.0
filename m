Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30502ECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiITMty (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiITMtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702AC13D08
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:49 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAA0NK024554;
        Tue, 20 Sep 2022 12:49:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=oLMBXXoCEeSMJNh/vYE7S/2Ipy1KXB7sdim33clpxpjSNGFpAgfIqSxDNDLH28h2t+uG
 3s7zxi5LnIYnLef63mg8xcTpd0onEwGAE1B8RpNhHixGhRZe7fvoc0YEg0QXx9JGLn4x
 Z8BSdTEIJUA5QvBlWaTGOMp7lERwCvsBZFaqLNhSsqIAroyl34N8RO6je0PGsor38DQr
 TJA+CbcnofDxX7HRgmnm7pGwT/L7lXjzMeKEVGGJ387HEo4oEFHlEXCB/BzteVtmXcCi
 /T42FbWGQUPkkATlsjxr6+EUj35PQDEjQQYQewVvvQf/b9yjWoziYgBSabe2kG8wgtul AA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stexgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAro9L035726;
        Tue, 20 Sep 2022 12:49:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d29r59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAC6NCP04stKwfjOlMguD7jJ3kSO0SGMhOOnOZ7cKhKA1dA3ssgAJjswXVTAE63ZyWEb3g646LpBy3Fu7xHwdWq8QLHPQaYqmZpwXBvQNVM4/hzaPw8nwBZBJlResz5rKeCredvkI8wsbST15vCjQSZNuPpFXP7IZLiV9W+fyH0Vrj0UQ7qIyTtdEooRklPrwOex1oO0/8JR715ZpFYwFTJG0GbvstW8hTaq44jm/aa2ayNcRIosJvcc+fpcE3ZLg5/PPCF9Em1CWmEVyQPClwjMiTlztB8jbkF3e+xFjNMmMek6wfp1MosZgvMBGWsBCvDvpSVV36c0tEnDile71Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=NeuIWVSazS2TjTsW1jO+r9kgFMnBQ80c1cgOuq4ntL3gqV1l3C5m8IEZRG8BgnGBDxJrZeGPs7SkqLS1OUmH91ZFlVvnv2ca2Ti8hc2uLHbLWvOE8qJ8zs0gKJhbUOmc6ifD7gD0/1tf/YbfEHNAyNh9sETUFAEldHROxcvoprN8uaAk9psbV6C2sxsqujQ+z8RFGu9apIVJc1vCN1Oe7iivtrLlhZU4UxndIZ1h4g45ak1y53CcJflIOR4v8+yZY7V38PMeKBWkZCPKKDjiJPY1sEDkHj7kPfjckosbTkObn18geui5V4rIGGQKJL3GFm4MazZ/CCqbMhQA9F6ObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=JrHnUvALp6OY+8aGdDgt/8P1VAEp4LLY3ALD08LL5lBkQYUEYLDEp+mvBGTUQJkH04Q0CM9DNb7/neRoNeCj6VSZnDXgrQ8o3H2i0QJNIbrbXIC2tptolblfXKKUjGEERiRZ4fV5QwolfxTY0TTaMVNOAPyxRaNTpUWm9cLxhBI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:23f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:49:42 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 09/17] xfs: convert EIO to EFSCORRUPTED when log contents are invalid
Date:   Tue, 20 Sep 2022 18:18:28 +0530
Message-Id: <20220920124836.1914918-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0156.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ac2fe4-dfed-4340-11c8-08da9b06969f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IpTMiMDujme4lJDW8VD/Rnhs1WQbnUFFMO7wjzQ84eDRzz4HdXzOBXRZDzxbF9jWAHbSVvsWfnn55udY2fKm9B2Bv9BJWM3ICRbMhbWEzrtFdsGeOrF8nXUY/8hKppYOXpt3UYxG4swCn2V5LTOVnSqf1JQjXLM6pnNzhlW7Ua9O7vgrZn7mKk+smAvKkp6hvE0zk392LOb+nj8HkMwsGRmcUT8Y2y/GudDqU88vfsweQAsiszUkuKOm2ZJXzUkXLyYrpfxBLvjUcv3/f2efBjh0Dgr8v2d6Aoa1vNT1k2qr4/AbHgyYSgKVAjkq5lzO/3B3CHUYVE+mTKuU4ha8cFl4S5q+zCiLBvNbBtLSMNfsSnOeC3VEQw8lggainhmRT8Vm6tvn5+Y9okMMURKrKcmYvQxs+7gAePpEuSjbm89yIcSsQcQ0P6+5zLSNLIk5DNfERMDtdWKSXFECQVNQLAsVziE12fCJp1FBMZ+fMbCquo8K8EViLWrsMg+wuHz1frgf+R3iGGr8kMXljaBfqGUXu2jYEZ965YKwzACxutH1k+docsJABnXtd1zREUCdCbZUEDCCJiuwjVRUr0bxCA8s6pkhYtcuAdqtKuvO3sPJWlI1u+wp26wrUGqh5GrANSGvyB3CdHdjNLkikWHizFbrRFXwl+IjoddFXF6AG8YS6ts7JslX4nCJc4MnDDF4j+H+NLjRzsqnNhH9OXBuHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(8676002)(36756003)(478600001)(66556008)(186003)(6486002)(66946007)(6916009)(6506007)(86362001)(26005)(66476007)(4326008)(41300700001)(8936002)(6666004)(83380400001)(38100700002)(5660300002)(6512007)(1076003)(316002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hG4aBTcyj7ZNEiCgoD75pjc2HzT6t/1cyKY8uNAWz8mNtX/aU1K5aLBnwZ1Q?=
 =?us-ascii?Q?xRNdhPiFprQ8TUUJNE2robKv5Urt5AJ1U6d5TJl/jgQuuCZcMsUfaa5CYwMB?=
 =?us-ascii?Q?jj5xtWEETzb3S4qLgF9Zn3LreSKBjte5NLTq/B1m7GFX80eeRsQV/GxaAM2r?=
 =?us-ascii?Q?H2xl5iCwCr41qO2Nc3Nbb75tXlorxzL67xqAm5sx4zG3gW7nCkhPtjqXYDpo?=
 =?us-ascii?Q?feugy88f+motaVO9RtgUNwwK3oGzt9x9NIiZZE8M1L+z7ij2MGCo+GHWN04K?=
 =?us-ascii?Q?hIXBK7SBFoUVKiZ57CnJ4V1QSEzcsfDXekeyDUn3IF+29oqTKlyd91QoWOMO?=
 =?us-ascii?Q?nxTAmIIa7v64tVMXBBcxgJ88zrQlEjroa7e5/ba+RvY8au6uHwI1pKK57RT5?=
 =?us-ascii?Q?onulmuLCpv+11q7omwohmLDco2yL7HeOy1cIbA3BpRHTsMW0l3VQqVaoL/Ql?=
 =?us-ascii?Q?l1dVHDzA8k5aYyzGg4f17WzHJJ5dHh2hYVJW5w39n2WE9NhFb/zB/c+vkCh/?=
 =?us-ascii?Q?86hBwxxR4y8hfgP0aDugjS/dqJRK/CBtJQ93rod/fv2OjcnyBipBh2oAHZVx?=
 =?us-ascii?Q?0LmuQxKM7Jar0vUq1RtFNg+NzvszNDorBUxcPxG4lH6jCpJbiD02ECNutEfV?=
 =?us-ascii?Q?dbuDsU+aSMsLQ+ND8B2QhZGc4HGbf5KUHQyohwCxMoeTnDZfcrIKCWT50nyw?=
 =?us-ascii?Q?I0IH8iLgnoEsKf/OYQ1qw17WODmsgBrJrF1aARz5ANPC68T83WwBY7ACqLFz?=
 =?us-ascii?Q?28gmJB1xsht88V7zp7cvYB4ymrekGtRN0k2OBnKCJos35BWgpyGy3FnarrIc?=
 =?us-ascii?Q?VVfEqFEePwIcxthvO4XshnsnyI/90UOL5xCFtADLaFu5oUMhr+P8Lb9eb6oM?=
 =?us-ascii?Q?epeYR67V5+4f2Yy3vgLWnLh4sWL0XjbMsOx+w+99l0A0Olc91J2h6M254s4M?=
 =?us-ascii?Q?6E6qp3ilc3pI5erTfUJTj8hRIBmPnhmQ5AIMlt9MlGsIsrkZEevBzEvkLOES?=
 =?us-ascii?Q?GQ8JKkt2ymoW+gWSXJnDN1tWiasojOWLmDjAYKlIg7AorpxtSB9YzdFHuhIq?=
 =?us-ascii?Q?ilh7ipBfVnUdrpdqOOIbFRfNBGf8lb55qUtJVWyATnwksabTs4RMUYHW4Mqo?=
 =?us-ascii?Q?hVnX6g42MpGd8xRKxB20P1bLbIw38c1NDoRofdivSeOwRSHuit4rGuLQdkH2?=
 =?us-ascii?Q?/nGjqDm1Q68+zJ7tot71AtsEBEVIx9sdET4IsxWOdePFlx9A7xgr6mCPHbw6?=
 =?us-ascii?Q?XWkSvi7gOmBfgZizdLD1fN1GrixXHsRORK7bKvupfbTXnRHLCIxVVgSQgHKH?=
 =?us-ascii?Q?sesI+2/dmcyIuwPpeDqguoRorGHzkpoZnK/mkbJSy/545o2SallbqJRtTaA3?=
 =?us-ascii?Q?W78lWWSq6D6knblGJEfFBdERSZ+PT3lYi/KnYn78iGpDvPnkuWz23Z4d+dD/?=
 =?us-ascii?Q?CN5CkHPeypDmeiZVSjCcmhhXHatJiIxCdvd7sUKeFyMQHr/DS5YfoBSIpduV?=
 =?us-ascii?Q?EGL96sjqJ4J8WmudSCAsoBAJBuJaV8UK9KVM2OxDnJRdMlqBBTwaIB5Gucl4?=
 =?us-ascii?Q?yAD+jqjcZn6VCUyG2jurUuhRz6meLt+xNoNmR59fAhv+jPjZbG9oysJqGit1?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ac2fe4-dfed-4340-11c8-08da9b06969f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:42.7806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zwHtmldMgJULFU5FktODlmU+OsI5mBlcJJLFqLks98ur5PVrrC7nnyO98S9ElRL1NILjs3112szvVApnILJtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-GUID: gwWjz4fDN_K0wfTysnSETJEw8PTAILs5
X-Proofpoint-ORIG-GUID: gwWjz4fDN_K0wfTysnSETJEw8PTAILs5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 895e196fb6f84402dcd0c1d3c3feb8a58049564e upstream.

Convert EIO to EFSCORRUPTED in the logging code when we can determine
that the log contents are invalid.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |  4 ++--
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_log_recover.c   | 32 ++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 83d24e983d4c..d84339c91466 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -456,7 +456,7 @@ xfs_bui_recover(
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -490,7 +490,7 @@ xfs_bui_recover(
 		 */
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e44efc41a041..1b3ade30ef65 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -624,7 +624,7 @@ xfs_efi_recover(
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 			xfs_efi_release(efip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 094ae1a91c44..796bbc9dd8b0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -471,7 +471,7 @@ xlog_find_verify_log_record(
 			xfs_warn(log->l_mp,
 		"Log inconsistent (didn't find previous header)");
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out;
 		}
 
@@ -1350,7 +1350,7 @@ xlog_find_tail(
 		return error;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -3166,7 +3166,7 @@ xlog_recover_inode_pass2(
 		default:
 			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out_release;
 		}
 	}
@@ -3247,12 +3247,12 @@ xlog_recover_dquot_pass2(
 	recddq = item->ri_buf[1].i_addr;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -3279,7 +3279,7 @@ xlog_recover_dquot_pass2(
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	ASSERT(dq_f->qlf_len == 1);
 
@@ -4018,7 +4018,7 @@ xlog_recover_commit_pass1(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4066,7 +4066,7 @@ xlog_recover_commit_pass2(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4187,7 +4187,7 @@ xlog_recover_add_to_cont_trans(
 		ASSERT(len <= sizeof(struct xfs_trans_header));
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		xlog_recover_add_item(&trans->r_itemq);
@@ -4243,13 +4243,13 @@ xlog_recover_add_to_trans(
 			xfs_warn(log->l_mp, "%s: bad header magic number",
 				__func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		/*
@@ -4285,7 +4285,7 @@ xlog_recover_add_to_trans(
 				  in_f->ilf_size);
 			ASSERT(0);
 			kmem_free(ptr);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		item->ri_total = in_f->ilf_size;
@@ -4389,7 +4389,7 @@ xlog_recovery_process_trans(
 	default:
 		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
 		ASSERT(0);
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		break;
 	}
 	if (error || freeit)
@@ -4469,7 +4469,7 @@ xlog_recover_process_ophdr(
 		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 			__func__, ohead->oh_clientid);
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -4479,7 +4479,7 @@ xlog_recover_process_ophdr(
 	if (dp + len > end) {
 		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
 		WARN_ON(1);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
@@ -5209,7 +5209,7 @@ xlog_valid_rec_header(
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
 			__func__, be32_to_cpu(rhead->h_version));
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/* LR body must have data or it wouldn't have been written */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2328268e6245..e22ac9cdb971 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -497,7 +497,7 @@ xfs_cui_recover(
 			 */
 			set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
 			xfs_cui_release(cuip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 8939e0ea09cd..af83e2b2a429 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -539,7 +539,7 @@ xfs_rui_recover(
 			 */
 			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
 			xfs_rui_release(ruip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
-- 
2.35.1

