Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D036DC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348061AbiETTAr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiETTAp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7B3DD
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KId7EJ028574
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=gT4z/dlKcefMxCVPjbOGob1ZVpzAe/GYx8+A9tJE7/k=;
 b=HMMURSIBittaKhXlg8/rFIZnaMnGoI8TCVlGAUOC+J79UkQY2DTnryjt6GgS0fFXwYrr
 3PsZalZMtXZCIyeaMP2rPQTDj08yZG9lyaOOWw9su28nv/mnPH6ZOyhCTrXNdX98Belq
 EEIbweu7qD6DcXkg5mV3ZVcnTkA9DE81eAZkqSUjwgeQu0H+EjOaCwFKL4FaYaXO9gZ6
 +9lUTJ3Q7NQVWOEJDrOBf1+vxw4OYBBfyiZ0IeI0XG+E0m/ZP3JGuYUzRBkBxQgGQ4in
 cAM/PLEn1ATqIDLRxBODohwLSbaFBe9rGJMxbojj5x58NR64XkheB1JUIbKDWVFPr2k9 +w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g237284a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KInuZP009768
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6rkwr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWik5kQLDPsWaqO6XUcfE1tbYhaZgXiHXPHWJe6Ry4hhgSsQgAnUJoqNPkkqzmspblUDMkUiCsWtrUgRl3xPCgGud2SQpTlqKbMXQ0rEZHIANzLMghkBnF8W/TjQojcmWkvQCGlMEe0KxegATov4a+Ak8k9moX+X2jImysplXDY0EwAfQjtz4BA2JDiOMtTvigXZncgM7BHTX9YHOMO6a5ycHrKUzd+M02tRk/4ZenMNY+qiWfpBQSEls0+AcuQ+jHoiqRZndgPEmjD6kNFAdbyHfl0g2vx8xF49Cg+KdzdWKqmLOror3tGRNV+e09NNXDUWoRulkUOqCy4zWs0J0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gT4z/dlKcefMxCVPjbOGob1ZVpzAe/GYx8+A9tJE7/k=;
 b=dJQ3ypbNXIM6p7P2GYV4lYNQ6GA7JpIPhECaVkSYJqp4N0+O1V15/dmW4kp/hJtuPrvNnEi7gHyYhrKKGMhmlWpySGPhssCiS6Ls56yY7ib3Cfrl1bEt475sORKkBJZglHmESCxHmzFA54ogXVYOchkh42aHBNueVV2Z2GBFQMMF7IjUjaLaW44f8UsPN2SjhzGKsltp5KGM1QewANkw7UosdgR+HikUoFHjTx0ZihMwZZEsfg6O1UutKY1eAQLodsf5Y9uDJVVKGhQxR7tHVkpETI9+Mg7dEpaOvQCg3NBLrUAG5dwyYaaum6a3hVkdZv24v8k5KufOItb39Q6Xmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gT4z/dlKcefMxCVPjbOGob1ZVpzAe/GYx8+A9tJE7/k=;
 b=bV+/9pOdkSmny+cDnyMpRws/ZF6wghQAlHGoZAXkyLB7ELWTjjgXh+W7rhJdZ30anAfOEWzLEKHH4Ij67uySkS0Bc1l2jMwOi8S9VccyHdA3IGyXt4rtJrnwML6sjCVhkFlE//8OUUEvwsHZRk8jg+SpR9SyWeEIwXO0FTLhsdY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 03/18] xfsprogs: don't commit the first deferred transaction without intents
Date:   Fri, 20 May 2022 12:00:16 -0700
Message-Id: <20220520190031.2198236-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3edc7de6-2bfb-4684-6361-08da3a930734
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658F3751FE2724A3F7CD35595D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f28qn6bilkCZvaceTjm2SWD8kIniiXXfsQdlEaIxUkpUzPwDMCaMVX+MKpqxRO2FGCe2+wrF6W2xbDIG5PSPKA21CsSsaYmClpClH5L56eA6k0WopRUB3O1fwaKcyNWv3TI2KDj9GdmYI7fvHivAytDJqpJWVsaTrgDLh0mYtPBYaRqIZVBbh+a8UPwpwSWOtW7cUJesL/LaxJBlBXztkAWZfchAhmmaai3eiMcAe1bJZuqRqk86KThdly01olzRZRGo0mCsq8+TznufofIR+TEgw1cqPuC0h+YaPvQlDyT97kmF8O10QQklCcUAsXRifibGWsjT6UE45WRMfYTEZ+no5yQCH03EcS00U8ak437WeYqD+9hglNR8zlqyRyBN03wKqGJyJtDhFF9aOE/1hVqETQ5DaW+BEJU0AoKVVAurFT9v1y1bv/823QC/E+KHcc7F6m6FV9LmOqUM6bR/1beVSx1Lz0MPV5qkj75GiVpocg4BnkT2zYnv8zI+3BUjIyLTqygc2DR/kMHE7wnRLMhx+3N0xjG4fFgPsY8NMOFCy4jRR1DcN+Jsx02Rfa1klmzI8f3ruFnLG/N9WLG1KDYzGOgIuXDL3HfTXZOUvBLce5Q/sc5Kk+xtDbSRRCDJRda62VvlZB+gM/hqqiBi/S5AA3TUiDPUQyHV96fq9u3q+HBgPRfKmOusYlLdz7xE656yiocBpdoPhazSUVO/cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wZC8fl4qDi0eHq2zALWlolw114l3QOiOAqFcNbSR5ovLYkNFY/j1fQY8wSxw?=
 =?us-ascii?Q?C8G1N9F4cw/UVr3nCW7NKpldAdCA+DMlAfTAQuZz3Hhyn5Q5REhq56tDuIBz?=
 =?us-ascii?Q?ZsKNU3JiiBxmDOECkjUfO081pNUz51TfG3VDuf6P/szzNjtqn7AUrOBzs/sx?=
 =?us-ascii?Q?/Oozn5H5MGmDSGbJbM5mgCgEoCTNpOKMHIL7pTT/PvLjxDuwiyAze11/Kbgc?=
 =?us-ascii?Q?Jt7IIDxnzE5TU1iRuuM94Soi3ARg1G9zRUkMUttcS+zsWq1W8gxl3KXDP+pq?=
 =?us-ascii?Q?Hg7y3+AMl9nngJeCvYwVEeZ/B/NjDKk5JgVzncC8EaAuqBv1edVtfsJbrJ8/?=
 =?us-ascii?Q?8RHwU2LFa64DIcbHCjjpk77O+54JXBP/YRIGxLS6aHKeBvN+ZXshHBwdiPeW?=
 =?us-ascii?Q?OhjWndaZTr6Ejbq99D2NOqN78TItw6FQD8W5X1HSDSmex2GqHg1U6b4S7T8r?=
 =?us-ascii?Q?zNfQL8CMk0tUSF96KpzpvEz2YflzQ95gN7dmdZmilZuaJftihtg7m+rUY4x7?=
 =?us-ascii?Q?rogsKjyTdMZQEgLaBog4F5kKq/ywpRhniIDO8U4grt2mpw9NsxvzIJWH0OR4?=
 =?us-ascii?Q?th7fn+0K8sKgh0u/1wqR03eGcfEkFXVVuNvu9hjVZ93i8CmqzviJ6bFt7Ikv?=
 =?us-ascii?Q?MO7gKebWjvh1PC+/CyyNfyljTVVNEnirWHq/OJNG5tx9BHLnSnnEQ3mIYDVZ?=
 =?us-ascii?Q?fmAJLhuRbZ+fz0iNbnqjEr/33d01syYCJp5pQgplMBtygI7ujlhNIJRl/5n1?=
 =?us-ascii?Q?32do5T8D8rD7goLZmHkN+PyDou7Zn+nBSr26/9zwNj30W8LsC3KO+iiZSXu+?=
 =?us-ascii?Q?eHw29k6Z44CyAzxjo6X87S67l5f9OQW46H/ngxIVS5PtwEVDh8SXwLnsYLY9?=
 =?us-ascii?Q?uGtbHIISWoaH25N4MAXPXE9nv/w66U1OEN9WPFPm1yh+J4W/rOMO1qT4DuRC?=
 =?us-ascii?Q?Ks34fgD5UG11u72uzqbHZOT/7AqSWh9ZeOS2kjy1gpHrt45v5KuxAn9PnS9s?=
 =?us-ascii?Q?jzd9MRj/NNr1eR/2VHpq7bMPAsjVFjy71N3r/qb1ow/T7RJ5SbKKv1xrA9oI?=
 =?us-ascii?Q?x4D/N6t/Lh61LCQszwNSvA8q1yooJRswWbYXMGKy2T3QaQMZLakxxTy29gSy?=
 =?us-ascii?Q?N+RlVkJ5P4dHH/vbPdVj7o32O0eiZCrh2u/2V8utpdMaCwqiX0j6nJ6xs1Zv?=
 =?us-ascii?Q?JXUAnu3Ds3h+mzfmZ5W6ieMwhvy+o0qpmh4k3zNRa3SLT8o0ldhYSM/V8j+g?=
 =?us-ascii?Q?fWgPynWczgfQutZnliRes5Yobi+7DSqlS5PYvIJhz7zM4KvmUyQl0AzWTJk0?=
 =?us-ascii?Q?Btc8DVH/gd7uLKcFlPBxH3uDnicnHB/Gq/zRJtaAowK5d5PCJF/XX33oaaYD?=
 =?us-ascii?Q?iekjYfhZe+9feaGKFUstzMeb0zdoGPQ/5HZcy9Cu6qlN2VuntqWgE/Eb6th6?=
 =?us-ascii?Q?8XCHM2+F4wwU1O4Lk/fv0Wtf7d/2y7dMlCiYYW8g5cns/i+dr8uRppZEebB9?=
 =?us-ascii?Q?eWzMH5AsbAlMtdTXpGOmUc68sU7lREG/jKURSjwYQMZHPCRykk1t7bzpmSre?=
 =?us-ascii?Q?CcJwYanniXr2S+lv+np2S+2lLGJs5dZzR/EjUcTjgT3u9bYy4zmqmiJ/GVFl?=
 =?us-ascii?Q?7m2EQXI1lwHrktDWAKyPRMcF4R0vzWXIUVlsJn7GLiAdwMI1s0SUNJzGYREC?=
 =?us-ascii?Q?CFkXDykYkUCrGf+1dlGAhIaEW6y/QDiwTgAfCHEGo6v8/F9t1D6fN42BKKFp?=
 =?us-ascii?Q?t+dP7QsBEwDORSRNEttNy8ABeoDDZxQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3edc7de6-2bfb-4684-6361-08da3a930734
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:38.3385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWGysjBPHH7UVfKVvCdwc4PwdbsHxLven7IxD2v/yx3paRUVNCJkcrJMCtLe4ybD19KUF+hHCd+VW71VAPc1TXXnaFyraAlgBY4zxZrzwcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200119
X-Proofpoint-GUID: r5Jdx-LLzVd3Eaos05VS_nhAlHLKQTc_
X-Proofpoint-ORIG-GUID: r5Jdx-LLzVd3Eaos05VS_nhAlHLKQTc_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 5ddd658ea878f8dbae5ec33dba6cfdabb5056916

If the first operation in a string of defer ops has no intents,
then there is no reason to commit it before running the first call
to xfs_defer_finish_one(). This allows the defer ops to be used
effectively for non-intent based operations without requiring an
unnecessary extra transaction commit when first called.

This fixes a regression in per-attribute modification transaction
count when delayed attributes are not being used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_defer.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index ece446926916..d654a7d9af82 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -182,7 +182,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 };
 
-static void
+static bool
 xfs_defer_create_intent(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp,
@@ -193,6 +193,7 @@ xfs_defer_create_intent(
 	if (!dfp->dfp_intent)
 		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
 						     dfp->dfp_count, sort);
+	return dfp->dfp_intent != NULL;
 }
 
 /*
@@ -200,16 +201,18 @@ xfs_defer_create_intent(
  * associated extents, then add the entire intake list to the end of
  * the pending list.
  */
-STATIC void
+static bool
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
@@ -483,7 +486,7 @@ int
 xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
-	struct xfs_defer_pending	*dfp;
+	struct xfs_defer_pending	*dfp = NULL;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 
@@ -502,17 +505,20 @@ xfs_defer_finish_noroll(
 		 * of time that any one intent item can stick around in memory,
 		 * pinning the log tail.
 		 */
-		xfs_defer_create_intents(*tp);
+		bool has_intents = xfs_defer_create_intents(*tp);
+
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
+			/* Relog intent items to keep the log moving. */
+			error = xfs_defer_relog(tp, &dop_pending);
+			if (error)
+				goto out_shutdown;
+		}
 
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
-- 
2.25.1

