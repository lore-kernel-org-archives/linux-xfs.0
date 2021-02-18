Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D617C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4154A64EB4
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhBRSrz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45890 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbhBRQyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngms069610
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=snS5fN8oi9aiTthTdIdPGlIRsX9eNM23gcfkIqilAcc=;
 b=uay3oMEisY0sUgk6PQehp6Q9/oEQ3F76FeoqycEvJdPuLHFVpfvs+qkRCJCWMRoMsTE5
 xWjwhZjS4LwQtahm9x+RIGdMlnlBgWoupFnU2c8nlOHk0CBl8v3VVAwH1M2YAVBbf6yB
 /FZaxQQXxyjfgVHhiYiMSOv372y9Wyidz47WJKVPStZ6830TJrwW5xPMHcQGvfN3DDhB
 GXATjfGQKVi/j5OD2gYLwnBMcX26dUMAKt6Jr2WhD5joye6/uyBw7XvMNIpmiAK2mmMg
 dN9vFsf2aDnqkq+DZaOKBNHWCrnLUeYFnNZ979vey2EkC1GzWNkQoskunaybg9p1GBkC AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoG3S155234
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 36prp1ruuc-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aX9kCt9COg7lBr+gH15drArYWOL2cMXcbZ6LAEpMnQI0c3aXDIiNiJqsIoELFOYYz6AsAh0uZ7poFYXXaqNSs0Q18476Lmx0ViPb2WogUV3LOYU04VRouQB2R59RmAXHMjYlNTDnssJD3pNu4b4/qOrOIsjAKetw9hvVlwj7du/O17iw6JcHJtPx0PmgtAW0/y/jd/d0Z7fsE/KorEcUZBWrAqkcnWQ3NMzlviiC438O/0xRyLjXW7LcuVmkBdOfGvzCwi5Xi1Q+RtIfoC82/RXsWM5sTkHRX7aQesw9m5EoLMl+WhEYU1GktVa1ADvSdUWaw+zCeNsX1+PfpWfHJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snS5fN8oi9aiTthTdIdPGlIRsX9eNM23gcfkIqilAcc=;
 b=Cl6vKawYcBJpbRmJP5/RnuQIrjRCFf1hP1bqWTpNUNIGI8TO06t0CWE6jTyGlNZAW/+eFetd6Hn5vGSlAXS3WhWBiNbIPS5F5e/LjMhVgN/AoiWUpDz5ju7MbyvKQMb3CIPhOjoBBIhsETYqw2sSoBgTQIGTj1QKsvYTNMw+DVtPknd0Ys5eyrv2pqw/rNssvBduyRHtrDuuIFzIbKycvgnBKQN4jy/pDKkclx4E9E73m1y6c3Zb3IpmVEKBwXRixrhBw5dJCvIfrudTfjp+VGph+4lS3ZZsAYopfQS5eIcrbStYXPs0LafkNbq5B5iTYKSqViN3GFh0l+05jExthg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snS5fN8oi9aiTthTdIdPGlIRsX9eNM23gcfkIqilAcc=;
 b=mfwBILJC/XO8v5iKD2jDfcUO6eiEIqMiSILeuhkpJW1yRTFpH2D1MXrP+TtL8220Te7XMK4EPZeNf0oY+meKTvZhshHjyamE6aU0zZQDC4/UcHjuPBc690pxTOaFqI5MDl6359d7Xg3GUZnxTz+KK5RST+apweS+xw657Is3o/I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:06 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 08/22] xfs: Hoist xfs_attr_node_addname
Date:   Thu, 18 Feb 2021 09:53:34 -0700
Message-Id: <20210218165348.4754-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 928f602a-015b-4699-922d-08d8d42dcdd5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3381F5B6C45D104424A1BC6595859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ka4XzLlAJyAscD5NbRqOtVZDzeek/y6osc/akzul8h2WIRjE2gCxt9g+OYNIM0vXIJm5f7Cp80PMu/R+LZrj/TxpVQafjeu217CGFHAGi5Tszr9qG08VEfmCXJc1TNHgIcjPYoIOuY1gdo/ofe+dbVHI0cvZOHX6I+FZ4bqWXwFgxTJL9Hd+2+CZ8GSg2fgNtv7LSRkIu7AP0/fApIILMRjUHfywg7iLgkpyhiPo/r0CX+5Av3js1Ttny96Db5UCpHpfeIq8ZvZloUZTDS0079QoHqhXtVKuQQ05TlwUIMASyv3W1L1SXy+pYnDkzmOzromLKLUex1gxCB6UYPuBpkV6TuQ3mehY1PLNJXywLnVGMwxUdIvu4vO6GN047HKuhGZ4IIfRDqK6utysCg0vfTHg0BLsY6CxnkhBT1Q6+wA1sUBNBzClAlYJvvxyt4+NvIYgti1h9D1Tp0eSminBfboKZd56hpIxieB1UzvC7227ymVaWhrq9LzQ6EsJV9FMNDdShU8qT117nGb+OnMlLZC2e8IeMgPCORx4e5N7hO9bhCzDL7V1Tn4AaNWAQMLFsDv1FstJ0wbSk5KniMYyHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dTL8AhspFwWQ0WngwaNHoK3ciY0gZuKOK1QmYhv4JeMDyQ0ZKSjA63BIwp8l?=
 =?us-ascii?Q?eyxwn+l8HUyBFEqJRW2Snsf9yuly+Zd8OCbfuqGEnuFTjlQ+M7As5u0lLkny?=
 =?us-ascii?Q?HQY3kypVIoIY0BCJj8zBhH8vUs7SX3sFJ+hPbqo/KbLO/oooW2LxfMyYHqev?=
 =?us-ascii?Q?PJKgYJxa+SID7dBw2XRePtwQSwqAnnoR1CI1qeaGnVMpaC2ntGYEvBDa9K0H?=
 =?us-ascii?Q?lilFAWqYAUz9xP82VMUO3BKYWSl0tVqIGwT/my9UNWCbl8LO6vGlV9xiIz7n?=
 =?us-ascii?Q?NwWA+HKlRIfQ2bccbJRbZN3h8Vd1wNg/o9zJkJJEMHPi+fHv0aunyzGbe7dp?=
 =?us-ascii?Q?EhdGLrjyFSr5UJ+aYifJMJH+4ZhgW8RSp6L4NaBycNie3HI15oJcYu4kXgxJ?=
 =?us-ascii?Q?l3nvXPDeiaj+7n8MoOTPFxq/Rvuq28nZgbdu8IZ0vfYfVA99IYB+sUwZibZL?=
 =?us-ascii?Q?gI7Mi7JHaRTfsJeP4Cgvq1jAfrh6XN+s9tpwpwanGdrD6712ORrFZ9GSeiBH?=
 =?us-ascii?Q?3G9CQLkorM50p5E/HfuAzd2chmGlxfkrevAYDsBHx4R8h3OorVptlJ+VQMzT?=
 =?us-ascii?Q?Z8nf25vwFgodKeBWMUcGyoJitsuw7wRc658Ab1imGwjAvUvUOu2RnUp3RXp0?=
 =?us-ascii?Q?JVxRREHia0BKUekosQ4GmnQW6XqvtAUB/DIReWKVlugu8TeQVO/3SBrE2Rhu?=
 =?us-ascii?Q?Mj3SBcAWuDQxZWQFrvR5204B8kr4yjV9MbCpjqaPr6V5JKVDMsjCfbUnhQ8w?=
 =?us-ascii?Q?3uBPWQcA88mTIRuk7Q0SdFYgMwMO1uxOL7aU1OFrhTXhtiTulzIzkx1zVpV1?=
 =?us-ascii?Q?V7XlI9U4JmgLYhrkkFz78KPOu8JiTdJDBrgDKiN1SRYLCu+y606Sr5Or6vMW?=
 =?us-ascii?Q?a2sEC6q6qutuQMt4j0veBxYTBVMcWVxoM35UR6HJ927kLnIuh6ms2VNJK3bf?=
 =?us-ascii?Q?DhDMczNt0rMaZu9SAWTzGHZzoZfIRxJr44kyvDkKfeV7peRymXZq6fvsEei+?=
 =?us-ascii?Q?XgyoVTGr4wDwsfjZGME1PKE6+k6u7HI0zUbE/gEg5uA2xo8SWwy7haP2mOqB?=
 =?us-ascii?Q?7640ZGPwxVutHUOA+Tm6tzUbPWTyS2ggEa2Bvr9RyI/vq4bBlUmKDb7Uosyj?=
 =?us-ascii?Q?Js/UY5PKiPexQeU1Q926ULKyS9NAGKrpzpO8DohGyQL3CX8BaDzwqG5mz0xW?=
 =?us-ascii?Q?63Epv6U6OvQEMUR+lAIZJ89Qe/HXefhqjJQVnw7uUoNVEisSm/E9kh4FcCf6?=
 =?us-ascii?Q?HBuIolUjzcMIrEyoZAOSt1uOFZm5kCyeCjK84lCwnmL5vFhQVy8ie6mewA21?=
 =?us-ascii?Q?zaae+MMNRr1orqKpjwKM0fP0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 928f602a-015b-4699-922d-08d8d42dcdd5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:06.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DNASc8ppE80QhaRF3NvgIJapsQLLREQBwryihfAj0Op8Vk6Ymmey79YubtAgQv5alqYqmgw07w3c0+MzEqybVfIhIwzIQ3gsQEzWfQbQSlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists the later half of xfs_attr_node_addname into
the calling function.  We do this because it is this area that
will need the most state management, and we want to keep such
code in the same scope as much as possible

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 165 ++++++++++++++++++++++++-----------------------
 1 file changed, 83 insertions(+), 82 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4333b61..19a532a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
+STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
@@ -268,8 +269,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
+	int			retval = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -320,8 +322,82 @@ xfs_attr_set_args(
 			return error;
 		error = xfs_attr_node_addname(args, state);
 	} while (error == -EAGAIN);
+	if (error)
+		return error;
+
+	/*
+	 * Commit the leaf addition or btree split and start the next
+	 * trans in the chain.
+	 */
+	error = xfs_trans_roll_inode(&args->trans, dp);
+	if (error)
+		goto out;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_set(args);
+		if (error)
+			return error;
+	}
+
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		if (args->rmtblkno > 0)
+			error = xfs_attr3_leaf_clearflag(args);
+		retval = error;
+		goto out;
+	}
+
+	/*
+	 * If this is an atomic rename operation, we must "flip" the incomplete
+	 * flags on the "new" and "old" attribute/value pairs so that one
+	 * disappears and one appears atomically.  Then we must remove the "old"
+	 * attribute/value pair.
+	 *
+	 * In a separate transaction, set the incomplete flag on the "old" attr
+	 * and clear the incomplete flag on the "new" attr.
+	 */
+	error = xfs_attr3_leaf_flipflags(args);
+	if (error)
+		goto out;
+	/*
+	 * Commit the flag value change and start the next trans in series
+	 */
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		goto out;
+
+	/*
+	 * Dismantle the "old" attribute/value pair by removing a "remote" value
+	 * (if it exists).
+	 */
+	xfs_attr_restore_rmt_blk(args);
+
+	if (args->rmtblkno) {
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			return error;
+	}
+
+	error = xfs_attr_node_addname_work(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
 
-	return error;
 }
 
 /*
@@ -955,7 +1031,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -963,8 +1039,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1010,85 +1086,10 @@ xfs_attr_node_addname(
 		xfs_da3_fixhashpath(state, &state->path);
 	}
 
-	/*
-	 * Kill the state structure, we're done with it and need to
-	 * allow the buffers to come back later.
-	 */
-	xfs_da_state_free(state);
-	state = NULL;
-
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
-
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
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		retval = error;
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
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
-	error = xfs_attr_node_addname_work(args);
 out:
 	if (state)
 		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 
-- 
2.7.4

