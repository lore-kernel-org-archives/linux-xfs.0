Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFC4C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F4461B5F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhKQET2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33714 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233009AbhKQETX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:23 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2B8TQ030343
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=qvEYPhoFK9r756gctj6npIhB53l0SUSOsw1nSpSzRLU=;
 b=LM9BLiw8JS37YbrTGyC6AU3PM/vzhx/wD6FMDOFFMqHrCegv+2Y3zbntRYFPESwLcFFo
 gZm5vjW7yv0AEGzkMDxR9+k9gYc7t5Z30zs9BPAPf7DFy7U66QCg6eCYrOezqWjVKr42
 QNHfa2Mn0R4gL4sq89+qgDozyWJGQRZo61IAv302DB21WaTRHBQm5+tsvs/XJSYclEFX
 CUFOZGnXxGslZs+OJ1lGWM0eqP3OW2SDPSuleLT4Vyn/XYqhUU1QXqH0GlVQc/iB2i6x
 dZvWwfRXVCq4kkiuS3oBdFoCyKEv/Xp8ITTT+9F3i/wgUmsPxQzySkjxru49yc6DOfop +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnwx81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKi180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAmC66f79bYCuKpLtAU8sS4zLkND1y7SAZLjfE0clKK2epjBfVX/l1/g9nWZeg5P9fTPjoR0kciPuSYQUOaFsgFZWnZp1InjlTTkTEgBe54eLKcLvAKL36J6f8ranpLnjg3fuNvw7H2y40W9Opt1IJ1QKplbzHS37mNareBNKk5sO4reRH9mmnzM8OH78o3sHWH6B2ON4KbsCKrkuRyIHypKwBHVV9EIf3izUqRoeack+J1iR2ihL9E7tZWQ8f3Qo6vTdaLVsE9IalfnSD5XllerTu39fbAb0FkQQ8ld02jyI6HGFKNULFrQnqsW94Vh2QR7uonRvHezgCDyaYWMhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvEYPhoFK9r756gctj6npIhB53l0SUSOsw1nSpSzRLU=;
 b=LXyE1p4J9s5LREB75q7YYq+QXFUmbEq2DApL/gR7GFmFg8XuP4wzj1yKU7MTZEYDsNDc5FQ04zLi0WQvVp70Dcg0VBxorXeF8pSJSsF4h/5dBvNpJTIDl107EGmdrqTEdlXQMQ0zWMdZ3YdD0wEE6Il53CpR8mX2pFns/RIfd+aMAwZxvYbwded59bdgHiOAg5V8KLCqVcDpZ6C9H+El2zrPMkoonZ36eawceIcf8ZuDRKIJTneG1GmIkO50IDUNPswxydVbpbUOYjhGXDV8No8lFby520arXhFoHyaQlnDuFReYq3Ewv1rSDSPgbNOhYO7zeO9ffW1c7b879Hjz9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvEYPhoFK9r756gctj6npIhB53l0SUSOsw1nSpSzRLU=;
 b=xQ4d/3sfMFtYEIDJu0cu9CuPCjwlvQIk2HVC/SlQXLSTnDGfhLVnILjp3V7RlPS2scfjEOh5KF15KsEoNFsxMdmqekvNTQDG1cRv6Mbtj8jvfe2BVYhIX7wUXJ7LSkiAXCID1qv/e+m5E/I5FBADviJHxoURPad4cjWzFwwNAGw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 04/14] xfs: don't commit the first deferred transaction without intents
Date:   Tue, 16 Nov 2021 21:16:03 -0700
Message-Id: <20211117041613.3050252-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b30ab715-bf32-41e1-9774-08d9a98102a5
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB40362DF8F6C32C02D6A48C9E959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJY3oVqbi4CT+kngxUTeHgQ50B3TuugblC3VDFTw93HhHIw3YeNyNxpPdGHiQLCyIVypkPgs0bd4rMt4PtHsB2KoO9ygmogyTuhWDBOT9Ea1Jtv2KuQ6h8PtKW49me/09y7H2n0F9RsdG7ZaMFcEmY8VJNyIDMKwE0CJHKkbZQrmwOZe6QhaTI1WO7PPi/HSgBLIfbhtL5MCeDE5Bng4lOZ0gLzAktcgN7/Dvtv/8v8w5NBi0mnYIyH/uYJb7HeKU6uMjuqNxzQzSYpArGXK0rbq8U9Tkcai0KP4dRBAFWo8VKqJW6EqPi8GLpSIH/WfmjYEb3vIs6Smr0FX/wBKwqd0HeREfTKzLY4NT7W2q3AT1QLBudCKwUTR7nEeHQtQWJC526NzNYqRzKDpaFK/qhLkfWotswRBVxUj1ghMu2WWl/V7SCOY0IiKMhU31wScYSy3Wp3qXzp0suIU0O9glfQBau37KVZvaek+ZuBLYg/gMrk/boOhHa1b2XEeAIDWO7Nh10oDcJzp6yqe1lZ7CODoMclfxLCcEZYt1hdUE6N23rIyKvetNq/+HZ4C30viPKD6qAKh7JJVKzPnRVlWBrvYy73ye/0mUvKKFwQXdYLDwkQviUqbXSOeEwVKRRPe+YxMfdpcSKxIBHR2ofDSXVikgrZW6TuJPgFil2ymWGz64MSrWOwvW5cPQw4ku8hYl+M4DnhaXbY0FFOHwihDbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KBj5bt1TkBKrnVma6mbBP26sR7Oc99El8OCXrpi9psNO1XXoNckFIe08rsoI?=
 =?us-ascii?Q?Fj33IG87lfcy/DWTgNiIX+Cu7fA863GBW4l/iNP3uNpA+MiqDrR564gi0QFF?=
 =?us-ascii?Q?3xzVao6h/iEbvq4DxAfmd1uHpnFRUuO30y/eGKgXyfQtvr0jP3GWSBHqlzCH?=
 =?us-ascii?Q?CQCFDmgxZKMqqluv2PpnvB2IG7W7El7iPMvby163Rv6PgNj0eGa7VX5cm1G6?=
 =?us-ascii?Q?b1467F6VgE3ULME+fbta22eHslvLKAG4gLIRkXOYDimlGuvWBpob07Ev7wvS?=
 =?us-ascii?Q?JBHoUTVPWCBosf5LtRviK4Qk2MCubqFuPWCItiSARf9glgaS4W78MHzpnFpU?=
 =?us-ascii?Q?erWucKlduueGkl3WkIRd31LsP9WbUHjV57PtAlPRzeUkssKBtMplpOxmICAA?=
 =?us-ascii?Q?legqdg6gVGe4wXUFr6iN21KggYS3KoLd5AYp6vOIJPuArlVZPFv51jFZJppf?=
 =?us-ascii?Q?bVIUQD2eUALyyHolCCPzgWnPYrf3DX+BuIktMgPkYYkchMzJbvO2OpR0QZ8c?=
 =?us-ascii?Q?7v1ZrS4JASDIUV3iAD8+OYw4E1iETfyKu4DZvH9osWlOZwQQbUw+qXNrrZIs?=
 =?us-ascii?Q?xyYyiMy2ASihYNXVzBtrq7QICPxijyPitjWekWYXDqN2fCShSyC0sRDQqnjW?=
 =?us-ascii?Q?tTbBJQKxVDKulkaurRKU7qP/tqwY0kOqeVWSglHSU1Kw4p33OA8GypM79ULk?=
 =?us-ascii?Q?q/TB9mpKAG0ncN9Y3DuQvYAXQBC1OKf6Tnr52k1JnNKUNDNzT0Y8QmIc77b2?=
 =?us-ascii?Q?CctAXK88hgfR7S8e3MUwzmWEAm3Ubga2u09qE7moQBeQZeKTuXBcpz1lrNI6?=
 =?us-ascii?Q?gDSG8F4Trg8S9mz3iuVZ+SMqZKrSQ9cAyQ8gKgUM41iqkSfajO4w0FEPr5wI?=
 =?us-ascii?Q?Cfk7yWYsqcVJRhumZIUK1+D/7G6aMsEbFbb/1+D/SA/J6xGoJKs+C8FFXaxA?=
 =?us-ascii?Q?IxforPBxQunRplqIlxqip/aRb7nlDLtoqDQZacCYD7P0QkPu6Ye5D1RWzs41?=
 =?us-ascii?Q?LaPX7/2FJxpwB/g3k9JKgL3YJf3sopANzzpaLSEy0dbb6VnADUm1svXGyOVF?=
 =?us-ascii?Q?nfF5nEk7o7z+nD8TTXMZC7bj5qDz8hjzsLDKgJF8hTubhRDIgsOby0NfS7up?=
 =?us-ascii?Q?FdZXYjU+I8/IKxoS8FrBtYgZtVqHEDw0OjdpdGsGawVDh+DXUw+S5Q385R90?=
 =?us-ascii?Q?Yg0uBclRLYP77LtMpl4XeNoE2XmKpWXo3Bdetr7CZeVxVyl5CvPvrvzl0z24?=
 =?us-ascii?Q?PLc8I1d0iKUpbhCmA+douqNSep1ahZtB3I9pi88NY8inRP+c1Fv1rr42xwz3?=
 =?us-ascii?Q?8DM9TjLMr0pXsYBOkw9KKSkKzT0lSk+kGIQmXh/w4ZRJ2F+6wUjBmvGbIlQr?=
 =?us-ascii?Q?0+/myNaysN27tm0WWjBaCgQq5wuseXnlvnjvjpIY+hLIXCPNgoxhz36DDcMP?=
 =?us-ascii?Q?s9ooFORWXiK5Iv6iGchFjw1wp4DeAyQCIEmCV7+x8xrz0M5faRYUs05aZ91B?=
 =?us-ascii?Q?2cosjkrxGy6E8p0PbOFCfS3oWTFzYEB+WAzIKG0IYx3pkc37JtP8+MHPVD0o?=
 =?us-ascii?Q?0ZdNeUTNFSb0c/WPq98SumffqEohg8YLJ7ynWCrV9kNoOmohFE8erYN2H66E?=
 =?us-ascii?Q?MRPLHgvFQ1f3DVHgk6jmV7JRhOrzs84lvnF5//7avYTvYDSdnqtZOMX071pN?=
 =?us-ascii?Q?+QFKNw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30ab715-bf32-41e1-9774-08d9a98102a5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:21.1202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmVG6AmFtRI036COE387xLEuXfsdInSGbdN/kgzwdzzvXCNgWejyvoQ8kVjqBCwh1QmfDW870lxDUI4HLyWHkueFGe+kH6WYITj0mt8y4jk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: yYZ-LmIvGXEI-KJWNLBBAfox8azTXymo
X-Proofpoint-GUID: yYZ-LmIvGXEI-KJWNLBBAfox8azTXymo
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
 libxfs/xfs_defer.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1fdf6c720357..006277cffdef 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -176,7 +176,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 };
 
-static void
+static bool
 xfs_defer_create_intent(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp,
@@ -187,6 +187,7 @@ xfs_defer_create_intent(
 	if (!dfp->dfp_intent)
 		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
 						     dfp->dfp_count, sort);
+	return dfp->dfp_intent;
 }
 
 /*
@@ -194,16 +195,18 @@ xfs_defer_create_intent(
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
@@ -454,7 +457,7 @@ int
 xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
-	struct xfs_defer_pending	*dfp;
+	struct xfs_defer_pending	*dfp = NULL;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 
@@ -473,17 +476,19 @@ xfs_defer_finish_noroll(
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

