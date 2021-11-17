Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5E2C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83CEA61A8D
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhKQEQw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:52 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12602 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232994AbhKQEQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:51 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH3CImM027666
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ZpTsL0GDDNZIm9yYFGLwP/lj2vj5e9h1cr0Hp44p2Rk=;
 b=cWITsw52bmRiCnybszWP1moRarxuS2VFfmyoRzBW5d3WXTrO4IQIzHRXZz5VVRwkdJ49
 G3v7yuT0RS2t+XF/2aOclF1kmKHeWrdPENwnIQ+XKA16Zgv/irgqEM8eeciN3a4Iw7Ny
 Y84ylOPW+HHKnYLlIsphOMtQ9wpjMdW2YP+g+TTV+78xLpa3jVa48UkVucWBrCMSQooa
 7xE2DG3ycP2I4CmfIkRSo0iYX3ZmMxaT2H7pUZFJdtSt6YheQGQ/XOxzojLt4g6hsZJA
 sSRlPVuy7/NwrRwsH4hf6E+7hMVdwkdSGgGll9WR5aCh8okj+uQdD7ov1cSvIYerv9uE nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhtvvpby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4B6AQ184801
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3caq4tncu0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coO6gJlOYA+8+PbM7Q20sX0CoJpPp/7lawstmY/0M8/qOB5mbZxl+NVs9OGONFH2CPUraBiDeMbByNjKgA0gyN1uzJ0Mw7cfgMFG9trO+lXtIjQJ4ZQVZa5X+g9STNOOcVq/ahV3J9VvoZvzD7v1tnZJoNva2NsrItZ/LcpSiRvf5sqriMLmrvvyATo+larnUYASyn0x7lMoyq5PhuoT8ISBj7aVRuSga0l9Efi/VG4Ta3vur7XGD/1jk8ryrp1BifPrwUsjsaa1NtXv6dG96yO64j6mOebiujfYsYdlXZeHtdgJqnx3s/CtwTGMSILaIRFwntJ9JBW14S8po+Pz1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpTsL0GDDNZIm9yYFGLwP/lj2vj5e9h1cr0Hp44p2Rk=;
 b=kgbMI43+e+2cqQc4NgYlEw6nI7Cnl/oaJ3Z8c9y164HTAnLu0Jnevwgr6vkHcN1HMoAB+PKm6JzxdTvNdQyZTJg9dFrgAw6E5M14G/QH2Y+0FrQgAP/9jXe5Ae5b+DkjpYrkVAU50E+KBlHURoG7jn4pv/1zKsmhPsHR0Cu/1IJx1Psx9WQpUiB2v7ntGxQMt1sOLlrY/Vi2NtnNPpmNBtq+DXBf+MboPfiFhV1pZsgU+zi/Jm0qZE4vJkzs2hxbDFXP220HraZy3qzRetN2jwjkC+mrkTYIftwQu9WiCxBDpXsdu3gtJc02jkPq2Qd9gSwDNiBrfIytR6I1Ea/qhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpTsL0GDDNZIm9yYFGLwP/lj2vj5e9h1cr0Hp44p2Rk=;
 b=ePQyGxsLNE63KaKxrUPrMJbBob+ehBBZZ61MsyZXmJ9+qlSbjxePiil0z78jHWCRC21V0innyKE2D9dR1G9JLeGKoLEsFRnszTNTDOpB++5QzOcidSrPnSvYgi/ouTTb8YEn/CjZ6asrrSOWDvDi1tcCGB5elxp58On6+eFVnEA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 04:13:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 02/12] xfs: don't commit the first deferred transaction without intents
Date:   Tue, 16 Nov 2021 21:13:33 -0700
Message-Id: <20211117041343.3050202-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33af9f1f-2f35-46e0-7ce8-08d9a980a84d
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB408614E82E940463B55DBBC3959A9@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h5ud0s+VQVQrlZetnL0I9NsJmdOQj8uDyWKc9hU0Awts/8GDROWLz6f4yT2ykKsS31H1pXEGCFPUBW6HDR0F9SHzIxanBSF6kFn7LJUDv5YNxrl0ICfzC9FbKMPLnohikWfnc0ov0AGFA5IgD8j8a4kLBvGLUsyWkq8jtSS3RaJlKKqrh7/AwFPKlw0kFX6QTRgTb/wjnTGlWRx43zbm5akPRSWvIM3CAUOkNO/CNRjuOAbUxr1Z2pblXr8bXiZBlKpJUVlKkEubOBHTSfF8dkCJweHPa6B4W/T+HhP3i7RyLOI4HGFo21vmm0QcojGVYy52pATWzcsRZq3UDobXvT66Edr3IZcB824yvmdOZIv3Ca3LKpbgfXAaDnnaqtoKFtANJOLr8iCJjzkjze7zefQ6Ojif4W52UZlbeut/6A86TqUYcyXHMV0k3F9oszm6t79xgBUA/iKcdacJB2Yz6UIZ2qSl3IZ0VPOHSqihajfTCXrAJ2Gt2K7S9DB+Ip1KczhgIIcYejdYn4fBw10FwU+sZQuZqDenmGxX52xWqvV+JZoZNnHUPRWHXGkmqMPHup/X0ZPL7H5oyTnGJH/igPLnZ+96AFzUAlhZgI1MyA9io1ZT0PC5p8xTlzTmJNCtna8lxVPHVLsVtl/EzOcpr2q5guSGUXOLrcmJ+4mSpOr3KJKyVZn+2xl9tci5MRMAHExY+j1SFTrzSAiCt63o8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(38350700002)(38100700002)(6486002)(44832011)(66556008)(8936002)(52116002)(2906002)(508600001)(5660300002)(8676002)(66476007)(6666004)(316002)(6512007)(66946007)(956004)(83380400001)(186003)(6916009)(6506007)(2616005)(26005)(86362001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?18SPkStiwoWUqW5usm+ZOkI3kWfzaOg/CsLPXJTAn0PVALUHwDcdn4LNv4fd?=
 =?us-ascii?Q?PK543GOgkFrDkr7F21bAhClo+MDKii98MNbTHCaQFL5gqReLHr18V4xUFlM7?=
 =?us-ascii?Q?TR4eULZNLQrm1PYpDkS9tmBOBrBpKpCP0A5cFWjAcKKtL+g0tfcHThhKZHIt?=
 =?us-ascii?Q?5RN+W0S3ZwVH4hi+m13iC1LYsuVuSUBw4oSo1wl8OMiJQNf3YPFNc/dDdQVl?=
 =?us-ascii?Q?o99kmmcWHjfSTPmWO+MVuZWU+vjbXs35I+2SuuQPUeGoRsExk0122tLU1ozl?=
 =?us-ascii?Q?g3RRDXDwN8hFnP9YXSq+TmyewZJ2bIkGiYhk5zAq70UiU1KknQMGdsteXDhi?=
 =?us-ascii?Q?Rmt2I4hbq63/d0dfNepk6cUyd5OUDVKxP2B4QxGqqFIcKuCI//EWMum8dP1x?=
 =?us-ascii?Q?irEYPTdByLRka+tX+CgPbbtp7ILlw0GTnVuOonISbsx/i//YSGR/ZiOMU0OJ?=
 =?us-ascii?Q?EewTn6FPq/lZomTUP4D52cjrqTJkgZCRYqzbAWFhYRMJIRG6cQE3fzlvAb/3?=
 =?us-ascii?Q?megw7n+jD4Mowl0Ye+XdcjXSXgqEWSMhqK2pbTCYHdIR7fQ3iHO1/keEGd7Q?=
 =?us-ascii?Q?YMxtK86TJbVtq6vfoNZHotq8cqX41VAA1NtE8jlOKognwEn2cqpiCu4uXB2y?=
 =?us-ascii?Q?o3XuzeEDIqRwRyoYQNOOyg4Oi1X2buqxt37ZKFQaBr7Vv+rsompUemb8HJlC?=
 =?us-ascii?Q?q1dFFz5IR116pnTFZbuKfKvDB9MVwpFV7lFVEoniNZaDYARwRKkoGvwfr7qv?=
 =?us-ascii?Q?5Y5Wywz2XTc70NHgZAFILRzHklTDoLxA7fHgwQ/qBwWrWbH23b1zAjJhVeBN?=
 =?us-ascii?Q?AuN6mTWtcGO4+lFp/qPX4ySMl/SfASSMRXzAunUNm4Tv2lknx2Ck4/KGaLJ2?=
 =?us-ascii?Q?GC6h7KKLVE5vV3Xl+276cV5LCbjAOoUrvKB+J/wYUZ2rutl0Md88AfN5w5bJ?=
 =?us-ascii?Q?qSLj5/B/DMhI1d8ZvuzgoBcTtNRJJLQcfBIjgz/RlG5lFNFmkpI6Awfci0Ze?=
 =?us-ascii?Q?8a2JbF0KGO8AerxXviDKGhKXiY6h6UWbdCdO2kZ9FRpIBKkE9GASemnAc3CT?=
 =?us-ascii?Q?EFixMeuv8mOPRIjXTF8LzZ8y2BtG9ad0sAl8w0NyzFvSL4G+Hwo+YoPH65h2?=
 =?us-ascii?Q?ABYRKO28u0JPJKvNIsxDLxIcSuz7nMuje7rLNGHb48FYVlInwz14PKE93T9X?=
 =?us-ascii?Q?9zJGn6XNQ0XAUXjebqjmrd9BrL5sQZJqlHpUbTFSgUeJOWW04Tx/2E3hrAJH?=
 =?us-ascii?Q?USOjYaOSTi0yw0FAMRzSxdNy8eaQoNk8mGENoMIigLQXk5GVoP2BrcASDHP0?=
 =?us-ascii?Q?FD+Of80o01uXr9LowSRhgmaW9rr5hcUtGi+RB0FBKTIkeuJWNHmZdnLfs178?=
 =?us-ascii?Q?3nsL7PSghkgchecYeQbukqswnnjHZTednEfs9xlGngzZ5aysiW6iH9aM4/vx?=
 =?us-ascii?Q?RRBr50pPbdEZZ44R77k38hW5sKVZyXAnE/z1M9K/r55fkEYHdlnaDCFiQq7h?=
 =?us-ascii?Q?GNH82Uv+W0jsRrrlPlkPLb162OPe42buTFrFn/zpIYxGkmNTvbsUx3Zl6eor?=
 =?us-ascii?Q?y2dKYnUXxY6bWKi77DZT0BdjB2FPrPBRlIjUR0UYDdz8vMCqZ76fw9uSfyOF?=
 =?us-ascii?Q?xwa8ObdLYBcnKYI1nLRFT6Lif3AkUkBGYFz4aOeglU+NG1C3gXEpJtIeF9gZ?=
 =?us-ascii?Q?B3lvow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33af9f1f-2f35-46e0-7ce8-08d9a980a84d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:49.5389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oYr2BCfiU4aGC3SaYVgmcXnQAc+SmE99YdUJ1sAA8TbQjkPv2FnguW0rgmhJwq92z24h+ORc2o7W7XHV6DbE6twLvwu1h+tk9b/ytrrRfOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: TiS3DHwFmh-9xoXlL2Ib1kc0vzWR2Ug2
X-Proofpoint-ORIG-GUID: TiS3DHwFmh-9xoXlL2Ib1kc0vzWR2Ug2
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

