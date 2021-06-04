Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05173C4743C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2984613FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFDXod (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51952 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFDXoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Ne12H078362
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=szvJfbvwmwL0QODj5H3eGmNFZ2raelHNU9VAKOWXOIU=;
 b=IRAvSvsdTqeSEmqtSafUAHry7MB3QslOUTHIvPUwUyQCBYsBF2CALbSboHN3KvPZ3R7T
 QBsmY+bSgTfrbLCL5lBHguTxkuVyTPhpSPc/UYa2kUS/BRYXzIJDnc/vZe8jZiViatEK
 7GNH4UX77htgNTGHtr/Z7u9a9Qg4WNCH/5KdnkTqeH4VmXcBdX4VxQsTVsnX6tTro2BQ
 c74Qa3mW2FsY4cWuf+63oNOU0q9rjWicq89wJg+tD5EJ7Li07l/TIs6NPW1dQlYjo36/
 396D+i0V90x/21pONPEHxk2CiVuZFoA1JbcXNDDj0kaQpBhpz1FK0BXrBQcUBOp0hWlp PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38ud1sq0cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Nde0V039038
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 38xyn50rp7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l71qiBc1V3XN0z0HrCvmiNSOWtS2guo7QW2I5kHz7F6vjLuxrCQ3jqdCRvPm3wX+TWL4Koev4CS/VuCRvQT9XRuGaRKASmmyOONhAatRnP98d9MrBNKizB4/5cGkns2L83zzGwLoidHdSSceHshE1GlAsn9Log5B+BQs9V3eK6u3P6w1F6j4hA1GuxcPfUP7shqfWRJH+TlQTXim5EPo4R8gWhkI6pJcWtvsxDro5668e6E0V0H90aMRM8h+OMFAO0tvoVuJsWMfoHyFKgrQ+/GPF7GmUoL6Q8WdksNuamwZH7yuDGGBTlaKHz2HSjgD5X4vZaF+Ab1lzmoTTH+2YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szvJfbvwmwL0QODj5H3eGmNFZ2raelHNU9VAKOWXOIU=;
 b=lmufP/RkPLmFVsDOeNkGQPJWJPMcMlj/rw4ofsXbyEaJcMJDCGh9rX6o3sSWECBZLD7ITG5/bLDCh/RBbtuMfTEh0URPfnpOsGuz5GcbD6eMM8zAa6prEQRrUuy4c8qBOJ/VeckNQVnoejFmTJZ5yY7vVQdfG/8BFkvUIDf5u/xSkPs1s6MKbBe42cUqS8ue7emeyfDIpNjEsXg6irDKRXrUJmI5URrs/OV+YSopypvsey5CgIoH2dHT6gbx6MGb+ux8IDVjs2Ukl9jq3i/06jKSrAEuYa9X2iaw893297McSRGWMgdsp1sPpjsgWTV5yZBcFG39MGo+sI/8UCFtuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szvJfbvwmwL0QODj5H3eGmNFZ2raelHNU9VAKOWXOIU=;
 b=XYxQpAdrwx7pKp1ISHDCkhd9iy9m2TUP+Xlo8itTwXG1xlhgF0OQO4C3oaaFTwfY3uA13X4fzUhPChq9PkfXA8UEaekdp098zZn/0WipLw2SAVY4UfhhxppTJpaNMpUGZM2AGFYVqPROLNAq3gtOAd8OjpBRIBU83Zk+YipZlJY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 23:42:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 05/14] xfs: Add helper xfs_attr_node_addname_find_attr
Date:   Fri,  4 Jun 2021 16:41:57 -0700
Message-Id: <20210604234206.31683-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210604234206.31683-1-allison.henderson@oracle.com>
References: <20210604234206.31683-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR07CA0095.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3b95c53-d2fb-475a-291a-08d927b2721b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5485A94FE798A57A9C563D44953B9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxKScocziUz8oF003aaKqrTX01nXm8eGgvTCZeZb8AwRzau7iL25nnR7zsohfkirj4j7/U6nl6tk9po+Ih89CixKU+eMhjUNywrvR8vVlZNLO8tCh4xQLY9+uj5PXpSlgvuVdmVjVtD78X5wjg7dFtODTzkQ7mnKGhlIF5DkY4WTOMZf6lw1xMezk+w50x3vsD8iodZHk4PEuu6P1VTjg3VTJmecuVPJKB50wTzi8rC3AtAGvFv8EDQN9rPYeoP6F1B+/804qMJPM9ZdgBEUjof4jXJyskGvW9Dmlm8wiZt/I8x7czqBiKt+y2K+5LF+FK3N888pdgS7Y2BcETI7tKHxUT8ibk2RxtKqofDKHTN6J5ZD5g/eQ5azSHw33xcgiJPNCR9pPOvgRSMIzHG76hzmoWvp3874eb9yrIFBl9Rcqeox6bkKoUoJIxfm1YKGbdt25gNYhWzLWIxnM26+WzFDblQhrVB3r/o20ChGEHYmTQzOJMkakcUIMQitsFrkLRhZ1IO7UiFs3Bq/NQRi35NL6zPtWauiZ3gKVrZ5F8SENGvory1FWQQhDi76iEolymsRLoUWZd2Kqc1XNUantXKl6aqWTKPATU6f01gHDswyxvmSAwA7SiDNVSmrDiN+tBUnD6QYcz5heGxEe2AZYiIvMyXTs77AIOS5JuiZw5SflyOZ5iiEUU7GmmtuEnDf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39850400004)(2616005)(66476007)(66556008)(2906002)(66946007)(5660300002)(8676002)(956004)(316002)(186003)(16526019)(6916009)(86362001)(38100700002)(478600001)(38350700002)(8936002)(6666004)(36756003)(26005)(6512007)(1076003)(44832011)(83380400001)(6506007)(52116002)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QB4P/+bExif/mB1DvBB+5mmXXqIcGdJMyscxUwibrg/fkaMIonwGrytESKGo?=
 =?us-ascii?Q?p2NVXBe03I8Na5Wz+0GhCWT1WuuamPD3AwmMUCmMLchXe3qxaRpO/S8owW0/?=
 =?us-ascii?Q?eUWBxtHu9kUmRkhwAqZKsI6EabmyDFLliPDqgNcSyZu6TbFrFXdKt0qyW4Xr?=
 =?us-ascii?Q?bWaijkoIvKzDmJj4S3i9ta+aV7wkPGtOnAE5+S3o7ElOQvaQd8frxd+Eu54P?=
 =?us-ascii?Q?YWi7hODx1JQZ8iaDyAoiVxImDmQ1YROYGdBc8IgyWnevBR+Jm2+LpYQcqqhW?=
 =?us-ascii?Q?+cnIcqsvi0k4hKBPWsQho5nnBmB/2dpt6uNoagXhrTzfB0HnPRF16mwsqt1m?=
 =?us-ascii?Q?41gYIhBqhN1DGCV3GTpUBcvwQpu5zj8P/dGxgaG12pCv5EIUXSYBH0CvT6E8?=
 =?us-ascii?Q?w2fbToPHfImMrpQbZy20JBvLtLyRQSXcm4cviSD+naDRarj+vLBl9N8hGMvk?=
 =?us-ascii?Q?XaRp9jfT9rE4cSKSVeajpCMyEhZj7ZxibLDW/Nt/vZ/UeDC595QcBIkR+lKn?=
 =?us-ascii?Q?QuZ4iXTV6iuoS8/mgWnzgAOKmuex9/4IenuCZzOMgTzhhpAUGT3Qms69UqX/?=
 =?us-ascii?Q?E5uJ7xtmmTtWhcEy20VUgQGpGEp+h+U21zGfN69hjaTFyTJXrDPnqpLLXgba?=
 =?us-ascii?Q?jWdUmLpF33oQVFqdVmgdoxBfCpGGDlC+7rmmVj1NyG8dkrh7d6eiP3/bDrGK?=
 =?us-ascii?Q?CJ2pE53vtPYhHA5wCHKrP+yNqxas/M8e4jICqbgMYx+7Kslxa4qFC5jqkA8R?=
 =?us-ascii?Q?jbzLJwZuYHAI4Zf+8hJwhf9lbJOobMDqbIyP8gPQ0liuxeaC6LxV3RckEAUK?=
 =?us-ascii?Q?NVkL9bCY8Tz+6kejnEmEnzIPIWtGUmmwv5vKm9HI945NCWZXKo4mYnGvKgz+?=
 =?us-ascii?Q?iu9YFBCxt1+ccBkc5bmL0ryv6YkB0waqC9J/K88LeyYG6Ii4I8NG6IPaNfXE?=
 =?us-ascii?Q?7N6EACWaF547XNJfLaMuJhmJjUC1LIfSA9KKT9CeKlYDncemUnHby7ql0xBL?=
 =?us-ascii?Q?FqghUmCdYQryr3PF91MRItd36jx7SwiXfnD90RWBSeKdn4BugTLd7m/DUChV?=
 =?us-ascii?Q?eoNd2VDVth5ZNVguCvMvRyMQ+D5N5Tt7sIq1logckA/QAm7KxjLvJ2P6KSLp?=
 =?us-ascii?Q?tjeEJx/K1+bh1DUC9tpn8dzZ0pN4FSR63myC+Ka8uc2U2LlmBB/4R1QvW3wl?=
 =?us-ascii?Q?GXMoodTcvF6WkecR76P528xdPyW+p9m3LGNKJy3d8A9ZqStkxzRJe8QSgvw0?=
 =?us-ascii?Q?EjTgu/Du6P5YcmgwP42vGWhb5EA7Ohaf5lEOhVVZBmVqzJKkZlIvqYSDp12T?=
 =?us-ascii?Q?24CZ5gTTQrgYMiBarnxOOZ7s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b95c53-d2fb-475a-291a-08d927b2721b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:42.3323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRP+A/bmrBErmDd8+MBSWv1qlMAq7Vqhiyw2JWFVhPg1zfOLBqUPvLWzeECgdJRCf+mw13QPM5LOLzu51fV+MtY5DHjLvX34kJcTC+UeNrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=986 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040162
X-Proofpoint-ORIG-GUID: GO6vTeNN02GJ2lSK1gnxwsMxPYLiqtJw
X-Proofpoint-GUID: GO6vTeNN02GJ2lSK1gnxwsMxPYLiqtJw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040162
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with an EAGAIN return code driven by a loop in the calling
function.  This looks odd now, but will clean up nicly once we introduce
the state machine.  It will also enable hoisting the last state out of
xfs_attr_node_addname with out having to plumb in a "done" parameter to
know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 87 ++++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ad44d77..5f56b05 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
+				 struct xfs_da_state *state);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -287,6 +290,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -332,7 +336,14 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	return xfs_attr_node_addname(args);
+	do {
+		error = xfs_attr_node_addname_find_attr(args, &state);
+		if (error)
+			return error;
+		error = xfs_attr_node_addname(args, state);
+	} while (error == -EAGAIN);
+
+	return error;
 }
 
 /*
@@ -896,48 +907,26 @@ xfs_attr_node_hasname(
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
 
-/*
- * Add a name to a Btree-format attribute list.
- *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
- *
- * "Remote" attribute values confuse the issue and atomic rename operations
- * add a whole extra layer of confusion on top of that.
- */
 STATIC int
-xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+xfs_attr_node_addname_find_attr(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     **state)
 {
-	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			retval, error;
-
-	trace_xfs_attr_node_addname(args);
+	int			retval;
 
 	/*
-	 * Fill in bucket of arguments/results/context to carry around.
-	 */
-	dp = args->dp;
-restart:
-	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = 0;
-	retval = xfs_attr_node_hasname(args, &state);
+	retval = xfs_attr_node_hasname(args, state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto out;
+		goto error;
 
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto out;
+		goto error;
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
-			goto out;
+			goto error;
 
 		trace_xfs_attr_node_replace(args);
 
@@ -955,6 +944,38 @@ xfs_attr_node_addname(
 		args->rmtvaluelen = 0;
 	}
 
+	return 0;
+error:
+	if (*state)
+		xfs_da_state_free(*state);
+	return retval;
+}
+
+/*
+ * Add a name to a Btree-format attribute list.
+ *
+ * This will involve walking down the Btree, and may involve splitting
+ * leaf nodes and even splitting intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * "Remote" attribute values confuse the issue and atomic rename operations
+ * add a whole extra layer of confusion on top of that.
+ */
+STATIC int
+xfs_attr_node_addname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	struct xfs_inode	*dp;
+	int			retval, error;
+
+	trace_xfs_attr_node_addname(args);
+
+	dp = args->dp;
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
 	retval = xfs_attr3_leaf_add(blk->bp, state->args);
 	if (retval == -ENOSPC) {
 		if (state->path.active == 1) {
@@ -980,7 +1001,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

