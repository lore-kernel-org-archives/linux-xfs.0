Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AE2C47089
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB8661358
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhEYT5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhEYT5B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnntH184984
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=QAS76PG8gCV+t1DEcGzPORiIJl8CPTcLNTqF2xo+fyQ=;
 b=E41Z2L1D1wA623L8ed/Pa26DbLVxxlQsjKg6Frzdg4N7EOtGqK4fKGFJ8mZWqGzIvkrr
 NkJAsS5i1p+hfeNASVE9FxslyTzRu1h4vNhfNORFhPGccsEAr7q6QFC88453PjsSolAQ
 BzNQSrxCANPGHD9b2QOfcVTLyKk+HkyScQdNMiTJQlx2Qbw+oARKL+6b8XcQLwh/1ukS
 hzgVGdBfjHalkAcDgQKMkeRipsndhEjJ1A732d7OSWttQnPTDo1xfEEVCulPbeI6orFf
 nls9mdE0mnjzA4+MUyvAyoBnoyn+n6i6WUc1m5z0QX28rzZFRzKbcTUI7zU+XBgGUa8e Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ptkp736j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJtH9g101715
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3030.oracle.com with ESMTP id 38pq2uhp2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i49cyQcqXJXkPrO5k4RWapL7OAhcdBNmR3A0j3mhf9f0qZ1hcME/h4d4FinunucZDqBUwaLYj5SqlUJpOU6rrR+aVMppbSpvc4BF4iWDecX5R43M7zrgPmCWK4snpHL64MU895wwS6Pyb8dk3dOv2ZIkz3YpVbJLQC1tfftSi23rHl8UryQ8Aw0Cgykang4WswAwP5sHIBxDoTLxMaJTmhP6NPxPYqXSkAY4rxBJc6c+M6LWZjRwHGPZPCqmD9B9yvoi51SVuxFFjL6hTR0e2A+yOWvqobamDDOMnKwsNXn9csijaB/dowLSEm72X3bGHtE1k8WQWtMxb5/I3TD9MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAS76PG8gCV+t1DEcGzPORiIJl8CPTcLNTqF2xo+fyQ=;
 b=nQkC/iDf8+xJp7Wb4aHvuF8w9OB3SVLoIqlafZ3zE8SjiRcOnLnj6QtMXcko41PbBfCm4BQJguboStv7pBExq3m7wOE0+y0uzO5tKGsTHidzvROmc2HC6bBRwa8Av1vgXaYQkyXnWbhm88vxFvprX9OOQSywUbRZlTOm8wVfKhFmdAGUtphwIa3O7jhXQxwzlk/tWyuQxzpZAVd1+p5KM4QEPo7RBOC/eq4lXIjfS9Fg+TN0fNbnUOvxpK5mqE34YuX3V6NfD/mYXExgEszbJFQ6a8pPgt8b2I+8OC9znnq6b3NiHxyE9nIIT8GjBgdLU0UIfNE7YtXhWVsv29jD6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAS76PG8gCV+t1DEcGzPORiIJl8CPTcLNTqF2xo+fyQ=;
 b=gYSfSLfarvGCYcjXQoAJY0uJiNsggvgVlCDfnt2ZDfTwH28BwGBQtL/xv5AeI4wnQLIce7h9uk68vhQsJQp2xDNR46PlGgH1DHtHUrzN2e921rWLk0t3YS8iK0oZ+bsWEsDeeyQt4sT7hFgAtma/CCpo70/EEpWJrfhisoBoZmM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4478.namprd10.prod.outlook.com (2603:10b6:a03:2d4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 19:55:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 04/14] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Tue, 25 May 2021 12:54:54 -0700
Message-Id: <20210525195504.7332-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da052f18-a572-4b7d-686d-08d91fb70b1d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4478:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44780B7249E6D44946F7C0F195259@SJ0PR10MB4478.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: obnHq31uOX+gvzAxDH5WXuioh2U+kERLJZynaGS6MZydmnYQWFGTWdERyRIqMkpkMjaRsiXVE4tNMVRcvlIaLUxMSuveX4kFwEmxJvf1KIVAxwVLAFMuoMIYXRV4UHuIzXqTy1kMbib9o6CT2/kT4i0RmrG7S3bpkophfnItla37r2/EJW0PaI0z/AKp37/MlhYYaQ4N7B8oKDezi7T7AtaT2BJal1kvxXtDeqAdyJjff5w4vG8UQD5AWn3pi2BL63wJ2YxWEL4SKZUGhrUu5xaGDmFF4kyBA0gLoY4hagx7W1Th0AFp1mxKPX4iKRQ1xgmzLm5yGx6fiArnxqPAAoP67IHCciuMEag2yyv/5SN1IzaTHW14JgiTnWP9FtrwKotqkPwdUjYMJmpFr173qNMBrfnYCOTPhuaNAwtqJpNKX5M/jvtOYIkbcuFoeCDW606A/KwaScN/1LpJd0SrImm126fPlar2Q4LdIL+/eWI0FfwNPBUXuC3LT2KZbEhqRgkmC4FayDYrNhMa/Xv6BjA80cZe67qQtwX3T6irq5vtXo7v5TTx9UhU7J3OMfGNv5Eix0QPO7W/Kde47tF81pwvxpLbDYek1/WEwrgTZT+xwZ4YbXvPNffLq5cleiddgVXmFg12sLDeaEpv3rMazPbIuBj7KwETJ/khA1yCgm4wHiHS3h6kXhijC2spQIHq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(396003)(366004)(5660300002)(66556008)(66476007)(38350700002)(38100700002)(6666004)(66946007)(6916009)(36756003)(316002)(6506007)(86362001)(52116002)(2906002)(8676002)(2616005)(6512007)(1076003)(26005)(956004)(6486002)(8936002)(478600001)(44832011)(186003)(16526019)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?C3l8XClJHKdEz1GeIxDk5K3aUpvRj0yjjf9o8A3LvunAYoz4CUlZCQiVXICG?=
 =?us-ascii?Q?edLVmNPGyrB5tzq+3yI4qyQuAstVtf8XIcP/LBpU0Odxkxtb9xYFy52hu2TQ?=
 =?us-ascii?Q?iGjlu0vqwP4wkMGgXi4EAGLL5JOGJ8peym37SvuUqdtv0LCDhzP8hLsDbDBr?=
 =?us-ascii?Q?4rEcMK2NhT+r/mcfTmYe5o3gOal3sw9x5Gf4eoBeT8m6x/+SqVIibRG7L+PT?=
 =?us-ascii?Q?ExT8bl8i5OveAtH8fSkNEPzXepcW+I1seHw1JKej1NBCqBt9nkiTBaJxeZBA?=
 =?us-ascii?Q?lpaBuiL80ICjfZ11a4ORITzzf0hc88aSGCpPF1XRjdAy/8h87jM6OQPM92i7?=
 =?us-ascii?Q?XAEDw1Zv6Wx3tOMEVpQQZPM58vQT6XM42DGJ3Yap2zzCtjmVFdDxxUGkvl5v?=
 =?us-ascii?Q?RipEp/gNXYw7UGRl81dqGdpVdsJN5/lymyB43L2WPyCHplRrsUxAosKe+o70?=
 =?us-ascii?Q?1EyPt+uDiPIStGBkoBD240OcGlpkpjl3YAG0X0oQVCMqE8gUt9jJwHDmEoXb?=
 =?us-ascii?Q?aZGJFCaZhFhmx9Wy2k+E4a6oa3UdaHUvtfACSQ3IbvLOmXj5iqGZPLctxf5t?=
 =?us-ascii?Q?JfzflGH5hh6qbcA4hba/6yKeFUKtPZlnT4DVRLAS/1L56IIaYNpTLCl3egqi?=
 =?us-ascii?Q?a+bCjfHka/jL1BAOlhV27j8RwQZ94VPTd3xxZiF6prK8bn3ENROqOGomZwbz?=
 =?us-ascii?Q?neEEz8aC1mFZ4Ljo47bzqJs4tiQPQyLDMEIXi/zmabYkqnikMHjAa7jtNZsC?=
 =?us-ascii?Q?KJ3qV0LuROCmuZqFTM5N6KCaWfCaUJcSQmn9REK9Vbq8CjK7EhhaCvORO3aa?=
 =?us-ascii?Q?gZK6glcQGKnXqmIhBpOfEIW4T85HlJU/MHeNoSurzYlyZVfqp30FiF8KJVa+?=
 =?us-ascii?Q?pJVWFu31bYOdIKofWrhlpMkTMfsn2nroRC829EhCv/hcp1DW5vMu80NvS1f+?=
 =?us-ascii?Q?MhlCgcrMnna0ExBiPV40xZWXa2kfBD6o3e/danF9RvLbgelFvACyMZIxZjbI?=
 =?us-ascii?Q?jp63FP2YYei1BiUMurilZIA9CFMZflsix5HLLcStiNTVRtNLfWh8C0MWs77c?=
 =?us-ascii?Q?ut3nI/GEp8RijBfL0jv7ec+nLYykS4XfbPxFMaKxEWhwWesfmSAUfpLEBtD4?=
 =?us-ascii?Q?IgQTfyB0Se72YLJShKOQVo+y6C3EoHGtj2r7F4IJspzzeDvMz2KO9tvKcMcN?=
 =?us-ascii?Q?R61rRNnIIK7h0SiOKHceKRVHXwWsdsosNPqu2PAHyYOlgvGfHJoBW0BSt99O?=
 =?us-ascii?Q?YBZLdw/pZZVjG6+MbDHWD4JzmOWap1iA8iVxUEofTzwXudTcs/Tbz1r0AzCU?=
 =?us-ascii?Q?0WbbjHw0P69HoArTbsetmAxL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da052f18-a572-4b7d-686d-08d91fb70b1d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:27.6649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFTagAnmfhWZUOiuRcB4hF7jx3uDHZ+PSKVSlq7pvNj2QZsoFYTVyYkDf6q5NZRsuN7+OHVxhf9eJM7bQyji1spgcpg+ayn1ypmFzew/TLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4478
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250122
X-Proofpoint-GUID: ahZIC0of8YGOBBan0T3zoduC5nk9yZdP
X-Proofpoint-ORIG-GUID: ahZIC0of8YGOBBan0T3zoduC5nk9yZdP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0ec1547..ad44d77 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1073,6 +1074,28 @@ xfs_attr_node_addname(
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+	if (error)
+		goto out;
+	retval = 0;
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC int
+xfs_attr_node_addname_clear_incomplete(
+	struct xfs_da_args		*args)
+{
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
+
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
-- 
2.7.4

