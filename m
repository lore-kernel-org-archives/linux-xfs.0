Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D0AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245525AbiBPBhs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiBPBhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC8C19C2B
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:36 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMrdxP024697
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Tf0NjEddFWUOcwlNC6i041NAtCePLr1M7UTEClECjpc=;
 b=YTeS/sOR/QkxNeszRF9UX0l795iKwLolJvhj44qbx9sYtziDaXJLvLBckbOUCi8URhHn
 mMX/9lrS3D/M9FYWsxfnnMcGcw8XdyJaLqF6WukouPmUuIit6Y3cCL+PRPbhkzo1Ji/D
 VXT3D50vX6vh9qrgsWCr4JPrexr9WMr9dMbjL30mm5Z9qOG3WoBDJbgEOq3kP2UiBe1Z
 6uMWC7r7/IAqn0LAbfvyTFzJDVylW6xMS8p1HUDD5eCfH0KhtqO+Zqbnj96M9V8LdXr3
 zcFc5Jl6+62QyrqO0O1Knz0GlxUh4JXuudESsC+OHW/Mz5m0NBIPji57eyi5T6kh2YO8 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8ncar77j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1VQ5X138923
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3030.oracle.com with ESMTP id 3e8nkxj2tr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SChpCh9xBfRkOyr7WSoJVMywaIzRLdjNKsmCLv5q2CHfIcskMJr+JxZ1YJcIDAaykSAU48UsrU30/peI8DKhGKJ3QAY9nY4GAWC1yueA5P9dIn3zvgbqzFfJ+cxsh2Xh06xHGAREX3vZZsMuO3rnQ8d7/L1x6FkzissE3RpmkxGoL84LC6sLNrS0YB3sQYflaQc+3BXy1ew0Wg+EGCFr5jH+he3f4FxeCqy/0XPyieLSZbM3Z2dqq+Oc2F26BHRbpysU8FysZSGLZC7obfZ6fNlWu9r1XTpkLCD/h7ea/03WVsn+C6o/GHbxVwlBhb7p/zSxBcVb6IJFLf6o4F0R8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tf0NjEddFWUOcwlNC6i041NAtCePLr1M7UTEClECjpc=;
 b=dFtTTEB00jPaRpK0U/M4XfN/DzlhL5EorE2FDV8RW+l2AVYLubq9Pg7cNKnWV3wSPIMICdFdLV/2NhZ0q3QuFJDeqVkxPHnrdX/iTrF2TyR/HUxKy4LUVL7+xHTcCtIx21W3cDlvqBtWqxGf+ije80bCsT2UYg87ZPi7dyMAFTkeJ5YnzZq7TPhc3jRMJ3/IpeGCMFaEyQpJ4QVlr1rHd09WQNwV79rxXhILF/EDV+7ib5dq7XeV6JeuMEFZvDWYe3n5EEHaU2eJ/IeGfJsXxPjjjXOu9hvImCppE0ewEJq0uisLHrf4nd0zLV4KGiI5LELX9hYlF/mlzgSvvgYRzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tf0NjEddFWUOcwlNC6i041NAtCePLr1M7UTEClECjpc=;
 b=n6rNMBuFUSB2h7AyLEspWILd9EwLaaqF0PKSI0dk2U+fQV8v0Zvohxz3NB/kBQoz/pvWqMOKIhzmJvd9OnDSD/GSJlf1juMdJGdLTiJl8svhhNdBCejK3A17eHWJQI/dgTA1CB0DpW+8lM2wqNMSHHS/XwLFfjRLozMTLRjxMjg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 13/15] xfs: Add helper function xfs_init_attr_trans
Date:   Tue, 15 Feb 2022 18:37:11 -0700
Message-Id: <20220216013713.1191082-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0769c9b6-a0ec-4a5a-6a60-08d9f0ece213
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2802686D1B4A13AD906D5BE095359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rBFrCVCS7tgtpcEd2dOScMXHOnnSOGMdVSYKDquc32OFFeMMqeUdBB2OjX2qCJeoYNGc4CzRHbTmnScm6+bwxP3uGQDnDsI3pEXy/Gh5dYk8wlrzIEg8Sq4zrhrMQ9QAzJqWZ29eU/DplKq4HYIgEINXdEt/zb5HMJ2IIRQi4PNmXeWH6GRS+aWqF1P/JlPa5ojh5eZrSRCjNr8ts9LgMQM7C12Z4297MemjJ59Ms0dvX3XcRsbrbBniWI6CpaqqIoKgjbS4vK2Xgi831ZiTxd9q3/Ofl3hmUMzFGgz7RQNG6xEUoV6to96ORAGBmRBwu+i+ebgnuwSzYbpFitvmeb1lJm6ZfKTrKAq+zV5JymFjF2+bO+BnmyRyQE2bEfGSA2VHUFYqbX9PycKOtgPOvUsD1YPm0oavY5rBMvC8Z2JCp2/p6vZn+tu63vzDD/56Sx+yHZBQE55SzeOE/HTDpvP3Fw8nqc4QjpJ/ENMC2QC5oM4GyEpww5EqqFPLRPBxZj5Fv19cBLAFjmnxH2NDDPwUH89wbYmUao0Xfro9x2Jf/TKErfwvA8GMyjMdq8ut4q5ClbzjYpp5qlzsX2fXi9B3pubsqBNMml9EPQ6EkvA9BaB1l5R1H0Brqg/7XebX/XJOStHs2MS7E5nHrq/x6OGwqlFPZVcsHUHlUdmbqnlQXI/HAP2JLwa1TGUWlbn7nvgciHeeFlWnhPLcs6vgAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dOfDXCVYTN4Q8qRqWNnVaoe6UB7L0Cu+zxSFvZMQ1b5zal+BUHvjBTa/0nOu?=
 =?us-ascii?Q?TYRXbfLtffZV4GQZVeVjWAR4bpRz/+liIeZvqCa0dUqf6ui21LpnRoVGwQpy?=
 =?us-ascii?Q?b+3wK9UWB6aYoagknwhMUnMBthTxth4vOS6q6lBrTkLWwisExpq1/8Vz1PqC?=
 =?us-ascii?Q?E9Mc9HYRX2gJJ34k+aUru/d7EI/DDnLMP4Lg0pxcD+Gom542AQOuNxhGS2qu?=
 =?us-ascii?Q?1DIZtThR4PwCZabta1bUnK6JF2l7STCBhT3Y3tuFqa9mNZp2kcoQqeG+70IM?=
 =?us-ascii?Q?9dlSFecOouzSrVIZuL30tD4+XkP86pB3byET9Tvq0uWQrjvnjKR8ReCqofrf?=
 =?us-ascii?Q?T1XwDEic65U/xKcP0z1jymqJfX1zwjeffoVvUG5oCKd8HiBwqmWprT+qHLyy?=
 =?us-ascii?Q?pEnQ6u80VoUyiHFln+I5Q8PtrSb8R4KY+AlNR88ge/rhih5Mu0kVboVDO6yI?=
 =?us-ascii?Q?6nLoHXWqCmo02lJsgdvxuRLRydbNDcsVVA+SPG1KA4btbMkvcWYSDPTyIHbe?=
 =?us-ascii?Q?5f9OrSdvGR3JltG5JuC6RDFKS4NRQSx9HSOZq7KVKlr6qM9H1yQWN1Fcql6e?=
 =?us-ascii?Q?hJzPOVq8GyIL+Hx04pX2/lW7ZH5IKvlXD/qNhWAJ+0/pzpiZrN61C6lc/t/J?=
 =?us-ascii?Q?uD7jrUWIZ/xYwLPAdNZSKnEI4phBzo3G7vYXIA/wJ6waGRYLhgNJDz0ZQoWe?=
 =?us-ascii?Q?zYcGGZAsmNPCJ9r2Z8ZeBPI0xy/hbDOz89Utafpg//nw8NB6I8EUmg+PCNyP?=
 =?us-ascii?Q?voHQiLQioOFBEq3ViTq4CvV9okQBIbpZ5/o5qWXlN3XID8/IjsKvkANiBagm?=
 =?us-ascii?Q?btWHiTAKhA2o/OWFXcD0zuM74dtA+hDPxnSSvZ4q+43+Bi535vPEZplCfURV?=
 =?us-ascii?Q?JxEeRFoHwPO4ZWfRJHRhCelrWcM/sA5zjukiPFUMkGQ6fi8t3I9XX816evK6?=
 =?us-ascii?Q?QLM7OhXqOMojyAJA2oWFm7pLGUk3Yf6NJbO7cGiM7hPFcs2GLJz6zA/WPAIO?=
 =?us-ascii?Q?iChpR6720hjbab4D5KyKOj9ou2QTVjlHmUkm2sHHrbgJtjOW70CwFcHj6Fv+?=
 =?us-ascii?Q?qrY1yo2yUEwHxxc5vkIdwyGbmjNH3EjwU464PePvalHHMm0ezAOxwSQ/ahit?=
 =?us-ascii?Q?gATXqFR0ULwnRGti+DzMh+xKBE6V14PzgA6Pgi073693Yjq3qolBBv5ihqTu?=
 =?us-ascii?Q?4HWKFBs++Nwfp9d5j5InZyhxNAyUyjp308UJn4bJeIy2pAJQ5tJriaIOsZ47?=
 =?us-ascii?Q?8Dpka8+biSzRwxv8Rn7qB2h827FWukPpq2oOlAjg6g9yfu66CRm/P2B2ge5m?=
 =?us-ascii?Q?AIn4CiA+QTBOm5xM1/M914pF3xQjwnO2YtvIURjujsOJYoT6iEksMVOo8jry?=
 =?us-ascii?Q?KSuJbctO2MTFSFZJzxVIy/ALmr2QLlmWlW5iDZthmuDZv/uiGlExiAO5o+o3?=
 =?us-ascii?Q?O/VuXdfzPqlzS7bV6yiBYu5QYOAjF0MlPUFV97qGSxrIa/68zXa33tzxN7SQ?=
 =?us-ascii?Q?gqVoeC8pYmCu7FKM2JWldhbtlQwOL3NqxRF0jnerzEnOLnueRZA+GK6+b5/R?=
 =?us-ascii?Q?bJCsFq7sCyt9dQQKpVkaM4LonGAi80lPipe+v5O3L28URpQrZG81SghfSjm7?=
 =?us-ascii?Q?O8IIdKy4x1YvkoRPpv1rIyCyf42zDSn708x8xkICtLjmLmlk+Ptblile1zU6?=
 =?us-ascii?Q?egXKcQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0769c9b6-a0ec-4a5a-6a60-08d9f0ece213
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:25.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M1kQOyjoOBjUkjJyEtG8M0OfpCCqvkaOZCeNO1lOIK1cZg3lmCJuMpJH9RLgEv5ypaSLXMz+uiVFQxBoWAF413AYEfoM5mV2ASwuu2R5qXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: 2JILwwm2BiJUszH1_3ASqqFvGlJyu_X3
X-Proofpoint-GUID: 2JILwwm2BiJUszH1_3ASqqFvGlJyu_X3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Quick helper function to collapse duplicate code to initialize
transactions for attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 32 ++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 fs/xfs/xfs_attr_item.c   | 12 ++----------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7d6ad1d0e10b..d51aea332ca1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -202,6 +202,27 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+/* Initialize transaction reservation for attr operations */
+void xfs_init_attr_trans(
+	struct xfs_da_args	*args,
+	struct xfs_trans_res	*tres,
+	unsigned int		*total)
+{
+	struct xfs_mount	*mp = args->dp->i_mount;
+
+	if (args->value) {
+		tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+				 args->total;
+		tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		*total = args->total;
+	} else {
+		*tres = M_RES(mp)->tr_attrrm;
+		*total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+}
+
 STATIC int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
@@ -701,20 +722,10 @@ xfs_attr_set(
 				return error;
 		}
 
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args->total;
-
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
-
-		tres = M_RES(mp)->tr_attrrm;
-		total = XFS_ATTRRM_SPACE_RES(mp);
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
@@ -728,6 +739,7 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
+	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		goto drop_incompat;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 1ef58d34eb59..f6c13d2bfbcd 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -519,6 +519,8 @@ int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
+			 unsigned int *total);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 878f50babb23..5aa7a764d95e 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -532,17 +532,9 @@ xfs_attri_item_recover(
 		args->value = attrip->attri_value;
 		args->valuelen = attrp->alfi_value_len;
 		args->total = xfs_attr_calc_size(args, &local);
-
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args->total;
-	} else {
-		tres = M_RES(mp)->tr_attrrm;
-		total = XFS_ATTRRM_SPACE_RES(mp);
 	}
+
+	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		goto out;
-- 
2.25.1

