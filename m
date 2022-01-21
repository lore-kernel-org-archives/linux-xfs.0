Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DA7C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiAUFTw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:52 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51992 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232204AbiAUFTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:51 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04392001131;
        Fri, 21 Jan 2022 05:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=uvWJHcVGimsLI9IeMt0VEYN8dRYAcWqySMCWCQ7Icsc=;
 b=ynEW8WGv2WFwhmiK+xHBClGuYQLAvan4kgpwAD32PeIup4B+kS15jR42PUbPX0bwpYTW
 Ez00VuyJETSsJMSqrJ8SLs6U+qqsK1Fs2yHTxn+jzVGaamSy/Sxb0aBRCpuK375vffY3
 diEQKh+PtrSJOdhz98JeTJI/s6mnsLn1pO529LQqIDHfadArdgDv/BE9d/6vL4z/GoMf
 u6QjhXfqRklkMft+/Gri50gGz7d9jUk9qLC52pWOf3KrjaGGyvJ4GpV1fJKIZocF+j2u
 RpZbWBTXfCaBdL8N2o9xYC9We5b/Y7UkOnpTsVAklggd/LHmiYmwxHNydOOv5IMy6pvo 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhy9rcn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5GU9K190224;
        Fri, 21 Jan 2022 05:19:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh05v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOeJmjZdjO/kJlIcJwMENylXDoTumjbPF9RS17jGOD1N2BrQSw1z2nZ5IVUAZObJDwzFh4Pw07mvBRJhgJfB/gYWh6E0hKaDT6sZIh6UAhWAQYFsDPgPkid4E/y4PKW9JqQdyAfFBAZpw40DZtylwFqLo12/lmNWsb5HcZyCfTDqNdHjeV6Rc+XomOSgG96nosy5KYzgrXvcV6yg1ExLzYvlUZb6oBOja9auDAG+z5sD0fhGjiqhWhKvH8rcbvN3c5KusrSynM6wTPrYKVLa0ZH2WeUbgbGPkIDrO48e3E3i8KuO9vT3qQHNssk2dw434rIklkRWmqzGTN95pYgROA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvWJHcVGimsLI9IeMt0VEYN8dRYAcWqySMCWCQ7Icsc=;
 b=DbAn5A8EPA4I8H/XAcP1sBciK++bXKg4DKUMpZtuYntjmAMiE9+262EOLNGY5wkphF7bzJ0vg1IXhMQKSl/f9cHR+Zo/57U7iOywAl/qUPI71hRDzvF2/KcssTbp+VDh9oJJsyHXu4xRgKfiQeGzubIc8YrywZr28BhtO4OAt3ywT4SbRNc6ywwhq6AJ0v3NUk1bgjCUD0tncv1xdiiwMd4R3xezmtebXSJwcLCIljxD2Jd5bWvZBP3h1lD5Bc9IFLnmEIuONJqAoVzPEp+qNECTYKuWeYlnGP0ZKzFfIFawhUQ1vEHrOOam4on0nHetefLOH/Y7R5tdgqx8hNs1RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvWJHcVGimsLI9IeMt0VEYN8dRYAcWqySMCWCQ7Icsc=;
 b=kLLZP46j9rW7MmE5V9Ba9+5j8fsCIaQMlLo8CypVu8wlG6gAJlGRNyuRUMd0dqCZb1eHVrZRYHdKFtE7VBtMF+Xm+MjiGFjnzeagyKFLjsl9xhJKA+H4G5s0yL7NKv7iLxZCIWBoNipbI8j8eCep3RieEFRfGWUgZLobtOef3zk=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:19:46 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 09/16] xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Fri, 21 Jan 2022 10:48:50 +0530
Message-Id: <20220121051857.221105-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 954238d7-a399-48c9-dd66-08d9dc9da38d
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287450FAA663D33BE3DF952F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:411;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hirc6QiTPWhCI2C5IZ1/DPL+fudj78srbR4ZtpFRwe+rMhJeFkD6QsbfLd6IAUsOjvT5TIMIcpBAyRyjMGE0alrAjIsfRIZC9I3zp+XYnJex/t2NdeULBtlZP1QAqnB+05GQxYfSdpO1BiS8vUgXrn+V1QbXNf5t2fh1ctKwKZoWaY0oWs2vETUeJH0VpP6Qpt4FtlbTuk+C7tMq2dGxQMJhyj0m1+VsZ8HTcMkYMJumaEoqU0yf5YXASrBS9nt4nKP8lFpguwDqOKtRmyDejw3UlM2lT81op0icbh0F9DfV45bGCaROtQfz1p+Q26cb8sBZlbvnGdtuO4y/98fUVpnRh8eCjwR45yVSf3oJ0xhvdmdd7nkZDnec+W1smcX7+eaqCY3mAJv2ko3rMsYWsLfqHyk0o/pNVSyiqSzHwwxK1ywbl7QFlcUhnqNnpHpBVoyZiViBu/btsio0gRfmpPCpxMSyXpLpXqAhoVWGR59ZVFQqWN7nY1TMwjI6EjB/Qs/JMTtsyv8R+kPWqMNw9yKCr0H08Q+9RYiggoDowGU/FI062OyRLc870p8h0IuEzzIDrsgBZy/2gh5D1cS9UvdB3DsB0CozgPe0ksDCYB/NZR7o8uJWwRea995uaakK3hsEqh+dVUnVFlWneuj1CqYtYkpaXakCBuzLwvKNCGWBdxHtYy3TLpZpulBNCQ100Zpy8fCjdI7GoFy5gaKyxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHIoxnRNtuSZy3Wy/7Rs2wWBpa1GZPP0NGMnolsDGO2q7Ft6iLWqt39MML/s?=
 =?us-ascii?Q?5ns4aYaXkJd4jpo0ENG4UN5LAKC6LCu4H951Gjj11HlUrEprC7f0fzVe6thj?=
 =?us-ascii?Q?Pxv11Bho5s9suCa2ZRh6mGAydHhVRLcaALOaQ+K3MkclHs/UltkEdoZjpBru?=
 =?us-ascii?Q?7qdCTo19s0wFqEIuCNmP9LkbqfKOQKlwfCBcirij9uPcJSOa6Bf11+nBf4Si?=
 =?us-ascii?Q?0WEMXozWcNCiY2nex2Db9u93oF8/SneMdelHZGZNDpCmytIONF7VObDEQ2Fv?=
 =?us-ascii?Q?vPqElPPrOLO8SWQjN1Wd3h9TayEFpl8n82zPf19CO8fluTP/wCqJsyjDRZcQ?=
 =?us-ascii?Q?ooPP+69ke0jg9Up/FYAremotHhIekvgKBeQxZcEIrqN7Ur/Ly4M8geHOfLAP?=
 =?us-ascii?Q?Lph6lwZh5xck8RA/NbL+QwyqH3ax7JOuyFQFTw9Hu0n93c11V6ToUTdn8M8U?=
 =?us-ascii?Q?gQnGSevbsmMMdib5JdouE8+WJgVruLIy3gJqy9S/SeG9K2S2hSD8Hgygxqh1?=
 =?us-ascii?Q?HlJ0sHwFxIq6qVWXj08jbZ3DsYraTuvW2Yrv8XnA2O+6+Bnm1h17y6dAOSZJ?=
 =?us-ascii?Q?RFNh+dUgyG8pcwok4WjE3Gt4K2Bv+I2bBGWPcpC3k/sAed+szoZAhmb83VrV?=
 =?us-ascii?Q?vnGI9TdD+6dVi9rTjelY7VJPuCFCTT6YcBYUI2POw+wIoYDMZsnOcrIRh1e9?=
 =?us-ascii?Q?PMAWdKnxJtha5NmgEcmHJUc0HKszJlfaDWH7RPgiXgEdmKYPTV5QMu2zN88C?=
 =?us-ascii?Q?8eqDSy5ORrnEY5ot8jkEU0e/9L934qgxfXRYoTzN/Wm/iwcFb4QN0GZ1I9vg?=
 =?us-ascii?Q?u4L/GUmsXl4ia7HGEdjeF6WTUGA+9ViNOlTzEOgnSQeZi/fSOxTd9ERf36pd?=
 =?us-ascii?Q?EverUK5nrs54+2DEVM6hGhHcdcZH+/qK6k8OdAjLdOlc7huYoycmJkeRydBb?=
 =?us-ascii?Q?vfeXoeSQ6HHJMbabt0nf+QtqQp7ZxaSWH3CzVJZZ2Z4Ww4vI7IU9ArGovODo?=
 =?us-ascii?Q?zcg0fNAOiivhNWzagT59yxLJGna8ssdQxQn8e3gxXNrI6WQMB7N2S3WmY0/E?=
 =?us-ascii?Q?+HPekSgXNzanYZBV4cLOdruO3SKDF6WqVdNEH0DpKJKgka23/r3qfDTGtkzf?=
 =?us-ascii?Q?2SiDKN8pmK/LVxblfN9nzOK8P7sMrQM+muc35NCiDj5fvXFXZiWWzIftespa?=
 =?us-ascii?Q?3RDxFqFqarrT1YwyRVZJ/IUv1sY+P4D7n71IQea3Adsgj2a68Ozp37l1dizX?=
 =?us-ascii?Q?hTM5yNKY/vMcunvZKQJh+gj/0GDoWm0QdQqwFm42eBc1+X6tWZGNdTvg+Qou?=
 =?us-ascii?Q?7HKpCB4SCfp3sOYub88Obiy9PFgsr6/wdBhrtLUZWbzmpsvqdCSXbo4PZ1im?=
 =?us-ascii?Q?BWQMFhYLiuwM0wiXaO0WWfV7VYhQiCwItH8GNOdJMxpesESrwm1NIbCUd7o3?=
 =?us-ascii?Q?a3kUmYL3Rpux23byB7nHdc38XYIavYY3UG5qZPv3QDhqBbG1oVASvNIUrGAy?=
 =?us-ascii?Q?EqOXYNLytHZEbOoRomTCDlj/LK+RS4D9zPVBSX0Reb58ld3tmEWvzb6TW8WP?=
 =?us-ascii?Q?7s0NlDI+tfyVsah1aR7Nx/LZzGM5fyB0AAqCSIlqu6ZBb+mcyr7+zvup19gC?=
 =?us-ascii?Q?uX9yQDcAvkBKPe17Zx1igkQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954238d7-a399-48c9-dd66-08d9dc9da38d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:46.4407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10OjXWghmasIA2hy2wUFbbOnm1qQZjB8zZuGP0tUMPFP0KJRlDodR6T5Uj3QXyzkgh0i2TNcVyJE7QwOguG1kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210037
X-Proofpoint-GUID: d5PA2H-jBL_7tnIosDkVNcjlP1f2MMzt
X-Proofpoint-ORIG-GUID: d5PA2H-jBL_7tnIosDkVNcjlP1f2MMzt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      | 10 +++++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |  2 ++
 fs/xfs/xfs_inode.h              |  5 +++++
 fs/xfs/xfs_inode_item_recover.c |  6 ++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7972cbc22608..9934c320bf01 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -992,15 +992,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1008,6 +1010,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b418fe0c0679..1d2ba51483ec 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2772,6 +2772,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_nrext64(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c447bf04205a..97946156359d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -218,6 +218,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 239dd2e3384e..767a551816a0 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -142,6 +142,12 @@ xfs_log_dinode_to_disk_ts(
 	return ts;
 }
 
+static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
-- 
2.30.2

