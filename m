Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FBFC6FA8B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIVFpI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiIVFpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2425B5756A
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3EGgj022761
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=bSgYqnZDSHeYd4AMYIUWogTKwneqY2oEo05inm0ZIxA=;
 b=1BYoTeGy5ZB4XD6E4caM38ObOnu+hDNkGywWFo2ev6NqqHWHyr/dJ2taFmgr8edZ1Od8
 dJ0JN2S0A2l1lufTwmB2h3Eq6L4QCN77umVy7sFqJosYEnqwH4c/gxsaRxXMYd2GIg7/
 iICu12tfjkdY7vrDaP1K3Zep9qV5qNkZKTDTpk41B6Ug0u+X7kaX6D4sh3rc6p9oWZbv
 BgcRffQxd/z5KvH0d+26n7eplCD0e/bK9E9UVtCo6GkNroYm41lwWuTxv7go3mQ5MZ03
 d3LMWy1bbII+1RBtH0ZPZf/eGuVOP4J0RnUZajXRFhKnvaMlVrXnl2TQLTJRN5HafVdo DQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stmkra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M211mT013165
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39n7ebb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bgr/5gIa0JKxnl7RjppOB86u+ahQAqz9kmym+qjlhUeqzc0lR41bhlspxkxo0TvQpzO7lrGEbOLRMQT+JuERCxrM/C0iih0nnhlyGtFoklH0LBU+15tTwWnnPhmLhS7s3rasAvogToZtmGA9d+BqBLFCpIUfv4uavtdb0e0DcRQCJQsxPdnW/1OwdODitP01s1ln6h18TWdLUeSONd1O3Kv33Zb4eNu5osWcuFdEYcivZGdzO4RZieSOTJfXa/xHXuxCLbKtwSIArgKByo5CRq+PosDVSDFraPz1ODoqZip52DUmi6fVKQyLmjb2VK4dE7BU/RRn0Rqo/gypoHyRuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bSgYqnZDSHeYd4AMYIUWogTKwneqY2oEo05inm0ZIxA=;
 b=Ftlv4nf1JRarmpqaH0uKsIsGxrbEpDNnKm0FjCNzzPjK5ivmmEhMEX3KPCAc//zvrFMbUL/nbAS0KjzAIrwsZF/YWOqsEIIkw+R8upzffY8CMF4iX/eZZv0qOqGR/Ub8O0vWTKdgTt041vJt+wvti+ocAE6Y2AQr/eC+ieKrOJH5wxcwwLMGP97iiEVUyOTDAuKJmOygvSOV7XASQ0SU0wkiEBgXEU80OZYJ8E2mxYC0ZC1+8m5bIvPaywwyXPRVnCA17uS8DdIa5//wXb+EvUxT1qCwZ59UXAinDOQgO+41VAcf5/UF3s/ChM9QZrGv5UELgd55+FUUMU9q7UH4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSgYqnZDSHeYd4AMYIUWogTKwneqY2oEo05inm0ZIxA=;
 b=p+6g8noLPXW2HbiPW1zij7Z+sxPNKznF9xey+CwUV019K3ln5fCNPK/RTGtPjHxnMPL6iw+WGxMeOq7GghZIVL/2lbHRF58bzHbt2DenlxPxWjERbNlxPIUqzz4IACvZcqqXd7rpB5Re8wXN67WiZL0YyZ++pGIjI2f4IWIAklg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB6627.namprd10.prod.outlook.com (2603:10b6:510:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 05:45:02 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:02 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 01/26] xfs: Add new name to attri/d
Date:   Wed, 21 Sep 2022 22:44:33 -0700
Message-Id: <20220922054458.40826-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH7PR10MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c6ffbb4-dc9c-4251-be81-08da9c5d983f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lHNS2AX5+Gclp96k1VWYBmdb5V1UgxajaMq87TJGx5TgNuMQCJ7j2vxadV2OCjt4dTlUCzuJZKuIoV8Xihrga39tTcnUnDV/4JyKjPo4Nmx+2AzUBIhTiNemPFG00NON56MGOJk1Ti3hSEdLDgsLFEddzGvjomNvU1A5EwDCBA74qft5YzG/CsZUus3XQ4eI33n3viELiULdki9j9nHwX3OhWzLGSh2VdkHu7mfWZ6X/eXkdQ//MyWw8sLcmD9fvlAoLKOKjRWwwHD9oRZsnE80YTIs/4LcBfND9KGY0JOjcwPMhf0DLsPa19vjJ8JOXYitOMjgfOxTAuvMQQEeQ18z9MCerata/ugijWbEbD9Q4dH+UUSPSafwZKYb0sxU/TJg11k2ygB2a6nTmQg1Qxkuoq9JDOkV7wDg+szAtCQtI9d63fa6kFV86sFV0Rc30teG1weszCeOI+hpjFiut2LMfvfvzkLedNe5XD+d+Wd8nwELLLXJ3OS9P8QkKRjCzvC34pt1kUEdxma4RzVgjyJ7W3Zq7oPUn+YEsvF9KF0IWQO4qOBCA2/Kjy621cWi4maqGn8/iuSoydpHzQj1Nn0q8pO4lOsnAEcG/hk57I/QpuXEyHJq+de2GuQD0uMSu/yfNaSm+XRPFQkBjIyp7ZKQvCh1v+5vHzRwqUqI64Jd8Hx3ai7Z6MOleqE2FpZEP7tDm8KZ1S+C6cHFgYinkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199015)(316002)(83380400001)(38100700002)(66946007)(36756003)(66476007)(86362001)(2906002)(66556008)(8676002)(30864003)(6486002)(478600001)(6512007)(26005)(2616005)(6916009)(186003)(6666004)(1076003)(41300700001)(5660300002)(8936002)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VPj5oCiD/Zdb4twoDmCxB4BQi9lYpipQ++bnhX3+P2FEG1yBdkWVQdMsGDCh?=
 =?us-ascii?Q?fdIO3MOMuugjXr/VwftOXZMtXPav6KHnuZtWtr/NLsKFZAR8duaWGWIyggFa?=
 =?us-ascii?Q?OZbANByO8ZjOc37xYVaQBnT0fj56WPEnAqGfc3LdxOpjZBNbtcZqyoc1f/kj?=
 =?us-ascii?Q?0B3khunD68hcsUEhCBczaU633W7CGUJKzFWArVNdcBxyoTIWz+il7FpfYRlR?=
 =?us-ascii?Q?il1czWMPZdNAtb+6Q6iNdBqPty5aHKisVXqZE/FW8Rk39nVHzORrVLtez99x?=
 =?us-ascii?Q?5HWdBqT9o4l3cae//FSHsiL536utyG56Wcv560rgAhawBAkwdnYkpHmg78kC?=
 =?us-ascii?Q?FZDbF+H4GnxmorUc+ZfGtvSbirFQh147LRfEbSwFiTFNwJGFZ7S1CdHUJcqj?=
 =?us-ascii?Q?hCualJYgjPZEx46Q1vNlmp2PtknFqFJkOkSu4NrlmruNbor62iGlaNcO2KIH?=
 =?us-ascii?Q?Az1iChAmhgdK5FKVtX8bdZlaXcjW3G0KJbUN+BRZAfEcaY1sC817HnVzewhA?=
 =?us-ascii?Q?+WpnOz9wdYCGtuz+TF+HHfI5BA4G5cCIOCgAcgRW6dFcSKcWXr5ts0Vij/xY?=
 =?us-ascii?Q?x2FFXobWnFQHxTX3W3Uv0B2dpxz9TnQ1JYgzcpP3Jb5/NiDouQRyoYhXzcrr?=
 =?us-ascii?Q?DcE6yrYIaPBbc2087Yfx0dk1rs1Y+gWY54yAChNUOGEtPOp8wwd3POf0jFcb?=
 =?us-ascii?Q?BiWWd/8y5sCa4EJ0mq6j1DhvHeYdRw3/sqh9TYnpi9i4Ub1uA2OW3TWWtIi2?=
 =?us-ascii?Q?Tgk0PTVCShNTi0/Zn00OOF+IgobPNNW8xocTqCBw/TJkS5iDaShaqMShNXE+?=
 =?us-ascii?Q?psZoTb+xaBV2YMxI9ByGB8Wi8l8UOKuJo0POtEW6xs7hYXAhyyF+5fTWBuY5?=
 =?us-ascii?Q?Yea14T/cSPcCe0y2Og/iRSI1ctm0UzCtgA0XCNYnPDarnzxMcydwyxxQ60y5?=
 =?us-ascii?Q?sf6ONqA/1BK9qTePxqSSFFQBK9Yg9QVuF6ABpSskH3bpe4roDDz7KjBQFSRs?=
 =?us-ascii?Q?zxJbc7zVOyj7m7mYI2xSWDWOtk01pN4WSVlx91l/UIXq/oTGSI0WJ4yVHqys?=
 =?us-ascii?Q?sSyfJNTr+YtTI3xitsjhAGAe93BAHoCJFSvEb4Zp8wPPOxHbSKP3CzXSMI0l?=
 =?us-ascii?Q?DgwZwdCN+PRyJq+WUlGHkGlRpWN5KZHpjYHDgf1KJw1iqwCtpLp9Mhq22nCF?=
 =?us-ascii?Q?Ngk4TNhuzrzgRyDKHv6c3C/mVZUyfxhg8xMvBo8Hxn2tf8784svvSHjhTNuA?=
 =?us-ascii?Q?qJoIapudXl353yaY1SZz8XZaDrqaz/2sq+UUZL3LeIL0YUUHL6C7cVkAR3Qs?=
 =?us-ascii?Q?qOl2VX6Cbos3EDsNzBABmhTsCSYUMT6fAFgXiS0GFNXyIClUFqn7BrkcXZbu?=
 =?us-ascii?Q?yJQ9Pj31f7tJ+tI5qv/EY63HnWSnDGcVOMzJRdxHXScO0gsmiLQmq001xsZP?=
 =?us-ascii?Q?2QaAkuugHT8DxctdJ8w6Zj1AjpBgcumEq1w9qxn3w5hxjUmlxcu5l7LaLzSI?=
 =?us-ascii?Q?0E25XGTbdXax2SH5sNnYBocpc8yo3Nj2YFeuCN+SOYU64a3IQhQor6j0KUkb?=
 =?us-ascii?Q?3aPCVZkkefZy97CHl4RbLdSTpTk+MrikF3cLE8L66/e67zbY/L6450d/Apzy?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6ffbb4-dc9c-4251-be81-08da9c5d983f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:02.8271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUubXOvY+j3F/Bt47Lz6Z530uRsOBMKYoLsT+4kFr7WGuzrkfIM482W7NPc6D+9UZnjxdK10G17mfuSJD6VUVSlTxeBXdEHZWSLZOVR6uWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: cPsEWwfNgHJEtDKDp3rtbVXARcbt1Q-e
X-Proofpoint-ORIG-GUID: cPsEWwfNgHJEtDKDp3rtbVXARcbt1Q-e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 +++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 108 ++++++++++++++++++++++++++++-----
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 113 insertions(+), 20 deletions(-)

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
index cf5ce607dc05..9414ee94829c 100644
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
@@ -85,15 +87,25 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
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
@@ -147,11 +159,15 @@ xfs_attri_item_size(
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
@@ -181,6 +197,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -188,6 +207,10 @@ xfs_attri_item_format(
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
@@ -396,6 +419,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -437,7 +461,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -525,9 +550,6 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
-		return false;
-
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
@@ -539,6 +561,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -548,9 +571,14 @@ xfs_attri_validate(
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
 
@@ -611,6 +639,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -621,6 +651,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -710,6 +741,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -731,10 +763,41 @@ xlog_recover_attri_commit_pass2(
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
@@ -742,13 +805,27 @@ xlog_recover_attri_commit_pass2(
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
+		if (!xfs_attr_namecheck(attr_nname,
+				attri_formatp->alfi_nname_len)) {
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
@@ -756,7 +833,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
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

