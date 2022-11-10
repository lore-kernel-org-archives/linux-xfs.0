Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBF0C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiKJVGL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiKJVGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40414AF22
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:08 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0b6j006965
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=/BFdHHVim9wiwtUmjR2DdhLeZr6RBKMox6U7uu8ndlI=;
 b=wOS4/Hpb7z6aPlDZwNK4vvtNp9W2C4gfIXG8KVhtyOsVtfCR639Y/Gp9mqMAsa7SYBqv
 GDfEWjFSpZ1wnU/wwVGIule92pqCjBd7hwoGbristNF9vPQBtji+GcLjsGuKezeyZizk
 mR5fQu65EE5+m255MlN3pmmmSsdPlXJM3rj3XrjflBmq/YJNO8u1ZmDj32fHRKC8tNF8
 qBGRLPQwXUAz87kAHH2SncffVxiquweM7wOkQ3XcH7Y+wFJWf4YMWhA22PFh7rCMvFgu
 0on9GUnsx9Kii20mOGCG/bcspEfd8X/IPANI32M7ragyMF54Qe8jzs6PF2w3wOJuA2rr Dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r15q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKajiQ004079
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctq0gtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmUhLoM5X9HRIK6ZURFFc/cmAwRSf4pcapgUhHQ5imi9gmG12mj6977W+9Yo5M1GZLzjBRfAtQFHtw6/mWMg9wY/pPVaZ6SG6IkuW9h/AvmBqt00JFpObzD+mLHhdJ0FwJqUUo/27ix+22VpfC3PLCyGOqOD0xjiJOjrRIi62BfjTmTMskDEufU72Baao+hFO5fWRgLQOfTAr6iDcxcnS/53/JXpcZuT5YJShlMgbB+py8Uppwrb0Gxu/PmkJXtFXhjv4ULnC4uxbbvsWifwuMHNWphWneY3K25CMmH6if6hd/VPeeA8Q9/mGgPOGRSOIWbeuvaMpVgYiNmHvwzlLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BFdHHVim9wiwtUmjR2DdhLeZr6RBKMox6U7uu8ndlI=;
 b=RrVotR66yw56CUzSrlC68+3cEQEsfyVqZ8/swWXkUMpOfWdhtsgjTZOnO0Y882vZvEgkeu6hbb1s6fJ1k0hkR9xEDCqDZ4JQg6NzDn+MZOLJB+ceYQvPi9RH723h8AV/2Ct/HQ8yJ0Xf2pEnkAz+dQOSAGEDenernVnoN3ox1ZJ/5bHu/bZZNs1mo7W7AVd6YGlGU1+gZSWgUmz4msEeJSdUPJHWSpNwQImsi+bx+x9TkaXx03bU6O61C6Dqt0cAgaXpGdkPtfdgYbbTxVajgm4cYBw62m0v8UmMZVEYf9y93+8snBC6/TGUqsmtsqbEk2DZ5/lSbFveocJ+bBpGoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BFdHHVim9wiwtUmjR2DdhLeZr6RBKMox6U7uu8ndlI=;
 b=e4na4hjxuCxMsGLjkmkGbCOtTcm2U98HcdCRLo5XNH+a6aV7cdtHsB4D+q6m14uew2FZxibs6y3kjefrnjUIAsAIaxpNA4plKNeI2FGPsOZWwAlFW89FZujDEagDaxV36elyc7O7AYIWRke/HKI2PGcWvpb8pXd3vmN94X0/DkU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB6318.namprd10.prod.outlook.com (2603:10b6:806:251::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:49 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 14/25] xfsprogs: parent pointer attribute creation
Date:   Thu, 10 Nov 2022 14:05:16 -0700
Message-Id: <20221110210527.56628-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA1PR10MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 93bce6e1-4d19-472b-11cd-08dac35f5823
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NFCSRm1+jv1eo6pYMlq1VTnHCFYCirzprQ+T9IWD1qMxmgY/+cBi5NxFD24weMZ/VrA9DQHlKcP2uyD6CuOsIty+uBwk6cbX+XFdAV2x37c/GQM0wdhfHGy1BgnKtmFu/sDbHbQ2AiKZPMDeFTNZubWxkRCQpnNcqFajpHg2JI80fMd1j2O22pJkVE53icxemnNLF3rtIMXrRzuE/GraHUB+/TA65WOOVt1GeMDg6ptK0/DTioj7iWR4r6NEBtUD3lZp4m2NmVmNNG55xeCBdJUVV7O9PoJ9LRstsTzrGgUDNz1MiRzVU9p40K3vcVomr2nk8XHBEidQZUpJ6aHO+1ohYV8S/WvoLRG8RqFYZnck473w/OgOhwDrcY5zZdPtJGOSPeiOX6R2Skp6+KnDJFBzCZX50XcckcMGNaXjGBMUSv3rWSmWQ0wapYkN8xMEHOiX77Czs2HC8z2ki21FmgMO9Py3a38Aohh6D8eeERPGLNKu3XgRoTNYBppeHMCahr4Cu9Y9NJtCO84viM88iZJ2ECZHTeGtX7FORxpZFseC8jTmjkCP2R15iSauVabXjPe7ARlGkXmaePaj4ls+83EAliWv0SmfryfiepYw++pc1m0uEQRYYUGYCXxl/9wLcpZL4dY5nezkED/pLCkN5giAP7JEXS10OjLJfWbbSWeiIj/pRBje9hyotmOYdomGcs2RfcTosyvlVvPaBAq7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(2906002)(6916009)(36756003)(66476007)(316002)(86362001)(6506007)(478600001)(9686003)(6512007)(26005)(8936002)(41300700001)(6486002)(5660300002)(6666004)(38100700002)(66946007)(8676002)(66556008)(83380400001)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K7B5O9SBJkeawKsoWXl0NkTJXHeiAqu0Q8533RPDesRe9TNLH348h7ppLnpC?=
 =?us-ascii?Q?oBgtysnS4vHC7qfI35M2cUvy0/lx6r0x2dg/Lr36mYSN9FJJAOQGcFIZgupK?=
 =?us-ascii?Q?Dovxb6DHbeLhvpgmV/KxzwjSoSxxsPoliGtnab/fFYUmXRzwAa8XR23DWnq4?=
 =?us-ascii?Q?afEHpMSiF3vEreoplNy5yo3D+NZpVFIAkr4TFnZevfR2WBWBYL2c9+ll8EEe?=
 =?us-ascii?Q?I4LAplk5jAZ98ArB0YJuZa0NoVPSe8wDv6fr7vjMnlVJFuIHKw7wfvGyYS0i?=
 =?us-ascii?Q?jGr8tBNppgOuLZtk0M83mURkKXrhsCMXDSwjI2V22eQMeBemQtBOIGYUAyAo?=
 =?us-ascii?Q?o59Jw+xC5WrncvBgOBXOFhQmADAWcTbsjAqQRnRjFhIlt0dSDDvPfoi0nhYn?=
 =?us-ascii?Q?ZnilZ/pn64GStyd4NRxpBQAQFIZn/nyB9VEgP+4fh+WlXevNbp9byDM0yR9C?=
 =?us-ascii?Q?2P4CG0NcGQjYkKCHFJqHYDU/DRy7oHkkTWzMCp/aC3LID2vT8b1DSiLlWGqK?=
 =?us-ascii?Q?Wn5B/ual1XzWpq9JfLeQnw+wqOuzoJOWDABzkUw4BlStO4JBQfp4gSixfWd1?=
 =?us-ascii?Q?3lMPHvLQzbv48rkpWKyZ9oOEBlyaugugpBvQEL5m9VJumfFfprq1+mIx97dG?=
 =?us-ascii?Q?4nmHSfn2E3PpneIcnLNOmJOsbIOhZK7EWZy695xoqX8sk7aTZX36dAR+NW6P?=
 =?us-ascii?Q?PlzBCStV68cN2stfpw3n5jKHP2S+PJIumxJljduATEYsZJsjvkUo4QXpil5i?=
 =?us-ascii?Q?BRqKpogHVIiMV7r2T2Jn8pt21D4eZzz0riGJwqXp67ioziIVvB5iNnUpi0CJ?=
 =?us-ascii?Q?Xm/rwCVQk2kD6rrAe5fzEjZc9rnf2eeFYtKXxCSWuIhc96hhy5MMWLrWY4fR?=
 =?us-ascii?Q?AfMA7GIuL9eMey9thKLBI0QiiAPBSA9JpUq7zL6WAZdoQYVtfKJlg3nCCKbt?=
 =?us-ascii?Q?xewaQdeKUojWptV/2qPfVWDWYwr3KeTyFobbzTz7MZX5moroMXjvHArWcwU8?=
 =?us-ascii?Q?nbreI8fMHQPNiP2p7w+fZd6HcZDs+1BpDd5gHPTdZnrPigVchBrocA4vzUs0?=
 =?us-ascii?Q?4ACly+vMZLZ7MaAMv+lopXi+2+IY0t+TIR5/rAeUNFmdtUBYEt0PYwNcxt95?=
 =?us-ascii?Q?6cftoQSyKBkGaJVEwqH8hUiGlaJDiPRDNRlHa9PFKjXr4m44Tp8BxXyF8v7j?=
 =?us-ascii?Q?uAAheFhCGGwEBVS/gu9wQGR/6DghI56NVQyvwtniK4AWRT23WykF4at1RnJj?=
 =?us-ascii?Q?g/SDOZ9Po8RkwZ/wHyx67e3LrpcourX/igRqCTwg6XjwIpmAEs+PqueH4Joh?=
 =?us-ascii?Q?4eKoHmGRDn9I5m4pkqV1mLGoByltSleyfr2/8bzEd+ybyljP+nkv/mIUsD8A?=
 =?us-ascii?Q?nNlGR+iNaVXlqoWoPTrURQgQ4fwXM+8OizaPLObET7kXD/TASDQcAky1Y8iY?=
 =?us-ascii?Q?K/uAxbhrVsNkZfr6u95fcyK6CrrYflBYZAVgiCHj5MVXfbD1VTE5Sfg2nZrW?=
 =?us-ascii?Q?sDzlYSD9/EIL4yOgriJMrJbI1R5kQfCR2HT2ZBk0upi8xpS0U1bfbmw+IzjY?=
 =?us-ascii?Q?XPYjgaKY0rk/0TY4x+vq+92y9JFVFjvoghjXYOmdiZ4prAy3rgurgzA5xrZ9?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93bce6e1-4d19-472b-11cd-08dac35f5823
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:49.5292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHOtPv98ZEjadId2PU4Ra9rA1ajAEvY9/fSh97herewQ6GmqUCM8iD3wdBvCcNn23f186bItZpZq/Ewfrx3vbylFG5ChfW99fdlRvMU23P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: Mt7RdN-khbaeCw3gyW2gogVpsSDPQ4zw
X-Proofpoint-GUID: Mt7RdN-khbaeCw3gyW2gogVpsSDPQ4zw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: bb5cfa7e0c8eff07c62b1a28e0a4ea1d2561e0bb

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/Makefile     |   2 +
 libxfs/xfs_attr.c   |   4 +-
 libxfs/xfs_attr.h   |   4 +-
 libxfs/xfs_parent.c | 150 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |  34 ++++++++++
 5 files changed, 191 insertions(+), 3 deletions(-)

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 010ee68e2292..89d29dc97aab 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -45,6 +45,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_parent.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
 	xfs_refcount_btree.h \
@@ -92,6 +93,7 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_parent.c \
 	xfs_refcount.c \
 	xfs_refcount_btree.c \
 	xfs_rmap.c \
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d5f1f488b4ff..edf7e1ee37e1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -884,7 +884,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -902,7 +902,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index b79dae788cfb..0cf23f5117ad 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..80318ae5745b
--- /dev/null
+++ b/libxfs/xfs_parent.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "libxfs_priv.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trace.h"
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_da_format.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_parent.h"
+#include "xfs_da_format.h"
+#include "xfs_format.h"
+#include "xfs_trans_space.h"
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
+	struct xfs_mount		*mp,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	error = xfs_attr_use_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = malloc(sizeof(*parent));
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
+	free(parent);
+}
+
+unsigned int
+xfs_pptr_calc_space_res(
+	struct xfs_mount	*mp,
+	unsigned int	namelen)
+{
+	/*
+	 * Pptrs are always the first attr in an attr tree, and never larger
+	 * than a block
+	 */
+	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
+	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
+}
+
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..9b8d0764aad6
--- /dev/null
+++ b/libxfs/xfs_parent.h
@@ -0,0 +1,34 @@
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
+unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
+				     unsigned int namelen);
+
+#endif	/* __XFS_PARENT_H__ */
-- 
2.25.1

