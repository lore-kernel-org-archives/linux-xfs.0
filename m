Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B4EC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiFKJm1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbiFKJmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9500C74
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3vwxg029669
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Sn5M+MvkTeadwVyvqcuIwkA3iRGI9fhiST0ncStYfNs=;
 b=FwLCzCwATniyco+r2fDro3o5gYsn2IUUDzn7azkI9vxD8IbjRZ8VPnknW0mp3g9Wa16g
 rcCEVioG+Y+Lr2T5IzLfANep3+d/evXjUwHkARxZyb2K9qOfXafCw+TdbHIWjbHFc7ri
 lNlR0RhljeQp/VL3Rwwxf+VinN3u1fwvnWcWyp9yE08zhRDE4fwU2wmTudywIru7dACA
 xO3KmiFkNlUi1/RDJzXfar/rF8srX8o3TyRaQKk9rBsXaklsmh9AzDur3GwHMK08/y9W
 krNhXLTaIYcEoATBI9hSiQLgGKOQjsm2TmdI5HzxVSrOImx1mWDC85HPXNMYKEb1qKzN dw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkkt89wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQG025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyuIzTGwUTfnL9NNuvpBwPAGMtyk72nmo3QLCnUZnvnnBcBWq9QazhyzS86b63hrSyGdQNMVCl3M9URyrw7eTXIfxaQDltNeSQ1DmEtypHrIKVANd+cFvUS04/OdhGn/uyR/Fbav083uGv4mYlhoPvyXw9aLEqfxTDaxZE2Tt9opG1pGUJUDcD6oT5904rMcYTtLlQo+gf01iZHFGL7Jji6bHoea2O7ZGmKm5VTUNqk8jOOwVGW+d6U7e7uKsZVh4L59lv+ztNW+ohtyYuqtNVaBhX5l3XSVtxKqA/+j/Q7/Kilejq5AHI55SfrUCIu9TxT2nkEtvYrdQxLfgfhydA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sn5M+MvkTeadwVyvqcuIwkA3iRGI9fhiST0ncStYfNs=;
 b=ACbzH+jWT7oDYMQ5W91rH9+ef6PrdO3nQIQWkRNTPML6cL9uXCSa6MTpqN4+e4jtLYNMc+uzc7u4mQeKGsi28JOplWguSVmUsQBXpLASKOhr99WbgCzI2KZkiAZeQuDCrYDPbrK395lvIs3fiAWoYkV6eVRZ4Wf9QGA9DhBHTHikZXMJNmqQA0fIVglUsY1mQlik0bqBEGuC8iEabxRabVg+uh6gQxUykw4ExGBQRuMgjEuRaxChUpXuBRy3s9RJyTfE0UbXHhlATDN/ibzIobzuZ8bFkpjLn0VxUU2Fy6Dm+qfj/Ozx3YwLoAnmyNYuS4Uv9EfMo9kB7B8g/CY30A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn5M+MvkTeadwVyvqcuIwkA3iRGI9fhiST0ncStYfNs=;
 b=IIY/im+uTXY4LtMd7qyomZTaLl4I+eoZ6gyiQ2VNeoFnIVqQxHrRu36zst/+hyzzor49awevlC6RaJm8jc5LdRj1JRUOlBlgG5MMkLaUmeUpICyalbD1AKZGphipGah+XI5us11AVgec0AK07po568rkWaZhM0biI/a+VFUjKDY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 14/17] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Sat, 11 Jun 2022 02:41:57 -0700
Message-Id: <20220611094200.129502-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bf498bb-379c-479e-f109-08da4b8ea7cf
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB460667B531BABCDAE11508F995A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eerWx0331aIAdDi8qo3Z1FAasoTMtete2SqtWy6M9Rnypi4Vno7GS/OW/Na7QboO3oAqOj3EjXjuwL3mMV8CuRg6O918j/hAENS5PrU3AlvHcEW3xwy0R9YS+ErotQUSiMnPhwuGTpM3swunV2aFOjD3UwgAxJlLeFpEb8wJVjErp3L4XjX3d4NbxXc9rk4uhAfs4+jZrSjsxQV4eVzTKPIXLYCdhVjs6NUf0OJwq0OwCeZAptwJ2HKx6QWbYYLF4v1d7s9gjoboPdPaGhbgf8GYZZvim+jUUu+UqTXOKkRFIJFKCCNmYJXYUPRe5RkClw5ghpqSRgpBgcjUm6716shYpWbyvyK0Wkx0UVnbyr5ab4imuEf+y7KHZ27Kbrt3OjBBzLirzmElBkiuU7yCcAOLGtMP1Bw/b4CsF8ATKea846NeM1/tsYo03GtBqAidl3y4BhcHX7palFCz4Hv0UaI9nR/rzY0vW75MYGmjsdXU6d3t/gtw2Xw1m5gf+1RGF34rXJbfw4cHgRgoL4n4QE0j5woPoNIPOG7Gcn8DKF6uiw48tplzEh4X6IbiJh1nuxloyuZ4zv/Mlr3FnYiMr6RDpPO0bNtILvAAKtRWOk160F47g9EG500GY32NYRZ9g69XGW3TY8Tfg6Isr7DufdFpHq3XGUW+qhDJnMaylnexskvh76CveXdn1b1DykgDyMMFQ8tqKBhJBUsIJhcdIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dkpnjk7OAq9FV43JmYRKkW56Knq9QLa09/ZKYH4eH0h1JsiP16A1XwYiOsUW?=
 =?us-ascii?Q?Y+BaZIF+YnsQPSQwcc7ZVQQWNWRgNbnczxGVNaZEEZ+6b5aYAFwt+ACsmIhT?=
 =?us-ascii?Q?NFIH5IExXxvNorScGVgp1NVW8kL7aNFm7vJEByC0/+y8ZSejaqOVhPs8C9Cw?=
 =?us-ascii?Q?uRSJYEHDJCDX/6APatjZlPp6V0AnruZ0INTucvPBHyTbCSU1AIbL+TcOxtYl?=
 =?us-ascii?Q?mTHBKQBB7T+2S9/QZUEKdeCMA4Tyz+JF8kOMRLvaq4E3Guckw8gsqa1PJ1fK?=
 =?us-ascii?Q?9wiAPUfavwWamnXk9A3EY9HolGZzmONYzS3ElGHCfiqjrkyg2mfzoHENgVp4?=
 =?us-ascii?Q?6LC0jrSX0kyS5T3mIkaKOYyHRszJR0mahZxK/uK4+/7mhl+cnhU1Ku0r0Go/?=
 =?us-ascii?Q?tifdf6ecW5fAHHdfNDsqSF6RL7eRCZr1NUYI+BFmlBpoiRxsbF87ejjOe8P+?=
 =?us-ascii?Q?wXYJkNgGuBHw1LHTNJo5SKMdNB35h8wIWRc1uPiupvG7y8a9KsXThOBl8YWV?=
 =?us-ascii?Q?YtaIj/PEDIFooQsPKOIrPuPqJoI126MM9OFBkIwOTGAci8D8O0FGP6HYcnYU?=
 =?us-ascii?Q?ayVO012XEmMjglVv3uQ+POSVDbh48HmVN4Khjh47IXMSBYPZ5jX/eHVcm80x?=
 =?us-ascii?Q?W7BXaCs71KXvONLp4y7ZuoHdSnKHMssapjIksc55l2BM/brgnN4Fs0SVQdOK?=
 =?us-ascii?Q?7b+G577qm0O+M7cM8pqyUthNK0V6Wkb4sqTMLJKlY0fDOOEwAuZhJox77bsS?=
 =?us-ascii?Q?j9bfFMd0tmuJq5vuTYzbB07L3akVtWzud7tRzykwIGYW00rQ5Xid6adVA58h?=
 =?us-ascii?Q?dJa8SvHFPSXb3//V+cYv+RUPyTiP5IgONbA1nZrw0zceTtbPoYvR3rb7FzMX?=
 =?us-ascii?Q?KbjebkXZi06YM2a9uCl/qNIdBzm8OQdbz0TurZihKpI4Vw8XudimsjpD3iz9?=
 =?us-ascii?Q?nI0aum4ij9jMvNkamGAS53VbS78pfIdgY16i0ENd74c0U5ym1XaupEKALcZy?=
 =?us-ascii?Q?QpTQpm1Wufzfi4y1uzXfWXaM87aofR/+NZWKK1QsUeRhyCHdmaB7Nuz/cApE?=
 =?us-ascii?Q?xvMeQ2GRLGRLHhYj+w0P/F5xYBqYjLHJqr9tJuH6c0ztK/hB9QOwQl0tyRFr?=
 =?us-ascii?Q?YNAHi+4KtGkDe0s4SXSQ32RiqW5J6pRuvusNAOEaj/9eilR/RrgzoSaMw13a?=
 =?us-ascii?Q?lVG1pG3Cik/wEA5A0A+/LdDlLYpm+PhUS6m197OC7WMbHEAOwnfIpBV+P52H?=
 =?us-ascii?Q?VHWZozWHrgUaekTICTOfsISBgVb0ReLbnkSBJBSz9bv9emMXnwGlEp7R/zqS?=
 =?us-ascii?Q?uzCt90hSenWyKA0fzQRObECfP7WCJoIa7rmOga41FKow8NnRP96pZSaUTy6M?=
 =?us-ascii?Q?uam775VU3WkELLsdFY+9jBSgJ8kbTX39Of+533A7U2XoQB5osNhid2vr2b9M?=
 =?us-ascii?Q?U3OPcgsVutAVcGSrG4i5qjq+Rin1GgaGXspSlNNJT0aq4oaUlS+jD++RHl5G?=
 =?us-ascii?Q?y0xHFt3JSYv7NlphGIyojoA0yT3F6q1ZnmYLqQcfRyRlxpyfE4gw51I0lYSB?=
 =?us-ascii?Q?73ZlmR7Zn18YJ7DWNyc8GFPUmvi1DycgMIQ46kFLQ3Bkc4F62vlPBCRWiHFH?=
 =?us-ascii?Q?ApZHqiyWsH1v0SOtpNt3cnuDanOuDwFJKuZ8/Z3SmSHsVDV79BXl1XfsdOWv?=
 =?us-ascii?Q?QlDZbtSzudW3eyzKQR9zgZ+7MrHEJUloka1HWYWuOlKfasEVPIaakTtBHnJB?=
 =?us-ascii?Q?FPGsYiMJ2VaL0nswMhebqhiiuVrsMRg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf498bb-379c-479e-f109-08da4b8ea7cf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:10.0614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KV9AV+gXBzV+qwL/AKE5kwI6XZzB5kYGqRSYqRK73SNaio+mjbknywP4X/P5Pcbf6pG5Bj4yjUejTJYerCISO5mbycWH+WHi6EZR62LHxqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: azjaO-km6C1tDZ6opSyqhWZKukgcGZla
X-Proofpoint-ORIG-GUID: azjaO-km6C1tDZ6opSyqhWZKukgcGZla
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[dchinner: forward ported and cleaned up]
[achender: rebased and added parent pointer attribute to
           compatible attributes mask]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 14 +++++++++-----
 fs/xfs/libxfs/xfs_fs.h     |  1 +
 fs/xfs/libxfs/xfs_sb.c     |  2 ++
 fs/xfs/xfs_super.c         |  4 ++++
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 96976497306c..e85d6b643622 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -83,6 +83,7 @@ struct xfs_ifork;
 #define	XFS_SB_VERSION2_OKBITS		\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
+	 XFS_SB_VERSION2_PARENTBIT	| \
 	 XFS_SB_VERSION2_PROJID32BIT	| \
 	 XFS_SB_VERSION2_FTYPE)
 
@@ -353,11 +354,13 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 4)		/* parent inode ptr */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
+		 XFS_SB_FEAT_RO_COMPAT_PARENT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -392,7 +395,8 @@ xfs_sb_has_incompat_feature(
 
 static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
 {
-	return false; /* We'll enable this at the end of the set */
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_PARENT));
 }
 
 #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
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
index a20cade590e9..d90b05456dba 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1187,6 +1187,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if(xfs_sb_version_hasparent(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a6e7b4176faf..cbb492fea4a5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1655,6 +1655,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
 
+	if (xfs_sb_version_hasparent(&mp->m_sb))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.25.1

