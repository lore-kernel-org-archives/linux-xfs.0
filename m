Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B62ECAAD2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 21:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiH2Vga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 17:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiH2Vg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 17:36:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACC77F278
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 14:36:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TKxMPC013575
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 21:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=JypM9AKxKJ12Ta1/QkNvik4jALgSfQlUi78oFkwa9t8=;
 b=moRGO4k3nqGWWNTwP3pS9jc8wuVVfWjl6UcnPp9mqnNRlLoOPLpjC9jNiAvGEfK3Lbma
 QWdyBB9UXp1YdhLK95V37WVjVp/g6chJMgjAgzINNKG6yFRYGG1wNNPtLrDXUNIg3ZcC
 hjuLk1YNjahzTsBsnOgEtiuKEscG4IHyiimG/Zle1ZuzUQvnaVT9UZJcmQbOt2XIM03g
 ymO0fL5XJJSyE2UIRsmrKPXmn3eMKU09yNNyAXfR5lv8OQ7xhiB+PwKQO3vbG1S4A6ja
 P2kZNdgyfbHTI9XtFgqhskWYUqQSy23vxdZFGbiy5t52A4nZ/F7FpWUfa5gqiBTLpsgS 2A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7btt4myv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 21:36:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TIo8bN038589
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 21:36:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q99pm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 21:36:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMgJsF49LQchY6/JRE1Cmxc7OunwLuvivKDvFczEhx3nZNXLTnV9zSjfHvswMFjTD8WEau465Mi0sDTjT1hkOKCoqZbEVmLEif86p059sptEONbPmV26MkB5W0MF115KiBd3Qqg3QdR3YbHOAstx0Nr4SAP98hbkLdmlXE9JAxox/2NSEUKpPLZSsYU3zXwUO5QfgSxK/UxV3WrMCSn71n9qlttglweRQjxVJ0/yuHWSqUjgKyGGzhJkfYxXs4a5QzcROGpLFRipW89UcKUrvwUhNJK8M2/n6wyT9ArO1qNHS+ZpGvd8qTkI66c5TXO4qPQ02gII/pAaREGT+9l2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JypM9AKxKJ12Ta1/QkNvik4jALgSfQlUi78oFkwa9t8=;
 b=fUPmEmGLGgyMq2eT9Eb0uDasGuSVNxdiXr74VMcYFY90XZo4kz1jIUQ0H/FjEeeks6GYocMYpUxB0HUh3quGRj/0a2SLlSBRP93tzfTGPsVlijH2Ljwx6t8DLUDcpOK+efO/gbTd49c3VcO5Oq0KPQ78fuphZuMoUeRrj318lQEbELNSS6WeXlHznrphGoBaCPItP5vQcIhYSLD6Tmo5upknQfw1UMYSxXlCvGhK44YaSNqQ8VhIObnrvvZPfhyClw3G7Tg53YKC+mXkr0k4NMfW5zntct9wIaPBsx6m0ersDBsf1P8/zpQwJ0MILm969S34q848oX4+jY44Vn+C8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JypM9AKxKJ12Ta1/QkNvik4jALgSfQlUi78oFkwa9t8=;
 b=MhTfi0KO88RP4oN5epKqaotRyJIzj+qNgllCkLssQW18DDbmeOtBQlJOq3USwicwooxx1c9aSgyXLwzYZQXc8JGVAJir11JYrbeZfrYkd2Sb9Yc06XXjhuCOP8+62xFCIks4opEUJ+o8aRmQ9skfaGX/2vA5g3NSB+4ra9PNYv0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1969.namprd10.prod.outlook.com (2603:10b6:404:100::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 21:36:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 21:36:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: Add new name to attri/d
Date:   Mon, 29 Aug 2022 14:36:13 -0700
Message-Id: <20220829213613.1318499-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0031.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::44) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f3d40fa-e34e-434c-d79e-08da8a06835d
X-MS-TrafficTypeDiagnostic: BN6PR10MB1969:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTetqtKN+aK3EFAV9qBqus110Fm6FnCDZNLwBif8mBqrGuuZQiNT1yYua5PVbcyEON3h3ukx6oIkxl1lLH3LYnPui56H7sq5MBRHVbcFLVHHdhwpodzQCkseg3mryw6w7wmZc9g7Kzst8mNEjxF+NuB9c0D/QgVokwkjd/io7kPn/I1D4oOqU15QBwVltyF26eEFQza+gN0VQAX2wLZ8vaP1HARc5qIXoMbP18C7D0a2XPROzDnsi4Xh0xde8x4gNYa2GEfvBJg5LeFfKl/9QtA6yjAai4pEtD+F6cH/aFiunEwhi3G7disCoafsFqgCY3V37U+Zj5MUWV6KdLRJfQr4KbvWH20CkPvHUD0QLxH7AI6myXmpSvzurqzevmPXyYMdR7kZKaE5mtE860/5YhNiuFf+SsNmHQEsiurdgcOHL6JlV1f8tlMIWvY+ki/sn0Tfg2M9qYCkEvxp/IQJTJ/j8XV48G7FuhTXQwN0/ybu8acn84VKmmET7qGIfUB8xyt9BTVJ4mWmok6CmAHVwrO9Yc09lMmUOw3bSOt+BpdXUxIcSQt29hwkDzlPGA+UcanTDEr+Op5/rVnAadoMpaY0AsY31cY+LqCPZAKYklubLvdqrBFPL4bWchV0gNnaC16GM2DGAFQJSnVcdrFlA5Xl8TQD26tRaPaCFn3XwurJnoDI1Y85aqYck839pOUnsiDceiC+/zE9cJKY5uazZuYjEH5bldf1DTpcdS+15tECa5YB/xWbnu+e+/RjOvxu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(136003)(366004)(346002)(396003)(1076003)(186003)(6512007)(2616005)(30864003)(6916009)(316002)(26005)(52116002)(83380400001)(44832011)(6666004)(6506007)(2906002)(66476007)(36756003)(8936002)(86362001)(38350700002)(478600001)(5660300002)(41300700001)(38100700002)(6486002)(66946007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cYUagbpEo4NuUSlvj8wKmEPHt43Sx/F9ZnIJHJPR77/UhKSMbyqo5nmKnLgt?=
 =?us-ascii?Q?b0kOf0M0zxGphngmdHpHvrpGzbcYwyi5OrbFTZ1dVZTd3Tr24/nt0eXlpzKn?=
 =?us-ascii?Q?94u3nyX81TvT2Ci0eZwv2QVSyX3Sqoyv4bjCBj/gSdsh5m+i6rjC5xXY2jxB?=
 =?us-ascii?Q?yQCKkqd8ctB2+baaVdNJ1BNjmQ5m8XvRKIyyqfR0mdoKNGHTE5w5LMi+I823?=
 =?us-ascii?Q?Lh6nJCbDnCPiNAlwHTwFS6oJaurUVU6HBn/SFcxmeO5si5gNDrD9+3xbV9DF?=
 =?us-ascii?Q?8M1hNauyQABJNhq63MYcVGXpaVYl/gyprmHRs4EQi2oFuTzgnKnPO6KQbS7V?=
 =?us-ascii?Q?BKdtuKQiEEPrQDAMpQxBvm/aKJm4i7HL8mqp6CQVU1PFz3l376KqeaYd/DBV?=
 =?us-ascii?Q?vfujNOtV7BthXDF2lkPznCuUTxtL2OtShMMEVFbprIiwqMDiGacLUKya5Hj7?=
 =?us-ascii?Q?QYfGJLZjpN5ZRvhWGhYACTzL1gvGg4jGKHk2/avfZqt5YuXgqpEPWVIRpKkg?=
 =?us-ascii?Q?33YSit3LQNd5cMyNMoRrJCLE8UP0gsm5p+AeP9XucM2Y4TNoRcbDJUF0p2fd?=
 =?us-ascii?Q?vW40PzY3PO3qFCQrRYwxjYuKZXZ3rdoHc1Bk1SgCIvOpW7VMNPYz/vpf9oeL?=
 =?us-ascii?Q?TxO5eXGCGg2fWEVz7LQlq8knkN0z1OpTVuoa7S+69Hhb/LeeL0CQdsEb73JF?=
 =?us-ascii?Q?Lu7CD9GaXZNeME3coUiiz1Pe6Z2diaBxZCda47k8JYMczzpgKcDN57oqcfQS?=
 =?us-ascii?Q?baHV52SLZXzbBq7Co4bY/eSPjWFUAoB3ozL2TUgTNQzk3dPBFWkoHgsnhDAz?=
 =?us-ascii?Q?AsBr5z7p89C6Idz3FSjBtsXoynOkRAMPoaa2zkNTHAtvpTrhpktWlmYcgDVE?=
 =?us-ascii?Q?6UMCsZwUAw24Qn+uFc3bXQmU5Q9yDLiLQ3F15GvFUigF6qrZwfrd/MRzSVPZ?=
 =?us-ascii?Q?GQb34NeshbeMPDkXg5dGxxHMBvg76ovwxTwL5tgix+VOOf8ZTJYDsyWm0hdc?=
 =?us-ascii?Q?AwLYYZuClShGAv8ivbzG8/btB3pJ06BUawFH6SCqPW5eUGIY6ItaORhL3S0B?=
 =?us-ascii?Q?nvPnKStiZm2xmmwb05exm1QNfGLuNApTCu9sLmbbMQIJ2h24m73QmNSGYw0z?=
 =?us-ascii?Q?a0j+Qjj5dXD7nG6ewocXMhAoJuDEyqp9NB/b/d5y7EBXCiA9PESjAXgnKZsU?=
 =?us-ascii?Q?U+gfcjLTUv2j768EdD4BlhhzYgTiaansCmQgOLYCBGX/dhycs02klatigfJx?=
 =?us-ascii?Q?aP+u2Y2zILVZiaddfsOtN96boc6n9TpUi8Vgy5AJzjx/U3f/p8kP6iggVemJ?=
 =?us-ascii?Q?BEDJBH1FYxXwAIGt17q6f8MyatpyjgeVDY/+IgIMe7do1qq0bg9PcmF0I564?=
 =?us-ascii?Q?BpKOI1SZ2F6As7jDA2325aBaOIgYV5IQvO+32aADRiHNN9pSX7tagAGSOUV6?=
 =?us-ascii?Q?080ezFSCfNxt9rItjDaDD8Mjzd7sk7ter0nkXznukqxZ1HFskUEwIXGNdRtE?=
 =?us-ascii?Q?Gqmq/9vuOsDXTFT8hbecioAmgqc1XhC5piotz0xZTn33g2RRfp81DTbeIW9K?=
 =?us-ascii?Q?WxUn7xLgxmKQMw226egAIntAorEq1kg+rJbxCtZMPih5wMe3HX65s6S4o811?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3d40fa-e34e-434c-d79e-08da8a06835d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 21:36:20.6166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ORKyO8H8OToUwz8kHJMu2B1lbkqyuxE5BuU4BZRMradNDiIauX9nPjlg/z8IO3ux+QZwlOzeIK67EVCT76Dty0hhgMr4YwPU6AaxsdKtp+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_11,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290095
X-Proofpoint-ORIG-GUID: EcPOb_WlUjoU602IF39QnLgoinobopPD
X-Proofpoint-GUID: EcPOb_WlUjoU602IF39QnLgoinobopPD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

updates since v1:
Renamed XFS_ATTRI_OP_FLAGS_NREPLACE to XFS_ATTRI_OP_FLAGS_NVREPLACE
Rearranged new xfs_da_args fields to group same sized fields together
New alfi_nname_len field now displaces the __pad field
Added extra validation checks to xfs_attri_validate
  and xlog_recover_attri_commit_pass2

Feedback appreciated.  Thanks all!

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 +++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 109 ++++++++++++++++++++++++++++-----
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 114 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..b1dbed7655e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,6 +423,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -922,9 +928,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..a4b29827603f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b351b9dc6561..62f40e6353c2 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -909,6 +910,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -926,7 +928,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5077a7ad5646..76eb454859f7 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*nname,
+	unsigned int			nname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -85,7 +87,7 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 	if (!nv)
 		return nv;
 
@@ -94,8 +96,18 @@ xfs_attri_log_nameval_alloc(
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (nname_len) {
+		nv->nname.i_addr = nv->name.i_addr + name_len;
+		nv->nname.i_len = nname_len;
+		memcpy(nv->nname.i_addr, nname, nname_len);
+	} else {
+		nv->nname.i_addr = NULL;
+		nv->nname.i_len = 0;
+	}
+	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -149,11 +161,15 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->nname.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
 }
 
 /*
@@ -183,6 +199,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -190,6 +209,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->nname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
 }
@@ -398,6 +421,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -439,7 +463,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 	if (!attr->xattri_nameval)
 		return ERR_PTR(-ENOMEM);
@@ -529,9 +554,6 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
-		return false;
-
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
@@ -543,6 +565,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -552,9 +575,14 @@ xfs_attri_validate(
 		return false;
 
 	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
 	    (attrp->alfi_name_len == 0))
 		return false;
 
+	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    attrp->alfi_value_len != 0)
+		return false;
+
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -615,6 +643,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -625,6 +655,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -714,6 +745,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -735,10 +767,41 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_value = NULL;
 	const void			*attr_name;
-	int                             error;
+	const void			*attr_nname = NULL;
+	int				i = 0;
+	int                             op, error = 0;
 
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	if (item->ri_total == 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	attri_formatp = item->ri_buf[i].i_addr;
+	i++;
+
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (item->ri_total != 3)
+			error = -EFSCORRUPTED;
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (item->ri_total != 2)
+			error = -EFSCORRUPTED;
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (item->ri_total != 4)
+			error = -EFSCORRUPTED;
+		break;
+	default:
+		error = -EFSCORRUPTED;
+	}
+
+	if (error) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return error;
+	}
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	if (!xfs_attri_validate(mp, attri_formatp)) {
@@ -746,13 +809,28 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
+	i++;
+
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 
+	if (attri_formatp->alfi_nname_len) {
+		attr_nname = item->ri_buf[i].i_addr;
+		i++;
+
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
+				attri_formatp->alfi_attr_filter)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	if (attri_formatp->alfi_value_len)
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 
 	/*
 	 * Memory alloc failure will cause replay to abort.  We attach the
@@ -760,7 +838,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 	if (!nv)
 		return -ENOMEM;
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a7930287..24d4968dd6cc 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,6 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	nname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 
-- 
2.25.1

