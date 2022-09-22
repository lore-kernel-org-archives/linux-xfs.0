Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D17C6FA90
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiIVFpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIVFp1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A863786FD
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3Dw1s019736
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=LhaMbuMQgszT3tT6UsmPYKCWwZn2im9movGEwJRcPEo=;
 b=chQqlcOScNGlfZQXi5tDcsY2MzQ2JAtR+xFjgj6nNXOnUMik8MzFXW+NBO2lVBt8xUoJ
 k/vMjpF2YeiwgQOF6gLlaTFW1IMnhSOWbEa8ynjw287ogpORZVTKwLcVkGSP1hiiij9V
 Z3QhHp320v6A50EbLS4HWwdfyXbfQNrtPNQNo3atk9KOFK41DQ2Xusf8y9oFDgNC6Wo9
 ic0spO1rODBj2lMmHJ4ZRsBU9j1ecY8UWpJz2kGtn3D7w73WOa5s78krn4mb2ZxbPG6h
 XU9rpUc9TyeTlfWCnN6jdENCKjguQthuxjSxKxrTThSZW1qXEnDTb1gvc/4YT6tQRaDC pg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kvchd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M1MKG8032575
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d46ya4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkKl7n6yEnwcUTL05KWISECes3UyuHXtB6LuhyET125WWffboozqKcP33vsuk/ZAWxvqfq2zSB2yDMfKoPTAa4LJNHknn1vfXdY6fht5DU2yTOD61GwKBxX0Fl+AcZCfL+jE0s+fY3zCJh4WauH47IGlxVOWvz8z0WywX1BkU5K50nvhqSChflaSqYgepa/Ho+eRCsIA0nQo7Hvex0wwiDQriUWGOoyrgAFF6Ain+INRRqaQ5oRIhQi777OhrLgfVJ8EvzK9K3hi1TMexbEtxIZsrMX3smxu4CGwVierxJOOj4xGSaRPEPtBvRVfdGrVKlwgpbqvtDKUDZJD+Gez4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhaMbuMQgszT3tT6UsmPYKCWwZn2im9movGEwJRcPEo=;
 b=VDgrq9LBdfaMSIgXGNfwrCP8JP4C/b9Z15DAlBu9PxFbbwl2ASWAUAxOgidK7YdJFmDGU9Z87PAShOkSWQYE7O3P+b5X58H28tLk5+lb+EmsIoWuh9o35j3y0G71WiYFIeK830c0pUIkSacNv+i0FNh2admMSPXFBYmW12rc+qs+q2xbF8MttM6S1lHWBqwXKKZsD6Rq1pwym0/yA6T3hgro3FmZjTJivvbcbASK/KFEccAgEWb6D/ahvW5j9StX0XMg+C+Q2aDhauXxRXnUXFmI5zhLgRDyRDKtpwg5z1Sy6P35E0CwRGMuOHQeJLN7rYx65UKP46nl2QDOTRVcrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhaMbuMQgszT3tT6UsmPYKCWwZn2im9movGEwJRcPEo=;
 b=lzK4NDpODxoZjrl4x+RdlJUpXd6GQt15Sh/+ib4rkVUU4iarMMq47j3Pia+otyqcoga+/+pLGW2y9xcVs8Jah7aBvB6BzXVRHj8/jD3dnOqNEraZPHCEFWlUhzLaFKVSqCsPnO5bfjo7J6NaxTn5Lr3nY9iOFb0480C3ZVhc2XY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:21 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 14/26] xfs: parent pointer attribute creation
Date:   Wed, 21 Sep 2022 22:44:46 -0700
Message-Id: <20220922054458.40826-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0178.namprd05.prod.outlook.com
 (2603:10b6:a03:339::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: e7ece623-a6b4-496f-7a7b-08da9c5da32b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c+i88kpMsodwWKfdRxy/43mBqbs4Y/wbf/l+2T2kfeibmtW+N3IThsCyARcyvhqbBO3N9yt2zGRb20ldV5RnjLFCC0TV0DPPE3ycbvSymUs0cLJjXQWZ4jB4DZj2vVpydWJlpF8axfTmBI6Mfna1J+IffXSJcJEYrXTsg0yiMgwswNFRIytX1eFcwHzznrUlFCbOF6p2KjDktgAuwvJK1VV+o/XXsBV7vRZTd67xcnFsBZ0SGnVbtVL8Y1TBL/mHUeWRcEnNZJvgkGw6iSA517LCWpzpBDd4bRSnYZNw9G8Jm8z8EdiO78NVQcsyFjVEsWqbiR+J1w9qghCBucRJMEllON2V81wkzkwB0fhCO1V/awwP0zvPmAPQnvaxvHH9eVrbNMZhRN8fzpjYqGANrDt0Q3BnLxgMAah16yh5aiLanYmnopEVvtU6LuI3dbah9Sn/WeEkujieOB/FtZc265wRr/aCGWw+TISV+EzyAej+KhVI2VUMk93mMxgDocOtmbjh177WHmeoy5QCdPfQuBmyzrLzU4CY/xSMyp8GLUU3wxV+6Lze+5iJwTBYp77tQ0+41Icb40DbpoafZLlMrIbua/mDdFJy7I8azMzko6Mfy+Wo6m9FUBNgOGn2rPwQ0chBuYWqXOqtniuOFyxOacTYvGhMfEgSqyaY8vwYrxCnfm8rjTkyFSZG5QBwnlmgtMkbxRiCXMQqQ1INshmI2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(30864003)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L/A8W3sdjtLWre7yq6Zzoz+Gesef1rj1k2RB6kTPPddYLJSinp5jgadtXia1?=
 =?us-ascii?Q?09nkltCpUDwPs5OgNWryEf7xmi0mNKJi84KNOdw7v8oFocNwvZMGxIILbjo8?=
 =?us-ascii?Q?nKpONMNwevWWIc8JBK0KdXYEBbHcOvyYaplzuSDFFfuGIFsEQ1n+qP4hxABt?=
 =?us-ascii?Q?ZHIP7lqy61w2runIMrQbDERNkCNOLc/iLC9e08TBE6d1DIXHmw1c/35Z3I5h?=
 =?us-ascii?Q?yRkp22giE4Ln1gOfdT++w1ri+gYB2cDo3IgmbCSA138RrwdFm+rEuUB2+7zW?=
 =?us-ascii?Q?jPL/1NjRAOgvouNS4on0D/1lzoxRcG7jZ8+1CUvXwGecKL0b3BUMHqo7twon?=
 =?us-ascii?Q?zgfpa0k/TGwg5hP7L0tMb3mlQQ/ck+MV7UJlXgNCvC6gvRXCquPmcZ/3VAEf?=
 =?us-ascii?Q?GJMcnV19hC62bBJjNvaS0Au8pZ/d3wiET9hzkA1K+6IBMRh92x92PsuQKjYF?=
 =?us-ascii?Q?lh+zrQFNCFDDDqiKJP5MGGQDOdqrRPK6flRUq61z00D3AahsfGZHBom3iZ/c?=
 =?us-ascii?Q?ny7MG56tt/geKzWnSQo6PFHArLrHL3xQTXIAILi15lHFCKaMliepeVPMzbv0?=
 =?us-ascii?Q?h3MWelszMxpw00Jajy383V6kodK06TtuMNvBelNmADOd9uCMuTa6LHr2x+5f?=
 =?us-ascii?Q?GOCfAGOivhz2xQsxOMsSk5NcDmcwid5+KttPgPhGUAyr3B+Aq3bL2HH84/ZL?=
 =?us-ascii?Q?msZjtz4CglA1TRS6Eb2OjYfmfcmSaCsfXpXAlPT31dhK40FKX+s+jHfIkAVd?=
 =?us-ascii?Q?vLfjV/0u4RQWOrjecdh7z9lO0lVdObLWhw5dqe05XqmI4Sm5SILibO+qVVQW?=
 =?us-ascii?Q?C0EWVodidqG6j7TRlupE8uoHoBLhiyXeX2jjdk4hXKYvlwn5uOVSNwy6QPiz?=
 =?us-ascii?Q?G/2PoEBkE++WOOeyax7auMq6CVJPIIqy3OJhQQ9R4LTqIMr4Eiarb8LY0m+f?=
 =?us-ascii?Q?Gggasucq46xLIaG3LCifpLzAnHV5otN2CjoZNWYNM0nusbzX6+zpefVCAkbQ?=
 =?us-ascii?Q?+Tqsy9TEiS4mlUW//jHjTzvG4/+PY7JRw4CsVTkDDy8ODfNVkasuWM6SxUHC?=
 =?us-ascii?Q?QfTCabQ7Kib7XxvAQ4s2smQh+I+Ngog19dxVHKxmPUfn5PaNIWRC5TAhoq6X?=
 =?us-ascii?Q?wNcdeIgDwS4ybJwNuvg2bzzUrUR/2myLdNceGiEKvhtwZ3/GeYx/GbSRpazf?=
 =?us-ascii?Q?0MOn9Wf+P3IVUEpRz+lekcB+J1gHFHeQ2fDqKX2rv1TZrkl6OCwu3nwfrTXQ?=
 =?us-ascii?Q?rS2XNmiXAqM0+SzdArFmBzBR/TZFxN5tIlZl9gOncv6woZz1RUE8xdDaKaTi?=
 =?us-ascii?Q?/xT4wDhWTYWvaL5h7qjsmZ4SVEcC23XoMiipN5yAiIxxQft9OEXXu8oDfqLE?=
 =?us-ascii?Q?mv545/UmfX09rwRRtme3Ok7g1WsVYHAIbB5+NbZEb2nqaoe6LO7g2QOleq8u?=
 =?us-ascii?Q?O0mu0xCCQbifuy83poqDlpb4r+GRvzNgOEApRKfLppfHLpc/2/lcWazACMCl?=
 =?us-ascii?Q?UzPVvvy8KhC6GK32fpviRVivH1zoajNW685P+Bg3r8zfB1S9mBOzvATajaEB?=
 =?us-ascii?Q?CleVX9eltkQlxMClOEX/EhDsU+jGjN12qu5gErb3Wak9H9x1HrrS1fRpm8BU?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ece623-a6b4-496f-7a7b-08da9c5da32b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:21.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qEd9Kk5S6qWZDU3iXFEeR6xdhErOojxPRm2PUGkcDV3S09+rcD9nZSee2EAMDR5S+6uCvjfMJgHYGaF+3C7MMh/uVQZ+1MoGoUFizkfUEQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: HX32505OkPjYxGaI5KDkTkkUcO2p0lE4
X-Proofpoint-GUID: HX32505OkPjYxGaI5KDkTkkUcO2p0lE4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_attr.c   |   4 +-
 fs/xfs/libxfs/xfs_attr.h   |   4 +-
 fs/xfs/libxfs/xfs_parent.c | 135 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  32 +++++++++
 fs/xfs/xfs_inode.c         |  37 ++++++++--
 fs/xfs/xfs_xattr.c         |   2 +-
 fs/xfs/xfs_xattr.h         |   1 +
 8 files changed, 207 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 03135a1c31b6..e2b2cf50ffcf 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0c9589261990..805aaa5639d2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -886,7 +886,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -904,7 +904,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b79dae788cfb..0cf23f5117ad 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..dddbf096a4b5
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
+void
+xfs_init_parent_name_irec(
+	struct xfs_parent_name_irec	*irec,
+	struct xfs_parent_name_rec	*rec)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
+int
+xfs_parent_init(
+	xfs_mount_t                     *mp,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	if (!parent)
+		return -ENOMEM;
+
+	/* init parent da_args */
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	struct xfs_name		*parent_name,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		parent->args.value = (void *)parent_name->name;
+		parent->args.valuelen = parent_name->len;
+	}
+
+	return xfs_attr_defer_add(args);
+}
+
+void
+xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kfree(parent);
+}
+
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..971044458f8a
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
+int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+			 struct xfs_inode *dp, struct xfs_name *parent_name,
+			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6eb264598517..181d6417412e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -949,7 +951,7 @@ xfs_bumplink(
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -961,7 +963,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -969,6 +971,8 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_create(dp, name);
 
@@ -995,6 +999,12 @@ xfs_create(
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto out_release_dquots;
+	}
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1010,7 +1020,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto drop_incompat;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1020,6 +1030,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs = init_xattrs || xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
@@ -1034,11 +1045,12 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1054,6 +1066,17 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, name, diroffset,
+					     ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1079,6 +1102,7 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	return 0;
 
  out_trans_cancel:
@@ -1093,6 +1117,9 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c325a28b89a8..d9067c5f6bd6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..3fd6520a4d69 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,7 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 
-- 
2.25.1

