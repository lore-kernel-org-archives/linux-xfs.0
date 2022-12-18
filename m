Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046F9C3DA7B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiLRKDv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiLRKDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE716575
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:46 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI7TTxq016354
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=GNgaV7JWpSSDmwJUzqf9/qHqiLneHt6SZLDisea9h4A=;
 b=cC5Px+3NVlR2mxEgA3BZyRwh9j9nXDPkk3JhCur8W796Md2ID/ZSxnANDzR7IS1e6Wql
 YlE8Kt74GyB6xbJW+FUe/BMdOV/7hAogR44DVFIwCqSSb6htVqyepwf+pyflCI3Ia2IQ
 lpEzq79M3f7G7zxm87g6v+KrsNZN/34DSEbKRsTXk/wj3p+A8j1yH3/2KrhPVGbZlFtL
 XpINX0EqAZkM4xu9yfqyrGmQDR0m+IBQOXDRpOYX3UhP9C8cyyj4YBF2L8zYNu8pZndZ
 aayq0/xMjl8mkCa+9pAiRrvW92YysBdh/j+doijRQ7WdsLWaa2rpbEhDndnkHOgnDQV0 CQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tms9bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8UK3W006898
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478n3x9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KC/NaoFJ1uUBDkYXsbhhQaijcM/9+Sl9cuhmJa1F4SdXzqzDn5OLSmHvN2dp+UOSIvrE6FKzoq9mXqH4Ti7Td2MJCJoj+FYybcVFXBxm++frg/cORv7NNtqe1wSKdfxrLIJLJ2hvPvYIWCIeO3frRt5Lzf1LLFOgZSCsjgd5Mb9NLuko4SW25bVFERjdev+U8AaoNwIPHtjTCzGqlwssL33lTvLR9AiZd8YqiekofilxQiMYCFabW4zFCPUBBuF2cvKh1bM4omzp5k0CEQ8R7QUlAUc94hepic6aDWGMdRCix28HVCQTdHt/gs1pnNcmxfYdL+L0QUlrOrzjtktxRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNgaV7JWpSSDmwJUzqf9/qHqiLneHt6SZLDisea9h4A=;
 b=IkcQDWKz5NAzsojKhaCsbSPHCvP2zUkO/mRao5SO/GJU4Ihwg4J9nt2QcBGNVsHS4Ow09yQ6tLK4oXmDgjQtJiaiD8jZc3oLdpQSDPXZ8gCZ8EddNtCa0LDA5jgnFJUn6Z4X9I5fp8pfP++D1AuLDcE4kTvEbvDF1b917DLneff7JUeI6oLFejxFuHgGJt8CN1dcJ8siyCFh7oKpQ3K0C9EEpDcAPJejKIA4th86luOtqCm+6N3tYZjMjHWxUpHmOCrbr58N23zt0vWsPbccbrjigiYdfJ0RSXcw8NDi1byOFE31JyjLvzSk2YebgIg2e23IWjjKjQuB6ubt2UEW5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNgaV7JWpSSDmwJUzqf9/qHqiLneHt6SZLDisea9h4A=;
 b=DmkJxxbP15tVRLxEu5dwaW+ZpvDrCQm7F8YB7BYMSAK4aQZicT2ygD4/Mbc3HEK3iIgAFe/EDHtr6wXxSb7OCzmNzmJ0KN1fcmiOylJug1GrUsRIygx/fb8Qz1XupqLAkEmHuMmnvd4mCg2VXmHVIY8/roedReTJrNN4u+WAsX8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:43 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 23/27] xfs: Add helper function xfs_attr_list_context_init
Date:   Sun, 18 Dec 2022 03:03:02 -0700
Message-Id: <20221218100306.76408-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: cde44a2d-3594-4cc3-d7ed-08dae0df24fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LFA4/OmIqcsVcFvOSZucqeH0SL9W3YenzaTV8m+eQzJhURpuVvkc79jn4GYYTUEbyj9Ci+luU6gZhxf7ttz61mBMDOwDCdFoTBOdmiX3LPhz67+2mHtJnsGaDZCCNdZ1Jc622AOh1OxujDbpZe+G6e4x7eNreijqG7wxMwLckK6kZKjf2qZ6gaIWMco2Jxmq1e+QBiahNlnXNby1eFRlZ/ZbKR6db/9Aud23zyQ/FD9lY7zdCK9p8T3yGB6oXvz0LsrTUXW59hMB/nLUskKBCNUKE6Xzxa5yZr6za2nfLjo/C0R7swU6RNdCaiIqXeAjZmAdCypwkq+xvCcXKPfrCBvsiIPQXrI0otf+AwlNBXy2xwK54+M5Cta7hangvPT6uMG0EA0xZZxsVczhUo7dGq3DOghjE6uNOA4f1+/lpLNRhEOqU0/yuv3lC/C/pyOsZtbinM90tb/zRIK6yOwzi0N9DR4abU0pARycbrbE6ljQCq94DtFnt201rhfP6SZ9bAabN+n99tgI1n4rz5w/qhWR7QZsjjjeSPFoEZC07GG9UotE2+kdiSUE/0duGKLhLgZGsVnBj9tfVSM+m6UnrVBwX4c5BXNbSM3b4DtwhQzi9DkomnvfP76SLJ72ENFOWl0JtS7s6xN+ONff1eXhYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9LnjMwG4y+PhieWj2MNXcHJbR4WAuNDXyA2vXyK1SAM2TJIpM6skGeikxq1D?=
 =?us-ascii?Q?uuQFmxkWrRD9iIyXwgbcBAcsOjpXz5l4apXm/s7tftsq8Z/PRgqTLwvTDk0s?=
 =?us-ascii?Q?9FC0v30AVtZQoEmyEaoLMpybRXqWWeN3XHadRkuPHgPNtUEZgc/26e3iQ23P?=
 =?us-ascii?Q?+r2DOju4mxKm3w0MePVwyU+LI+pszi3Zad3rXyrxPXudehgAdn097JEnVs6C?=
 =?us-ascii?Q?pDGXFvfOGjZ17ePlgUh2WZMe6bFzTLikRr8Q6NqSZiIOBAAlpHGo8eywhCLp?=
 =?us-ascii?Q?XUYPDkjfURzJPrZc9m5UmEh6zOIpCX70QW44mshZG/lHf2pCRLXfiye6KGrO?=
 =?us-ascii?Q?HSzC6ZotL5sHR3mp3HrgZswcr/eON1xmmrRaP18/a8LZB5JcnVdTolQxmnCQ?=
 =?us-ascii?Q?qB3DH0Noh9t41zMqcMSWeD5Ib29DMWboQwlVg74a0nKmq3Qyws4i/hxg33Sq?=
 =?us-ascii?Q?LeQt7P/L1jFmbUI8SUnffikqZOBDJZFqlv81R28c88KECMgvmCxVAdAL7rvk?=
 =?us-ascii?Q?cBKSNo5JZYibBeRSHHxZL8aeZAGAg0At1im4PlHy/GIwINcFKHwj8gFtIbM0?=
 =?us-ascii?Q?qXXdNhTKPAro8FwwMbJxlNgyjVOSXZD+yjl/G8h0AOL0r3cbgiSkPqaDVcrE?=
 =?us-ascii?Q?dUTeUA8DgB+RbjK8pwT5nEzmnIDAIP9hxH/MJztgK60HgKd4bD7cmijDh4x0?=
 =?us-ascii?Q?j7wlJ0QuUuTVMwS3VxOcOhTR0PHuBYdLmxH+azJtd8ahIB9vMoBZLnGKgTi+?=
 =?us-ascii?Q?BA6rKGxIcympzHgQShRa/NQSALr5rY1es8HSXh6anZYdlyilEN9X07GpF7+p?=
 =?us-ascii?Q?i+Yk7rCrS49h5hjmm3pCgT0J2SilWnt3z8vBasS7S58+C3+o9kQ9a+d+ad0c?=
 =?us-ascii?Q?4Ealq+X6CQSlKpdlQWnU9JPT5M2nWmpkV1SiGuWhqqnNBMj59yBgpn241bJl?=
 =?us-ascii?Q?YzNcEkZQh3vYiUhMUrECYAgvzkRjs6x8xcqb+nBoUiW/6zeV1c9hLxyTCqG3?=
 =?us-ascii?Q?yjUqofiTXODPUmOB7vvaaRf5aV1UoePb3/n/l5XdvmZOdkDWZXaZYKayMYtO?=
 =?us-ascii?Q?N+Gx9AI4h4h6uOfJQfYq/dSErWI1a7KE+wGoDjH4G0b7jkCpy1JrzWe0T5FR?=
 =?us-ascii?Q?+aZSNS0vQAxCxXvM2eCSAMSqo5B7O8ZXwHxHEs0Eaw8VSalaSgkmarmOMrfo?=
 =?us-ascii?Q?mSVN8Pm7J63ypn0FDRu34ODi5B8BDpspfdgfPmZgf8x79FsykQjd6hHPGYL/?=
 =?us-ascii?Q?R4XWU/UmIZC/PldGM1l2SI5zyQKnue/e5Hq1CdWTS0Yhamw7UFybheCQi5e/?=
 =?us-ascii?Q?HH0fiohSW7NqXJMEE+r2UAOsH06ijOyxmzeAGcSAL3yQFyZDZJnWM2jbXGM4?=
 =?us-ascii?Q?eMthkOHT+lOLdkmzvWLqBsbh4xzYASKC9RrJ0gKBPWO2H3I3dQ7ddL4/kpvS?=
 =?us-ascii?Q?iYfsiIaukR08TEHqQahwpCHFLzxelrC3GMVVW1jnkyyqRFPNiOS3SYk3pUxG?=
 =?us-ascii?Q?1LfvOWbZsCHfhU95/tG3KlLDJp8UzEBXxDjZny/SCK2tSVFP2byxq5EPmG3T?=
 =?us-ascii?Q?Ks4lZEBrhf0m+DUqfGSs2o65SnKZBZLiG0BrSeOJRkgD4+8NGAnILa0LjgPK?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde44a2d-3594-4cc3-d7ed-08dae0df24fe
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:43.0137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKZ7VBmxFyo9ylv6n/MHqfQLew+ceO0GI/5+g480rDWUK9kI6hj2hV/hJ05zenzM9XShCVZ/pwPQKQ2wyFV/XRoxDFIJqJPihI1qrETpOi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: s6Ha_gnmySNbBVOL2FuiosiiDajaOEiA
X-Proofpoint-GUID: s6Ha_gnmySNbBVOL2FuiosiiDajaOEiA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h |  2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 595a5bcf46b9..9c09d32a6c9e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 13f1b2add390..01faef8ad1fe 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

