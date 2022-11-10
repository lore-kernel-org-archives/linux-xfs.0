Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F3FC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiKJVFx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiKJVFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382EA4AF1F
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:50 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL2xAm003525
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=/MFjiq1URFRRzE3A8Y/bnsoS2I3yKUm3EY8PgZNK0+s=;
 b=G90X77FrbIasv/f7Gj8aSUMc55WHaPzD0qvD3sqjCmUJQ8GpRKhKdNerJGj1W2qNtbF5
 oiGG7I4EQeHSf12xC3ptmvr+95tNxpmCmEMK9MkPyvXvjJFarHsjgX9YipdrC6wk1ObQ
 jpVa9TH42gzAKeTmMiDD29+ej8yx9C060O2SHDOvPtpWLtSXm1mfTT2ZUPcGd342ftT9
 BvDZLQdVjtSo1S8SpCQyird7GUqRe33/Z1j9uCJdL6D9AXBlasneObgKUadGp5g+NfQ9
 53E8aI0aDxAwhjCmGzXXBcWMkkXUuG6hiNFIj0PRfq1nckYxjzqRcfyOFhJqubfdE48O Ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8vcg097-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKeTiY038169
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh4fjb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPsaGCZLA9gZcLM0EF0UEDCkb/2laP6R4fmGPPJLExX+IaTU6epoym9pdVe3g9s7gxVSDODn9UDvvt1CI92qIqDTOPjCrSp7/2tRNDPM95hsiadT29xQhQe6RzcC1jvnFQ8B6J+K8/AFitzvAjnf29zhJ/dJanRI4inpUm3ZCa6h4qURR7Cwtsw7h4PxP0J6wOqjm0Ub4uBdCHTLF+/stNQxUsIBcssVD9RL0rWuxqyZ+n7nrenaR97P2EGbw97IuES786DNpYI+8URZaC1ZWM5efgCEsVKJrbKzvdzEdLqXbGthURG89wtIcOYQRb4Cz1uIbMw8NWfS7GqosXa4JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MFjiq1URFRRzE3A8Y/bnsoS2I3yKUm3EY8PgZNK0+s=;
 b=aMDd7MEoptG/J6j74ArWX0ybKmneX1UFi7k+zlXfmIh7DNlSu8ZCF5LFKGn7nQfID35m9COizg9tP/QPYAogHg7QSqPv8uHhW7cM28SnmCoyOxdNnPvyog2nIkPailUPiM5nElfU45v4XWE+t3fA4bRvhbpqrVx2bozF5psd8ua+HHxLfjVpgAq4p/uD7F8TG2HFrty7ehYrCt9e2GxKU3d3YKdPuhKY22StSTw85WOHsiT/2L4im9ugjdHROJdu6GFSWY/3jDPBm1yzJzN/fJrtAXGHhET9Ob4y8OOspHqzn8M533kTioVf6yNFF+UoRw7Qs29++bfIv6mkSnxxKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MFjiq1URFRRzE3A8Y/bnsoS2I3yKUm3EY8PgZNK0+s=;
 b=hfCf6WYuCG1b2oiQYKgrC6FKF3FtOLu/1mBDkb+cnFLPG1JP/QObs3mtSmrIzAD0RUqjkRVRX4aUs+bjIXZexLpAl1NcNyXcd91vimEOtZ55IyJsNGbmEgf49P/TxnTOqVvGvusYRdVINKCDx+ZIO+EGMmFFwYS4zzwA9+VeSi4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:45 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 11/25] xfsprogs: extend transaction reservations for parent attributes
Date:   Thu, 10 Nov 2022 14:05:13 -0700
Message-Id: <20221110210527.56628-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: b026f78c-702e-4314-2c8b-08dac35f5574
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1NokF2XMg7mQAFz4I/HbnHUG55K0bfsVm5LVpeRCmUKlnnm+//aFKQhUCcOsWM89hqEanhCJdN1dif/l/iEgshV+CYD1fYwPcJVqsL4b1SRWPzVJT1uzZFxVvPnUBHw0MCq5BWHkxv3poY2wevP9Q/YQoXIR0xKH9v+6wq7ooHQyVeeWOoGMxMBVVsXFTV4/3JC+C3DnJd41bIpClVUNUgqURO1FBhX7dBZMnmAF9iw41YavCe1jCe/qMtEMezp4J00e7KWcefnbsiqH4WBwD2YONmrWWSy6IRsuy5NtKrO/MrMHjY5cDdLdWN3ByTkFVT7C2H80zsFhQ95kemXEKTs+LE++f5oR0s0d8BMlZf6movHxREIxCxjIpKNG6OgpEjfnuzWFTBZjpWO52b7/UCkcLyUu6P0NT2ubKGLUZrJSw6xoX74cVR0QHWLbq9qUY5HpsoCzKw7i3PXcM9Y0FjBt33j0Eam7kRLo7Xq/AmCIruJuDSu8EgyUL77i8jUzdJmzZvY5EWYESbwc4JbNWEiUreBy+gWcuGQcSOIvqMKrqwnK0AkfWOZVKw34F0/r+zwxuohccijKIeYK6BpIUmiLqHfBX8a2uR7zZN0dTo4OnWQw7F+vFrZAcRnv8tAzpX4vYkpA4mZuGrnfL2850eJ7usdc9JA0LsaAmEvCaO55Dq4VP4/8zrD+6Wzcqiu1fdNMUW298UCR8ocwOm3dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(30864003)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?slky0mcttMdu7dj7dg/D3W8jtDBjPqJocxuTMa8lrA88DOiXTpcyyqu6Q/nY?=
 =?us-ascii?Q?oRnS85vG1KzNARFBum7krZs+yFSpbVtq0szANXnI2SBzMqRr7tscGSKSpHi+?=
 =?us-ascii?Q?ZSObXl3SuKm30WmIxnfuYmcfkbsh9lHJTastjf3bIPhvKsmBi9OJVz4h86Os?=
 =?us-ascii?Q?7m3RpMIUHiKLp/vSwAZVVPBCuIE/8UAukfHhRsDEtsHgxdUhF6oniVSTe2+t?=
 =?us-ascii?Q?2OVsci2YnIgRk6LMaWXcz9QMwzzhum1sRGudoOrpjmryADjzPr5qy3nErKvm?=
 =?us-ascii?Q?eOVNXAPPjHfDmlEk/JDANW2DTaUuJyxvIhEPPN1HaIPDwXzpceetVB56/34B?=
 =?us-ascii?Q?sjBL7nEvxFo7mfbfkLEBTS4KR3rD2DRQx+ofoFx6WK4Zr+A5d75yfQs2NGbg?=
 =?us-ascii?Q?rASEp0t7UmTOkPNIyIRUBy+di7heH7TG5VwMOBlj8hG1mK6YJ6Uxhxn0Mb1N?=
 =?us-ascii?Q?PhHIUGNlvHyDwZikmOIl2QczEJeX08+nu0Xgv10OPvZghqQSmCGX6CSq+dlg?=
 =?us-ascii?Q?sC+OJjTz14LZR0rRYVOnaQ08rjubXxT72p9QGIsx1tx7E7YI546gnIvYJ/ln?=
 =?us-ascii?Q?N+W9gzVGW6qDOamlRupfGwz48pivceuqxfsKWr+LgX+U96DxuHqLtcbcjRGk?=
 =?us-ascii?Q?wggKX+FWApT4/ei5wylIpwZ8/wPEFWmBdMpc5A3163a04Tn9ANwZn0kJeazo?=
 =?us-ascii?Q?GQqLiQchciVUycV5W97jn9+TXElNYjJ5hy7fYTEr24o/jT2zfVvN4kx9PUBo?=
 =?us-ascii?Q?yuBKA9j7eKAhCjuTB9KLRut3JegbCrdheBf4MR73qtIAcY7ULUOPWp6/sgIy?=
 =?us-ascii?Q?daNi0VhcuAJKw6dS1U/OqSkX/bxffKyi9UhJZd4ixysCq0j0kj5M/GzVxZWr?=
 =?us-ascii?Q?zVo1vJuOVqr+Wt56QxdpkIcqJjUI+YGAvC1VvRLnJZbWTy3i5G9Z3g9+qT10?=
 =?us-ascii?Q?eQDcpEvZxTiNgE6o1ohysgpKeYv1dS/9rMYKnJJnsVe/yJt7XcpbqHuetoZB?=
 =?us-ascii?Q?0IQPgEAl9iwedIYPJZY0WmgQWl1WbjGLYnLOnC5Em9B0ZqmVR50WNRje2ZUn?=
 =?us-ascii?Q?769isuQtO/FMwSQQg4N0aqHDg79yFO14WL6iEavpBD+9C4OKoaSrj0SY7Z3C?=
 =?us-ascii?Q?jrjymNzyEdJ3om1Dm+kpB1aX0Ots9goKRRwor7hACWXvYSwgAn5Dd+xzXBN2?=
 =?us-ascii?Q?j7ZWAvTEKH1CyUZWXlGJLdIbLd9mHEr62w2WWDBsotwheeAN3/fShMZbWFvH?=
 =?us-ascii?Q?cyUL2nOPvuRKLml6fsW7wTy8tGlPVhhSlyJlSrmQmMTsPWzBFtqP2C533bzO?=
 =?us-ascii?Q?+trjHHYDw4RQhD9y5XL9yFUVcSRBtpXrjt78u7Xvs/ssmEZNKrVnxuyzbXKz?=
 =?us-ascii?Q?KshZCx6qGg78/NECq/g4uJjrsgBGX6gGLKakM36mTD7H+1+ddnCfORCmy4Gs?=
 =?us-ascii?Q?2qGkOU7KpdmUQZxjsWvaPubzxClj1rU80Hx05gV1kY7zkMcrjgQIGe0apZ9y?=
 =?us-ascii?Q?nYbSoOq/QOcOhC+bSI7ywHIKSkHsR3ruz3CMvtixVtLlxYa4u+WTCeyF02H7?=
 =?us-ascii?Q?rCvdCQ3ghXP6eOSmVME7wrpHtll7Tqr1u54lKsmxywXAP5nyn7AAMrETgyXx?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b026f78c-702e-4314-2c8b-08dac35f5574
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:45.0426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZGaMrC+dGLUnaMtSfyfknKV3DCQCdnWOldE4Z7XjT9KE9XTkvYbvhCWpVFkZjmqrHF3RdLzUNonWqjZ2GZiWAAtgSQD2c3r+rcETvaYZhDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: K21GpLEy6WIq5Focxu5sQWjmQMLyneOk
X-Proofpoint-ORIG-GUID: K21GpLEy6WIq5Focxu5sQWjmQMLyneOk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 99c10e460207a624b3e243e4a3665737d436d08c

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/xfs_trans.h     |   7 +
 libxfs/libxfs_priv.h    |   1 +
 libxfs/xfs_trans_resv.c | 322 +++++++++++++++++++++++++++++++++-------
 3 files changed, 278 insertions(+), 52 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 690759ece3af..8d5e59d8a5f5 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -58,6 +58,13 @@ typedef struct xfs_qoff_logitem {
 	xfs_qoff_logformat_t	qql_format;	/* logged structure */
 } xfs_qoff_logitem_t;
 
+struct xfs_attri_log_item {
+	struct xfs_log_item		attri_item;
+	atomic_t			attri_refcount;
+	struct xfs_attri_log_nameval	*attri_nameval;
+	struct xfs_attri_log_format	attri_format;
+} xfs_attri_log_item_t;
+
 typedef struct xfs_trans {
 	unsigned int		t_log_res;	/* amt of log space resvd */
 	unsigned int		t_log_count;	/* count for perm log res */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 6fd7ce42d3b6..b2bad05ba3b4 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -521,6 +521,7 @@ static inline int retzero(void) { return 0; }
 
 #define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
 #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
+#define xlog_calc_iovec_len(len)		roundup(len, sizeof(uint32_t))
 
 /*
  * Prototypes for kernel static functions that are aren't in their
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 04c444806fe1..1ab3e5684a58 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_quota_defs.h"
+#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -419,29 +420,108 @@ xfs_calc_itruncate_reservation_minlogsize(
 	return xfs_calc_itruncate_reservation(mp, true);
 }
 
+static inline unsigned int xfs_calc_pptr_link_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_replace_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+
 /*
  * In renaming a files we can modify:
  *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
+ *	of bmap blocks) giving (t2):
  *    the agf for the ags in which the blocks live: 3 * sector size
  *    the agfl for the ags in which the blocks live: 3 * sector size
  *    the superblock for the free block count: sector size
  *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ * If parent pointers are enabled (t3), then each transaction in the chain
+ *    must be capable of setting or removing the extended attribute
+ *    containing the parent information.  It must also be able to handle
+ *    the three xattr intent items that track the progress of the parent
+ *    pointer update.
  */
 STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 5) +
-		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_inode_res(mp, 5) +
+	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
+			XFS_FSB_TO_B(mp, 1));
+
+	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
+			XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		unsigned int	rename_overhead, exchange_overhead;
+
+		t3 = max(resp->tr_attrsetm.tr_logres,
+			 resp->tr_attrrm.tr_logres);
+
+		/*
+		 * For a standard rename, the three xattr intent log items
+		 * are (1) replacing the pptr for the source file; (2)
+		 * removing the pptr on the dest file; and (3) adding a
+		 * pptr for the whiteout file in the src dir.
+		 *
+		 * For an RENAME_EXCHANGE, there are two xattr intent
+		 * items to replace the pptr for both src and dest
+		 * files.  Link counts don't change and there is no
+		 * whiteout.
+		 *
+		 * In the worst case we can end up relogging all log
+		 * intent items to allow the log tail to move ahead, so
+		 * they become overhead added to each transaction in a
+		 * processing chain.
+		 */
+		rename_overhead = xfs_calc_pptr_replace_overhead() +
+				  xfs_calc_pptr_unlink_overhead() +
+				  xfs_calc_pptr_link_overhead();
+		exchange_overhead = 2 * xfs_calc_pptr_replace_overhead();
+
+		overhead += max(rename_overhead, exchange_overhead);
+	}
+
+	return overhead + max3(t1, t2, t3);
+}
+
+static inline unsigned int
+xfs_rename_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	/* One for the rename, one more for freeing blocks */
+	unsigned int		ret = XFS_RENAME_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to remove or add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += max(resp->tr_attrsetm.tr_logcount,
+			resp->tr_attrrm.tr_logcount);
+
+	return ret;
 }
 
 /*
@@ -458,6 +538,23 @@ xfs_calc_iunlink_remove_reservation(
 	       2 * M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_link_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_LINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For creating a link to an inode:
  *    the parent directory inode: inode size
@@ -474,14 +571,23 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_remove_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_remove_reservation(mp);
+	t1  = xfs_calc_inode_res(mp, 2) +
+	      xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2 , t3);
 }
 
 /*
@@ -496,6 +602,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 			M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_remove_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int	ret = XFS_REMOVE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrrm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
@@ -512,14 +635,24 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_add_reservation(mp);
+
+	t1  = xfs_calc_inode_res(mp, 2) +
+	      xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
+				XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrrm.tr_logres;
+		overhead += xfs_calc_pptr_unlink_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -568,12 +701,40 @@ xfs_calc_icreate_resv_alloc(
 		xfs_calc_finobt_res(mp);
 }
 
+static inline unsigned int
+xfs_icreate_log_count(
+       struct xfs_mount        *mp,
+       struct xfs_trans_resv   *resp)
+{
+	unsigned int            ret = XFS_CREATE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 STATIC uint
-xfs_calc_icreate_reservation(xfs_mount_t *mp)
+xfs_calc_icreate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max(xfs_calc_icreate_resv_alloc(mp),
-		    xfs_calc_create_resv_modify(mp));
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_icreate_resv_alloc(mp);
+	t2 = xfs_calc_create_resv_modify(mp);
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 STATIC uint
@@ -586,6 +747,23 @@ xfs_calc_create_tmpfile_reservation(
 	return res + xfs_calc_iunlink_add_reservation(mp);
 }
 
+static inline unsigned int
+xfs_mkdir_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_MKDIR_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * Making a new directory is the same as creating a new file.
  */
@@ -596,6 +774,22 @@ xfs_calc_mkdir_reservation(
 	return xfs_calc_icreate_reservation(mp);
 }
 
+static inline unsigned int
+xfs_symlink_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_SYMLINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
 
 /*
  * Making a new symplink is the same as creating a new file, but
@@ -908,54 +1102,76 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
-void
-xfs_trans_resv_calc(
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This requires that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
-	int			logcount_adj = 0;
-
-	/*
-	 * The following transactions are logged in physical format and
-	 * require a permanent reservation on space.
-	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
-	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
+	resp->tr_rename.tr_logcount = xfs_rename_log_count(mp, resp);
 	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
-	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
+	resp->tr_link.tr_logcount = xfs_link_log_count(mp, resp);
 	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
-	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
+	resp->tr_remove.tr_logcount = xfs_remove_log_count(mp, resp);
 	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
-	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
+	resp->tr_symlink.tr_logcount = xfs_symlink_log_count(mp, resp);
 	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
-	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
+	resp->tr_create.tr_logcount = xfs_icreate_log_count(mp, resp);
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = xfs_mkdir_log_count(mp, resp);
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+}
+
+void
+xfs_trans_resv_calc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	int			logcount_adj = 0;
+
+	/*
+	 * The following transactions are logged in physical format and
+	 * require a permanent reservation on space.
+	 */
+	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
+	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
+	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
 	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
-	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
@@ -985,6 +1201,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

