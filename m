Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337A9C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiERAMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiERAMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A60F49F1A
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKQKJe023077
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=veuXd+087GLTnlB2RCsj+4J4/YeLGwYa7cCiO3H4t7Q=;
 b=kIKmCsaAdhl52Ia3KvhhtSh1Hb7sn/Goq2MhiddfwJNP0GAXPVwuIXZP551sXa8iRm8h
 u6+1HWkBks3CsaIdlQZ9Wo8qQWpGqXzFY48xN/tt5f7HZ2LCL3i8Md4RDfxU0bY2fjt6
 Bi3YqvdyorM2qxvorEQp/za96V++m0H5SqVe4OddH0Ri38jYXi5/JkAMwCMaxjoehsoA
 muKoYwuEgu8DpC7Rf8Tp+KCCIHZHTnKJr9jMiIRES4eYR2J6Dh5W+Q4M4xJFmZq3s4Fa
 gQPSYSFaeCmbj3risRi3ye5Oi5OnlrII8Kan/C1GgOeN0tgtyFsmnQnlEu+UkVSTsePG aQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7ss2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0BhWE008599
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cprqmw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWf8KkRisqcNh4mZGcbA8yixAuIjyeon712pFX4dP1u1557I2RuZM7UL27yRjg9D7qPIrRUNXuK9mly8yQlCFOIpQFj5SodSEnxPOVcHCVM/QJbHQPEjb/NJGFxRwwC+LkS5zOL8jxxpGF9Y4Tu3V3Pemm9ewpO/IgwClItDe9CVlYAnpIu0WDPzaLQdkdUHtYkFRmN+uYNOit5gWCeLNbS2HEhs+c76hYA9+arX1f7ZwhXY557kL3WT2G+SGlAGX+mQ7ON+bnGlS7uIQz8/Wtoa3uY7he46KZLvPIVM3wcb2CkntGAvUasgslh4nnNpIyImzCl92rZLveM2/HLWfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veuXd+087GLTnlB2RCsj+4J4/YeLGwYa7cCiO3H4t7Q=;
 b=NI6uft8U+WizqHaCfRr4LlWZZAr/uR9XzlhVJCoOJPDJEcUM4FObcqSzl52ODl3uNFV30GBx1IGuaxvRO9DPeXJIHd0z0+IGchfezQNfY1O6GYZNI4gG54Qvs4noMlciNl8HhCQj+PBC2jXpdix0ncxA6dz9++pB9KhwfuhoztoSLVYKiSzUX6ZljMnQahMPT8gybLrvAZSODQreQ0dq8H9FONFaqlJWFMSxcvtpg5iry+sTR0Rq3BOfONQ9wOiiox87LDaWFLQqnBeoNhjnCrsDnSZAh/Pzji39StbGkzsJqxFRTAPfwaEg//qCWJumEALPaLRLoLwJPJRcS15xLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veuXd+087GLTnlB2RCsj+4J4/YeLGwYa7cCiO3H4t7Q=;
 b=k66axeHyTHgwMLZDEO2VMM92TDP7bPJRN0oYx34Z92XZvRLcON1u7LZ1lPKjvwKilEhnd+12A5QjdpreWPMlhWGU2/8d1hpRYL0JWglG3f5mjoJrR0VSq2/Gx6py4bk7avp4PBpcrRGNnKeHpHOl/juHmlLDAIUIuaQKAJXJkO4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:37 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/18] xfsprogs: Implement attr logging and replay
Date:   Tue, 17 May 2022 17:12:17 -0700
Message-Id: <20220518001227.1779324-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49d04ccf-df7a-4647-09b8-08da38631d70
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB15287F2D349FBB45397F9E4495D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K2AQx9Cpzgki7zC0WFmZDG/kvDhVtP69Cz/UYJDKhKu4n3uPwlJaDx1ON5IAQ50PbUYI23z9IV4sdmjNdqm1j0nt4Tr4XSLuNJYJ9L7KmvdjTrIVdHhkJDXyEZ5FFYWDS2R4aZGv3Uj+lUCgxBZqUKuDDAJ7h0EBBcOKxlhNnuz0mpA9j8UjTKislzjM09/VTstFCsGhzXqOMsJTg0unwm9gukQIkQT7Hx1PwuEb4UBTD2OjGwsgAtN/dGI8WTTlzcR8olJGJDejTxVfIxNX2z5PH1z0l5iK56hjfI4y3Dr3JA4H4GdrG/dtnNaSj/8yNU3s9F8yGEkkVUgH55bIKz96WlZ8BXVSS91BY0oM/y2a8lHf6vapQHoglM1lPQV3LkBeCttdJg3i2hWrzKm7N+ilpcnYiPu7K5TJ3Xq8ymubSxHvQHkf1ktu+TX6o4pT+UWrkRNPoCmIl04F1rCbGOSEGD92Vw7SQ/e42STYMvnORMv5qreAoq3fvChGrTeqLKQCvapWq1JD4Os+1XkKaZ9a4P66veWTl4kpdH3AbMjxRBTxCtI+KfkRxm6bC3KVs37h6xEOtVU6SoIGSqAsxZHQLbAq7lH9+hFU6LUbbScjdWAGBHE4S8V8VpIYJtR+sz29IkjA+CJhBamfsjDr48SASVp+hd1StBxhpXKV21CWDLRoujB8I/hRTE6pvzQb1G+WZtuNdleTwhK0qkvJUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rycIYXCAiHf/lhvO5O6tWDPfUU9iA2FmN/emgUXCZDzvcNgC255b1rvcn63e?=
 =?us-ascii?Q?3TOkQ10lGu5wCuqtpdyoXEofxCZ+Q+joZsgvWOZlzCywhCi5poF0ULT41QIi?=
 =?us-ascii?Q?2de7URK7bsZQQsE3jPKHGa3LxNmhkxCkllwSUV0HKEdxde1qt+xRfP4eT0R1?=
 =?us-ascii?Q?aXKWF3OClBLi7+CuUEUf3IZ+bpZPwTZ2mHdWXf9Hiv5zYn1VpeUuvD9GVpsV?=
 =?us-ascii?Q?XNFhnukUgN7sDoJ8r130ZzvO0ohFSUX49PvPi02WQHXYsvopSh62Aj9TEdNK?=
 =?us-ascii?Q?ucTN9m9xdTK5WvECbiR/JURgc1wKQQNxS1cp+CYYjIzA/dNYkAZ7VbY4fnbV?=
 =?us-ascii?Q?2rhRerl/9HuHYVQC2GLSjydHqB42J9JwCgmZ3V9udD6xlwsBkqjQ3MgCXiV1?=
 =?us-ascii?Q?Z7fdQYGgrLXq8dSTaBT9/rEo4/ZKmTjkryvCfYjArwCivrrNFkXTABSVm4ta?=
 =?us-ascii?Q?cc8XS0FlgMO8bSlRX97h5sGOno9Xfskrbh4dMyBE5BivS5+XEnL8y0xBm2Qq?=
 =?us-ascii?Q?NdJagVtrRCYSpwt7aFZO7BicgYUFT0/5hqpoLHFOvvvWv0PhG1aW2HgVki2U?=
 =?us-ascii?Q?ZPU9ZBJ1ALm8/gUcpukt59aTlfLJFDhCmbVwu2WQLeO7aaorS8j0u2QcFq5g?=
 =?us-ascii?Q?22N/B0DUCVQBMZkWK2jqk4/i5ROjFOQ6S+90ODn7QDe1gcnDisWuBw9BdWrh?=
 =?us-ascii?Q?B7wYU7ZZ53IZ4EPytYxrV1Mt3R2AkbTVzXo3eewY9X9CAJ1r1h9VHf0A1F4h?=
 =?us-ascii?Q?JgO37xKMt/JOz7DFTvwLpHGhkWqG245emKXdZ7rjIMNRN9wI+ghwph5/goGP?=
 =?us-ascii?Q?f7uWE4jJ5gT+AVifmskWK8epcmEZP0/Ce2T4EnzsCbIPKWytLgnzRXm+6Aft?=
 =?us-ascii?Q?DJKNTbsUg9/lgHNAkn1pN9VCqOwYlycV61Hf7QwX0sLSTIkPD18SZzkLRjpX?=
 =?us-ascii?Q?oKcZoQm5AR3bLPbHWBbFuue8wjmkH7LTBIEND/UXbnaJmTiqFsLmhnwUOO9S?=
 =?us-ascii?Q?ysT/k6LWrSEHC0h/k3nPYaoVCbYxg5BoISE5vxsXG8YuEqTosjcW3fyvkQG8?=
 =?us-ascii?Q?0Vr3fYzHvxPc6NPfgQZjZpj40Dv9XBJmB/AQ6L6Ef6EYjwHqO6f6Pm7j9f5v?=
 =?us-ascii?Q?mSmUK7y+SpWfMaLKcM6xmFKYDCPhAYHn4rqt+E3lgJCigX0he5pRAWe5xgdr?=
 =?us-ascii?Q?3CW5f3CME3R1MVj6e/x0dN33+ilc006dBCDAQ0t8m8Bx++1G/5h6e0uYT4sR?=
 =?us-ascii?Q?8agT+Fa5+ZS3GxbIpO7iJ5jSI6pV0gxVd/56vvdKWoTW70bkTuToQmqn0klP?=
 =?us-ascii?Q?n6uH7b20DEN0xqW3W0AfualX4KGAtCitsXCgC7eSYMUAzz4bGydjbrAv1AlF?=
 =?us-ascii?Q?EQ1xEQ201IAt2a9wwkkeIYS8nNO76Bg9swgcqoZEuQsJy2j6MA2lzpd1bHvf?=
 =?us-ascii?Q?iMwSQfLh/u7yLrA//IsMRqdB1fPWX84fxbm6ADhvjrEIPPQTzRUXGO9iTGoc?=
 =?us-ascii?Q?VQQjU0quTj2O5zRB5BcC2np0gb04sZW/GHYqA8cHnp3Kn4IzQH1Bx5DD1uIX?=
 =?us-ascii?Q?ewB6IVrKcNsTRrAcVLoIpqvXTUE+MiF5RukLPq1GXwF/Nuf4Pfsbk78p8QL/?=
 =?us-ascii?Q?3UQ3y//mzNITsu52zx72uddnIyJjwidPLIKst2P6Dgbm3dVNzA84XFlwJEZJ?=
 =?us-ascii?Q?8X0C6aA4g0BG0MEW46/2Y0aC8HDLmyUckZ+grk+iyDTLyFr/0s+e5Y7Z0Jup?=
 =?us-ascii?Q?TdMumP/BQrCZn5LSc2iWNPrUGBj6iqI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d04ccf-df7a-4647-09b8-08da38631d70
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:37.5176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7G5yB6oBo8nCZRdgUAJs0iN9FoKJNd81VLQr27byhIwxg3nadB/9NVNHSySv0T/sKR+ziAQRRGENrXI2I0YBYFdUaBygjhu8vAqOFHbk6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: usoeQAAA9O3FUHseuWJmwOLFGDryEKDr
X-Proofpoint-ORIG-GUID: usoeQAAA9O3FUHseuWJmwOLFGDryEKDr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 1d08e11d04d293cb7006d1c8641be1fdd8a8e397

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c | 119 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_defer.c  |   1 +
 libxfs/xfs_defer.h  |   1 +
 libxfs/xfs_format.h |   9 +++-
 4 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 1337fa5fa457..d2d12b50cce4 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -120,6 +120,125 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
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
+	args->trans->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
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
index 3a2576c14ee9..259ae39f90b5 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -180,6 +180,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static bool
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index c3a540345fae..f18494c0d791 100644
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
index d665c04e69dd..302b50bc5830 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
 	sbp->sb_features_log_incompat |= features;
 }
 
+static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
+		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+}
 
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
-- 
2.25.1

