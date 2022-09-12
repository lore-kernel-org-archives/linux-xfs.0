Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5DEECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiILN3S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiILN3Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B94430562
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEgxx009245;
        Mon, 12 Sep 2022 13:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=07HYa7YdgXCfB5rxK3fwxhNWlAoNx7Oz71rmCyLxGtM=;
 b=wN82KHxWoCKYlS2JZ4evB+gMQ4gogdZp2G/3MzeachuVTR8NfK4Lx5kI+uecuVLxVQHB
 QxsvKzC1ElZJN3ZehvwcMgjlk6k8hGsRMBECHfSdbrOr4iaynb7t4qEDmfhF8GUQt4Tn
 s3Rtw+h8D6RP1IyxnjYCJ99gcouH5N+rYCV48BcirxW4tC/jn8ZeTJDXHz/SUZ4fkc14
 56OvtSammqeyxgdauLWa28II9VKfQyE4dKdTBY2ijtN27FbRe0dOTYrjAXWk8eyJWdbe
 vd8cUFcg/NkyVuIZzum/jzTJSuA1+5vq4QYdkKtUTlQzr2I4ZkcNTFyHt21wdAorkS4T 7A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgk4tbeq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgZE025135;
        Mon, 12 Sep 2022 13:29:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12a7vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZlMgz9/0Z+WEHnQloQB5NYMvMQifb00GjK1Lq1Lm6n7sJoKUPg7WzRXAmm0KfAgX2p6EgSsKuteT21ti2d/MN75xuw/BdP00FHhnrn8xe8juiPcXWNbft2W2Xnm96D5gODMcY0hEPZvczlZXCHkbxXocE9Ad9OtTqo9D1PMTngttq4SEN0rEuFTMHNJ6ex1G19Ja8AUqsl9u+RMPpd8BDpxtiWJr9VNNTqSZc65R81N7VSn+KYoDZlYKVzhlgr2ijjw3MFItZ+hoG8jfCEzkpTXAO5CDT+TxnZdnq3pFkjzHILjzQJc9WSOLuaTBALKRDS4hAFxawnQItebED67fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07HYa7YdgXCfB5rxK3fwxhNWlAoNx7Oz71rmCyLxGtM=;
 b=mqPC5GuiaMv0+P/HUaR0MxWxs/Yb6/N8O3RLt7cfqkZXvT6vV4SjsnZsr5KbIXZgLh9XS01GBqApAE96L8Us05qNK9Q/i9/H1m3jT+w8/v8ZTJ2YpcNHkkpHKi08gYuRcOXDGurxarAmhgn6wEAf9L8d37gQheKwsUYUDzlQj/F5DNPfsrdUcuoVHJer6KHH4jyUQ2fs10VXewGkYmYXdXeGHmm5jN/r8XrGlhuSAFFFZ9J56pP6LUxGLrY9keNInxsrhKuOt4nzAkXmGDyGfkE/HUbMJJRs8U6UIdoFS23xVnSJz6nxfOQ80hqH7EQT0k54L5koj2dRkIkPRP8vCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07HYa7YdgXCfB5rxK3fwxhNWlAoNx7Oz71rmCyLxGtM=;
 b=LF0FxFZVO1/nW6frI/Z+cr8vhzpt84lNSMtKVtCC+9n0GyGhWPY1KKAohlzRLVQM3dhJexPJtDA7Wj0Eko2kdO+iIthiwlWravM6p7P7ljGWAv3/FyqOo4O69/fQawYHFh1yCZWWPO/FlW3V7FJJiTr4gfHWGAG+n7eCKlYzUWc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:08 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 11/18] xfs: constify the buffer pointer arguments to error functions
Date:   Mon, 12 Sep 2022 18:57:35 +0530
Message-Id: <20220912132742.1793276-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:194::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: ebf2ff84-756e-4471-3b04-08da94c2c55a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /15/8hu0fMZff7xNaq3hjeQhsZDx1LDQ4/AtFIPasMMOqpy6Mqodsgn8/pfRbghdl9HqiZ44eomGzgsoFh8v9Zk5GDUEyC26B1Ykpti6UVCbJJA4tH/ERg3IAxIg3cZ1sIRfqESwPOFZLjZKYIYCuJJa1K+dos5XXzlfCYtSIJkhSEwx5XYimUQv8J/a3xXW8U2Ab6PrNjREnv8eMGcR4TYwdbqmFk86OtXMzICaCHHJ5Md3kRIMRLYLMpRA/DI0I/eBOplXPRij56iB0/6aU+f0W3YFz932HOuk06J2Cu2ZxxqMt9WbU/BVq2wgZV60O7dDWn2Z2qB0GYffPUQhuGvgWVueuq+0XLxGVcckh+KOEts+1t+VPviBmxeDJvsRd5Ig2MO/dS43Y3/nmhjDQHn9xhRrZpQYDa9bMCmlCzLuaof+WHLlD7jChA84c3Bl5YDxDW2pcjfZTch+mIZCCD53qd99G/OC7WBpuoH5UyXTx4spzlk70I3dMfVmXzsaseR/nJQEUqWTHueuQY/a+LxZ7wNSA7caRk1nHRZJtHDcaA5lXKKFm00669YRToeaX5LpujOMKdt0nGCVyg6hEd064i0/TOxjYXj+Zg4YoiIRKmsvUghOBYl3OqLH0+ZtRNp6Goxo+Jy3rjl0wejDZGP0ivBXS70WZqJNDdN31kHmSS+e9m1IXRFNrE3PB57cbai5/JgbePBw+ErqqDpfQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(6916009)(38100700002)(6512007)(2906002)(5660300002)(8936002)(66946007)(66476007)(66556008)(8676002)(4326008)(186003)(6506007)(2616005)(1076003)(478600001)(26005)(83380400001)(41300700001)(6666004)(6486002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bViBvVrBEYIAO8z0N54SVcfWqRNY9AJLXuObZ69psVVshaDK0GYmC2Xpv/q+?=
 =?us-ascii?Q?i02Qqa5izbsSzJQPHZ+jwJJrJs3/jYKYX8ergSPmgRkkPnIMNeLdFiiDoLIW?=
 =?us-ascii?Q?E5num3aSIN5T1b8QSdUc/kIqG9041F97+qwYp9Pe+WwDMcBiEEs2BHtfntTj?=
 =?us-ascii?Q?Pyi5Kw5TFvU+vGXaXP5yMbzIMHQCxzPwWu7ZyqBtZgxpFNWnuvH9OyZSMBBD?=
 =?us-ascii?Q?e4132q1Y2ArvSpn8N+OVA6qb0Mf47nvZ86UBzfjYAcQVk95VsBqfdJUHqkct?=
 =?us-ascii?Q?OXbcIamrE9bsFZXIMrtPZACeZlRvt1zI6yk0xCmoMpZsb+udjGCjLKQCOyjV?=
 =?us-ascii?Q?a4ECUW4JryaTWRPMW7ZPmRdy6UjEtE8m+36eJ89EZNoU0bolJ8KlyA8mgvl5?=
 =?us-ascii?Q?PQCKO0gW8UTeASo6aVEu4KNclf1gmWGS8GIMCXyBOZA3K7Ylp8d1MYmUi4hn?=
 =?us-ascii?Q?4ZuqpsKizbzZV2S1z0oCQNkSz9rXib7Hxdse0pRkbEIrDq5To5bVsSyvVTDg?=
 =?us-ascii?Q?UDYqoqyoUE3VeDqrwaWd4gGvOtY7jEVBzHmCr+95NgwxcTXzS9FLS5Dl3n4y?=
 =?us-ascii?Q?XThg6fXNk/fabyiwWpdBD0foObRFpbA2T9Wk8rd8QXBLSAx3RirCLkTA96se?=
 =?us-ascii?Q?ny11RJUAt3dzhyrkAHQUlK/fNN/0CCLcG8B10OmU3HgLYO5f73nRjai5IN09?=
 =?us-ascii?Q?OA3rlCMRaHwagx95vbFB2jSfQeVgAwjILjUhJL8I2abGj1CArSUyLLQrkq14?=
 =?us-ascii?Q?HbLC8yfgJwddgAk1vaTd22fcCcftCTTwOzGePELpK2YvWMzAdvzY0Jl5oCXw?=
 =?us-ascii?Q?QMYt+fH0ndorwKhNEiDOpaiFclaeDRVhYdXPFVCknzFcPdBkTXL4Vzyv6jvC?=
 =?us-ascii?Q?uLVumXw+V6v80jBCn4mDvIu2uOTEfPm6+ENro62GtqZcjSuwinjYqlN+MDo/?=
 =?us-ascii?Q?fsRPoN6smRE5VRJrH70QXBepdtlXryFfVGmy6oKNt3fZUMcJBLnzkgjaDvwG?=
 =?us-ascii?Q?JR49PY9xpcmm0AIbS3sNejWjaTH/RMbZEPz8PVVJPac4yVRF/oRx6LSIVsMw?=
 =?us-ascii?Q?JjWeXC9UbFWTzsA97QTE6tbiLvF4z6/MxrlMDq62G08U25PKxjzsfnusIgPw?=
 =?us-ascii?Q?BxTfsSyG/U+OT3IPvBEDnbYnmo6Qe87tLxfRt/r0QiZ9STj0rw79W38tyoX5?=
 =?us-ascii?Q?q7b/Jbr59miMazlhl6tvz5RZ+f9SXEjsZYbdHmk3VGNQ1UmAbXBWuD6DIYdk?=
 =?us-ascii?Q?YRH+m5GMC+ne/8MZ75moND6D/7YDQdZOf2ppX/UsEd2d3L5dxJ3umZWfmJAo?=
 =?us-ascii?Q?Y4khgCEnGL0BrtEYqM102KW1k7t755MiF8gsJxz75KIi9smxUYFDfeGElpMn?=
 =?us-ascii?Q?m0vgDPIIu+7nIcE0FVGt0n8mp9v3KlznDU+WzRwYPXM/XWBpKAR4BgcggUhx?=
 =?us-ascii?Q?k8NkgDL33a34eso423mL8+grw53iyyqdokirre5LyEsNikYodRYJ8jJFp+yE?=
 =?us-ascii?Q?q6VP0w0/IzlFVU6nJghk/Kiiyjr8mH2OXuIsQxAnI8Hz3H6OHa6+LQpNdpkG?=
 =?us-ascii?Q?y5XnUOs8KHX5EhxRF/kNRc4+l8KzVayhFKjJoOdDwFNvD+9FwQsCte32Ueke?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf2ff84-756e-4471-3b04-08da94c2c55a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:08.5062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cs5jvvW1ZNkETIGTaqaCc0ctfEEokQ+cciHleOmO2tXURSywNB+EI87eBGMzq6C4Oq1+t8wS+hLTEh7haoY7mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-ORIG-GUID: EWJISKORh7Uq_Gr18fbJhs9zROVG3PoR
X-Proofpoint-GUID: EWJISKORh7Uq_Gr18fbJhs9zROVG3PoR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d243b89a611e83dc97ce7102419360677a664076 upstream.

Some of the xfs error message functions take a pointer to a buffer that
will be dumped to the system log.  The logging functions don't change
the contents, so constify all the parameters.  This enables the next
patch to ensure that we log bad metadata when we encounter it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_error.c   | 6 +++---
 fs/xfs/xfs_error.h   | 6 +++---
 fs/xfs/xfs_message.c | 2 +-
 fs/xfs/xfs_message.h | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 849fd4476950..0b156cc88108 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -329,7 +329,7 @@ xfs_corruption_error(
 	const char		*tag,
 	int			level,
 	struct xfs_mount	*mp,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsize,
 	const char		*filename,
 	int			linenum,
@@ -350,7 +350,7 @@ xfs_buf_verifier_error(
 	struct xfs_buf		*bp,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
@@ -402,7 +402,7 @@ xfs_inode_verifier_error(
 	struct xfs_inode	*ip,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 602aa7d62b66..e6a22cfb542f 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -12,16 +12,16 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_corruption_error(const char *tag, int level,
-			struct xfs_mount *mp, void *buf, size_t bufsize,
+			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
 extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9804efe525a9..c57e8ad39712 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -105,7 +105,7 @@ assfail(char *expr, char *file, int line)
 }
 
 void
-xfs_hex_dump(void *p, int length)
+xfs_hex_dump(const void *p, int length)
 {
 	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
 }
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 34447dca97d1..7f040b04b739 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -60,6 +60,6 @@ do {									\
 extern void assfail(char *expr, char *f, int l);
 extern void asswarn(char *expr, char *f, int l);
 
-extern void xfs_hex_dump(void *p, int length);
+extern void xfs_hex_dump(const void *p, int length);
 
 #endif	/* __XFS_MESSAGE_H */
-- 
2.35.1

