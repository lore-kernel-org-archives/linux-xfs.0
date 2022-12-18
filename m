Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254BDC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiLRKDj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiLRKDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AC755B0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:33 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI5WDjO010788
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=JvYNAxTy47ctoLj+n81Qs3UCuJd8vQN1/d5nPCnUt2K+nbQiKs9DQAQuq633bexcePr3
 S70k6KmwJlcshsWMUbAlJgD0NxOowVph3KhvwCIauOLARRxKH2k2yzGSuX23xWrxD2FD
 IMhnW3cqbhoqFknoPGKUNh4kHYTXKhdVltNsNcDXxksts+W/3DuztE259qs1PnELc/FB
 tm3W+1HLtLmiT5S2G4Nvb6Bz++0cZyG6ZSf3cTcEXmUOSfqk7BnYGubkqf5jzcw6cWL0
 22TXBLG44VDvBpDJcTOHfdcU4XCp6w4qvlrZ5vPXam1reeKLRqM2wgs2w4jyDYGTxiJW /g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn99gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8SAqj007072
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh479cbpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ToaZfIjmk318q6xLa1M2HJJ1E8i4B8E9vkaXet5WsSIDAP/b5BUElXrAWb7ve+jIl+6Mnn1DFjo92Bn6uqim5aJyz5s5GQmAuXd9nkRFbJUoPcxKf45jgCwJfvalfJvtVtrug0JrB1S5WAvl0Up4x7kCqGL/ScNPfENIuuCFTGOWynUFAjaDR/iNLaXg8TPm2o+zeix5NhtwmoF+W+zv4VYyigviIPgjtQxEyUvkQta5wotnZOetXS7DT8SqcwBLDUMacWpRvtZsJdaQjQQ0QkKXlhNexBkp5dNjQPnW+NlIJglj4NIE0x3vI1ECzW1cAN9XFLZlSftgMZ42Q6Z41A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=bycbFuZh0h9nawiOdZ7ZeAJovKeLAHuzUAtrKPm8yNphvYXQ28FhbpLRYB7paZ9AjpFiC8tG1MJjXcF+jbEHCosm72Lu1RpJzgBp7Ijg0+GvjdkmT3WBOFYFalthnIBkj25PBT8Y6KiTR50c0B6dIkbswm9TxBAxMJSEk0hvgERkak4LR9Wghv2d2YukzLp7XQL+b6V2czmrsZMEaISfklqDeSfKTKFiZOXTA1EqJXM8XPH0g6RIhfa8yBHE5mst7ho3nQ7HOj9O5t1rMZWI6e9rVd2Ev18bMcBdozx/ZntUDzb1SbBL3xLqDUbAvtnnlFkR7em8EC4lQuVsyKwldQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=thKw0kBvjGXiuXUq3A1tMEmiB5ClnMfY56nEhXCwxC7Q7fsDMk1i1mjRJJDVj/68IW2PjPCAGAHXsN6U+sPqSUexotQSDOTb4gXa+Gzz6L0YNa4J3TrodQuYaUVk55cuP5fM73E56TYSjJ95yC9hx31CHT1KzKozn3gn3PigVMc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:30 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 14/27] xfs: extend transaction reservations for parent attributes
Date:   Sun, 18 Dec 2022 03:02:53 -0700
Message-Id: <20221218100306.76408-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0234.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c339123-d9fd-4a87-7e5e-08dae0df1d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ewk9d7K3SDutxh1U5KmjVOlX5GooCFOS49Vz4VYBjdBcyTy6lWOVrdYvYeG6I5pDeTzNJJ8KRyy6rti1Tg+3zrz+BiSh15UvAAY2PVkNl4aHhzCQ1MiN9gy/osxkBWzOX+KUG8vu6C1VbbkM8ZT3WjwEk6cQcIVeUotEQiZ7QdBmZsPrJwN7oD4fiuDeG2mlg+DJAPFm9eHp0PMhlo25D3ukooY7Rq30W/CtOJOWv1pNVvP8hKmo1q4SPrT+79H0uAAtk85iZo5+cKfjQyJnBhgLXyBEJcp0LavsxQFDv+j8EopgddhxoyXMQRxy0TisOc/W/w1C9X+06sSJQKzghIUJv36oe350G3+IU+FdnVHRgJOkC9cymFdwao7AUzBOGwqKpxC6ekAZpL0GXaC81Nv6btdtVxrf5d99QafRc6hhFenS4FInPPJjg2dU8JeGuS8PQHF9yaUPJzRleaLpL/pkcBSo80BAt15e2DDRddZ24iN5Fq8TRUPYiWFCn95eLkpwbnB+DJnfpy9SkwNH0/nnohKgxDdYNIJQonKzEdNSMngR9Kb4oHPjt/okJBgdsQLL6Hjgp+HYr3EEKvqt+8MnFE3rIS+MntEjo4RJSp726wYdVsQEgsQbK8CUHna6YhqLBXyY9Oilr8rJxrlXJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(30864003)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0XT4bZ9Sg8ZLZQoqvfqJR6xy5Ds+Kq0cIWi2bHcnz3u3abphz7GiQYx7pUuC?=
 =?us-ascii?Q?WCiq5nDyC1UdOTHekyFMKU2IfuJgQMg1PyIsh56tp0dGhP8DP/QAnL7998e9?=
 =?us-ascii?Q?H3zxaYbx5pYMOc220n+4AfeCiOHRt+AK/8bJ8xy1B7xxUwZIAuCOPFd64x2V?=
 =?us-ascii?Q?LTHmWBfrQNBr+Rk3QzlP8fHfWQPkwo3pAomTPTDNJ1ohTE+LqcnqJOryyZvA?=
 =?us-ascii?Q?bLrpsPbpYydWZz/I0wc2YFkZpoeNOFNFf2108H3OULbuaEyjuUU21m3Pwxu8?=
 =?us-ascii?Q?qS07nQjOUa9JSfmioU1MZ3OoDmvTxyNL8sNs67OGzJ1cO+WPNzCB7pfIMnbG?=
 =?us-ascii?Q?F0u8LgaBxu3lHUbXgPGaZDac/Vt3v8IwzoPKMIsEBF4CZatokvAjoQRq9wDN?=
 =?us-ascii?Q?1RK6o2v9bwxxHmCXovb2zl5cXp1+yZew7ORYOlAO8SBOc5S3Dzc0THWgc7V4?=
 =?us-ascii?Q?EpWqfOSBXzUvZ024OLiQDx+OtTS+GgMj+3F7IQFqCg/4w3VfqWVsTfFAL/sE?=
 =?us-ascii?Q?ZoUcRxyNUrZ5qFODX15J/8Qi6uU3WYsESy+ZTU8rnxNP7xKGhfhYcaj7svp9?=
 =?us-ascii?Q?bhVeXnu5ZbFOThdnFLXKL0Hwo1KkZaxhsR0Kgfe7CLJuoxDdxYiYj4CuXtI4?=
 =?us-ascii?Q?bTSNPsmgbXSt3X7PecfVx0W8tOZRq7dAthmHoHRWj00pqaly3xkS9gqDVfqe?=
 =?us-ascii?Q?wtnGPz7MrQ8NGqiqeidvks9t+CB1GjSBpY8YPIDEZ/GBTEkNlngmfAtJdi2D?=
 =?us-ascii?Q?7D60xdvj/N7pLuSC86uGX0XEMrz+qLSiWChGS5qf9l/ltxBbdMytqnDLBBTu?=
 =?us-ascii?Q?Amt2j2xEQqkwvD+lEktsvaG/YkaYxyFBidk4YYJVPn8F23kjpx9fz79ihfZc?=
 =?us-ascii?Q?EaP8wVk8XnVQ0nvpBd9Gh7Q7vUQ6O3LSwLenEOTx8HkLqnZDLQqzP+qRSmrV?=
 =?us-ascii?Q?xoj4kD9BP4zjO8zztDo6rVwO1+xPEWyoNyhd41nqlMuq/SA+6iaG2pY2xH7h?=
 =?us-ascii?Q?0Ld79ZwbjdBTFPcryXYUBsTnymmVaAnPXpMKal+/Ursal9Xv7TPXPr+UG1IT?=
 =?us-ascii?Q?BIjxx5av1JyDfitGdr8oUXbo0MBnF2C3WixyghkNJoG0/l99srwANAQWlCml?=
 =?us-ascii?Q?1wQR9nAjbeE39YrzLWiid2mGRLoOYGgjpnMOzcVZpFjFETUNEc4tfAN7NIxY?=
 =?us-ascii?Q?Ac/ep1uCmtVpdX27DkcTsjuuAhAocxBrPyEkPTuleS2jozzIPfEKgbj9/Wra?=
 =?us-ascii?Q?nGYGp9DWdXBaRY69vYFYoFgWdH2LAUl+Kb2oMcnG3nveswgYR9T1Hv5h4qi3?=
 =?us-ascii?Q?FJlyvTJLrouhN+axjifGMwNjw0o/K55+FEtTjJx+yHMW4//iJ0+qqzl0S6gF?=
 =?us-ascii?Q?pMR7MBn5YKqiIhDFT8xZLh9lI2BtNshESJpMLwUu/tvhI2b6kBMrRn29tFG7?=
 =?us-ascii?Q?qUNrPDeEIRz8JKb+kM6M9T/qKjpG7EMaTrimf+XiyttwqiIG++jIpalRxyA4?=
 =?us-ascii?Q?+bd9xGdT9uw1Yl00CafQaVDXhsXFs3kd7LTomTo9jJvZbhSbo+pdHpZYhSCC?=
 =?us-ascii?Q?mQjuMiKWkZ8drstuj/caoRTdvPIMLkLXsHDkF/KldcVLdmbM7aIHKgcoosRG?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c339123-d9fd-4a87-7e5e-08dae0df1d3e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:30.0089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u+203Niz61EURBJ9kyPT1+ZZfGfWZeB2GFt+m8Og9x2/ORdQJ8ZyH8PG0QuwzGojWzAebrG1GygsOb0EYRGPwtyIlVTGdL94iJqXwHUJvDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: vtpAqIeeziTYz32ZVjLYtiqcA90efOo0
X-Proofpoint-GUID: vtpAqIeeziTYz32ZVjLYtiqcA90efOo0
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
 fs/xfs/libxfs/xfs_trans_resv.c | 324 +++++++++++++++++++++++++++------
 1 file changed, 272 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..93419956b9e5 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -19,6 +19,9 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
+#include "xfs_attr_item.h"
+#include "xfs_log.h"
+#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -420,29 +423,108 @@ xfs_calc_itruncate_reservation_minlogsize(
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
+			   resp->tr_attrrm.tr_logcount);
+
+	return ret;
 }
 
 /*
@@ -459,6 +541,23 @@ xfs_calc_iunlink_remove_reservation(
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
@@ -475,14 +574,23 @@ STATIC uint
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
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_remove_reservation(mp);
+	t1 = xfs_calc_inode_res(mp, 2) +
+	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -497,6 +605,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 			M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_remove_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_REMOVE_LOG_COUNT;
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
@@ -513,14 +638,24 @@ STATIC uint
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
+	t1 = xfs_calc_inode_res(mp, 2) +
+	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrrm.tr_logres;
+		overhead += xfs_calc_pptr_unlink_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -569,12 +704,40 @@ xfs_calc_icreate_resv_alloc(
 		xfs_calc_finobt_res(mp);
 }
 
+static inline unsigned int
+xfs_icreate_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_CREATE_LOG_COUNT;
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
+	struct xfs_trans_resv   *resp = M_RES(mp);
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
@@ -587,6 +750,23 @@ xfs_calc_create_tmpfile_reservation(
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
@@ -597,6 +777,22 @@ xfs_calc_mkdir_reservation(
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
@@ -909,54 +1105,76 @@ xfs_calc_sb_reservation(
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
@@ -986,6 +1204,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

