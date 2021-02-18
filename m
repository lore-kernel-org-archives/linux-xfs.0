Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B6FC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A0E264ED0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhBRSrR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbhBRQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTokt040528
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RkzCi8OZfI/c9FnKZi31CDw7K0ag4CKTz3kKt0PjB9g=;
 b=VZvohHdwlWfVYrPuTvklbnlNiy/xW3t+ZkFaGd2E7SVVHn7IBVMTgDo1beTwTuv/7QhH
 ku2JOPTt+6i+wPHHgc7an1YRoebzMzblsDoDYb0dNSDbsFn3ildE8yhfr9BhWH0wUETT
 ZNPHqNyO8VoCRKrWQRieNOqmbkL7XQ9hE5l9S70kSjTGAqGnnztQ3kwC+ck60wn5GJ6f
 t40I7amGril++fBBl0Bc37n3z2mAO+88ULMQX0Oq92S9gekGPqE3+lAdf36wRLCBNo5t
 126i4WUSwECaM0duvEJl20NgZuPbRKHgpFM0DogfBgFqFOsVfVeRGHr4/P/0UQn3pxAw sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUJtH067880
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 36prp1rkmw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0AAsLvcvPxdHZELdXKx7/6W1YTGROa6mgYZBqTMciU/2QD1n80zpsplLGLvvPuhWHQR6vZrOkq4ANVfP9aiS5Gkq0TmemqDI2cJnnsjOe0jbl16SXVS+DLrXoTz+wvRcqwG9eVxnjih4LSz4ufXDsI5KWne9MPisyx1Jz7la/4w+J2Ph0dZdoxTTTFHVYLOlvpKVfEypsMJ2zP2RW9NK7ct5rn+k7NxJ9y018A3F74pagXzRFzIBm0rxCZZ8TO+kmZvwzch+GoQrQPaVuYk9mD9Tk8kEoxCfoUkPkPNqqwcSY3Zdn5qGwE6dTkkTwJB8B2yVnCOUP2ajQeXf7GzIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkzCi8OZfI/c9FnKZi31CDw7K0ag4CKTz3kKt0PjB9g=;
 b=RxxphXjSt5Raqg/ckPSLgE/8XgLfGdy6PE7kb67+c3ZKgaeN3SKTUr/85P7y4GZl69VPwVBVce5HE/6oCHpb1wFuqVdXCxf8ug1+EBXKrtq3zgCXYQYCJ0aOImOncmSFKTvAcyrz/sIIWFd/JVJKgE0j/RtogqMMfOA3vKShlhM/M5FMRFXfpI1q4xVhMW5afbUaZQxCtqD/c2RJ7VRkWRFUY0ie8LDySnt+8uI6QzlRhRf8bnOc7u4cCFi1p+zoWsLF9vou4T5/S1YNdWc2DZmZtWuWvt5ymvIn5JzpNtfpKty+jZqfC3cxrO9f2SRIZb8PD1dAIVs2xmTod4/u3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkzCi8OZfI/c9FnKZi31CDw7K0ag4CKTz3kKt0PjB9g=;
 b=p78XxCfoEl0DXw9xUzWU21v0m9M8pY1+LzuXGRcgL2YTA8UjRNCR15v54hhD0+XqhRs+MhKkV7DuVQrWazULi8K9iwuGBxPMQgx2/JNEs60OAZvH9nybebD6JhKUy9ZSkr18fCx1axYpUfSsdrQ03qP/9E+zXvOoxDpYizT/lE0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:46:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:46:16 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 32/37] xfsprogs: Set up infastructure for deferred attribute operations
Date:   Thu, 18 Feb 2021 09:45:07 -0700
Message-Id: <20210218164512.4659-33-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c23573e-fa64-42fd-6591-08d8d42ca361
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB29655E05A60D4C6700C3843F95859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:194;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CNnRG6XEH3tQoLeTH1UC01icFbiKewswPygeM5xT3MuuIf71OXSkv1px09ds8EawygKYkRpRX1mqeHLtrIMKjI8ntJHJRYR3wmh8V9jldm0VzvoTVMAQB4O6z2627eHJ+KjJkkOaxTZ1/71Y7Z2qBFZteIjwjC1hULGjGdaarbXHQQacaJFq4GSiOvzmBTlbarUCC8k+14p14uPkK3u2Pp9bgc7oclUoQ0wOgg1iVrb5uQKsL0pTOBNqblHAcQUGSQZV8hhmNjAh7oa3tB5XmQZfYT2KBNrJWIesiOsaJAInl5rgwk3mWklNVpbozDP+ggrfocGJR+0cBFDv0VmIW2icVkdYWwbSPwWFcOVR8Eqaq2+xmi+fFiTEbqTrMeTnpQw7pErqeSJYV6ypk9nszYt79DUzdv16liPKPxK/CkNHfKXN9wNozM5sVx3csHA5fl+eKygPuDpXPasWCQhrDPLCQLcKLCj7xbrHNjAPa2mPvTEWsRhIu4GgXxqkLOD57vAOjNxeGOaiDGjRY9KgYFvTWLZZUQ6uM0F35QcC47uZ9fzEDcsynqTAYcLUS2ospClZG6f6DSAP6uM6AwVaTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(69590400012)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(30864003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZdrQQ0//4Mf8FSAsuc7E7tlUF9uJSSLdZA4QtgP2PtrNqSB9DRlWuPJSw1Jb?=
 =?us-ascii?Q?CUs4Lr6wZMgL61EoH+hn9Qh018b4nbRG7umOE3GK8l2ugOs3R2GcEtCI30wS?=
 =?us-ascii?Q?e+fYQUGt+dpvQ1x3r+mUHA/UgEzmNHGrvPBu1SQ4wfVAm4TTSizZ8J9tRzs3?=
 =?us-ascii?Q?kU6hlk/vLtj5Yjec2Hej8Xz1J4GTEf3UwZtVGQN3MbSvoZoFtxHtdUbwpFn2?=
 =?us-ascii?Q?kYmZjlFwsksLgXc5+DUq7+urzz4JVXKKAte3jEjrjPwRbNifdhOfNV5YWUe1?=
 =?us-ascii?Q?kR3gPvX3uZ/svkxmTMeZ/tO08EzbDBfLscyvjmkBLo/ofOrgAWUunoy39aGp?=
 =?us-ascii?Q?4JtGtV2G8ZDQal+lwUX/khsIkK/J0DOndq/YrJBuPdLEtDzf2C6VZgeBZu7v?=
 =?us-ascii?Q?5+NzTd0IogxqBub1s46aYgxcWpOtFtmfJlmP0nc1Sa3Bjd/vTCYdoBr7Hwyn?=
 =?us-ascii?Q?KRM/cIaPs9iwc020EjcAb7jzmD4yGm9p9cfjg+493UjsKWtikkawEn7jOBnW?=
 =?us-ascii?Q?yyAmkX1AmlZAwbcdhlc+m5httIdIA2Rzl2Z2mJ24KJajGMUue1rk1Ee0a2BR?=
 =?us-ascii?Q?/6lGWvkG74rgttpPmYVsktgcVprQH9bVUCQvlqWAdx22lVrSUT1NXMGv6PbY?=
 =?us-ascii?Q?P2GbUvIYw7DptXMfdYN0NFEu0siDJgch/aRzyIQikhwxVtavxmO4tBIUAkEE?=
 =?us-ascii?Q?49hgHK98z1G+yFAiCkFJLanbDfnAHkb4gsS2tu5VPrx5IgPl/WS75XA8P/6W?=
 =?us-ascii?Q?pvC8dzRJwFQiNH18blGceTDQbjp1SxKTP/k2YLUNxP3urQZSeWhcpQmNAbIg?=
 =?us-ascii?Q?puAfg/ndgA/rj5T/E35k+oGzPes18E2MXxqLQoZEPpcy+RxWfvSuNFg5VgLF?=
 =?us-ascii?Q?7lQQLChtQqvIxT/m3xSTvGTD9QQItITwtuII2e+TfGa4GjVvm7C3uxDKlyku?=
 =?us-ascii?Q?Y182Vo+Yxee9I67LZf4HdoZynLvBJ9JfUNeG9KchTC+DDQDQXm+y6LvXncZO?=
 =?us-ascii?Q?ZV6YBipIkBWjZ5UGwMvNfP09rjj/us/k8tglLh5T2ol5NETWlLCNI8p0KYuG?=
 =?us-ascii?Q?fcxpyArpMl0cP/bz8N9oH7NYXWPCRTQMSqULFqN60YLP0D7f1Ud8DQhzV0Jn?=
 =?us-ascii?Q?IOtjjUOIRbmzcG5pY7hx6UxHoda7ilagZzK3d0ZvrH+tXhxBeZUJ++C5V+8g?=
 =?us-ascii?Q?Zy3jLBOSAhr6R5y0p6Bmn3nWeU3jv4oFWEk/o1rZp0348k3QtB1X5iHivkZH?=
 =?us-ascii?Q?VJxK0KE1Q9LandmghZCCHACswbFwVFbje2y0NtKuR5sy/yuEF8rRfflX9NqE?=
 =?us-ascii?Q?CiuqZw7Ppl1MDZFjLDtddTHy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c23573e-fa64-42fd-6591-08d8d42ca361
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:45.8928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lKz1FfETWtOTMlSFEsInrinyYuhqphN5ouO7AKhsRzEuDr1X+W0CeXgsvKIKAIW2n//32+ZtxsOx3R3R80I5Gf9ZblA/l36bWcyzvzamNgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently attributes are modified directly across one or more
transactions. But they are not logged or replayed in the event of an
error. The goal of delayed attributes is to enable logging and replaying
of attribute operations using the existing delayed operations
infrastructure.  This will later enable the attributes to become part of
larger multi part operations that also must first be recorded to the
log.  This is mostly of interest in the scheme of parent pointers which
would need to maintain an attribute containing parent inode information
any time an inode is moved, created, or removed.  Parent pointers would
then be of interest to any feature that would need to quickly derive an
inode path from the mount point. Online scrub, nfs lookups and fs grow
or shrink operations are all features that could take advantage of this.

This patch adds two new log item types for setting or removing
attributes as deferred operations.  The xfs_attri_log_item logs an
intent to set or remove an attribute.  The corresponding
xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
freed once the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute name, value,
flags, inode, and an op_flag that indicates if the operations is a set
or remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c     | 132 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h    |   1 +
 libxfs/xfs_attr.c       |   7 +--
 libxfs/xfs_attr.h       |  31 ++++++++++++
 libxfs/xfs_defer.c      |   1 +
 libxfs/xfs_defer.h      |   2 +
 libxfs/xfs_log_format.h |  43 +++++++++++++++-
 7 files changed, 212 insertions(+), 5 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b18182e..ab21173 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -16,10 +16,14 @@
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
+#include "xfs_attr_item.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -112,6 +116,134 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
+static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
+}
+
+/*
+ * Log an ATTRI it to the ATTRD when the attr op is done.  An attr operation
+ * may be a set or a remove.  Note that the transaction is marked dirty
+ * regardless of whether the operation succeeds or fails to support the
+ * ATTRI/ATTRD lifecycle rules.
+ */
+int
+xfs_trans_attr(
+	struct xfs_delattr_context	*dac,
+	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
+
+	error = xfs_qm_dqattach_locked(args->dp, 0);
+	if (error)
+		return error;
+
+	switch (op_flags) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		error = xfs_attr_set_iter(dac, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q((args->dp)));
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
+	struct xfs_delattr_context      *dac;
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
+	error = xfs_trans_attr(dac, ATTRD_ITEM(done), &dac->leaf_bp,
+			       attr->xattri_op_flags);
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
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index f1b1ca10..e40a02e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -497,6 +497,7 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
 #define xfs_trans_unreserve_quota_nblks(t,i,b,n,f)	((void) 0)
 #define xfs_qm_dqattach(i)				(0)
+#define xfs_qm_dqattach_locked(i,b)			(0)
 
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b960340..28212da 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_attr_item.h"
 
 /*
  * xfs_attr.c
@@ -61,8 +62,8 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-			     struct xfs_buf **leaf_bp);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+		      struct xfs_buf **leaf_bp);
 
 int
 xfs_inode_hasattr(
@@ -144,7 +145,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 603887e..ee79763 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -28,6 +28,11 @@ struct xfs_attr_list_context;
  */
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
+static inline bool xfs_hasdelattr(struct xfs_mount *mp)
+{
+	return false;
+}
+
 /*
  * Kernel-internal version of the attrlist cursor.
  */
@@ -390,6 +395,7 @@ enum xfs_delattr_state {
  */
 #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -397,6 +403,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/*
+	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
+	 */
+	struct xfs_buf		*leaf_bp;
+
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
@@ -410,6 +421,23 @@ struct xfs_delattr_context {
 	enum xfs_delattr_state  dela_state;
 };
 
+/*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_delattr_context	xattri_dac;
+
+	/*
+	 * Indicates if the attr operation is a set or a remove
+	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
+	 */
+	uint32_t			xattri_op_flags;
+
+	/* used to log this item to an intent */
+	struct list_head		xattri_list;
+};
+
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -425,11 +453,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+		      struct xfs_buf **leaf_bp);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1fdf6c7..06df7ea 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -174,6 +174,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static void
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 05472f7..58cf4e2 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
@@ -63,6 +64,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_attr_defer_type;
 
 /*
  * This structure enables a dfops user to detach the chain of deferred
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 8bd00da..59c2807 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,7 +117,11 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_CUD_FORMAT	24
 #define XLOG_REG_TYPE_BUI_FORMAT	25
 #define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_MAX		26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_MAX		30
 
 /*
  * Flags to log operation header
@@ -240,6 +244,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define	XFS_LI_ATTRI		0x1246	/* attr set/remove intent*/
+#define XFS_LI_ATTRD		0x1247	/* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -255,7 +261,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -863,4 +871,35 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+/*
+ * Flags for deferred attribute operations.
+ * Upper bits are flags, lower byte is type code
+ */
+#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
+#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0x0FF	/* Flags type mask */
+
+/*
+ * This is the structure used to lay out an attr log item in the
+ * log.
+ */
+struct xfs_attri_log_format {
+	uint16_t	alfi_type;	/* attri log item type */
+	uint16_t	alfi_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfi_id;	/* attri identifier */
+	uint64_t	alfi_ino;	/* the inode for this attr operation */
+	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
+	uint32_t	alfi_name_len;	/* attr name length */
+	uint32_t	alfi_value_len;	/* attr value length */
+	uint32_t	alfi_attr_flags;/* attr flags */
+};
+
+struct xfs_attrd_log_format {
+	uint16_t	alfd_type;	/* attrd log item type */
+	uint16_t	alfd_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfd_alf_id;	/* id of corresponding attri */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
-- 
2.7.4

