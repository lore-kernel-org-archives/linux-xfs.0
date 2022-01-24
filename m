Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0A3C43217
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240999AbiAXF11 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:27 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38160 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240953AbiAXF1Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:24 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NMEhds001974
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=daVUUE9P8cNh7WKnlH54ymXnu8FEmu8xfco849edffI=;
 b=EnnefDyPDpzTBv9mttiy0T79p6CAfd3QLU7j4cYIUEue6Z7MAiS7BLHYelBwlWyzaW0R
 z7GCg5zPUCjVeZbu2Nc30YpCF1eilfHwiWmGmkbYWPziTlTyv5oxiY48vdP+N0yIDY29
 KlocX7x7wBjU/6pOsXyclgGpDCWpKTYzuTEiBRVZg5Za/SFeWBFIkXHX9LHzGpuQc9eu
 SL/Akh6TS1azSSSEaERZExUJxx47CV4ASNHG8b+lXkxvE8ATmDDU6OdP7Q08qb3lhcOe
 hFqYePjjivmwJhEWFJFTQTSEFcHOrR4BdOijGdemRTyv0DSmILmo2eGxCWtFZGAzXJaH 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr9hsk337-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5QKJE012201
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3drbcjr27k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWoBf/whFnuLI5la+sRBJQwcj5NXOctgeAm/V7XC5zjAfobJ9A2SkJEQNpGq+2wQkNyG9feJt4yei3PDIFlsyEQr8AdFwzb2qB36VilprBeQBS1KZ0C3iSB/noEig5rduqJTjLc/IJbhratH34kLge+6JxZ7wh/PtIDTM/e6whaQb7UPrkvjJpXIQ2edxUsKGQF/Ct18ZGTUllq3ogXlAvQz1xSiFlDQD/hkD3Oq6rigy4DxKqGZOKqHIYUFo/OzFytOSTV6fkJZkAmFZEVBYJAhkV0C8YiuevSbTP52gOm4p8M7LxBHox28Fw57TTGXfJ1oxfVwoKnaRft8SosTLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daVUUE9P8cNh7WKnlH54ymXnu8FEmu8xfco849edffI=;
 b=dcQ3nOajwcxN/UL2OaKrUChE2kfiesPwNoseCA8lvBr4IGwdayn7CSaG7id6TF4c0VfB8jjVXFkkBLSdg43LJ5/b1rsl5kAXDDg7Fh4kB5TOXPeG4uTDjjKYmiYEGx8cl3Mko/IX3YekZVt+MEyI3IiBUtymrbCzg7JJiAPKLdEFSKA0nvbYKe0fe1SmjDdEvI/VO9LAwJ0T1+e0JXbNd/yFUQj+q6NardgjfUF7lxlWDvcgLJDVonBz206oipPS0OEr9nqnwdGLddWk7wc4pv3kdzmGwzakilxfuXufL0pZPKfl8vLWv54JAuSFvXbJaP+NET6dltzwiucMSHp30A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daVUUE9P8cNh7WKnlH54ymXnu8FEmu8xfco849edffI=;
 b=aI+5g0NdMglpCJN5OwLCmsrfvUiRqS0k2qYmPt5j7DO+Uneru2ug99pl0wFqD8Y4RHfTa1rWSgzWTabRDonlBIbDnLt/zFOfPzioV2VtQjFBcXwcn11QpobB8Kw75sblSvK/EgwT1tvvydMloz/KscMLPuVpknIQAgkB5u/0/+I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN8PR10MB3523.namprd10.prod.outlook.com (2603:10b6:408:ba::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 05:27:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 08/12] xfs: Remove unused xfs_attr_*_args
Date:   Sun, 23 Jan 2022 22:27:04 -0700
Message-Id: <20220124052708.580016-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81e05997-389b-44f0-e594-08d9defa3016
X-MS-TrafficTypeDiagnostic: BN8PR10MB3523:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB35232BC756864C7093D9AD36955E9@BN8PR10MB3523.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WEM3E9tt9D+N39HiX7Vr+/CJpOkqdxwsofkFVoJl3r8wEtbWhkGbmosRKUlStsHObKTdu+TnHXYPe+qSHTGudQMj+SSrp/b3KtNwQwrNm/9HfcekGyFljHwAnWymdRCx6jgDCFQwlrA+EiewLVonBdmzXF+d9R2SJBTAg5AzS7ogI5GFxP97XIFR5tAJvEQXBOkhEIyZxyryDn932aNVMHTLWUZjxERBZMrUPeS71Cmsb06HWmeGhHvunF8QccRuoQgBiQVw+P44UkA3H9QQggjy/6BA+OfdtGzs7gWZ4ESTmZjgE0MvwMIweqgVJT7GwkkaTPQXJNlwexVxRWqUINu19pk+AkqQ0hW8uT9z8oBQ2AfemHj5o0M7NlH2kTZokQSN4hsQmY1erJZNh4Duu7tKR6x6DC4GWL2sPwX6YZBuBukWmTVnNRrAVKRl6PjvqXmKXaBUmPLlSNJ1z5RI56EcOFcEtLtVuzf3fMjdtyo6aJJL785f4RRgL2LzF5bXaDwHOsGkaP+Cnz7Ez0LqTbZBlgPIyJXxOjlgx8PU6hJsHqMUZz7+KfmksdXd9xyuVOfcCXl7FItLZ4X1zTQoKtgpUPHNUXI/HCA4DRmsq6/KIN5gCTHi8upuTPBvOyYcgc+rlNv6B4FabZ8dCcvA7KSApSx+rdhnMjjTgOf+XNnUbpl5Zfctkx4rtK7AYOhsZSQfOB7picWr7WQD7ctUbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(83380400001)(2906002)(26005)(8676002)(86362001)(2616005)(186003)(52116002)(6506007)(44832011)(36756003)(508600001)(316002)(6486002)(6916009)(1076003)(5660300002)(66476007)(8936002)(66946007)(6666004)(66556008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PhhH5hD54o36mS/ifaDMw/sLqS9RCNvMxtQsMk/kP24Tbvmklfb2yMfJhodp?=
 =?us-ascii?Q?VUM7Sd10vc/z/5qNfu9KSTTIdwf9fxhxBZgpj3BHzwvswAX5AHrwDA6ROAI/?=
 =?us-ascii?Q?VCa+T4k2yqw4kAlsbelUH1CxJxjks0b3TbNcNH3VYjLxn9AdSjWVEEv1rwCs?=
 =?us-ascii?Q?6fMv6ptoLFJnDrGdiDueXTHAr0S6preXb2QHr/zVrE3i1b2PALxiazdHAzvQ?=
 =?us-ascii?Q?meIfhVj3YBAs2Ezj/AjECJOxnPHWOGFc1aFmFW11PfjyvK83YA9QbFu0PxTK?=
 =?us-ascii?Q?yWv8e9ddR+zhvN9GkvBGIKxCJ09rLspviMqZhqI1XAKCN3C80WHAXSN93fvu?=
 =?us-ascii?Q?apvlwyCoVnrvOtF+JR81jaeedlxQB7SX/ePNZKl647LXlSZMm6V6IT9yKKyq?=
 =?us-ascii?Q?Upe0t3s7x3GeIxQ76RwYxNlc8+bLY+eku2p1yHziIyQPNE2NdCsGti5JEZg8?=
 =?us-ascii?Q?prL6HUrDLZ0VBeKDmobO3+NByzNAq4XqdAWHl4xBmZh3AdBD9f/snXe52Hm4?=
 =?us-ascii?Q?DV4QzhZfkAJa5MZpiz1l3lBAwTE0jQzYNzpLEx4LdBWBjjq64HYs6rRjW5Gy?=
 =?us-ascii?Q?QqChLM8baj3kYvKgUlFiGOh7x1PVGKpcleRWL7Qn6uP55p9+90BeyCjRI7TT?=
 =?us-ascii?Q?kw8H7vDM9KzGd/BsveiDKWoohMI+Qbd21GP+g91kWYdIAedIjIMU9EA1GuaP?=
 =?us-ascii?Q?pAAajoayXyvjmruh0n0YfMGT7TtQYxMyj4mDo46nTIi8r00o9/fqS2644c/3?=
 =?us-ascii?Q?bGtvEKuwkyx7pwflEaSqqCMbjmDHYjtQLk9ZgH/vEwWkN2FDwipXJs1FXuc8?=
 =?us-ascii?Q?dzMV2VHOrzrZsp/HBujGEt7N9yczd7Ucw2mQrNX04+iTlKb0Ra1rBHyhdYjA?=
 =?us-ascii?Q?aHZBukkeiY4x1QfpRtwHppSBNGMDaUHFL4pJ9i7dq03nZBVoamkqcG8Qso+N?=
 =?us-ascii?Q?qKp4InAWj+42mcl6DrbOSgs2WphU8PzFzi/zoO3LiKmOOBrTOit8j+eN34Ic?=
 =?us-ascii?Q?3ALS+rdXOTtgSk+U74jdB6KFcpP9+F/erLjPM0DxHwniE/xzTCdYhPXCvFYO?=
 =?us-ascii?Q?To5fMzj5RPptxac9eARfaG8/W23o87eKPcbSwrV8drK9y1mrl2+TaLqNNBhM?=
 =?us-ascii?Q?VMNDv3mSORirdLNGC47LYfSterpGHVMMwhn/+B+85pFdJLtugG8lP2Lt4IVz?=
 =?us-ascii?Q?10Uc1OI+Rwjr3mcNTdpXvjIYnsP3qEOV0FkEvymCy+ha9uH74fDv3EW7kVI7?=
 =?us-ascii?Q?QwL+jfwrrZLxty7kv9BCW/uqvq1vWCVLwonEqBr9TwKp8lu/xCkui/TQk5tC?=
 =?us-ascii?Q?jgniyowqj6Fwy8xgUcoLLV+lIKFrz+B95Sfv5GxQ0jImob4tnwr5ICR0ltG2?=
 =?us-ascii?Q?KUUE7dDhwTb39KOcPnTlRugoLe4HuqSfVhr+huG3qQdZN+JOV0OhwB47krxa?=
 =?us-ascii?Q?PwHtuWQdrHO6RRAim2jZBDGUqWFQdNOhGUkJ9n4+sJsbM+JlKOLHzwdWiafK?=
 =?us-ascii?Q?g9VyCjfl3XjZubhpR4vToGYeU5SVOTM+Asvgr/MdbTdu1fTmyS6VeBtQLrQt?=
 =?us-ascii?Q?c6SFJbTAHzsCkHy/JRCbZQNTzlWQ/lcvIEeVbljBXpTYqcdcItRMAU0/7bTb?=
 =?us-ascii?Q?xC0id+/3SgFcDiNimVeC+VQn0+FLwKIEoP3YQygANTGASmI6YYKcJSU0HXaX?=
 =?us-ascii?Q?fBZWTg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e05997-389b-44f0-e594-08d9defa3016
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:18.1039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3HnJjSGjbqSxemjUCR2NJrUVvY4OrHBJg4ffUsMU+UCUmfsahp5u6s+nuafR6UhhzcaNEdzufEYaupoYPAmcjPIoMYHpk4QmICB7N8v/BE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3523
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240036
X-Proofpoint-GUID: KoK6PglnOnYiMOZzDzmRaT-XfdW8brav
X-Proofpoint-ORIG-GUID: KoK6PglnOnYiMOZzDzmRaT-XfdW8brav
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 106 +++-----------------------------
 fs/xfs/libxfs/xfs_attr.h        |   8 +--
 fs/xfs/libxfs/xfs_attr_remote.c |   1 -
 fs/xfs/xfs_attr_item.c          |   9 +--
 4 files changed, 14 insertions(+), 110 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 848c19b34809..3d7531817e74 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -247,64 +247,9 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * transaction is finished or rolled as needed.
- */
-STATIC int
-xfs_attr_trans_roll(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	int				error;
-
-	if (dac->flags & XFS_DAC_DEFER_FINISH) {
-		/*
-		 * The caller wants us to finish all the deferred ops so that we
-		 * avoid pinning the log tail with a large number of deferred
-		 * ops.
-		 */
-		dac->flags &= ~XFS_DAC_DEFER_FINISH;
-		error = xfs_defer_finish(&args->trans);
-	} else
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
-}
-
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args		*args)
-{
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error) {
-			if (leaf_bp)
-				xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
-	} while (true);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -323,7 +268,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
 	if (error)
 		return error;
 
@@ -332,7 +277,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, dac->leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -340,7 +285,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -353,8 +297,7 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -373,14 +316,14 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac, leaf_bp);
-		if (*leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans, *leaf_bp);
-			*leaf_bp = NULL;
+			return xfs_attr_sf_addname(dac);
+		if (dac->leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, dac->leaf_bp);
+			dac->leaf_bp = NULL;
 		}
 
 		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			error = xfs_attr_leaf_try_add(args, dac->leaf_bp);
 			if (error == -ENOSPC) {
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
@@ -399,7 +342,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -690,32 +632,6 @@ xfs_attr_lookup(
 	return xfs_attr_node_hasname(args, NULL);
 }
 
-/*
- * Remove the attribute specified in @args.
- */
-int
-xfs_attr_remove_args(
-	struct xfs_da_args	*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_remove_iter(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-	} while (true);
-
-	return error;
-}
-
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -1309,7 +1225,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1324,7 +1239,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1578,7 +1492,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
@@ -1606,7 +1519,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b52156ad8e6e..5331551d5939 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -457,8 +457,7 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -516,10 +515,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
-int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 83b95be9ded8..c806319134fb 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -695,7 +695,6 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 3f08be0f107c..da6cd88541cb 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -270,7 +270,6 @@ STATIC int
 xfs_xattri_finish_update(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -280,7 +279,7 @@ xfs_xattri_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -390,8 +389,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_xattri_finish_update(dac, done_item, &dac->leaf_bp,
-					     attr->xattri_op_flags);
+	error = xfs_xattri_finish_update(dac, done_item, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
@@ -551,8 +549,7 @@ xfs_attri_item_recover(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	ret = xfs_xattri_finish_update(&attr->xattri_dac, done_item,
-					   &attr->xattri_dac.leaf_bp,
-					   attrp->alfi_op_flags);
+				       attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
 		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
-- 
2.25.1

