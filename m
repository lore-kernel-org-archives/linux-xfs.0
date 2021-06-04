Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C812DC4743C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3D10613FF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhFDXo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48636 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhFDXo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Nee1f055627
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gOndIPq3yL0StYVAqC9PVAU9zgGvTO1HUubFLKPYzqA=;
 b=WBmtMiaePDOKL/Zfxn5KIUXNR6u5KZ2+QLQ26V+Px0WDu3ICZUq3e+l+KOXkiliJ8uaL
 Mh+wdsqI3CJotErLvWNk/EQzMRx8LeSR7otbKkVjVbEZ9NCTNUJkANCc8u6HpN7d4DrN
 9ByyFNVNgPB2UzMjyog5gRhbyCPN/a5q7txAE8yj8B9QfT+GvDnySG8na/omnv8/Q7Dn
 bNPEzU/oFmlji9pq9XlYZwnR2W/jifwFARs3sFCCpS9zTISOWRW7GMQdAar480tFHkZD
 vGPSemD6muRmkH6zpVHuHGkZlOcLwjOOlKmBYZbjwI6VZEpHlLzCn01BH+sBcj5bPDwL dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38ub4cy2nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Nedi5056299
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 38yuymb0mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2U5Y66Gs5LyUgSP1d5v8qZ0d9Mjf54vncxUCtXz664x08QqCn8v36IG//EBYVoEzC/z2j3+P+IgcKdCQg77NoTUHPv/IFjudV4HZNIF1UzYH3M6NjfCS1dkpMRCkzVpns2KrigIRYsILdiFX4BPHUdtr7dF1m6wYZfMsKlnSe+DYjbso7GZb7BMl2VnAh2S5fZo/7GyGgi09M0CawXyOd13N/QoImOhz1ZlYd+ghPli3E4uc5e7VDheIQzA9lTG9zqJcUGpRq5XKhuGhqqJJFe9qJihiEzCdh/XD1nFIEFGpKTlxnTkXtqmvM39JBqqqldu0zYroM5BcbMUKgruNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOndIPq3yL0StYVAqC9PVAU9zgGvTO1HUubFLKPYzqA=;
 b=gx2sMQHbKliv6QBG9k2gEexmOPhm/xnosnHEC15wKmwzeULYaBG9vH/lL97JSwksNbarNbpIoa8fG+TDSqSc78QQjPDdeMSovGjgqvRO267LyKWFYMnyuXNmxODNNmA81s43SW/4RE2TRFbUKbsTXA3S5kCGqMuMmhgV8LNw2h9F3XlCb0OGUeDGgHL/peIZ3Qjpn3SFjAW22nDquk02S5KIVRUmpYdAADzlEwgv2xMR8bMf8otiFcuyaMx5oXQ+pMrQ8kJdGbTjPwCrecvEs2U0fuf+6Dl6gJ5z7nMK3Bab5P6z5OzPfZUXIs9hkAM4li+DHfnMXYnQCg4ziA8N7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOndIPq3yL0StYVAqC9PVAU9zgGvTO1HUubFLKPYzqA=;
 b=o4Ym4TmFEhX5IIWg+r7dUzO6xqFX0R0KN4v+fR/bawJFGva8JD1f4qAJvZKwMgtUcCPdINHVWnnckTRj6aayJR3eXMWvVZP2Q2kHe3ZF/7HSXySiSaJNqI5WVKMNrWZeUp6UqwkwF5QXmC16HA1+7h6UQuMreP4sugopZkJcro0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2485.namprd10.prod.outlook.com (2603:10b6:a02:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 23:42:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 01/14] xfs: Reverse apply 72b97ea40d
Date:   Fri,  4 Jun 2021 16:41:53 -0700
Message-Id: <20210604234206.31683-2-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb3a1af6-088a-4cf0-bb25-08d927b27026
X-MS-TrafficTypeDiagnostic: BYAPR10MB2485:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2485B27AD5B4550FFF65BE78953B9@BYAPR10MB2485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bxJvZe9nJTk30nsZKYDmUsRvffN2e/NOdqj6NQcuKCrTnowVT052SwPbPM8oBOhX6cYJMuqoAPovAxKpU2n34c7gQXAc2s8KFVwI8vQpIY6f0hvf3eMhLHxcDR4pe8sCGi1oJiu3sNF81xEAGxcy79t7aVdGvLrNmgtSoH5ye+P7QsGTa4a5gccx5q5Zbu/C+Orvsa3HjV9PFjDjm8g2U6A9jKJIIfxoVMTEksb6I7gItVurBPH/gT0+PdEYsMTpTY497pnVLrPI1vsVJwClQ/Y1TKWiLDCDpBirRVmUfatWE9Od65/3ndK7dYIRU32cxGkWlpQFfaQgQlb9MRcCA6UTmqaauxcDYuE6HEQ5kRMFA77+3j5971nJmN+/i650X94JlP3O+OWmpt7K/DHpyee4NVo/sSjWYE1b70pgGh5ofqiVoyBFu/Qp2ZdsbZZx5Rjz88Tp4bVIHXw7jFobgk05AWECX5wJd13A9mD59tOhw1dA/HYW6jywW+5KQM2xLIlpJOUoZj3xe35LjUAHhJbL44NItleIcdrNowl/0RJ2+MlmbrTmzHEGaBW/7ZTZcWH6heTiDVEXLFM8tWvQC4kAJ+5yZirMOb1tBUTapJIoOwA3bGpkZj6QSf32UEeWez79WxoBlxBu4OT6KqtlRI7yo5D0Oit+spfeSiMGPRPVamfwpZ9DIFWkTp4/dxYP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(346002)(39850400004)(316002)(956004)(38350700002)(2616005)(83380400001)(38100700002)(16526019)(44832011)(6666004)(2906002)(1076003)(186003)(6916009)(8676002)(6506007)(6486002)(36756003)(8936002)(66556008)(66946007)(86362001)(478600001)(66476007)(52116002)(26005)(6512007)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8UxJGwVuhyI1Q3uUH5AjW9TIiQekJS2IFY3uk0l7OhC0X3e42720cD0o9lft?=
 =?us-ascii?Q?ppp/X77MRaxdTBXTEufH8+rc8oebgpv/x/e98upFihl7UYP+2HqNSsiZN7BE?=
 =?us-ascii?Q?j+KesjwVia5mYCFejtr82uTL7d5tHjjYgq8kNfdQilAYB9Y+8+F33DBggGnt?=
 =?us-ascii?Q?WBBDN+Mo+OUoDunI3qdXFEvGVfcJUUsRjc9d066fdRw7t/ZMPasupNU6y2zl?=
 =?us-ascii?Q?INzoX7CRUt/bvtqEma2N+Ke/j8Ou2uLxI/l6/vJ1MYVLxwxco7F8mXChxfbi?=
 =?us-ascii?Q?JeYhV/sRdGUNfyNMDu2C31CmReM5Q1EvLMYyqiCbBk2chRs/4Slh7YlVJnrR?=
 =?us-ascii?Q?ORBVFem9ojiUXlGKleEjC9s0WkCmxfZBn6/Af8096DOkZkqH7dEytN/g3vre?=
 =?us-ascii?Q?pFtBm6+icMPRCd9DGjDA0gKDuM3CZ3njRhuolN1Yn99WTp+yoSrfmlx5WBPx?=
 =?us-ascii?Q?qRk5c2LiP3P/Qv2Q+s/z1UJ0midGHJcr8fnNsBseyb0v6suTyJPizIadcTNP?=
 =?us-ascii?Q?xJLJn3pq9VaNHfgOFaneKkJ+OHlvqKwhJdRYQVdcJDW0go3GlBFH7MhKKqVp?=
 =?us-ascii?Q?+pntSogm9W8IB5X1DeNpv5IyxEO4t/BC77YdDBMMTnxNM1Q7eTtvf51sX557?=
 =?us-ascii?Q?zEMG6bGP2mBc6q5lZ57GG54DiThm6TVTx1vXBVJDsa0+5n9S2ges+vEgN+nd?=
 =?us-ascii?Q?WvzEg9wTXidWVd8THWrNAoGyqagUJ14mS4XnPXULIxZGVJDK0XeOP+3uI7Ko?=
 =?us-ascii?Q?yThJ94vT6QzdprMXYyORk/DFD94aFL9Uc/ugLafxmwrqNQ3/WQY2yHklwYcf?=
 =?us-ascii?Q?8IdzAX4b4OulyPhJNnB8AcbY6e/ylh1G4SgCACR0KuooqYYZCssh5eruKvTV?=
 =?us-ascii?Q?sA+yfENQ3PfIWSy3fGlBgLk28GQkagxwEnzJ3QRpMSztoyh4KWj8pxCxe/hC?=
 =?us-ascii?Q?fS8yfZR8Sa8+WhqUV+OUz5e5dECln7gw7BqP0rhZ0PVNHwjzgjMO33TpqpxD?=
 =?us-ascii?Q?YgJn9QLM0pJOPZxzxzLHSfR8s8SovJli0vbf6F1YlVE/QoWpRLcB7P8k8TlV?=
 =?us-ascii?Q?rQ3MwQOpoSV3WLe1/OALVOFTr8H+tcuJ+ABqs3J4cV63MrPNnhiiVLR5/K6s?=
 =?us-ascii?Q?eDu57yGeWmlRFoWZnr60ifyfLgV+1nNe5UQf68FK+TbXQqpcYdb1IOUqiUaJ?=
 =?us-ascii?Q?fetEzyTnel8PgVNCJLzEYzaRI0FDyloY6CQCQfXd2v4m252myPNNIDF0xq/s?=
 =?us-ascii?Q?SyOuuESEDBiVYujRnI4KmmIOTjk2syvHJq8nxmZbjwZrneo3f0EpppzURavm?=
 =?us-ascii?Q?r+bXqkaBFyaZypf5Vk9MeU6T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3a1af6-088a-4cf0-bb25-08d927b27026
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:39.5166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6BlR3QQ7R4qS+nodFHFxNqEqCe2cJtqqCTF1J0YcyUseYxxb2To73ilY6ICuweYk6lWqJvBbDDQLZVuWvpolus7wXbMEmde28OECHvOWJ+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
X-Proofpoint-GUID: HB--ZtPHfTKIMYHpxi4eQOyNdhjgQwyW
X-Proofpoint-ORIG-GUID: HB--ZtPHfTKIMYHpxi4eQOyNdhjgQwyW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
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

