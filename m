Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58922C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CE0E6117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbhDPJVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhDPJVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99JcU026162
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=a1flEBdq/mOGYIwhzA2ajbkdvOvCvF2o935u7UsJcxE=;
 b=Felxol5EjF+ExhR78id/5kOYi5Xmipi08XWrrB4y0O7lOEp5uK/aeRVIv8KeZD/wxhj4
 CRqeAV60iTeKy9eOnXg/18NsUj5NM0JDLJZim1ghW0AA7fj4ojAkmcTLpGcjOs91So3r
 LlsAXwE/a5Ha4nLHJu7twaXvPNGJayV/ByZPoRewMr0hsZP5yBW1qZSmCDXmW+y4zAje
 XXeh2s1NaX62aX6soRWNXOOE87QAVLTO/3CDtvoVACil8G/cUA6/hbQsHpIvPwyKP/ES
 pTmueCiFe+dCOu98qH8d/mwcdGrokchQ1nVXAcrxqYK5ywiViOgBjhKHGVkAqLMC8teY FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnrheu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99eLX182118
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 37unswy7h9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX0JmWiTCeaeWn8MtrpaQGCY+paTalvCVbHuP9deaB5480L72lEA8FHeGeXoZCoeVtH6DngDlOCP0cJr9r45NVksrruFkrOyLP+lNNlbdlchR5UCUJGxiliA+QQeo7H8pY0eU/Y6fsVOkEZe2aN3FuL8+7zEwNHtmL5K8YhSUNAz4haGQqZCiqwN25VB+8a1BwDV79ngYRGYf/5LuQxbTR3UujmBmBT5W5w3S4WXEhN/NcQ2XDWDK6ZgiGpynTS3oSRIJO/ODMBhM97bEr9n5t6TYATPIzq59S0QAw6ZCGpwMvH5Cg+Wg6ymMvGrFObfeIy4bjwfC2HHhYz7oXy3Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1flEBdq/mOGYIwhzA2ajbkdvOvCvF2o935u7UsJcxE=;
 b=aQHWTiyn0Q3fMfnwjBW+ce99zu7FK4bUb/X7p8HHJSn7INOSBwRPcOd4yvkCo5WGawdUjYFGlHyw48G7YzG6diapfFwlVbwCI7l38c+tOphb7Ul7eJ7M0KL+U4N9iuPpTQTiBuXA0rXytZzKbUt37GqFPEA3mzGHiB1u6G8C9X4Z+Wau7IOgqOJOowt15J/xFdExaBr+OOTT3bJQszrerEitB6r2S6chxWl0IHXIvZTFQFZc/B0J5ZPOOzXdy0dKAA6hzYY+LXYAp2u0TQlBY+Ejd9eHVptGkLK5xFB1DoqJfm17Du7vIsXJX2cgeVJmmj/unRvd7ttLCQv4jL5HNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1flEBdq/mOGYIwhzA2ajbkdvOvCvF2o935u7UsJcxE=;
 b=O87dbbVhu/ebDJqucBv+4xfOt/eaIFWoAlg3hsF3t693+TLaOBuMj3Na2LpCrjeg4Z291yDdpwSSJG/u/W7853WvrJy2u9TdnxLFzBIz1XsIuiTfSbzIBNy7pNPsTV0yWYJGl1Q4dMTxWlnGByLW93/S78C0RLhZfuQsSP5Ae3U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:21:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:21:01 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 11/11] xfs: Add delay ready attr set routines
Date:   Fri, 16 Apr 2021 02:20:45 -0700
Message-Id: <20210416092045.2215-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b250bbc-e8f8-4621-d65c-08d900b8f3c8
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2567734B162B49A416DD70F2954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 03FiDQvI/fUHDbZ4zcmxXfACE4aszEVGGRyHUc+BKGLfYkgF6kbW1xDp2zOLsrFe4piU9lA7uOutrvSWhzSnqBhYJIdTQOmwS5CZ09mS5lKFwHEgbmLjvpCzowMVBBFakelDy3HbJ8hhk+1bGtsX5MgkQ/AFJj2UaH0nlDi4wTH04apSES445dKBaXYW+v+ANed2UU0dPynW6VuYe54Domj6fKmBoXSgUvcc65R2e0pHdOiPXzHQEX+sOow5zFFhcVvQRnEn47jtWiThMPW+1i4e7NMVuKPLDklORsvamMzi9w+tPZEHuJ4TvkXSza85tV3lS9Hb9PjwbAKKPy/+IQp+7sxJWG8KPiDPFoWNX2oF6TLE/Kma7ieEaH2lXoPK2331icRy7ghlur2EKhlmG3h13U8rX8Gp72p1XlmipCUI4l6JMw1o3EbXV+iQoprX9lUgoVljZKq9RaFxMkxTpkjo+5Jj6riRc69wBfwCUdMv+IGdGWKRn5M+wA5kLUIJPKSrPgPs7UPjjcoL2ekul4ZIE9r2MHFMv3zUvnH/V7CvqW0VSwsE6YdbtT43iqbjZ7emaoNPH+VQO1uDZCHpChB5yOmbgv7CxQ8mnN0nl7XGcWR2I7zw3ReBKJfskZ2KC09COXmvhib138Zba+MGUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(30864003)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r8zoWI8IChF+TOg37vunspeu+gfDDWS6amyYwry0ncbvyuLYKQBu4JVAMR4y?=
 =?us-ascii?Q?fBo5/rLH8xxBJqly1LX4CTM48UaVNyij1PXVUr6TbGv01TdYyYIuZeRnJa4S?=
 =?us-ascii?Q?fQiIqFuPifnRrSUljc7U+r1CtTG3s7qXWUt5vcojKeUIDHAY1u8JwWd3IMkV?=
 =?us-ascii?Q?hfnm+I434v8f4Uggwz9ppQaD34Ndtpmg0B0lgVRxaG8SqPfdozuHDcBu/5bZ?=
 =?us-ascii?Q?TQSTApuoOvN5uuCs+/prFDG8msMtXxkY4pwIx8lUhAcUlHpUcKdmo9ol8kO0?=
 =?us-ascii?Q?8saiOp6bH460i1FaGBwV5Bqq8eEA9LfZP0ujyJ3PluctAKtUbAMYU0yx1FoF?=
 =?us-ascii?Q?Yyqbw0UIXgHTF2VPaHYUyh8b5QsNBi/WtwW1tmH4StZwIKzR8ChtIa6wbsLs?=
 =?us-ascii?Q?h2vMDd05/SuHQBtufJGDFcDW5DGeOMq5wr1zJgY/S94oy4v+oXJ1txsdDT0B?=
 =?us-ascii?Q?5WDpsbGf82Kur+W/oDlUOuNJkMTs+Wv0AVNB3aHlDPooRyspOLmHCunyPobx?=
 =?us-ascii?Q?OhjRyB9fwOibQJ9UeB2YDbGb74FlevkYmzeqgFMaJopyKVWgbVViIjO3z2iH?=
 =?us-ascii?Q?fmCObmPRJcyZXpNlVROxLkwA3T70Ax5E8zyVVGs2FskQdE1vZKpLFwrObe2v?=
 =?us-ascii?Q?thIBAuSJOYiRTSjySRT3popdyxaxiSKFzGlHJ+ljC8IOPxjQtLRoV+YiOouU?=
 =?us-ascii?Q?r9Rptuq3TYYNfugR0Hr7g1O6ONQtSoWmBLA+sQ/JRfSrWO6nwADsF6HyrS3r?=
 =?us-ascii?Q?Y94CcCe+lTdKsJz8MibNb7ymlSRbBaG/xJQznLCoi94uLXv87Odkq7LRSJBY?=
 =?us-ascii?Q?gD0J/nCE5L7DorHuuuZ5m6BehScy+24NX9a5RBTxMB0s0p6tAft0VV2hlzKr?=
 =?us-ascii?Q?9zXIpDq7uRklqGQyAxN42uEBR1DBlxTG9ux/5KN40XMUqaeE/M4ZhsfexPFd?=
 =?us-ascii?Q?cdcdbE6diXO+744Iywvrp8rwUBOxSBnxVJEAS7gkyjpx3dW/Q97/CnizJYGN?=
 =?us-ascii?Q?zatBVeRnYLLXvcpnePC3R8J4n162CNvVmTBKJJM/0+9IkKvlGHheFC96GNbo?=
 =?us-ascii?Q?yo5HEIgKUQ3z95NEWyZSxOXH32N+IjdHnjM92sZUiwcjZF9IjbQGAI6BRDH3?=
 =?us-ascii?Q?fBN0pO83pT4j6ZPBWM3s3qzhnZDU0I8YgjMDtO8z+9Ax/IdtjX9Q3871c9AP?=
 =?us-ascii?Q?J7Gw1F9Q4QjR2aNo+HNmPE/S1z1Hzzl4JevB++GXjuGU+22I5KxDS6lMr0ht?=
 =?us-ascii?Q?2lx+f/Ac0tlec4ODQLn9A7X4NBIiMZo6TIY9hWTDoDmnk1I+yv5l/tlFDb8L?=
 =?us-ascii?Q?nIFWUTKIyvjHWJioQzQAe81T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b250bbc-e8f8-4621-d65c-08d900b8f3c8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:01.5734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pRbm5hjIx1vnmuUDwfR+Clbyox/1jTfEsyX1bkpKdMQHtCpputylI/tWnuLJqqjNnsDdimf0ayVgcT7qYnRZvxhkTYCCcGc5He4J7dkxkLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: enHyKDriSTV2_5Yw7FjHolH6nwyiPiNc
X-Proofpoint-GUID: enHyKDriSTV2_5Yw7FjHolH6nwyiPiNc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
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
---
 fs/xfs/libxfs/xfs_attr.c        | 445 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 272 +++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr_remote.c | 100 ++++++---
 fs/xfs/libxfs/xfs_attr_remote.h |   5 +-
 fs/xfs/xfs_trace.h              |   1 -
 5 files changed, 613 insertions(+), 210 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0bea8dd..302e44e 100644
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
@@ -224,7 +225,7 @@ xfs_attr_is_shortform(
  * Checks to see if a delayed attribute transaction should be rolled.  If so,
  * transaction is finished or rolled as needed.
  */
-int
+STATIC int
 xfs_attr_trans_roll(
 	struct xfs_delattr_context	*dac)
 {
@@ -245,29 +246,58 @@ xfs_attr_trans_roll(
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
 
@@ -276,94 +306,130 @@ xfs_attr_set_fmt(
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
+		if (xfs_attr_is_shortform(dp))
+			return xfs_attr_set_fmt(dac, leaf_bp);
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC) {
-			/*
-			 * Promote the attribute list to the Btree format.
-			 */
-			error = xfs_attr3_leaf_to_node(args);
-			if (error)
+		/*
+		 * After a shortform to leaf conversion, we need to hold the
+		 * leaf and cycle out the transaction.  When we get back,
+		 * we need to release the leaf to release the hold on the leaf
+		 * buffer.
+		 */
+		if (*leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, *leaf_bp);
+			*leaf_bp = NULL;
+		}
+
+		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			if (error == -ENOSPC) {
+				/*
+				 * Promote the attribute list to the Btree
+				 * format.
+				 */
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
+			return -EAGAIN;
+
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
+			return -EAGAIN;
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
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+		if (dac->blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+
+			return -EAGAIN;
 		}
 
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+
 		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 			/*
 			 * Added a "remote" value, just clear the incomplete
@@ -392,26 +458,35 @@ xfs_attr_set_args(
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
+
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_LBLK;
+
+		/* fallthrough */
+	case XFS_DAS_RM_LBLK:
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
 		 * Read in the block containing the "old" attr, then remove the
 		 * "old" attr from that block (neat, huh!)
@@ -432,89 +507,113 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
-	}
-node:
 
+	case XFS_DAS_FOUND_NBLK:
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			/*
+			 * Open coded xfs_attr_rmtval_set without trans
+			 * handling
+			 */
+			error = xfs_attr_rmtval_find_space(dac);
+			if (error)
+				return error;
 
-	do {
-		error = xfs_attr_node_addname_find_attr(args, &state);
-		if (error)
-			return error;
-		error = xfs_attr_node_addname(args, state);
-	} while (error == -EAGAIN);
-	if (error)
-		return error;
+			/*
+			 * Roll through the "value", allocating blocks on disk
+			 * as required.  Set the state in case of -EAGAIN return
+			 * code
+			 */
+			dac->dela_state = XFS_DAS_ALLOC_NODE;
+		}
 
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
+		/* fallthrough */
+	case XFS_DAS_ALLOC_NODE:
+		if (args->rmtblkno > 0) {
+			if (dac->blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(dac);
+				if (error)
+					return error;
 
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
+				return -EAGAIN;
+			}
+
+			error = xfs_attr_rmtval_set_value(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete
+			 * flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+			goto out;
+		}
 
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 		/*
-		 * Added a "remote" value, just clear the incomplete flag.
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
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
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			goto out;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series
+		 */
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
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_NBLK;
+
+		/* fallthrough */
+	case XFS_DAS_RM_NBLK:
+		if (args->rmtblkno) {
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error)
+				return error;
 
-	error = xfs_attr_node_addname_clear_incomplete(args);
+			dac->dela_state = XFS_DAS_CLR_FLAG;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_CLR_FLAG:
+		error = xfs_attr_node_addname_clear_incomplete(dac);
+	default:
+		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		break;
+	}
 out:
 	return error;
-
 }
 
+
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
@@ -980,18 +1079,18 @@ xfs_attr_node_hasname(
 
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
@@ -1017,8 +1116,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (*state)
-		xfs_da_state_free(*state);
+	if (dac->da_state)
+		xfs_da_state_free(dac->da_state);
 	return retval;
 }
 
@@ -1031,19 +1130,23 @@ xfs_attr_node_addname_find_attr(
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
 
@@ -1060,18 +1163,15 @@ xfs_attr_node_addname(
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
 
@@ -1084,9 +1184,7 @@ xfs_attr_node_addname(
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
@@ -1103,8 +1201,9 @@ xfs_attr_node_addname(
 
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
index 28fe719..c0b94b5 100644
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
 	XFS_DAS_CLNUP,		      /* Clean up phase */
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
 
@@ -219,7 +490,6 @@ int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
-int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 908521e7..fc71f10 100644
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
-		if (error != -EAGAIN)
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

