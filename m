Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DB3C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A99A661184
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbhDPJTB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48310 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhDPJTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99wVh166527
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gn0pEXl/tbbSf92GO+UUyaYMesazZksUIGR8pdNb13M=;
 b=Qxi5gzuPu4d2nhpxtp12+W/7Eee95kDNxpBGnLh4mFk48II+R32fmxGlHmApAUqFFdRX
 e9FJZvKEf/vZLLzFkA5t6uWx3DaLrusSnZyLXvL94T38CdeSyCExft6fK0pn8T0LyAHW
 Xd+Cyi5pwwliCgR9LH4XjnGAZf8vCGIa/bLXaFKoQFHrDwThlNch50ZUWxixH4P1ZRrO
 JCHGLc6wVtieVaEtdMntsSo4SArhD4rm/Q3PBD/7IEn/sn+KxPQ2krKGIWB97kroiWQo
 QNzbOj2X5AnsRcNRAwafPmKKP1aSQbceLdpyCWMOxOgK25iUiepEWyaL0vtBG0Fb0VfS Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37u3errkfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99dBM182009
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37unswy4uk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/bDLtnQ989mqk0d63oTnP4mGO8LwhbIrYDOw76vvWOQmyQHpTgKztQslalPC2aiPmSTswcKPSJmnK5+sM0YV7HDot9XmAY/z4oHngFymGSFM9xB3tUB4JYgefICJh/uUwRvFBSB1qfjyOk+20YQZESkvZb49Iby4wF1IIx72BqlefryTbMB2JkhcAVETWjowbMkuvnDRJubKziDRuBhhbzU90mfrOe4soZpvVNRHvrVsFZaW6R2opa83LbUKNpke8+KCyJLig7pobMKHOkLhwBOwM5eEE8sWljr9DsBn9Y7nDLKZiuoEaATsjCp6v5qNufbg0DbHobq7bhvS+Ww4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gn0pEXl/tbbSf92GO+UUyaYMesazZksUIGR8pdNb13M=;
 b=dTUztMFe+1GoLyqbfWSyweyWNLOhED1zNADZjOf0ZaOSqRi97QMIppxzZHcrPGR9OsGI7ece9yful3TELj2CcyrI32ez2WsbKCYDMCOc5CXdrbikqBZ3/nzvXRLdN4M29QmUN7JN6YroPNkSqEdpuL0QK5F+y2zQHAFQPH3x2GTSJDbVCi2rlZsRdoz0Zjo2feKoTa43dHpa02IO6bXZl5zr4pHs8YehCvW+7ceP8T/MOUVt+AqWoDtX6iL1tJCqMTOJ4p6QW3CyZNZ3ac47S43YddKr647367u8lTuCG0WvnlJcX7kAAjVJ3cS84l66P+ZO9/lICHimpehQxoIZGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gn0pEXl/tbbSf92GO+UUyaYMesazZksUIGR8pdNb13M=;
 b=zKKiWn2VbvnOnPxsJ2tDSD///EGDoOAvV568hLY2AuKEnQTqcsYmoLk3hua/7TEAU/DOMTmrxa97cRx/HL0ac/siJK1sW2Ynt4/WVEVsdljd2e5mgg6APFz+5C7nLrLspuFtEzigcXZbEuWElQ4RTJJxY2QIgHc4ghNSHzoVD48=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4800.namprd10.prod.outlook.com (2603:10b6:a03:2da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 09:18:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 03/12] xfsprogs: Add xfs_attr_node_remove_cleanup
Date:   Fri, 16 Apr 2021 02:18:05 -0700
Message-Id: <20210416091814.2041-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416091814.2041-1-allison.henderson@oracle.com>
References: <20210416091814.2041-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 930e3ef2-e322-4c4f-1133-08d900b89ae5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4800:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB48004CFBD54523C730E556E9954C9@SJ0PR10MB4800.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0yU6fo+HqRiwZAJY3PLnUG8lvrNA4ULdpHKno4lETx4m69TgaZAptK+QXZ1LPudYapqhF3OC5uHe1WHCLtBQ1QgNtCqtNlFivabJibVrCgeqlqFhPnLQSoZI9nIde+IMgHagy/M6TR5jlLQoXUfFkkSPD/VwbY7OmArDC8B7fN0zQUpV8I44EM8bjr7PkrKUD8jefecEqVidAbC6lqmUXWBPSVVuKOXRIOPPnqaYRzyZtdbg3ens9KAklrHUe9m2qSRdh/ikRMW3TqlZZJS+7OqUqok6zY9o+dAfZ0brjQ99XSj3tsbbx0L9Y6hd9lCCfE7SPE+sgbCrBT7RAWSwOaCsRSvK1IhkFagroiBXVPMtccMQA4KK9zsFcp3h4BI9iXCd7476BSSb08C44V6ihPBPrPM2rYQChIvTaCanB+2eB7e4wCKT1XNdVchrZEZl09HM2lBHG7NsNGjT1JIm2c4aP5/FI7BKnwY6+E9WEin7EUwbNvQInIb+oAOur85oT34kQdKtzhsvfL7aP5ZA0DCtcnYI3OLDPRC9J61KZBdTUaJQ9WsB25PQhgpV/L6uEuzQ4kTWuwIx/20s16IEcbcujoI5DgC7vmbcn7Nq3FEWSOWpamJ/tzD8r2qS+J2dxAuUcREF1TlvfeRa51s20Gn8ORj9BcL0GJPO8S8iEMw+HoazIwYf9hGFEZVK9EJ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(136003)(39860400002)(1076003)(83380400001)(6506007)(5660300002)(16526019)(186003)(508600001)(316002)(8676002)(6512007)(36756003)(8936002)(26005)(66556008)(66476007)(69590400012)(44832011)(66946007)(38100700002)(38350700002)(6486002)(956004)(2616005)(6666004)(2906002)(86362001)(52116002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EsxT7DriFWmz80xy5FTpVXk/6WI4M6E0lW5LbACvUivqGTMRwv89oWYD5hmV?=
 =?us-ascii?Q?qP4qW6XNK9NSQWfNpQyLMyKg61SNlrGAc4PmBa8uwxzyh9otkfFZxiUzW5zJ?=
 =?us-ascii?Q?mnBg+7J9gaCIZrHIGV3SEJ4J1lBpm970ti1GsIaUQdUthIt43NtNhUmzU5hM?=
 =?us-ascii?Q?YHefpPM/Vgt90sW8lPI4707j1cO2+QvoFItiB/StI9RiNFb2QSkSujmca4bR?=
 =?us-ascii?Q?PfllZz6cq+dWyN3SF6sc2Lnh+0H2A4zu8wMpgowjTUe0KfIbrDXfDGQyo+5B?=
 =?us-ascii?Q?jDyA6CEdtI/o0hCanp/oYa0/sNZ+bhbVE3vOH0DtkwYEpT3xvwfZ9YhWUP8i?=
 =?us-ascii?Q?vSGNGZYva3I+MwPO6sVm+zjkcvVDrR/lllbY2UAIPTC89K0+Oo5UArgodti2?=
 =?us-ascii?Q?S83BSe1MxEhjCV+akOur1CDicJuRea9bpZG9LSntH86uEoMWyb3mV1fL9Ye+?=
 =?us-ascii?Q?wYL0K1LmGJwIcsuq31mItu3V9zv20jH4i7bDFxv8rFdyslBqGCsyigpVtwdc?=
 =?us-ascii?Q?U6FgAlc5Ey1tI5JGvtWUHopAvnUnTNwXW9RSpvO2kS+MzOa7ZX/j71oaYa89?=
 =?us-ascii?Q?zA0y4cdjWijLtwm2KvYjNUzhPH9IbNhi/r4hV03hMLzXxr2xOHe569HJdfzl?=
 =?us-ascii?Q?lPKSW8XFvYTages3UpAneyOhQhKxkqKDeVDOaihDWXqfNRCWkQKxlcWi1gP1?=
 =?us-ascii?Q?TXPN5CPZqVEhzGFxRvE1uUUg9BoBUSydyk3QHm/XBBf6Iwg0kGZf9p58J+uH?=
 =?us-ascii?Q?BxHVlz+ZcQCu5jzd92P4vTcUzAusFQu1u/Ejha9YVjzSiWreVXgV7ATnbuJT?=
 =?us-ascii?Q?2in6vXQZLUMv8/fj3H3uMCKrQS1LyPxSOVIFce07zc5uJelgkrVxGTlWXRpT?=
 =?us-ascii?Q?x+pB7V4owZjx6TyC9B4h6njwbFSN2LZNvkCK3kM5ilsS4HCReYYrVyc8kVx/?=
 =?us-ascii?Q?qHBXRTYnKlK4bJ3iFLFL+qu14KIoi/cfB3xc6lU5yzjoQWQ7PnfyyMCMLDrJ?=
 =?us-ascii?Q?nMYspIr1+NtNlkj4JVKmZP9Gm1mGVIhEO2VwuRqQON0CHbROzy6fcqwbieBE?=
 =?us-ascii?Q?VJjfWoq32NASrG9dErK2S4AyW+TPoL2owC067BgJgRK4z00zTaXizJPfuBOd?=
 =?us-ascii?Q?up518jEfTbfOM09peyWIu1pYV4k9NLLAJwUNit004IT6ApX9N9S+O5migiqx?=
 =?us-ascii?Q?0q1XrlnRdo8C+UDhfBR/VKlamUIAbS85ZSHHQ96Ss4a7K47L3ahytF0nXgQd?=
 =?us-ascii?Q?OO/ypkc1KC1isCwW0YK6DZgZJYCgL8PywaxKAnOXc1okj7qHLXNEFBIxLIXB?=
 =?us-ascii?Q?E+bpbBEjnuKcP4P/ISqMkjI0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 930e3ef2-e322-4c4f-1133-08d900b89ae5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:32.4034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ydCAJ2f33p4IHbuRfPiSjM5pMVzL0X/cvS6IbMSQ1t/PP3jeLM0yrJ/7cLgYPUWtztGXsIuA+fiS1g1Wqn4yzzqYmYDza9s7/BUnJqZ1lQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4800
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: C7tJZsIZz_Tipj5hnNqbqezZcYDoByF-
X-Proofpoint-GUID: C7tJZsIZz_Tipj5hnNqbqezZcYDoByF-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 4078af18570ef0f89fce18e9ed9c1fa0c827f37b

This patch pulls a new helper function xfs_attr_node_remove_cleanup out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c356238..956a832 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1202,6 +1202,25 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_remove_cleanup(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1214,7 +1233,6 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1242,14 +1260,7 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_cleanup(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

