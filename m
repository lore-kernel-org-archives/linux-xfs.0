Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943BBC47088
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F7861279
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhEYT5J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49634 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbhEYT5G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnjAL038703
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EdEkZaR6alQV398zHx9t8rPo4BCLa2RMEctKAGGLTSc=;
 b=e0ADoQtVAhlp4zIuFCqYygMaetEFuk7V6uigI4ao76DGrmJvNn902wjYyNR3ci1nELwI
 5GclAyTP/7sk+GOFKV0CnL9IwxxcBL+LzQMIwJbUhjWrY/s2Pb2cliiDPGXCwdssSOaS
 ZjBy/e8jIK70wlCEQz/Ok65seYTIb38+Apn9jxk37op/WztqEO/cCJALsu0yIfZNyxrD
 ei+XEd/IN96u3Syy2xHfaBZtk2+cwrVgMOKmhOej6gFrrVFe/wfn6L+fpa2yTwleTEVX
 09NI59QYolrOAjWHQZ7DqcDaHBtSbhLdI0AyAmW5hpBR6Fd7suPKO1hBmHt917hl07N9 CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfcf6e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoDij188864
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3020.oracle.com with ESMTP id 38qbqsjk14-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtnsSxOle8CRaeUm85Z5MBZG0f9g1atoAjZ4e/LKprbIgCDG9HT9DPlqoSh/j21gNOySxErckq9Q88XPW0rfHADSlJ9GEub9xoXA6ET0bq96FVqz8vD/HFYrdgVwHJ+UDA84DLg6VNhh6VFxPOdkns//rFmALvgRsLz/zvvqMv0Ed50Fu1RfKj/Cjojw7Ph7D5BxUBoYvP1tlmpK2zL/RkIWr1Sb70UK6uBGrLwX75/JH/uyvfME6tTzCeH5OErwjBg40oN5gJ36M8NpNHtsQTEuSNHuyDO0Ac5ZKqn9G4ifZ9OVHpK9XPaJiV3uYtro59RJlxmzWugtkl5lIzissw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdEkZaR6alQV398zHx9t8rPo4BCLa2RMEctKAGGLTSc=;
 b=YxsdvAdWpdEp287Ni9UVwS+A6H0Te0vkEU/w6G3CWs+P2kbjjhOpD3zxEOdPx7O9ZMNJ1bVCzh+N1uLOHxH9Vz1WsI/7PcTJdu2grAi5iyolrcC7r72DPzpK9X8QvnmlJhdmdK1S8i7/P7CFHhsAG9pBOTNjcMLFNVRkWHWgGKCb9I5dbaY7bdcf5+9nN1xJz8pFvUj69Tg05qfNwoQ6OL84nzR+WuXL6YKaPIjA4o9n+jmMPe6aKqDjN388ks3131vx7co7oIlR7V8acIsVTQ1AGgKVZBEG6MO66RH0mWYsEwLH9srMBWgdecAWPVKSrmEpTca7ZmZgUbrCSuBDxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdEkZaR6alQV398zHx9t8rPo4BCLa2RMEctKAGGLTSc=;
 b=ToegPAqQYHCqFP29aQnAxOZnqXLUHmNIXqa35yUrbU/9QjgGuRTHSs0T3Eg6MbKxsdIHSUZ4XHlqE/ExISLAGfrZWhryxWmQB4jpHyYKj0NLovxVmSzZ64E3JQBAHN5v3UcZjrzsa1o0XaPlrB3Mx3IyIQbPp2yD3350O9K23II=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 19:55:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:30 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 12/14] xfs: Clean up xfs_attr_node_addname_clear_incomplete
Date:   Tue, 25 May 2021 12:55:02 -0700
Message-Id: <20210525195504.7332-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ddca837-3c87-41b2-eec3-08d91fb70ceb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4544:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4544E78565B89517754D78E895259@SJ0PR10MB4544.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XGmYyG4c6EbD+Se6AwbUT/RW7GQsW1cRgmUL4no2ZqfCIRZ9egwUUFYPWUUpXbWEj4qU1RguBDjYxJK5U2/m9vL2Clg9UNEgkZnMpPDX3hsGAzYWgzjMQaH+TksW3x6rIbV+Gcjv8xHszVXcDPhtilzJYdLEpGScskEQj+1x5BVLTPcM0445weWmTcRMIJrLXE+jc0To8SojG02O3Q0eJdBK1PZw6zE1oqW8dPnUjTaxX9bBuux+4YkIs5+m0NpkkVka+kNF0SmdLRKzI+idYcoRDnsCEV74aGuQpWMT2SOR8GYQztVOkRKI8/uP1ft2FTarqpitinOZcKOqZ6jHCNfT3KLg6MBJpXHkSu5q5kP05rCDMraU1hiV3KH8RWOW74RLxTOOVF2p8m01THsiZ1lOJVshn7yLsMoKetlzpBzcuaHXrJJgGdtU1ri3qKXfTTAvpR5pbFJaXRFHvvOSKkTj5Ee4L5mjnF8gJTnsgiKH8ruvCcal9mGk1ZhJXtmirPbCv3e/ePewVQmHlhVlaIzyHIUn5OdpjLGj9EqFXtU9BtVPn6/pLmJMsmWX49KGFILvLPGfIxdcCkyX6h47i9uIeUJuECLMHnz1sVb41OY6m4xb4pjp1qB6uVPrkVUMUwYjKraA9kDs5ZvvgD5+1jz69uy11NyumD/U7rmIKMYaaWCOY4tB08UlWjafSA5H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(396003)(136003)(376002)(2616005)(52116002)(5660300002)(956004)(478600001)(186003)(83380400001)(6486002)(66476007)(36756003)(2906002)(44832011)(38350700002)(66556008)(66946007)(26005)(6916009)(86362001)(38100700002)(1076003)(16526019)(6506007)(6666004)(8676002)(8936002)(6512007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wMT8pLhQjTDIZiCCikrs7P+DDOI2irl6YNz7BKxWgR1mnwDSccUK2u75v+1n?=
 =?us-ascii?Q?tHTR2CTaZ2cUTWSbVLQJc1U8ddkrkQyvColF9z49MEfmvB2ELE+asyw+6jSh?=
 =?us-ascii?Q?pm7GB0h147BfBBqsV8ITrDgOd2PlkMLCtHqNe3B/CqEtqi8NLTapDGsm7PFK?=
 =?us-ascii?Q?Tu2MuUDLiZQNs04qFyxWfueeafFxBOUD+W3ToEUCyi6qQ+VkY0MicHIvAEYL?=
 =?us-ascii?Q?gZBYaLTOIS962u78edM4xTdF9SWlXXnYXzCBlqmGA9gUBL3s2IaF5TTlMY6R?=
 =?us-ascii?Q?nB1ElCbHCutMeDiY6dTPZ4GHt9Wr7Uh+7YY7vEosqJyJAmAW8u4h4WzOFzCl?=
 =?us-ascii?Q?kgx1SlbsO58qZS8nZEt85lRvpIuEdEr3fcN8tCEK51yiZFwvQLfmB4/AVmkJ?=
 =?us-ascii?Q?SBaWeYoK7Rvj0IrSQL8lJYuN/83oHeMCksrMm/HIeWI69qFF19gz54WVjEK7?=
 =?us-ascii?Q?jNng23caVrvbWw0nYSYAqaO8yL9n7LnUqfyJUZ7HBtGvOKRv0QjAiZ5DukCk?=
 =?us-ascii?Q?Cf3pFfHy6Kyv2FPhkecOViDxFwSSbt//vkoyjW7g92K8dcRepVJ6ZSrlJ0v+?=
 =?us-ascii?Q?XQeYGdfye6ch4SYeFk4JAX14L/JMOqQtqKXaGVUrKXDzrseLp9d98GY9tNJy?=
 =?us-ascii?Q?YDRrmrds+F4G3FAy/46q5AFpt0YDmaMfJVLhPkHEMqDog/JuS8SbfEGmMzZX?=
 =?us-ascii?Q?uj351yQLftd8xuCJX8mUYhZb386b/2dwr5wC+CqMgBjV3FaN5CmTR3YGj1J8?=
 =?us-ascii?Q?isquFA8WUklOOUoIKGs0YG8r7IxwPkdu+jq6770+JQeUK5vEfkPfD/HDFsBP?=
 =?us-ascii?Q?RW4DD9UdiUzVh+qOriNQ6v0027JFJHW/cRUll41KtdW7HyKdVGNvX1fsRmZb?=
 =?us-ascii?Q?LWe+b8W0oTfkteUZRvFIhm0IIT3Vvcf63+uY04mhSiHaTt5PXj8I6yUw2AvB?=
 =?us-ascii?Q?wBfBZ+BxAzcwIAYfqPZYuv6j1mqvG+SwyZkuDC5XSc6ucgzOYkkkmsZn6uW7?=
 =?us-ascii?Q?F6RhpYRu4ObYc/UFPRhNtyCWXKaULDuobg2geZvfMPJHh5/DsUNTavkQi2wO?=
 =?us-ascii?Q?bDQlnnROHK3/W+hhHNPCovhp6PStoxBAKH5ZETi/uGNIhllBNiNrOoobrxDz?=
 =?us-ascii?Q?PryXkziugbkvyL3XL9App4xUeWJ9TfEhAK4ugVVpYVPqq3Bf1i1IgHGY/Yn3?=
 =?us-ascii?Q?VbISf4J4fxdJjgRCHErnX8xYIhx6ocQYC5W3SUd8cUVUbskPAw1tejPSqGo+?=
 =?us-ascii?Q?2aOlj4XURMT6HkpX1CY3z7PVEHGRyH5t73PYuXdu08zPbIH+O9Tyz/mfkMdD?=
 =?us-ascii?Q?OVgIWj6lW9vdvHm1EaqaUtSl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddca837-3c87-41b2-eec3-08d91fb70ceb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:30.7294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNU9RsMYPyEpvBsVfOE2Kah1aGwHs6LSj0+CtAwy6VhTT0EbduvPOe1gf0ZMcW7JySg8Y2yFm3LIcVbPbXTcrnil0Pnhxf8HOc3u4Ileo4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-ORIG-GUID: AXAbKXSjDqIN6ifMWBEE6Zka9euLAsCE
X-Proofpoint-GUID: AXAbKXSjDqIN6ifMWBEE6Zka9euLAsCE
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We can use the helper function xfs_attr_node_remove_name to reduce
duplicate code in this function

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f7b0e79..32d451b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -63,6 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 			     struct xfs_buf **leaf_bp);
+STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
+				     struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -1207,7 +1209,6 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
-	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1222,13 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
 	if (error)
 		goto out;
 
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[state->path.active-1];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	error = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	error = xfs_attr_node_remove_name(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

