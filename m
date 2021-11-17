Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49DDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DC66608FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhKQEQv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:51 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44840 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232453AbhKQEQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:51 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH21H9V030389
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=G9TB70UXoJ8wxC18+3j+8D19N865yNHOn17ox95lRF/oyGUeLyRBi8MGM8HVdG8SrhJX
 mLUtHXv/7Gh238ad26JNxzOw/FyTtdKVa8qSGn8ewrgmqCf0rBb5zdsSxXe9egUSqWfO
 9Z72bdt4gUNy5AI4PnnL59E0+b6XMn/l8S8tE4VE/b3Md4EnvoSSbihgx+KfxYFvpN3R
 GtMJTj5u6pmTmZUtHrqq4BqOuR9k+gxr9cLxcPqENesY4rJdU8PzZkIkOXVSN9KKPKVa
 EwdeTE0F/QFOkQ6o0DUrDxrlWz0ThkCeKO2kx6jO/VoP4jr3SY+M0cvH0STc/97IdDho 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnwx0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4B6AP184801
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3caq4tncu0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdkJq/efOASjZ8WNcfU2UuCSaV7+4LnBwbR4A/SQdIzpwoKE1kOyQxMqrIrXyoLQ6h376c0/0NzBdqRFDey/FA6zYfzkRUfoIBUKceNOXUzhaXVXUy3I1fXyM8hxw+m99FLt3vowsIuikJHscLgStM7WiTDSJGkQMXncoQlCdhc+o6Hfo5RHDkYCdgWwP6qigGGBUAww1iOKY/t1ZIkoRi1Hg9F9r8/r10Z/85gWSEWDX8iVBxc+cta+2nQanBsuRQh4fS6qCvnNVKa64bj5X6Wfz8cxMurrpmgouAOqoSLMNoMo7eL44mQGpFv4qG5qB7FUSfo2y/hWqU4b+dRXcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=akuKjAoDFpohO1u+JgSgwpPxoojkoUTtxTID+Xa23eRdK1yXKnMYcqCxWMr3p1amMFdUE8IrAL6nABvaAGfVjJa+2U9XxklguNX5coTCnUpM0d3OCBr3W75maQT9dh1dyiKVdjr5tsCqzxrgtiUMVvr6rvKeQacQFnq0r4VKxaN5V5Zs1HqZVo07dVeGyho5o2o0RY4fhqOAsBm8gcNYVKt53QSIgf6w9yJZGe7MKEK2Y8JyJd73RjWsGaduLxUbWdqHoRZy16mi6+R9t049CttSL9Vwlp+LpSYwyQMU2Ud1IgumhzZ1JkoJogaT/w6HwAoEyxTnaQoqrJ06psu5hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5ZjRRX0+Ag3k3QMER+6A3+XIPRF5VcX3CVx2dHGqEs=;
 b=giZ9W7BAemtjLEN+IedApmi3zRWQX8bWNlZ7aPljYkiIyBPVOJPj9Xu5HIydOMw71dpxaKyuHltqcULsEfgX8mqSuS0/0ZnTyEfwFdG1rUtiyI0vzMhzrT0h9vy9hwSX/MR4exwFIQBXBrFCZ6jPP0j+omolfYhRm3U9MPlryf8=
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
Subject: [PATCH v25 01/12] xfs: Fix double unlock in defer capture code
Date:   Tue, 16 Nov 2021 21:13:32 -0700
Message-Id: <20211117041343.3050202-2-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 90e58bae-81b1-4d53-7b28-08d9a980a81d
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB408698E489363475A348EB5E959A9@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +LO07qlLwEJSP7dWiYz5llnCbaap1MBEVeEJi5crUomu3orKmUrArw7eVhABAJ/ff0p8zj4QVEjLbKfG/Xl4tQp3afoROFz2cwzue4PU/n7ihcSf4QNntUZyusuZBrdxIei5oy5B65XGac7aCB5huDBneLHbmU8errMLnIMLdH8cfYMNrUIGX9SgUicNo0olVd4lw1ryQIPFQKM8AxtXgm7t/SYiXHXdvE1GRc+UZ6Vh7DTr2ugJsVk007ysJrmPI4RZjdEXeXziCHG4kKYrl8YqPjmRYzUnSnopjuZRmo5QaigZO2+pW0qE4Qw9fyLGjAycw4ZvTZhB1V6nxYvfedSZAziPf9UXe4D9svmWGfx7jxhfP1IY4Ab7GrstOhhXfLXIVHgYHXM3vceDNVtPqaIaFdvh6lEd4ks40SN//YILhd0S8rTWzL0jrQVWcA4ghRRSiYOtWUS3LQtDvbhbrl8rc7zZ7pQFe7jfX/lku1QNt79dBoEocmgxoU00NplHts+AQJGK97s6MITPzF6UmF36UW1e4rJMl3pYiQYgeKJ9dw+2hzw42Eoer+kAguiJMljpPgXB5vzpS/9O/dVHppX66kvpLagz9okXWfg4ybwGlPDZpW72EIW3iu0y2lCQDDWkd/wxmiFY3d4QGOGWGCxyFZQR9As9wvYia5IKP9tl6M2CbElQwteRXPhedNalIX22SC7jBJz97RbpE8Rw8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(38350700002)(38100700002)(6486002)(44832011)(66556008)(8936002)(52116002)(2906002)(508600001)(5660300002)(8676002)(66476007)(6666004)(316002)(6512007)(66946007)(956004)(83380400001)(186003)(6916009)(6506007)(2616005)(26005)(86362001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HjVndrFjhu2fTIAOzqv3f6X9XwnbAAhkV7b2jwkPaURk0wCG0Elyv1reNhZq?=
 =?us-ascii?Q?JkfuKfh3b9CA2IjWsHAOj451I+awtoaLn4GwVMr47WcAD94MsbTCdJlHRILX?=
 =?us-ascii?Q?6RTNS4ZPxSrUBvchJ/qTyrWAlSMk+Ved2blUKNBaFXSq5uzppFjRCph+6UsD?=
 =?us-ascii?Q?S6QgZpowO5+hzsZVztXRqXCevO6tLG7PCZoQ0RjiP9oENcC2K9ReXGMDhvX+?=
 =?us-ascii?Q?OtJQoDvbVhYQKPkW+skkTIzAk8nmLA7f5orlK6N/Nqlg+QO0qtq12gTelGPc?=
 =?us-ascii?Q?wM9hipoZNma/bfG98VacaurApydSHxeba6l/v0WDVLCAJ4xV8j84XtimOORr?=
 =?us-ascii?Q?WFsQWcuOGKCkFRT+/fJCE2PMKmnR4VqrcrCIoqLbOaW6GwGWHPL1hHLOCRJ7?=
 =?us-ascii?Q?2DDT8/3CkYGhp+zUOM+DUTwo+sbaLXHwdEYNRYwHEG2frcmS0ZN9Epc4Yhkj?=
 =?us-ascii?Q?B+5A1KBT0F2enEdzvNI7/9rzuMCWpL7IxVcNGKBclcH6PzjURx1YXSQqBZn1?=
 =?us-ascii?Q?Ovsa+GD3hWY7jnjgZtdXjOJMiZTHDLJ7mE91/52MVMsncS2cXrt6U0bsf9BF?=
 =?us-ascii?Q?7Q80NJT3KLNkTV1BQTy5UGXz+KnKm+G4sPRwNC+qW37yLt17p7QsHeGDg+p8?=
 =?us-ascii?Q?5OF2iZKTqp2c3nNTHgjSGcJsB1mz0E/t4d9znhs15O+1d9rg5zJym2Lpwxwg?=
 =?us-ascii?Q?j3Bky747IGLrNlXE3Qm70ejNnl5Sl/xvqZMov9LvhWXvGtbgKJh1v9AdLCvN?=
 =?us-ascii?Q?eYMwaI2PsW86lJcwGAy/UUl0frUgykZ9ElNMkuM3ZgGuV92njv47+RDVdWeF?=
 =?us-ascii?Q?UVWwnpCeWsEXA0mySfgUf/vuJKPoJ9azPUxpY8cv3yQN82mUhzv5QnCRXy/6?=
 =?us-ascii?Q?mwKXz29Y0QlG+lEQ4JbPCBfRMgW2WWm4sDlquSojY3fyAC+QyFfbinHmoYgq?=
 =?us-ascii?Q?Sfkr6BtE6R0NQK5wgO4pHm0QRrFNrTdC2IBSLCYIQJOr16+veynm3y1T1pV4?=
 =?us-ascii?Q?ryGVSIuCrg8XsMjIjzdoqxYefjnzzJP8XmVzias4U9k07HoboCez1h3cqbDt?=
 =?us-ascii?Q?GCqKZLnGWaNkZTzRY+dYtvV2M5RyIRalXv0Iby1ttYYGWesLtOCtupDe9usc?=
 =?us-ascii?Q?jM4wBhRjQhJ10ps9xAoNmNP7JjYajq7kCQcPftU1UZFtmseX36TNzuLNTFwT?=
 =?us-ascii?Q?90Uu92BDEDYDHmY25CYLUtQgzxIU+b9VzD4Y5A8is0X8CxD9sa7pbZlAwiwj?=
 =?us-ascii?Q?rxDEUloBYOcBxOfA3xL4kozuNfUvUZ3JyIWiDBPTzTMCAc+XhjqAg3XDNVPZ?=
 =?us-ascii?Q?tcfkFt6GxiXVNgpMFX16wGANnnS1v/TPW6B3BukrtuNQ0TfHWJC8l/yEiskU?=
 =?us-ascii?Q?FWH9ttGo4iuuuGa7OmKCWJVW1VYKRjU0n6VxwTWyJaMd+oASyrJdUJ9RJKaZ?=
 =?us-ascii?Q?KWUZwYjYDE31kqpPtBCzrO3lqCnp6s0TcP/YgwaXjBv1LrwN3CVFEWgebKJH?=
 =?us-ascii?Q?7c0COaQPXEnzLQsudH71+PEVDDZaSktZJsZGHuA9I1e167+35xnXxSkkkspP?=
 =?us-ascii?Q?Ok7JNlsGI16byiwUfZjq5uxYv7YYbwKmUDO6/6VXaXdKTW8xbkZDuowES36I?=
 =?us-ascii?Q?E28ekyxrkQjq0vJpSJ3T/1UxgbltuAtHJuKm5RhMYoCgd/N1s+lGrCbOTPOQ?=
 =?us-ascii?Q?1B2S2w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e58bae-81b1-4d53-7b28-08d9a980a81d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:49.2402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fr9nQv2R8BdYZLu1sCnApqVnmRhJIKbwSoADfZfTjazgg75sEpa5XDUNoSX3qGobWOuOmNSnDGdEn0zjEzJd+4ZlJ/egybKAAMJd0IWiiGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: r1IqD55HttFpv1CGj4f_Rh9XOWMYKHiA
X-Proofpoint-GUID: r1IqD55HttFpv1CGj4f_Rh9XOWMYKHiA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new deferred attr patch set uncovered a double unlock in the
recent port of the defer ops capture and continue code.  During log
recovery, we're allowed to hold buffers to a transaction that's being
used to replay an intent item.  When we capture the resources as part
of scheduling a continuation of an intent chain, we call xfs_buf_hold
to retain our reference to the buffer beyond the transaction commit,
but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
This means that xfs_defer_ops_continue needs to relock the buffers
before xfs_defer_restore_resources joins then tothe new transaction.

Additionally, the buffers should not be passed back via the dres
structure since they need to remain locked unlike the inodes.  So
simply set dr_bufs to zero after populating the dres structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0805ade2d300..6dac8d6b8c21 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
+#include "xfs_buf.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -774,17 +775,25 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
+	unsigned int			i;
+
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
-	/* Lock and join the captured inode to the new transaction. */
+	/* Lock the captured resources to the new transaction. */
 	if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
 		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
+
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		xfs_buf_lock(dfc->dfc_held.dr_bp[i]);
+
+	/* Join the captured resources to the new transaction. */
 	xfs_defer_restore_resources(tp, &dfc->dfc_held);
 	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
+	dres->dr_bufs = 0;
 
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
-- 
2.25.1

