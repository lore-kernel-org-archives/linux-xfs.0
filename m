Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DC8C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbiAXF1W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:22 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2340 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240794AbiAXF1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:20 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20O3uFvf019292
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ZpTsL0GDDNZIm9yYFGLwP/lj2vj5e9h1cr0Hp44p2Rk=;
 b=VmY62k0MHV+2oFCOvS7JpQTOrokxG2q6L8XN4+b/dhnabKYyV94gYWW5UCTFsHIMWaq/
 9SE9qurfmdxGgMQi4Kgcb80S1rGyhHKxSWfzUcn1pL/Uhg/YkZVi7eu5YLZln4Y/BXkZ
 /PcePT3Qz8VFS7WGSe3wUOGUzy4j4AJVCzBCj8urph8VkB1NjgVRYeDj8UmIeC1Ozwkb
 X73+rKxMQmtxL1LsPtgwAdKali63DfgmsIVN2dXngszDZulZRCaomkxvo3yJ0oF+2J2h
 dBtbXv8CzCvLnkA8ESw3fdqwxCVfbw+0rWEAXgf0pISBX8SyIOO4FqQKW7JnqflB03MO Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3drafub3gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5Qr8L087767
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3dr71up23q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXYZv9UwMLsX/8ZVdFwpK95w4eW4jiogtaFjxE9eWfLMN2+yaji6UwYQRUBw6g3wtclAKSBNRJ49ceh2sI8fGa0C0VB6qH8g1vNQsmJQqyFoYJc9ss7Uvd828bnn4eD21j3xTZ1bWJOwHxL4l5jfQXe/X6og+ZK94N4OZYnY6nSWsGQkKXaiYhzicaC56Bn6CgcYawPS4yyqm10WWG6fjc4gtDPkFMbe5uznbXxQKyFUphYzyduK5wg7C5el50mKaoBYCx7WJliNGkGUR4dvJ2lZA99DTQeb6ehcHDkSz0nA+njJxyUrDe+8aWFezeycUmUxF9S+w56vCSTdURJ0hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpTsL0GDDNZIm9yYFGLwP/lj2vj5e9h1cr0Hp44p2Rk=;
 b=PypvCB6sghsFgEta00glUrdNKUbnnhquFW57BoyA4ydFznWXEEI8Ak/gposzLBw5ap4N/worJbNyR3j+v1ICzNrtyupo+eUP8Nj9QpDb/HQgX8dOxybaD44XJQRECRkSXcA/unjZJSzdEhr7JDQYp1f/KUbEmqUYctjv44xrOueqy7wa8uDX+Cs0r7SbAQZQftB2qNIGd2FccsAQgXW+JxYhmjQbzAXdBA/wX2wGggHAbDyo37u0X7bxIzFlKPqayNwqy5EKiWs3H+fyqiLnkojf8PJHM3pNb4ilUtDmRy9hioDkQ9aGiAM5EFTINJTs0o8gj0JWbF5v4ydlYb6rjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpTsL0GDDNZIm9yYFGLwP/lj2vj5e9h1cr0Hp44p2Rk=;
 b=gGORnL4EL2nncw8N/ZGpRAbg3YXitmfFYBGZrgvtvfHZUB7lPhet6567GjiZDTg5dJiYYIqc0Y3HKH4briQlbVFVv95BlJoYg8DKRd5qIJDexPXVU8zAgNVDI8dC668A/4MqyMJzFZ7OfXxjB2Xg3gljKYqaN56Uaj+vCO40j5I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Mon, 24 Jan
 2022 05:27:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:17 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 02/12] xfs: don't commit the first deferred transaction without intents
Date:   Sun, 23 Jan 2022 22:26:58 -0700
Message-Id: <20220124052708.580016-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8c2e7c2-7be4-405d-35f2-08d9defa2ee3
X-MS-TrafficTypeDiagnostic: MW5PR10MB5874:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB5874F2851D9FA16EBC8092D0955E9@MW5PR10MB5874.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L0IAqDLxu4nDsrLRLFyV0zLAHCUr6QyQKt0P/XrIGOHTnen/2h1MXBsOgSGqUZsokiHPp64YU+HrArKpUH2/OEaaB4+dedu4YyL2UCS1k5WzeK4lu9XhaegrHwILUEr2Le0e3kwgRp8ELt4y0pybYx2p/QwhY+ib9eu9g2xzRCDOEsi/xhnrQHPFB22uuWCEsIQaxUSpKGPfx1p9Tvv5YycCo6Fn37D/xxAU6vhGa0oz0xWxU9mOESNsIhyds5Je+DvIGtrcmCILASMstxIDGkYjW5+3znv0dT4eJ+8ej8U14azlxfRiu3tX7tq6ZBYafxQHt82D+CHxJuT9BUH9m6tt77/MYxLeW0/3puCfc4nelvvreF6fGR6gpAqol6vHmPIxfvE/6amlvMiYfVLPtrC6YcEGSbhLEvwZKee03WZigh5s3jO6uDhc2bd7rG7ulFpevQstlMqqayViJYLfP4VaUZLjodz7D675jlC0tNzhbtLNAlKE+olvwTHlA98/EvP/INEOk9lfbCOd4DXbDRlJTEPvLWf3xCitJc50Wd1Jl8AZuwgn01o76XCji42c6jqY2VjBee+L3q7ELxL9dhIQ4udeeuQXeLCpP5pEJpWNkmxZgmXv6ymcHUhmaSvyjgZ8f5ocO97JSTIjD311jrsAmd5MgjVLu2OZzhjaxFGeF9NpSSnhw+rKyy7RZ7xiVjUv+97xsNJldL5abvK77Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(66476007)(8676002)(6916009)(6506007)(6512007)(66556008)(6486002)(44832011)(1076003)(2906002)(83380400001)(8936002)(38100700002)(38350700002)(2616005)(52116002)(86362001)(508600001)(66946007)(6666004)(316002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PrASuKtx990YJU6e53ibIGCdr8t9MMclKgjXez5bZrdjgxAd6F+fe2+FOGie?=
 =?us-ascii?Q?qv1q8Yqmv141i7XSA+b53Rf1q+rz+GPq9aPZ6mzgYkK0g5yzhoPiyb1m0Uso?=
 =?us-ascii?Q?U1ya1/ePHnCh6tlysFNELiJMEgrjTwlDRlQdYq1h9aLodbFuwFPHDL9weVe2?=
 =?us-ascii?Q?8UD01nol+2FO5yqqRzh0cQ+N2ufbHa46AcQZhm1do71ISUkKKzfiA7HZqGVy?=
 =?us-ascii?Q?GunfAZTPjrjgkxy+I+eZNeHq7hqELwsH4Pc9mWIiZ9LRlvaVpcHJDvdEJF+r?=
 =?us-ascii?Q?XnqPIo47DKk5axGmRnsT7XJWoq9/p3W/KspHpax8mMACf/mc4fY+3DbI0IKI?=
 =?us-ascii?Q?aFo/rEl4qieuhp+NniWJzMYg9ZKVied9vWgIeGIwELv7+jNi5Nr8q4BIo0Fw?=
 =?us-ascii?Q?VXDbwNO5a+Ls9je+wnC+JyB7qQmoZn9t5ceU0YmtIjtVhsmeUl6/CVtGfzXv?=
 =?us-ascii?Q?Xg5trK/PqoT8rEL7MWkXv4Rq5ZO5LBLC6jx+k3PeXUslmkxUMlDBTinBvVq1?=
 =?us-ascii?Q?yWZjpOutsvKKyeWV7P8VUAF4Of8im47YbXD0SOXpUn9kPm5PatsVl9Z5tANN?=
 =?us-ascii?Q?iZNdCv359fTjTokDR/UCcpPZ4RWbWlO7xKsnAIqtYax7VW1eM3PjuImrI1NX?=
 =?us-ascii?Q?sZOsKFTUjz/jrzLQXkL7Duxz1ccSOA9CiMGFX62EIl8cdvqIK1C8UydIhxSh?=
 =?us-ascii?Q?PycdAAv1onLBAK9EF2YpW0BZQlySInR/cuk5C/xr0RZx0PgJ9AktfzX5FA6o?=
 =?us-ascii?Q?sjbOscPdgHsyqgjw1/jhy4gSkQrXgyEkZh3o5g+c38u3emJq7YKeqhbhO72W?=
 =?us-ascii?Q?EyUUDezp7wBOh8Orm6DPqDNxfHsuSN1L4l1jaYFJKLO1VWbU4PGinTO/3xtO?=
 =?us-ascii?Q?wddYO72JlpIIE2WMY64xyS/zUS6E8OqU511uRXbwIMYRQnjTIUX0a5s8aptC?=
 =?us-ascii?Q?DnxRJdg+gf9iLNp8F9t1isZlU1yQljgkAE80hGCu+SwCBAr+VkZEOH09nhH7?=
 =?us-ascii?Q?oB8iaN52n0KTX/6c2fT0SJrQfZEUmQlW/D+91GM/IT8ggPntUznK6BeIAty4?=
 =?us-ascii?Q?aYcJG7z1UzEnzq1U3BY7AGuwb3HcRvO8m4HqNYeIGOIsjhf9Z4bKLUJEXZXO?=
 =?us-ascii?Q?RlLRMXPWiJXa0OOz1o/xS5h8tKdJ09u2MSDS67FWTi6KMQZwFYEgCXGKgJH6?=
 =?us-ascii?Q?7BFr/7lD1hTEYXjw8To/Rhs97VFvQvZPokLrJMRJVkm+5Hu33uprzBhOm2RA?=
 =?us-ascii?Q?LmVgn0xzm1lQ1No7LJ4cNFquzIUNbv6INe7vUGVGnPZxvBhZqyQR0vOcE+99?=
 =?us-ascii?Q?VBD1a3bFtTaZak5bGpeypEpVKceNae8O2V65vMdOUS0HVktZFcrh/KeE3grB?=
 =?us-ascii?Q?ZNgPJXzOtzKknAnbNbyGwmExJRCiWQJDi2fDO2YKsSfdIsNtF342lDEcDaWN?=
 =?us-ascii?Q?Bn9kxW/4oZv3+6LBdlg7iPwGx6t2D9nUlPIwGwiPwzAFt74DjDkUpzhAsZiq?=
 =?us-ascii?Q?8Fwu2QOw9opcGrXcYF1AsrXOyJk+O4+Zt6Xr/twLhJZndXP0UNiASNClZpxs?=
 =?us-ascii?Q?LGlhsk6PsHpUPLSSLMA3b8eBgy7EUVMwG6MfIqeMYtBS4K47n5LQCKZgxwSP?=
 =?us-ascii?Q?D16uKdetq9wQtecF+ANTjOm13yXDKHky/qoTISDlNpRmJkxtuio33Tbb+azQ?=
 =?us-ascii?Q?/w5Geg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c2e7c2-7be4-405d-35f2-08d9defa2ee3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:16.0874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrkLlBiOdV5JdLYvD6QHbS+orFd5BPdxam9zEak6DB7T6GX4fFDeT7cc8ej1p9Vqap8/v74up+Wk7I9YBqrP9GXMTxMCKfRa7cgJQ+FTmsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240036
X-Proofpoint-ORIG-GUID: 5vUGx7y1UVP48FondABBKZVp15NoKUK9
X-Proofpoint-GUID: 5vUGx7y1UVP48FondABBKZVp15NoKUK9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the first operation in a string of defer ops has no intents,
then there is no reason to commit it before running the first call
to xfs_defer_finish_one(). This allows the defer ops to be used
effectively for non-intent based operations without requiring an
unnecessary extra transaction commit when first called.

This fixes a regression in per-attribute modification transaction
count when delayed attributes are not being used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 6dac8d6b8c21..51574f0371b5 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -187,7 +187,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 };
 
-static void
+static bool
 xfs_defer_create_intent(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp,
@@ -198,6 +198,7 @@ xfs_defer_create_intent(
 	if (!dfp->dfp_intent)
 		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
 						     dfp->dfp_count, sort);
+	return dfp->dfp_intent;
 }
 
 /*
@@ -205,16 +206,18 @@ xfs_defer_create_intent(
  * associated extents, then add the entire intake list to the end of
  * the pending list.
  */
-STATIC void
+STATIC bool
 xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
 	struct xfs_defer_pending	*dfp;
+	bool				ret = false;
 
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
-		xfs_defer_create_intent(tp, dfp, true);
+		ret |= xfs_defer_create_intent(tp, dfp, true);
 	}
+	return ret;
 }
 
 /* Abort all the intents that were committed. */
@@ -488,7 +491,7 @@ int
 xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
-	struct xfs_defer_pending	*dfp;
+	struct xfs_defer_pending	*dfp = NULL;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 
@@ -507,17 +510,19 @@ xfs_defer_finish_noroll(
 		 * of time that any one intent item can stick around in memory,
 		 * pinning the log tail.
 		 */
-		xfs_defer_create_intents(*tp);
+		bool has_intents = xfs_defer_create_intents(*tp);
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
-		error = xfs_defer_trans_roll(tp);
-		if (error)
-			goto out_shutdown;
+		if (has_intents || dfp) {
+			error = xfs_defer_trans_roll(tp);
+			if (error)
+				goto out_shutdown;
 
-		/* Possibly relog intent items to keep the log moving. */
-		error = xfs_defer_relog(tp, &dop_pending);
-		if (error)
-			goto out_shutdown;
+			/* Possibly relog intent items to keep the log moving. */
+			error = xfs_defer_relog(tp, &dop_pending);
+			if (error)
+				goto out_shutdown;
+		}
 
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
-- 
2.25.1

