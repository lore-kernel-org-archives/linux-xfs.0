Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47C6C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhLNIrg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:36 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17172 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230007AbhLNIrd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:33 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE75Q0d004559;
        Tue, 14 Dec 2021 08:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/VrILx6A5BwBgXYnzB0V7i8apE5cFN0/cdhK4yIfE6s=;
 b=M7llldK3Zy4giji7SDfCcvGhhX9pqG3UF6m64fcf7Us/fUUrGJoDuTthrWuIjCloug+P
 /LuxdIPuN4xhNXZgX7BGIHHCf6OY+49sJB5qXVM+252MzIytBPrnOlkJPRNDabe2LNPg
 3dmdwAZqPIJmuvBaxSCy+9MtD2grvKPSssANyW+B2mOMd9zFnzVInlZdJQ/BCyCfDQYY
 EFN5JwhUmrQdMFQPxdA3stqjdrDCRDnEiY2EMrQCFGrjRTCdxe/cNS/a1tFO9Qxmb23d
 msRsZeiYgqLV9BBdg/3wHUl2V354qrcqHPE+aT/xB8fEgyQFnSL7q7Eespc+iv6FaHpC wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mru5wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8foSI104448;
        Tue, 14 Dec 2021 08:47:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 3cvj1djqqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RktCD166rIM0NnA8CIKbZcNQ9Kt0CbALPDlNR4keHf+1QCpLl8aatZDaT1Y1mGRAccLMGLZPORuXhe9CwWsZbkOI/WJltnCJNkl6MafOczf1K/mWPmqmU6AlnfAu9e5flZMG9boOQ/oWvrXeDe2W2pq4xEi+TzZW8ttDibwiLOBVCCg2X648viItCaHqSyXx+lmmYAXmxffh0lhJlewfTF+y8+ID4Cf3FO/Gv6apdrybaw51G+NF6z9w5NOdxA8Ve1VNt0ln3djax+76IpLSa9cJlchFPvX36+IscvSgQyknk6pCaKNKr8rq6OSPVrAFIy86cstNZ4I8zxU/p9nWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/VrILx6A5BwBgXYnzB0V7i8apE5cFN0/cdhK4yIfE6s=;
 b=HLZJbElERubWk4YXOpD7BSmATAqfBS8Y6ZvIgmeEMLiCFLF+RMdeES2cUf+7LP4nWWmi29t8NYyaGF5vaTfA4IU8m1f8DBHjqcaCOtiJjmr/9udT4GceAYVSw8ymCfH9TtED04riQM/0lvX2CfeAaxgLmWxT+v9GHpyZ7cHyhrpNEbM0ArCi0nSwYpHF2TIYH7+Z1qk+HHj8XbEPWjA+Ik4omYoQ9vlzHdWPPE1mYOxnqkQH6J35TjpXnTz/zOTJW652niNzpwj/0ibyav0/YrM+ta+CGSZzbDrp5vwYizx1H6prB590DaeAZVw9QtuTS0wRmGrHSfIEIhGHzr39Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VrILx6A5BwBgXYnzB0V7i8apE5cFN0/cdhK4yIfE6s=;
 b=HMQDI0wkzQdyFk3u8bmMeCNwb6ktExYRu0prlymi9eIlJ7K3Lgcr6LqcYxyswY+QtH/JTA7RUbWvCq2Q2hzPhbVT43JM5wl+da9fFgqJtNEejdVnZbUskp6lhshUYOy9nRtqqdFfZcuDJfwOHkchQiiaeoNz7jg2IpLCyXBEFG8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:28 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 14/16] xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
Date:   Tue, 14 Dec 2021 14:15:17 +0530
Message-Id: <20211214084519.759272-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cab953a-3658-409b-1393-08d9bede5b81
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054EF699B823A58E05769CAF6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t9tyMTuN04mVLBxajEoRltgFDTjVBmtvxHY5BeNDoue9Jj9D3DHE0etzxSlXGV/Bcv26ma052tnBsl6/oQUfNzBWFOdR2PmykipOEIGgiHCoj0J7Zxhr7/Q5aoFhx56FoBtxUPNEJDrhp5DcsnBCYYbgQ3Jqez70GbVI4/807EjRw/Vdxc4muNCic4OSn6s/V4gXhm9ax5qRDzQ3PBQYpFwlmFdScSwBb1xdTrwpVW7GwRpSi41OUBh7ycpBVlTRuYUwAUxBxST942MG+RakL4UlOzfbMxn4YYt3BApe4SBqGbXRpPTxDkl3pQHVtgqSz5qAHeYeKKr2APZqRKU9hswXVEUG6dMTB5ngCs93AzhVAE54263CdJxutZWc1FWuZGi3ZY9XPlloTWAp6b1tXUAncQLBwPbuYNzT6wD9SKawViRllRcCESP4gu0ZKFLAylzgUDIkFVcG365srx298U1dQiShcGtr2gUyPEuveB00yU1ZvPxhyNXM9HrKqqswnOnM5DwzVKheLkhq6MBZRbO5xCU6wI/VTK3/XZvWglRZVVtId35DUkGp7azFwdHTL7IcFfeBuK30GQN9K8C52NbZDYwC0p64Wo/gDQ9xgTD69Zo5aBHEbtzQ0ZOmdAvKXQG+Sa8AixSzTBV/c/f3m04Rm7ly3g5y7qyRKGPE4UC9k76fGow6bXvZ/sFUm5VpTCXpAjKzRuLe3VLLH3QZiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nYC+dChoBlF5zp08/Ae4z4+zPSvwgItZdyZNE/xovfQqiteQNbvQ8k7tr5A6?=
 =?us-ascii?Q?qeg7gySAo8aFllMeI4Vca4mx5awtuToT7qHaIA3z9fqkmkRz3Bl9KvTwOBjs?=
 =?us-ascii?Q?KO1DV+/6NSB7IoApr0D1YOW4+STwswQFLKwhQ8sqGoIdR9RWOX0XbhLOVCT+?=
 =?us-ascii?Q?3KV8grv7wTNoo/PzDMx5lpHzO9Mdw0QmRLp/Vm97TjVMhtF+gwpSVsAFCdNj?=
 =?us-ascii?Q?jJV8fbGKxaayzqaLHIzxULlLtLl8VF11X73T9HHTN/9T5mHpBTEQRfc4czf/?=
 =?us-ascii?Q?9a918x6+YhTIG7ExY5SUdbtsY3VBy4qjroIFT06fC8lwYZpS2rxsTcSWMjdQ?=
 =?us-ascii?Q?a3qfgWVTSRvITTLAfpE1lRH0RZycOa5B3ZUNi8Bg66M3S0PFcNVYTk4gRklV?=
 =?us-ascii?Q?ZBxtmu5ysflCe9Kq86n5ByPP39fkfEeVa9XhofE3GNIy9Nj+Zp0nwyvZN0hK?=
 =?us-ascii?Q?4WafyL7vlf+3dOE/DwOvFOeorIY+MieqLw5DT6m6ENXEaIJikV0xOaWj0Mkz?=
 =?us-ascii?Q?qB/NZiQx7tOHFKvbNvhJS+Rp+LZYYPa71rgNxcoee1LTpR0oA9IzKjvW5K3Y?=
 =?us-ascii?Q?C6Iyx//lhFG2ThinD5jlHSIbq2TfvGAYrSfx7jjByIRe9LeSg24KU2jaXzfQ?=
 =?us-ascii?Q?ptV3kO+arpovFSVAwA5UkPuKwzXgzL7cubgWbcaEv4PEChPGzp0t/Q81FgvL?=
 =?us-ascii?Q?WfMb5uCUss1zns2ZummqIRI2g0eWT/ZcwEzos4TZuJd97pZk2ApO4pob+aRp?=
 =?us-ascii?Q?GvLXHMK7mehfOSyOM3PlLkewHAw2CatZZQ4JaU1LPFagyA+mIl+EhsygavGv?=
 =?us-ascii?Q?T7dU5UCBghplid2tNUAcKCPs91y7wCBcBksEfN1HUQp0JXciKfeE4CUnvzCB?=
 =?us-ascii?Q?mlfTTlirjH1fa3C49UrzyuDBbgjidb8PZHGgomb1+tNy++DRYAdOLiRV9/VW?=
 =?us-ascii?Q?cwJn5jj9WzXiW9JVRgMHQUs12Smsy7znmxCLHBEr2Wgusltx/AzXRC//57x7?=
 =?us-ascii?Q?GtR6wVWbIARr/DF3SN6F7oBXeJE7QhgDCDLY5dO4zXgU3Sv6uxT3nZiNoamA?=
 =?us-ascii?Q?Mv7/DyaTGl3rD1prBfUYMjmYiIRSNe5JrGWbd7H1tPKOBRrNqvSue3vVdqWX?=
 =?us-ascii?Q?5CrzV2Hf4c9mq66AyBV6eBF744zrBAFWcgpo6N/kDeKrugGTGHHQP8zfIPZm?=
 =?us-ascii?Q?JvzdQQTlLlo/LiDSkkslgGwDV2IGyU+TVZYEXeziAhYIktwbw3/1Q6ZexLxo?=
 =?us-ascii?Q?HrbEYmmiHSiSbAf+BCEoLs+bPix2xxUVD3n7Tx44jW70VvJftzXl55wXPo5Q?=
 =?us-ascii?Q?KeTe0JJ8s7T6i6k7DJ57TFE6rz5k8rF4PH2QnVuS4OQUZ6ViAOSC8LtPxd/d?=
 =?us-ascii?Q?rwfDx0DrVc7xB20h8agnokkuOXAF0hp6n7kQbmT16OHMNVJ8E4Nr3wafF28B?=
 =?us-ascii?Q?4RMaE0Zi7n6DATLZjczw8JsbF6QRdpmmErFwTU7Bo1+sPfY0DVETTQN7518t?=
 =?us-ascii?Q?QEJzId8A7Ihehg/gmf/VyIohOVeXTjH3RLkaLR8MwF78zzgZgChisicbDMtn?=
 =?us-ascii?Q?qBURBumqhqZSmPeL/rB/N552H6gc3jXBL6YckcUxi0xbo9xTdpFqbFITGYPS?=
 =?us-ascii?Q?fii2B6Pj6lM37j4vJhdqfsM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cab953a-3658-409b-1393-08d9bede5b81
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:28.0253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIWw55X8QI8miikVVm7tA6JTJcT4F5bfThfkP4jcOY9PHucefYGjo91p+mruKSdeaS5nsy+x/iYYcMwm8Fl0sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: bX_mckbD-T2hdJxEGPRvdv-UxyXzQZE6
X-Proofpoint-GUID: bX_mckbD-T2hdJxEGPRvdv-UxyXzQZE6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes are made to enable userspace to obtain 64-bit extent
counters,
1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
   xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
   it is capable of receiving 64-bit extent counters.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 12 ++++++++----
 fs/xfs/xfs_ioctl.c     |  3 +++
 fs/xfs/xfs_itable.c    | 24 +++++++++++++++++++++++-
 fs/xfs/xfs_itable.h    |  2 ++
 fs/xfs/xfs_iwalk.h     |  7 +++++--
 5 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 42bc39501d81..4e12530eb518 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -393,7 +393,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -402,8 +402,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -484,8 +485,11 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+#define XFS_BULK_IREQ_NREXT64	(1 << 2)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 174cd8950cb6..d9e9a805b67b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -893,6 +893,9 @@ xfs_bulk_ireq_setup(
 	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
 		return -ECANCELED;
 
+	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
+		breq->flags |= XFS_IBULK_NREXT64;
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c08c79d9e311..53ec0afebdc9 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -20,6 +20,7 @@
 #include "xfs_icache.h"
 #include "xfs_health.h"
 #include "xfs_trans.h"
+#include "xfs_errortag.h"
 
 /*
  * Bulk Stat
@@ -64,6 +65,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
+	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
 
 	if (xfs_internal_inum(mp, ino))
@@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
+
+	nextents = xfs_ifork_nextents(&ip->i_df);
+	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
+		xfs_extnum_t max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
+			max_nextents = 10;
+
+		if (nextents > max_nextents) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			error = -EOVERFLOW;
+			goto out;
+		}
+
+		buf->bs_extents = nextents;
+	} else {
+		buf->bs_extents64 = nextents;
+	}
+
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 7078d10c9b12..a561acd95383 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -19,6 +19,8 @@ struct xfs_ibulk {
 /* Only iterate within the same AG as startino */
 #define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
 
+#define XFS_IBULK_NREXT64	(XFS_IWALK_NREXT64)
+
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
  * buffer is now full, return the appropriate error code.
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 37a795f03267..11be9dbb45c7 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -26,9 +26,12 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 		unsigned int inode_records, bool poll, void *data);
 
 /* Only iterate inodes within the same AG as @startino. */
-#define XFS_IWALK_SAME_AG	(0x1)
+#define XFS_IWALK_SAME_AG	(1 << 0)
 
-#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
+#define XFS_IWALK_NREXT64	(1 << 1)
+
+#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG |	\
+				 XFS_IWALK_NREXT64)
 
 /* Walk all inode btree records in the filesystem starting from @startino. */
 typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
-- 
2.30.2

