Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D6BC4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88EEE610A0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbhG0GUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50442 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235675AbhG0GTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:51 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GdIW007040
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=J7eU3T/UQ2Mly4rg6q6HHFpr9b/VATWPGLy+ovlgcuY=;
 b=k/GgfB/+hn59AWDW3cJTe+vgccUNJoNM8vAppqqsXwN8da1/G3teN8sL2KSm6YnAevPO
 NqAPvZjTRGcnMS/W0G3lK8hvc1hXhxS0B338xVGHPtxsp+et6kCojiQpT77BQZlKGcJc
 F6uhN77uy5G6ejlD9scz17dOrj+VikkAWIDNSgQUb26L+DG8Ehw5CJJB6qXq4XJt+p0p
 5C1vejNS7cIQPsjK8vgmKWRGUh1KTM4QWezCyCWhx1uwP3gah6Rr00Ef3WOHXgPPJe7f
 LchTgYlRlyyA/T1n8+kJvB3MaIETm6PQYw8D8iw60GuB7pqWCAVxL01MroYZvBti1yvr UA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=J7eU3T/UQ2Mly4rg6q6HHFpr9b/VATWPGLy+ovlgcuY=;
 b=ZMI/XmUxswkjnWcZlTckQfhmjBik1dv22xX4WXCkx2fN5rR1wZY+HOL23zuOwHbo0QY+
 mRvIECG5uWYq/xmZdEV47jM567XnQg/CH/JY8g1MK+sBF/ubAPxhv8QtvMMZJoRQ58Cu
 uT2XvaQb0B19Vw/+Uv+0PbvFAh1Zgz9X/1WQO6kLQ1LrfafpUFjfRB2ZjBDwRCYWnine
 yFj60N8YulNOejNXDguQ7P4BmIDae4V5wVqiE13HkHGoQL9PLKc9prIVSBrtffg42cWP
 9EfuGlcfxBh6cHvPZzjBwr/cVPmEXys6SppMnGdZHxCOW7II0pMJ4gkiyGNdkZgRQJfa 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0ue0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJ9114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1WHvyUM9NfuamJGkui/iMVYgft20LpT/poVQJwXF3mWBsSxflxjt/U9kS7DTPoc6T1USvBXjxGUdArhWRWKj1YsGKSQTM3noZ9x0LUmUAiCcx2vn9vpz9CM4x+EA7DldwsA7AHXfeAd/qSGVFzQdzoPIgAKD2biJcBcrIzseR4IYx4ag1l0c0fxcPQYRNgM9GeTDlRxNYaEfda9/aJ8hJAaXKz7EmAHYxuckEtIOptulf3KgT9iQXwi8nPWquna4JnVMVago/cr3axTf1aCr6h3oJW5rcX8zDVXNGiUwc8xSrUfarJ1vBT3WET2YOEjKAoDfbKlmbCxvh2SacVXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7eU3T/UQ2Mly4rg6q6HHFpr9b/VATWPGLy+ovlgcuY=;
 b=KdYZV4kmOyyPKwlSD5L0RB/Oy2ZgjvMQ0Np+tHhE0d8ADRuLNrH2/SpT9sQBPMta9zeVFAyEyTh6KabiAwKK65nyq6kiVg/+8llk0oPZtqQseQxbHQftxKjymfn/Nw6erfGObzbRwf6cyxHL1qejJ8dSZiipy1/1mIxox4d1dXom94ybjlHF38xBd8a5kdJIIhSZ2hzHgYHS1RybP+rmNEtDxwjUpCF7LCifxsKykIC1ENEp3Gqp7zjgcEA9A3tRx7VgnnDZW41SKB3ody52fWktSL+nrC4XrgUEo/7nAzXebN5ZRxGcBAhjfegqpArmJmmWQmzOMvVrlDEL/HMXwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7eU3T/UQ2Mly4rg6q6HHFpr9b/VATWPGLy+ovlgcuY=;
 b=NEuWcV/YBtgt+8v/M+maD25D8/LNawMrROY8JYGA19PRwvDNe0Z/7tHmq5u3263RmyMKSF+UqCjVEqTq4cjsemkFRagEmIM73Xs3BrcgP5PcxZhXNfprH1lnllOS/HSRvQiungVsYc/TOaQw4MULO/G2G2gwOFPb8PtJf7m0jMA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 22/27] xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Mon, 26 Jul 2021 23:18:59 -0700
Message-Id: <20210727061904.11084-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27987aad-bd92-4e35-f33d-08d950c688a1
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2709D9E7EBB5B048DF1C558995E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtGEzKDoHwed6XMkFdpkEG9oglYBCAZySdLJlEvNEjL9+MNfj+yXE1R+hSi2pfDJPMXPeBUAWAdtZgMg851fdMnDe30/FfT2gQB7teJ9IK3REe3PS7WX/dhNjIXxwTXaxwUVktUXn2jW3ypvE/KwRjjKQPDh21+OCtcmhbh7PUIlfmcWRX7x6+QIL5Pwm9wuGC5GMlp5sBprkD8VRF8Ei5nfGZwtPAGTS3XJMwq8bjR1E0SUoWKpIflYGwwXBloYRwPD7qcFbat89zdf7WpWe4rHL/2Tj2zTE96kcDJ8F3JA73hfn48mCMt1hn/zE0Cx9e7MNFz10uF61qdHvoWSxlO88IP0LVbY7IPdoJowk8EbBe5i9ndOZOaFag33tGrWEZKjAmerFdcVjUf3ATVJpyaimpKc7Ff9Riq38ivbQyIQauX3VsG83Sc/K2qqIRuOCIKpBZTZYrovFEQ6BcCTcSzmBl+cgf1VeMmdzam2gldN/aXPfhvC/5Ks99taaG6R8kIU4OLfVyhsph3Zi04aM4Cv+t7yioCkABQUcS9fngT1OFwkPNBkN+6Mp03gBHp52nyIZK8b0GfwollohBkFF6qYQ4LpUhINl/wqwMDns78MMayZkgwSAFRtFvwF+CEix0DI+YmwuibOMrfq/AWHQQGHvP/NWVuo/dg6PB+lKrf3Ca3T4hDM80QZE0koGj2K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(6512007)(26005)(1076003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KFsdr0IHLesmjZCbGGhg3Mo/zPfJeoWb/rVaqSREv8yDw49mS8JBDgHdErsc?=
 =?us-ascii?Q?RdNbMnfCwTlBJ37b7St4t7ti4uU6P3rOTmG0bxEABkmUKHaxJf2Op1OBI/kC?=
 =?us-ascii?Q?DvpZFixaECzzYUCa93NW+acdHzpcn872u6LGQNuFBkxjctudTHLs8ijnIpVI?=
 =?us-ascii?Q?CFwc9nNDWpWRqwlHJLr/Fh3NFYhosmJw3ol8Adt2aNo42HRMUFXdSQnoWp1S?=
 =?us-ascii?Q?rKpAGQr4gGzpUcPQt4jgSC5wOR65ue5sqeq/PNe0YJ3ORty4rnIboJcWobw0?=
 =?us-ascii?Q?kD9GllnHqaR0L/+wCDsTFb5/6XPQkaU3WgXc70L32XafAm5QVTBUm8oyswlh?=
 =?us-ascii?Q?XKajoeOeT7kgaNG3daQbQZusgLXTjCkevkALaRm/DtKKbFpF78kw8cUtydt3?=
 =?us-ascii?Q?alYCbCr6ty4XKq+OQps/eb5IU3rkH73Ff5ekLL41/pXglekiY0SyNL5BVXUY?=
 =?us-ascii?Q?wVixP/sUHWuMRy9Bk7cWuncrogD+7hhtur5KjrRYJBZPFfbJsAoR1vpktBqm?=
 =?us-ascii?Q?ZcP59a2AzEYeknCzBOraZiYvDvnoGBq77LHfynRKZ7skNE8tuNpd6haZZ0yT?=
 =?us-ascii?Q?moWhQFIu3fcST/rcmlL9bq7WegJLSOcc3JF1egfp57qRM9IjHZaM4CnZMDJj?=
 =?us-ascii?Q?46oYB/OAHgI9OvWDmxObM3pFkAvRy1cChZ8JdxL012OMQSSKQaKGy+7eNML3?=
 =?us-ascii?Q?e9Veu4aTsZ0TwVoE/Tul1e7cbroaCwarzfcpJGYq5ELwwEcZ6Ur424HS82LA?=
 =?us-ascii?Q?kPIluz2NG7oUbEkV65GpbM3JBIfVC5BdazpWP/DTAbT09zPsQ1yW43PP7kpx?=
 =?us-ascii?Q?Wz3WHzOtR8DdPr49uHPgVdUoyIAURVjt+YjL4Mb57v/IsltHFYXLNb/c8CWW?=
 =?us-ascii?Q?SOjnR+YOOGQCKFhsf0dmMEyAUJtlmJFAb/3ZVXrZkRYeRrEeAdOrmxsM3Wk1?=
 =?us-ascii?Q?AMF5OrI0+knrpOHy5k0vW8BDgF3NOGTuxwo7xI7NZxNYkFb9BPXrfttPtwrO?=
 =?us-ascii?Q?08O14RgP+XuJHr86LmYxi482Bcuu5dMrksS5aB50Md8z+ho/ZD4krpsDwfnK?=
 =?us-ascii?Q?lLUhh+KrRwjyag8jLneFhmC81LjzJA/Tikz1QnABrCw9b7HDTvH7AgexDj5i?=
 =?us-ascii?Q?cL4TPoxyTZ3WeRvLdoAudss2Us3WhHUJMRqVVeno6UA3AkqNhHN1IT9f4P4f?=
 =?us-ascii?Q?NUgd71aCVr6Riwo+1o6vfYk8N/jZDW7uJQ2n/qhNdNIzD2hEAQtmPSJmchiX?=
 =?us-ascii?Q?uYA9PQDazJZNfd5/ya27FruPAJrbZfv1iXXqVPijmX4uC7lQN5NMpdSv1eOZ?=
 =?us-ascii?Q?pMGYkf17k0dmKWZ05gvncXxb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27987aad-bd92-4e35-f33d-08d950c688a1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:47.7519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrY+CHXlxQ4zLaH03ab7FX6Vq9JhnJCqVnKYTqTZ7Xs3wVPQZwQPtObQg9gNtAn7LUrtCoD2uu9ddEYkoppq3EeEh2ki9P9v0tQhqz/7R9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: a7X8gNkgTDz_-3UQe6kn3aR8TCNF-YyJ
X-Proofpoint-GUID: a7X8gNkgTDz_-3UQe6kn3aR8TCNF-YyJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

These routines set up and queue a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h |  4 ++++
 libxfs/xfs_attr.c    | 68 +++++++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_attr.h    |  2 ++
 3 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 0272ef2..0d4ec11 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -614,9 +614,13 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
                         xfs_off_t count_fsb);
 
+/* xfs_log.c */
+struct xlog;
 
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
+int xfs_attr_use_log_assist(struct xfs_mount *mp);
+void xlog_drop_incompat_feat(struct xlog *log);
 #define xfs_log_in_recovery(mp)	(false)
 
 /* xfs_icache.c */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9967719..260ae8f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -778,13 +778,19 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
+	if (xfs_hasdelattr(mp)) {
+		error = xfs_attr_use_log_assist(mp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		return error;
+		goto drop_incompat;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -802,9 +808,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -813,7 +820,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -835,6 +842,9 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (xfs_hasdelattr(mp))
+		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
@@ -843,6 +853,58 @@ out_trans_cancel:
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 463b2be..72b0ea5 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -527,5 +527,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

