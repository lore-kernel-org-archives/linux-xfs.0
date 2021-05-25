Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09B2C47086
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87EF461279
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhEYT5E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34176 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbhEYT5A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnVR9184907
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gOndIPq3yL0StYVAqC9PVAU9zgGvTO1HUubFLKPYzqA=;
 b=zubjCR65sIqNyYz+RxdUjo6N/7N38e5IUgggaaAI/djaGh6EHBa90PceaOBsjrl3yDUf
 k3qd3zfEKVxNnaWB6sFddae9KxkQw+yLSv0ivWmDMJDoNOrBiHrCoHOS/bZHufrhJjNI
 leE8yweq3x5RA7PNGuHNOnap5xAXKXMbHWm8GDkIMEQxgIF2wSIPp/uCI/ukBKmaCYpB
 KO9+x8SIMKghxQLen2yqsgCnd62PgyB6oE50Tq2ZTNRYI65mG9WmIZNdv+DwTmwwu5Ke
 W6T1cvumLzBQ8nEClOdtzoQDzGXld1HxISla7j7S10lf4wk1kKMxFfCJs8aLzgQH/Ur4 hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp736g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJotnS143650
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 38rehawt3d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkP4GzKQmR+PLbdclfQWXn4kysUtLJP+PFPjoJbCrwIEBipxeu+rIxB9iPPP4anm248Of/0hv3iS6st9OUKZFZGgeGJKe1oIg8ZXRgGltWZoYEOK8uMJ6j5NMjqXGZ3DBsTp2g5dN7Oqq1Gs1XmfHP3MHF2e9+eQxrXuj4iwXWaSPs/ycme+vYMoN4Y/mOoEeTP03iMAMSpGKcC5XehgzjOAVcz4rPrPSVLFOzVobMZQiFwf2pGcjuuneT71MYPGcqv8i5PnJCJ8z8/X19byzbiepnP+3Dp1bDgcRyRhKuQBsExJLqQ9snd69PzHMevOSjpHA8ifNSrBAqa6Lw9BXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOndIPq3yL0StYVAqC9PVAU9zgGvTO1HUubFLKPYzqA=;
 b=c+PlP+sLH8PDgdEy8fXd24f0zAe/m59RdkxIn2mM0qgVYzwjY1KjIjUAdQJP1JBZAGiV10i5s63vsfB/HUfYFyMx3EEcFWgH97Ls0kbrwGJVeBjcDMEWsFbdEVvTgyzaLH+N/3CiDjX7bQv2ugAcc81OkdrSjpntkIcel+uNAm5fmBJviWH9qmtCu8NnAkaZYztIq4ZBDH7zpC9vlQS+CaQ3bM7pBiacmSENh9PffWKafmK8NiaWUR8MB+taCXPXPO5u2ixGS0+1+a7VsDNn9rjVIgYj92ijZoO7edUAT5bm/O8OeYBSeCIHs/3E4l4Y/d0fQTdOm8VsDFKtf5t3MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOndIPq3yL0StYVAqC9PVAU9zgGvTO1HUubFLKPYzqA=;
 b=Te3wZf1JMIJvlP+h/1djQJg25QgK1/1WWjiKz8gAVWaB8vl9FgtjWksA7Gf0ymGWR7BOLTtZdlyo1AJLxiaLMqBKKBLswsaud79514mX2aBLDE+h/tY3fGEilMZRkE+1NugUYbMMoz7HDhSfPe9KhcNIjgLDlwY4PJF8ZhVjZJo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3144.namprd10.prod.outlook.com (2603:10b6:a03:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 25 May
 2021 19:55:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 01/14] xfs: Reverse apply 72b97ea40d
Date:   Tue, 25 May 2021 12:54:51 -0700
Message-Id: <20210525195504.7332-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8a14e5c-c9af-4b51-16f1-08d91fb70a68
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31440602E4655D057764981495259@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aVsXngbIIQ+DnfDRZ1G3eVHtHlPuAQ976TwcDC8A4OMxsBwLmlDMs9uSaYufvC35DGuTPqIIZqsBYKjSah2tGPbtd2n4KHwneTvqNNE14dVlEwamQCmapEo3OPbDoiushGtyj31EneMCfQzEd2sfQAnZTq5aE8FZf2lj8QH/JhlSmVl8M8bTZj8p7psdydqZYxO7dWTW5UZ43DHmmfvuxB4eBLXzgnhECApxb5TixknQaC2QucIS9mOmyufcUHLAATOqKYJQqKInGAjZ8bF7s8MuXeuBPqT5hGpazfY9c85KKcI5CT2zG5udJYtOHbW/Wno5SbOOtpxgJ4fTgR+w81CvNmsRIARUhWp0ctuXJtvzv9uKbEHX/TpdVtq2NVtD08B4tWyxog7aYQi5zgx1FuNGfeUi7DXmMVx+k3fnY2l01S79nW96CWdY8MdHnOItHNmcMWolnUU/eKXKoJSZWJcExofbsn2Y7i5Wa4b1zfrqapFPZncloOwqeSai0+rSCZTqtncycSmzOVoBGjgkgFCd4g/IBZfQdUyn2Yud+0YfNYhexLjGqFdsvft/vyRuSreI2HaJys50jkMofGSSCi8AsrNqZgbnUJbYa6q8KpUB3mfSnfL9IXguWMTeg52lP9KKK9CS8A1UjRbZIuFbznNCIsVSga1vIsQrzM4pAipXFf315WnySHkIeErwFdSU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(8936002)(6486002)(6916009)(8676002)(2906002)(26005)(36756003)(6512007)(38350700002)(478600001)(66476007)(38100700002)(83380400001)(66556008)(6666004)(186003)(956004)(52116002)(2616005)(44832011)(86362001)(16526019)(1076003)(66946007)(5660300002)(6506007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4OhyMFHnifHg8G0Q5n5bAgdsv383ezKyJO2stfl7GeL9O0Kg1tVAaLR22O+O?=
 =?us-ascii?Q?y1FoIa1OcF6sAfk5kodGT+yC1uUsSDgSQmaU2XVKori5gpENyYbqhwBtEGe6?=
 =?us-ascii?Q?ZxxjGpa1XWj5hB/vSgulPg0uyeYHuhMZ4JhIdQL+hllJvK9NNeWftt3ImDnt?=
 =?us-ascii?Q?T0uscaUIFhwXbliXbo7oJoGo6ESH1QaBjz1G6B4eUEiqvLrnryOa699JmdZh?=
 =?us-ascii?Q?YMN0c7a3ForJLdLGkl0OHNgTNOkYMjDUMKWVn6xgxuXtfHhD1Aw05u7Fye8/?=
 =?us-ascii?Q?moTreoyP6UMOVuSah/q0bJYdt373/zQ1zVfUjzgW3oku+4RVNe69zOHE1QRI?=
 =?us-ascii?Q?3du8GmbVom1Wq86rIeuphWrAPS2hiV8N0XIwIVTqO0Gkns+GR0Kvvo6G2cI5?=
 =?us-ascii?Q?Wdqfbt9GVkpF7ltdfhTsdAs0X6ER4EvolrSRbcKY1Ee1O1NSotInI6sVpeaG?=
 =?us-ascii?Q?gzOo+FnV0n+bOEpWLQaOg+fiLepVgTe3Or1pcRiGQv3PDup4d4Jm1HTmq3DM?=
 =?us-ascii?Q?bVeJ6a339p0BxcgMfVz7RVsZRtSWOyBk4rBIVX11D3osUHoqiNYpVgJJOmtv?=
 =?us-ascii?Q?7JjTXeZ3TTqCzz3Co6f78tvamoRYBJFOOIec1XWa66SBmTS8+B5UQKZDt7Ov?=
 =?us-ascii?Q?e2i7L9ASSjTKydZf42jhcrtpxuhF/ExCO/XBJZks8BXcTIScrsD99TQNQr3I?=
 =?us-ascii?Q?y6x/cDFljxu5XH2hprDBLjBGPP11TrmRZqXKasvM6l5s3TUZ1MFzd1+JiWSH?=
 =?us-ascii?Q?HI0fAGbGE/miFvAw5E7iinDIX6YIzrqzJHpQqOyQxQt+5MhmAnjkGEW/f9OF?=
 =?us-ascii?Q?GoX0NoLn4nfLFS4L5qppAa3Ip34I3q/TYMjgDk0GvI8LfoCbxEKv3LneXxTg?=
 =?us-ascii?Q?vphvdnphG/zht+4AistwCLdfSpuUxJwUj34DNY+oSc9BXmXkGaLUKPavxrMW?=
 =?us-ascii?Q?Jq41EJdhUe52Pc9MFTqwi/KBmlq6Oiabq+5aag2LV8LELspWbMMsdY0YIHq9?=
 =?us-ascii?Q?fGXa0xWXLnC3xaRbYY+VPbofamIGPuFqQHTEOVbhaT8GRKWJI5NwtoEDWFUq?=
 =?us-ascii?Q?Ql7ngvLUMm0JJhh0saTLHnGtQfYwh6O6C2/6bRY4uoVeuoIwVxGeANQ4o5JL?=
 =?us-ascii?Q?+97zGd68Md3xcFxeqtZjg995cpj/71PEzYm+K+2TTyeSVACz7iqwPsKNRzKs?=
 =?us-ascii?Q?hdB5m4YV36EvWHXTI7xPh9wOdpsLef8BauvLsZCzeRgjPkv3K4Zj79kPD2Ry?=
 =?us-ascii?Q?l3FNgBJyVc8Fd6hH7Bu7qdk/mVNHnB91n+D4GZ4fUtXJ9IdqLKf6LT7lzr+w?=
 =?us-ascii?Q?CDcsGyotZi/NMcQ1AQp+bkJL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a14e5c-c9af-4b51-16f1-08d91fb70a68
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:26.5512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /22oJz/LL8JiUWYIZtId/bBr8xQIn+WtPy3rzL1NnF9E6FXKu36GZb8MzIItumIsFHhNnfOQg6u1VDx6nuW3hq+a8sku87A4cCPfw42hUYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: 1cNefhABwMm2dAB6gqR9VbiZcf3xt17w
X-Proofpoint-ORIG-GUID: 1cNefhABwMm2dAB6gqR9VbiZcf3xt17w
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Originally we added this patch to help modularize the attr code in
preparation for delayed attributes and the state machine it requires.
However, later reviews found that this slightly alters the transaction
handling as the helper function is ambiguous as to whether the
transaction is diry or clean.  This may cause a dirty transaction to be
included in the next roll, where previously it had not.  To preserve the
existing code flow, we reverse apply this commit.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 96146f4..190b46d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1214,24 +1214,6 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
-STATIC int
-xfs_attr_node_remove_rmt(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
-{
-	int			error = 0;
-
-	error = xfs_attr_rmtval_remove(args);
-	if (error)
-		return error;
-
-	/*
-	 * Refill the state structure with buffers, the prior calls released our
-	 * buffers.
-	 */
-	return xfs_attr_refillstate(state);
-}
-
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1260,7 +1242,15 @@ xfs_attr_node_removename(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_remove_rmt(args, state);
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			goto out;
+
+		/*
+		 * Refill the state structure with buffers, the prior calls
+		 * released our buffers.
+		 */
+		error = xfs_attr_refillstate(state);
 		if (error)
 			goto out;
 	}
-- 
2.7.4

