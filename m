Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AE7C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353152AbiETTA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353103AbiETTAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966B87672
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIss0P004411
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=3NZpY3pi5BuM4KLKpJUyhxNZ6mc1ffUqXtU0mDVV0CQ=;
 b=wGIghTMPKmEHV7p8s6vZr5yzlQUSQP14Ekw2B3VkQO4xLPvO1I8Pt9y52j5ybZ7KejLu
 27QgnPZ1e93K/HrQpWOa8c2CBoCijTZa5J1Y+wNMr2xjBpVyqVWGhT524NV6PKo1pFkG
 CYb+YflXLNFANjAz/tsBPI9Q+XixQTBc9rffQpwLRFs3OBIUutnYeGGgNQ1z0DJmXDXk
 YBkYMs01ZM2DthLnRe7CFWr3zZPNR2amvY1488lmjS9/eeH01qYcZAymKrveyd/piAt1
 5ziaU89EgK8nh0p3SaT8ts+NEjEvFRONJ3fRB7Wv5WjCAHtGnSV51XkOSGx7pcutNEmg JA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucfe3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIo9u1034597
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhfm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkSlZF9U7WDA1Lq9iuYALPB/vXZujPt95fP+jQsano6CvxahQCrnIyIc+NI+TxRcCnsOuGz6IQz7VS2KaZZv1KOxU7IveHlWjZozGsbxgmH6Kfg39QZ0lhLJHRzi27de4uXcBR277QeVCro8N1Whi/tTby547dA8OogGaL/Tf8mp/CR8OE/z1VCGCloDYegqi2SVfcDeH1Gc7W3CPhFDeYacZ7SvYTdrEwmNTNwcamPAK/YyDMunZAoBjsBQbqwCgbsFudosV/igTelCqYOKOfssLhnve6OIzzw2HWTtqw1Y2/S/rtoOABXoGYmWDId7SwIv7Av6mzTl/DpgWHo4ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NZpY3pi5BuM4KLKpJUyhxNZ6mc1ffUqXtU0mDVV0CQ=;
 b=BdS5AA2nggPG6O8GY40bTZp8h6UnF7Zl6BIioLSywdSKv3HbAnDyh9pAz+eWTefKftfXICQlZ3AXT0/BIs4AYUGQvrwZYS2T+F/JvDhW2VhxClcHCp1QQVYowZLtjmwrCejv07Xc4dxVSnvmKqjgdpEnYne4cY7dv0iFMnXZO1Y88TwlfBjZIP7ouMzhY5nZyUKvro/qqHjtT4jTm+1JxEiXdTpSZntafVqQk50nTYSyUuLg5XOjvUsVBFPxCUUeotBbTHvfWJHJKAu3RtcK3oTeMhrnVjXsaWOHUN2T8Vzv09mZm7buwYn4OgXiEmKEx6Klis70pEiWt8HjF9YSZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NZpY3pi5BuM4KLKpJUyhxNZ6mc1ffUqXtU0mDVV0CQ=;
 b=OsRJPK9CqrMahhzBtb6EO4BXdmcnIjfbgs4Gf8bqZFnigvqJx+xPKJv9VYSIJo/shLfQPDAs/HZk/OioJd1VmKvpu2O02gdw5Qhm/vXgju69Y5UGFF9yVXklv95N72ybEIPtKFqMppa+4811cC52A/GBb6/hIKpFdo3KpZu2euk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3399.namprd10.prod.outlook.com (2603:10b6:a03:15b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 19:00:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 08/18] xfsprogs: Implement attr logging and replay
Date:   Fri, 20 May 2022 12:00:21 -0700
Message-Id: <20220520190031.2198236-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb616f53-115c-46a7-6b92-08da3a93081e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3399:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3399C7CC104DC349D18B59EA95D39@BYAPR10MB3399.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: shmpJc7M0rVN/+cIPLTCUuW0PoOszJ0DDCiSoPs6x1gvZFVKCH7/cFNIhNSBUhTUMrE+xmxtMPuXbsyRd5bc49bldM6AAs5GiEDT7TM4qPrEmwrF5IqpTJZccOeQDS8bYuX4cHw4rLitZEDnK7dqTwOKK/Obwx4CzcdfTZyKLmlvoOtl3vpgBfPwpliw8QtkZb6eHgEW7MkcF4U9l3BYDB/hgrpQ88GhOu/UdPbZqC0ZEUQ2CQm4Uy6ny554nIwBV6BsNyvH218OrtIFxuuKzd3cXMKy6tGW5aipPQByCSGFxr3zcSra2PBXRm/POkX0UwpYjdCds0oVckbMSGXDf8EgeNST2Iw6ZFydhTEqupm8H3i7I3b789wYvBEE7Y+c4bLEwArZFP5rN/YmKa7GKXdFK6lWHRp9Gkhpb70falPo0AfRklEwsSRaXBVku0UR9yK+6lrpbTBjeZICL7N27f3GeBcWD/Z+m7DXcMlO3GQgfRMvi290M7M2O62Hcc3aEzq9q2ZvY0wDahjPOD9//xRAVbhOZV4tK3vc+/EWKg2x4cK72iDxCSr2q/nmrdshO15LDWXQj8sr7nMDZCCHB6vOo+o+mxFZgEhSQ+sh+KejyyKegnUOwzhSG3KTuzBnDZ2CWTFirMX9BmsPcKX+PAwIRPZyFHDX8LSb6mHRwcvTr9z0Z9EHlFG4S2VdZs2CSq2njwlNsVgzl5E1rFAxlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(6666004)(66556008)(1076003)(2906002)(66476007)(83380400001)(52116002)(26005)(6916009)(316002)(36756003)(6512007)(6506007)(66946007)(6486002)(8936002)(38100700002)(38350700002)(5660300002)(186003)(8676002)(508600001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ddGp4snej5pP13fufk+Jnpo/5m/Q9OCr0wUByd1HLqLnC3b3/93sybf/+t8S?=
 =?us-ascii?Q?fsHrFbh2WU40jVogtwBByFlDfZuiwC/naVkAPODUToJc1GsLCabEWZrfHVDh?=
 =?us-ascii?Q?vFUwcKWPtSAjAzBOqnJwO6+gnqB6p8zAkJyFC1sXoSEBIlJWNwNXG+QQA31E?=
 =?us-ascii?Q?cM39uFJdz/sIwP4rL187B1Czl+zKwnovY58UJRE8EzmxzAcISyivHGhiNEml?=
 =?us-ascii?Q?1vpJOPmGnmmMTCmbojgdACKx3ZpOxPtgJXPA53iB3DtKa8MGxrAWim6qqOia?=
 =?us-ascii?Q?C27rxePNrUWRb4OAWryh93jvyhgirgQedgGVHRe9T2i+x4PdwwP6uFa7KIoN?=
 =?us-ascii?Q?rjqLme3BdJjaUr6RooThAkDXTsK4J6cK2acr1ORkcn0DMsrIAO3s0Vtizwcq?=
 =?us-ascii?Q?FCDrlVWb2p0T6AS5fv6BZxKBpmww9rj3cieF8LbhneQE6TjacUbhGhBCOrzV?=
 =?us-ascii?Q?nhdRC68RpZQmHGepuLUXSDhhs7jIu2uKZD4lGfjorQkrLYuc5v2EFAc2cWHS?=
 =?us-ascii?Q?PZ2F90nCoHblk1wLYmhtitS8abfH8wuMBpfQrLxBifMRP+TtlB9fDYUhPj4d?=
 =?us-ascii?Q?xhb7XbML1Gi5+XmvPYqtiVFMAMT/+SZxM0JVULx4M6VqfuDVGbRkrxpZ6U1X?=
 =?us-ascii?Q?f/NyEnKCZlEPhgCDcZbCtU05C/4zabvhxraOBgHCnaFfWq0BnWZvG7900nwR?=
 =?us-ascii?Q?E7eiQEgzUv+XdTIRCpmGwDok4TPHhGdhGSDjDQmZ9JIJ3QbeROOgv9Cpq0Cl?=
 =?us-ascii?Q?kqlnVAxFzApqQO5j9jjmXHBPRkQpL7eWCa1ru/odpl2fry21T6yEtmpQoIEh?=
 =?us-ascii?Q?TnzYmnlijjXTMXg7veCcrCWzPxDcV/XkRG2QX1vgB7L8TsfZSJtPf18Ntufy?=
 =?us-ascii?Q?8R59cFBAFPDUhcJa/kIlbTPqTXAUhdLoHekU2Lai8ZCNicSFJ0mj8r2Hs91z?=
 =?us-ascii?Q?8DfmZJy6rkKkXYI5yWWGkUFVngxitZYCbxE8btVubxEpcSYmmL679sGCewj3?=
 =?us-ascii?Q?/7SbTCbcQJqIu0KhKPn1mDFZM3OpShF20NZk7xDhsUFZ4s3eKRjZT+8hrraP?=
 =?us-ascii?Q?3TBGT8jc1DgDXJ2pPeDv8vlwrFjcFfSU//gt80Hiw5HRj+nFx8cb7Wy2CPF+?=
 =?us-ascii?Q?N4xDqd3H0o4gvMMSBsqULU+XkuHi2yWt4j5R5wVxL6eMtMfmd1AxJrk2kXsL?=
 =?us-ascii?Q?ZtRACefYQndiM+Nxwc0C7u49wPJdsKyx7LPlgHDheaBoyQ/yOYTjYQWUfuzZ?=
 =?us-ascii?Q?tv4JQo0AvK8VrZDn7cvLCFOKjFInZK6s83wimBM+s8kDdqjUHwQkAPf/9eXC?=
 =?us-ascii?Q?r3V+32iNwFenEiIzTihHSoG/p/NKr2+aIVy9lHMBUte5rP/GOzo1b7WycLJd?=
 =?us-ascii?Q?dhIlObcWT9s2js4z3A24zrsO6qdGO8ls50TLbQH+6i2vJ6Yf4yW3vsOLeWIk?=
 =?us-ascii?Q?UV/6FtRUwOgpEwNp1C7DL8/1xYewScO9g5+PoZLVrsyLdxSoXUKd04t2tyFf?=
 =?us-ascii?Q?KNH2fklT5yS6JGCbFEUr4H88BZYMTZmQpJRK0f0JgyjTDKzSZLASFcSkvGLy?=
 =?us-ascii?Q?xEsk/lZx+0Jo/KIdRap2htDFNRzXfh8iZ24jmlGHRlhgbHscyhW+zW4/m6+M?=
 =?us-ascii?Q?2+KdgBy8JOajCu2y9CFCZqAtuw6sPd46DZ30lJxXD1aUGm4JAmX54d7Nt9ya?=
 =?us-ascii?Q?lLLz23v4m9g/I1iwo7/myAbHpfCOW2O4RMs683BVrG1/MiMPmKlZArJCKoTj?=
 =?us-ascii?Q?ADZp9wrIYe2pjthnbfH1CNyeK6L/8yw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb616f53-115c-46a7-6b92-08da3a93081e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:39.7942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMf6xT7scMKxmxNU1z/w1IlbG+j8GqEHSMkoRoxC4cIfWMvD07INgWXiLCiHktXjJk2/G2/JNrxpfTmMqNo82Hi02ZGRlv6C6+TmVpmA2Po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3399
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: i753x0nUqsEXfuVFbBDU1o4a7t-taicn
X-Proofpoint-ORIG-GUID: i753x0nUqsEXfuVFbBDU1o4a7t-taicn
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
 libxfs/defer_item.c | 92 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_defer.c  |  1 +
 libxfs/xfs_defer.h  |  1 +
 libxfs/xfs_format.h |  9 ++++-
 4 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 1337fa5fa457..be2a9903701f 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -120,6 +120,98 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
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
+	struct xfs_da_args		*args;
+	unsigned int			op;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	dac = &attr->xattri_dac;
+	args = dac->da_args;
+	op = attr->xattri_op_flags & XFS_ATTR_OP_FLAGS_TYPE_MASK;
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	args->trans = tp;
+
+	switch (op) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		error = xfs_attr_set_iter(dac, &dac->leaf_bp);
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

