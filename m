Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6480EC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC7D61418
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhD1IKb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43440 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbhD1IKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80HCl015794
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=apBVEMCECGqSZXvhn4W4+W6k+OReoYJds97WK7QSpdA=;
 b=eLBaBRPkQosRcQN34G/QVr8r5anmrzoW9HXrFndOLRmTvsmwFxine0dtBu+n5yvcDXrc
 iNUCAv4hkubK35XspOlAtNMnAqbDWeJUKSM/oY7AYQKeHh0XdcSPLaSlkNUBxHDse0CK
 ld93j38TlQwmjcN7Fu71w0Xoih9AFayRLivbmvBHBh6u0N7CoJ4NS7pW4CTpC6xpYFHC
 PiLa7ggLupPkCZIAFF2+UNeo0b00NMinFRi2zoSnZjmveFMHsNbuXiwHVwzMGVYTQNXf
 Y/Da8QbWlp/Qq+lij/rh9P1+dbKnJFu0lj9+Ve3J9GDCpbigU8gHbMSWY/YQ6vK9NOmy gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 385aepyxdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S7xvkS002286
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:39 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2053.outbound.protection.outlook.com [104.47.38.53])
        by aserp3020.oracle.com with ESMTP id 384b582vfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RS/z+Tuh9Nztxpku2GBcBihhlEtFAM3BsyLewks6aXOB36PoQ6N/3dabdTCe/tkgxQVjKCJY3nczOkHupfPX1Zzq5yejWmYnFGp9C9tA+887voAeNXZVB6PWEkG5lb2eT+MFfR7uqDD6Cq1wehYiN+QS826uhHNatnj18fCj1wT5Qwk/kWTjqU4/DvRe8zifSqBsHv1a9u2QvsMRXhpeg0ySzVE07X75xbf6gCKueVz6lXL1QVgLGG9qa0h4Zu5+EqbmAeifuspno5rpKs8Cdk/eTjJ29Ztw+BuNRqHDPo6CQDoCoDVRbogg1sd/caHcSYKRzMXx7lCBMbtFjh5KEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apBVEMCECGqSZXvhn4W4+W6k+OReoYJds97WK7QSpdA=;
 b=O4eBJD5MBXX67gOYkeyZHocHiUAXLX/W0J9MGwnWRyOzekTuVNeFJR4R+avMNv2Mp0Ouy63Q3LIwpJr3l/Sp+TOFqznt69GIIi2IrpSbzHJmUe8Onp5cP1Z8mb1n1YS4RYnXuc3vx5XQHyONVDI4veAN7/mtl+g98nw/ok9LtoJod1kCyPoqnzzUFXETwbNKJGLn0Q/Tf7IFWH2aztQp8GBZNRBlJ5771wRMsbZhvm9B0XTf4hWqek2uQ7p8wCGZH3fMRxn8T5kbIBWWEs9r7Zt0AoSwS5Kidwj05d2XKkV1W1CEaQZbNeJM/HhsaOYW5v7EQF14MgQTVa7oXUJajg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apBVEMCECGqSZXvhn4W4+W6k+OReoYJds97WK7QSpdA=;
 b=eypqvUCvQlha3i5nZsz1YQXUhCUbkr7UywklT4KdWWQ5D/RbJ1z5IPTrWL3DFMt7E2TfeQ1NG7Q5TNpW1VRNajyamUR4HHxuRxYLaAYIz+SXZeazDuWXSBwwAiXG7u3N+8DcCHq9i0F6hwIqpOxIVwBvYZvSi/fYfmkoPz8ia8M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4655.namprd10.prod.outlook.com (2603:10b6:a03:2df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Wed, 28 Apr
 2021 08:09:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 11/11] xfs: Add delay ready attr set routines
Date:   Wed, 28 Apr 2021 01:09:19 -0700
Message-Id: <20210428080919.20331-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1680b8f-1745-4058-812e-08d90a1cf61c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4655:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4655E8BD4D657E3BACF9FD5495409@SJ0PR10MB4655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6WovA/xteF4F/74PK4/egXWw6/KzMqVGcX6zU4iIPDM+ZoWrO9eo2bnBq1lJkjPQnYwjeVFBMjlPUt5snJdQTd3dYNtZjUaQ4MVZcXx0GXyD5UI7K2UioIUnJ4GWP2CjdC8Ttb81QfcydWsorjzJD0cELc8QS26F/nab9oI6YwoKZ7ge4nVK3CxJsxV6KHPfkxxZLiyk3kKZvZD6S12r2ROd1S+glSfXm+2d9s9Z6aqWf1gbyX+4OIZRnTL2CeyvG1aoGqXOifRbaariCbdfT53dO1c83uKUGE6oSfauJfmAgpIrUdCgnvpu84SlG+TU5JI3fkzIgkfYjH+YXy3ykF+ipffwXYb5zGQ1WpywiKlSB1d0UlWdHx9gA3orfafOKVHabbnneujJFkggpZLWo7OJx0QbQlbv+rh7v5kbt5Kum6h4sUyCBvipLbJ9SF+mqCWfYDGHntcrSrpmoYu2+3eFRs5Y1cc+Yuca0h4d+4bvedBTmy4DnpOKwIV4Xuky3h4aKmOyfEIgbUN6kFjNKDsu2ICJnhoemannzh3eHFiJHtFk0ICQig2F9BbynEl6uZoEERfDDjTqAJznmCP/a5gmx21NwPz3FnV6M4B+OCK5vS3USDycxNuUSYNqXeA3slk5IapO+IWoIPDXDUoKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(366004)(376002)(6506007)(52116002)(6486002)(956004)(186003)(36756003)(66946007)(38350700002)(30864003)(44832011)(66476007)(86362001)(66556008)(38100700002)(478600001)(2906002)(83380400001)(8936002)(8676002)(316002)(6512007)(1076003)(5660300002)(16526019)(2616005)(6666004)(6916009)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8BJmohO77Sj5BfFXrfd2Jq6SdxpmtOPn0tlV8wMyf/DlR9CYkk0aOGT92YMs?=
 =?us-ascii?Q?y1QjC5oKbK2PsTBz/FsuosUc0nwanbcD2a9SWjVr5tby4wStNC3cNsOpCR8U?=
 =?us-ascii?Q?shRLt8nzmSFd2Cv8P3U1WhFwFcjtTVvvvE3dhyR1pc2gDP0/JDWVgDwon2h6?=
 =?us-ascii?Q?Ud/nl9c9Qc26Y1M5lJugOMfn7KKAULy6eAhFphzMM8ArN8FjCgR6uo7DkNb8?=
 =?us-ascii?Q?kfwACCtFUNXcFPAtLZ4Sp4ExHxhHX6xED5wF1zBWfZHZ4m+tZmpaklfRFjX9?=
 =?us-ascii?Q?zXtPrrVct+6jaKD7tml7Zq7p5wNTLnVVuSiMX+pY117zoJnqYiCsxnEUWHXI?=
 =?us-ascii?Q?CSc4p0M6UMR2iys7ozoOpKffto1KJfUK+7G4DCX3DqIVLmZ2jmno+x500dAX?=
 =?us-ascii?Q?qPIpeByggsKXrEYyEMWcOhPVULhRCH2TevN0HokkD43MrRMT+Zm92po+yziY?=
 =?us-ascii?Q?cc2Zg3c/9CesCXg37xrqdzzIAf/q3kt9C/Wvnip/jU6SXAYPOP1FGz/Se12s?=
 =?us-ascii?Q?TnTFI/wk4sUWtAkUf3tls1iBLYRieZmZlQ++bi6fi1WmIfQ+RiiA6n2iP7LJ?=
 =?us-ascii?Q?MTrzS8HfhDQo9Lp/ggrh4p3aKigy6Lprk4DLrSJV09GCDkpHRYYnt/8dhCzJ?=
 =?us-ascii?Q?HRK3JxCL+3ybj15U/IZxWbh9bVZbbZI1SrI+4jVlUtA4T/WR4+jcprajHfZ+?=
 =?us-ascii?Q?lFaY4my9dytAovSBNR5uPO/oUmm46WI89dUmM8NzlwvZf+vKH6VTzgPyiqSU?=
 =?us-ascii?Q?iJq6MPYtuNu97Z7JMoc4VoMhOj4+Rojeu0z1cy+audfpVaXLX3U5E59jbaCM?=
 =?us-ascii?Q?IovWk5syaoFtYFwtmECbTXAeaXi3d4Wyt5MigJf0b/ZiONri98anwANkScmL?=
 =?us-ascii?Q?bUdQsikxx7LW6g6BdheZ4/bje1lB5vUkyW0a+yfQY5ByCtQuKlVUgBpr7PYR?=
 =?us-ascii?Q?tJ5UNH6Q8636MqjEmkF01qrZf3hVE8rmAKGMCZ+t5k6SlFvwbxZwmnm8aRiU?=
 =?us-ascii?Q?Xr7Motutg10D8oRskLaqpjvh308N44NDSUsBypt1nIg1bn+Q/+0Qhwt718Bm?=
 =?us-ascii?Q?VFvCIM5QbYTVsWeIVcQDOb1kzlGwVoBAS6aNRJ1EnjOh+iTJOySd9579jKDg?=
 =?us-ascii?Q?gm5MbgStA2sr7qp/76e82khiC9DChsX6pK4yUTIkrI1qSrvURsaSWK7uO4JK?=
 =?us-ascii?Q?k6sfv2cpb2YQPUiGipOWe0FucYeyiFnu6GwI4UC9Z65wGtvh8KzIo7JoyU8X?=
 =?us-ascii?Q?tNwNlvb7Y6QW8j60SCmgnnBiiQH9H5BIhKi87K6TYNAaOvfJfi04K7J+LJQU?=
 =?us-ascii?Q?sA/9//PRoEY3mKuPgO6bq/t+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1680b8f-1745-4058-812e-08d90a1cf61c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:35.6390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tfUgNJceW0+o6uZJOyWFVyfF//XSmYv4qAyjhmH3/Iy6qNMezBjjTTkStOX4rKmg9afUbeiYElvk09eDUyam25YpxVhMfsQ1zJqawSdcmQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4655
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-ORIG-GUID: qlWyRWdKXMBFwCiasqkZUaGnOuGT7ab-
X-Proofpoint-GUID: qlWyRWdKXMBFwCiasqkZUaGnOuGT7ab-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr set routines to be delay ready. This means
they no longer roll or commit transactions, but instead return -EAGAIN
to have the calling routine roll and refresh the transaction.  In this
series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
state machine like switch to keep track of where it was when EAGAIN was
returned. See xfs_attr.h for a more detailed diagram of the states.

Two new helper functions have been added: xfs_attr_rmtval_find_space and
xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
xfs_attr_rmtval_set, but they store the current block in the delay attr
context to allow the caller to roll the transaction between allocations.
This helps to simplify and consolidate code used by
xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
now become a simple loop to refresh the transaction until the operation
is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
removed.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 450 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 272 +++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr_remote.c | 100 ++++++---
 fs/xfs/libxfs/xfs_attr_remote.h |   5 +-
 fs/xfs/xfs_trace.h              |   1 -
 5 files changed, 608 insertions(+), 220 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a91fff6..4096418 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -53,15 +53,16 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
-				 struct xfs_da_state *state);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
-				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
+STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname_clear_incomplete(
+				struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+			     struct xfs_buf **leaf_bp);
 
 int
 xfs_inode_hasattr(
@@ -244,7 +245,7 @@ xfs_attr_is_shortform(
  * Checks to see if a delayed attribute transaction should be rolled.  If so,
  * transaction is finished or rolled as needed.
  */
-int
+STATIC int
 xfs_attr_trans_roll(
 	struct xfs_delattr_context	*dac)
 {
@@ -265,29 +266,58 @@ xfs_attr_trans_roll(
 	return error;
 }
 
+/*
+ * Set the attribute specified in @args.
+ */
+int
+xfs_attr_set_args(
+	struct xfs_da_args		*args)
+{
+	struct xfs_buf			*leaf_bp = NULL;
+	int				error = 0;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
+
+	do {
+		error = xfs_attr_set_iter(&dac, &leaf_bp);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error) {
+			if (leaf_bp)
+				xfs_trans_brelse(args->trans, leaf_bp);
+			return error;
+		}
+	} while (true);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp)
 {
-	struct xfs_buf          *leaf_bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-	int			error2, error = 0;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
 
 	/*
 	 * Try to add the attr to the attribute list in the inode.
 	 */
 	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
-	}
+
+	/* Should only be 0, -EEXIST or -ENOSPC */
+	if (error != -ENOSPC)
+		return error;
 
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.
 	 * GROT: another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
 	if (error)
 		return error;
 
@@ -296,102 +326,130 @@ xfs_attr_set_fmt(
 	 * concurrent AIL push cannot grab the half-baked leaf buffer
 	 * and run into problems with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, leaf_bp);
-		return error;
-	}
+	xfs_trans_bhold(args->trans, *leaf_bp);
 
+	/*
+	 * We're still in XFS_DAS_UNINIT state here.  We've converted
+	 * the attr fork to leaf format and will restart with the leaf
+	 * add.
+	 */
+	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
 /*
  * Set the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
  */
 int
-xfs_attr_set_args(
-	struct xfs_da_args	*args)
+xfs_attr_set_iter(
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp)
 {
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_da_state     *state = NULL;
-	int			forkoff, error = 0;
+	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_buf			*bp = NULL;
+	int				forkoff, error = 0;
 
-	/*
-	 * If the attribute list is already in leaf format, jump straight to
-	 * leaf handling.  Otherwise, try to add the attribute to the shortform
-	 * list; if there's no room then convert the list to leaf format and try
-	 * again.
-	 */
-	if (xfs_attr_is_shortform(dp)) {
-		error = xfs_attr_set_fmt(args);
-		if (error != -EAGAIN)
-			return error;
-	}
+	/* State machine switch */
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
+		/*
+		 * If the fork is shortform, attempt to add the attr. If there
+		 * is no space, this converts to leaf format and returns
+		 * -EAGAIN with the leaf buffer held across the roll. The caller
+		 * will deal with a transaction roll error, but otherwise
+		 * release the hold once we return with a clean transaction.
+		 */
+		if (xfs_attr_is_shortform(dp))
+			return xfs_attr_set_fmt(dac, leaf_bp);
+		if (*leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, *leaf_bp);
+			*leaf_bp = NULL;
+		}
 
-	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC) {
-			/*
-			 * Promote the attribute list to the Btree format.
-			 */
-			error = xfs_attr3_leaf_to_node(args);
-			if (error)
+		if (xfs_attr_is_leaf(dp)) {
+			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			if (error == -ENOSPC) {
+				error = xfs_attr3_leaf_to_node(args);
+				if (error)
+					return error;
+
+				/*
+				 * Finish any deferred work items and roll the
+				 * transaction once more.  The goal here is to
+				 * call node_addname with the inode and
+				 * transaction in the same state (inode locked
+				 * and joined, transaction clean) no matter how
+				 * we got to this step.
+				 *
+				 * At this point, we are still in
+				 * XFS_DAS_UNINIT, but when we come back, we'll
+				 * be a node, so we'll fall down into the node
+				 * handling code below
+				 */
+				dac->flags |= XFS_DAC_DEFER_FINISH;
+				return -EAGAIN;
+			} else if (error) {
 				return error;
+			}
 
-			/*
-			 * Finish any deferred work items and roll the transaction once
-			 * more.  The goal here is to call node_addname with the inode
-			 * and transaction in the same state (inode locked and joined,
-			 * transaction clean) no matter how we got to this step.
-			 */
-			error = xfs_defer_finish(&args->trans);
+			dac->dela_state = XFS_DAS_FOUND_LBLK;
+		} else {
+			error = xfs_attr_node_addname_find_attr(dac);
 			if (error)
 				return error;
 
-			/*
-			 * Commit the current trans (including the inode) and
-			 * start a new one.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
+			error = xfs_attr_node_addname(dac);
 			if (error)
 				return error;
 
-			goto node;
-		} else if (error) {
-			return error;
+			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
-
-		/*
-		 * Commit the transaction that added the attr name so that
-		 * later routines can manage their own transactions.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-
+		return -EAGAIN;
+	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
 		 * identified for its storage and copy the value.  This is done
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_set(args);
+
+		/* Open coded xfs_attr_rmtval_set without trans handling */
+		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+			if (args->rmtblkno > 0) {
+				error = xfs_attr_rmtval_find_space(dac);
+				if (error)
+					return error;
+			}
+		}
+
+		/*
+		 * Repeat allocating remote blocks for the attr value until
+		 * blkcnt drops to zero.
+		 */
+		if (dac->blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+			return -EAGAIN;
 		}
 
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+
+		/*
+		 * If this is not a rename, clear the incomplete flag and we're
+		 * done.
+		 */
 		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-			/*
-			 * Added a "remote" value, just clear the incomplete
-			 *flag.
-			 */
 			if (args->rmtblkno > 0)
 				error = xfs_attr3_leaf_clearflag(args);
-
 			return error;
 		}
 
@@ -404,7 +462,6 @@ xfs_attr_set_args(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
@@ -412,29 +469,37 @@ xfs_attr_set_args(
 		 * Commit the flag value change and start the next trans in
 		 * series.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
-
+		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		return -EAGAIN;
+	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
 		 * "remote" value (if it exists).
 		 */
 		xfs_attr_restore_rmt_blk(args);
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
 
+		/* fallthrough */
+	case XFS_DAS_RM_LBLK:
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_invalidate(args);
+			error = __xfs_attr_rmtval_remove(dac);
 			if (error)
 				return error;
 
-			error = xfs_attr_rmtval_remove(args);
-			if (error)
-				return error;
+			dac->dela_state = XFS_DAS_RD_LEAF;
+			return -EAGAIN;
 		}
 
+		/* fallthrough */
+	case XFS_DAS_RD_LEAF:
 		/*
-		 * Read in the block containing the "old" attr, then remove the
-		 * "old" attr from that block (neat, huh!)
+		 * This is the last step for leaf format. Read the block with
+		 * the old attr, remove the old attr, check for shortform
+		 * conversion and return.
 		 */
 		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
 					   &bp);
@@ -443,97 +508,116 @@ xfs_attr_set_args(
 
 		xfs_attr3_leaf_remove(bp, args);
 
-		/*
-		 * If the result is small enough, shrink it all into the inode.
-		 */
 		forkoff = xfs_attr_shortform_allfit(bp, dp);
 		if (forkoff)
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
-	}
-node:
 
+	case XFS_DAS_FOUND_NBLK:
+		/*
+		 * Find space for remote blocks and fall into the allocation
+		 * state.
+		 */
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_find_space(dac);
+			if (error)
+				return error;
+		}
 
-	do {
-		error = xfs_attr_node_addname_find_attr(args, &state);
-		if (error)
-			return error;
-		error = xfs_attr_node_addname(args, state);
-	} while (error == -EAGAIN);
-	if (error)
-		return error;
+		/* fallthrough */
+	case XFS_DAS_ALLOC_NODE:
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		dac->dela_state = XFS_DAS_ALLOC_NODE;
+		if (args->rmtblkno > 0) {
+			if (dac->blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(dac);
+				if (error)
+					return error;
+				return -EAGAIN;
+			}
+
+			error = xfs_attr_rmtval_set_value(args);
+			if (error)
+				return error;
+		}
 
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
+		/*
+		 * If this was not a rename, clear the incomplete flag and we're
+		 * done.
+		 */
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+			goto out;
+		}
 
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+		/*
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 */
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			goto out;
 		/*
-		 * Added a "remote" value, just clear the incomplete flag.
+		 * Commit the flag value change and start the next trans in
+		 * series
 		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		goto out;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
+		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		return -EAGAIN;
 
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
+	case XFS_DAS_FLIP_NFLAG:
+		/*
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
+		 */
+		xfs_attr_restore_rmt_blk(args);
 
-	if (args->rmtblkno) {
 		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
 
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
+		/* fallthrough */
+	case XFS_DAS_RM_NBLK:
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_NBLK;
+		if (args->rmtblkno) {
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error)
+				return error;
+
+			dac->dela_state = XFS_DAS_CLR_FLAG;
+			return -EAGAIN;
+		}
 
-	error = xfs_attr_node_addname_clear_incomplete(args);
+		/* fallthrough */
+	case XFS_DAS_CLR_FLAG:
+		/*
+		 * The last state for node format. Look up the old attr and
+		 * remove it.
+		 */
+		error = xfs_attr_node_addname_clear_incomplete(dac);
+		break;
+	default:
+		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		break;
+	}
 out:
 	return error;
 }
 
+
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
@@ -997,18 +1081,18 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	struct xfs_da_args	*args,
-	struct xfs_da_state     **state)
+	struct xfs_delattr_context	*dac)
 {
-	int			retval;
+	struct xfs_da_args		*args = dac->da_args;
+	int				retval;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, state);
+	retval = xfs_attr_node_hasname(args, &dac->da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto error;
+		return retval;
 
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto error;
@@ -1034,8 +1118,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (*state)
-		xfs_da_state_free(*state);
+	if (dac->da_state)
+		xfs_da_state_free(dac->da_state);
 	return retval;
 }
 
@@ -1048,19 +1132,23 @@ xfs_attr_node_addname_find_attr(
  *
  * "Remote" attribute values confuse the issue and atomic rename operations
  * add a whole extra layer of confusion on top of that.
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ *returned.
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_state_blk		*blk;
+	int				error;
 
 	trace_xfs_attr_node_addname(args);
 
-	dp = args->dp;
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
@@ -1077,18 +1165,15 @@ xfs_attr_node_addname(
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 
 			/*
-			 * Commit the node conversion and start the next
-			 * trans in the chain.
+			 * Now that we have converted the leaf to a node, we can
+			 * roll the transaction, and try xfs_attr3_leaf_add
+			 * again on re-entry.  No need to set dela_state to do
+			 * this. dela_state is still unset by this function at
+			 * this point.
 			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-
+			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		}
 
@@ -1101,9 +1186,7 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1120,8 +1203,9 @@ xfs_attr_node_addname(
 
 STATIC
 int xfs_attr_node_addname_clear_incomplete(
-	struct xfs_da_args		*args)
+	struct xfs_delattr_context	*dac)
 {
+	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 32736d9..41ad5e8 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -164,6 +164,262 @@ struct xfs_attr_list_context {
  *              v
  *            done
  *
+ *
+ * Below is a state machine diagram for attr set operations.
+ *
+ * It seems the challenge with understanding this system comes from trying to
+ * absorb the state machine all at once, when really one should only be looking
+ * at it with in the context of a single function. Once a state sensitive
+ * function is called, the idea is that it "takes ownership" of the
+ * state machine. It isn't concerned with the states that may have belonged to
+ * it's calling parent. Only the states relevant to itself or any other
+ * subroutines there in. Once a calling function hands off the state machine to
+ * a subroutine, it needs to respect the simple rule that it doesn't "own" the
+ * state machine anymore, and it's the responsibility of that calling function
+ * to propagate the -EAGAIN back up the call stack. Upon reentry, it is
+ * committed to re-calling that subroutine until it returns something other than
+ * -EAGAIN. Once that subroutine signals completion (by returning anything other
+ * than -EAGAIN), the calling function can resume using the state machine.
+ *
+ *  xfs_attr_set_iter()
+ *              │
+ *              v
+ *   ┌─y─ has an attr fork?
+ *   │          |
+ *   │          n
+ *   │          |
+ *   │          V
+ *   │       add a fork
+ *   │          │
+ *   └──────────┤
+ *              │
+ *              V
+ *   ┌─y─ is shortform?
+ *   │          │
+ *   │          V
+ *   │   xfs_attr_set_fmt
+ *   │          |
+ *   │          V
+ *   │ xfs_attr_try_sf_addname
+ *   │          │
+ *   │          V
+ *   │      had enough ──y──> done
+ *   │        space?
+ *   n          │
+ *   │          n
+ *   │          │
+ *   │          V
+ *   │   transform to leaf
+ *   │          │
+ *   │          V
+ *   │   hold the leaf buffer
+ *   │          │
+ *   │          V
+ *   │     return -EAGAIN
+ *   │      Re-enter in
+ *   │       leaf form
+ *   │
+ *   └─> release leaf buffer
+ *          if needed
+ *              │
+ *              V
+ *   ┌───n── fork has
+ *   │      only 1 blk?
+ *   │          │
+ *   │          y
+ *   │          │
+ *   │          v
+ *   │ xfs_attr_leaf_try_add()
+ *   │          │
+ *   │          v
+ *   │      had enough ──────────────y─────────────┐
+ *   │        space?                               │
+ *   │          │                                  │
+ *   │          n                                  │
+ *   │          │                                  │
+ *   │          v                                  │
+ *   │    return -EAGAIN                           │
+ *   │      re-enter in                            │
+ *   │        node form                            │
+ *   │          │                                  │
+ *   └──────────┤                                  │
+ *              │                                  │
+ *              V                                  │
+ * xfs_attr_node_addname_find_attr                 │
+ *        determines if this                       │
+ *       is create or rename                       │
+ *     find space to store attr                    │
+ *              │                                  │
+ *              v                                  │
+ *     xfs_attr_node_addname                       │
+ *              │                                  │
+ *              v                                  │
+ *   fits in a node leaf? ────n─────┐              │
+ *              │     ^             v              │
+ *              │     │       single leaf node?    │
+ *              │     │         │            │     │
+ *              y     │         y            n     │
+ *              │     │         │            │     │
+ *              v     │         v            v     │
+ *            update  │    grow the leaf  split if │
+ *           hashvals └── return -EAGAIN   needed  │
+ *              │         retry leaf add     │     │
+ *              │           on reentry       │     │
+ *              ├────────────────────────────┘     │
+ *              │                                  │
+ *              v                                  │
+ *         need to alloc                           │
+ *   ┌─y── or flip flag?                           │
+ *   │          │                                  │
+ *   │          n                                  │
+ *   │          │                                  │
+ *   │          v                                  │
+ *   │         done                                │
+ *   │                                             │
+ *   │                                             │
+ *   │         XFS_DAS_FOUND_LBLK <────────────────┘
+ *   │                  │
+ *   │                  V
+ *   │        xfs_attr_leaf_addname()
+ *   │                  │
+ *   │                  v
+ *   │      ┌──first time through?
+ *   │      │          │
+ *   │      │          y
+ *   │      │          │
+ *   │      n          v
+ *   │      │    if we have rmt blks
+ *   │      │    find space for them
+ *   │      │          │
+ *   │      └──────────┤
+ *   │                 │
+ *   │                 v
+ *   │            still have
+ *   │      ┌─n─ blks to alloc? <──┐
+ *   │      │          │           │
+ *   │      │          y           │
+ *   │      │          │           │
+ *   │      │          v           │
+ *   │      │     alloc one blk    │
+ *   │      │     return -EAGAIN ──┘
+ *   │      │    re-enter with one
+ *   │      │    less blk to alloc
+ *   │      │
+ *   │      │
+ *   │      └───> set the rmt
+ *   │               value
+ *   │                 │
+ *   │                 v
+ *   │               was this
+ *   │              a rename? ──n─┐
+ *   │                 │          │
+ *   │                 y          │
+ *   │                 │          │
+ *   │                 v          │
+ *   │           flip incomplete  │
+ *   │               flag         │
+ *   │                 │          │
+ *   │                 v          │
+ *   │         XFS_DAS_FLIP_LFLAG │
+ *   │                 │          │
+ *   │                 v          │
+ *   │          need to remove    │
+ *   │              old bks? ──n──┤
+ *   │                 │          │
+ *   │                 y          │
+ *   │                 │          │
+ *   │                 V          │
+ *   │               remove       │
+ *   │        ┌───> old blks      │
+ *   │        │        │          │
+ *   │ XFS_DAS_RM_LBLK │          │
+ *   │        ^        │          │
+ *   │        │        v          │
+ *   │        └──y── more to      │
+ *   │              remove?       │
+ *   │                 │          │
+ *   │                 n          │
+ *   │                 │          │
+ *   │                 v          │
+ *   │          XFS_DAS_RD_LEAF   │
+ *   │                 │          │
+ *   │                 v          │
+ *   │            remove leaf     │
+ *   │                 │          │
+ *   │                 v          │
+ *   │            shrink to sf    │
+ *   │             if needed      │
+ *   │                 │          │
+ *   │                 v          │
+ *   │                done <──────┘
+ *   │
+ *   └──────> XFS_DAS_FOUND_NBLK
+ *                     │
+ *                     v
+ *       ┌─────n──  need to
+ *       │        alloc blks?
+ *       │             │
+ *       │             y
+ *       │             │
+ *       │             v
+ *       │        find space
+ *       │             │
+ *       │             v
+ *       │  ┌─>XFS_DAS_ALLOC_NODE
+ *       │  │          │
+ *       │  │          v
+ *       │  │      alloc blk
+ *       │  │          │
+ *       │  │          v
+ *       │  └──y── need to alloc
+ *       │         more blocks?
+ *       │             │
+ *       │             n
+ *       │             │
+ *       │             v
+ *       │      set the rmt value
+ *       │             │
+ *       │             v
+ *       │          was this
+ *       └────────> a rename? ──n─┐
+ *                     │          │
+ *                     y          │
+ *                     │          │
+ *                     v          │
+ *               flip incomplete  │
+ *                   flag         │
+ *                     │          │
+ *                     v          │
+ *             XFS_DAS_FLIP_NFLAG │
+ *                     │          │
+ *                     v          │
+ *                 need to        │
+ *               remove blks? ─n──┤
+ *                     │          │
+ *                     y          │
+ *                     │          │
+ *                     v          │
+ *                   remove       │
+ *        ┌────────> old blks     │
+ *        │            │          │
+ *  XFS_DAS_RM_NBLK    │          │
+ *        ^            │          │
+ *        │            v          │
+ *        └──────y── more to      │
+ *                   remove       │
+ *                     │          │
+ *                     n          │
+ *                     │          │
+ *                     v          │
+ *              XFS_DAS_CLR_FLAG  │
+ *                     │          │
+ *                     v          │
+ *                clear flags     │
+ *                     │          │
+ *                     ├──────────┘
+ *                     │
+ *                     v
+ *                   done
  */
 
 /*
@@ -180,12 +436,22 @@ enum xfs_delattr_state {
 	XFS_DAS_RMTBLK,		      /* Removing remote blks */
 	XFS_DAS_RM_NAME,	      /* Remove attr name */
 	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
+	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
+	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
+	XFS_DAS_RD_LEAF,	      /* Read in the new leaf */
+	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
+	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
+	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
+	XFS_DAS_CLR_FLAG,	      /* Clear incomplete flag */
 };
 
 /*
  * Defines for xfs_delattr_context.flags
  */
 #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -193,6 +459,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
 	struct xfs_da_state     *da_state;
 
@@ -220,7 +491,6 @@ int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
-int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 2f3c4cc..fc71f10 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -439,9 +439,9 @@ xfs_attr_rmtval_get(
 
 /*
  * Find a "hole" in the attribute address space large enough for us to drop the
- * new attribute's value into
+ * new attributes value into
  */
-STATIC int
+int
 xfs_attr_rmt_find_hole(
 	struct xfs_da_args	*args)
 {
@@ -468,7 +468,7 @@ xfs_attr_rmt_find_hole(
 	return 0;
 }
 
-STATIC int
+int
 xfs_attr_rmtval_set_value(
 	struct xfs_da_args	*args)
 {
@@ -628,6 +628,69 @@ xfs_attr_rmtval_set(
 }
 
 /*
+ * Find a hole for the attr and store it in the delayed attr context.  This
+ * initializes the context to roll through allocating an attr extent for a
+ * delayed attr operation
+ */
+int
+xfs_attr_rmtval_find_space(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_bmbt_irec		*map = &dac->map;
+	int				error;
+
+	dac->lblkno = 0;
+	dac->blkcnt = 0;
+	args->rmtblkcnt = 0;
+	args->rmtblkno = 0;
+	memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+	error = xfs_attr_rmt_find_hole(args);
+	if (error)
+		return error;
+
+	dac->blkcnt = args->rmtblkcnt;
+	dac->lblkno = args->rmtblkno;
+
+	return 0;
+}
+
+/*
+ * Write one block of the value associated with an attribute into the
+ * out-of-line buffer that we have defined for it. This is similar to a subset
+ * of xfs_attr_rmtval_set, but records the current block to the delayed attr
+ * context, and leaves transaction handling to the caller.
+ */
+int
+xfs_attr_rmtval_set_blk(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_bmbt_irec		*map = &dac->map;
+	int nmap;
+	int error;
+
+	nmap = 1;
+	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
+				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+				map, &nmap);
+	if (error)
+		return error;
+
+	ASSERT(nmap == 1);
+	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+	       (map->br_startblock != HOLESTARTBLOCK));
+
+	/* roll attribute extent map forwards */
+	dac->lblkno += map->br_blockcount;
+	dac->blkcnt -= map->br_blockcount;
+
+	return 0;
+}
+
+/*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
  */
@@ -669,37 +732,6 @@ xfs_attr_rmtval_invalidate(
 }
 
 /*
- * Remove the value associated with an attribute by deleting the
- * out-of-line buffer that it is stored on.
- */
-int
-xfs_attr_rmtval_remove(
-	struct xfs_da_args		*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac  = {
-		.da_args	= args,
-	};
-
-	trace_xfs_attr_rmtval_remove(args);
-
-	/*
-	 * Keep de-allocating extents until the remote-value region is gone.
-	 */
-	do {
-		error = __xfs_attr_rmtval_remove(&dac);
-		if (error && error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-	} while (true);
-
-	return error;
-}
-
-/*
  * Remove the value associated with an attribute by deleting the out-of-line
  * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
  * transaction and re-call the function
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 002fd30..8ad68d5 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -10,9 +10,12 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
 int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3c1c830..96f93a7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1943,7 +1943,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
 
 DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
 DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
-DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
 
 #define DEFINE_DA_EVENT(name) \
 DEFINE_EVENT(xfs_da_class, name, \
-- 
2.7.4

