Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BAAC47087
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 346ED61420
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhEYT5I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbhEYT5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoBI7035360
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=O1+ZN1ZUPsgwHF3F/2hEPkSMwZmcxdwsopEYGFc3tR0=;
 b=0hOCSsreE6q3vDYlQjTaIsXLtoYOaIL7f03aCnKL+OaXPd3MEYLnIRmXqg6NhD1KoQzK
 bXIteEfaGgMp3GBv9xqSYzxgzb4dcxBsPg9bGJY+h8SpB/h8haOpa/TLTNQU+GJ7BAje
 6g30114u/zZPfZonOk3u0HLqCaos0mQd8+yMjPwdauDvVX1dtpn2gVo+eY9cgdNocI76
 Q+aFSOLgE+3g7vsPNeI8xs9/hnsq5I5y0unWGSP+R1lQrOqIG2XXV3G88aQM6O0uHgmx
 KMfXGxZDHxMgG9lsbT8vS2xlFmMgudEBSwlztIFZjjemRdnFu7X9IwzeXAnmYjxDR32v xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xkju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoDig188864
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 38qbqsjk0g-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WL+FWQ2O3uw7tPpyQirsXRN+u2metAdwnUFyVW2ih3kpaWis+cXkOqvICye8yVa2wqmlA9r4qq8doSbNhrGXyZ5CI0JXI+a3IurQ2G7KVGwrCmBalCvVWzB7RTNh63fb3H1wVUwXhMtb07iSgvd5nV19vDh56OAhRFsMfhA6EOzkF2QmgQCOWItvo2Coloqjw1PUE485iaq0KnvcvhTwK5TH64XNTBKDRdxfUSIU5+gV543p/MVS/j6H+8jOlb86v4oDPZuR4SSAA5NBZRGcvy6Gi9hCg0quKfgil5JE8h5prIvERgEjRn5Iwtwy6PdFtKat2TTuozxLiYoDdejwJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1+ZN1ZUPsgwHF3F/2hEPkSMwZmcxdwsopEYGFc3tR0=;
 b=H5mno8Pc710hdxCkkMz06K/LHxYUs0999DizKXnbjYt+nuujOzPZYxieFtNQb/zoLs52gd+3Ocy5A/z8HbkeWf8SI+u8Tra9l2C2XTO7QZNhZocO9PsnFrheRz62e2PPC4CwVUf4kPki4JTx7enKeMzvFcP8/H+0T0yi9yDan6ZyH0Qrb6Ny7NF9lX+ZjOndf7s5vnqfc044CtOL+AbOxf1j8mX9JuCBSomxLtkr80RtpPkWuOhmRDnqijhXnZNcVUincHRvhC0C12YbDmNoxT34kIsh70LOiizppKy7QvCXkvNVIbp2uIBR46m7oC8Tvq9CrJSSGp8U1u1sFT3ouA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1+ZN1ZUPsgwHF3F/2hEPkSMwZmcxdwsopEYGFc3tR0=;
 b=rHoxmBwqn121rhDyfG7oSqqnHypxWw23AEJQfGi3IBUZOjMWnQOeUPwEDr4CXhzmZRPkhVYNC7h6BhM6qLloDbRaxbUlwGGYM7Ai/JpLs5fofIYvkMRPRoxTFuhU8Z1lf+ZsBjeFRYmPCcl82brGhulqN/fMBYaYXZEyrmC/dRg=
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
Subject: [PATCH v19 11/14] xfs: Remove xfs_attr_rmtval_set
Date:   Tue, 25 May 2021 12:55:01 -0700
Message-Id: <20210525195504.7332-12-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e2d8626-9a4b-4273-3a04-08d91fb70caa
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4544:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4544F195CEA0856C9AEA143895259@SJ0PR10MB4544.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GyqF+CRLqz8/+F1POWxvymuwsYSi0MV6/gTvBd8g0VrtqKerG5UIwfBCPw2OzdjJLcqsuhpiLo6u9gNrtKQquCeqjW6d/PLID7HrJppldW2O9lWXqfMUSUmCk30eQN0dLbrqycXf5ZyXwKFNkyml6EYF6JGjVNsMqk/jcU1kcC7sn/qOgmq3NUWIdz3R4sh4TSMNGPE0DFyC68AtihW+i0aNTE0FKFXSORJL05EhUC5Ere+3wyCLHaDVbJ2E3ntD4myQg2sTurJ0ls0oCkdBaCzRc0Kdnz5gnD+Gc4UpKmCZTi8/Y97ktLuWIhBZDMUeolntoerRsYWw3MEjCDDAGfYyzZnt4mtguBuwn76pmtD8KrKRWT+Ikr7DG9AkLHXZKLs9ES2tkWgYGwpfb7Hhb8aCnHDa3UrgExSxqVEpeRGaPLkxUAYcNcYFdygPyhWyO5sg43WaFNHrkVr72sfR0z6BFxY/qAuqfrmSb6+6csYtu/Sdop0bSsnF4HrdasJttRNybkl58UO1kEc3DAkTkL5728WgVgUdrUC6YRpxKIJwcFYMHulhRMLiEY/2+GaMRaCa+cnOKNhmYwfUgjMFW7dDJeYr4OpxqDZEXvlgs/YuPxLgnDOr0il/KtY6f0VIaWIqfXvXsY/QyjG63VRqLg4qF3wFDSpcguitnyvuwmoJmW0bzU4Cc3nGbPcjhoTz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(396003)(136003)(376002)(2616005)(52116002)(5660300002)(956004)(478600001)(186003)(83380400001)(6486002)(66476007)(36756003)(2906002)(44832011)(38350700002)(66556008)(66946007)(26005)(6916009)(86362001)(38100700002)(1076003)(16526019)(6506007)(6666004)(8676002)(8936002)(6512007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tETWJ35AzMnI72nXd5Dc6A518vKnyD80g4aqURN+Iv3NRNbyi6c8dDqq1FtM?=
 =?us-ascii?Q?rjifklngry31eVFK1mOl+EtfYldAwGoKQWg1Y2PVal8G8zHekYd51SobQ8nL?=
 =?us-ascii?Q?0ZVp0WY/i4m4YKFovAQrIeWX/Zr2zEUuKzj2gGLs0paYhW9EC0XeRxkzbOMq?=
 =?us-ascii?Q?6Cq8jMGmdueskmN+V8rQKZ1op/o307L7ixVG/LMUfYiATtbowh15oYQAdOx5?=
 =?us-ascii?Q?LDzt3JBK+0DjU6LrAS4qvl0U2mGO1BfopqKFsbuQx55QOtGF949Wm/T9vwZx?=
 =?us-ascii?Q?l4uF5QdEAOJU4VPwwYh9CVaPHbtqqQr7yg95L8RUciypl3JwK883sdjBP97l?=
 =?us-ascii?Q?1eK/B7hxS2erfVNPhSolJ+nDmv/OvB+MEP2jTHsVh9EEyo2xDrq22hW+wI4r?=
 =?us-ascii?Q?QE2nfGj63kQC4ND8+3bcSEBeKtB4g7xxHvxCep/8kiswWvcXWteZ9bC96GMF?=
 =?us-ascii?Q?DWnbEeTA/YEnnjyT+dgbjRnKFe3XPJh+ce6oooLhA5sF2eW3CfXAfOxnO4Bc?=
 =?us-ascii?Q?75+OqrAIj18zQee4DTdLFKMWKo+xtdtqRzzpT1t201FRAi3Yoern8bbVA87+?=
 =?us-ascii?Q?Y09aeElICHjQyFEadzjkS3xRKyWxzRJYwMXL/s8X9BRVgSL3i22kQNkWclTd?=
 =?us-ascii?Q?pB83DIW0QPop3m01CjddKmDxQdLAYQHLH8UqZj3NzVJU/qbI542LloXT82vR?=
 =?us-ascii?Q?Qmw7LYxuCWiHKOassCkuWu83aXTFKwdFZ4DEZl2DMgOABzZ8v3I1HHuTfoQg?=
 =?us-ascii?Q?NzJav7SNPDSo4uXzKxNJA0EkqnVAcuz4ij+/jI0LiBkpPgS7Wk92Dvb8uMSJ?=
 =?us-ascii?Q?DvvGXaYCEAqcMAcbYfGRwqH1i9yCPi1Tj4wuTnRXwlsBzewUEhfTcebPJ8MR?=
 =?us-ascii?Q?hdHRPBgD9/3M9hecxlo47SAQq7rjhDtPaEO/2o9N5D2gqsscSLvARf7TLSYf?=
 =?us-ascii?Q?e723MZyW4TnrhevUZfTH5C+T2p6ZZr8yblH0Kndm4IbflPgOuuuqooR/EQ1e?=
 =?us-ascii?Q?Buz8lbjCQX63bbkYNGT6drtU6fq7/PpFBqkCO4j5DQia3i4sJWYLmSZeqItL?=
 =?us-ascii?Q?Riau5TNP3CN8scBlMB4AEm1KleXF/8Ul4E58q82v4GuHKw4KAmbhRVDOupHM?=
 =?us-ascii?Q?LCeke3gvk+UhQlEMMXJbR7F4H/edB2Rus2FcaTRgP+8pZE7oLw9kAanoTopt?=
 =?us-ascii?Q?HYOK6sA8tib7THf+5j+NXmXSOmh42cGmmf3ok9B1c3nI02Ev+rXCk0yEk0Sk?=
 =?us-ascii?Q?m393gqUXpG1rAcHkL5zFaf1w+n45mAUlfqKyf1DkyE9vmaTmcos1oQKq39Mm?=
 =?us-ascii?Q?vMvJNEgDWaBZNFhgIi1l5TM+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2d8626-9a4b-4273-3a04-08d91fb70caa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:30.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bImHiAPaoGNJx1mRHIeWk3bcBypLm6E8OQAV95ruar5Z1GC2F/+ggOilfqmr6dc2a2z53lQSSFymFwN1UfMhlydJDPUiXYYDprG+oMeq8K4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: 6OtZDqiso9R5gjBIooHxFri5OVjD0-fl
X-Proofpoint-ORIG-GUID: 6OtZDqiso9R5gjBIooHxFri5OVjD0-fl
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function is no longer used, so it is safe to remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 66 -----------------------------------------
 fs/xfs/libxfs/xfs_attr_remote.h |  1 -
 2 files changed, 67 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index ba3b1c8..b5bc50c 100644
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

