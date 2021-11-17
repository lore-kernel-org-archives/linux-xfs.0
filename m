Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D3BC4321E
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E1E661B5F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhKQETa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:30 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36328 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233030AbhKQETZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:25 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2e5tE030690
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=/pR4wokD5Azel+3rdNIK75KpN/hWXyV5VuN20V1JDRc=;
 b=kiITfZzGJVGjvZbympUN+Ry53EKgRnPd0eMzSjmFaL8mMZJA9KX4F2+sBgKqpCrX9rqm
 43F1pnaHco0ZKzQ1ZAhn/6Vg2l1znP9LK+OIBJRwCN+QQgTQCVvua+1MGcygA/2zZPD2
 6Wc7ssdGkvMb9+z5pw0uuv8WMVHZRE0bigXNsNJxNWyfPxdnE+MhGMRW9sQBiXZZ529b
 is9BiWwa38p1THUr0KBbgJoznNfP0+ZgeWQH3+fSNTMNc861XvRtJfuVqL3d4zY2T7E5
 qb2TZtav4iNCk/LNOoEMEuzK6x68i6X86GQNs7JICBvJl7E13ei1J3Fcf19PcLPWS/j7 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbh3e5bhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKm180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6sM1cOaVUUGjaGg5+ItHcxIfiWIumJwGIB8VPHzFIgqTabz2jaTsSSHt18W7I5GlNcFu7mUctf6ZtdDqS6qs6pubCfV1ckmjkqLqTj/KDzlz3GLE3gJLVLWS+i0R7TIebcc6hlUOZ5QjvYDowMiDzhpxJAr/jO5rRXUmh32WwEJUIElLRazwSOOj0HMGtPl7TMu7u63VWo5x9WTvqvKdaU/OVB07xY4KwHPsLCQ4FGXZY/gCmSBCb9n2qhZi92JpdwwbD0osu4NGg1FUsJvWZdA+nqxgEKPn6WrYTvGfQIehqkQtmMV2rMswseI2ePjXZivroDig/MDX8POHo7Dkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pR4wokD5Azel+3rdNIK75KpN/hWXyV5VuN20V1JDRc=;
 b=TFrxeQ8gAzPWf+4u696SbfkyPHbezGQUodbk2YfMtGu/PNzaNqXSZ/YcA4lv3jYqiHh/e7yDaRpcvDSutpVR3gyvg3fzPwzR2sU/s1PzAJuNDOZr5DCMEi3WnOPzU09SbA8GsYI3pKFlOhfLDpV2CxSy8e/rU63IgwEPoTqxnsEo4cqW4M7s9S1Na2fy5v226stxXdAcSmFwNWN2C415oEAJa8kQCsNaZgA+tcXc++HtJhR/k6Lm7L/gyT/EIzIQ0grdZx1jL6WNOX93t4K77qRhA3v+axVull4E/1EfP+4fEKPVQ5rBtd/ICRhYl7SqnI2oAf/7wASOt9FplO+6jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pR4wokD5Azel+3rdNIK75KpN/hWXyV5VuN20V1JDRc=;
 b=ATNj1S4WOjvHdSCG3NXx7uA6sxDo9lKqD0ST4Tvi/tzGaMEDfXNP45gnnDIwoPWATvMmxh3HeACPbIYfwWlsgS3sLieHaFI6lPI8PKgvrose8EYv6lXUeg/817Dcb/OJNOW9M4t25TVvfOTvNuLhB3K8g/bwZZJPbvctQDYBeZk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 07/14] xfsprogs: Implement attr logging and replay
Date:   Tue, 16 Nov 2021 21:16:06 -0700
Message-Id: <20211117041613.3050252-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80b11849-0e00-4733-ee62-08d9a981033a
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB40361D769D5BDC52AD14F578959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1HVR+TO8r5QrQjpQJX+LiZLr5NUlj1xtQq7EYRixnq//TWhoTG8PxY9vyUe/bVlwR7Bv9pJFKTtMbwxFVVdFgMjNkw6PiwKTXb44FHABlI51i8FpfLm8D9FSEutPI4YLKCz9bNzsB1etc7mfVmWjEwwEgl4h4YOAeMVP387WSwfTsZYrx1Gc7+aaxidTkK+IZHNG/ig/DkN8q/Uv2QBGF2FxgblNHyRfDtpdc8NkfyluzRr+ca5OSSqUG4tKyooW6ZIYUPQo0B9MUiaEbZFUZ3/6QIy3H+h8PUZQGvahC4RWmzqmuBEU3D+Y0WP5rDQuX/y4lQknDRMavsJwmw5wARhLYQjzAL6X7w5DZOXJ8CB68j/eFuapjYFcoBWIvhjlTS5Qt2bfdz3oY3q0BC26D85Vp1irt62iviYhkKMGKsIRv2euTezMpjkvleV3GKJ0PTjynwvCBhzXr4IAp5z6uZ2zOcf0jCJXFu4JrswvgPN4ESEVtbYdEosKhlwnFoas8q/Kx8DaMKAFjYP7IicPWfz9B9VMyvxhV1FvrFjXCt5b+Gy+O/hkcti51mdJl8SHL615JM4THMQebS7aneJzmVW5vbW5bg3KiOGh3zQOdeth03EDml9L2bbwvTxo4hAFGJ3orLsL0O2/u/AJqcpTN8lqdZZrBOfVkNvoe+Z1Ro4h+ht4s9Gr9MxaCR7qpne0uCmW+VYmMaWMdrsE6IG77w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LiEwjvYEIUCutp9hxBA5g7W3YNJhlefVWIfztfeOKdoddO4vXbSQQhwo+Mdr?=
 =?us-ascii?Q?5CCoU58FwsJ/WuKbIthXvP5H2tedEPOggQuqT+PD0Q/FBZaWw3zPPFfl5v0Q?=
 =?us-ascii?Q?qC3rb4AbRUItF8khSgUojxxXIJtq7A2ES/Oqt6erDeh4pb0WfSj3vZt9eXkZ?=
 =?us-ascii?Q?tKosIBQazAW2h9j6x3PZ1j57Vc5OVZjj2KQTa8Zh9cYZr5oQMxsUvH7zI2lG?=
 =?us-ascii?Q?qPHsscwI/+WX2Fk0p91GChcjAjHM9hSNnaRA+koXgVQxnePnZ+8pwX+JpHXy?=
 =?us-ascii?Q?Khk2rXNrrwlBFlLtGR8ou5pvuwyH3yPZ8d/5aFyugMK0uu9aon0A7KsM2Ufb?=
 =?us-ascii?Q?SYsk3e2SH9xULJpsSZflc+FAQ6PoZZleOIpggo2/E9+Grvv9k7NPxnDR1yCI?=
 =?us-ascii?Q?bDdIKGD0D8PeDihP2gT9WX5itN+xKeuqrQxZ62GaHnqySmkm/1iUYLlFeYI7?=
 =?us-ascii?Q?vjmBFSB2/xPj0tB3Mw8CWyVgccqk3NL8pjYR0RWuzNUJA4ndBgQrfbok0Vdu?=
 =?us-ascii?Q?T9mOajnLv6XOER7a+upTqfesEqcPjmbTzP3P/PftyyRwU6StDYbJC24/gZ9z?=
 =?us-ascii?Q?AzqxIoDiQN034uNXdB4ORaKeZWvpfbqk9PTg5aHOO3t3lzhRq3K0nD4EGXiW?=
 =?us-ascii?Q?Hf4Vp/8iehGDE/rkWY2C+sjg4ojtHZsiBBhWmcQODhuIuqrFWt0f7E16f3jK?=
 =?us-ascii?Q?exYC2QKM3+2S1NEx7LET0/f87zG4XRxgMPMkBgkPS8WYHP7QBsVnWqmfQ9eV?=
 =?us-ascii?Q?dC59BCnUWau19a2HXwzS4H0CAUSecSRSLZRtY8Nk5PO0GuhwpcLSfFsAfZBM?=
 =?us-ascii?Q?kHNFLPeZn35+4+sYFhxQaRx/WhnF4QvnKRgpGmcv35Vn3FKJIsLEKdp6y1Xa?=
 =?us-ascii?Q?G6UIARSfU0SH+ZHICNf9tSGUCrtTIQjQd3GSlNxns7bMSaaSGfq/yEh0qZPP?=
 =?us-ascii?Q?etROH9G4z6N5wjFRoQUtdKoOAhzxA7ccOLm64MxXvqaGC251enbL/9biFhSC?=
 =?us-ascii?Q?UWZOkn//Ef2sQ/vZIfSrDRNGtYuNLmtRPej5MspPK2TyUyGn7ZVHGaEWoGlZ?=
 =?us-ascii?Q?ms9Vw3Rz470U/neQ3KhrHGxDw/GuQVNWjWH1a6oaQDzsGID8/UwqR+5IXtRu?=
 =?us-ascii?Q?ND8CB3GX3w4aulGXndSBv58OHou+E47n7/F8+lcOXhGxxSpdVuh2kbWpPY73?=
 =?us-ascii?Q?cXXGa8rhZES/u0eqs3KpBh/D2j/4OwCvvNUL0fKAllcCxaCZcCmjJ43P+iMc?=
 =?us-ascii?Q?gHTgPY1A3bLdSSjOKdFPKxqnZvc5HE6ErkyPI0dfBV347hYczuAi2CLCtwdw?=
 =?us-ascii?Q?WYw6YjOvkv1ZY1N0UDm5NRsjyvrD5duzue3l2F18/EBMZ52yRuEz4Db58URG?=
 =?us-ascii?Q?mOj20IIp2Dkl2todcGwUuKwhpD5e97XMSk9qRtO0q0P91abrpm3kHUxErpHI?=
 =?us-ascii?Q?G1jKK4Tv6UbnjoNa2ChHdiIgWfEBJ+fKcwNAqUZD9eGQuI2yujrvtJEuxDLf?=
 =?us-ascii?Q?pa0wBA11oACXLQKxL4r6fcEg3MClyIGBqh2CS/njZEVtnnKBzUgdmxZ4DpJU?=
 =?us-ascii?Q?GV6Quz4IuLYbPIVmpqvcdTHVUyl4dQSCVvnwUVgG9UxAcscou/6IMYqF3ypG?=
 =?us-ascii?Q?lm4k0qJ85E6aK+qYF27wQ7KnXfbCh/16WEu54oJO8qPZ1rIcQ8Gh0ILWlR0h?=
 =?us-ascii?Q?rFhA9A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b11849-0e00-4733-ee62-08d9a981033a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:22.1019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYhzoByT9bzDz1nK3+ia4K7KQUGKoKxUpo+ZtaInxx8lE4hcmTmvFMiedxTJrcSYmS5wAEwaRjnstNxr+lo98ug4oueQOGYeF6cxhUjvXOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: 7hJp8CGasIWdRedYUg4Wiu8_4vXkFxfR
X-Proofpoint-ORIG-GUID: 7hJp8CGasIWdRedYUg4Wiu8_4vXkFxfR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/defer_item.c | 119 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_defer.c  |   1 +
 libxfs/xfs_defer.h  |   1 +
 libxfs/xfs_format.h |  11 +++-
 4 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index a1f0d7e52ff3..46026084f44b 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -115,6 +115,125 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
+/*
+ * Performs one step of an attribute update intent and marks the attrd item
+ * dirty..  An attr operation may be a set or a remove.  Note that the
+ * transaction is marked dirty regardless of whether the operation succeeds or
+ * fails to support the ATTRI/ATTRD lifecycle rules.
+ */
+STATIC int
+xfs_trans_attr_finish_update(
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	unsigned int			op = op_flags &
+					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
+	int				error;
+
+	switch (op) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		error = xfs_attr_set_iter(dac, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q(args->dp));
+		error = xfs_attr_remove_iter(dac);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+
+	return error;
+}
+
+/* Get an ATTRI. */
+static struct xfs_log_item *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return NULL;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	struct xfs_log_item		*intent)
+{
+}
+
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_attr_item		*attr;
+	int				error;
+	struct xfs_delattr_context	*dac;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	dac = &attr->xattri_dac;
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	dac->da_args->trans = tp;
+
+	error = xfs_trans_attr_finish_update(dac, &dac->leaf_bp,
+					     attr->xattri_op_flags);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
+	return error;
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item		*attr;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(attr);
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
 /*
  * AGFL blocks are accounted differently in the reserve pools and are not
  * inserted into the busy extent list.
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 006277cffdef..c03390643942 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -174,6 +174,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static bool
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 7566f61cd1b3..58cf4e290c3d 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 5d8a129150d5..37ef0e627292 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -590,6 +592,13 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
 }
 
+static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_log_incompat &
+		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+}
+
 /*
  * Inode btree block counter.  We record the number of inobt and finobt blocks
  * in the AGI header so that we can skip the finobt walk at mount time when
-- 
2.25.1

