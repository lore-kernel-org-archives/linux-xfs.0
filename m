Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F00C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiLRKDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiLRKDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAD5D2E1
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:45 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI88nMX023742
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=QKvLNgMADSwIys7Z9r3xQwR4akbPNIA5CAmYUt91gLGFGW35XxazCtJ0TWdGJ+LsRdMW
 tKigHrdSDGlomUjYvpns8zdG3SfyUbAvsBUrLC2hE0nipBswhLAHyXy6h+OjvWIx5xGt
 a7zGxK2uzelYdStDJcciyDB7jHD+ZPYGZtAEdKaw5rOH0EJSXbNCSHSbZ9K03ZE1ihR5
 23rmHgIQVREAsTMC8RxSnilXiDUMql/yi2Dz0GerpM2kdU9bY1509reTfcqlkDMcCG13
 qT6Q323JizfX3wCFXUrYTT19bwEhRYVYsDXWHhYYslCG1+kaXP9kqo8bwPx/bK5syOT/ aQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn196x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8UK3V006898
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478n3x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvMZqha84sRHi5anWJZTRH855rLIB5btkCJyZ18aytofIlhHR/g6bDD3WUncZfWZHdZGUru9Invt1V2BAyrEmW+mK7TWmg032bCD1X5MrBgDF/0t5vK4Cidyh/Wi4S+MofJCcIkZbRppLBM3bgNqjAoLWiDBbutafQG8aRW80Ls4DUk0SnCzJuvM5upd5YR/sX+N/xpM3njuBvsiNZmZjDIhRdsI6dIqkjk9MitDJ7+vHJotSbEdmNdaRlNCqtlq30Y4TQJcjONrIseIGbh/f3v5UUSEKjfOr0hVJuErXriqpgaE8bb08zxEcqAzqzpAby7ihitR5Gfk011RZ0K7ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=e3AQjsa2QtCnlZ1BSQv4ubQ2wkjvCWN03o+jNSJNBq+5p6odHDddNKlHy/UXV+TEjoIFltyLbvox+rjAH1SqRZaTf6GO/Zu96csPLKbvwQhoVe7rCGRvfLmHZQDpCzRBOk3Lf1Sj/3hMi3Zg+b62jcBWcGBvNsSNI0As+RsBR1ahAQmRpKUfvHSaBY8+AWpJUH1RtNgrcp37j5vriT2Wk9G3G4ExNuNBoxKzQQCmDqVuxLMBfk2d/C2EGzTn3IHvpnKzRuOmA3RmZY7nVR3zOXtIlW1Vm1qCi9YHhTFRzrbbBlGgg6QzaXgjMH7TBRPYr4Jx5kNjRiA5r1RW71u8qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIC8fdeyODQX4149WUoke6Xnl+AOfMDBbJODIBnqukw=;
 b=S5o2na+ORxBM2SFdFoE/5RsHilPYlS+8kt5BHPCy/Nbj8p28wmlb6B9y3E3Xmq+80mHKabCzuLZZcn7pxnXdz8SJo1czqoYko7rZKpgN0J+Rqcpkqtv7nVo6Mx3vqPoZM+RH1GXNb1I2KxUBdunj/1cdfqCdkqqYKqXh6OTBuLk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:41 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 22/27] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Sun, 18 Dec 2022 03:03:01 -0700
Message-Id: <20221218100306.76408-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0156.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: 94bfe6fd-6e5f-40c8-0c9e-08dae0df2434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8Ad4+0sLoPyxSzUkU2fvZ8vAk/qaU7HTzJLWilngFuGLOF+IwyhMk7OyZtHG+Q7syd0qtPtx2VetANntLMhsyCCenzEJB3CLrTp6RKH5y3zohQPpr4NIPEXL2ZAJcWvac4fcFnDfIAz3bU0nlWEfcPMssr49Y27G6Hfoa0W2qPREjRidw5guJarrt9kFTSF/P0id2WYFYjdp2vDRNXE+w8aO77SOc9/v0KRNSJxTaotnKnx5kHgLpa7ocXdyDujryZT8ZM1EoH6FErn7vh1SLSXY2ufhuNxIJAcDn/dDZJXqez/CLh3+g/Ouh1Sq4DN7nOg1vSGtzb77N8sKXrMNoUPyckTxgGolKUW2extlyeekH3wL9tGklTt/iFYcjDdPbqB7NVJgJj/VwubVz/D5ujwedI7vwiNASZAFBlL+zu7YECumE3gsIkdY/GnSOa2A6eruVglkh7ELbcZ3B9SvTEIq/PKq3O5oBInUi0+R+pWOQzutqsFtok88uNOZeyE+ioQluTwh/VoG3HtgCBNMx5QZdpGNjoG/WmK9CnfPw3CdESuMR36eV3grexfoSCueSv9nU0gag+gZMog4WHhwE67qazDEHWYFwmxDSi6QRJ0YAQWhWGbSnkYyXzQsCwWeCLH9LJq6g2BBs9v01GmSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pL+HFc98FVSTn1MxlEiX5XOxpmAJIE9y+DEayTP99E5ZPteBIF81R2dfTmGc?=
 =?us-ascii?Q?N9Z019DWP7L634VBzUBvTmNg7X8o66qIFPUw+ZVItefisjvxDTd2pZWqA5Yu?=
 =?us-ascii?Q?KmR7nU8tgVyRDCUBnJSOcxmr/oxibRm/hPMmdwna5fPoA9BDtpE0yecirJJW?=
 =?us-ascii?Q?dGgpDZD8Esl/h0pKkGti/X1Izprori9UoJrOI1bUhf7DvwYXWsnrjHxGW7fV?=
 =?us-ascii?Q?oJay+PxwcanR0yaMAUVmw4L36gzz1C7yjBt+Bt90pN9zxnok+5UXYJiZTbHi?=
 =?us-ascii?Q?G0L9en5RO/CF9bGJyYvZzr3tVMWD6VNptXtvgvCtSJs5ipF9USoVm7gzG1EH?=
 =?us-ascii?Q?bi+gU6+jA2ONeL9cjVkLBp4rmRRyragqnjEHHIzJfe0Cw2t2ex+aJV3IhBtD?=
 =?us-ascii?Q?QNmUEQWyxtmUck6xU/nooOgxoNevfGC0B8pWr10FFbFetXcaha3tF+p6hD/p?=
 =?us-ascii?Q?H2l7JUeq0HjoNWY3nuCB/cfiWlhU37udKrONBOZrBGLkmf53sdWjzCHuf8t3?=
 =?us-ascii?Q?RCwlXhDoI4k+af5HIUMzvhaeZ7LfnPKESB73sg5QuCzRrIQouOjxC+7jbnZx?=
 =?us-ascii?Q?0jqSIwPMLG0+Dgzqq64ojaKUecFGJ7cFA0D1S+pJC+d7hVcwc57dyyfT1luu?=
 =?us-ascii?Q?Fv91ICy5dpIBJjTzFhdKUoV1pDoW837yN+WGlqBLAAAd++PYieDkwr+Qvoob?=
 =?us-ascii?Q?Afl2hyxDO6d6UV033i732jc/lHijDDeDnMigruiWCvgjOiQxcAm2K08xC2Rb?=
 =?us-ascii?Q?JqF7vwdDK7Y/wL8+vgOVlNeerGyGk5YZqCXT5GP5TTECOJZI41aNFfuqRQ6I?=
 =?us-ascii?Q?7KgvH2mZ51Dut5F1kvpPiucWVmhik4Tb5/stfZGo7rf6aH7K/ERlWyh/LEbA?=
 =?us-ascii?Q?6rOSJsLxgZJL9cpgb8yb7TBWV/UgS129a911q2+RAOHfgycskmJfUrUUshog?=
 =?us-ascii?Q?xMhDIhgAFQ6IcLoDiQfToCIXaj4kb78kwe1+r5ghjA95y0iJr4YAItpII4WI?=
 =?us-ascii?Q?xl47I4oBV+E1unwLnTgK9wikz4t0MmfP1N1mGIT/mpayOrUMXQG8xhFJZkhO?=
 =?us-ascii?Q?66IFxFS92iH5V9Ie9vE7BmS+cNCTbkwFgrjw0ojc/J4/R3x+zcgQRDam8ItN?=
 =?us-ascii?Q?5wqJEODgQauc5Ty82kfpoIfAaqZw+9tkhwU+cEYoiouFiQ/QTTieceadGILM?=
 =?us-ascii?Q?GzUBVVUTo+hyFOssNvzyN5CaIg0Xk95pgfp0eq1GchplSgB8+MiMBbb7Yz5u?=
 =?us-ascii?Q?bVsxXogLD/7BV/Q4B4o4MlScqOxkzbVW64wW6hGDOdw1rrfGAZJkyIs+5xb2?=
 =?us-ascii?Q?Dwl79eEqfVOimUDcQc33SN1xdouT+mfx0YufTClMXe2IWUnQZ/lNcecKofIT?=
 =?us-ascii?Q?lXmxlzS3/jlD7H3vkWgjoK72vVnhYQv0XqO+F6cGOhALI1qzXwXy62AaHpax?=
 =?us-ascii?Q?c6DMy70akSLwBuwTzZfRWG8oCc8jXSiG+erZXnHidF/D6Gat5mtrRnbpJE0H?=
 =?us-ascii?Q?lqCbgUXfzfm4DfA15I4+/6rMOK0VViFeu2jw02DEVhqnB6vVV96G4J7P5Jit?=
 =?us-ascii?Q?NHO/v1M2EFDW2+2HxL8KOd5PdDs1ezm0cp72W9gXdo2GYfhaqSDnUdKlrUm/?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94bfe6fd-6e5f-40c8-0c9e-08dae0df2434
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:41.6847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQKY4tMqb7Av80S7h/7Z25d/1XqRYUCMV16EVu/oPRTjXyTXqiTVa7sxPVpk5MIAiMyzc8KZ0DZWDq3NM0tVxffwviZYKfLlgfNxcisunEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: 0BP29eCL5-FFNPfAMjHrflY3CxC20Uxb
X-Proofpoint-GUID: 0BP29eCL5-FFNPfAMjHrflY3CxC20Uxb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 4 ++++
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..f413819b2a8a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..b0b4d7a3aa15 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 1eeecf2eb2a7..a59bf09495b1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -173,6 +173,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1189,6 +1191,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0c4b73e9b29d..8f1e9b9ed35d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1663,6 +1663,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.25.1

