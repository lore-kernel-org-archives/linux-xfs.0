Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E80C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiKGJDl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiKGJDi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294FF12763
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:38 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78v8q9032535
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=nz/6gyNDiZ8f55Y3KaE2JhWw4d0ccM5H5XCYG/o7FjpWhaDhcOyLDyBLHv9Q9TJA3rCY
 qh6Sr7gh8ZbZyJh5sj1lB0UxPk2WVAHd1I1Htbx/a1wGND5UWHGEGgVKQkwJiBLPFFmG
 z0Jfsx/J8ufRDeTVhHQDBzpjXFhLapWXZs2XyMB8T3YNEqZlcZD9vj5N5q3dyWpswXHb
 WYDTso9bi71Xax7OLxL3Rom0+ntqQQLGcSH/sMEYs90epwiaZqP2oNfA27R75Lfzgx5X
 yRfGHzmR/eyjzZ6CuUzhiaDNxX57EsrUK4nTMfngtpbPU+M8oFVpzKSnC5qKjscZpBo2 nQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngk6b7r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77JXoC025146
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek6ua-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ah/4h2v2pUSG+pTgZx+1dy+LwlVED49CLx3cdb97gIN+rnRwuioVkwH6im+XQ3g1hCl0bH2SmNBFwvbbE3u5oAOqZvaik/kj9dgFaAlhi4WHG0zIy+BZurrnftScj81KwmD7gCLVlzC2gfAHi5IkAEx2ckRMEk2oaL+MIrOVtPA0kbbTEfN+I5XuQvaqgLvtP5xainrIoqNMy2VleNBss/trv17sIE69qTwRnZNxodoeNAuobhvSfa1ERfU1Qtdfoi2mg5+6R4AhT0LV24ALNHocXuwUQ6rLbUkG8JJ/fOGmp+Azv9itlBKYslDIJyGEzUzsasWn5yu0uQbM+/l7QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=nNr1g3rH6ZSQI6NS6hKuOroHT5DnbWfKuRw5+Jz1Pkym6ZYZxee3ulZVGICsJeQHKSNgIV11OcX/27Y1EPivO+5kumGzxoaysvtnLXqYCJndI0g8u8q1N+xvwxsbXyPJOB23dUe9/3YX7PUTzny8vHu0AUDUcezPN12o9VIM48Ze6NX1zk2TrjCuyHyY0IoxR4eKYxvyvjV+sf5c2WcI2NiUAT4hIv5JDIMIi9bMyowYCoztKZHyqj5hDVdgVVihnSADdB39jhrZruhzREL/srEv3PATV2xJ5viwlDJMSBdLICahiitdoFdc9qsYX2G1VOZSkI2BiR1LVoy8Z5TbuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=xm6bbglkESRqPC26d9EV+LpL5k9vmdp5Ep9g+5YNZEVp0xsV3wXT1gXZ7rhE/lT23s03b2tM5gLl+q7LhR8QF2gtF25NGRNlAUFn/A/9XEGQTKLWJ+y8p5AzLfg8drCzDf7Pd1UaHXgG2j0M0PbkqDks6rSObaB+vVCf6WPDpgE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:03:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:32 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 25/26] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Mon,  7 Nov 2022 02:01:55 -0700
Message-Id: <20221107090156.299319-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:332::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a673928-5bfd-4cff-aafc-08dac09ef1c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYCNa0dbQNYoRnfE3ExeO6jzD8TzRaM69gWihaI3ioQBvN2Zj7Z+5FK7HYJgV/C9RLyXEC4SEED+21of7ee2y+L+rzUJ+Po1RururFARrElwC3sRAwldDOV5WgI2d2PZ+vQvttAqILYjx+4xp5R82+TONKPOyDJ/DGfLyOxAqq2zWBJvl+XZHzJ7H92lR/wav/aGyS+OCJ1fPgImimo2E6b3E6DkZeJlqHiWBOID7maeO3v4exA9L5uzNke1vjYJL+XP6IeBvnZdIwhDWmFhcXQRrqRwbcU4HECFWGXE4VNQZmXYRgq4c71vwlwBh3ULOxNOu9XNVws+scY0IzDMkCbV8t/5xgNmRxPFmMvxPABp1tJCOCGHtgT+cUprqMffyH8nHjaIa80y5iBfkZVOTvIOef3H3nr40/WI+7fDxAF9+RxDGUhPJCSXkhM3O2RxtVswKxY4nlfydOLqfONAAo50BeutYXWoBzxIuyWwFkcFCJHQVU4/zxv57nEZ5tmuWNHYsGVZ9MS0d6szZOLWEG58uiSvQrPNHZXI5T7+RpzBFobhl7sKd0RkfWC5X0nasnLVdmchLMHKy/FaB1bkzhRzOZHGMQ6DeSjbVg5I2pm0Cre+tcgJAlEABy9MS6LbpC97rK1ewx/A6aHUEd0rqxt+2g67bImHRc3wipVxOzssLMRA7oCwrVOw7tIHee4rgGS+RFhYh/J2QcPRjIEGNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(38100700002)(6506007)(36756003)(478600001)(316002)(66946007)(66556008)(8676002)(41300700001)(6916009)(8936002)(1076003)(5660300002)(6486002)(2906002)(86362001)(66476007)(83380400001)(2616005)(6666004)(9686003)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uu0uUEEwIdCPQ28PUAdXAhkZxowLRtqNqQ2iMlT9K2UuNmhBfQLZyq+7ad6b?=
 =?us-ascii?Q?pVBAD5RbAtB8ti/L5VciyMaqfkYBg0Qp++fNT/wwHozkqSnTezX9NQuUoKkp?=
 =?us-ascii?Q?guc7OnFklXxGpmrexCz2BxqxrpTPcACbfBe9kC1wPJZpkeK1TAuipeCGjhdf?=
 =?us-ascii?Q?BEjIHZ1qOnc17BKwKcN39kueIIar5Sto/f3ap3Edo+Jf81TyHzvcX9hSCB5Z?=
 =?us-ascii?Q?cHNKJ9TNO/HDBkvVxQ+YsZsZXrR1qNIuAenyZjLTXaC4R6tHTmxxxO7XvC9j?=
 =?us-ascii?Q?hHFihePb/RoJnGv3i5mjOpom008EpxJ089uWNNHW3qx/MLO8o5jx4mk1eepm?=
 =?us-ascii?Q?ahf9/BtP7LPcV1PRUxbhv0eBAi9hu54L9cM2L9/8ek+UWjQeqgnMBTSglun7?=
 =?us-ascii?Q?kJTTgXFW/BgC0PPy+JeUm05+DNEXi2aGn0snDBByGAbvEEpkZnut7pqU+dE+?=
 =?us-ascii?Q?Zs5BFJDXW86Fwkki505iH/PQG+J4AIWp6gksfeeYyU6cUUlLhJ9Wuzd86c6Q?=
 =?us-ascii?Q?sIzA3GSfqwJk0p9JzlZQ0AMLZqu1i5y6p0+jEK9LbNoPHsQ7x5zfI4fBTqSs?=
 =?us-ascii?Q?3g6wZ4nSA2ta6Q9cp2qzaG5LpT4Nt8pF479xNI+twAOqXS7r+f78Egcz8IVJ?=
 =?us-ascii?Q?L+A1xK5yGHb0XW5j4T3L9AB7fOiZPv0m62sioz7/Pd/a7AM4Q5TY0aRDXGjP?=
 =?us-ascii?Q?PdMlJtvnsG7BEdzieDqR/8qCFitrH1kinKRRWe8W3sAIZLeIHWBjST7wa+H5?=
 =?us-ascii?Q?CAq9fU2mXxG/HEtPzFCxU7SSaRHwu8aCYLgx91rDR651l5hv8xb0L9n7wXfR?=
 =?us-ascii?Q?oqZ+PMdINK/Fx4Qyf4NwGYbt8ueBtOYpqTs9V8ojPxM0y73Iy8fmDnStYs/5?=
 =?us-ascii?Q?p2+7VPS+hYDOHKj2KnMjXCIp2/c1Wjp8UC51WmmahhjsUNu1VWhXz+PnpEx5?=
 =?us-ascii?Q?5WOMvX1furDBaUeVlY9jDpjZEbrM3KnstseGlNBqjYlZuye2s2+e7CWcbAZC?=
 =?us-ascii?Q?SNT6Npal3tzUsddFYxBqnJN2CzGUJgausm+IwZGiuye7eL60p6IfKuJPrHQW?=
 =?us-ascii?Q?CafowEXzhP++82ih7x4+eMOgZY363MoO+QhjIWSabpgSqxvz7cD2fJD/1wMY?=
 =?us-ascii?Q?xJuJWXzQFUf1Oa3GYV7Nl3tpEaRmhKpvPy522iq9tPYrjDWuvFEkY29VFCo+?=
 =?us-ascii?Q?MGkt711+eZHaGnixACpGugQeCi4B2EzMQUXv3KT85ePdEY3pSWQr2Aygxms0?=
 =?us-ascii?Q?P9iDDEhdRMaZQVNI13R+0ZZKkF6M7VjDhVWLyONXK588sxE2SGxFmJmBbyPO?=
 =?us-ascii?Q?zpWu+1hmQ5Yk73SGdpa41NNvmr46bsQtSPvR/OuM1jHa+pGT6HU7c3T0pIqY?=
 =?us-ascii?Q?bfVi4cva0Yu/kxjEWD1N4nDWT0QYIVWMHtiPgV+BliIbWB+JTlgktOTnYqlH?=
 =?us-ascii?Q?ooq6HwbYlOQF76mYRUxp7xInsIzJUFZBaoVeaIKCsXz/k9g0JrRH9XbB5bUB?=
 =?us-ascii?Q?umRNdslzMazL55V5RP3T1boT1A85o+oFjVa1z0yPR/gP3+79w4s8+4VQi0HK?=
 =?us-ascii?Q?6A37JBNgyWPG4ylPrHhh9U7WzkBT4Sidzr2GWcaE0idk/cBK7mYCl/RFan51?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a673928-5bfd-4cff-aafc-08dac09ef1c3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:32.0469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cl/iJrRJ+Qn79L54gTjbxaMkkiT7vpsBWrqVLyg68LipjAtCynHqlFaKX8CJ40e7Kswvev600EkZ0cdw34RDSeb3xSn/TV7d5wSTfzdVQY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070077
X-Proofpoint-ORIG-GUID: gbHiPlap2cpHADPkKRBDYk7cnkP3su6t
X-Proofpoint-GUID: gbHiPlap2cpHADPkKRBDYk7cnkP3su6t
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
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

