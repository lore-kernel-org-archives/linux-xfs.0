Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52911C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiLRKDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiLRKDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDE665F3
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:15 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI7gqoW016629
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=BKIVDS279WOWisAknbfiFDMV/nhRWcmoWlfK4NKu+KF7SAfQGt/8KNj0UUdi0HSb0cOo
 Gxf2eVMmcm6GfhSNZZRXlkcOSoGvl6hFMyZAehsFOzncocvtP1eTVP9mhIk95RiA9YY8
 ej4nIe2GUSETbOP1TPJ9OEo6GYPTyxO0ama9x956gx0EtkVteNo1qGXamzvkyLs4REpR
 69H8BDctQgpG+UOeS1WQIWfE7k75cqvjhH4QLDS+MDNN68yUwgn/zkA6fWpYjc4UDQ9B
 e0tCKXO4ZpfbXyrqtYT+W6wlPOgtMyQpESvo51vJv6ROedenKMn4OWunz+98jLVWP7qU mA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tms9b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI5lGwu022376
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh472brp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOweR+sTXLf7sfUk+7utRZtPimJzE3aUcdZy2dPoji3KBi9/ANF0HPbhLLDofieCygqSjdznf9pdzfaqg4xqdguDrD/ZRTIH/FIC6w9HLxGgOcgxU17VCxncKX+r/oyjbdNjHJubm8hECB0O+/UaGDsE3uZWd53YAjFzg+usSq9yKyEdLrtkH9RkXmnWYmhf9WtSfro9UhErHTkdE6ld8Rj18LBmF95OtsbBqLEFg47kEKL4fIeDXxpLP7kleroMkTLsk3yfkAinOQbeXZ2vl4S5PEK+kiGbw+k2joIlksX6fqOWDT6BagPGZemmUS8iaS3SNintpXvb/YRXnurJpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=c7f4TiAb/KEYgK/YXhZuM0FASnZu1M6oORSE4/6s8j2Cz1NUWhdZYB70sMrFKfgOXslXUvGsaANYKzeVZGDibozdOdxOmIVK1Wpo+TvwJltEgjgBfBYXqW7WNmeOg9iyvnEJpKujuJuu3Y2zBLcXNqEJctGkFA7rAo98/gFS0MGYogQ3F3hPTzgkyUzRM13YDVN8tyIeSdwu/FfM0bI7oinEEak13ZD796Z6jGCAGXypkI1b9psk9dZ5XRmLlpyYx5SkrNPunOTJOoqwaCTINk9SeKrdcDhOCL00GcGfFlz8673AYd3u9pSsfa0+nVPtM2KKIgldOogQwDdi1LSCoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjnJXb4QLTI/gC6onLA0jkmfXuy0GCZXIVbvceEUfO0=;
 b=VhcDBJnnsyOb/iKXo9ha0ULebP0QV0XWKZtDoHe5qyMiSfng0NCflS4qycSWQtOiwMO7tkM3UYlo7Cv3jUMD8TXYhVgkbmQNSXTRCkngXaHzwpRyTIrsqmcNxnEEJHGX7z00LJDP4PdfDcCPYo30qBzeVjM/njBn2UWwnC4dKM4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:11 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 02/27] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Sun, 18 Dec 2022 03:02:41 -0700
Message-Id: <20221218100306.76408-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0058.namprd11.prod.outlook.com
 (2603:10b6:a03:80::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: abc99f68-105e-4aad-e120-08dae0df1260
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +mzUGiGx2uP4hq2ueWLejH1l+6jxuLsLp+5R+XLzwbWmbXo5jB3xo4NPvS/RZMLerTMo7IKKMeKJr6ItHFOw1Xr0WBT5K4zRy1UrN6tP6U7Ia2sNFmk/qyT4uQmCPTLR8MgbundHz9vzRYa1kijFNcsMuuOk/Cnut8tUj/f+l1GvX3yx1eKkrME8QHAVyvGO/JiLXukdVtx8gC5cvxSexffY6FiMWUiNExjUuPzMbd2aiSq4/h6JxbaT+XAWNWbC4zRXOx1nSvSlkqgiQoZXgNW0oe/nre3Ubd3H/VJHzqp7NGjp4QEf3fsRnPPTZCUrXVmVZeWoGwIjHdRluA703FwNvgicKm52mFK5wpxlQG2aPfjQvKPLet2Gcnf8gz8RoCrkfoulOuw7i8BZUI9REoUbGyiMJedzrDu2eoWp0j6iGEl5GB899IxACt0iEp4FXDsoJsCPb3I9cQTFEcPMTDpZfnmCdsq6ZE9hXeEIuhHkl74C2U+VeACaF01JbnW+FmadZNvegkYQONySNxTSyC8maANo7FGb6Bc7OLxU3a/XhFjmmtrYUUId8KP+XZ3eKyH5LVvN1oN8aENPkRuDNq8mZffkxYGJbAy76wlaEFPstm3HBOvPD/wIOWQSqcEs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qay4kOkCLL7y5DZ0apKsfwDkWAWEhjS2p6qpUJha6VET0udT9fXtZ+cg8Udd?=
 =?us-ascii?Q?TlROiDkjQ2oLM3xFO6woix/ZQtPeaLEoybGLVuHktZqkO+Yb/FMs+O8UQBNV?=
 =?us-ascii?Q?+u/HwnRysweqjHHvFTa+mRgkLzGG51ucIfJ93b4sDM6nSdjxGmpzR/C2aqw4?=
 =?us-ascii?Q?e1V/uWMX6qgVC1Vwb9pccpsGq0e09r4ns2+Re65d6Szd+IQ5ilX4iTqXU+Hi?=
 =?us-ascii?Q?UIkEMiOqSSaPf8ZYdDef7rJAjDXAYhMWtBW6WuZE6pv1EJPP9ffn/CNzk4FB?=
 =?us-ascii?Q?mXN8p5AYf3raK3r1k2JtqEUqkor+BoCVmDshFik8g4x3zppMJqff+J/glFAr?=
 =?us-ascii?Q?hkIBBJzCRRD14ZpgQe5X/PlToGLoWsSP7huT5eDq+tV0ZIZqrWZ/tnz3uggH?=
 =?us-ascii?Q?FdW6sGZy6a/cK/JVZhmjTQskQDGA9fRnAxRVOYmHiTp3lVtBEuMmAJEdhH/o?=
 =?us-ascii?Q?hrhcEC4Ul0TAjuVCOrfHV4M3rnc1gW9F3XZ7HTK8HHOsyNC8uLMPIZ7BHOgx?=
 =?us-ascii?Q?/gGTaXQP3DnLgaHnFMDNBKNq4v0eIAiwokrTPFS+GoIgwOzAl0VuDgiEPIaV?=
 =?us-ascii?Q?MA14aYxF3r3z9orzkDhGLd9Zcr7EgWBpUcG0F46q++6V6/CizixBY1QWMu3U?=
 =?us-ascii?Q?Usx4BZQWMNeN2L/VQDBURWLCsLX0QVMQkjw+7Grl2/VRiIlschPfxvCduQim?=
 =?us-ascii?Q?ZILa1JZWU6ic2pdXj9zNfITvz4jne2jAe+e2Au+FYbMoXSJGTAsXnW9YaePV?=
 =?us-ascii?Q?X5h7p5lKuVRgrZclorar+OzqhHfUpk70xg3t1O65r7jo+xDWiPJRdtTteh/7?=
 =?us-ascii?Q?MnCUkHagTGp6cFRKUC18FyQnG/bnHjG5Ymb7K3EDXLyf2cVU2ItOhnNl+b9n?=
 =?us-ascii?Q?OAgq9Wb0SMlggDIcAKGGQOqETi1XnNq8+T6sCRWB8uVdc4gUMIQOq8204WsY?=
 =?us-ascii?Q?QvEtqQ2hfcDtc8JSTq0wv/UgKuT2NBlTrQ/ZprZdiOfLgKdO2pCwAofmlSQx?=
 =?us-ascii?Q?jZcNxX/3DKAMZbaRRuz+USp6Xo9H6v/mzUOcXRWtc7zDvE1oaytkya8uOxz4?=
 =?us-ascii?Q?jnXgHW9EP2t1PAKs7c2Pv08jBJLG/HwlW86eH6qqPS8gnlo1pdbF2vlWpJ0U?=
 =?us-ascii?Q?RO83ntqUf6AhpB59X3oEkTqSFZ1kiMhsvLW8iyte+tGtDxSBla8F/c8B5nBM?=
 =?us-ascii?Q?AGJUD3RMxZ4wrzP0hIdCXqWFLmgNjt7LJfqfukjMAx/PjGOf/zW2ltIYpXmd?=
 =?us-ascii?Q?uiLqVw3JIcnilMmI1TSx4ThH+gyCuSWxocK7cY5ltvT5b6a9K2FnRyNVgywd?=
 =?us-ascii?Q?5ykR5szUBFl5WW8ohKd0zDdsmSmNWSNRRCMR/uUtGOASRztSbrgK0MeeyvS4?=
 =?us-ascii?Q?GoINITNKM5ynHakf9WrqrDdpX55TF9bEmYNvgiUQsSCQdxYF/v54zgg9UpYG?=
 =?us-ascii?Q?37zJSdfoGivSRnL++pAxRWcVz+Gdjtsd7Ryxvwk5zDJAE8SWyP0uBABrc3Xi?=
 =?us-ascii?Q?ym+fC1BUhZCJNW8kWWJm0NILbmQ/16C0Mwo3BrVQjqIXG80rTA/Xj1q/4SLo?=
 =?us-ascii?Q?pvi5CFrIEY5Ef6Uxn/l3Sp2KY94fY4IiEnYm1NeMeTuZpxdFg/eYOH0WI2u/?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc99f68-105e-4aad-e120-08dae0df1260
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:11.7951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sun/Wb84AVzwzCayIxX+yMFbulQ1F8kz0uY4pc4WdpQ3lJiibrQB2RAM9tYhd8q3wARGfGBYuQw96XXAQpN+vlSz/gQChWfyMg5lAhUCXnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: WPg1NKfxxb992pXZkRACijSa9GGl8_DX
X-Proofpoint-GUID: WPg1NKfxxb992pXZkRACijSa9GGl8_DX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..fdf6941f8f4d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..27532053a67b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..2eaed98af814 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

