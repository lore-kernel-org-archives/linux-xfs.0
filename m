Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57230C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiKJVGX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiKJVGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F874AF25
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:20 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL386q014039
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=4031/eD+z7zjdlWhp3b+fysDVSFdjogWtt0VzsXMpEw=;
 b=V0NMp4OFQJp57GL+ZuDudMCzG9S0q4aXFTMq2eq9IX/eGtih7Y3udY/KsA7Nq7hKZciG
 XHDtQEd3qWsBFtKnTcw6x+OKysKLoisIH2FwqVjOHDyqdW9BMMPtxQukwmkdyXXYLNv9
 j90AzECAPk07gEUtnAghZwh6+fzDnfzfFQmJU3EhsZS8R61pXtC7+3YAN3G0z5dxARa2
 FNurpkZhXnv7+/nTDYG4dknWzwBtbjz6w3wtBquOE4Lu+4a5Fr1RBt2EQQy0fLeGbtvJ
 0Y/oZoo9dS8xHwNlX8pKRmuU0zncmXeMvAOe4Grqt3OszvPom+oCQH5P7Iol2Cqb7ctP nQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8vbg08p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKdVN6009690
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5hbmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVL2Lpup5CeGQFqbmALqQlyZuc5LbY1FCGopyy9ggGKs05XOtYhbHnozOUwVoXV8reAK+pyetKTGrIMfqdYfYrq+ZYfvxfq6auFUOrQf676Q/74zLs3yqd8eEXepxDntKTpdf3xhGlaA3tggmIpXkQdZtYGIjmNqh6qYPNxcDymYeKfoJXLqHoTOW32A32DaO/cEPjk6ZuzISbLHnQpJ9dsoOYavH/v+u37kFdjUUHW4QhBfzvfMjWMZqUcfco/gyyUqrIbjpiZx+/x0/Dz7LXPC4zg5Znz7ylUJVi8wtK2Gwe1xBSMom9R4iCLutkkqiw8Ix0DfdczX4X158UL61g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4031/eD+z7zjdlWhp3b+fysDVSFdjogWtt0VzsXMpEw=;
 b=XRU5IETTe7MdxbcRdaNfXCStufytRcSCDU4PdPooYSNpfjg+xyEdTEJA+XwRuZn/uldKr2k6pwmutR3DEFajVkXfe54xEqHl+M5bOq5Qce9jP5FUpoE+xL/soF9ZaIrB5ocsElJDoOVjxT8zUJCq+hM0+JzfnLVvY4whgJVjp2Si24N4TXZY2j4Qifoxeq4LRs1CkPtlhJF6vxZ/7UkInT0Lb5MLvIKvC8rH0q8s7W7r7z1ghy2bN7rCCWpblUxuF7PdebhQ99fhAtjX4H4EM6tWgvRfuxWuSaZohCd3Orrnoq4InuXeN8V5KZTC4J6vgEVlM1aMr6TQbENKY0VjYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4031/eD+z7zjdlWhp3b+fysDVSFdjogWtt0VzsXMpEw=;
 b=wuUSflG4Fe6aNxs/hlXS6Pxost8Z2xWfaYnTvABzBogqMIcKT5Lw2hwcrgERv2xxOZ2+ITrcyGaOz8V6kZJmIh6+PwllMoz8uchoCsU9AE5xVYSI+MfXAWrKBUr18521ZPvEMbAECsFgixTlwFsEi+AjaEUGe0NuHO3mjXxnZC0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB6318.namprd10.prod.outlook.com (2603:10b6:806:251::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:06:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:15 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 24/25] xfsprogs: Add parent pointers during protofile creation
Date:   Thu, 10 Nov 2022 14:05:26 -0700
Message-Id: <20221110210527.56628-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0035.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::48) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA1PR10MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ee3789-2e23-4c6f-2087-08dac35f6757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1LRNb234yVZ7jw3Fo9s3ufzWOC4lxt1E7QgCjcZTbKazWXuqtZrDbFmtqCxEv5VMTGryYyqItk5EdjcDLh5Z9B1oWWJcm76fKUkC0JtZzNU5l8w1IfCUyx2wAVDXhKdPkct0MMkbfsH94TDHSIYHUfqRmakaV+olwm9Qn/lOeQDGil4Sk09fwo/mTqLDmIPHA5ClDAdllYerxixpnoes0afL4YULC2qjubo766agkJDlF4G0Eb1JwoPY2v+Po7m8XU+irZHvRWH6FTHAYRETzHxAnUQbSbJhy0QiaynzVaIAvslfXRFHWWr3/dB4wFsZw8pRNnkv4s0fjeXRoOPmovywR57H59cma7yOJxet6GfnfU+5e9gv//uManmyDoznsanQ1kXT+poN7ZFmBMlev7Bu8bKPG6q4DQzgQadrEcFR5dMEwj+6zky5zYTok8Coj7HliBESxJs5LsfESoZT2MIo6RS5+D8k0DBjelJD20VWCKiaoShvEu9TFKOlf3RJNYt/RyJTum/HI8muxr4eGVweM2c9NdEJIKkLsH8GFfuz7keUSjnN9xtsWikmrQRwJbANR4bDJoVXEPb87+zHCobzMxO82WH8Td0he+eiyVHdZ34oKyopwmm3/xlLbuFYTQBZBPmz7/v4S0pZs9yfEucfzzOo7iofm0QQf570B59ReUbXEoQOj0feHdyH1wQDAdi18rjq+2wTwGW2xoESAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(2906002)(6916009)(36756003)(66476007)(316002)(86362001)(6506007)(478600001)(9686003)(6512007)(26005)(8936002)(41300700001)(6486002)(5660300002)(6666004)(38100700002)(66946007)(8676002)(66556008)(83380400001)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PrcDnpYO3S+ZCj260AA4Zk27DVBTY2lvAPXica8CzmJTZKBf1ZpzG0PPBa/S?=
 =?us-ascii?Q?VDQrIjBu0jmPb1Nk6lv/pMoq3sikgXmJ+fUGzCX4xeywpRXeaoJgqvveJQvP?=
 =?us-ascii?Q?DYWI4tNM9izRxhTYFmk/FxeAbiaqR8h3oWiMsSnZHkE8k+Hj+x7xHSTyM216?=
 =?us-ascii?Q?a8YpPGYtAbDjouJYcHxJwWDovBZ4AfLLPIJ9UCGn4DwrZQjFDZnqm0/EqGHH?=
 =?us-ascii?Q?rgjXc0vugnYZiEPDHCtP2n087JryocyYvrSAUF/2xoO8lxt7naKFf3VKebyH?=
 =?us-ascii?Q?8PhxAk0JyOQAfkWvsGn3YRasFZTIQoQssWcNy0x3sqgzma6Lr42+/YXUPVtD?=
 =?us-ascii?Q?zJRydrAXBWtTxc+4GzmMndfT9rDPJKHq+be96+FEdSaEDP2kxejC39I+xu3O?=
 =?us-ascii?Q?jTFrG8KVo1Lcdq2tuMDWDL4gh8n/7u9FxGzNvl2/6H9bKc2RmNJvOhkiZs2l?=
 =?us-ascii?Q?GV5W5rbvY2h1hGQ+EZ2mHr43b4NendP5Mf6VHScKrVE2PMSYkKOSwA587ffV?=
 =?us-ascii?Q?viH/VY7pX5KWVPvMWMglxyt1HIbrFiJz3G2+1bqs+1OBq6D+gCTdqyejSTrt?=
 =?us-ascii?Q?ZUJywiw7acywO9PzQAoMI98YMzD3TMQ5SKylmovJuPQ25QUoQKCTundCdNQX?=
 =?us-ascii?Q?puo7xW0spvBvx0DtcFLAMboc/rklKJ5XIwgMDRyZ8JpDxcllrvnorVyOzJh4?=
 =?us-ascii?Q?0eYDg12+rvw4MUNKR1vpVh5lKvP2UNsnF8orshBquXbRDZ74/M3X+cLKqsuB?=
 =?us-ascii?Q?O6QpzSNUsnSyjQ9iBOM7SrA2YLVyFEHxHfwxg/ntxB99LO+ke+Ty7Qr+5gLQ?=
 =?us-ascii?Q?AkiPq4nuokk0LGrTzoVDnJA7NZA2xVkO6KyZSPCqI2er8JLAJnHzVNonoYFP?=
 =?us-ascii?Q?dkJNJEfOg67/QkI7rOiVDfDohKtD8eu7M8FtynpI1YjmaNG7UjbP3Y9lRpfd?=
 =?us-ascii?Q?6WbqJ3q34ods5xLUD8YEVhCeu64G/bNsAqIoOLDWlwpPpyvBCn/MUvD0S54r?=
 =?us-ascii?Q?W4f4jeSmpycqyjhTHhS02bqe7tLkc9KPdNkSqPihIkmY4dPw4V+mwLNk4vxb?=
 =?us-ascii?Q?PoUJ/KHe9KKByZAX5B4pynew8dR8zERtpUiF5Knus8bCqtaNFihQyZAfKWHO?=
 =?us-ascii?Q?gE4d2au2Pggo9AqlZxdGXu9C+TiNHJmVjIUb4HwmkBqXTlLVu1KeiZQPAtZD?=
 =?us-ascii?Q?tghcNA9vAZTpuW97cupV8h2n9b/LgWV1F9MAPg7sdZBGx61BIArIpzLpOAcV?=
 =?us-ascii?Q?N3ZrUnu+Fq/sg9Fz7RrslmHudN+WWWNd5ztdrAatsskhR7Q8EdDcB/L1PWF0?=
 =?us-ascii?Q?SaPYyV6Rkm2qHfTHNEmrTyZkau+e/i+mAl7LFbx3HeMADb+yDvtt/l5pzikF?=
 =?us-ascii?Q?jLnEtV5RSsR/Q1OIuuFMxNdcQ5SVaqGBsUnV089r7F6dYCW54Z+GpTHq8MVd?=
 =?us-ascii?Q?HgwJM1ip489E14fwa1CMCjc0izQ9HtBtk9n3Uaf/w9PTP8MSe7g/Cf0gNSix?=
 =?us-ascii?Q?1akCD5V45hT+1CiBtCF9Ir4GCUNxlERFnLu/fWwcN69EqMFXq4jBfSApDr6p?=
 =?us-ascii?Q?GrwemDrAjL9GolZMwidazJTkY2MeGH9fAWKjjnuyuQ0s0vYeBAB/0sxV/FHU?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ee3789-2e23-4c6f-2087-08dac35f6757
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:15.0512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQx1U48S9+h62ltcHExdSLZ9hCFfMzJcBlrOEMrRpyC7dRsh3Cd/0IYGfUwo0kAyb+R52j+6Pi9UFONeH4zgeNOdpMbKytWl71Uxd8+21yY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: PWP9QM1olrmH09h2et-EZPMsh3l-JIuM
X-Proofpoint-ORIG-GUID: PWP9QM1olrmH09h2et-EZPMsh3l-JIuM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Inodes created from protofile parsing will also need to add the appropriate parent
pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/proto.c | 50 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6b6a070fd0d2..36d8cde21610 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -8,6 +8,7 @@
 #include <sys/stat.h>
 #include "libfrog/convert.h"
 #include "proto.h"
+#include "xfs_parent.h"
 
 /*
  * Prototypes for internal functions.
@@ -317,18 +318,19 @@ newregfile(
 
 static void
 newdirent(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	struct xfs_name	*name,
-	xfs_ino_t	inum)
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*pip,
+	struct xfs_name		*name,
+	xfs_ino_t		inum,
+	xfs_dir2_dataptr_t      *offset)
 {
-	int	error;
-	int	rsv;
+	int			error;
+	int			rsv;
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, rsv, NULL);
+	error = -libxfs_dir_createname(tp, pip, name, inum, rsv, offset);
 	if (error)
 		fail(_("directory createname error"), error);
 }
@@ -381,6 +383,7 @@ parseproto(
 	struct cred	creds;
 	char		*value;
 	struct xfs_name	xname;
+	xfs_dir2_dataptr_t offset;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -464,7 +467,7 @@ parseproto(
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -487,7 +490,7 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		libxfs_trans_log_inode(tp, ip, flags);
 		error = -libxfs_trans_commit(tp);
 		if (error)
@@ -507,7 +510,7 @@ parseproto(
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_BLKDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -521,7 +524,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -533,7 +536,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_FIFO;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
@@ -546,7 +549,7 @@ parseproto(
 		flags |= newfile(tp, ip, 1, 1, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
@@ -563,7 +566,7 @@ parseproto(
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
-			newdirent(mp, tp, pip, &xname, ip->i_ino);
+			newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 			inc_nlink(VFS_I(pip));
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
@@ -599,6 +602,23 @@ parseproto(
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
+
+	if (xfs_has_parent(mp)) {
+		struct xfs_parent_name_rec      rec;
+		struct xfs_da_args		args = {
+			.dp = ip,
+			.name = (const unsigned char *)&rec,
+			.namelen = sizeof(rec),
+			.attr_filter = XFS_ATTR_PARENT,
+			.value = (void *)xname.name,
+			.valuelen = xname.len,
+		};
+		xfs_init_parent_name_rec(&rec, pip, offset);
+		error = xfs_attr_set(&args);
+		if (error)
+			fail(_("Error creating parent pointer"), error);
+	}
+
 	libxfs_irele(ip);
 }
 
-- 
2.25.1

