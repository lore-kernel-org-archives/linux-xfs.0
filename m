Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A6DC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiFKJmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B815F54
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:14 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3vVbv029561
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ghFV/JCHsbsOc/x/yCnMQP+cdQocYzjVtpi6RPk00+o=;
 b=LEyGNo6AlUwdgsllr4pRiuOPsiPGs5R4pKzUzhPyFR1XHIYMT9UL30N4jIb5PDNULq01
 BB38mL1VUzsphs4OwfzFqSf6LftkQ5IPoDs/ZKZzcstbExrmIct9i1E0GZPfU1HwrHyE
 uCdM8tg2AWOLvnd+dCy+YMro3H8ojcAwQHCv9j39QeUj+YnF5u+s5qJ5Zehj3W14ql0T
 G9zbgNxjqsZIF+EQavSZd5n4xkG2usgHHOKwvGYKwUeoIEmgaATDDLzmTh1GhYNRhKXv
 sp8z73QWav14aWkmzgi+BEujVR4iUybRtvK1ubB2++by45tOFXf2d1Ue9W2txgzskq+3 5Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkkt89wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQC025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZMpJaPZAUoyRM+LD+PgE6G6lX60l2dPDTn2tHkZQSK97g0FYZ5z2hDKN9vxja3G/6RPmuvctVCvrUYwURaBRftNzY375DEVc7L5wkhExEYcj3DZXROpfru4/Hl8SeREo7297GH7f5f8jpVYCrb+bRewBcYKW8T18mULUvj1UvhckE8y5oPDuq6m7LPIySUNZW9kdFSL189RFn8Z7WKRfgUDP2N55ahNTHl8RNyvL/bjeOSHrQ0WACLmKb65jd+sVZv1HgqpmxUZiwBmEPXIDZ8JURZIzv3+lCHeUW50m+XjKTZMfD3Gv2kiMFnh4Ipnallhg1TxhCmI3InnZrctAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghFV/JCHsbsOc/x/yCnMQP+cdQocYzjVtpi6RPk00+o=;
 b=avY6YnR6U7wRIHyiYSfCyFNubhHVJqdPulOj4ITkdyhmXCPrTAmweydiI2dOLXdyfUd6ze1ZIJelcqPAWdTHwC7tcmqNLTELJam4xrsSsxmHL6QEOvLncZwfSKg4qWgcGO2Jv2SWVEBF4Jto7j1Ez6MEXaa3amDb5XtyCeG4buV9neoYOU8NE0D+QiTPVduiQ1u7e4/7BeuB0FROPOcBTm/4fsd59nBNByIr036Im6fFbS2uezwyWx1Y7xN9VE2scwC8T/FEPMAngfDURs003qNFnPTCCLTyrKUgw4guQ06+D5nF8xvKrF2e1yP7M+h00rELKYXXHwsLbZEkRIWleg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghFV/JCHsbsOc/x/yCnMQP+cdQocYzjVtpi6RPk00+o=;
 b=ZcPeS8R4K7St9phjqUGBsw2qqSnx+Smmkq0AX8vIIC/S7Mfxi8Q0Ny6/97aC3w7yn3tztGr5MzetFb4BrNSk7kf//9TZqVU1p4wMunEHPlXn4C2H+ZiLqPC74d6DUhWux4iV1KPE7BJRFtXvAl/RElVDBCtChaxSZr/dAkGQWrA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:08 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 08/17] xfs: Add xfs_verify_pptr
Date:   Sat, 11 Jun 2022 02:41:51 -0700
Message-Id: <20220611094200.129502-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bc4ed8c-f7b4-4dc4-efad-08da4b8ea6cb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606371C5B26B9FEAA9357B095A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtNykPGqu9m2f9f7RAHKVcueTusGwd0mdgmSSbUqkNRnu3r/ua6XDpz4mJV+tnP3VN/OShDIGH7AUVnjafriLLowB1q7PuJnkf1ieS7mEAtAqTGZtbTM2Lh1waaPBO6AghDs22ujhtRyHQbRj5d68+L49zKzh+W6e3qEGaBvDFrx4NkI3d5txH0pXVc6seal/R0BnYXz60n4mWhinECGwqPV1EHVRUD6gs+qWmFhhlw3rOjPfC4+LWy2soH0dL0qXNQhFpoLPdrT+e4kDLK9IFVzl/Cs20JAdYg3r7182VRSRiJyqVUGJYBzU8gFi2XrU+sxrOgIR+7MyacTDrJAd6sWuzma/+GIKqSBCectZ7vjLQSjH/jX8EYJ4aR2NOM75OO7f9UQ4zTxjfbhK/HbOelfxlXbgeohMtoOHp626/z5f0WFYLFMsy433qkxqv+BAT+3njA2Q4eCnrqoZLc0hiir5NY2uRIG2cUJBoiDgFwmk16qguQeoMoBMUmb//55PA1Syo6fW9I1aRMmqFH9AFxhdk/ISPEFARzphadDb6l3TIOQ5OH5fdRa/oO6+FynDzJaT26gOSiu4L27KxVWxtk6gndD1tczVisg3Va56kjagGrFFrkDUT1z61hqmX66Cv9aM2PBI7ckMO7DtYc5H3FuOB7v64u2xMlUbFqjd/z3f6xFo5VIiKpSHi5rzZ3M9JJjafTllNMgS0Wa2k846g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QjF4/lhu5eIi2Cxm8DSrW+KcFcC2ZrXwDy86wcLoypEhhDoM08a499BoTyQh?=
 =?us-ascii?Q?VSj8ocOLlB40g0rursqKCD9ZnjddUXFIkklD7glrRWlozOcnoBDdEI0NbXxq?=
 =?us-ascii?Q?ttvIt0bwmuFIcLojxw0QuZ2LrLZYJm5EiY6e1sF4cRG2U3/nVBTTRn4K4mOC?=
 =?us-ascii?Q?9BrK+BkX+uH+SQ3zeCOHtT6NYFLm2rmqElWQPQnt4v2rGHmx/dlFxhsqOrwf?=
 =?us-ascii?Q?w+x3L+Viq8wUlwToT3v0M4SMj4a9NKFl2tgRhgaV+jdOjaTx5mdNwWWeblza?=
 =?us-ascii?Q?mZ2hXSSFZtMhramDv3a1WsKziiDg8qhfks4IIluv6w7zEhvtRW0Ide9AIXQt?=
 =?us-ascii?Q?iHKFaIDVjJgrImCV62zN7CeNqgSW/XSqle8lSy9+21R0FdTlXduaWSxpPjBD?=
 =?us-ascii?Q?+IgLGyFL/3AM459bN6exnTV8K2s1T5ewGlM1q6LO6lgwRDSV3o1SqTP74e7s?=
 =?us-ascii?Q?1o9F5NbBm5RLBzK7bHM5Q0+bUccwBOUL5SbrwwimtpQ1pPzAKtzygxwFIjK6?=
 =?us-ascii?Q?kjugNTiMkfiUvwmIo5cSt/VeSS+PLbIE6ppeRCjI5K4MEf5FY55kNeZuuntz?=
 =?us-ascii?Q?2oLWy7WD1rUkwC6NT1QaFbcvbyZIkk099sD9wCMGSbVxkguTv/Bp1sorqU3Z?=
 =?us-ascii?Q?rexEJd54Hu3i+8Ov35geYIcjYs0BwjBSstfU45ripITJxXJG9UnDYmh0Imuf?=
 =?us-ascii?Q?GZgJQjWffr1LvJwMKwAMIBigPi3nHaHYQugpUKoaPabDvGrZcIpW//kQp0BT?=
 =?us-ascii?Q?9v1o5mbxtdrW/7DOw1IZy9lfbx2gdshu3ZSV1U+NZ0Ff2Rp+Zk3/HWVjdVrL?=
 =?us-ascii?Q?xRX6qSJyRHy6ReJMaT5QuwKzEE2OnJcEkj4fNbGc3EpWIoa0saCPCIgAhbE4?=
 =?us-ascii?Q?jBvhvYX6B8qMno/8DEacaxCvXICMPa6Wqb6pNdorjfPQo9QXzwpvQY3gdtJl?=
 =?us-ascii?Q?2OztyHXRdWPVWTwrGqiOKAtF+T2pZ8MvRMd+exFusqKClDrVrByfB0pk6YCH?=
 =?us-ascii?Q?q7Nnv8JOZwl3tYiTRQ1C+SGT60erf4F9ZMZZPZoVkm/9nghYSCRwOnxduBk6?=
 =?us-ascii?Q?e5Oe0vmEKHOjiw+nOemhCUUmVB4tHXx/vkOp2xhbgYiFduYULZP6T7UaH7T3?=
 =?us-ascii?Q?WuZk0t4qSdKYg1CbHdxmugx5w9ZF5SKK6PicZUXx4wtJ8u6RhwK7Tj+dd/4J?=
 =?us-ascii?Q?f36Zjy6vPUuZk5uLY4QIWUn459GXs3r+5QiYVm7/dwXascfcX8SDOePtkp78?=
 =?us-ascii?Q?3kcQ1/yXbzYI38MZXBOs0hjnOGcwzzlvmj+JYVYgvlIueiMzV8d9jfV3WM+3?=
 =?us-ascii?Q?4ilUfRi7ud9mYgSJoTx51wch0hZAoXuuyh20AJuk+z/nwGHBU51JkTkdNpBm?=
 =?us-ascii?Q?3k+DJkmlMVfdHgndfDs+wOdQuYvukuH1iNzXOzPWMba6HCMfrFroY15/7bh4?=
 =?us-ascii?Q?Pox8rthC0Icpk9pij/Avy1CWGfLjV/JHKV/vtJkCbEQupYTKy4WmFFt3FaKg?=
 =?us-ascii?Q?qPr6373O3lWTPeU+29/E4hxrEnMsA/J+cpW3j7kiYGw4qCN4KiNwrWIHCkn3?=
 =?us-ascii?Q?TjLKoYBAqyoPuo95YW0o6ua3xOTbBX6vYb8CQrPn12y/CJgbVK4UDK+ytjdh?=
 =?us-ascii?Q?mLzcH8clrXBcqAIsTqaUQvE8v4vlw0EStjxWgmQevqnf0VUrfVXKaBKKfhVx?=
 =?us-ascii?Q?ArrbQ9dyWJ2QSkxXiaecOXSS6JT+I49L7oGoPGZ9aOCn9GbV5F5BJ9TOwrB8?=
 =?us-ascii?Q?tTRSZ5vsvR9h8ADRxIjXA9IU4dwKO/U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc4ed8c-f7b4-4dc4-efad-08da4b8ea6cb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:08.3418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNare3Tru/8524ui/7FHP+/ochSIyM0gxlya3whXbQBwrzn1fIr/5F3hSs0u49AuM1QmRXzkCGzzIT1wbfpULU9SHarp06DLeuuQPphlNdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: 7dchpTA1HewHllvu5Gy9DzH016zaT02Z
X-Proofpoint-ORIG-GUID: 7dchpTA1HewHllvu5Gy9DzH016zaT02Z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h |  3 ++-
 fs/xfs/scrub/attr.c      |  2 +-
 fs/xfs/xfs_attr_item.c   |  6 ++++--
 fs/xfs/xfs_attr_list.c   | 17 +++++++++++-----
 5 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ee5dfebcf163..30c8d9e9c2f1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1606,9 +1606,29 @@ xfs_attr_node_get(
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(struct xfs_mount *mp, struct xfs_parent_name_rec *rec)
+{
+	xfs_ino_t p_ino = (xfs_ino_t)be64_to_cpu(rec->p_ino);
+	xfs_dir2_dataptr_t p_diroffset =
+		(xfs_dir2_dataptr_t)be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1623,6 +1643,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 7600eac74db7..a87bc503976b 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -562,7 +562,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index b6f0c9f3f124..d3e75c077fab 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -128,7 +128,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		return;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index f524dbbb42d3..60fee5814655 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -587,7 +587,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -742,7 +743,8 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 90a14e85e76d..3bac0647a927 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -58,9 +58,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	ASSERT(dp->i_afp != NULL);
 	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
 	ASSERT(sf != NULL);
@@ -83,8 +87,9 @@ xfs_attr_shortform_list(
 	     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
 					     sfe->flags,
@@ -175,8 +180,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -466,7 +472,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.25.1

