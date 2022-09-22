Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3189C6FA8B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIVFpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIVFpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109B0785A0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3EU9G005824
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=2BGSacapGkGkz7h/AQx2RQYnQv+q5ltQm6/GslDcAiQ=;
 b=DLr+8sgrDF9BcyXDIIUpRvbOOiwr/TGI9DpiN7HXzLy3MwkOcwh8ixdrMGqUA6h8uIMF
 DCpqTXIVaSjrcMGZJcmfzpjU1v4wZstDFf93S6JZmJ0kBVZWpggPfRu48P3p/eUEqUw0
 lUzRdxIjvHCZ+iP5kZSOfpxRnMizpkFqlK40Cr6Bzh4Nr9VEbaYtWewEsc+KhdbphABi
 t0I7mFs3IJ1Bfhp0CtJ9OJIbUpa4Qpzqx5z70SIugTytXcyGI5Bd9ObqwY+h9WyTFNR6
 XmpxjjHgpkryHdlyBroes24ijci6r4qEShbQoKYy7Y8QWi9H8//uC9cBnL2PZpEPYvXO jA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68mccv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M59ZJQ032487
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d46yc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUQrXJmdLR7BeOCygdegQ7ZzxSxxmAUQOFPw+S3YqzIuroR85MzaMsSkGzZgOi2eMTT7dQY7ol9jIPCzx9JHbhZ1wx0cW8x0Zo2BLOqecIKMek+JbTqqLX1apwkv3R5yXWiEooBlZa0IsCETpO3ZprHP4M5/Ro3IuJPpCjg14TSXJsAsfDm77uPvcl4ac89+IHMM2FabImwGvBghWQsYjC7atmzf2B5SqXEjew83f6fSPP+hzMpwAG/rVd3k0qXQV6j6opjr6p6ezhpAebxMNurcoRRejZcOXveF1cL3p/DXDja8eQUm+3VQpHpOL7IIDVboY2mPujgEpr++gExfbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BGSacapGkGkz7h/AQx2RQYnQv+q5ltQm6/GslDcAiQ=;
 b=kwZVJGd63rtDLTxj93XD6sZN2OpAa3c5viuPmHdGkFDpd04i3n17KCC9oBSATXEe4Ao6zz/IBW6TLPWfW2Sts+fym/8BU8R7iXtMj1uqOnwF5u34DeTwXHaF6IgaYh9l2c35KGrMw1m8wftC36sHYw13BGN2l4Z/gm2NxiHDr5WF1AqyjJZ0UeWdJiblKoFLVibxU6PfBVtj+gGxjzbZEphx8zBGjsvKC13s8ttbG4yIkyeZuffOOELJUAeXUZ3nRIRmRVULAkKLAkcoeOE83r4Ao7QnLbYDlaHeUQrJs2KzyRf+tOatYhOzZYTSzfi2lDakTvcJbTENZBQEulH0Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BGSacapGkGkz7h/AQx2RQYnQv+q5ltQm6/GslDcAiQ=;
 b=cu9GGKrHqgaFIC4+7RM0oDowECauG2O1N7VJP10AwknGVF2AJihwA1CqtIs3HpixC3VsAh2o3Ik3Oo9mPd1KrdErQmsiwEcXS1+2ixO0B7q4gH6x86l6oSaSooNYTPZYokuyhF/o/Uf1LUrhfNj8k1JGZowz7MJ7ZZlWxVp2j2c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:27 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 19/26] xfs: Indent xfs_rename
Date:   Wed, 21 Sep 2022 22:44:51 -0700
Message-Id: <20220922054458.40826-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: fe22a9f8-564c-4dbd-6fc8-08da9c5da71e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vtD0Sa2Smz5zFSkU4ztEklGsQwbFG4beblsbLoA7P95mEL75BlA4NV2AFkZqCVpLIJDfN++YtnW3pwxeIACBrTUp7jA8XPrmeoLVERJZadgeJ+cYeahDmsBMZ6++jrWxj99OG//tUmhH2y9x7zRKCmRzoYIAhgXv63JwFCf/eQASNFXhZKEM4enEkswH1nrN2YJrlFqpWeAYb05quLt7rOC1Ir/OuBfJv3IDTzZ1G5hzZutpC506zn2ccpr+f93UHnNhg9+n2v9zk9MxuXwegUdooSiV+YP1y4GTT1HvmjfDUlpzWx5OEcyuGqrnOO1E7o/AIBw0HfYHz61LBYbwevTGViCELkuzvStUqu1e1v/sawmxFNhxhGsnkmsDE0jCNOjQjM5JG1HN4eBFIiXT7X1+QvdzQjhBWGNPU2NRSsYBHYG3DYgpsiq5yS2Qkl4IKHXYHdSx2Rld4UPqvhsZxDgTufQWDJJMJHTejT3+8e3UJO6VXB5X6xd4nUlsIaSneroqqpl5p9qZVomusBqjn0GVW7469XI+Dp8BGwxjCeXw+R78Ww9RtkLPsXZYUIsddm6Z8A18zq3bjG0ej787zRfYpTMRueZrssEza5gErujns+ybTWL7W2Mu/J/VER/Bl/W3IsOqPmGgKn/f5VDSJpv/WEdYZzEW7QN7NcuhzbO+UwERNcsL8bJgPTnHjyMxtX2URz66HGiPFAWs07SKEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FlBeuRHToAFfXck+YFV6EGlOBpK36YifBiVJBjrR7CQMqdtl/H1z7yckV3oE?=
 =?us-ascii?Q?JXzy8G4OJoofhc6YXcX2mNmbQ4+kgmMfn3hlGhpvEMNlb2goUKtIbbXJ7u0a?=
 =?us-ascii?Q?p8GUvJ20f9N2zfzgS14MXP0tThRbMc7AY0OpVydI8O2aDiXnQHRuwIlPBdyC?=
 =?us-ascii?Q?rf8e6KrbssrGwnij4zJXjkA+O/pjXQCXFjE38cZtxLM7fVlZ4Cynfg533Zr3?=
 =?us-ascii?Q?1G1s/GrmGl03Jo3LNUhs/1v3zwFXTWHmBNxnHDqPQPiEbTGZGuk8hVgUttre?=
 =?us-ascii?Q?rhykIwqsutB8wPfD79ROGz8e+z+6l7LwRN2CV9EN7G5SoDp3LgVvbKsFfwI5?=
 =?us-ascii?Q?jFiSx/YZOe6sm5G6TYTjwR3ZAPNyPEeifyfdLyJLQ4sszorVgRBVujKrZyET?=
 =?us-ascii?Q?72bBbdgzupFJuyVxhIcbt0Zj07KuF4PL0PfhyBhdihaN2r759tSzZ/La/MF9?=
 =?us-ascii?Q?LrqqO0fuvPC/1SRaWez5YeMyFL5iEOFJ0A9cJb546gQU6JJRgIRGwO2stHFd?=
 =?us-ascii?Q?UQZjKrrwuOUzZpXe3pVbBoRhHSf5p79hcm0pmgXEyDn76HetMPCUWh3q4Fdi?=
 =?us-ascii?Q?sJO/wL1plR//kyjB9ExNV/TEBcfjEV6d38poA0wvjdjrDA/bwFzg8irWzaYY?=
 =?us-ascii?Q?al813IY7ZG6GcOB55mv6DMHW1BFOb3louCfalEClouGL69HyDJwpn49GT0ki?=
 =?us-ascii?Q?fm7/ceJMikiNYhqUalOxTuXeMSZGd2B0e4Herd69oSGqwaUGn1S7KtdZcKAE?=
 =?us-ascii?Q?n8fzMnjO2NU8nGwaPQuhtcNMVh4vlY18qMmVQASSD0aV6Xvf1SZeW4nLZyOL?=
 =?us-ascii?Q?376ua98vVJcI5PBAYYTt35ZvZg0TOUjXjFwnVMvx5pkAgZVsqklulzkg6GU8?=
 =?us-ascii?Q?CtvLUgpB4k0bkLBar8GK0huAnOxNoAC988soC44Oi1P0p9dVKFfCAyPWlqVS?=
 =?us-ascii?Q?uRhKDmTpuzqRUL1Fe/XaX+8BzZ4dCt5vqZF/uE8uFIzGaNpkYvmm1GTU8Amq?=
 =?us-ascii?Q?rg+tfchdk+kXdR+0T+XRoNX00vc9ZwGcdr8x615hwtBMJVWHLH+XFNvTVW67?=
 =?us-ascii?Q?eezkSxRC12DWcPGEbfy1vcEWwtYSLpINJpx8YVuXpeIHNZabXGZ100heNJ/T?=
 =?us-ascii?Q?9rea+xKqoSWYdteXrL2pSVCx6twPENaSXDtHUukKWDeTyHZn8Ti+4FVadT7h?=
 =?us-ascii?Q?2W/vBKmUirOdRDQb0SGJtkza9c+VHP2hHS+rKTF2S3u2SnpEnpamGqoWn9/f?=
 =?us-ascii?Q?nAqa2IZGOhwhkXDrtbmiMv2fC+LdMNp2bmK8+JBatShnsXy0gA7SmELXIAR8?=
 =?us-ascii?Q?vhSZi3fsnOFvO3jBghNc4K0ZF9rEOSqBl9cVC7LQ87vwAd511GgtfbtFzMs9?=
 =?us-ascii?Q?qB4/z0l2qYlRdSn8dohsPYFlmFE51X1qXGjFsrEIAOcI8/eTF37XSI2Hf7/8?=
 =?us-ascii?Q?UZuRJn9zrkVPLwAQJkKhdNIEOFwbktTpNtXod4HYRVcOOS+6mwfjPND5RAAO?=
 =?us-ascii?Q?s6XYOKX802/3TpJN5iaVKNziabOyPX+TciqLt82bNGv5Gqm54yPiNobswOyw?=
 =?us-ascii?Q?5JwbREhPy8ZaDNKmr97lskgoMCg607KN51IyVgqCW1BhZy0BhcilIBPgPo53?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe22a9f8-564c-4dbd-6fc8-08da9c5da71e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:27.6809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgJ6jk4vYlbkqvja197lSQnIhCfldjNddGiF8Ke3kTkdfh71BaR6L5juMN8pAhxPsQC/dh5W0bx0gdnJwRR5yC92kn1tzNFT8+7dQQpS+dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: v0Htwaog8_SujlzfOx9moNAmE2XWE6p5
X-Proofpoint-GUID: v0Htwaog8_SujlzfOx9moNAmE2XWE6p5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Indent variables and parameters in xfs_rename in preparation for
parent pointer modifications.  White space only, no functional
changes.  This will make reviewing new code easier on reviewers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 51724af22bf9..4a8399d35b17 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2891,26 +2891,27 @@ xfs_rename_alloc_whiteout(
  */
 int
 xfs_rename(
-	struct user_namespace	*mnt_userns,
-	struct xfs_inode	*src_dp,
-	struct xfs_name		*src_name,
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*target_dp,
-	struct xfs_name		*target_name,
-	struct xfs_inode	*target_ip,
-	unsigned int		flags)
+	struct user_namespace		*mnt_userns,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
 {
-	struct xfs_mount	*mp = src_dp->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_inode	*wip = NULL;		/* whiteout inode */
-	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	int			i;
-	int			num_inodes = __XFS_SORT_INODES;
-	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
-	int			spaceres;
-	bool			retried = false;
-	int			error, nospace_error = 0;
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*wip = NULL;	/* whiteout inode */
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory =
+						S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
-- 
2.25.1

