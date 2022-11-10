Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC8FC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiKJVGQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiKJVGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FA05FC5
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:14 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0b6o006965
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=bisSlqZ0JPhpWwCtmLUn+PlJ2Rlgy/CxbnYC2+xFTAQ=;
 b=Z3ow52OMtqauFQkrRMtKx3Y3zCg82dUDVn9f8m+99B0yK8vULlae4/NifMhuq0zTvkyZ
 xzgbafBb74Qi3e9FFkZWb8p6PE+fxi7B6Tuh57+ofjdQp7myCXzptKYh4+7UJymlaSB3
 oxAeb/UVuX40i/DjWB4HsT+FNz3gTbD1NMmAeBIWVnMC1YOPq5r0rHsnmfhKSaTbBxSM
 azc2pVY4GPoo9f9azP9srxfnWbyiR8iuyRRFDZuaCZ7AoE4U/kFmI3afYjKmw1d4yphR
 17F/Ro9KM3E+eMwOcGrsa/fC9jpdOT5tNDRaPrBjN2414vRiS0YZxtmefA95goi57+ut rQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r15v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKajiR004079
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctq0gtw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0hgrQ8lq0VADLyYNRNxIaJJm2+EIaD7So6QaI54mzvHE0i7iRO2w2OZ3JmKIbU/JomXY6t7Zv+6W+ppKUOS3pz3rarP0lpmKcwG67SHl4kvUcJbcMcGomfo91UHQd0YINz56LhE+D7wIA4LlRZIBJNcF9DhmoChsRd/BL6EOdKFQ7eSo7bLtj9K/TqmfEwYuo7g2ddRPCVGy8nY/TtnyfRjt8E58MB4JWb1ny/PCQq0xUiZ3kM1ddcXiZEruoPCw5fE62SW7fFZPbl79HLVof95mC456sQqmlISl3vGdZjnWrQiS541op/TyCaozFtk4CYe/aj9D3ayr6NBiBUGVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bisSlqZ0JPhpWwCtmLUn+PlJ2Rlgy/CxbnYC2+xFTAQ=;
 b=kHkJaKWW/4Wk5ouOGeX5p/36acgGTLv9E87sNSF598dxng+0QMgKdKt5PVcRRi3R1yPP1cLv7Eo0Z2cSOkNf/Q2B/ubW4SKjdHBxBEA809X6HNiqfCX9Ogi70GOB+0AH2QQEA+9mbPt3SkkpRrgbOg8PN++TTluwUJTvfz4iKTw5m15OTm4XVy7OYsolpZmu4TSBRaLkd+4D/Hw3aPE4ptotvdTSo+rPNhTPGZpu7kzcjr/qHD9xOQylHbDo7NCR4glrUTdUFlrylqX/Lnnl4JWSCrN8BkuEWdL7qfKq4n0SNGuJ8zXtt8BM0VOSUbM+0nl73z0wMWMDxk1eohykxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bisSlqZ0JPhpWwCtmLUn+PlJ2Rlgy/CxbnYC2+xFTAQ=;
 b=BBY0ezcq1+EOSrEoHRSZTX8WsbVkjnLC5Kf66odLbEo72G5a16ZS2Yey2cxVUPJax1fmOvkTJmML15ftRenM7wNkJNZUHCGQeSjY8hfzsvi8Uos50rMhZ+wjAr8SiVyO+tqv4Y0X6T2uRCfGc83b30frVnVZOUvoZxzaeMu9HSY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB6318.namprd10.prod.outlook.com (2603:10b6:806:251::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:51 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 15/25] xfsprogs: remove parent pointers in unlink
Date:   Thu, 10 Nov 2022 14:05:17 -0700
Message-Id: <20221110210527.56628-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:a03:331::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA1PR10MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 2572b676-2699-46ba-1d7e-08dac35f590f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Wq/cBWnBxmCRsgb6yD3Jl1qysz5LzsjMYDMpb6/Qe1K8vimThP+p1ZlSL1hgW45yPmMAG4TDsNRWaeW+1xtwpYgv9xVuUpOJV+9737kEF0JehT5Wy7S/zn24hSh8nZe6ALWx5aOevxtt91K6IeCeupKWLZCXZHPU7FCT+SpNwfFSrGeWC1zWTRC9GmXJSleGaxLSsQq5EjNWKZZsnFte3W2hyCwoaDCOGbpib0IWs1wDYRzc3SMKgW92B4zKqhaoT4ZJGLXH4uEK9YVzYoC9pgaAEStXPkp8rmkGQdMO2n473x4KFVdlFkgjp/fgkWYZhKn8AT5g8JSPft1iN1f5Ec6Qhcfr9uKy210kVMrz8A+vSVLZE9LjGJYCC/xUzhu8js5pZUOsYtjff3TgcKZs6AwM+eKNJim80cxq1w45wLcVUzq9z7+sww7qNN869NHppeafTiQr6bsLV3piEtKufGdlmT2XfwcUDsrr7BIEFPtAzXxzLGJJLj0L7W4eTV3gpOMcm8/jyXXMia5jKuqh7ODJh02KitAeqdX6w7TOT1Qnyor3R1IqDazSbtPUsrpCZKcrO70EyDU3clmirvkEnfr3/klAQQTBpKP4DoA6W13/e0MsAjM7M3HMXaEFlyOXNVKdwzctJItbg3OoI/5N0Lhp3BP40ytvRgb0bpbYmcBASs4r+7eQJr/BvSNAc3bzgD6x6c6x5qBJXqfX+/uyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(2906002)(6916009)(36756003)(66476007)(316002)(86362001)(6506007)(478600001)(9686003)(6512007)(26005)(8936002)(41300700001)(6486002)(5660300002)(6666004)(38100700002)(66946007)(8676002)(66556008)(83380400001)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HH+HNwXKuUC+axDHPL5K66k60cF5sZf6HRwXqCSRdzD0/dWyzhBx2mZbb9NU?=
 =?us-ascii?Q?/tvMMsdeAkupi++bJjD8wNxr2HlU6MNDAhosiHrn4emdN3Y8CBIkwaCV9xUA?=
 =?us-ascii?Q?9S0mZvVFvKA7acn6Tae+iHkBkP9WeOL6ZsmIYykIfA48PcNRMpdQMfM9xv8h?=
 =?us-ascii?Q?Nv/lfyI7nqE/CEchO7vaHalH6oTDA+VQjT09xDNhTtXjtXjZg3qvo/XJsoyd?=
 =?us-ascii?Q?hajF1pbaMe1Ww58R6/nWPZCL3rwMDTQFsS5jP8Urz9M0iVIakca9m07xJySg?=
 =?us-ascii?Q?FU6dm3Z+OZjf6kMW9m/zQN4u0MugVX+1VPNJO4Gs4Q7X2ZOvnf8O14bup/jl?=
 =?us-ascii?Q?uk6Lk2uQY2Ai+vlSR5Qcwd20W2pbkzzaOwpAVRXiLCcxDKeeTLJOn2vURQGQ?=
 =?us-ascii?Q?Xm6ADxVs2B2jLaIxOJQ7d/7uyoQQjKv/u/9ZD7HHJVkMpF9JgngKL0tlvkmp?=
 =?us-ascii?Q?RWW0JD20/jdpKryyaQGo0eF72vPv/nWYeNNMSYyhh649jKTLx8x1FCzDMetG?=
 =?us-ascii?Q?ZS/fKbyDLKAOTa5BGp+3QPga8NxUygneoMPPzmsWtrzdPcs7wqt4cGnP4jdj?=
 =?us-ascii?Q?5kwGmlaxTimq/YYyTs+E61TvMk+JnsL14045q1pGHYh1WSzp1y47Oj1DdUm1?=
 =?us-ascii?Q?ku9HHgDoq12feb9/BXWjKMC1+Hmi0M7CES8tDHwSJE6ByjaMApwTEnWLZkre?=
 =?us-ascii?Q?OO1u4Z/YT4idQWMaE4ZpHcv/n4PuMd9fbhJSK4ymLKuRS04YWja+3drqnRqb?=
 =?us-ascii?Q?VPcrDW5iOcdYURll5sX+C1l7MeypXfP58arb1wE0n5kq5CJG7LRrXBceovGM?=
 =?us-ascii?Q?lzr+Qfj/J24DbOC+DNNIioHfgQUT/+tu+OtURBJQXXowAMKtwDLCkoT/Y0Gt?=
 =?us-ascii?Q?KbaWV4HHis6YmWquMQ2MNLmkmgfp1IkEXTJpu520rpXbMcCzVFQjnjh55wG5?=
 =?us-ascii?Q?/wyjvqYpcyeQYI0AfAM/+CAuYOnlZbXWF7uZc6Bi5LoY0GiDUEvO9MRUgPS8?=
 =?us-ascii?Q?mfcExBAIRUFHgWQC5+KCSqpZULhlxDn1IWMpggJUUsU0ocARIbonFpTT/U7l?=
 =?us-ascii?Q?WOu+f2pe602vC4YISVViBFX4xWiywSnAbY0dPnoyyjcwwCgOT83tGxxI5xg8?=
 =?us-ascii?Q?tpkQMu7Zukq9LIs96QZT3XBYbLn1GMEqA11bHTYiqVW9Ccln2wCoNDOlQSS2?=
 =?us-ascii?Q?x7eIhIAj0RYkGv4I2U1l9nT+hZKm1ZNM83iIktYltvC6b/aj5krIMTiYD4zM?=
 =?us-ascii?Q?yHYtO3WX5dMg4amOFyU/OXQYAwd4FSUNtwrLTebRXkPdxdwyhnPTbcoStSI1?=
 =?us-ascii?Q?7rfDxJ2sLMJ9A1qrCRgbKJnim2bnqkmDAk5bCARcgNqW8yL62tUmVaYVbS8J?=
 =?us-ascii?Q?31IJMHrfvudmIUzIdqBmZ1cfhJVoyFlmrWXevktlux+a+fFuEU+VWEsIXyLH?=
 =?us-ascii?Q?ovJhWlI/Z1J0IXrRNbMcH/EVjZXNznubfZvMwnEWZFB5wVm8s3+Yz0S8TYZS?=
 =?us-ascii?Q?UJ4dlbYM0mUg0nKb+AbqoeQrZSUoNHlyylCMWHIPB8sZmFAsZkxoLm5jn1ZJ?=
 =?us-ascii?Q?o3iwQqcjzECi8Xp1UVfQHMIdEDs0ixJH6pEPATokzNUDIk3jlXomp4k/WTDc?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2572b676-2699-46ba-1d7e-08dac35f590f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:51.1537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c0ij5r/+jSn+FzessqhfPJ9MoGps14FILuF+/SkmT4te9Pv4N8tuHLGBXHUsG0Ecsh1emLsTOS7vFazwu3ItVyMXmMj6JOCbR7e4eXMMnd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: 0vofcaJs7TYp3pmCy9_KsVrpPpXGNIJs
X-Proofpoint-GUID: 0vofcaJs7TYp3pmCy9_KsVrpPpXGNIJs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: b9ffc3d05531820aea30b2caf3368c312d8b2508

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c   |  2 +-
 libxfs/xfs_attr.h   |  1 +
 libxfs/xfs_parent.c | 17 +++++++++++++++++
 libxfs/xfs_parent.h |  4 ++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index edf7e1ee37e1..04cafc5f447b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -944,7 +944,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0cf23f5117ad..033005542b9e 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 80318ae5745b..4da2e1b1a1d2 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -126,6 +126,23 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->trans = tp;
+	args->dp = child;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 9b8d0764aad6..1c506532c624 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -27,6 +27,10 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset,
+			    struct xfs_inode *child);
 void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
 unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 				     unsigned int namelen);
-- 
2.25.1

