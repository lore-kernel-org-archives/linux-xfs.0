Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD3AC3A59D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJUWaM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiJUWaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF56E1943
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDvFK010115
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=9JVhchN9O8Fvg8k2qPEy9kBteHtJxKfBmwuE+4xrLec=;
 b=wNs/7t7tVbNaJDK3CoVdxeQkXWve7GcbroblAxFvAwSzdzEBwYKbhagSAbqYAVCTgXA0
 SbkEWvu+J93Csh3/h22KzVoDrBcdwP5H2oVHhA5uJwOIIwHM4MB97RiT8dvXBYgnGZDE
 GHqZAQ4BNDE9BnsZ6QCyWeiCmerxUKODAe50+/XrnYtwIvacASewIDdidevk2DpfSnft
 6NijGUpZmDzNhtogim5hqpHQ+TDs78Pe/NkhmhlJ6JYc9PW4lX7MwppXpm9Smlu6A2+b
 uMxyScRJhZp7EcCFig0InmRVO15EIsQlGSTfKLdko4jKLmPmv6eNTzBAHAXxg0wRrQiC Sg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k99ntpm19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LJ0HVB027370
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htm00kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ehns0ZAtmxHGqM/iI6Jddzi9VMh1RaVUBbODESYG0DSHICD2kQZ1+/W2Z2EepHyrf6brLpaBpZk40R20w6WwOz/EW4U6DbRoCFrUaHt/I4arhKdHn0p9+SKE3Zkqs6yiV1QwAYrtNOQjwR9shFyX9b6HViN3nt8S49LXOGtxwR6fOXbNdZ8VNAgL2d3txSws7uJLewRiHuKypWIiexkjHmsfUtewVdLq+n5+zAYZm0sd5i3qRnQ8Hbw+wnDo+sbR6/pmGbuorwb2y0tw+mA+wq10H5bV1pRbTLoNEaAER1juV81w5jQm9GHolwI873VEriKWYqL8Rh9u86IxuLjqgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9JVhchN9O8Fvg8k2qPEy9kBteHtJxKfBmwuE+4xrLec=;
 b=AZ0QiZJmVSVqjMHI3eZ6B6X/YC9K39sZFi3HJWZHr1TygNM9AUpDGJQUpZ7HocByK3aMdemGnQJNmyN5vOL47oRmtQm8UIr6QLkTcpbxDeqG2UXk4VAFIj3+ABHdI5neij9q1fpJcDFiTVqLyNIKFKkLcCn14/UH0qKIUQg3ZhW3qLvy+U1sOciuLddTpcGhbeXWb++oB+F4sz31DU94fbv+4qbQzjV6cHhNL/9GobIU3ibmoNCeB01NguC0O51DsQ/AwEtqZav1y2TNOGBgiIFAinPpL2LPKPXMpX1COnfznlGp+asLU5kzwoqa6GMPji2tJqA7dv9IIuVati418w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JVhchN9O8Fvg8k2qPEy9kBteHtJxKfBmwuE+4xrLec=;
 b=MbhP4smZiPm/3rTO+bXqyJAZCT8SiBWrcZpAc1syJwGzIjc66JAnfOH15QpMjWhDcX+6Sl081x4HhWyVFdN27goafh29yMu6N7f9OlC+zMVnpmhLYbxHXt9bnLtmbF/5Yhll0Zx8oAl+kYpi/tSumNWWif7/qdkgnBBXO0LDud4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:29:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:58 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 14/27] xfs: extend transaction reservations for parent attributes
Date:   Fri, 21 Oct 2022 15:29:23 -0700
Message-Id: <20221021222936.934426-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fbf29a3-df59-43c4-2159-08dab3b3c941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzUL4OaS8nvMZFDnH2Lko7W8RL1YpRHKscoyn4Ja/V/u585xwz+9O1XO65HoA3Mv7FxXaYcQN8jFlPG/58QfAi14+davcA9NYO5bE0XrHGj46dcGoiqkAZiEvNHahzERMSEzdODNvMkwGwuMYpoiK7VaRyK864XQ7Br3mE8wnxc8morrZQdKs3oYuyrpVdKKkFakUZ16mjXjaqp9pUVMyaZQqPwT6OSGuKL4v2IjSnUMTFJgaIZRoOikyrKWVFxRBGEKivOtb4LjqS6SSjhQ6iVBS7RvhnP9jXs08fNNo7Vlp19wNRb38XlfWK+r9TL1e4cFC6if++29NKpRrVnX+sz42gAc2uklzzizwdfTnrL/CblArufgnG1sAa4CnIDKnO1L2IoOvhXThwkfqb4JQltvVbBOLbF0cteBhlmwxIblO8oa6StGHk/jPjcX8Ih/QjBaJ7Aq7L567Mjy6xbUitftF3fvjOvZ/EQzu+X7bdmE7Q8rrnLmfa8O+iq7stDNzqqKwJEams+Lj9fklynVftIccnV1y+75cDsTR3BA5vcFumMkXEKebOKSc+a3nQ6CujRbkyMIwgHIr09KdRifU0v5SZmwZFh0wig3kEmbnyfp+mpblCFlmAoxzGUo325MnKjZEDmQiovJkk3BjvOLhwtBeiQkDn4D2CXZe678YPWLpSFz+DjuJd3+npK11KOMQ98cqv7Ado64GxOwPb11/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(30864003)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fZ/zz8STl6E1pilzwKk3wnz9migI9o0w7puapAn71QSrM+BSp11nSi9YvHB3?=
 =?us-ascii?Q?T6PzYnHm9luDfjzpD8yaCZiylFJq6zdfTnCnjJlx6SC3hqhObRjWlZYRWH5G?=
 =?us-ascii?Q?XKtRlkQo3uEKdOVsZ+BjBrvFxRXoeywMhPwsIS9v3t5GCMeG3ypzmy2NMZ9X?=
 =?us-ascii?Q?y2/3PWRDgRQmFJggcDqc0fN4vmUK7X6SPhV6xb0afmW9SgPgSn5FbhMeOpdE?=
 =?us-ascii?Q?z29pCGBGVLM09C+cZ0ngHrkjqboC6BJ1bw7/RybAc90OXaX+NQyVG4NYRvwn?=
 =?us-ascii?Q?rYbPMv8p3Zbyoz11tw3LymTCXrqZ3U82U/3ow/CIsuaL080uykiikWj7cH9U?=
 =?us-ascii?Q?qJo4X/znswN5v9AgarpfF7KlgyUfx2D2/XdSxbQwFrPiv3HUmNSzb+jJQ6HW?=
 =?us-ascii?Q?Onhjv92Wvf8l7SX4m+P2+EuJN+RoEhjzURUj2DK7Ub6Tb9yjVl6IA6PxNNOE?=
 =?us-ascii?Q?MrsWYUIPO6u1G9SvbnWCZzv6VgVi0xsoofjVUTzoH7Z+pgJ/4HAWR2bNW/yR?=
 =?us-ascii?Q?QFalFwc/MwlXoU0xGKrtPq0nk/hcqKaMc0FBcUNT8IhL/ZEd/OU/Doa07Hny?=
 =?us-ascii?Q?NEagnz8RbeoNiv5ICqw3i/mdzrDKhmcs303ajxl3nzHPuV7z0aG9GMnSHanm?=
 =?us-ascii?Q?RXLqbYUazN0UAc1mOBBTNWWATvjd74zVGYL+TyflJNtkoEvwX2+OsNWnFZk0?=
 =?us-ascii?Q?nsYClnJamm/o3r4CFkxwEWChqsMcr083oi0zgIg/eIVcfwa2aLY0D/Mhdd4c?=
 =?us-ascii?Q?2nS1lUsH9el5XDnd+dbm3RROhhISQ9kcTZpCCPFPtrD9TwgQqH12ojqdADrb?=
 =?us-ascii?Q?iIgA32usKkVLhQlK3/FJ1m8/ERLD8zi/5ney4yM+qwru0OW+reD8BSiWMyf3?=
 =?us-ascii?Q?qoZT7rOdmwU8ExCAyhrriCkRdFgfHkzhBajjl22690SiFDtn1w97biIZrmV+?=
 =?us-ascii?Q?QYDdgzdBWJejWyHtO+6xH4FTWTzYHR3YsCcuhMIY8bExVd471hVVGpxtssLg?=
 =?us-ascii?Q?ADxXANOZ9pZdtIMsU4VdUAtinybbNITK0GbV6Gb+PVBmNblRtdDlD04QrZ39?=
 =?us-ascii?Q?X6cXfPF0AkxYhxo3KVAYiL8TTH1DLQbyYonMOK2PyNxRKT9IBvwpqJ+LKiei?=
 =?us-ascii?Q?Kt0NfYDOutPDd4p/o9dr789/FrtHgEwuTsJt66TQo0cfIh1PegCWMbk2AW20?=
 =?us-ascii?Q?GNRh2TJSLsPFVFmyJ7JARbnn/PJpJXrp6ryTCmW7Ae6qhm+a6BOFZoCBoxk4?=
 =?us-ascii?Q?2FFVKBPAlYBHMM4U+PGoEGn6KYfnpQ7K+jpmdvVHQrnen1clHm1zmVNCnaZv?=
 =?us-ascii?Q?XrIbMdog0vxs4yRX+EMSIVsZtzlf/HZeMx5oC1pEjJjG7FIRdOn4Ogw2u2W4?=
 =?us-ascii?Q?fXjM/Qis5fMG/rHkoCG4/lQRPaC2FXSzwf94LbYNaXkWjKb+R0qQZm8r0MHz?=
 =?us-ascii?Q?NJhD4IJmnMO8RjRLo8WgaXAeT9Dp3G8QctKy8B8iAD8JnWzizcH/2NSVXQOY?=
 =?us-ascii?Q?dtM/vaaddHn9GDrYR77L+Cw6Db/m3yPf9Ja63hSuJTht6NNNDlbMq4pQRYKu?=
 =?us-ascii?Q?8JwjIH+LoJtEgmQx4bgGiSS0WcgU+7p7K/NbMipRAVwTn7ALThEbofuNHiPl?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fbf29a3-df59-43c4-2159-08dab3b3c941
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:58.5227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRyHlD/MqyrZ+766Y+LYyFuKVxE1Xa3vsqu9y0Tm9ilGKcUJAFx/eZByWZHwDM9wiphCjSfowWU2K5HW9Ll9yi5S5h55lfRQC16y1jj/Pv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: zbJ2Z1uDD_ipOsWB3X6sRQU-hqXhDfGF
X-Proofpoint-GUID: zbJ2Z1uDD_ipOsWB3X6sRQU-hqXhDfGF
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
 fs/xfs/libxfs/xfs_trans_resv.c | 303 +++++++++++++++++++++++++++------
 1 file changed, 249 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..756b6f38c385 100644
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
@@ -426,23 +429,62 @@ xfs_calc_itruncate_reservation_minlogsize(
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
+		t3 = max(resp->tr_attrsetm.tr_logres,
+				resp->tr_attrrm.tr_logres);
+		overhead += 4 * (sizeof(struct xfs_attri_log_item) +
+				 (2 * xlog_calc_iovec_len(XATTR_NAME_MAX)) +
+				 xlog_calc_iovec_len(
+					sizeof(struct xfs_parent_name_rec)));
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
@@ -459,6 +501,23 @@ xfs_calc_iunlink_remove_reservation(
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
@@ -475,14 +534,27 @@ STATIC uint
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
+	unsigned int            t1, t2, t2_1, t2_2, t3 = 0;
+
+	t1 = xfs_calc_iunlink_remove_reservation(mp);
+	t2_1 = xfs_calc_inode_res(mp, 2) +
+	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2_2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
+				XFS_FSB_TO_B(mp, 1));
+	t2 = max(t2_1, t2_2);
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += sizeof(struct xfs_attri_log_item) +
+			    xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			    xlog_calc_iovec_len(
+					sizeof(struct xfs_parent_name_rec));
+	}
+
+	return overhead + t1 + t2 + t3;
 }
 
 /*
@@ -497,6 +569,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
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
@@ -513,14 +602,27 @@ STATIC uint
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
+	unsigned int            t1, t2, t2_1, t2_2, t3 = 0;
+
+	t1 = xfs_calc_iunlink_add_reservation(mp);
+
+	t2_1 = xfs_calc_inode_res(mp, 2) +
+	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2_2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
+				XFS_FSB_TO_B(mp, 1));
+	t2 = max(t2_1, t2_2);
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrrm.tr_logres;
+		overhead += sizeof(struct xfs_attri_log_item) +
+			    xlog_calc_iovec_len(
+					sizeof(struct xfs_parent_name_rec));
+	}
+
+	return overhead + t1 + t2 + t3;
 }
 
 /*
@@ -569,12 +671,39 @@ xfs_calc_icreate_resv_alloc(
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
+	unsigned int		ret = XFS_DQUOT_LOGRES(mp) +
+				      max(xfs_calc_icreate_resv_alloc(mp),
+				      xfs_calc_create_resv_modify(mp));
+
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logres +
+		       sizeof(struct xfs_attri_log_item) +
+		       xlog_calc_iovec_len(XATTR_NAME_MAX) +
+		       xlog_calc_iovec_len(
+					sizeof(struct xfs_parent_name_rec));
+	return ret;
 }
 
 STATIC uint
@@ -587,6 +716,23 @@ xfs_calc_create_tmpfile_reservation(
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
@@ -597,6 +743,22 @@ xfs_calc_mkdir_reservation(
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
@@ -607,8 +769,17 @@ STATIC uint
 xfs_calc_symlink_reservation(
 	struct xfs_mount	*mp)
 {
-	return xfs_calc_icreate_reservation(mp) +
-	       xfs_calc_buf_res(1, XFS_SYMLINK_MAXLEN);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int		ret = xfs_calc_icreate_reservation(mp) +
+				      xfs_calc_buf_res(1, XFS_SYMLINK_MAXLEN);
+
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logres +
+		       sizeof(struct xfs_attri_log_item) +
+		       xlog_calc_iovec_len(XATTR_NAME_MAX) +
+		       xlog_calc_iovec_len(
+					sizeof(struct xfs_parent_name_rec));
+	return ret;
 }
 
 /*
@@ -909,54 +1080,76 @@ xfs_calc_sb_reservation(
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
@@ -986,6 +1179,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

