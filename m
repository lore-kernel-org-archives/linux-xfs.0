Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F15FC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E04B61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhBRSpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTAG9155835
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Hz8QgiQIfc7DpwjA2jhB4veFUU5HCGuu1viIPYVhSNI=;
 b=cm7w11UPZ6+4VluivxS9NiLO7a0L3SkDCfPU3OlbyOMgHz167qUJ+URAYB5yoo6iKGH3
 nVIyC5L0h/JRQiAmDv+DwM1OQvzPoESpsux+i6vQBPGxP8ODysfT4XKZhQCNPW+z2AmC
 KRyVXN7YtqtNPn546muUpq7p5apGAJ9GT2ZZmQ0BIK1yOnwT5XQJWCAygoOdhwM1xUi4
 9XrMhg6N0jHeL277jQCOJnT2RIX7lzfRm22PdCAuzb1+SlVVyNx5TH1KDc/dZNoUJuST
 GnHsfDGtz4lEYqrGIdH4Ibt5ZTWgJUJ9rBATLyhHp36NL8O378ODO8PXzsBBePkFhdP5 Ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r6m4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCaH032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPydcWnMUvFzQ3OcBmbYONarTSUAQRjz5Apx5AK1nA5YxLLPMFFyDPGIHf/T0uHd3zWIWvwIQ3MaO2eFrDFkYL745dCcz3eLIIjL7dF53Df8iRn5hK4LyPdunp0uEnUqJDukVxvQapjUfOmIIUJqUi+q5rHz7cu7vfjncwKu4psqFraFmfdFak1jRRYp4X715bpLpCZhVN73hJCYm5FQaICHWuDrV81OvH+EtaeRwCc2LdCnLrEi1nSF964Pms7b5zwBZutGsRqNizU9pB2wzxvHOT75jR6FEbCTbVKyULrMl+NGXtxwHeS81mGrlaAjH+RKpzlwFH2EBejF3AGy5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hz8QgiQIfc7DpwjA2jhB4veFUU5HCGuu1viIPYVhSNI=;
 b=Q+cwjYYpVmih7XyUaSdaQE3yzT/XAZHQIHTNM+haThvGLFbzLWlUvvnN4hpELGeUdeJ6A4Pf/U0N8HmQhsVvTUi/vwPOwQgF74hsLlK/n/oAgrjhAxGzp4ZRcE6Qfz5JnqHwYOx9bxRNd5Q1baAQoEplQGWtG5tZVAt5GkATcqH9WXyRVRuSFX+D4xt0PV6o3ymun3+5jzkW1Xzv3Opv0T1ef7HvE3ZgONy0q1+4/zMRRJU9HMvAH2zBt1fdZs0CAtmS/aYqJwLsh9YPWjGbMBVC9L4xEcAGZRGNFuP4sP26ZAzmtynYYcG3yDSYCn5qgD7/HPjNt92R7sjdrlpCaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hz8QgiQIfc7DpwjA2jhB4veFUU5HCGuu1viIPYVhSNI=;
 b=v74QIAslCoCD8SlYInyf//Tc701jaLTzLwKd33mHxe3pvGiBhde7dtMcwiMYOTFs9bQP/DHweJ9PCyQN5yyv4B9VCzYPRlm8B8I0QVwIbMn6o/91BGnbgYsMf1wriFbWsRlfxcgaKKIVCuNuYfwEgKX2Wr65hy54LgdsAMfYn4c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 18/37] xfsprogs: Add helper xfs_attr_node_remove_step
Date:   Thu, 18 Feb 2021 09:44:53 -0700
Message-Id: <20210218164512.4659-19-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a0863a0-99b4-45e1-2c41-08d8d42c9f83
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4290D2BC28827D16BC390D9E95859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:233;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dv2c2VVLkpl2wBXmZ5x0nfd/GcW+4nrd2YhZWgPY0YASzALwdzsAgKQl1Rfx3juVIS1SdKiT6r4K35VIpMu7R7l6qxgQTlf/CqNvR1PYPAEoJzL/DsSnT3WnMc4t6gbUOkgzq4BHZEuhfgCT65Ht6L9wFU9Ll5M9I9/tVxx6JNKp1dkfHFKZMEwdH+7u8WJMwkaUGhYibG3JBPJPX5YFcrC1IVeye0uhKx5NcMlmsBD8qcHiUn1cbYbjdCXd4SyZ97pkNIMde8svtyFhHy9MFeYWvGjY/89/po0ZkhF2AXPgAsFu9p7JG7R2u+0x1u14yk15+ZTI/qfEY/BrynaQ+1TwspAj2a0Qqkf2oxeWyYJKzfBm0lyzVHBS+ryJwI9YkqGZTSriSXwQ9yxVdAg8/lgWWvEU7g17ygfZ9KRmmmTl8x937r/0JhqkuNscefJJmXiwag5UQzhhEfM6JObEftTQZryKcwkfHEJ2kyssS9G6LT8XGpiO9ZPo1fk57GO6PrDoYbpB2jvXUDtZLFY9HyjIQ+eiexVFTAZqRyFjJJC3u/Mz4Zd5kqISOvPax4fAmBOiBvrZEkUegYApBrpf8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(83380400001)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZHWIKANiuZcHMkKljh9UInJ4rCbROFV/C/Y7NaEl0DAXW1H0Y+SHPf5ASAC0?=
 =?us-ascii?Q?ra9WaroTSODFi2fCMwMSqbUOKIlX3YFiCXc1agz0bexMDxfbuY2yuMXL27oa?=
 =?us-ascii?Q?q/ltfgO01xLt0rP4weIkQD5PGDV8hEWnJUFOr2w7/Gmamc9eDXZVNsPSZKdy?=
 =?us-ascii?Q?kcwBYo723xPIbh19rS0Q0tbgtaOuLud88+Rt+crhkSvslYRYaW1AXkXCce+k?=
 =?us-ascii?Q?NSXt2Ka6yaRHiuiwNKtqYJzo+HOQcJcNUDHneMFAtNgxolg3U0vWKqxpHqEB?=
 =?us-ascii?Q?W1qbht+joMyEiaTnrQivRJnAFqb3LA/Ki/mjdE2VaPdywWJghAk7gB8CEa+b?=
 =?us-ascii?Q?scxNSMSkDvOzClmzgc7MiRa4dH1kw3/MqbZGigVwqSF1v7KV67HDJIlbKCpe?=
 =?us-ascii?Q?iKW6HvMqfoIuifVCwrdgER5hNp30LU4BZAUDYkApbQi3AEiWL8WgJAzzM5+K?=
 =?us-ascii?Q?76zM0QzpfQMKnfvoLH8WeV1tTL3nfoNzMMJ4yyDYD3iaca8UnFISRI4Tv45P?=
 =?us-ascii?Q?KRpNuCIoywX+TNJu+oMi6zld82pgEM27UOAaeC+uBSwA0U3Xl2uG1cYqiGZ8?=
 =?us-ascii?Q?5qazMVSjVs9nK74i4P5LDIz3CDH2S6U1eUTwmMYoiciUDWtGTRQoHIiYrBgp?=
 =?us-ascii?Q?P41NY8wPjy2riJIBjRbaTAcSW4yVisUr4G2QtOAMQ8o8qWcPkIb79ZG4gzyh?=
 =?us-ascii?Q?v1vvT++g0oljiL2hJp2D1rwYuJ/U8Dak7+76ux65DT2AhJa8IAT3BMPQhWhj?=
 =?us-ascii?Q?NcmM1SppdfBSivHiBSDiXtfqrSTtxAy2SrH3k5JHaPPrmwCSe6RUDQ848dEb?=
 =?us-ascii?Q?xeBCiXLm7l9OE2cJoec1OZ8zdFSvK7ByPdVThSuC3n9K2hgTtMHPyRvvHMEz?=
 =?us-ascii?Q?1meRKk+ffEuoNtIbVJLvpkUhtyf953FxD4CFkEYn7hXXA26+cxZp9dtirAj8?=
 =?us-ascii?Q?JpmP4PJ6EQs50QUZTrBjYJpX/V8GgS4D9RMyu/e1nnVZmN2DrRk1Ysev4Qfm?=
 =?us-ascii?Q?bQ3EK2vFBMXpy6fhcRS0/Hr3MxDC/oBYoAj9peuPtIY8EHZqLrWZUEbUf3qh?=
 =?us-ascii?Q?P2XvYdqx3rBrjqiVrKGDiv2MExtX4MQri8N7dxcK4G0atctHpK3pVKNCrb8C?=
 =?us-ascii?Q?KBcZoj6g+kO3cQQezHgDN6yE9PblAN/cnZMiaqVhuRq8ma9vHrjLkPxIcZwy?=
 =?us-ascii?Q?82kCZ98pH97HBK6PLP3scNtmEpE0rh1KSwkZ+7BtqkpY9zXWWXDT+/6ZESDl?=
 =?us-ascii?Q?dxLorVk76F4EtNyJqsT1jiFUddFYIK12A3JJU1hNZGmR4L+UlILLMqQsaiRK?=
 =?us-ascii?Q?0e7DYYPR9v2z6aNb57XiZLsk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0863a0-99b4-45e1-2c41-08d8d42c9f83
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:39.5078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSLCbr7pn1W505mB6Zcc4oVKQlXj1xsx9oWgCoJsl42lPI3vxiAPN7X9anmL/Fm8wARXpnikzBHiG/DhxbvQyIQONUTfBvWYU9nU9HHADiY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Source kernel commit: 5e2aff99f8f0b7ff511b7bbd1213743f59806878

This patch adds a new helper function xfs_attr_node_remove_step.  This
will help simplify and modularize the calling function
xfs_attr_node_removename.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 237f36b..bb3d2ed 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1241,19 +1241,14 @@ xfs_attr_node_remove_rmt(
  * the root node (a special case of an intermediate node).
  */
 STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+xfs_attr_node_remove_step(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
 {
-	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
-	trace_xfs_attr_node_removename(args);
-
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1263,7 +1258,7 @@ xfs_attr_node_removename(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_node_remove_rmt(args, state);
 		if (error)
-			goto out;
+			return error;
 	}
 
 	/*
@@ -1280,18 +1275,45 @@ xfs_attr_node_removename(
 	if (retval && (state->path.active > 1)) {
 		error = xfs_da3_join(state);
 		if (error)
-			goto out;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
-			goto out;
+			return error;
 		/*
 		 * Commit the Btree join operation and start a new trans.
 		 */
 		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
-			goto out;
+			return error;
 	}
 
+	return error;
+}
+
+/*
+ * Remove a name from a B-tree attribute list.
+ *
+ * This routine will find the blocks of the name to remove, remove them and
+ * shrink the tree if needed.
+ */
+STATIC int
+xfs_attr_node_removename(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state = NULL;
+	int			error;
+	struct xfs_inode	*dp = args->dp;
+
+	trace_xfs_attr_node_removename(args);
+
+	error = xfs_attr_node_removename_setup(args, &state);
+	if (error)
+		goto out;
+
+	error = xfs_attr_node_remove_step(args, state);
+	if (error)
+		goto out;
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-- 
2.7.4

