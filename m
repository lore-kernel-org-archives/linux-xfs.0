Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBADBC6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiIVFpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIVFpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFE271BC4
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:11 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3DwSc022580
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=1Nflb3Xu8mVj7Oix0o68xfpHGNd72mncPXBLEYWdO3U=;
 b=1FkC6IZwpBpMRI/Y5BxvvbXhdjZR8d8QegFEorkUTd0I171zFV6VD27/jOfPAUbhXxDa
 cE9d0EI4nlTmChVj0gHufo5avTnfHt5sThxI4EAPZGq9mzU2Arh8U3/UI6wOYh4+Y3sP
 ODVpF5TPbSt++NdW1XAn5smGEW73cnvuq9vZoy75J1GjJu/mwnarVOMh8swnRlPr+wPI
 QKMWVBOFb/Kmpzj1hcz/c8PYP0nu1o+INMq3yyqii0+OhHZfxrTrMHeSUiXlMX/0o5qT
 cs5mxEt7VJvkOAvf9+Juaq/KxLD6U/jVWl2dTBzndWcdvg9BGX74nwALhEl/SL6UHrE7 Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stmkrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M4rvLo006970
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:09 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cq705k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ap42RlR1YhF02UDxUichsqQdkwKm4M0h065QwJBXc4jVnwCVsypiYZ9KY1aUexAlIiaKnX3HDK3tMRNsxeVETHjL8Frj9PfX7JPcNPf1V1BiO5OexRDysR2kvqQZJJrJEnaW+BD9tok/DGXyFbpvX3lOdpq1zxriGFDqnuR2zTkEVNXUCBbBeNz4fBiRmfgqFqqjZJA3UYB7Es9jkKMMzRA03cjztKnyvOMWAKlDhBlUYVKbJXVcvmyTDeybGUl43yrTJ+W9e+qs+LBmx95ayIykw5TJM9NbNVz9TwUly4T4yg55qPyJOCazmTIswww6gN9lkhY7cKELCLZK4tsL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Nflb3Xu8mVj7Oix0o68xfpHGNd72mncPXBLEYWdO3U=;
 b=Jawvlf46X3P/FhN8+PZhLfeTJZdTd5EGO23kwC0K6WpA27I5vYAdVOnuGtTwefI/GQpvIQP9JSnKSvaDB0BoAmWM4lVnq69VUy8YNdPk9Ibl8ibHxUPbuZofzR/CeyRu2CZWTUtjv73JoilmHLJV7ez5M+ka3a4WvZamcpQT5hWX2RLYlFhXb1iV2jA39XWg9fnhF6xKmwBkHWLnrfsde6Tn+c2cuYWiLqvtv6wSq1tlDbev3z+A59miYXhkMfdn15AoYn1nnbAQj9YF9O7kZarPzJKRgEtMV7CT0KCcKTgv1ry+xxHHbjTd/MQ50IB0MQ1iiAiB4N/+dESa8/D83A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Nflb3Xu8mVj7Oix0o68xfpHGNd72mncPXBLEYWdO3U=;
 b=WeKHfzCH6u0Da37td2qQLZ2iXHp5nwDOMhF6EN/+UGgOOJcVx58J29+QLhgF2/jinXSk/kzTazWGfQKpbokyJ91wrQoUsRrOhxfmu0M/EPQbEOlPlni3Z3FeFTjSYZTamvHyoDvW/+tM9BDt/Em63V/L/BNUbTn+tTF4aTDOdjY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:07 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 04/26] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Wed, 21 Sep 2022 22:44:36 -0700
Message-Id: <20220922054458.40826-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0068.namprd17.prod.outlook.com
 (2603:10b6:a03:167::45) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: a84b9d7d-6703-4b5e-9719-08da9c5d9b2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXUDkMEKfBPyT796edqtX88IMrLq2tal7pbFtfqGRwxywWmWkuHP8ugE48gS0V+MdXYZDVTtcNzlh11NifwN9f9CqIqKtR3fNRbBQxJIXV+/xQ8NGJAm3EPuLx1/WYHUuLjOsRssKb2OFxU4kesTsuJVK+34r74QcytuhrQ5+5UW3HVDQZFIfr+OzAqqUqbbhYUCC9U09NdoYrvIndVav6TFmX69Im4fvbXoI/eZctj/V5VQ0q1rg/N+/2qpkPd7OnH32uglQk2zBsAHGmnjigxwaUBFUFNd7uDsRt0GYw2RVByrlBZaj4Xy1VHQWsIo+Zm51qPUtWwCLFfRgbdcfbMM36oV48bP2qFa9NR4ATWIkRQ2EFPjbsEaGj3Y5RfXF7NL2pXJWDju3XCdPZdAoLH7SzgFrPxHFXK9kILPdzBPt/gXsv/2l4MgJGwEmbLLLwpBe6uQTOp9g3cjRJxYKiGd/VZyqcGHkzEBPwbU/nRzz8AaII9m+uWu/xzgfnWDWo0Rcz+/aO/77N/YcZG2RCAGbrQZ68gQ9tAJI0xsBTJQ1/R/hfgy8ZPpoc2GRw5M3IWxDmeJFqeRDveUx48iIMYV4Ya3H1c9VAi9EOI+jgztaNeYvlkXKwCLFFCdqkTPwZefGlpU38jArisz6wXLyErr2WVzcuOnMKE7YLj4YXFAMHK54WkzjNjG2YXMAmdqZPoNNLmKkzZ1W8hAU2L7zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2T4vR/PJAKLmh400sJfaLOWBl3DUremCGMJ3i5a/JP6LPvbg11YKDFSxRuLk?=
 =?us-ascii?Q?6bu0MDhu7L91uMWHes8E4+GLt0YxEX+I/n62cs6U+kdGhO98Jq4Wa923nJ9x?=
 =?us-ascii?Q?1IaxsfbK5kRgYzR+4zngxc8VvuTJi83UnN/QN6OxaQDp5tQ8WFmABAQ3xV30?=
 =?us-ascii?Q?fNmNPDQhHpld68Qng2U6GN9SrgzAD6waUnBlDNF6mDVYUQIojk9Q1Snb1K2R?=
 =?us-ascii?Q?fWLauPyuWr6U2JDqwkZoWmPMvP8va46QRVyyeATZOyXh/g5fS9UdGr8I1aRc?=
 =?us-ascii?Q?q47MfHxpVblS3f8Wy1p6T5SA1PxP0t/PKZlqfh8GFoHor7C989at9+aoMyv2?=
 =?us-ascii?Q?iK6IWVbC2h48XO2VQBkYHl+7+NMHa578aKJJFZkpMazOucYfLIr4R8v+19aF?=
 =?us-ascii?Q?83mYYtfps6chizApDUQZxVwUEx6XeYa0xtdrSXczww5pkxjKzARxaPoAbJQr?=
 =?us-ascii?Q?ayMNrAC/5SevRfx/65KphOuVoBQFLJIkugI4uU4FHAvKqgVkZNytfmGGUbht?=
 =?us-ascii?Q?5L33HgHM8LSr+1uMWG1vX+ijfRgCSCLmp1u82ktfEzFn2GaspEWXbLNXNKZQ?=
 =?us-ascii?Q?wMa6oPYZdy1fuh3SSBIcHFEdPCZr/xVokY8ioQtmPZ/y2OlldECcCEfn8NDB?=
 =?us-ascii?Q?W72HXrkW2j+n49oabtFUdL5hPucjWQVewS9w6l7CNHsO3lSYGfEr557xHpXh?=
 =?us-ascii?Q?py0L84y74gkzIfCGMlEbkFTlO3kvhdn5wkuO1KXETCwHWRmUtGl77ZCC245u?=
 =?us-ascii?Q?k0hgb+4g4apPXHGKm1oPUjdMFZag1TEturSGXmHRJtT9IluIc564sTNSVNvN?=
 =?us-ascii?Q?Jfv9Vs5KACW6v3YGYi4L//rYCwp8I0uywhKxPDtZz8+eEP03MX/pjabrFpDu?=
 =?us-ascii?Q?cbPwr6pTC/51IRHhOz9HIeDQwYqPmK7bjgHFjdjso6GoJfveg7fGIPk7mKZV?=
 =?us-ascii?Q?3dwaPJGcQ0Nju4KmomEu74ghy94lQUkJDwwFcGPH1sNUye8iM8YPoIwqc1bR?=
 =?us-ascii?Q?QP5bP6esuPVHTCadGd/z6Ghh124fK4DlrgTveLoR0UZULDTddifluf0ZdoUi?=
 =?us-ascii?Q?5DZ05hpGQPX5s9chtPNkRuux1edrdFTh8qoGUceUWGsOHR9f7/UicC56OLEb?=
 =?us-ascii?Q?hqixrVUJttrXeu+rmRcJ1ux8k5RdOi1n4QhyDbqEJCNfzQAXcohZbvJR+bTy?=
 =?us-ascii?Q?KbYaPM8jiOf6jyBLSTDAoo3SRCYZmDUGdjAc6mZpY+ICVAGOsPvkzsL7AyDA?=
 =?us-ascii?Q?6Ic/k9lMud4pz3bRyMYU7NlBGZ9LQWuEepqDX6bnzmRpP8b8iJQdhDT7FWJV?=
 =?us-ascii?Q?pM8r1QPPHv5hTPhF1S6856TY+T8gfcVn4OO2gtIt9K3JuOhXpzjaA3aqI7xj?=
 =?us-ascii?Q?QpfnmAy7ARnFghC0rQlpYG6Iwtl/txjMST9CRscnH2fXD4vIHU1jkBFS5yp3?=
 =?us-ascii?Q?LekuAvzFWLwRgxyp3G9dzga/WG/mhFO3+ntWT+7zeo5+yL1zpLbgFt664Swd?=
 =?us-ascii?Q?0xGx0BCxHkPRTnl2P2o99eZPMCxWd38YCYK+hcfP6UZcjd3bR0b7ZPnovmt+?=
 =?us-ascii?Q?i7q2hF/pfQdTIwtRQ0SgtQ36KlrY+tIzqSoYYY+JzQFQSIrH1DuHbfRuSavc?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a84b9d7d-6703-4b5e-9719-08da9c5d9b2f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:07.7075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwQyheQBWPMLQPM6r5XBa2rZo6OsENYiBlc2GaRjhpn2SLhvKtJYPjs4zOnMivWtA14ysi+nvJc4o0EnwcOy4nCRM4JGR1yD3B3VrryG4Pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-GUID: e1e_5lMAi12aZ4LLDLtDUGCk7r24phRB
X-Proofpoint-ORIG-GUID: e1e_5lMAi12aZ4LLDLtDUGCk7r24phRB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++++--
 fs/xfs/xfs_trans.c |  6 ++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f21f625b428e..9a3174a8f895 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1277,10 +1277,15 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -2516,15 +2521,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..ac98ff416e54 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The ILOCKs will be dropped when the
  * transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
  */
 int
 xfs_trans_alloc_dir(
@@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
-- 
2.25.1

