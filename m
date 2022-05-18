Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F2BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiERAMv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiERAMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3872B49F11
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKb04d008004
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=StN2S1R96t/opID45ShRFjfTkZMAOuSfKFoC3sthyYs=;
 b=oOlLwlkzj5oJhRveoSIuHlKS5OyjVtyu5sE8BLptpsDiL3a1oJfZy98fq9d+d3RKrpA/
 /TM4g6SRs5iA8NrcGbrHS2JkrJZlFOgfKJ+3DYQ4sGsHDi5/XeN25Cegg+6ugjOnCUgc
 7mCUbQEpnnKy7J78UbGAim4Lc26bmepLyWo3Ix1j2dOvpRUPU40ZJb9m0L5j8InEfWp1
 UcXU5wXO5Ps9dR08+8HBsOchpMixmValiYshgIYDJAYFAF/hyXJQOu4R/C0dsqM5iSid
 KyiMJqe1G9Pkp7VhzYvykzDWagHMxIlv4Tw0dxaqgzGWEiDjuegWPMJUfrSOUkvkv4fg vQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc7m36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1OC021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNNJrkUypH01GQt36shLacXMk1BPhJS4hlB6QEs88kfcSNksM/ano/Lime5cE+m5/nzLumxShQBuGOK0cmXJ/eSTCVR37VHgXgZ4rbrdGyM4GMA/UiZM9czK8rwHt16luSLVb8DXn3j4mmJ4BTCUpyDPSyv8dd8R013HzirbxK7swdt54FsQcnR3KOFFTH1v9zGl+cRJAzwcxXUx6eefzcSkD4SFpBD9cmK37vZjRmSa/pYb/gpNqTldrU+fSYq1N2uoC/Y9skjOibLnhE+mQJBUkkZWSYZDxw7ZBE4VR62USGZa+yxuNhtzflG1AIKdbq+1O9n7vmIAv6djptJPQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StN2S1R96t/opID45ShRFjfTkZMAOuSfKFoC3sthyYs=;
 b=fHUHy0jUlF8Go+hXfFc921BHcdjuuRzQevetNFBmxyXfnBEC0rGSxaH9rbeuS2slmAYL5HRB5XKurU/cmfLK8qmRfihLYsTLD9IGScvfS9/0jdXgcytMDgh84cyLGO9LqwcZzHFbLz+0vWC1FH2OjlFQ95x0/KF58BQcWdI11lSWxqkkIwXKR1doQuvYWFnjP4EN/NVlL71Yhtx6A2ZzwtM56X2WgvSzA27McI6n0PH9sdMmxu+A4n07fsuKIf13MG/2eK8OmUuXREDKdx6kRTuSoIVNhUfNFu12KS2Zj0RKFmRx4WboQF+u6mPLG8H3hT8SjG3faeOxfnKW45Agdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StN2S1R96t/opID45ShRFjfTkZMAOuSfKFoC3sthyYs=;
 b=mVaiLc2pUJVBiVxZdslEp3yNUdKtJJyDL9bWDA+NjBYg2rnBN3Qrk6pq6wMUvhaPccnRsdLxY/QMng/MJD4qq7F/E6sAA8eGwnd3QERfNJeFfuVGkywCZKQn314do2PZxI8IbFiU/vBso5u351AvaqeeL3j+L6RJHZoBC/UQ8SI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:37 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/18] xfsprogs: Set up infrastructure for log attribute replay
Date:   Tue, 17 May 2022 17:12:16 -0700
Message-Id: <20220518001227.1779324-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1985b981-b392-4421-f448-08da38631d2e
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528180DBEA19722F331D76995D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wR045C/XK/QnbmBwEYqm5yUPm5tykomumbuj/tCTE9lOs9ttNQQ6gOdAEGu+zv96Si0+3rLXAKjlKWRRsZ0/qZ2N4kWW/60LhtlNFAhU/t5hk8lIw5/yyFRQed6a1pf0qP0XF2Cd8RCkTD8ULzG/7q3vomKOv5BxqdtmiR2CEq7WXE5xSLMOX1WYq9QFmjOT3OPMiKB81ParKi6q03tCCjDkuVKyj/E8f3ukbeZICQ0Al51i1gMzrjg+a2iWBEMCYtMBTRaQIIsA5u/PWRKtJJPHUE+yrs0f6rOkilJYWyFyLm9X4OV/QZRU6McD733Kn/fwwyEq/rfYNEeSxA+ivadM8oR3j7DyLd/L620PaIsapn+XzBevR027alZl6phQ0j8+k6HGqhT5GdfTL+c7rARaqhq/76fgSEG0s/GJcJfeLdctIw/Tt0HXHMJaKMz6W5x/PlP2IzRaxHvHtTLkEkPMBLACGOUHzFIug5mgpzPo/Bkh03JtvBYXcdXMPFId7IIJIaD6kaVBgL1QX01Jalqg4QsK46OaVZAZdSsotF+VPP981xanpgzi9qP3wKgVrsbvXCiPQAYBxr8l1vkgNMRQteVnxoXJ/xTX2Z7W1rDnmRfvmC2NH8j9SDBvUhioM12VbkXfLebobDKbDmj74K8nHRk1n+7GyygEgxYo18pxXbpWOWkgv58uTmKqOzXPuGsnBSFsribPhydaoAW2oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RQMwWufHapOisJYRSREda05UzfrPFNPVG8GS84Snwe8RcdiruBcY1id11zMr?=
 =?us-ascii?Q?tZTtDFGR+OV7IdrWFF9OibM8Vra/RYaHqjnf6c7phSorl6z7k+wlj5KJD8qb?=
 =?us-ascii?Q?H+mxI4Vj4faV+aFGXSnHS6MhjvcvAbzjbuYKYwqHHbSxGD1vJ+78LHHps+8c?=
 =?us-ascii?Q?pZykprYpfyVFTRGkKfcwEvnObb1ZpQ2Fh41xG1xDk044LziyoeQ+Y84cj3Bz?=
 =?us-ascii?Q?k894bEzkk3C+2KDQy7Y+7z7xTnJT2M4B3fQIHZ/RCrF+94JAA0ZLJvEqK3Eb?=
 =?us-ascii?Q?n2Hwiil4L19SRBls6M2QHz5qxWYpwe+y17qduzbfoccJmPAVNpktzMv0FWvw?=
 =?us-ascii?Q?duEXeMUsv5+2qVYvSt6NI0BNjqkHA8/6BADJ6ol2KZxMMcQbvX152N1RpxY1?=
 =?us-ascii?Q?IUnGLnQtrJQ6VxtKU+YQv/oXbINdzpjT6r+R4WupF58Us45u5+9LCnyZZ5ao?=
 =?us-ascii?Q?D6/sgfyfASsoJIFETg8sbiZ2F6+1y2hqNJiAwueD3Me8cR0AkShLpcBkvlWU?=
 =?us-ascii?Q?PsZgSBBApVzebUyTvKX4NOZe/Zu4lTfHzt+F3ZWrsRv4cVCzKSFQbUVLvcWg?=
 =?us-ascii?Q?Pl6AIij0QGatodEmTRSrDlWozhkTO48zngdtuT2+Y7DrI//3swz/mjZ8kF3r?=
 =?us-ascii?Q?9oBi7w2yfGPFgMTg7VS1cbPq2BeBtOXVAl7T2jJVru9KM+4AO15UfEZjm4/v?=
 =?us-ascii?Q?37FpyJlJ92T0CUjncoQ3A8Z2bs+DeznmrDJ2qzYm3QIGtK6gSg1ptrXvhjGM?=
 =?us-ascii?Q?vq+wzlDsF7arqCzoj5YlERmwPUNtPFcfwgldw+05AO79YE+I9dlyK9gz1x4d?=
 =?us-ascii?Q?O6IlwsK7X5ikXinmBXxN4LJ0qv5r0sBU0KdhL+284BEzuGIatExUsSZBWoHb?=
 =?us-ascii?Q?1Xmr5i8jDjuyQYr+BaRBgvNkJIv4lm0UxmyTWzTci3tUwl7/sDOxRzxVx98g?=
 =?us-ascii?Q?Gvpv1tdX5uu03B8RihRVyGYQSHP8p/m7vqH5PsDsPrZHBtKKA3cID4j6/XcX?=
 =?us-ascii?Q?3ZLbJVMKsXimwhcFJ8u1QAcNZKYCT3NtHyLHWA82+/6CeihPc0Ncnu9YRwBC?=
 =?us-ascii?Q?y9sLYCw4iHTSBnkbyR0Z+r1YpzvZtCbjyown3Vid1BZS6A8C9acmSnzvTBCu?=
 =?us-ascii?Q?NJIU3CxUSk4jCpgQDhricFy/mTWAr/0cF7zJ9nmzOwFk2tXOPQRuk5kuWf99?=
 =?us-ascii?Q?UcYaXzI7jjpNZvt/L/Tc93OIo5sgvLzzq8j3hE7tveo2s7m9gjT6VZ8azblQ?=
 =?us-ascii?Q?U5QKofRplsjr1oEVvVOyb/WyKNuS2NkNoFb2kxqTpb4vynObYGt6sg0h81C0?=
 =?us-ascii?Q?LVsymLiTFePvhVxHFNOlKuel66IBVC0XPBukx73McZwx8GqDmJ3zOpwY59Yi?=
 =?us-ascii?Q?M6MYj9sen40FfedWda/tVUjT4zrSjfsVWcKJeOa0xF6ICuy30pkedNrpBpAQ?=
 =?us-ascii?Q?HOj7pb9Gt1RSuF2mRo5Ns61bBsHvTGcujmMRM8PpwY01clqzKyhRxF8P5j9H?=
 =?us-ascii?Q?VFmh4GdssnMC157WZsBUSh1tv1o9GmbgRuMF7ifPFFv+K64B3TG3e9to9nUD?=
 =?us-ascii?Q?r7h2vEo1UfAgtf4gHXODMCjIlRUV43XmV8OO2BQT+aWUFy3DXlS0hJRzHoyn?=
 =?us-ascii?Q?RFQvg+2JX9Rr65w6LnvE3+jjArszenNv3bk6yYEt5JwoClvhEpMAEgPPvvBe?=
 =?us-ascii?Q?FpIVZdJC2VYdol7sCFRKOaN6CHmemUikAOxBNS8ID1w0iiUhI3LCAEgBcYI8?=
 =?us-ascii?Q?dW6FgbCaEsD29ylD6KuhedMOKxSo1JA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1985b981-b392-4421-f448-08da38631d2e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:37.0801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fO85+jKIQza09gN60P6VwV7XJ+93xvF4OqgWyhiw9pm3q+/ZBcA8yz6/PoOz1uDBz1qmAgFvw4X664pnwqwDvPg1WiZ36xUTU8YTjavSYmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: 7IsWuTfeiHRF97rZEhx60SoYBPUvRtFN
X-Proofpoint-ORIG-GUID: 7IsWuTfeiHRF97rZEhx60SoYBPUvRtFN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: fd920008784ead369e79c2be2f8d9cc736e306ca

Currently attributes are modified directly across one or more
transactions. But they are not logged or replayed in the event of an
error. The goal of log attr replay is to enable logging and replaying
of attribute operations using the existing delayed operations
infrastructure.  This will later enable the attributes to become part of
larger multi part operations that also must first be recorded to the
log.  This is mostly of interest in the scheme of parent pointers which
would need to maintain an attribute containing parent inode information
any time an inode is moved, created, or removed.  Parent pointers would
then be of interest to any feature that would need to quickly derive an
inode path from the mount point. Online scrub, nfs lookups and fs grow
or shrink operations are all features that could take advantage of this.

This patch adds two new log item types for setting or removing
attributes as deferred operations.  The xfs_attri_log_item will log an
intent to set or remove an attribute.  The corresponding
xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
freed once the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute name, value,
flags, inode, and an op_flag that indicates if the operations is a set
or remove.

[dchinner: added extra little bits needed for intent whiteouts]

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c     |  3 +++
 libxfs/xfs_attr.c       |  4 +---
 libxfs/xfs_attr.h       | 30 ++++++++++++++++++++++++++++
 libxfs/xfs_defer.h      |  1 +
 libxfs/xfs_log_format.h | 44 +++++++++++++++++++++++++++++++++++++++--
 5 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index bd6ace1c4e61..1337fa5fa457 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -20,6 +20,9 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b6f6e1c10da8..76895d3329f8 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -61,8 +61,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-			     struct xfs_buf **leaf_bp);
 STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
 				    struct xfs_da_state *state);
 
@@ -166,7 +164,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 5e71f719bdd5..b8897f0dd810 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -28,6 +28,11 @@ struct xfs_attr_list_context;
  */
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
+static inline bool xfs_has_larp(struct xfs_mount *mp)
+{
+	return false;
+}
+
 /*
  * Kernel-internal version of the attrlist cursor.
  */
@@ -461,6 +466,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/*
+	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
+	 */
+	struct xfs_buf		*leaf_bp;
+
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
@@ -474,6 +484,23 @@ struct xfs_delattr_context {
 	enum xfs_delattr_state  dela_state;
 };
 
+/*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_delattr_context	xattri_dac;
+
+	/*
+	 * Indicates if the attr operation is a set or a remove
+	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
+	 */
+	unsigned int			xattri_op_flags;
+
+	/* used to log this item to an intent */
+	struct list_head		xattri_list;
+};
+
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -490,10 +517,13 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+		      struct xfs_buf **leaf_bp);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 7bb8a31ad65b..c3a540345fae 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -63,6 +63,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_attr_defer_type;
 
 /*
  * Deferred operation item relogging limits.
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index b322db523d65..cb3a88d80b4a 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -114,7 +114,11 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_CUD_FORMAT	24
 #define XLOG_REG_TYPE_BUI_FORMAT	25
 #define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_MAX		26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME		29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_MAX		30
 
 /*
  * Flags to log operation header
@@ -237,6 +241,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define XFS_LI_ATTRI		0x1246	/* attr set/remove intent*/
+#define XFS_LI_ATTRD		0x1247	/* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -252,7 +258,10 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
+
 
 /*
  * Inode Log Item Format definitions.
@@ -869,4 +878,35 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+/*
+ * Flags for deferred attribute operations.
+ * Upper bits are flags, lower byte is type code
+ */
+#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
+#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
+
+/*
+ * This is the structure used to lay out an attr log item in the
+ * log.
+ */
+struct xfs_attri_log_format {
+	uint16_t	alfi_type;	/* attri log item type */
+	uint16_t	alfi_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfi_id;	/* attri identifier */
+	uint64_t	alfi_ino;	/* the inode for this attr operation */
+	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
+	uint32_t	alfi_name_len;	/* attr name length */
+	uint32_t	alfi_value_len;	/* attr value length */
+	uint32_t	alfi_attr_flags;/* attr flags */
+};
+
+struct xfs_attrd_log_format {
+	uint16_t	alfd_type;	/* attrd log item type */
+	uint16_t	alfd_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfd_alf_id;	/* id of corresponding attri */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
-- 
2.25.1

