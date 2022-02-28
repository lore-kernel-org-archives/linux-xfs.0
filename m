Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BECC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiB1TxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04A7C7E96
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:04 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJqlV009906
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Af03T31u2y2ZuaGoP2kTHccW+Eg4gGdVpOz4egX7exA=;
 b=B5mKE5R+QjN5MMflcS/8bsCoFoIqshbL3b31wf8MYB3mVAZU454SqHVEGFwf45TdIXTC
 hedhj/nLD9UtjlTZ5g9i3UeirQ+tRKajgZcOU5dmFO7nBPne9ruUMh90Z4yBpaMhNw9P
 8mVN3vA92Ea+gkHmcyMCaqYWm4gEXAcmvdvSs09eVPKIAIbD8wIncGusEAb4s4lJe3Qh
 kW0pYhCkNIcfkdRu4vFt9/gMUsTqqj/7QRaoG2aBb3CEJ3MjDSB9tnYY1VKcLXLNE5S+
 HZePbFJytPseiapSfyCajJYgOcf+1YWNrYUedsYdGggsLymkuTd031poiLPru6GhPMvp MQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14brsje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJjsZ9061244
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3030.oracle.com with ESMTP id 3ef9aw0y4u-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRl90tQWwuMu23Zqza9PILKV8avD5kYlFwujniZBYwtFUFrA74OWEFuZ+T0CwhvzTRn4vzm5yoVTSZKmRus/I0v1lbBGwX/kpqrsGueOXt70a4knma6ha0fs2pXjwsgsPxorksXDNjH5flJq5q6TgTW/uvlReiE+9v5UB1nea2sD0TP6gexWSQLZrGvqrPbQWsV3Cc5s1+sKh/6aPNNEjCpZqXdhem3N1zcDue5rthzTmgJXi/Fhw9TxzlGo8zdpnExAoGjCBzIyOwT75uauT3dw9WpjnOCv1ml1MV/IQwKMYS6iSukzmS/GihxRRJr02rSK+wOaMDIsW+neWHFMLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Af03T31u2y2ZuaGoP2kTHccW+Eg4gGdVpOz4egX7exA=;
 b=W+x57tykz3VRTj3eKgZPH7x9mmxkQc4DzVfxkSm27Bpv3NR/0EGvWUVLy6vQ241+PqwXdqSQyNNpGYqTAuRN/TdBNNYuH2VfIu4DEtNFUFBFFjGXlkNLft9gSkj3RBstI321R3/rnlfEspNagnhPMj7ZDMTDCIF/OEkVfM2JJIPjK0rUifGyH/pS8VLgsk/GXKrb6APFlO5+yzwLyFKKooMapE5FV5wVPlgkF7Yl3obTphMmIH9IgfrNbhLE6VZeSy7US4LUK0rowOBDvj8O+ezz8iPh0ErvCIU+U3d0ChAFZFV8SicRH3/UC4sbuLJ2XYjC3V8UouFYfw1xl7mvyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Af03T31u2y2ZuaGoP2kTHccW+Eg4gGdVpOz4egX7exA=;
 b=oBAcqBUx/IzyeR+sbuumoeXkaLYsXtuyC+JEhpZ9c6t8VLx6t6swTLezrgZSE6+JIj9pxAZMdczcXkgmztbdliOcbepRgiDaSdSsQiTv2cRwoemb9IIzjKQ8LGqR1lvHC1xUhrQ5JcmhvpYQ0TmAw6kAXR5dt/alc3LgPrYMh74=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1732.namprd10.prod.outlook.com (2603:10b6:405:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Mon, 28 Feb
 2022 19:52:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:52:00 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 15/15] xfs: add leaf to node error tag
Date:   Mon, 28 Feb 2022 12:51:47 -0700
Message-Id: <20220228195147.1913281-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9094865d-a6f7-4b30-c8a9-08d9faf3c85e
X-MS-TrafficTypeDiagnostic: BN6PR10MB1732:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB173216A9A4EDC5CC8E06B73A95019@BN6PR10MB1732.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWvsHL6ObaVDbovn6uag+KqeGYr82qfkSaQEkwwqDAPIHq6OdVm3Z5G6KALUHBs3n3+cCK5kJAGJfhwW0u2NOO/YF8tE13TG6hNe6zAIifU/JN0lKn+vNOOaBqmQVFe30cXHyCNtKaqZ1pfYmN3Sp5FHBSrNY209updK4wmnoVubc/j06DsZJsAiMUIjD3S1e+M+1jNRWP0SKYivVCPL74tPULeUxFGwOobKoKuNF+o26dQ/TaePYOIrSTKcdH+oUZ9CmnX3VsbIQJKvfFdz41K9nO0V5Xaiw1f051FkjHKI7Enn2/bsfKMtlOxatLZUYsG9z86aNWV2J+GzOdZBuqFnE3ZJIxbANVIm3ln21KRWSMqNg0SBuiYOPN+FnAYTU8QIHlafXj12JxyAylzLGR/CZ8LWokL4H4ZAZhFpm8kUEBueV62A/tBYnaa4xC4+GpxkNLHtAdbouzYVczhSw6QQsNzSgwsfo+WnKDaPhwv4Qvt/gogE2HAgzbDmWwEwDZJbxdqG7XNFgbDgBnB73j48c5Zpuo7kzHJdP5jfP62tZ32aa5ChqaEIavPii9ecwowGpCz6LLGtVjPFytBkDozUvy1rSTGFfkjJZrUTPMJ54j1mXFZfdCwBrZwZ01UXMSdbiIytyRvbvg3b+yNZqu4cH0KbfozKxEiCmxyw/KLnSOdV0Sb4QDgbdYSxxsYbBtgF6Qi0NIxiyL6W3NVI9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(86362001)(6666004)(1076003)(52116002)(2616005)(6506007)(508600001)(26005)(186003)(83380400001)(6916009)(66556008)(66476007)(8676002)(66946007)(38100700002)(38350700002)(5660300002)(44832011)(8936002)(6512007)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EtOUPj9m5ScCxCyEY7zGNjmHSmyl2oiZa0e35VRmZwN1ZMPa9S/1D8gWIm5a?=
 =?us-ascii?Q?VKhK7Wdoi1l4bdkOhUFL5aI9rQf4cn3gA8M9xTgL/kS5BS57Brp1EX8hGunH?=
 =?us-ascii?Q?Wx7MW3j/dhpkX3n8WU8avBeuoQD1AEzLa8EACaRI7bvV/hHbbdtfXA8cQ7YP?=
 =?us-ascii?Q?6xPZ/fxNw/o+tlRKFt+DdiaBpKW7g9hR2s0YYc5zhWD2jVCnHs+i9S0LBYe0?=
 =?us-ascii?Q?saCulnKssWyh2rwyvono5zNCnq7tHMFDlzok9dFhTgj/WcAUR8isbLz38JB/?=
 =?us-ascii?Q?jtbzoQ72/mqj/s9qwUUHFl+98a8hWltn8MZGII/QTwZrTLgUdvtAFZFkQa5D?=
 =?us-ascii?Q?1kZBhmF3A9R/AXe4UbPa4wBIcwoM+1PlBmkLUiOhRjGGq1dni0NMhMnKIjCB?=
 =?us-ascii?Q?RyE5LG2BQmpYpGsp6feUmrzEKuvcp3tq4QqT6t623XkVAlR0oYR6mXauue5A?=
 =?us-ascii?Q?evqflWA/RuVsccJSLmp6IcmUG/nZ0UxOvzvVqTmI8WkrFk5Hmw9zfABm0zBT?=
 =?us-ascii?Q?t3eD4zVWhqty4famBGl05AKKG+8e+ATFE/0sdgoQG9LEL1DEGOKJbzTA28SE?=
 =?us-ascii?Q?370PgSvUDPtId2RoiCt7IJ1+9WFPHXFr6uHw4L7cH4Q2DDZlIMnzqvo52LHi?=
 =?us-ascii?Q?cP9ykF/mUZah0sAIXrHDi8SxNQng239Z6PzdGcA6xMKiv/4+QSwrHZufqJ0V?=
 =?us-ascii?Q?/Y5fYkx4LAdCpNZYhPVv7jc4mSdUYpz8+JhEmdObiah+vwomM/aI04UQdw8P?=
 =?us-ascii?Q?WvpHQR7JPdvEyjpPJrOTMOMYNuSnYylhbN/QvmLpv3TZwmPwgBDrvkFAk5AW?=
 =?us-ascii?Q?xNAggi7rcORROdojLO8B68p5pD2lkQGNWwREYCzivYtGHj591Ek6Pm+JHpxE?=
 =?us-ascii?Q?99rLmZW60su3V3Z1IWLvY1gSZx/m+wHUgLQUeqqYYlMcA/FcugidziYUTGsO?=
 =?us-ascii?Q?iBgNhccoISNw5ictCd3sK+W6WjnSc2tOY95MpVaFBROocKESn/PEqusqXufn?=
 =?us-ascii?Q?YDgikdObxcdfcWXLTGtXJGq2MyMvHj2QACQchyozm2QblJWsYj5QbPtjJ1k0?=
 =?us-ascii?Q?zWkZ3jPmH+az/E0PFn+tHz35w79udxEQmSD8HPzCpCVcy6/smTLmLL+omE7U?=
 =?us-ascii?Q?TtTRKfNsvmmq6Be+qNQajw0NZJ9sdS0iEdGxxaQSYyleO5okaZDN9vd152WJ?=
 =?us-ascii?Q?12AdJzu0CdQ7qrCQ+s7vgNp4FmE48WBQDzQooMiTQnhh3nbmO+IkdhaeIpsw?=
 =?us-ascii?Q?hzby7NQs5NX6dLGJ3ALj9/zXOgcSk0dJcXgwG/OMMdhveYGClmEMr9IJyonA?=
 =?us-ascii?Q?L1/e/dq7TgwHfZPXkV/zkfj0FFmYY7DkiA9xHmseRt95wANUgACN81GZKWql?=
 =?us-ascii?Q?T5453x2LVr1uZB1rwSd5jB4jGlrwH6hUfBPqTtlo2rO7a7CZezcUhKW+831B?=
 =?us-ascii?Q?liAH9AaoRLUqhVahhe6gIDDKiaDmlNni1OXEXA5TDGh3fTNWW0KSCt2L9feM?=
 =?us-ascii?Q?9wWZ0EaCuk0orig2SBM01lB8XC1RdebVyCyMuBiwWN/J3HuOUsHbfxrN7l02?=
 =?us-ascii?Q?vshZHacjm6mvKcEqC/kseWLM/7UZhynxw8wSSUww+/yNNHHK4+J2msEYgGhj?=
 =?us-ascii?Q?YbuSY4JZTAk41I9Gi1dZWbWNn0oS88JjW9mzkCGthswVbc0Pi3GVkIFlbAV5?=
 =?us-ascii?Q?jAOHnQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9094865d-a6f7-4b30-c8a9-08d9faf3c85e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:59.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPlz0aTkC7zfaG6K//AjEVu3RWMGshb1tvrv51ZVLAiKKa6As3hDWyARUZoFNVR2nP9z04InvWwi+WB/rSjTTs+2KeQl1xGTEDEimbzxvpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1732
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-GUID: KcjqDEu-NPP_CKwmR90WFIA-574GrL6E
X-Proofpoint-ORIG-GUID: KcjqDEu-NPP_CKwmR90WFIA-574GrL6E
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
 fs/xfs/xfs_error.c            | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 74b76b09509f..e90bfd9d7551 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -28,6 +28,7 @@
 #include "xfs_dir2.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_errortag.h"
 
 
 /*
@@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6d06a502bbdf..5362908164b0 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_DA_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_DA_LEAF_SPLIT			1
+#define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 2aa5d4d2b30a..296faa41d81d 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
 	XFS_RANDOM_DA_LEAF_SPLIT,
+	XFS_RANDOM_ATTR_LEAF_TO_NODE,
 };
 
 struct xfs_errortag_attr {
@@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
+XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
 	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
+	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

