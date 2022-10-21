Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB593FA3740
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJUW37 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJUW3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1FA6AEBA
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:44 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDkIL003800
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=RPJReohoa6ha1TS+UjP0LfYpV0iyN95RSOQrPlJWMMk=;
 b=aoyX4YppuMIehVwihBaru2lxC7HKUXazEJZh7aqhpClOw1RSsW+pkAhvITmC13L9fkIx
 En9v6gYQ0h5Pt+b/KW1JZ8pnXePTmVX+AaUSofV55O8RbbDHveDYsny8JCSvdkc/CPfp
 v0Oo5hURwGVmeOVPlk9YCEwM0oz31ddy/Z9PJDvh7Vhp8tdTYYjf64v/YPWbe3Po8DcJ
 gTjc5TQcU6vbi3o0bXjGDBc9GS9rYF8SAtJu+UkRYN4CLhku9+mZ9lldnSJbAO6CjK2q
 Rm2it8yMxy58Lw2L2Z/lZ1y/0lCntMo2q7febMp//cNuoBNxrOYQ7xJcWvdDJPjHb3n7 KA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu0ajbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LM6tea018120
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:43 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0uc7dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNNjXKUUrY5tjNrOAGxSl8/IMEyUbUhrXK52QfaLwi34qzyzrv4lMOVAOIeyguCnC19BsHK8AjoqEJMguUenhhcZjuHS2CYuOCRDBuWsm8B5OBow9nUUY0x2XhsyQmvi8rS2E5elKxjZDPzbqpnVBVFW5ybvCfH/Yi2n/3xACrMNcArlWO2rlr+cIrD8KwYyiN4HOCSXXNOL/s95SCBOO8SEPki33nDD1oKG8n9mG7tt/SaBk88qB5e1fEKfQxvYwlonRNeIxeps6jXlMonHOT4/92/pcCs7/dSAvq3tyuMaATWqQpz6/hoHLtOM6UNIPJq+hQttTBKM7psc97M3nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPJReohoa6ha1TS+UjP0LfYpV0iyN95RSOQrPlJWMMk=;
 b=IJ/12691/XGzYEAqNr8AFNoK7ff8shI/JlTEgn094y26o4L+Rb5fJRMYn4Nx6MFEaW8t3ghoNLm/9PaQa1YFjHyGnZ2ix59Mx3OPNJIlEB4TCFd8iCJm4YhUmzpEt/OW5TH4+at1zht0yWou2XgO4z5wJlm2eVFkV3SV9dK1R2g5RTohL+SvXK62+qM44kjdXCkSzAd+xTaSnQHqA9pe3e3DhACTvMkA0gqINyO8sb/zXYLesfjszE1Wpi+CliuCCB3LsWtsXRIqvKI897T2krIHO6b1CpUOgyDVECmHr35MLq8mtBosBZ4PLehgANSesWPDj8IumrQds4nKt/OVEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPJReohoa6ha1TS+UjP0LfYpV0iyN95RSOQrPlJWMMk=;
 b=Khmv/YSv1nrmLxXH7Zx0w5pPIesxGXOrFDaYLM3IA21JyE265z2LiHnz2umXG03d9SkyYUP28Bzl03d0a3SOGK1YyUVrpZbCw2q/eFTQUS8L5PMh1nVhbLlmvGbUNzg+idtGa3Xn3+nD5dkfsk2Nu5e8ePHRx1ZMm1S40Rw17QA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:40 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 02/27] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Fri, 21 Oct 2022 15:29:11 -0700
Message-Id: <20221021222936.934426-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 864f3951-f73c-4719-562c-08dab3b3bec0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1JeJq3ZudhVn68DRRREkbsIiWOwrJX8IAKTSJgKs6J48EDoOaPVJRdfjpL7TvaUmkArMaP6hLxHzTIV4bmIRDizEXSdBUZ+qCWt7gkFPbWw6E+5RWpwLWdforpVlOU8WJNK3QeZV1ZcBFenecKZOTm2jbsOfC7vpdNjDGc0s0Zw2Ba9YhFXSnqPKo5KrHXry3dhAbkyJSNjuavZHN7vZTmorgbY1HUA4xLHQ4sIIB75R6aaD6O1lglYYrjbTS+UHzQFaw0hrimmZvB+amX7o2a0oLUuQhKsQXJNJL75e68RP59YbdZiTP3hMlN5jMaRp229r0EBXxrASENwQPfgAseGd5QqLWbiYn+H0R7xni5nI/yEbwltLNz0brvugIyrbyNWCmWfpdumIIPk6mj8IgY8Y2R0UAZF9CUlLSHShM+T3hpjIkXUu8E4w87BP0LKdhD3so3a+oKdbZ/zj1xyWgQgNQpAJJaqYEY+hzQPuDOgoEMmiJZ+pjSVjiKGGswIa7DhTBK5rt98WgYUUxZFyYbN66BESY8mkbnqBJl4DfRw7GZp2KAuWJsBqodT2Zx9PGV6MYR7e3XKh0jT+qKrNDruRTjEo7T7lHbkyn8RVkY4Zqx/cQMKiDaFSsL1FCG9zen/+bgNb5qDEftCOTgEPFj+XpuPG7nfjAwbyTY2GKuDSv6pmqo23aNLjkvRbynnGD3onaCaHmOXTSp2xz0hAAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2a2cvpL0qpO71wa2h7pxuBAoFrlWQ8CjnCk5zdyCxGnRiAF0sbpjfFb8dmZV?=
 =?us-ascii?Q?0oFU9FDE/ttgF66gpE8mcrwN6QdvVSdpLdKAjhxEjWwX/yJjLf/8zr6kSrga?=
 =?us-ascii?Q?uNmfqIFprlG7pG9zrrLq3BMdJObqp/TN7t4tX914LtPf69n+LDHLzZYEeZgw?=
 =?us-ascii?Q?LrqJkby8OCw1QWbdLF827l4CjK/tX0yWcqaREZhMReS1rtoNCeCBMAjHp4g6?=
 =?us-ascii?Q?iVg7K8JOi0JdrrkpFFFquoZtoN318OabhQHA92++H81VbnnnKc94IxjNtual?=
 =?us-ascii?Q?5kGyfw2QH7VvY60BbnwkVvUk3vdAiksrAAR2z/CK3VVn+fgwPGo28i47haCw?=
 =?us-ascii?Q?zK+86iIrXz8hQcky9peIbMzUjHEJG8kOjFbpVxL8xjVs6rQaoGhee2Q/VZF2?=
 =?us-ascii?Q?OJv6T+gXnp48MAKt94+g/LSiXF+FsB7ODBiT5y44AO7zowpjX1Cr/cR4wKCL?=
 =?us-ascii?Q?DjgbFJaBiSqKz4JcVjN7xSNVL3PAah2x1S17Cv1mLJFSiQZKiaeEGDPol2t3?=
 =?us-ascii?Q?6EIBxCEWaQ+8Xig7XxcoSj3RsWbWurs9ystZbHX0Ygcy7UjA6eX4M2/mVPtk?=
 =?us-ascii?Q?qZR/yJ2vp5XYiVwC8YqYPZjyTdmphYxJoZOLjhOpVU48KWdVHm4WW4JJATxn?=
 =?us-ascii?Q?ALKcLiZfpQME3dtlevZ8u83mqsHhjijyh8X0tWPywlQsdVhOji7D4MVhtPXw?=
 =?us-ascii?Q?+ubV9RHkIO05SE7vzY1rUd2+htEL2pHlxJLgnA7BY8Th5drRa9jUw+kqtBjT?=
 =?us-ascii?Q?mRVpm4bnj4tnXEJ848fOnX98wfI4ZazfeW+C9ZFJsU6xAgy+Hdusu5aJzHer?=
 =?us-ascii?Q?xZJioDDh4Xh9WYJO9Du45zTAbip1ZxXXOkqL8i1L67FOIlOreVsnngIXTG8p?=
 =?us-ascii?Q?x2lYysqi7CpkxOvXSHaEndguqbMY+V6pQIURNldYl6Nwf9HWkiwIsKAFey7q?=
 =?us-ascii?Q?IFyky7RmkopmVIhi2TJzC+/FljyrCLEb57YmbsLZZOypfAtX90pchElb+Xw3?=
 =?us-ascii?Q?mr5zLCJTdTyHhxfB6iyshvvE5ygPxZTmWJ2MQoMGegDl4Ks1D+TpENcBzaJz?=
 =?us-ascii?Q?A6qY8GFNeSbOHKVSI85z2N3EnvzDTz3m3S3ww5W8qOi7iPtzrsEllzMrO9mf?=
 =?us-ascii?Q?UNvx2hRsatJSSFXeRFkbFxbt8BLCGSo5+3auEXwDitsjM86QN8xSq04Rq+up?=
 =?us-ascii?Q?/vPXUdVPHOIwh1O1pYcVpXDlAEgLPFWvXZdn39LAr0DlZ6+dn5K2tfNmAMmS?=
 =?us-ascii?Q?lFox/MCOqoZrJljTM11m0bqH9tKUidQDDHiX8x4o3l7AuhhFLpifAUOCiP+Q?=
 =?us-ascii?Q?GlZrQh/soDbTeDueUClFBn9QFiM0ATKXlmE1V58BjFF5RiuHHY1S9YnIsjHS?=
 =?us-ascii?Q?+RuegMLM6OFcG2KfCWHo4SEUt8a8K/PB+TguH9GxDfculUOu9+6t9vVCFLVr?=
 =?us-ascii?Q?009VMlTdvqYHoxRiJe0vkAH/nxykd1SUA2tdzSzKfwSpoBju1BhE9/nhj5sN?=
 =?us-ascii?Q?rlxb4pnbXp63rlZ/l4Fbz03oKMrVsb6e4CtDsDA+R5/bY7QjofRYLa8orGCd?=
 =?us-ascii?Q?6xXuzqCDF4gddliMZp1St9l8Wvgg3toX4wmcMLXzV23D3IjNjghqR/0nVXEF?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864f3951-f73c-4719-562c-08dab3b3bec0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:40.8402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w07tLm83sKM5t43FPR8XnYV4ET3W0eA7MpTGFAYSQX8ZlZcDcqD7iX000up6VihNNwX1Rdl9j8raZONNp2dfz4jC9N+cQ7fdM5iH0XgfoQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: VJyIIqcAu4gQYY1OupEjps-u41LVzvCN
X-Proofpoint-GUID: VJyIIqcAu4gQYY1OupEjps-u41LVzvCN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..fdf6941f8f4d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c000b74dd203..5ebbfceb1ada 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..2eaed98af814 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

