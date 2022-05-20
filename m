Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F55C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353035AbiETTAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350692AbiETTAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8807A5F41
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIcLTM010504
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=StN2S1R96t/opID45ShRFjfTkZMAOuSfKFoC3sthyYs=;
 b=DmFQsGBW1QhGZT0XvkBuXtEHhWQn6NdgwzBLmmadkEdN8+an5wjfI8fYpPLWZV9ua6J/
 YY8MznUxAwVuapE7eZxFMf4qLgFhuR5l+zXUfvq/l4z4eGl7dEZ2zfBswUDYJdwrXmm2
 awcATpAWFBnbTDep68lzqqetAXp7WljuXQflgfGywfBTb8e9EyKXx+GvEFtlwV7xynZZ
 6N4BGL8uwLdKSK3hCgz29nsIOxK+PE/imiwVaAnn5QHiiU/SFOmoN/+j/2jFfn2rgRav
 Jt4Z0eu3BxQ0ecqLjFhS3ADA0RNffsdv+giEOV2aIJNwu0LiwZ6lImGyfPzmnDWr3Yyq Ug== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sfvp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIo9tx034597
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhfm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gedwz0GKt8hVi4IzEhqxpytDvavXk/rOHvF61Dik4slhywqPgAgvjoNWpfh55HfM4IoWx+/bH+1YUaGXVxz9fV9/Ez1BxLHRnda9jaESSwoHdoS/yysaYBh7pXfOJxUcw1PllobXNvgR2IElmugmdCYQglAV1SRYHJHwNXvWy5NAxtHNNLotmQAOVocLfZGrCq75SJ2RNU+qNqoyAbSHnG8TdLzT28qRhMno7fn/cI9zBLhnNRxrRTcLVRjgtZAwERbJTQoqhmeHTL+U0w+zyFeyKy9T7fPulVQATEPC8NNibUGA/ajX0w6tDijCXQCM1YXIONOcOjm1MMB6Qcl8Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StN2S1R96t/opID45ShRFjfTkZMAOuSfKFoC3sthyYs=;
 b=clmuovC8bxgIoFg7r7agEivmajY39b8Q4g6ZLVwdaLEnv2tYLtDW2UC3lIj8ca4u9ksH0G1WLEnzjVpEq0cELbdJg7mpoeIQ8dh1LAezU+8MWL243XZ57jiM5aWBW2Rdt5BjIXcsUi//AJDphNmEviX3rKsF9PG0hDIYjf2UhAv1DdGaUIMMWLT48mp0WnnukDolu28+HdsQE5NIY/AXT9kWP09aTj8+Zby19oS2MYG5jQGHvlMyHOgj/Itd5vXm6C7MYG6iCymBCKVpyGwKorcIq4nwUjhcyWh4qgZicSezIFNc+9DkYnTnuabhCxzBGnv4/yy9wuWKsz3za73faw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StN2S1R96t/opID45ShRFjfTkZMAOuSfKFoC3sthyYs=;
 b=DQSJ94P8kP+GuRjh/KSdpJeDpmun+8FfE3JlPSzSi8++C0f2dquYp4murLkw1Q0gIaRizjBHMNIveJKV5bgMQ19RoSWohdcB0YoZrT7qEOswcjsw7pwsL9OUfm61ooZBR4d22aLx38i9+xA97NwV4onqcuPF1Zg7I71rLhzffus=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3399.namprd10.prod.outlook.com (2603:10b6:a03:15b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 19:00:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 07/18] xfsprogs: Set up infrastructure for log attribute replay
Date:   Fri, 20 May 2022 12:00:20 -0700
Message-Id: <20220520190031.2198236-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6501f035-5557-405d-20df-08da3a9307f1
X-MS-TrafficTypeDiagnostic: BYAPR10MB3399:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB339980F1E55537521DE60DB995D39@BYAPR10MB3399.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jxD+mWtcstPkj7kW3oueOVJbOcy/3MQMxyrm8efuw8P1PO8V1vK/WU3QJYKSPmIvD2GKJf0VhOZnRNka4c94qiOMmwhyefSYpShaLi8teG6zfGyKGq1i7EPuQObmX3FaIEJiq42yhQfXy6mqRGEsUua3XyZW8GXKcZ7A95bdgnW3Qg0ccESHyJ/PCK2NSKV1mZRjJYpfOWsv1/V+JUU3X41zYf49f7j1jtl+XnX3xRteTtFBI7RR+ypE0sTedWnDDji+x+dEuQoyZ//d3+Zec2kwouq/WDAnEVM663Mhu6Vu2E0jVY8u1boBVl+FWbKk5cHiBaNdjSD5yLLhtlv5zLrGSK7XMNB8s9GOAMXNT0JhdPCdeb57TlnHIZeB6eMjg3dpEszzw9AaMzfTsYGrZIkSD6vBoXDcpnQVgIza6iNCwODeraRQLgDYViIioUyLbDnBS2T2xnp/3F/qpXCki/LtMxJ6hELt8dGbMbzNbxTIfPw5fNQTV+/HfYQIGPyPJqB4YvmB/tGgvE5SYJH+W+rJiwuUaZ+fnb6vQBUQSf4c5xjaUul12lNMGw16go380jwoj9VARuHCjfVI7EcfFUaYE/D2L9/yk0xJlJ6zqwC5q5npfzlasV/t8pcCPaZE5y/eDRqzfkaExFkGJbltDvtqHV7tIFeLZyDG8Clq+J98EJgR1js7dVaBr81Hhm+MsLA5VRCHmfTdvB3QkQ5Ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(6666004)(66556008)(1076003)(2906002)(66476007)(83380400001)(52116002)(26005)(6916009)(316002)(36756003)(6512007)(6506007)(66946007)(6486002)(8936002)(38100700002)(38350700002)(5660300002)(186003)(8676002)(508600001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9xsYNpqv3jyDOsFHxKrRi8z3CzhTV+esUTMX+7oKVdWFFMBQQ2ckBGZJTWL+?=
 =?us-ascii?Q?Dr/PRxh4XtKTAmcFJy9RcUgvF51mEH7aJVnNsHYLhjl+y4lO4XQMvzUD4sMZ?=
 =?us-ascii?Q?fTcHcsCc+W+FQ8fhwGqxfJk2/FLBOvn1qYL9Hk8KrS3+RgVItpkUyyns+dYA?=
 =?us-ascii?Q?gi10XgS5AIj1OmYhEltMDSNj6J715Nqd4F8IvFoNblpUWDvAbVdOnr0/Kby+?=
 =?us-ascii?Q?V99oJdm5baI63dKMyX0XuHImKzFxsQoY6UC2QWKd7dUvnIpLaBMcBPSXO1Xg?=
 =?us-ascii?Q?RyfFOjdAlpfmX5+Wk6Rkhw+HThufpy/MVeYoUxk8vTXIdO8X02QRQ0MKg5No?=
 =?us-ascii?Q?ZgN4NFLvwPqiVk51dW6d9/tttYLbW+gqqdcU7iWxuoxJMEgriK5LZXbhz6dO?=
 =?us-ascii?Q?RBEl8QgjqaP1o4BrKg/9fJGasE03L3jm1Vv2TQ/2kuLD1chvIe8SUU2kDyvH?=
 =?us-ascii?Q?2qADK69RQvgpJHmIF3/1PGG+nU7ea/vBMDlf3Hf09dlmS0QJUz2SGBrkdYRR?=
 =?us-ascii?Q?Ehiv0Rhxzp87ah4C52SV4Klp/azn4eBy+BCd6DAFsr3rZ2RnoBkQd4xVvtIf?=
 =?us-ascii?Q?Vwdh0PaTeeh9c6s1jWsTW+5TYIUgXhx8AI/n/zc0pu/60P9PWOjJ9foI94BU?=
 =?us-ascii?Q?iVaE6EF0qE1HvSkxPzaFe9aljAhisrYdtObcbkpZGVh0SCa4a3O+XK+vdk3U?=
 =?us-ascii?Q?r3Betcge9TGG/7bcSVxqSQd/TkuzAANeqYbtkKZ/aWSOYJUzvtIxt+c/tgCZ?=
 =?us-ascii?Q?Q4ArdXYOcAz03L33bsHuZNgBOMwGy932TA9CjECmAZX56mJtT71jEj07FXN9?=
 =?us-ascii?Q?afV5FzbnWbNJfgWGaznWOcMaS5dsRK2VQSzkJxDAlk6PNDudHE1lfpVz9ZWY?=
 =?us-ascii?Q?D4NtsYzvT3XRb8V88TNN5cVHKjHd67g86MS+0DvTslx99gXoVVpykNbOMmAB?=
 =?us-ascii?Q?c60IakigePWl0iRKvQR17vBs887CyrqBVYNXfisQA8Wl9SFru49IKC3y6yKK?=
 =?us-ascii?Q?1GcwRe6D24GLpCkMmQPO34vfkNObRcmVZdUFBYuLL8HG/vg9T8fFv2FkmFU0?=
 =?us-ascii?Q?869IYH2aPHiHFMO9IWCkx1vv2g9T/40NCqbi4IjtPgw9EdK3vq3odWsppDJT?=
 =?us-ascii?Q?cfxdUNP1RebugBLSTprVSd594ZBpySyHYbSVHg2DauYtpm7JMsFMtc/L5C+X?=
 =?us-ascii?Q?7AyBu2JwakV06jTgpHwI+yvkiFKWEx0HJkHqBRSsEfV2OGCcd4CxY1blYsDD?=
 =?us-ascii?Q?PtZTznfzRpyFNtzFxPZtz4Q6PF7C07wwo8K+PeJ5msrRGbKVAnw2IrbQ3Jf/?=
 =?us-ascii?Q?2lmu4y29bQvLuPMVKh4spBWqVUR67IEje+bAeY7X2L4pNBzZA0fZzjAWOj4B?=
 =?us-ascii?Q?gENSdW/J5knPDd4TtGB3kdkYC9e+igGwMg7n2yoeVVbyI+cDXEYwMlitYGN9?=
 =?us-ascii?Q?i+tFv8uqeoCMM6VKNxAL5wEBrWz+I3IhIxCIXxzQZgd9qy0eDcYeFfnO7Tv+?=
 =?us-ascii?Q?9a6HxPDlNfwD8F+r+DHhLCjIIuf6p1AmBipLE60VgFsjLjwMDflfHcn0Nv/5?=
 =?us-ascii?Q?6HSLF3ENmJVz8L6Ay1vIQYDiOztF8oZ0BrnPpTB7x/WVWBCnDmPe6SOZktNu?=
 =?us-ascii?Q?IWSNX0jwuQK06ISfgqfZMIOw4QyDY0JeUtGJ5I4oFGcD0xJJe7eEkrH9MYsP?=
 =?us-ascii?Q?YtumEtd1RpgyzalNh304cRaNVksLTSUVEpIodNq6gs2sHgxd+tkV4ci0GHGR?=
 =?us-ascii?Q?SfJr17d1Yaf/lZVtS7/nMBBlsBToodE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6501f035-5557-405d-20df-08da3a9307f1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:39.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ie2rOSKu7Bz3RhC0lKoz3QpPbJKAPMes32oKGJY9KFdD75HxQzWAYCZvXusDZQZjAOV34F6yflJnzYcW61hQWyrq5gn7QfnWH1Aif5uFZjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3399
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: TgFBmcDwX0q1Mi3WYdzDtW6OIFXbhkCU
X-Proofpoint-ORIG-GUID: TgFBmcDwX0q1Mi3WYdzDtW6OIFXbhkCU
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

