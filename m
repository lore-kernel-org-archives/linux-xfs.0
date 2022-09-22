Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D196FC6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIVFpe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIVFp0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A951868A7
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E5ng022049
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=sxCmQxu+JOW3mHfwwJf6+3kU845htts9Cme/qPpakmI=;
 b=UC/9k57Ls8uJU6koG6SiwdTq2+TVIShGhwsxa4gpIwEDWFXRSVzHiAtLxFbrMHB2Zehq
 ZtbXJSPuBsTFy/3t01HsMprH2HM6Q6N5h8wR9ZvW8af3UjBa6DMMnvH7aNFFv/ZpuCtH
 X1Ca1j93aLg91oumRCao5WvUll082ANxN6kmiFbwNmCh6g/2tSH85W5VxPd+xAm6TnDX
 L6QqZRzkf10Zr7d33lh2Mse22cfbvIPOqfwMuJybxD1ijCuhyXss6IPWll6oMd7saMIk
 zhUkaE1T54BceqTyupQhpQ47DL7UAG2itCLP5jR8CgOvrFj8g7i6jpoz8sbIkFPj433k QA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688kv4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M2383l013197
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39n7em6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmtcEAs/fqdrbClXIKz5KliWZXxS6AmHMTX7ZmvNYMtM75a2Vl6UHLArr91Ph3ojMp7q9bsFdd1to+ugeb6D9+M9v9uXTy40K16CCy9n/Eq2rmJyEKNVytahuWEIML0IKk8PgHF7U7snxeSyS64kUl3MLQu4r7hRlfMNi7vKkMUOG/BZIgNBFn+yTy+EyoL37at0dZlMWC6HQ8d3L8Gp/XdQiR2TLegl5fgUo6hJ28Uf751vOxxYN3A/QB9Q15Bl4/iYQlC5dStMYezKynqJVpjEjh/XEzOyhQy6DVcCaiMF2ZN1gZrK7dJexjyiRxIWQYGPxvrt/OUB6U4J5Uh8ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxCmQxu+JOW3mHfwwJf6+3kU845htts9Cme/qPpakmI=;
 b=KvSiltIy4xnDj/1QPciVtU6w1dG/m6nkALjaczSZrLIKJ4X8PXmAv373btow5SIzBA29YBGYyV9eOgZTD1nwmZismpfYrVnqTL1V9NH9D7fjsUDNFn7N7zfVDoz8OcO41jnZ9yQzi9RrXrJseUhE6CqvFdYYMnfHuiY1D07rLOplH0ouYDi+wMcvrM8NvISEY+aSt25diJzo+fQpYYgKou+5Y3l+soVtHJevEgHgaHo6X7iEKitCjHDGgkgkD5IMrYGzAYVLZ7D8pj6UvxszNjCPnG7eo5QvmYE1KKc9Lncblpbiw7fHtfqAq7TiuJXLtdHyQCgoIo+PEfQbHxyh6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxCmQxu+JOW3mHfwwJf6+3kU845htts9Cme/qPpakmI=;
 b=MrkrGzBemkn25TUomDcrfUaM0GPdTBPJqX2Ti7AmY6ItgP9GqNKdswI7vDPKUxqmAZbk1w2exjeR+StAiAt7310FqlVlUd4zr5PiDfzeMR8hWPa76TQ1P8lApmbLRVAT3e8OSffcGCaEHcJIps6/jQQqGWVzSxvJRCnuV6QyP0I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:19 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 13/26] xfs: extend transaction reservations for parent attributes
Date:   Wed, 21 Sep 2022 22:44:45 -0700
Message-Id: <20220922054458.40826-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0154.namprd05.prod.outlook.com
 (2603:10b6:a03:339::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: abf4102c-a5b9-46ac-c9b7-08da9c5da22e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhIJBa1kC1xf+VipQTveJ6LoBnzLTyd4polbpqvqea6h7zbOeXLdFZ/UmT/XGXdgoQtQYa74EOD3b2f5EHSLKErVxhc4HhubDa2gYEP7E/yNTr902zMLQvoVfNwFULZ+kPqLrnM9eWQybig0fZRUFqN01humiBh670v882tpx+Dknb0pt07mdcbjRuK3E58GT/Kuik5f4WiOwJ+DNqgpOh+1xLvR2jcK1GMD8cLQ1wB5GfrSlltge5k67G4y61HI81HzE3foWbFZ7NoFd8Z/3dq3pGYBKaZYm64MhJDCg2bjy80d67dIB4wMz2eneKT/Qi1GW9YKxB+Qr/9BEmaDeP+MXL62Yhk1kc6NU/hT3iOQsHkvfWVgIuE08EIDvumkK4MIyLGEYwep9vw/nYUOf7yQNRDoVZD5Z17Si/656tdGloZf5a8/sgA+oKPzohXnwrTzQMURtVCp8bK9a1ygR7HrFx3zPhoYfARnHnH0mCl2Vm0N0nrBfhJVvLhD5CHNhFWqpHzNWXAbV7enSR2T7t8ssLb4UlINi9S8AO7AZvzbHYv7e2x42jp23sbeyRYp2XIARlqXrpU+yTo0QgV9R3fv7InHdG24UEHgvTSlSe2DAw5aSwkPjv5DdRFbZDiKUlnHjDPHKwUwKuFa6Dn0235KjRt1wpEvG0CxSqmlL8eKyrL7qEXXGHrdZfmr7IbtaMiMt2omCWnjRy5zg/OEEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r0/2u4ajXgaBdl/6yR4JmMX5NyyXMW61zfmCFb+KDxY8xBh9K2WtTjx3yHe+?=
 =?us-ascii?Q?24cEaBCvqjLaxlsOWi7QxU5eOEXGVPcFyfTkXdKY7XIUk9VqQjoWzyb0WVop?=
 =?us-ascii?Q?y0p5mIh2CzGWqscmXpNvTQafWC02ESNCwPdUu8I4Ur+YVC4SkoJNZXW9E6vX?=
 =?us-ascii?Q?1QX4lHnCPP/gF4Gwp8B6TZoCvjk+4yZ9zsJ3P9owhs/CFLSIbscJAVHMWoiM?=
 =?us-ascii?Q?DgdS9ljFAjBgqqtPCz3ILG3BoH8OOYDJZ4tjZY4nuurHaAsKy0WmODlOvu01?=
 =?us-ascii?Q?draQHqk8yZJ1NG4rihGtP8AviyB0jRukG6jtvaXahortUOSdA4I5BdqIjSP4?=
 =?us-ascii?Q?SzF0rizL+hPqeHNyrZfPwDSFdUHAAlN//OlWYvVXmkziDag8hW/N9bY+csM3?=
 =?us-ascii?Q?tPBgB8YyckvRJ448OM+WxSYOM1G3WPyf7Srwc1ym1ZQcdNeTEp1EQLTnPoSX?=
 =?us-ascii?Q?HVrnIMEQIds50cwVoRl2lYFkhHRwUcvtaCpAMcZZL33CD51rIt8PsM5U/+cQ?=
 =?us-ascii?Q?6vKKg7mTELxdE8fmiSDeHXgt3GqF0J4VXVEnU8dvU9LinapUWJ/05gyWCiA5?=
 =?us-ascii?Q?o6HsWwAhOiiRs5TIxlVyFA/IGCsp35irhdh6zzw3mXHUZWW1/5X7LZ91ay1t?=
 =?us-ascii?Q?AwnIn5AkvP9sukmzMFs6FcSGPvFOHzrPt1t/YBFG7xSb9WPosFsY9t+mMbgt?=
 =?us-ascii?Q?u3tUxHPiBIzpynp5JHVp2hHtTJ5voDqGWhZ+UiW5QM1shW83RxoM8BnIEDIR?=
 =?us-ascii?Q?vSa+074NmZbzqzFzhheKp2g3jIcuJK6fttaJXUU8o6ner67b+N4F1rxzHjqU?=
 =?us-ascii?Q?b9wHvkPFCDr5hPQNaXocz2Bn5n5KMe2Hrgkq9QJJLFr1oNHyQxK15B7GPkKC?=
 =?us-ascii?Q?chNqM+Pz7hqwCZawQUwZIJxAlro4vS9qbj6MZeg9laziLTzjYC1BoPFukArO?=
 =?us-ascii?Q?rhh9PVuDBk41aFhaUh6GFMTJ6Zlwg+WwfwJDFt8/dDM3J3dHLUv2iaQ1aSMt?=
 =?us-ascii?Q?ao1NdrlCHDlW4WtV+bD4J3HIqtBuX9t1E9Q7agQoyhm0IDUCQOu3kNVAKFe2?=
 =?us-ascii?Q?XXNbWvGvTDE4D5jvJNIfjSw9ypOuBawYyuQy75aqmoiZYTc8YBc0INCv2tPD?=
 =?us-ascii?Q?LAh1YzZDdH6D3ple0dMpL5uew4isjZSJmpQdxOYoPYXCQrpzxRBVaBikRX1C?=
 =?us-ascii?Q?J8ykaBOb5l3uTbn6/Bi0cAp16+Kb35LeegvbBn1tPA3LqqvLHkKMl3CPRO6I?=
 =?us-ascii?Q?Q6PL6/zvne8WLoVQ9qRlHNDMdXRXp+JEKcT1Yd8qSiFzJ1/9ABD598eHR3yk?=
 =?us-ascii?Q?1BOvMVuwe9zVUHeZcU6xOHJG7+AtwXXnLcOWv9g66kIxqQvxZifpUmfgFOP4?=
 =?us-ascii?Q?SFqyfBVStxdI3ilPWkknSlmThY8LJwaloRIHxmU3Xfc/XvderWiGVXI/d/ue?=
 =?us-ascii?Q?0gBZ+ogq01p99HM0jIZSdhjvuZ4mgrqtQXKvyobTh+4S8o2+kePBJ1qIkJUK?=
 =?us-ascii?Q?hT8GB3EPbv0gud2HQ6tLUUVpl+fWHTD5EBu+gODz/PiYzfyrYEI7e3gb36S5?=
 =?us-ascii?Q?9/PwlZejGyBLsuNXq1fT1yKKHsKyjIYwNeSeKgE/q5J6pytCGqMpFyb+9DPT?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf4102c-a5b9-46ac-c9b7-08da9c5da22e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:19.4151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iPB2rlu+Cn6+zFSPGiYRWdhyhQAMCy+PCm8BsTsnmnsZMDyAJ1fAZtUoXX1uT1NI9vpbgGxXyfUEuR7LbSZfTLJtyn3p/NO9pAGQHyxh9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: AV3mUxQ-k8BlrrtVIgkM8RxQF_VWVc3-
X-Proofpoint-ORIG-GUID: AV3mUxQ-k8BlrrtVIgkM8RxQF_VWVc3-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 135 ++++++++++++++++++++++++++-------
 1 file changed, 106 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 2c4ad6e4bb14..f7799800d556 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -19,6 +19,7 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
+#include "xfs_attr_item.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -421,28 +422,45 @@ xfs_calc_itruncate_reservation_minlogsize(
 }
 
 /*
- * In renaming a files we can modify:
- *    the four inodes involved: 4 * inode size
+ * In renaming a files we can modify (t1):
+ *    the four inodes involved: 5 * inode size
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
-		max((xfs_calc_inode_res(mp, 4) +
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
+		t3 = max(resp->tr_attrsetm.tr_logres,
+				resp->tr_attrrm.tr_logres);
+		overhead += 3 * (sizeof(struct xfs_attri_log_item));
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -909,24 +927,59 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
-void
-xfs_trans_resv_calc(
-	struct xfs_mount	*mp,
-	struct xfs_trans_resv	*resp)
+/*
+ * Calculate extra space needed for parent pointer attributes
+ */
+STATIC void
+xfs_calc_parent_ptr_reservations(
+	struct xfs_mount     *mp)
 {
-	int			logcount_adj = 0;
+	struct xfs_trans_resv   *resp = M_RES(mp);
 
-	/*
-	 * The following transactions are logged in physical format and
-	 * require a permanent reservation on space.
-	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	if (!xfs_has_parent(mp))
+		return;
 
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_rename.tr_logres += max(resp->tr_attrsetm.tr_logres,
+					 resp->tr_attrrm.tr_logres);
+	resp->tr_rename.tr_logcount += max(resp->tr_attrsetm.tr_logcount,
+					   resp->tr_attrrm.tr_logcount);
+
+	resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
+	resp->tr_remove.tr_logcount += resp->tr_attrrm.tr_logcount;
+}
+
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This assumes that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
 	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
@@ -948,15 +1001,37 @@ xfs_trans_resv_calc(
 	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	xfs_calc_parent_ptr_reservations(mp);
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
@@ -986,6 +1061,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

