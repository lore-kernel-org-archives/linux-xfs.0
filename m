Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F88C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbiK2VOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbiK2VNq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FAE13DE6
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:21 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIXUhd031406
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=z3creQbH3Xf9qAdNshfrsno8Scw0BDN1qnzR08TzqZs=;
 b=ABdXL1dLvJIP3ZthuOSy0T0iSAgwSW8BDKSunEH2FSqyKQt7Nr03Ma1i1TEoH8SMEwjz
 c3pW1JrNgIk/+AoXrzIFygFCnBFwF4gS3FVGJaB82NLKextKx13X3vARj83WJKdrFEAx
 +tjvTifGeHB9oXy0hHsdNar2FvZhI+hsHF8QJ82Z4BtRgSwRddCk7XuyhsgbylWui6Xi
 dwnltMkOh1MVohRZONU6DXIpgbLgCGQyUrsxrwq9D0M359uxFYJe2hfW2+CjE/T5h+SE
 TMVJozxNFOIsf08yaCR/fNAC1yVeKk3VBR5CQyyIt9rRlggeVTyosBK+sLs49Lfjes4g oA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m40y3y5qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKUnBd027897
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj1g8-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbZ0qRrYhMfpnwZme1IofWEaM1xulJd3kKBLB7pzUFtZsqJKHfFUhcQMOmSG4+O+zhEb2ubH5zeTQZ9p1wNnlyp5ynF4692Y6wxklGtIcl7IFDBzKG1KBmUM85msGrvRbkNhOGqfzp+WMWoAVqMVdks9z+Jr+dgx8+poDul9L0tUFfw1Z1ZXykwre4CNypvAuiqSAIVMhvM66gDPhZHYPAxhhmQavj+Zn94t8rRXkfFrrM2Nj5GLcmYjpiYQPd5If2269eyQ3rLvUO36kyXBXlulBQw+myFGJAd/wtk6VJVNLkNgEDZH7UTP0x8XpylKMM/dXEzy9rATFLxn7B/luQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3creQbH3Xf9qAdNshfrsno8Scw0BDN1qnzR08TzqZs=;
 b=E8SinAPJvJ9WRzT4VvQaxtduzusCPsgoP0VFwKk4G46xw1Saxtd1EauPen9Ou+RqbSWTZSd3nNBoYFc3vW4i6ca4zVFx6hao6Ud89i8OoN6UJTThYHkb/jNEdSFRPZzjeIArPhchfN14avsRZ/MN4u/pGnfR5Me3MBcBZ3vg9fkOys4dS+fM+5B7wBPVYR6hpDJqtnagdA+O0SgyO1cz9MDUgudVXf6vi0ttDSGGGMqZvlaltm52wFPvloY33Lt2XhsO+IQFLpU2ctFLL1lGBLOPN6wHO7Itg2rfulfdLyW3p8etgKZMfLMJukE31lxuLDKbAWWpSVxvIzMsjEpAdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3creQbH3Xf9qAdNshfrsno8Scw0BDN1qnzR08TzqZs=;
 b=u1Ea+sTKGib18KzY3aFLMb20DSGaVMpafmvaftd8xyVoR1PYQQb6ES7y7I9i7FVgFzttuT1HziiHxXvaC653Ljzlt03bdt+poLcjy8U+xW832W+4E8vFBe7gObnMu3A9RddhUCRAdNCbNWXhoywOQRJc47T3I95f1J/nsAEBytw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:17 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 21/27] xfs: Add parent pointers to xfs_cross_rename
Date:   Tue, 29 Nov 2022 14:12:36 -0700
Message-Id: <20221129211242.2689855-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0057.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: d80a1688-fc84-49ef-c4da-08dad24e8921
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t4OEsf+7qZ/ZttssCUuIAY+5O0DUj2KzRDzr7He8RLJS6QKnXKfIlS/XvUGgoIeC1hMxCwR2ogUxYEHzOog9bzuZgxwlNX/sAVlrTnn2USJuzdMHoUZv13vBjExjKf4R4b5Yvq/ZNAPi1NFyzglEtCt6P8Aygm6VCUoOn/hg/dRmdCyeW9lN6SaPbjuvWWbgrnOdQPhGaqMTbvKHobM1H9GkJxotacfyw2SxRzv0fPST2HDueOR1Z4/tj19HYfgS2zLmkTwvDCU5COrQiiTq0ECznUhkM1LQ1WDQtWoyNLSjVOsGa8hBmMxxT4oxzvY/mTa6gP1X2zIY+qzzrn4T5Qyf19w+PTAV8Hj7ad+8uPcIbEy3hvbVHLF28CTz9nFVLcBIYirTah3c0M/9gvLfrZQnsqesKHo/ejxJwaUEfGStugo1DUr2IWxGEOmOg0fJbIeDK46BK03+/CSUrV+IoJINoFx7oHO6PvjzpdjgXkkms9LRrZDKPqSiExU25CFOOe7bp5e6KqzvzUNhQeB/sDAemBwvNX16+jkZbd/QefLy+2jf9E6nSvGL0dTbMg9j4F/N02YKL2FSDJQ1BLrbt7a7DoKKXiEMB5YNLoW854GPRuqfUEIX5zOhlCKG8uQb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oYIRt1ksoIwzzcm10+glTRdux2+fHDsOg2UkQkB4y9/3GcJxQxLuQeAoUfz2?=
 =?us-ascii?Q?py9Zwnjeu/agOVHlwPWUEBCJXlg59wofXzHHXQjEt80zZQUG/MKj/7XRtAgl?=
 =?us-ascii?Q?urADO32SnEyWyeVtftwfUFeNG5W97w99RMCvpxTGKefzETIvrAYcgEslskPN?=
 =?us-ascii?Q?Z6A9FAl61llYKT2xGiylBVcQSVyxQLT8blaP7eS3ZgMmE8G/EgWD0nlBXSrC?=
 =?us-ascii?Q?gwxLmh+7Lz6sWiIx4YR3bdbvDPLSmnBUIQWmcm26cHJx7j3l7X83SGyg/mYj?=
 =?us-ascii?Q?6fjnFz5pPeoXZdZvVyR2H2xOGNYvwkdo/vRjCzTJGPfPnZ3FRJffd8JlImkz?=
 =?us-ascii?Q?NKED8UPIOo98rLennt0elLx9AG79ilUhhbQwIPZ/GKw5u8u9pCdfvfqpDdIx?=
 =?us-ascii?Q?m6UNO2qQkjqyUzbfuIVGUfeRv4AYHGL4XnMuy61o3V801GPhCSmvIYw/vH2u?=
 =?us-ascii?Q?UuP60tQsqjMs4ys7F8NiVyDSRtDTE5f8Ld8iKuWFsFyk6IkWpgn+DEhtPxpm?=
 =?us-ascii?Q?DXXPCTOrMloW2+P+VsxxFSLA3x0U3NrxcHesD07QKR7FqlEvZ8e/mdqfBKS0?=
 =?us-ascii?Q?bzr4W9nM89KD6JKUXdIxQuxr8XxrUpWMxFSLoWTFIlCk+3rSC23N0wk05928?=
 =?us-ascii?Q?s/V89huyvMTRgTV6jIONIhVnLC+ehBD7g82RGhKHCM9JEaLYGAgcbldUSqFx?=
 =?us-ascii?Q?euVfEDTUjwUBnkoPcCZgcG0njOM4dhRUYuhno3f/nSjXnmIZAQE2IaxWkJHG?=
 =?us-ascii?Q?qZw7bPsP6G+7Y3wOQ+nKQgTqWpsRXGKwcJ5UlQ0S9SBhlPzU6WA+gMJ7UEa7?=
 =?us-ascii?Q?jQBVDLCUrLP0s7QuszHIZZAsCJCgo1ZITufn6krPEhB+CWNvEifuPbbhveSl?=
 =?us-ascii?Q?lSoEVL457skVfSiPoeYGqr/fYHsSq1LReISRZCM+3RnGm7Ztch+ausYyWZE1?=
 =?us-ascii?Q?L/s0Z1UTOKSWQcmIEZe3LPK0DNKihGR6Ep1LRjj1hy8a0umkt39bAO9tyNbf?=
 =?us-ascii?Q?Ws46ZVWfL255KRkBgcMNeXF3DngtggRqzsbnsVOzezI45WEj6JPrD8PQHMEg?=
 =?us-ascii?Q?M3fMobq1t2haWH2iB/EHe4mZmq5nUMjpeia4rkhzw1gvM+Mk2BPH8jY9Blvk?=
 =?us-ascii?Q?FUVJ+7Nhc8HHW3k/XNNcffFbQ7+Tx/zpR4tNk6DRiPn+mIwBqm4gnpgF7o3f?=
 =?us-ascii?Q?WozqBOLydgosoAulBNwY3X8FDfAFOuEPcJ7h9yFUxD3A4eSrPuMP2tZFRJeG?=
 =?us-ascii?Q?HZlgTtQEnonrrRN8M2EIms3EbUD3Gx3VxJN/qiMp9f6uSxGUsskAH1j9NsdE?=
 =?us-ascii?Q?YTVefWPb+EXPKcetsi4mXjUFbtlDcgHJVFq8swzks1d2F0TIYuuzfmgjKrMX?=
 =?us-ascii?Q?LUuzlZAmi4M4+sTVcTrMSwUpWyGJ0V8M4jLytlIOhauER6GSn+uRcxhNQ8M5?=
 =?us-ascii?Q?3nbFV6+oYgalmc97zyCRjY+1w4TUrDvs+u6wgpu0KRa7mYgWX1KvFe36LPCs?=
 =?us-ascii?Q?blx3y8Ux9m+unSjta+/wDal1pde7yWgta44/60KziktxBzAIWaGva4VPU4BY?=
 =?us-ascii?Q?k53A6Dq8XnMipy33chj0OVrEbtG1RASyQWDDp0jx8IRdhVLfeLpo43ApmOex?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FGLAT1vamlv8YFiA8sX1k/czUuSO4qj4o9Fp/wXqJnu4nYAQNNu3SvR63BK1gc5u2wrPIt0Avp6tqf0wOsXsmMpki8SJlM31ZkgAUs6NIXAsj3Y12gw/Geg1ZlbuWCqusMTAujw5U6yz0xhvjPDVeLN0qTHP+gYxtZ3uI7R9x31ztNQwJIe88fyAXaYep9mHuX0Jj1/U9zfuPDMB295FPOgOtd1k/Z3V+1F5a70Z1tFBsIJ9bBH92Iz8oRZd9LDAl5pJF/GuuX57Y75wzsGko2HXwzA3n2RFa/b5rCeKKzZFza0VXP1uO1wZk+I/h3QaGhlsc9083C5JRX4UYD0V2gQjPpo0SX9+5O4vBNXNvjz8qHkGWXmz3yq2aUCMUl4Dy3SYW8tKVYtUVigIhYXZFbqgSDStgqueIc/B+hBdLmwWElrcK3/hgEE+6PQhNneMeL9h9XTJgXouZummSM5FJ/2oUvxHyCjCujV58vLEarJzwOpwzo28HxkRscAxviFch6UiuPTT/JAABU6u8Hf+LmMzkPJDiCMz9wWY12tpWLg7XhXtVAYk+xkHmdVSgtLw2q18iWaN3zjAoRxY/2B2rN/A5vXDzIms1VJXO9LlHe0J9cb9pX0HhEHN3uLZQ3n/fJm0lJhg3uI+O+mwapAjEG0S9adVBjlQE2YlvBZKDO7XX7oLVNsboaio3uwsUnFzYMsH15wyb5CN4+tYPs7ygHI7LyzY9vmxiNm/erRYb6Ucrzb0c7c4kRjdijpSgE4VbwEilzXjjfL9elm3mhuBHA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d80a1688-fc84-49ef-c4da-08dad24e8921
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:17.7570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67mVmCliY8XhOH/ftyC9G0epbdpjGaIGh6SxRwCFEgN3SzGUrafHfIbwUIa4b2zSJW+MCdpnQbmZrENwAKieR3gjX+uTHG/ePOxOUSoQB3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-GUID: w97RxFtkEJcBMZDe36oCNUoy0i_XxA4V
X-Proofpoint-ORIG-GUID: w97RxFtkEJcBMZDe36oCNUoy0i_XxA4V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 64 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 256404fb2468..f08a2d5f96ad 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2744,27 +2744,40 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	int				spaceres)
+{
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
+	int				new_diroffset, old_diroffset;
+	struct xfs_parent_defer		*parent_ptr = NULL;
+	struct xfs_parent_defer		*parent_ptr2 = NULL;
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent_ptr);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &parent_ptr2);
+		if (error)
+			goto out_trans_abort;
+	}
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, &old_diroffset);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, &new_diroffset);
 	if (error)
 		goto out_trans_abort;
 
@@ -2825,6 +2838,18 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_replace(tp, parent_ptr, dp1,
+				old_diroffset, name2, dp2, new_diroffset, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_defer_replace(tp, parent_ptr2, dp2,
+				new_diroffset, name1, dp1, old_diroffset, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -2839,10 +2864,17 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp);
 
+	error = xfs_finish_rename(tp);
+	goto out;
 out_trans_abort:
 	xfs_trans_cancel(tp);
+out:
+	if (parent_ptr)
+		xfs_parent_cancel(mp, parent_ptr);
+	if (parent_ptr2)
+		xfs_parent_cancel(mp, parent_ptr2);
+
 	return error;
 }
 
-- 
2.25.1

