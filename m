Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E490C4708B
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D563610FC
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhEYT5L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52470 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhEYT5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnA0B162043
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7KrpfNIpGkq21hxTRQClmWcIcdcnniPh/z+cCZkGWQM=;
 b=ufwCkkyxixepfr5FbTbiwJQH7lecPA3UKQK9h3Q+avvOB3eMOOwnLuqZYd+ZHbWy9fKq
 L9FlHiL5LRfNH+4sS1033T26p/YuQrVfU0kn5fkU+KUAHoCzZWznomDqn36D5RfNEoqE
 AHZf9u1O4r75AUOnCuwjWeeEss91Z6nPk1Vjfu98d4xy7GNzqOedNXoO0hDR47QfEvV3
 08b15cIoVu/F6wqNLC227WI7sQShBJ4yRhtpycjDJEsnxELa7iakbMVLWaPQ2EGQr/T1
 5MF5rix6UMHANOEoSPJX7iRc5OvSmktsQpUlEDHQacxA/RqoQRDnRiHU4Gwy19YUEJKG 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38rne42qcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoDil188864
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3020.oracle.com with ESMTP id 38qbqsjk14-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akCQFwwxsUlQgxiinmbwkKCWoUeSjTPPqEIZVog2kjTvThjR7WQ/fUfdKmTMiQOJsthFjJk7wnlaRu2/IjFIssKF41+SRozPKslp6pTzYidcZCXxjfrCXYr9FgQMEgKNnHycNT5fAcpRPNRgVj0nsqCxke4E0/0rYBOeXjQ7f0Pe1hOLXqbMC+LtGHRpB3BdYh04KqyXeIDKLojk0f1G5s5tCjKlk76Fzi4hqvFB5SgnS8R/StWqPMHjo46JqCptWpRxK2z6YTATz4LE2Fso/KTlmsSpk/hMSSc7+vLornm4y1xCj0yPx7baEHLBubpT49xT4NacAgyRD4VzbgTs/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KrpfNIpGkq21hxTRQClmWcIcdcnniPh/z+cCZkGWQM=;
 b=c0QN/yhT1nDgTEA8gWlrwZF4l7lw4wTfKVtOoh1TP2iNIAfYBX6C683Z2GqvZyLMvYTOuuDz5ugW6xF5mpluJvhjMee+TQT7uAD0+ZULMv5yYyM8EC2i2/NYp8zT4ONNjftnROocI7MjLG2IxmBDgs3w+0cfRmY2YT0VmpfWjYcANcoUi6tzU1DelFov0a9TZOliTcw3JgIxNn0HXv+Ew4hxIUXYK6FxLcmY7r3r1Jue3Z6iKJY9CJfk59PnQYauAGyuGv6LaxY0IlUe7qXMNryGsEh7iuwdPtHsYiSzWgQyXnprHcGff+3DJtZrXo2HUNNm6/mNQ3O3jo/kQ4EtXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KrpfNIpGkq21hxTRQClmWcIcdcnniPh/z+cCZkGWQM=;
 b=hEVWAebAtDRY+93/8tb+7VVka1RXh+eTBcBl/zLPj0HHnHKDxQEGAlJj72H2oVGI+4ag9yNv2dinZYVaEdTveefQfUkAY5ZsYhbwg243j6ZE5ZhdlN1c4DOIoe2RVzcdylY8RTghkDpNZKvi+V3qGOfPbdqae24RBLjqioLC2Hw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 19:55:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 14/14] xfs: Make attr name schemes consistent
Date:   Tue, 25 May 2021 12:55:04 -0700
Message-Id: <20210525195504.7332-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d9a1d93-68d4-45f5-0c8e-08d91fb70d50
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4544:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4544B689347364806CAA1FE095259@SJ0PR10MB4544.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49CM+Ddz4YaFT1JKWyR+AIKllv3xSlQsGtghVqoMjxl5cBpKBmrfeaBQFjJNhIMJdNn3Zq++k7++/QgDSipm4AipJ1e6g3EJjS383zyiFpCvn3vPGy62JDmKcZ9eixoFUefZi6NcDgYnu/nsgBwiNg0IzM6acN/FB6RL0NIek2Kc90A/rWyMxZqW8faZ1bZiSuml8fXgOserNZUycyfWKKO9TOKxNLJLZU3Et404U2UJdTtPf9NTBKF6DB3gTF9FZc4S/FVEstnqDxYphXeASEFvA6qWXS1S31i0D2T6zc2ZfsjqRupQMxZHSMpES4qzpAL9qrzWABEa12CNs2RIclGrO4aZX3VfsS1UAGAIfHL3EVxi4USO6QtONzNDV8j3ReD8xG5QE3y/xS98IkQx0l9f9mi6Z5NcszW3B8o9Ar/GjV0P3XPUgvgCo3kzXcmMRSpGdv1kJzN5C05k9iN/ammEwrRGiGjRJ4KL+Mwp7b/iHXvybiU/nvpAaDBEnxSNd04unphr1TGaUu5AeKAxIaYR8lF1uiaiFGiXkLuGtpS9jFuWyZNv9SalJAcjfZSzG397pX87Dnnu4O5Dhwi3kxamfuPJsndvrB1Zw4N1G1e4vgZu1J5rG3Fuo/U6GM4KaYAvpVCvg/hsxLRS5hGFxk2kyG6qokxJgUUC/Sl6eCQ7OFWfQ52Jvk2PZ/TbBbCF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(396003)(136003)(376002)(2616005)(52116002)(5660300002)(956004)(478600001)(186003)(83380400001)(6486002)(66476007)(36756003)(2906002)(44832011)(38350700002)(66556008)(66946007)(26005)(6916009)(86362001)(38100700002)(1076003)(16526019)(6506007)(6666004)(8676002)(8936002)(6512007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Bqr/8zZU6JYF2tPggO6anAfCePFCOYMqMLlIIRBdq51B7vuLptjnPVksZIHU?=
 =?us-ascii?Q?EWBpKaPH8L+K4yRjjmucLQzepRt+RkhOLh97q9p4942v/HJFPNAjPCBtXWTV?=
 =?us-ascii?Q?wxrldf4m2/cl6LbJjG4B7N783pfGJ/1xHd3Uv/s32obPhxeIakuQoQF6y8Z0?=
 =?us-ascii?Q?ynzuwHgNeEb8oMD8CdeqeKdwNcdTXrOlkxsUH/JErzL6hnz4kWIv6ioZs8Yt?=
 =?us-ascii?Q?3fxs7rDWNHiHHHmckl3N2nao956lXDLvfHUIkTPs3yJDl9qleFe7Lj1AGJ6q?=
 =?us-ascii?Q?ligKAbxGSzOLlqHmHpc61y4qZQhI28aknOaS4Izx6cWmvicKvnKpCQsLq5MU?=
 =?us-ascii?Q?EY1sc/qeSM9m7rHvv6Vfz4BBsOtOBLOLczEWFVukqb9s9xGtXX6vums8CerI?=
 =?us-ascii?Q?tK/Q1HbOfNRmO8CuzmXQ/vk1UeQ4SfnTjtY0nLsaKGuQwYQiefZcylrcVIF/?=
 =?us-ascii?Q?qcBpYLDE6HEnkaJtagJWj5uF7b2gRaYwnA7JnNq+YNfjbjZJBU17d4ORh6Yf?=
 =?us-ascii?Q?ieiOQw/u1n1BkZOAGDwguJ+29yqLnW5Xp2rs+iuAhiF4YjI3ydX9BX1lDY81?=
 =?us-ascii?Q?CAlD+qkInjqF37vPm+BA7ecNsAqWy9jP00cQKET/qcBJKeEMuNLkPwxLeupW?=
 =?us-ascii?Q?O07rnBTMHpvEkinl4l0qbayqEWEexF340GFSl5U5KQ+1LEliHkGvcKqTwU+N?=
 =?us-ascii?Q?clbmu01nsw+cxbfzjPgD9CFRjtRsWcnjgIcK8ChO0ixlr+6oqze1wKXvrI2E?=
 =?us-ascii?Q?U0eBntC1blrgUgn8O8jHbd1t6L0Atj5O1qTI3bQcC7mQrJovJgFS/SVrWhuQ?=
 =?us-ascii?Q?EgFVTcQoFqJp/UG2JY0AP2L8QpKOquPrp3UtjVRMbSh6e/uqX3ujcwAgjRR5?=
 =?us-ascii?Q?JHkAawDAKOJMLF8qUdSd62/aPcqnCOHw99K7ZdpQYfylI2ZTIYjKFKqaIHHk?=
 =?us-ascii?Q?0HledTUdFn0o3UgeX5QXSOsYVDPj57goXzRM5ccgHtur+blOzbdMb/f7urOm?=
 =?us-ascii?Q?e8/8m5kyGsMpTIwbviQyHF/PB+mhDOU1icbGnlr2mlFRyIpjE6xztSysAhI5?=
 =?us-ascii?Q?gLQdbVMGwImkJJ5uZWdMI54ZPjzChPjZdpYbBvBmSJtwnaCPktbsZWBKMi62?=
 =?us-ascii?Q?5NeIHndU6ah0Xl3Q7utiamHHemfwXJ2CPjXz8sHwWGa0g0ff6C7cx6zwrOfu?=
 =?us-ascii?Q?4KXuPIjoBf3p9EEC9xz786hUbAxx9KR58/Y/1y3dE18CfzQq6jbmOcrJikb5?=
 =?us-ascii?Q?vtq25+0zeviwt4FeUlS4LZyy7YIJWewsVuWUO9Ci82ZdilIMMSM2CqlAGmEA?=
 =?us-ascii?Q?FKH7hNMvT2ffNor3DW2Ae2IB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9a1d93-68d4-45f5-0c8e-08d91fb70d50
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:31.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yG6g88Mb5ojLMPbMSMaCvi1RqKLYxrlD89JO+Wt7phEUolGyQRcHD+8aS2DMBXLkm94XaC5wcFLBxw0aDTHWjeFXZu04IGYGoASXCFEdxpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-ORIG-GUID: qe6k-o7eQGOe4dEc4ff7lflChUqPcz6l
X-Proofpoint-GUID: qe6k-o7eQGOe4dEc4ff7lflChUqPcz6l
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch renames the following functions to make the nameing scheme more consistent:
xfs_attr_shortform_remove -> xfs_attr_sf_removename
xfs_attr_node_remove_name -> xfs_attr_node_removename
xfs_attr_set_fmt -> xfs_attr_sf_addname

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 18 +++++++++---------
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7294a2e..20b1e3c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -63,8 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 			     struct xfs_buf **leaf_bp);
-STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
-				     struct xfs_da_state *state);
+STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
+				    struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -298,7 +298,7 @@ xfs_attr_set_args(
 }
 
 STATIC int
-xfs_attr_set_fmt(
+xfs_attr_sf_addname(
 	struct xfs_delattr_context	*dac,
 	struct xfs_buf			**leaf_bp)
 {
@@ -367,7 +367,7 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac, leaf_bp);
+			return xfs_attr_sf_addname(dac, leaf_bp);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -839,7 +839,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
 			return retval;
-		retval = xfs_attr_shortform_remove(args);
+		retval = xfs_attr_sf_removename(args);
 		if (retval)
 			return retval;
 		/*
@@ -1222,7 +1222,7 @@ xfs_attr_node_addname_clear_incomplete(
 	if (error)
 		goto out;
 
-	error = xfs_attr_node_remove_name(args, state);
+	error = xfs_attr_node_removename(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
@@ -1338,7 +1338,7 @@ int xfs_attr_node_removename_setup(
 }
 
 STATIC int
-xfs_attr_node_remove_name(
+xfs_attr_node_removename(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
@@ -1389,7 +1389,7 @@ xfs_attr_remove_iter(
 		 * thus state transitions. Call the right helper and return.
 		 */
 		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-			return xfs_attr_shortform_remove(args);
+			return xfs_attr_sf_removename(args);
 
 		if (xfs_attr_is_leaf(dp))
 			return xfs_attr_leaf_removename(args);
@@ -1442,7 +1442,7 @@ xfs_attr_remove_iter(
 
 		/* fallthrough */
 	case XFS_DAS_RM_NAME:
-		retval = xfs_attr_node_remove_name(args, state);
+		retval = xfs_attr_node_removename(args, state);
 
 		/*
 		 * Check to see if the tree needs to be collapsed. If so, roll
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d97de20..5a3d261 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -773,7 +773,7 @@ xfs_attr_fork_remove(
  * Remove an attribute from the shortform attribute list structure.
  */
 int
-xfs_attr_shortform_remove(
+xfs_attr_sf_removename(
 	struct xfs_da_args		*args)
 {
 	struct xfs_attr_shortform	*sf;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 9b1c59f..efa757f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -51,7 +51,7 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 			struct xfs_buf **leaf_bp);
-int	xfs_attr_shortform_remove(struct xfs_da_args *args);
+int	xfs_attr_sf_removename(struct xfs_da_args *args);
 int	xfs_attr_sf_findname(struct xfs_da_args *args,
 			     struct xfs_attr_sf_entry **sfep,
 			     unsigned int *basep);
-- 
2.7.4

