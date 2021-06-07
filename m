Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2690C47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 05:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966D161208
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 05:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhFGF3x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 01:29:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGF3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 01:29:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1575OE4t164324
        for <linux-xfs@vger.kernel.org>; Mon, 7 Jun 2021 05:28:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XPX0XefVAdL3Ax0Fs8jqJb0IcNvVihKj12e7+yansjY=;
 b=0iR8Ro/X+W7O8aRgckQ4jxC6iT6MRoAv6jljoYC46VTuVxmhsv/hrdI3lrhjx9SMTWxa
 OI6aWZfXqcQa3/r82lOLQJ7WDwxBGxdBMTGfEpJTcLqUZmoUNfOGQWQd0NmKY81RlZBP
 5XOZSS7I7kPx3/X3DdYzssyaT3m6bo+YpQO7NbjE7shEBc7fXT30YQxFqB+4yqIQKpLm
 4pg/MAMft8/R2OkDct0xVEagjBccsRvr5rVzC1e95prS/smY41zem9Rz+yc803a0gdLz
 tSr0zJWJNS9kiTcCLv0aZXrrs1Q7kYGWGjeKzYNI4X5dcOwVIrwbofeuve6oFE8TNbdW 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3900ps1ttu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 05:28:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1575PmCi178624
        for <linux-xfs@vger.kernel.org>; Mon, 7 Jun 2021 05:28:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3906snnq3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 05:28:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRi+M7WT8tF71W3HuHwsDeRRaMe9KvUwqTDV4uvtOLZiCXY0Lelabmryx82iyQrcj98c2KHQTZ4TMt/aJgLLEpvr7noyX0y1ylGJAh60HT6dveuNHS26a7ZD7g+Cl2Vq3pSasxoImMNWvprrPQDWvmxftWWtQ7wI7x07PTQ3NB8av0sVsdU+qKm6KNqxaYLCKcA7d/V//POnBbfJ+gO+FeKbxuW27wK8bxXp59Tm+YNItETl83T6L5Mnbi97NkfdCLTVuFNB/hEb7aOqIRukr3qx2rOrQR9MneUnthrqvEpK02i4KD9YsVLSriulv92a8IEcB05N9EVnIfMpGWf8rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPX0XefVAdL3Ax0Fs8jqJb0IcNvVihKj12e7+yansjY=;
 b=SOeDAxytubYrtu7GyVdDO2VwLWkeBMlyj7SLcFYmC/LbL10sXHiikwGVrUvfNa3cniB+BFxiEor++1pNiXANx/lmfCA3V021drH9tLFgivKdtiCAmugEtX8ScYGuO1Sm4wdUpOKQX4V0FZBkgxbWODyBCsR4iduG25leK2gG7ChmABS0Yrski5rFdECR50Cvxmsj/4up2Y1p4iU75h59YtgYdgaKAbg9byBIcgl29Ct4D9Bh3OLxxB4PZtkUlitL7F9+gBtnWUN2zEQ8F2Udozlbhm1MdzCC1FKPIbBwY4eIDL2WbvdSmzBOBuxfiViTSLquIY8vPpadWSik+mp9Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPX0XefVAdL3Ax0Fs8jqJb0IcNvVihKj12e7+yansjY=;
 b=F7geGEBvWUP2FcUAXGTCyMcojBNtShPYwNZymdnV1XKOMmHdNmxKqEmeStghCQCEEciXC7FkJ7hrq7oU/xkNL03hCgKaS1ZYxAtGPgh6EJR5yrJaV6Iey1AdiRplkk2PszL1bV7xsVzw+1ck6Ei3zXB8J8+Urkf3fTuP/+w09Sc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4687.namprd10.prod.outlook.com (2603:10b6:a03:2d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 05:27:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 05:27:59 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 11/14] xfs: Remove xfs_attr_rmtval_set
Date:   Sun,  6 Jun 2021 22:27:44 -0700
Message-Id: <20210607052747.31422-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210607052747.31422-1-allison.henderson@oracle.com>
References: <20210607052747.31422-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:a03:100::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR08CA0019.namprd08.prod.outlook.com (2603:10b6:a03:100::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Mon, 7 Jun 2021 05:27:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9ae60a6-0257-4b85-5c0d-08d929750318
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4687:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4687F586798C35BD0D11086595389@SJ0PR10MB4687.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CDBLAZCaM17FWHHPUGuqtRp4YSYDc0Cx5GdQNVFxTenyApyqsO+1XU11FwABgqFgi64vwNbB6ei9qmNgvJ7ihmd68FEYTPLwmQ8VWHcGvRB0LP2bOf2Q7zgqPbAP/rRck+kC5IJgZ31XlgKdpiMD7nwGuM7CMvv2Fiv2VeKcT1DPApygorzp6IK03if9WOKKNktWnhuypvp0T/1lCQewvRzyuQ8sOn0lTJzFUr5foQC4Grxuxw3kkF7F1beLew+YC0DCBcIsVu0Z/3SxHf1dPJnKipwUOaOPUbk2ZHRT0jE5Gzx+T7Nn31PZmCL+LppZpD6NdE2ieTg6TXpE6e6/viT9e1Qb9KpMiQ2rvGl63AonIuq14yw0CWlo9FqwwaWz1ZyREI21MPdnBJK/F9Bj7FDXHM71524RRRdHHuNVMMrFTai24lLq7vEtK/N7ASdCkawKvG/OLgtOnSXCxgJPpMITWEKu1HV1E2PeezEwO6qfKOJmrSp7nwBhyF/bSz4/Hd/YcnZVgqi9ey8bPCibhv56piqq8okypqakuNSiUAryh9mvSJsmlS84C378o0kM57YJhovex4lt57NgU5RNliASPfvZhL85EqVlTH3EWz8fY4/bp8Qe8gOuO/vozdwB0CvFqtJLHfnDTvQr4Cdks+/gWOnB9avuIn9OTl7fe9KqkmFwugpCudJOOKNCS0R2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(396003)(366004)(186003)(16526019)(1076003)(316002)(6512007)(6666004)(8676002)(8936002)(38350700002)(6486002)(26005)(83380400001)(44832011)(66476007)(66556008)(66946007)(36756003)(86362001)(5660300002)(956004)(52116002)(478600001)(38100700002)(6916009)(2616005)(2906002)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O/T3u8e8j7bpWOU/g2siT+fHky8CZYZuurD8ZUi3bD5KTH85ugyp/ZccRewF?=
 =?us-ascii?Q?hFdT6ErPsiYe2VPliB8itBCjFOcglmyj4UfheiaZZhZ2XABFInftLJ2wbls6?=
 =?us-ascii?Q?68mYKmedMiYnUzGIfhS1zw9/26PFZdpTMzONlCat/iBpbSYElLxTVWvA3M2D?=
 =?us-ascii?Q?ttRWHR6u0OUx2mndMWuCFN/sq3S2y4Tisl/rIRbjPMSH10vMtgA5b09yJbm6?=
 =?us-ascii?Q?6ci8n+bZC/7HTH7uGF+XdNEMPQ7aF19+yQjYCnrOqpCaZbjOKfm7fozwXtPw?=
 =?us-ascii?Q?gLkNDjswlofw/8ryM5J0zKa+GN8YCFUeqIjWUwVPsxa/uVrXk0YxrqEHMDFp?=
 =?us-ascii?Q?tzWN0/PUSV1wh+qrqtpBcxhhHrwUhNjmiHoYlg+aBdJ4nVLNDfEfZUOERMkf?=
 =?us-ascii?Q?1kEhGi21M1wGh5+0MjW8/egp0T5YYGd8oMhd/1xYsg+Q7iFhgHz5HoYFHx1b?=
 =?us-ascii?Q?Wz9UQGQ+fzsIvj5QBpcI0Z/GMnB0gCjhYRhdw6zh8RQddwgLXWchSc6groDE?=
 =?us-ascii?Q?jOwU+cjsdtPzlagaRNqzezRNTJwkIxNgZhLcu+X92Udtmcv/Q0FeVUolk3cj?=
 =?us-ascii?Q?FWa/cqNgCWNp/Zcggdyr/HJIobbRbxa4nfyn07KTw7ahEmbazlZ+YYb8DuaB?=
 =?us-ascii?Q?rqITnoBiFtj+v8AkYLJKnRZglbqkx73/XI7PCsy5aPrq63lHn2m+ZUTcabvY?=
 =?us-ascii?Q?QEoHKFfzZf0JGjm1Zuv460F9L8XXRaCYxaHPAtDWhzIS7CBIqR3B22OZUFuf?=
 =?us-ascii?Q?1/xK4A1njyuLWDKLigTFODG5GtpYdKNmHsqYgjfFkXZ3v3KZndnugXwuC5N7?=
 =?us-ascii?Q?8MQSRxxVRgK/xH1wPgINUU1NIZ0qZZt+W/34flIEszE6NdZ+cgGYtjUw7UN7?=
 =?us-ascii?Q?PaaTVdylgMGOm1mzNkEzNTd9UAHtP2ZLv8DnedpwIoeEedOjJ+LPY0cuQ9R8?=
 =?us-ascii?Q?MZ/AQgXwuLQ+F6zibj3jlFRyVIezghUbTPc+AmMsd+5g2vXZwyY07Yq7tGK1?=
 =?us-ascii?Q?m0Cq6JiBnIuJQuf3ytnpZn77xEEFQSoNardwo7kMmFSG8+D1KEx7+uuDMZj5?=
 =?us-ascii?Q?H31lTjhvOoPQbGhiDIoR3Rq5InOeoifbFhC1B//fpArM8ZERitXODAxtLjR5?=
 =?us-ascii?Q?YCSTWvVP822PwzKuwQm4zZxseLWGS6vg7MDazPl0+P5vwm5a3RrhC9RVetsW?=
 =?us-ascii?Q?n52TvTLm7GtFer+vCvc4r1u507pROxG4MoTsvypxOczRMt1uJpmQlJQ8nxJF?=
 =?us-ascii?Q?L/Kk+sn495PwUI6Cu+l8hAC62hAdZj635yzl/wWTr2ZaxtMWWJ6ripB+2Jdn?=
 =?us-ascii?Q?vFju7CdeyTq7C+ugTx9IirYt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ae60a6-0257-4b85-5c0d-08d929750318
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 05:27:59.1129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAYcraKoi9azTb02CsrMiArnB7dahCcDdHuO4n5hCfhj/KCwi2I3ArAUmfzNRDqXg9fVW94/8M+xUDPVBJPdtd0HeW99qlCjTq9WlqSD130=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4687
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070041
X-Proofpoint-GUID: p40G7nnknaC9ckPrxS8KqVQHNQ53X3ph
X-Proofpoint-ORIG-GUID: p40G7nnknaC9ckPrxS8KqVQHNQ53X3ph
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070041
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function is no longer used, so it is safe to remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 66 -----------------------------------------
 fs/xfs/libxfs/xfs_attr_remote.h |  1 -
 2 files changed, 67 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index c1b09fa..0c8bee3 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -562,72 +562,6 @@ xfs_attr_rmtval_stale(
 }
 
 /*
- * Write the value associated with an attribute into the out-of-line buffer
- * that we have defined for it.
- */
-int
-xfs_attr_rmtval_set(
-	struct xfs_da_args	*args)
-{
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
-	int			nmap;
-	int			error;
-
-	trace_xfs_attr_rmtval_set(args);
-
-	error = xfs_attr_rmt_find_hole(args);
-	if (error)
-		return error;
-
-	blkcnt = args->rmtblkcnt;
-	lblkno = (xfs_dablk_t)args->rmtblkno;
-	/*
-	 * Roll through the "value", allocating blocks on disk as required.
-	 */
-	while (blkcnt > 0) {
-		/*
-		 * Allocate a single extent, up to the size of the value.
-		 *
-		 * Note that we have to consider this a data allocation as we
-		 * write the remote attribute without logging the contents.
-		 * Hence we must ensure that we aren't using blocks that are on
-		 * the busy list so that we don't overwrite blocks which have
-		 * recently been freed but their transactions are not yet
-		 * committed to disk. If we overwrite the contents of a busy
-		 * extent and then crash then the block may not contain the
-		 * correct metadata after log recovery occurs.
-		 */
-		nmap = 1;
-		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
-				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
-				  &nmap);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-		lblkno += map.br_blockcount;
-		blkcnt -= map.br_blockcount;
-
-		/*
-		 * Start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
-
-	return xfs_attr_rmtval_set_value(args);
-}
-
-/*
  * Find a hole for the attr and store it in the delayed attr context.  This
  * initializes the context to roll through allocating an attr extent for a
  * delayed attr operation
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 8ad68d5..61b85b9 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -9,7 +9,6 @@
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
-int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-- 
2.7.4

