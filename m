Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4EFC6FA90
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIVFpp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIVFpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7A390825
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3Dxga019757
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=CjLFkNlrPeZOStSfwnOXfearjo3kjuU1d/K7kssrV/k=;
 b=SbyVrRWkgJZcyW9Xb3oEPBso+LCLxkFuTf1xqlStIBQBBDrSYuEbfuNgGNY6xJElALYZ
 Q0JdUQhxucPyUfvOp0pfwE63vilrjkPjw2yzXBKNZN2ZAbtJq2nOxW/bFABmmy6kIUxt
 0FCqXRpKJqpCxNKODIDqUfZ5cWFpaBj5AMCxzjYbIL7bNZEnN7PSz64yMeVNrQLPUqbW
 eu+uwBnbYrYGdkpLgAB0wmDKLTVLaHwuDB+UjL9DhLMt5tMkj1TDkYvKo3y7cq8Zvcsl
 hBRBlFN3NvH5PYqtDs/G2l/q11DKTU4tjkXOW9V++G0OLtz+29b2W4n9JHANVFcJtaXp ZQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kvchy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M1oMdL036614
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39fmuy1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQ2ZdZQvobK/+VNueJOz2WqXe8daChYUReWAqoojDztWwat13YXR1acyKZuGn3vROl5YfCZopkoyjkPZkmCiLOzjhQ1NBS9ICK7JHvNxrsg8q1fsHm0eHj3k1earY1eT66ugJm/HykdCXdTeqnsorNao4I8uzBVMHe2T8O9alNvWb0aN6bXSroWvFOvR7GcgVV59wfYFe/bZbMW9Kr/WHKC56pDO/JuEwuqID+YF6jqSGzjf4nSzY6VBNas0ETGrjbZrgbhZvg93nzfWkPnKt8JYWP+uHQ0/H9OnuBn8a0OyXYXt5jZ+X0QZbmIGSWY5cWx9XzeRY5FXXQRQo2mNfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjLFkNlrPeZOStSfwnOXfearjo3kjuU1d/K7kssrV/k=;
 b=IMdGrG5zd1a6AXdB60C5bThPkksAbMxge41n0gi9TQnSddu75nvfcq2fTT/SWFk5+G53L8rmDWQuqkfCqz3wSaeQD66ds1JJ98sQ7lIT6TPBQtyUuXgiSh72DCycyK1NDr0z4fIPZF6gKi3kfXY79bEDC9Vwp15jQO1axuL7i05q1rNlYLume9o5hCmv5n1eaEglLFoHTfemRKzTDMKd0BcF23qie16B7FoTctstNyOJ9Bc8z0hO1LyGE6il6w4WWEL99X4ilnyPHAYJLXrSzXFkVR9fNwsgn40iXmveNxic7zLgZrz2bzqZx8K89ZObDe/EbpsiABjkZov9XkJMog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjLFkNlrPeZOStSfwnOXfearjo3kjuU1d/K7kssrV/k=;
 b=tgnfIe0R2I8f45cuCYeNooSAm5qr8HO9fBzlCxIRqwR/PHdIA9SmMPqdviVhSzbrFmK9NMW9vNNM+iRfIDlBIivEOau/Mr1rjKGAm8q7CXu7kwCxfe0/7aeQepofLLhbeiP3ZGYk50qv1W8MCMvhaJydINjG8+Er+TR6ziRpiJw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5952.namprd10.prod.outlook.com (2603:10b6:8:9f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Thu, 22 Sep 2022 05:45:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:36 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 25/26] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Wed, 21 Sep 2022 22:44:57 -0700
Message-Id: <20220922054458.40826-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5952:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d5339b7-41b3-4157-b184-08da9c5dac2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mCUflICTTMhsHDO55CU5h6oy3edTl5xsDXFVc6J49NEPgeCTi6Is56/eKJqmKZCM45OrzZL3swlvApJHu/GA2o7BEsJPVCzd7AE0S8LeNH4LjByievZJdETBkifi6Dia/ObGf83JDXCKZeaNwSciT2mhgW3mCLGSClc5m91qV7c13m6qsOzW7shK3Rmiq7WY8LeVbj+/BoNIQUXYjHMcKUnu6LrlY0pUPyEOfyg8xKsrqUp2mml6TLtFv5JTyCB+NfHcUwXGYA99csGywm9y00aSCnj+hZCv+IWZzVSHQYySMBzt9NgBQ/Wv1JKavTEi8s3Im1DrF+SKYU/xMfqYWMRYQ80dRREVGLeS0pnjPGPsGeUK71dg/MSDeuRvaOVxUy96Ub3vjFFqOgglIh8ZhX27iK2iJK6R6gCx0pWDb4bgXmbnC2m0hu48mWnQ01JfPsC8kVX6mq6xwOSLzNnxlqkbLoUt0wsuNI8rbsLSlWH0Xur1uhGzqLBqdw+Ne6fngUwEYK+AtqVBKpNPVExmrKFCGEiZUn5WPzNZULBlgLM/4IYabxlqN94iGrphEeWfhhbEOKkREJCwH3GwlRDCpE7RTCXj2rmdIKVztp0xiS5kMSeoMwucYruv2sknqAmqyGqBmWHoxQLuq/P7tXP3t0iq6knNx4WOIsWfy9h3GLBuHem2JB1KRNEcyzQsiaxZXj5Z4e8pPLmeDSuOHp6Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(6506007)(8936002)(26005)(6512007)(5660300002)(6486002)(316002)(36756003)(86362001)(478600001)(6916009)(66946007)(6666004)(41300700001)(66556008)(66476007)(8676002)(9686003)(38100700002)(83380400001)(1076003)(186003)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k8tUgs18ucIuocuUbkmr4FCEQ+4/whe+zviBFySeuyID5vEYxmT70eZZRm8k?=
 =?us-ascii?Q?S7vjli6jtK1aUmUYPgA7ZJ6pRX/VHoBJ7eKm/l8pRh4eNxvK+/RBSym/Kfbs?=
 =?us-ascii?Q?SHeD4jgudXRrsDxE7AyUS6+lvFWZnqAfoVZNIthUaEBYOG1GiL25nQsZ+bMP?=
 =?us-ascii?Q?R2Q7X/Je8J5glfaPOqlFvV7L81BCowoqMJNhIllHTVJzZUozZP4m9idyI2wE?=
 =?us-ascii?Q?8cYV9fJBanH4h9f9txuOGaaMwnyZjdCvX9KYNngyoRHNNtr3xkK2TYsvaB4/?=
 =?us-ascii?Q?r4bSmPsle/NJEZCEH/SFXKL32SZEmtGFso4asr/ow2og6M67BjwZz+EIbBS0?=
 =?us-ascii?Q?HiJ+D506O4gP2nXQFRURs4V2nJ8UU4IDBR1vzA9KkCBBVsmisaUkIpT1SFVI?=
 =?us-ascii?Q?nwuXdtSbjrdokcIkBnrePAI/1oihXoHQ3ibvcoE954/M8YHzYrapKRyonR+g?=
 =?us-ascii?Q?79PWZJ4oz+OdtV7aaYBcVUhZURvuBjee1VimoUqfNZJlnjPQCIzSRfcsuHNj?=
 =?us-ascii?Q?pu5AaWQ9AQ4FBoVpsCsJf1TH9kcycfBsix6i6EQ7hl6ABJ8GuAZ6t+xlxiJ7?=
 =?us-ascii?Q?3tjEvIrv7+uwev7VbxtNIEUto2ybXRkMNHrMQXq6zt7qZC1Ye3nPmbL/3AWr?=
 =?us-ascii?Q?SF+ylbtIif2joZCIWzrE99svqi7xbsxe2rjIgmyDvDWW/fLx9qxy3TWm4EkX?=
 =?us-ascii?Q?uImL3jIhz1MOz0g1ggI4q0ND/JZFxL4ev5AQ6v6ytJaY6gR52epEW9ybE9A2?=
 =?us-ascii?Q?2zaY7oQ8tHQtP3Hj60WnyAl9Xilf3Z6PkNp1kUQDBrHxPgaOQmBIsYfgjw21?=
 =?us-ascii?Q?FKJzucUzr4r7td95Z6TgbZWO1lKS0gQNGC1HB8sf6VeIQc3WUH7zc3mr+WqD?=
 =?us-ascii?Q?hhuew2qYLYyhpBsYYOzU/c7XobMoa1B6qacVl9uXgXxYmlTGV+eGbt9tDBff?=
 =?us-ascii?Q?q7+B6XZ/vhlyE04UGfdCqb4SFp3DO3vbWabbQbo67iO9uk+X2e3HSwZgqAqK?=
 =?us-ascii?Q?4bLSnCXkH3k5HzVn1TORDjMNNPIo7Sjb0Ok11xorhSa0eqdeT87TOpwsmjeW?=
 =?us-ascii?Q?ERhhGRpnNM9R5OoiGk6RdOIkzga6P7L3d76wCfRa9l8NMReJdzXntBQ11+jo?=
 =?us-ascii?Q?NV0MBu+I22BsCpPKDpx3HzRO6DiBid+h0hFlsaGon2RQ4HNfW2itC5XLHpv9?=
 =?us-ascii?Q?L9vlrWdTKFCgr+cqslfy+cegDK6f6YsJ0k3Xr1VSyDMjQ/MlJnOccwXjdHPF?=
 =?us-ascii?Q?Ei7XCNUCUG1jU+7bo70EWVOV1ulp8U6g5cBHOxsuUkQGNvxPrULA2RRxcSSB?=
 =?us-ascii?Q?XZoSU+2ho9B+eaRG6O3pGiPamwVhgYdYpHhv9KpNLim57J2MaqUh9Nvlgmpz?=
 =?us-ascii?Q?kEF3ER4FNtqjjQeZr8Rg57zn8ggbiNeJV14xSO49uKHb+HDKTbKnWmlmRz7O?=
 =?us-ascii?Q?Mub1IiL8C3E0x7VS3CrHB+SszdGFU0/quWikKHXrrsSgd9CQ7bPMMogrKNg5?=
 =?us-ascii?Q?HzOTuARRQ/b7p0skjx0rIdtNiTjh3hKGz887fvO6tQ2/c2hBNKOt/6WY44of?=
 =?us-ascii?Q?ZaiNtawLnIwFkKW1lFqs/AppNzI8a+Nj/3838CRtatw6x0w6RNCVBXFeGcK2?=
 =?us-ascii?Q?Gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5339b7-41b3-4157-b184-08da9c5dac2f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:36.1982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjCS8btZn0U/u+VewuyxHdeMv765SIW39Sjv9samQ0XmJy3QLt/AZJ61l4frT9jxu7ceYtjvGfgVmv7T7MFouU0VSXUjVh1Wqr14aKeSfSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5952
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: SGQw7yI7OymPtr3uanqIcF4DDvczlA_r
X-Proofpoint-GUID: SGQw7yI7OymPtr3uanqIcF4DDvczlA_r
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Dave and I were discussing some recent test regressions as a result of
me turning on nrext64=1 on realtime filesystems, when we noticed that
the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
blocks.

Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
contains the maximum estimated amount of space needed for a local format
xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
which requires units of blocks.  This has resulted in an overestimation
of the minimum log size over the years.

We should nominally correct this, but there's a backwards compatibility
problem -- if we enable it now, the minimum log size will decrease.  If
a corrected mkfs formats a filesystem with this new smaller log size, a
user will encounter mount failures on an uncorrected kernel due to the
larger minimum log size computations there.

However, the large extent counters feature is still EXPERIMENTAL, so we
can gate the correction on that feature (or any features that get added
after that) being enabled.  Any filesystem with nrext64 or any of the
as-yet-undefined feature bits turned on will be rejected by old
uncorrected kernels, so this should be safe even in the upgrade case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412..e5c606fb7a6a 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,39 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Decide if the filesystem has the parent pointer feature or any feature
+ * added after that.
+ */
+static inline bool
+xfs_has_parent_or_newer_feature(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
+		return true;
+
+	if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_RO_COMPAT_FINOBT |
+				 XFS_SB_FEAT_RO_COMPAT_RMAPBT |
+				 XFS_SB_FEAT_RO_COMPAT_REFLINK |
+				 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
+		return true;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				 XFS_SB_FEAT_INCOMPAT_SPINODES |
+				 XFS_SB_FEAT_INCOMPAT_META_UUID |
+				 XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+				 XFS_SB_FEAT_INCOMPAT_NREXT64)))
+		return true;
+
+	return false;
+}
+
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +64,16 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * corrects a unit conversion error in the xattr transaction
+	 * reservation code that resulted in oversized minimum log size
+	 * computations.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +
-- 
2.25.1

