Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87045C4345B
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60DBF61A01
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCZAcL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56950 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhCZAb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Ta7B073617
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UN3QIopJJBaSreV55oYfXghKzhVuTCDiHJCA3OucaN4=;
 b=MMZtJ571dnI0mdZjN1pZYUPKMDmfYL3A/k7pwXCxKnMLCvuGQNozooc2j0bYqfXFOvF+
 t6g5iTO4aq7gXcray6ZpiooWeRQQH/c5UV9yffztUzZzPFCDVaxp5XWaX4gtcX+XzBfk
 +uZBqq9dnmTjDXy8BO8twDbMnbZPp6ukhbHtym0cIaBcmh/3UF4EbXWI2wSE6c9OyVGS
 IbPi2A0tqhjqlr/fLPS0eKt5c/kn4b1gvWdoXvU9tE4rRDFJm7STYdDpA+tgVnzhqmcY
 zrTtRJFAGUB5J5yYHq2EZXCYlmhjQQPeCY3sPUGEv5vyO3OkHKlvtXTPZd8tseTmKdGe 9A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37h13e8h4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Omv1009664
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37h14mft65-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xh0ffhwARYa4fnl0O19hTIo2yg0KUVDaTKI+eZQqGla84YZDIBwPJ+EasdMhPRNdYEn/td5MQoq0JsOPSxkysGkhx0xMiaaOIcZYDHI53wAO1HZKQM0FArC1lA/LDKScByOBCsdNG3d/npcK2dEwm/wg/FM6BcnxJi9CaCNI0XFqt6K2sAetK3gYMjhHFGepakCqV6kIjSquIk/oLkr6Lwd6DYiUBxjBLmHkcsIc/tg9UTuE67qoyDEpLoTPqWH95wYsmYGVF5jdvd525HrIlDwuvrMYg0iUQULXCO4FioUbQo8FKSojOrGtqYJ96nCWHLL5h81kO/9rqEHZ/0atcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UN3QIopJJBaSreV55oYfXghKzhVuTCDiHJCA3OucaN4=;
 b=ZnCHXhf44lJqyQ0W920tnojszcKTUHODtJ7lpkzYeOsMtX++bf5bp7YhwADGuSuUHEuWBhHylhL91BC4tRmea6wgEmjVulTzlfmL8+4wXMLcfrxDqlnmuUZvQSxo21qMxIjDM1eZ1iaRCDtQV27OCWNDd+iQeZE6qQnpgRsNWZhLJh19a76ucBIqBfoSnY7pAQL8ao/peAbf0pCYq2mlCr93yb1hUYH1U9dp63aKqk49B69aBR5cNURkE5pObwSPD5glvUJpaxQ7DxBE7reDhom6EQBs9qwupzyeOfxeH2nTcd7pohfswG56SF1r7vyxa1N86bQ8lELuSwfJgRZtMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UN3QIopJJBaSreV55oYfXghKzhVuTCDiHJCA3OucaN4=;
 b=HNam4EyBZxRpfh/l7rX+ubYnfuLj40qOGKkSouU5bG36vlnIzekL4Y5Cgh/gZKt2euA6or+EjD13LnjBUzfe4l9bt8QtaEFGsyoIBziqPxWjYHZEaqWY3an4h3JWQkkQOH/Awq+5s0pIE37/ojrO8RCye6bz2I4ZH1LCRMRxCAA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:31:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:52 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 28/28] xfsprogs: Add delay ready attr set routines
Date:   Thu, 25 Mar 2021 17:31:31 -0700
Message-Id: <20210326003131.32642-29-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5743c806-ff54-4ee2-fe53-08d8efee8d5d
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27091E125B53F7F70657148895619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6UBJ83oCW7HXvpO2qSTJamAdJQfiqpXd0gqVnZ1Hx1tkzmPHlvqea0uer51tqhn3pMYkJCsdv1Cfs4EUhQj6zib4lw90UNMBcBWpcxpvV+rBBGjmLjPxa+VdTzPao+1eWLEjL/cIZhi0Af5wPLDJgVk7F6mvVh8ixI8FhrTq+E1NVRfuvaObAf/yY/wCcPsfTTVnBV4uWEXcEO6bI6sTgust8DaCVp0gjXeARMCbUYjery+0PCdYSc7cASqSAtYpjI0wekgtg7iJp4Pi+cytGNBIDexZqmyJUFpSNisfzQOyG2uN6p+oDHDf/roDHg0p/8qfLfuZIiVqPjsGhPB6zSZfhbXMOpbgLtidS98axkQ8d4Q2i7m3w2U2sRnQrQgiqmA5l3lW69gQzgqQnM8pmpDn187LQEz1k81o1rTxtpA6iYZfWupdHsWJsu5gMbih5LjixK/j4C1gLbSNl23xv1Q/bZfTUnKz8xNl39jhNZQuaRLADs9A3TdMq5IW22BByskoAMbtlkPAorXnVnmAvkdvA/rDikZm4Pg4CM1kmqMLs48tJvF85QKGaauBoCNa8EhOQjmX8RuRWO3CLOJN7Yu33sJTygMf/QQmQd2mNRLb92W6VvPX/C4o4r8CP+bLujtFM/lrjYFR6mA5MVoAxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(30864003)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7MZGv15JmnvGl8jZmXFuAbdWSMHdpAK2IcAjyQTvAgd92vxaTI3d1uj0Mog2?=
 =?us-ascii?Q?2OroHOVtgZEqszM0/77//061F/X26Jgh7LBfZxabMw/MnmKCBaLjmKIgiSkc?=
 =?us-ascii?Q?j9DS/rs+rIaetZ4fPChnx11RECsENvOIhaqKDTFx1kDSnsVhnb96IJ0EBajX?=
 =?us-ascii?Q?0LXNO+OMbaseKX2jiRHwbVVir93/pGxzaiK5MrIKj7FMP7ZCqmsU3t0gYW1A?=
 =?us-ascii?Q?6BTHHHrfq2fljfP/o/DdPLP6d0QiauNLs/1KosIUo/bmA9TlS3cJmzKHUeYV?=
 =?us-ascii?Q?S6cddIEgziS3tAZ+T9rhrnwkEj8eZbbbgT9phpcrV5fJ2zUYEyXNZAMkuDPa?=
 =?us-ascii?Q?xOO8DEFQUMWY6WWVnnhpjHljCtBz9q7r98RgXhkyb4CWSPDHaAyWn0S1OH6m?=
 =?us-ascii?Q?5ElnssXvokOBXR5gRVNlT4VWd5W/Nlt/nU/vgwgHIMCYGcULCAYEnUzqLv9G?=
 =?us-ascii?Q?tgmBpivutmzPnJILjWnEhlPG8R+u8zZbWFxO74Z5bXRckl49Yzg0L2WgPNTr?=
 =?us-ascii?Q?X1Ow1WyJfvh/WkI5t/nysMUDO/tnCSDrNOUz1Gdy8RhNtKZBTvTby0/Gqad9?=
 =?us-ascii?Q?5sfuyveqj8H/N3bC7maEldUfmPCHeggkOmoBBUBCGAJPAepCrzPfVoGkCINH?=
 =?us-ascii?Q?8vIfzI30dvKd5boVBpy+2TX7/+3fPAS311Y4Ya6JLWQuSbV01wCUXHD7sf/F?=
 =?us-ascii?Q?g3ShwW7jcfyMv7AHjgZ6oDzRxAbi0Qk1O/eyfVVGsTQDnynY6MMBQaD51Jt/?=
 =?us-ascii?Q?Qs352CXyi+v9jgYTwSWrXPhpuVmjIXLdT7M9WIIwh53XtaaweLJMXkiXB403?=
 =?us-ascii?Q?3moEvaUJEaH4WMJkRmgsyCP9VJHXtKZxKeKh5p9WaYbbRCj1eXm0EOr1VnDV?=
 =?us-ascii?Q?gGrznzCv/XBF1XLdWQq+hwVp0SyyX6+R2hPiNqB2EJTkfvwTE3d3sMqgfSs7?=
 =?us-ascii?Q?ziOFvSBR3AJ5OYTQKBhGllcPLAsv4RYZz3bh8vpUxl5ZLc+gpCU4Ts+0s7NJ?=
 =?us-ascii?Q?wtvXc+mpTDaidyQzncawagHYmGnc/W+jLSR+kqCxqEPs/FFr2Ia8hAxp/LO2?=
 =?us-ascii?Q?KwvNNVUgFrtUH5XBr02hw8aDDD/eM8rUm4HmwPx8+I7VCb93nA1sdoAzIIvj?=
 =?us-ascii?Q?kcuDWxbEL6pYLkxWVPNq3sSK0XqyMioeQcvgzId1L3Ym7aZzGssAD1aNs28t?=
 =?us-ascii?Q?lebhpQDdyF+3tmnbxE56R+Jv2G5n0HVuO/J3Q9eT3TGGf0cM8bTIU9OkjUOo?=
 =?us-ascii?Q?mCypYGxG1hRohldvfX5Ehq5wWjaLfnYIje9hk/fDW0SDDPXio01bwjOkaT2N?=
 =?us-ascii?Q?b7eHszvZoWwU/CvtRMD+UVv7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5743c806-ff54-4ee2-fe53-08d8efee8d5d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:52.7968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGT2APRwUBDp64/ysRyBtwbKjXjLhT1b6cQpkrXZuMPcsWYxP3Xb873scGZNNbhuy42/t4ci8oxJ+PTJvbsWnAt03JvSLWxIvNV2XoI2Y9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: TO44HghAXprRD98KfAkzrykeO-8ktNvt
X-Proofpoint-GUID: TO44HghAXprRD98KfAkzrykeO-8ktNvt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45e46c998cd75749f6975ffdeeb9a59768e4fcd3

This patch modifies the attr set routines to be delay ready. This means
they no longer roll or commit transactions, but instead return -EAGAIN
to have the calling routine roll and refresh the transaction.  In this
series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
state machine like switch to keep track of where it was when EAGAIN was
returned. See xfs_attr.h for a more detailed diagram of the states.

Two new helper functions have been added: xfs_attr_rmtval_find_space and
xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
xfs_attr_rmtval_set, but they store the current block in the delay attr
context to allow the caller to roll the transaction between allocations.
This helps to simplify and consolidate code used by
xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
now become a simple loop to refresh the transaction until the operation
is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
removed.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h      |   1 -
 libxfs/xfs_attr.c        | 446 +++++++++++++++++++++++++++++------------------
 libxfs/xfs_attr.h        | 241 ++++++++++++++++++++++++-
 libxfs/xfs_attr_remote.c | 100 +++++++----
 libxfs/xfs_attr_remote.h |   5 +-
 5 files changed, 582 insertions(+), 211 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a100263..090aec1 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -160,7 +160,6 @@
 #define trace_xfs_attr_node_get(a)		((void) 0)
 #define trace_xfs_attr_rmtval_get(a)		((void) 0)
 #define trace_xfs_attr_rmtval_set(a)		((void) 0)
-#define trace_xfs_attr_rmtval_remove(a)		((void) 0)
 
 #define trace_xfs_bmap_pre_update(a,b,c,d)	((void) 0)
 #define trace_xfs_bmap_post_update(a,b,c,d)	((void) 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0840f87..48f999f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -53,15 +53,16 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
-				 struct xfs_da_state *state);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
-				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
+STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname_clear_incomplete(
+				struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+			     struct xfs_buf **leaf_bp);
 
 int
 xfs_inode_hasattr(
@@ -225,7 +226,7 @@ xfs_attr_is_shortform(
  * also checks for a defer finish.  Transaction is finished and rolled as
  * needed, and returns true of false if the delayed operation should continue.
  */
-int
+STATIC int
 xfs_attr_trans_roll(
 	struct xfs_delattr_context	*dac)
 {
@@ -246,29 +247,55 @@ xfs_attr_trans_roll(
 	return error;
 }
 
+/*
+ * Set the attribute specified in @args.
+ */
+int
+xfs_attr_set_args(
+	struct xfs_da_args		*args)
+{
+	struct xfs_buf			*leaf_bp = NULL;
+	int				error = 0;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
+
+	do {
+		error = xfs_attr_set_iter(&dac, &leaf_bp);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
+			return error;
+	} while (true);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp)
 {
-	struct xfs_buf          *leaf_bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-	int			error2, error = 0;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
 
 	/*
 	 * Try to add the attr to the attribute list in the inode.
 	 */
 	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
-	}
+
+	/* Should only be 0, -EEXIST or -ENOSPC */
+	if (error != -ENOSPC)
+		return error;
 
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.
 	 * GROT: another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
 	if (error)
 		return error;
 
@@ -277,95 +304,139 @@ xfs_attr_set_fmt(
 	 * concurrent AIL push cannot grab the half-baked leaf buffer
 	 * and run into problems with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, leaf_bp);
-		return error;
-	}
+	xfs_trans_bhold(args->trans, *leaf_bp);
 
+	/*
+	 * We're still in XFS_DAS_UNINIT state here.  We've converted
+	 * the attr fork to leaf format and will restart with the leaf
+	 * add.
+	 */
+	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
 /*
  * Set the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
  */
 int
-xfs_attr_set_args(
-	struct xfs_da_args	*args)
+xfs_attr_set_iter(
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp)
 {
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_da_state     *state = NULL;
-	int			forkoff, error = 0;
+	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_da_state		*state = NULL;
+	int				forkoff, error = 0;
 
-	/*
-	 * If the attribute list is already in leaf format, jump straight to
-	 * leaf handling.  Otherwise, try to add the attribute to the shortform
-	 * list; if there's no room then convert the list to leaf format and try
-	 * again.
-	 */
-	if (xfs_attr_is_shortform(dp)) {
-		error = xfs_attr_set_fmt(args);
-		if (error != -EAGAIN)
-			return error;
-	}
+	/* State machine switch */
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
+		if (xfs_attr_is_shortform(dp))
+			return xfs_attr_set_fmt(dac, leaf_bp);
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC) {
-			/*
-			 * Promote the attribute list to the Btree format.
-			 */
-			error = xfs_attr3_leaf_to_node(args);
+		/*
+		 * After a shortform to leaf conversion, we need to hold the
+		 * leaf and cycle out the transaction.  When we get back,
+		 * we need to release the leaf to release the hold on the leaf
+		 * buffer.
+		 */
+		if (*leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, *leaf_bp);
+			*leaf_bp = NULL;
+		}
+
+		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			if (error == -ENOSPC) {
+				/*
+				 * Promote the attribute list to the Btree
+				 * format.
+				 */
+				error = xfs_attr3_leaf_to_node(args);
+				if (error)
+					return error;
+
+				/*
+				 * Finish any deferred work items and roll the
+				 * transaction once more.  The goal here is to
+				 * call node_addname with the inode and
+				 * transaction in the same state (inode locked
+				 * and joined, transaction clean) no matter how
+				 * we got to this step.
+				 *
+				 * At this point, we are still in
+				 * XFS_DAS_UNINIT, but when we come back, we'll
+				 * be a node, so we'll fall down into the node
+				 * handling code below
+				 */
+				dac->flags |= XFS_DAC_DEFER_FINISH;
+				return -EAGAIN;
+			}
+			else if (error)
+				return error;
+		}
+		else {
+			error = xfs_attr_node_addname_find_attr(dac);
 			if (error)
 				return error;
 
-			/*
-			 * Finish any deferred work items and roll the transaction once
-			 * more.  The goal here is to call node_addname with the inode
-			 * and transaction in the same state (inode locked and joined,
-			 * transaction clean) no matter how we got to this step.
-			 */
-			error = xfs_defer_finish(&args->trans);
+			error = xfs_attr_node_addname(dac);
 			if (error)
 				return error;
 
 			/*
-			 * Commit the current trans (including the inode) and
-			 * start a new one.
+			 * If addname was successful, and we dont need to alloc
+			 * anymore blks, we're done.
 			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
+			if (!args->rmtblkno && !args->rmtblkno2)
 				return error;
 
-			goto node;
-		}
-		else if (error) {
-			return error;
+			dac->dela_state = XFS_DAS_FOUND_NBLK;
+			return -EAGAIN;
 		}
 
-		/*
-		 * Commit the transaction that added the attr name so that
-		 * later routines can manage their own transactions.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
+		dac->dela_state = XFS_DAS_FOUND_LBLK;
+		return -EAGAIN;
 
+        case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
 		 * identified for its storage and copy the value.  This is done
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_set(args);
+
+		/* Open coded xfs_attr_rmtval_set without trans handling */
+		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+			if (args->rmtblkno > 0) {
+				error = xfs_attr_rmtval_find_space(dac);
+				if (error)
+					return error;
+			}
+		}
+
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+		if (dac->blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+
+			return -EAGAIN;
 		}
 
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+
 		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 			/*
 			 * Added a "remote" value, just clear the incomplete
@@ -394,22 +465,26 @@ xfs_attr_set_args(
 		 * Commit the flag value change and start the next trans in
 		 * series.
 		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
-
+		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		return -EAGAIN;
+	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
 		 * "remote" value (if it exists).
 		 */
 		xfs_attr_restore_rmt_blk(args);
 
-		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_invalidate(args);
-			if (error)
-				return error;
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_LBLK;
 
-			error = xfs_attr_rmtval_remove(args);
+		/* fallthrough */
+	case XFS_DAS_RM_LBLK:
+		if (args->rmtblkno) {
+			error = __xfs_attr_rmtval_remove(dac);
 			if (error)
 				return error;
 		}
@@ -434,91 +509,114 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
-	}
-node:
 
+	case XFS_DAS_FOUND_NBLK:
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			/*
+			 * Open coded xfs_attr_rmtval_set without trans
+			 * handling
+			 */
+			error = xfs_attr_rmtval_find_space(dac);
+			if (error)
+				return error;
 
-	do {
-		error = xfs_attr_node_addname_find_attr(args, &state);
-		if (error)
-			return error;
-		error = xfs_attr_node_addname(args, state);
-	} while (error == -EAGAIN);
-	if (error)
-		return error;
+			/*
+			 * Roll through the "value", allocating blocks on disk
+			 * as required.  Set the state in case of -EAGAIN return
+			 * code
+			 */
+			dac->dela_state = XFS_DAS_ALLOC_NODE;
+		}
 
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
+		/* fallthrough */
+	case XFS_DAS_ALLOC_NODE:
+		if (args->rmtblkno > 0) {
+			if (dac->blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(dac);
+				if (error)
+					return error;
 
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
+				return -EAGAIN;
+			}
+
+			error = xfs_attr_rmtval_set_value(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete
+			 * flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+			goto out;
+		}
 
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 		/*
-		 * Added a "remote" value, just clear the incomplete flag.
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		goto out;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			goto out;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series
+		 */
+		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		return -EAGAIN;
 
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
+	case XFS_DAS_FLIP_NFLAG:
+		/*
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
+		 */
+		xfs_attr_restore_rmt_blk(args);
 
-	if (args->rmtblkno) {
 		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
 
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_NBLK;
+
+		/* fallthrough */
+	case XFS_DAS_RM_NBLK:
+		if (args->rmtblkno) {
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error)
+				return error;
+		}
+
+		error = xfs_attr_node_addname_clear_incomplete(dac);
 
-	error = xfs_attr_node_addname_clear_incomplete(args);
 out:
-	if (state)
-		xfs_da_state_free(state);
-	return error;
+		if (state)
+			xfs_da_state_free(state);
+		return error;
+
+	default:
+		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		break;
+	}
 
+	return error;
 }
 
+
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
@@ -997,18 +1095,18 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	struct xfs_da_args	*args,
-	struct xfs_da_state     **state)
+	struct xfs_delattr_context	*dac)
 {
-	int			retval;
+	struct xfs_da_args		*args = dac->da_args;
+	int				retval;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, state);
+	retval = xfs_attr_node_hasname(args, &dac->da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto error;
+		return retval;
 
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto error;
@@ -1034,8 +1132,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (*state)
-		xfs_da_state_free(*state);
+	if (dac->da_state)
+		xfs_da_state_free(dac->da_state);
 	return retval;
 }
 
@@ -1048,20 +1146,24 @@ error:
  *
  * "Remote" attribute values confuse the issue and atomic rename operations
  * add a whole extra layer of confusion on top of that.
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ *returned.
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_state_blk		*blk;
+	int				error;
 
 	trace_xfs_attr_node_addname(args);
 
-	dp = args->dp;
-	blk = &state->path.blk[state->path.active-1];
+	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
 	error = xfs_attr3_leaf_add(blk->bp, state->args);
@@ -1077,18 +1179,15 @@ xfs_attr_node_addname(
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 
 			/*
-			 * Commit the node conversion and start the next
-			 * trans in the chain.
+			 * Now that we have converted the leaf to a node, we can
+			 * roll the transaction, and try xfs_attr3_leaf_add
+			 * again on re-entry.  No need to set dela_state to do
+			 * this. dela_state is still unset by this function at
+			 * this point.
 			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-
+			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		}
 
@@ -1101,9 +1200,7 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1118,8 +1215,9 @@ out:
 
 STATIC
 int xfs_attr_node_addname_clear_incomplete(
-	struct xfs_da_args		*args)
+	struct xfs_delattr_context	*dac)
 {
+	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 92a6a50..4e4233d 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -159,6 +159,233 @@ struct xfs_attr_list_context {
  *              v
  *            done
  *
+ *
+ * Below is a state machine diagram for attr set operations.
+ *
+ * It seems the challenge with understanding this system comes from trying to
+ * absorb the state machine all at once, when really one should only be looking
+ * at it with in the context of a single function. Once a state sensitive
+ * function is called, the idea is that it "takes ownership" of the
+ * state machine. It isn't concerned with the states that may have belonged to
+ * it's calling parent. Only the states relevant to itself or any other
+ * subroutines there in. Once a calling function hands off the state machine to
+ * a subroutine, it needs to respect the simple rule that it doesn't "own" the
+ * state machine anymore, and it's the responsibility of that calling function
+ * to propagate the -EAGAIN back up the call stack. Upon reentry, it is
+ * committed to re-calling that subroutine until it returns something other than
+ * -EAGAIN. Once that subroutine signals completion (by returning anything other
+ * than -EAGAIN), the calling function can resume using the state machine.
+ *
+ *  xfs_attr_set_iter()
+ *              │
+ *              v
+ *   ┌─y─ has an attr fork?
+ *   │          |
+ *   │          n
+ *   │          |
+ *   │          V
+ *   │       add a fork
+ *   │          │
+ *   └──────────┤
+ *              │
+ *              V
+ *   ┌─y─ is shortform?
+ *   │          │
+ *   │          V
+ *   │   xfs_attr_set_fmt
+ *   │          |
+ *   │          V
+ *   │ xfs_attr_try_sf_addname
+ *   │          │
+ *   │          V
+ *   │      had enough ──y──> done
+ *   │        space?
+ *   n          │
+ *   │          n
+ *   │          │
+ *   │          V
+ *   │   transform to leaf
+ *   │          │
+ *   │          V
+ *   │   hold the leaf buffer
+ *   │          │
+ *   │          V
+ *   │     return -EAGAIN
+ *   │      Re-enter in
+ *   │       leaf form
+ *   │
+ *   └─> release leaf buffer
+ *          if needed
+ *              │
+ *              V
+ *   ┌───n── fork has
+ *   │      only 1 blk?
+ *   │          │
+ *   │          y
+ *   │          │
+ *   │          v
+ *   │ xfs_attr_leaf_try_add()
+ *   │          │
+ *   │          v
+ *   │      had enough ──────────────y───────────────┐
+ *   │        space?                                 │
+ *   │          │                                    │
+ *   │          n                                    │
+ *   │          │                                    │
+ *   │          v                                    │
+ *   │    return -EAGAIN                             │
+ *   │      re-enter in                              │
+ *   │        node form                              │
+ *   │          │                                    │
+ *   └──────────┤                                    │
+ *              │                                    │
+ *              V                                    │
+ * xfs_attr_node_addname_find_attr                   │
+ *        determines if this                         │
+ *       is create or rename                         │
+ *     find space to store attr                      │
+ *              │                                    │
+ *              v                                    │
+ *     xfs_attr_node_addname                         │
+ *              │                                    │
+ *              v                                    │
+ *   fits in a node leaf? ────n─────┐                │
+ *              │     ^             v                │
+ *              │     │        single leaf node?     │
+ *              │     │          │            │      │
+ *              y     │          y            n      │
+ *              │     │          │            │      │
+ *              v     │          v            v      │
+ *            update  │     grow the leaf  split if  │
+ *           hashvals └─── return -EAGAIN   needed   │
+ *              │          retry leaf add     │      │
+ *              │            on reentry       │      │
+ *              ├─────────────────────────────┘      │
+ *              │                                    │
+ *              v                                    │
+ *         need to alloc                             │
+ *   ┌─y── or flip flag?                             │
+ *   │          │                                    │
+ *   │          n                                    │
+ *   │          │                                    │
+ *   │          v                                    │
+ *   │         done                                  │
+ *   │                                               │
+ *   │                                               │
+ *   │         XFS_DAS_FOUND_LBLK <──────────────────┘
+ *   │                  │
+ *   │                  V
+ *   │        xfs_attr_leaf_addname()
+ *   │                  │
+ *   │                  v
+ *   │      ┌──first time through?
+ *   │      │          │
+ *   │      │          y
+ *   │      │          │
+ *   │      n          v
+ *   │      │    if we have rmt blks
+ *   │      │    find space for them
+ *   │      │          │
+ *   │      └──────────┤
+ *   │                 │
+ *   │                 v
+ *   │            still have
+ *   │      ┌─n─ blks to alloc? <──┐
+ *   │      │          │           │
+ *   │      │          y           │
+ *   │      │          │           │
+ *   │      │          v           │
+ *   │      │     alloc one blk    │
+ *   │      │     return -EAGAIN ──┘
+ *   │      │    re-enter with one
+ *   │      │    less blk to alloc
+ *   │      │
+ *   │      │
+ *   │      └───> set the rmt
+ *   │               value
+ *   │                 │
+ *   │                 v
+ *   │               was this
+ *   │              a rename? ──n─┐
+ *   │                 │          │
+ *   │                 y          │
+ *   │                 │          │
+ *   │                 v          │
+ *   │           flip incomplete  │
+ *   │               flag         │
+ *   │                 │          │
+ *   │                 v          │
+ *   │         XFS_DAS_FLIP_LFLAG │
+ *   │                 │          │
+ *   │                 v          │
+ *   │               remove       │
+ *   │        ┌───> old name      │
+ *   │        │        │          │
+ *   │ XFS_DAS_RM_LBLK │          │
+ *   │        ^        │          │
+ *   │        │        v          │
+ *   │        └──y── more to      │
+ *   │               remove       │
+ *   │                 │          │
+ *   │                 n          │
+ *   │                 │          │
+ *   │                 v          │
+ *   │                done <──────┘
+ *   │
+ *   └──────> XFS_DAS_FOUND_NBLK
+ *                     │
+ *                     v
+ *       ┌─────n──  need to
+ *       │        alloc blks?
+ *       │             │
+ *       │             y
+ *       │             │
+ *       │             v
+ *       │        find space
+ *       │             │
+ *       │             v
+ *       │  ┌─>XFS_DAS_ALLOC_NODE
+ *       │  │          │
+ *       │  │          v
+ *       │  │      alloc blk
+ *       │  │          │
+ *       │  │          v
+ *       │  └──y── need to alloc
+ *       │         more blocks?
+ *       │             │
+ *       │             n
+ *       │             │
+ *       │             v
+ *       │      set the rmt value
+ *       │             │
+ *       │             v
+ *       │          was this
+ *       └────────> a rename? ──n─┐
+ *                     │          │
+ *                     y          │
+ *                     │          │
+ *                     v          │
+ *               flip incomplete  │
+ *                   flag         │
+ *                     │          │
+ *                     v          │
+ *             XFS_DAS_FLIP_NFLAG │
+ *                     │          │
+ *                     v          │
+ *                   remove       │
+ *        ┌────────> old name     │
+ *        │            │          │
+ *  XFS_DAS_RM_NBLK    │          │
+ *        ^            │          │
+ *        │            v          │
+ *        └──────y── more to      │
+ *                   remove       │
+ *                     │          │
+ *                     n          │
+ *                     │          │
+ *                     v          │
+ *                    done <──────┘
+ *
  */
 
 /*
@@ -174,12 +401,20 @@ enum xfs_delattr_state {
 	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
 	XFS_DAS_RMTBLK,		      /* Removing remote blks */
 	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
+	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
+	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
+	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
+	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
+	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
 };
 
 /*
  * Defines for xfs_delattr_context.flags
  */
 #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -187,6 +422,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
 	struct xfs_da_state     *da_state;
 
@@ -213,7 +453,6 @@ int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
-int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index affff4b..fd43449 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -438,9 +438,9 @@ xfs_attr_rmtval_get(
 
 /*
  * Find a "hole" in the attribute address space large enough for us to drop the
- * new attribute's value into
+ * new attributes value into
  */
-STATIC int
+int
 xfs_attr_rmt_find_hole(
 	struct xfs_da_args	*args)
 {
@@ -467,7 +467,7 @@ xfs_attr_rmt_find_hole(
 	return 0;
 }
 
-STATIC int
+int
 xfs_attr_rmtval_set_value(
 	struct xfs_da_args	*args)
 {
@@ -627,6 +627,69 @@ xfs_attr_rmtval_set(
 }
 
 /*
+ * Find a hole for the attr and store it in the delayed attr context.  This
+ * initializes the context to roll through allocating an attr extent for a
+ * delayed attr operation
+ */
+int
+xfs_attr_rmtval_find_space(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_bmbt_irec		*map = &dac->map;
+	int				error;
+
+	dac->lblkno = 0;
+	dac->blkcnt = 0;
+	args->rmtblkcnt = 0;
+	args->rmtblkno = 0;
+	memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+	error = xfs_attr_rmt_find_hole(args);
+	if (error)
+		return error;
+
+	dac->blkcnt = args->rmtblkcnt;
+	dac->lblkno = args->rmtblkno;
+
+	return 0;
+}
+
+/*
+ * Write one block of the value associated with an attribute into the
+ * out-of-line buffer that we have defined for it. This is similar to a subset
+ * of xfs_attr_rmtval_set, but records the current block to the delayed attr
+ * context, and leaves transaction handling to the caller.
+ */
+int
+xfs_attr_rmtval_set_blk(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_bmbt_irec		*map = &dac->map;
+	int nmap;
+	int error;
+
+	nmap = 1;
+	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
+				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+				map, &nmap);
+	if (error)
+		return error;
+
+	ASSERT(nmap == 1);
+	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+	       (map->br_startblock != HOLESTARTBLOCK));
+
+	/* roll attribute extent map forwards */
+	dac->lblkno += map->br_blockcount;
+	dac->blkcnt -= map->br_blockcount;
+
+	return 0;
+}
+
+/*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
  */
@@ -668,37 +731,6 @@ xfs_attr_rmtval_invalidate(
 }
 
 /*
- * Remove the value associated with an attribute by deleting the
- * out-of-line buffer that it is stored on.
- */
-int
-xfs_attr_rmtval_remove(
-	struct xfs_da_args		*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac  = {
-		.da_args	= args,
-	};
-
-	trace_xfs_attr_rmtval_remove(args);
-
-	/*
-	 * Keep de-allocating extents until the remote-value region is gone.
-	 */
-	do {
-		error = __xfs_attr_rmtval_remove(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-	} while (true);
-
-	return error;
-}
-
-/*
  * Remove the value associated with an attribute by deleting the out-of-line
  * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
  * transaction and re-call the function
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 002fd30..8ad68d5 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -10,9 +10,12 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
 int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

