Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC605C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6897364EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhBRSp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35686 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTiDg040357
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GuR0+TcHv2SCwg0AvzlO95XeHRUEtDEYGs+SB+yRIas=;
 b=awYNfwxjT0uq69vApjQdg1ib+PI0jv2NNqKad3GBSNIb5QyJe0O03ZeYlla/c+XIqICO
 DtTY/lq+fOWqfrvKAsvngWwQxhl8fHXH3nlJaDEksBGa5SdsVkS5Xu0tx0ugK3T5uooO
 rujyrvgEvscUhM1ZUTRL9w2IpAISTVLBch9VzdVtlvstW5thyDTenhEq+Z8cD+kj00wd
 olzF22TY+5mQwoq+REhg6XVf6V4GDZ9Dfv8pofAskbgAklgr3i1pmgFO8MzCXbmDPZz2
 /zkmqdWOpj6xQ8IIVfUOQ/4v1TXQGqIa3Z7pK3x6T81EcPjsnflKH8UcONqCmSPaqPKG Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTfft074752
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 36prhuf43k-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmyDGJTc/BxElvKHdsnK08+bpUqFMhiuulchteraRaUSkMbeu7QrDiQXPOCGykEFyohEPJZ85SZIAjgjFk1H8DGzZ3XtjJrZdPaJ3Gx4IwXJ02dapx0Lp6Om00PrqWbMZ4iHOaVaU7kqTPQsHv12EKoXdf8Y2h7LFjiYAHchhcVTdN798a0BN2jRIepoKBAOlZMYhXdxpgQUDjlZ3MjZyyj39HdLuPW9D2tuk5j6rX+pbkS0TRJcJNypdD3rf4hQJp8Tjl76PlwwlP1ZmR+D54DeBFUvtG5RNwMxhwFDuFNF/0SEKTja3+bn881LeplWDDizb7lGnhmgttvd750qSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuR0+TcHv2SCwg0AvzlO95XeHRUEtDEYGs+SB+yRIas=;
 b=VAimDP84JtNUCYHSKDMwH4gs7lbUWRb3dcHujBD2wbZzFNtWMtx4EhEE2fqsfTEIa2dt9nii4d67SjokzqHoeaCtZLay2gP1t6te/1iylmfBvqllcqmF5yYnP+3sBnZqxv6ZOBos+do0ws9A1Iw4RmOBsxi6WnGFnNQZ4dK4ihYV3SI3X4SQ/L7Q8iA2AGNlcYHaC6boaM2FWz8TwuxQwAncyA6CBe0XNX2qynXqHknaVgvDHlt+bgCKLyilx5oaWglqtJSMbM2f3z9b5cCbnFeKU33nvE9ADiaRplUVNUi/+BZcnut8oY5l8F8pVLgiIjEQwOwMQfOY0TPOyPnchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuR0+TcHv2SCwg0AvzlO95XeHRUEtDEYGs+SB+yRIas=;
 b=rC24LmpcgASpZuwTZGYeUjjgasaKv1NGcnvkC5ZI27jERoQbYixXwKF+ub1wn5tGAwMBiOGPkPVSkiBkVPQPCgwNnC0s5lFedkGw3zsb+DbmP7p0EhLLKwW0LzqBftJ3cHyX/bJBU6APlbv8CsbL4XTOBUvJS/ri+9T+XO8Y+2A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:45:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 23/37] xfsprogs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
Date:   Thu, 18 Feb 2021 09:44:58 -0700
Message-Id: <20210218164512.4659-24-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc1a353c-c46a-409d-c8ca-08d8d42ca0ef
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4495AEC61EA0F17C440DB03395859@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n8b2IuIyplD5UN1hWaRWcZRPAMkrqO5+MDm5E0rkpDJrAQ6VApwJgP3UHuJwZezl7UhK03c7T4FH5DASz/N2kzKaqex8gF6ZpE1s+j+vsLD/2a5nJsUADzgsjgQrJvhLmphIpQFUAt8QIeEumeAzlXAfJgOwP5QFvCWnKzf+iSA0THRADW23oKeukvb92OhzStdEFAnghsTfRdgw+VtIxmkda9u5BRVblASu0LDZ+MBhvuwIkfjtw+J5rjkF0ApfgnjRysQPTlkpyje1+axhcG6sRnlxwLTujsox+h7lBRA5RzBzdjq36dYWeMClFsBzgluA7QYBQrzt5jUaGkKEUbRh4rPGEwaFpJmZDRmjb6ZEvWy4lFMxJXEh/Rnj3uR8LrG8mteVxb8WrcIdes5YakvgDLU4rLh0z+mh1jDJFW0VP8OrTiJpbDGEQ2l1QVK60+j+BEmBp5EV0KEU9CfdqSvF4rtjWl1UePAC6bxQtZqxFalQcaa6NaWBTV1zJkhoLo5qfzw6cvZ3E/VXUgViezh/YVLyzoXuROePI1/y8lWWoYCOl0A6req+BfZfb3JNXvy9rA5Qz+kLlxFw24bikA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(478600001)(86362001)(6506007)(44832011)(2616005)(956004)(16526019)(52116002)(26005)(6916009)(186003)(2906002)(6486002)(8676002)(6666004)(316002)(6512007)(1076003)(36756003)(8936002)(5660300002)(69590400012)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yMzdKBUcf/uMqkWNt59xNWboA5sk/JAmplI/PRsN5wayYG41yt6xf0hAMerI?=
 =?us-ascii?Q?2o2krH/jt2Fb0DHJl/+/QykrxZ/HZ3KTZhke8tlbQFuWYILz3BR0/HTAiBif?=
 =?us-ascii?Q?8Y3PJc6P/VirL3XBN1So2mb7q8BSKokKBP4NLuxhRslTVctZRMjRm6imxk5H?=
 =?us-ascii?Q?muLkVl6+M/R+FllE/yQsv2BJQMoP/8HnFl/orwJR7spNZtIIydJLX4PzjIv7?=
 =?us-ascii?Q?Gmd/Y1SJ4fE1EzTPuaVY5xsnZE8x1VNn5q4S/scYfKs1UYKUALxLUuQE0bMn?=
 =?us-ascii?Q?xAwf+o3wU58AqOgYbRdK9x56dJKAmofocYoD/M6xIXJxaSj4nAwIY1YeNkJQ?=
 =?us-ascii?Q?+654t23W1yCK+xOQLgb55Dsuu/NMkUgjDO00RmsucnGLvIj4w5ODTaEfqf01?=
 =?us-ascii?Q?GKd6Trpp3O+vfwV8y7WEOzLPPJk4jwsXSXvxCLnUq/A77wYm14Hx1CQMUZn5?=
 =?us-ascii?Q?Mfmym6gTa5+N+CUV17Nc8EMf5BuRoZiOzOiDc2S/MzSk4gO0m/LRUe9k8Alb?=
 =?us-ascii?Q?GwWLOvtnBzQIXS3ILLS2Qqlf7gaoPL7mg/nZqs3TA56KSPgTnmc0HvWwLiWc?=
 =?us-ascii?Q?//3axS55ZgfR3owmUK00nstJViHVbdQEkBjmEneZ3HcQn+zhvIvpu9z5bcxh?=
 =?us-ascii?Q?giT3bdUKyl8uhREzk63x9k2Bv/8cY2Lmq6jpt8vgDnX0O6w4jvRwwQCjcoEO?=
 =?us-ascii?Q?rpPdqPZagWkeAXvGstG+c7Beeyq7c9HAwN0Om3I0ievLGgX2R4b/uNLXr7Rm?=
 =?us-ascii?Q?js6qcxlqIe+kMahlCtDwlJWOxVbn3sLvJmnpmE3L2RPInlS4QmjrM8jGaWTd?=
 =?us-ascii?Q?rgSILob0h9T9gnMGaHqh4QWRjHtWdH8W44MkdbCYRpU5q4v8WxOevhtgjWpR?=
 =?us-ascii?Q?Z0Vo/jhX4fUv7UJ78/r8KbH92Cq072fSOkGZsmuPHZEUe+ZNh3aPSAAF2BN2?=
 =?us-ascii?Q?ZS+x+Ffo0JGIIJYRA+1OZDpur2P37a5WjWpCNRPG53R9mJA5n8wrLVahsDoZ?=
 =?us-ascii?Q?3DaElEnBzE+iZP/CmaiWNrGQpgxm1Ztqqka07h/3dVVYIwvuVWlY7NUcnmmj?=
 =?us-ascii?Q?WPXyy7MXh6gykzCvlUdrEWF0hN/cmUkQXiGwyxX+aL3BIYm7LL4wi4/vVpqm?=
 =?us-ascii?Q?BT8VC5NO3is9gizk4almoo60kYsSrauUp/VlNFI6qLa5BzDnuMzcrFJMqY2p?=
 =?us-ascii?Q?il58GjPyUILCbORl6kS9Q9e8pXqGoo59QpPUTjAJN+hdFYnSDRe9ZatkNbJ4?=
 =?us-ascii?Q?muRseL7D3h90an8qiza5lMf6iaIS3/6eq3PZISImq3E8CGBztKKjQY3/1ZxI?=
 =?us-ascii?Q?bymPzbEKdJsIMC8ENb0OdeuV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1a353c-c46a-409d-c8ca-08d8d42ca0ef
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:41.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: po01pPh1NUupTmhFh9DSIJAxGesHlYMNSuoQgUlEbi8tGFdiF9SNaij8Uw0DIPfnp7nrbpOUxHkKpbtZOBjbl2lWVrLfqcAVfTddDsLMQeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 392a7ea8080e3753aa179d4daaa2ad413d0ff441

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index cf19c44..d9d7a22 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1072,6 +1073,25 @@ restart:
 			return error;
 	}
 
+	error = xfs_attr_node_addname_work(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC
+int xfs_attr_node_addname_work(
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

