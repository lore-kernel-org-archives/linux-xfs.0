Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25976C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FB2061B5F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhKQET1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62962 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233008AbhKQETW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:22 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2SuTq023609
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=YFXw3UrZeC1Ey7UWqss1pxK4F3t3iXBlpHnKfGUVads=;
 b=VCJ/CQU2zFJcOsYaGdB6anV1GgB0ODL6sO/4NJ3BtKRzS/xQ3zNzC1Pdcf89QJikXZQJ
 BmkQHS/DRfqeDPoW8z+C0b1/CzCDabcCzgkPsm8dWZizbGer2UwTkDMvfPDMFKWOWumH
 3tfIvSPdbv/YOvsSsmYJ4qMbDdqLH4kWHmmx/XiiH7DDp1U7mEISFtXgp1Io8jbVnxR4
 QM73LvFxtDWzHP2NobVu1WQvHblqhNk5UlQEsJYZynWvXbBRsJnKs9EzRerJJ9u+tkFN
 Y/cWXZ+VhBsbnsh1GC8uEJn3NhzeBkCshBPLqk5H8fyU3H0S71jI7vqvFgDICITpc/aF ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbfjxwws5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKh180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwqSpRy3JgmL3ECl/N3yHeTzLm9rOoMv5PQqi2BbO2QTS62gnTjiRiXCOcvvK5u7fbU/3JNsXEvMmzJUX5N/V1xO8qasU1b/EncGdMST/kN6qsbnoHHiIT8SmbIrw4UeRNx+w1rpLxEv1w93xGuTpYCoV1DgFv6/2mfgYt5WyBwOablw8yX81GpDKv1xiJ+PyG/ND9qmRryS7hkYbrO3I5+gbftdinNgDODumUaHEGPLz94Q8junnlrFldVXsDrohYp0n8LUZBTfyCMSRbevx3jJ8KUX4jFyNofpFVAB6T7i2OaZIzIBLS/y+iaMoXtYFSUptNnHBbknyamHFdR96g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFXw3UrZeC1Ey7UWqss1pxK4F3t3iXBlpHnKfGUVads=;
 b=NxwVUKfNQYPDLwX5bPCzHEJbj+hjycXSisl7a3jWc//W8FqunYvXdgSQGGKN+cSe+uPn8l8ptbbSbyBb9BuqVgtZj610TUgd6ZyBTDSVSgs+yn01kzQaGlXbRVrEOx0wduXvUIkWg9NA9jHgnNtfR5uPRsRGV2YJchW0BjKhexTSMciTChqlZi9kn1JB84paIlxGF5vS/clA3qg6FOb5JZzU5KpCR55VuUlLiDmkYLVA0YyGl83VLuud6AxPzLdbgeXDRyDRA5FrmjfO0MlA4UEdESwxZ7ABqb5oEmxqtMUBhnfYpkmfEZ7eyIGjlsv1swy6RwgnEBynkqzy11Z73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFXw3UrZeC1Ey7UWqss1pxK4F3t3iXBlpHnKfGUVads=;
 b=KmhFLWQ6DVnk6l/SRcO2rj/HTjWPC62ZzEZHMA3Yws/7dCkLI0u4D/cK/YNHanAEwD6/o66ENu5mc8BXmKeCTUmzvTLxW8ynYoAlwhlZEEuvaCHZtsCybAuFBB2H0Ifvymm79ADJVoOURofCs0A57QGXXLsZ/Spz/fzav5qVtuM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 03/14] xfsprogs: Rename __xfs_attr_rmtval_remove
Date:   Tue, 16 Nov 2021 21:16:02 -0700
Message-Id: <20211117041613.3050252-4-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d176e633-56bd-4cfc-f01a-08d9a9810271
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4036C6BCFE6F278188D1F184959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AzrFbAxUXnjpjbrtk8xinBFXvwWQlScDlBfPlAGXeYE5Pw4no0x6wEVMKJ9knbrUNoo8xLRLdlRRrKY5NV1Gwu25n8xAZjl1u2RzvsjPHkkaMNSBKNREXAXsgp+PP5KqXdKoDCm/WJcllUNUvlUF8PzUFwVEI2NmaKyzpBym5aVwBaEjs1WLVDIdDIrlk92mIxgXuZ1XbxzsTx8EoxJ0m5skHyiqrf/x/JgM4vplTAzWVf53zg6iNBm1y8Poq0QCZmXPv4lkbroz3hpadqeABTFueLwqCkHuGp384Y1ZK5BJ7gR2uEdkDldqeIjMxQ7XHG1yeFJYrxC0gnFJ3rVwmWgo87PAk8pm4Fegaj8U24+DpXI6ouvdtdcuUlL+GDGdeUfXfJ+cpWqUdIH/sj9XsHzoj5gJ/zBBfoc7NaxU4JBlYu8YgJbzcYRGnGyIOZp6ShdeGrivKLhBLrgE9q3UkgbkzXSNoJxAyX6Ox91CC9ze/8+tlpAKAf34ca0jdPCR6t4DLOrSGy2xtF/sLFNEVpbm8JBoswr6ldUp5r0j8fweEiIgpGlHPD6hlyYPA+Xpxtgsr2WDqelbum66c8UeoNX3b6EuAQ9scxKoAMCoVnDEs8ay9qu5SInERrV6C4eAawTrLPtF47Mp5YwJRIVsjlu++rzvMTPssFayH9o5FsNWFlguLiiS8fuRsMxrzMNLih8ZSQm5rVKl8/3mWYGRJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fBiPwDQFBOyq7ddb8UYCHpq70XQyLl9O+H8QNJw/JexwZ2vbEGSstDajFBeB?=
 =?us-ascii?Q?JEtmm9UY4pO9MWQSDVrWT6WSKSuJRLw2UWmGoiRguJVC9equtNbB0tOxIt5t?=
 =?us-ascii?Q?M477mc21bS2SKgmwzFxiUl63ZEor1UCWn/LcmqylFiwCCF5yUfReTMnRxO+E?=
 =?us-ascii?Q?2ahm/nKEvqOOZKmhf0jUhfZ9+y+M0X0k3RKh5w0RQgc9OL62bh4ReFrQ6g+3?=
 =?us-ascii?Q?wFVTTrAohAE3kA8iGINAzlVLHGIGiXiLZ48fiGrcgrE6Db42BN2wq2jScpwG?=
 =?us-ascii?Q?2FsIlHD3gDD0WPdWJ4o7i6UqRkBAASxhBrD90Uev7XUvoy8YTNaU5X0JC5s3?=
 =?us-ascii?Q?sdkw8WHtZBV8VFhCxJsUOVFpd42QuQE7C+Bd6yRXZrZEt4881+cczlANRJqS?=
 =?us-ascii?Q?sPS5yyWRtGgsQ+vSEwoTOGsKSLybGVgUmY4iEJ/TDxRQYwOs3SxNTj8FHWSi?=
 =?us-ascii?Q?Swqs+QN5eD60/Zz6RIdkqMu+WSwsBrlXhIEo5Sb1NgaZ5CO48GgSPk4Noz5n?=
 =?us-ascii?Q?MxlBP1QZSVo9gIupTduxJW9MXerBYKWM9wmsb8COi71/SfQBlth2pzEriQDI?=
 =?us-ascii?Q?7VTH4+BCRbNIzSDPIjaAjemFP+SeCoZb81twiTQd99Vh+yYeWx/PE93LSQpP?=
 =?us-ascii?Q?3xiMpTb2XCzyAIijc2VsWZ/xE0ODANiK4SyO0daZiTinY8snY19FN1iVrVAh?=
 =?us-ascii?Q?PzKJim7eNpanGwel2xKHOvRvqr2/oDhzlFAj+ZX/cex5D+tH8qVenctWnVun?=
 =?us-ascii?Q?Y5C/wQq2Mw0Nj626DNC8rpwaNna6X29cv6Htx6VSshk+FXHQUSRsL7fgIYj0?=
 =?us-ascii?Q?ZQTM8UYJ1Io8D5JxR6nTyuY3UXqet4QoNv5VwQMWbw4EyKjr4j5GkTJLrscT?=
 =?us-ascii?Q?Bw+3W/zzIBsHO4wsrmKjIcoXAMmY0iGV9+Orr7WqrxgBRGtO8Ckz2NAm5aC6?=
 =?us-ascii?Q?bwkK1Z6y9p71xuVplz5tsy05OsNHcBtcIy/x9NEkNGJLFAEb9eGmbT24mry+?=
 =?us-ascii?Q?OIjEP61eEkjeeXhfbFY9dbGyZat5t+93HlfP7PwUeWYUvELaPXVRQ92Petk6?=
 =?us-ascii?Q?37Pm2wchvM7R9S9acNhG/W8YQR87Ll2FO6vpfGMDJIiUHZoHM27WrEfuh+sd?=
 =?us-ascii?Q?M4WxALbFkbvtQ/01JY4PZrTZcRombyYv+h2j3uBWznSpsqx8f3OL6FFsCM1E?=
 =?us-ascii?Q?POV3lR205JwCjVeceCdgVAFudwdkIx1XU5KUFptrntf0MGZfOUcExjsfUalA?=
 =?us-ascii?Q?mEbSbKDrJRbQOXFEJyMzQnXvu3HN39QaeTwR3BZx074pskO5UtzRJ8RpNqVv?=
 =?us-ascii?Q?4dPE06IUkveJEI0i31Pl8tLquFcupRY5nrWCtqBrnYeU9PbA5DT9XPPgFwfb?=
 =?us-ascii?Q?OlejJTQGUvgl934gATD64OXNuCmJkR1iIHeWVto8JgqgdPDElrs+c7uwreGp?=
 =?us-ascii?Q?tTAWDENgI6lIQnYVqrs9+VpI2V274BcNR+xUE1jGEAe2IxL5SwWPYJ7onQGW?=
 =?us-ascii?Q?itWTE4f2IDcm58YVXMwBEQX4DMB092kR7BbB7Wn8Dj4vgRNhvmm004Gnfg/X?=
 =?us-ascii?Q?TjIfY5DBg1E7Jw7kisEplWKAP5AqxgjkkWTra4uY6ub+jcOW1HqN4NxyFLas?=
 =?us-ascii?Q?uF2ypodgT3yWf7J5UAegZNMsJfCekaIU/2Du3d2TmL+M3368/ypOdSiciMTu?=
 =?us-ascii?Q?fRClmg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d176e633-56bd-4cfc-f01a-08d9a9810271
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:20.8016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jeO34Vq1qxqmK6YCgwLSmbTk1rLUXJVskdGArBHFYI3jETk29jy+ssMSg/9jFgb89DgX9201gJK6nYnXllTIt+9jQvVupyDRG7IvrN/YikA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: tNeMTxHeiHBtWeOVrI42e71aEmOlxZvB
X-Proofpoint-GUID: tNeMTxHeiHBtWeOVrI42e71aEmOlxZvB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c        | 6 +++---
 libxfs/xfs_attr_remote.c | 2 +-
 libxfs/xfs_attr_remote.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 354c7c3fd38b..2957fd030423 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -495,7 +495,7 @@ xfs_attr_set_iter(
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -609,7 +609,7 @@ xfs_attr_set_iter(
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -1442,7 +1442,7 @@ xfs_attr_remove_iter(
 			 * May return -EAGAIN. Roll and repeat until all remote
 			 * blocks are removed.
 			 */
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN) {
 				trace_xfs_attr_remove_iter_return(
 						dac->dela_state, args->dp);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 137e5698c15d..b781e44d9c5a 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -671,7 +671,7 @@ xfs_attr_rmtval_invalidate(
  * routine until it returns something other than -EAGAIN.
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 61b85b918db8..d72eff30ca18 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -12,7 +12,7 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-- 
2.25.1

