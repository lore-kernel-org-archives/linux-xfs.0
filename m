Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33612C6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCHWiu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCHWiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A37F59811
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:43 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jwoif020849
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=OJMdApohwbTZMSn1v7vP2XL8Lolkn36rKp+MWOdS4xM=;
 b=MCzUNtLF0iV4pXW4BjcG9a1cBkyii4PTYxj4D/T4lr5+vijwr6bmxsnUuy9pjov41ihE
 TcTJUqApo0vG0RXQ65i2GEqqdnyxORPID9ge3nmKRm07qWvVne5RGhXM2dp9D3E+ZM9b
 h0PuoO/Vh/6G1gaTlPbdTqaS05pwgZFJzKRwkci5+jAZKnxCbUDsXIAtfS7fuUpvtpIi
 N/K29qYvuCtY4pfEIPl7Mr529eSpykERvECLw4j50WDqne3/8s+Lc3yT8wuHPj3V1F5b
 Yg3skuuc3szRkG4q8Xcmax2/qOxE/wxAoFbxr9oLyzi2xrLNs0y7YAyG8uc6QTZE13ah AQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41811a3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LuWGd020781
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu8my53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcozajOW/RRYB51gmFKyak6lsiINjBsC1PWF66dmmrSAYVVNkRwPV4iQ64YZrAEEuhK8jR1W4lU03WFAGrt3cxM8DvpoIUKX2T123xIulVbL273MxwloOnBKvW8OFLor3GR3uP2VumHWBh+RSXVJSMn87MFo4j77qZDiPHgMzGaXPcOQVOTri6TjwGDaJAdXrGery9TLo5aAUsOcu/TlpAD2tkfDDZyRWGqKtcuxZlzJSFT7H63R+qgLA60P0BmYkqjzmAHV7qaIztedk0D5z2VYYab+K0HV8pxVEH0GTbMSDUGZb3f0yZ981z90h+23vXgMGMSKcBWVZTh7RNdaAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJMdApohwbTZMSn1v7vP2XL8Lolkn36rKp+MWOdS4xM=;
 b=CdjoPTKlVm/UKfWM8+iPy+byJcL7fDqSnOypb3MPwbFSKDo9k5ZXL6OP+SKzyUPi5bfKEM2B2h6pRAXYb1iB0xhH7OXsuV6BXb32vM0vNMQvb8yxZO5k+VtQiKVw33QyNjhQlhjVeYwqXWT7a1/STwCm8xdZKwlb+RyjZAq86yuLD/qrLC1/Xlh+RwazfYS29FMX1qpLKKn21/VZCtegOSAwk/ehLJrEpYVUnRfpCh46D840lREK1vR/WWg62HxH6MJ+W56nWgwmKRdVmj4Sl5Ijg7Jk0yQsGie0T3rW5lWAqC2/dxlIsOLsVeqHwmMrUgTpXalMdt/icuJEF2Elvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJMdApohwbTZMSn1v7vP2XL8Lolkn36rKp+MWOdS4xM=;
 b=qjz7pZWIENtT7niazgrWiR3oog09cN+QBoTpPeIjLcYmWTtvrf1nRL8I3qsOaSPndeuDhtmj4iDbl6Ox2iBzbhi7vOfP+TOVV5EYJr77RJQKvbOcDYuiXSeeJ84AQlsVSbQhi9O1BXkH/6VifjDQ81IYbOQpxHe+P50D5xx+cUI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:38 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 23/32] xfs: Add helper function xfs_attr_list_context_init
Date:   Wed,  8 Mar 2023 15:37:45 -0700
Message-Id: <20230308223754.1455051-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0113.namprd07.prod.outlook.com
 (2603:10b6:510:4::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: b26c9f39-7e61-444a-47ad-08db2025dc60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmJBd4P7nQiEbI67BZwWihhNWOn1zu0cfB+GcY8NFUYWqZIOczSZkPHxWdQS0mBsupn7tGayf5J8uGjmg7Z32lMtW4RWs0BRpWSQVg4Se530dHHRh+tGBgqikXyEkh+/TkbqVW1qHnYUQ8Z1hY3h8lxRVwpYrLe0X1JRNUhT8d9xC4DTsUolmgvWB2kJ7c3OxdOrVq0Dth7hsecmqHWGc2iASYQzOeKa6WJCOmyetC/ztDdoMWMHqNBuX2ypOdfzqT4zohiJpGKC5ih42oOeiTSfyLNrQS68jzoKiqh7aiJPRsyIicLDwmKu83Qq6UHcCRIciEjBNud3hfHMuzh2xO4MKZN+8TFVkbsuxSG5hPUInsCizvSuy/eW9c3VFtvkdx+hTd2gL1J/F57iuaGyPTwNwXgptEh3CmfCz47kBAzWCTwNxhdgzeuqNIO1ZBvKwZuY3A46F2Pz1VJYLG8UFGElpu2ti97B/Gvde0Fg1sXkVIu/I+nF36qrGrKdAAFOxxgrh4Y3vl9sv8w6be/7VcmPosACTVxI5EQtTxDQqwQmAGYMWPImYqqNwwPRDp5VIX8kQW32sy9FrqWb5NUORfnNiqBCoOJZo1m59n7hWNzkc4uPxVfWDRql0rUE4NlXxUEOZpaRSYgkyOIFRiynsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZpZslY2zKDM126u2y7JPDOlyMAMUMPl40fwpgaeTBEYJ5VBid04aDcDPdm2p?=
 =?us-ascii?Q?SoEaOainLfyuRqgqF2wbqZhZf/rq6zxFd/BFZ/n+1F1kl0yoDL5k0jPWCECO?=
 =?us-ascii?Q?bd56DouBAESHs1lTHJFFTBKKR3DNwSq3JbOmle5vo1xR0r3I5FEa/Er2ZjF+?=
 =?us-ascii?Q?tUTqpT7pBf58oLDRfRd4w40p/GdWn4bE/CQ7Z2Vc3OWOeKFj9VsidCkPnp4/?=
 =?us-ascii?Q?zaAiHhHMYac6MzCWv6MP52OZk8UulF1TSDlEOCYSPiZLQRbR8Vly1ONV7L4a?=
 =?us-ascii?Q?KBDd79c6x7DMabhRuMUvKmKQlI8+q4ip2kBD/x/hcV7sj67Jku7SvLIqwjqN?=
 =?us-ascii?Q?LFcw5VEFyHZpzv3hs8RkhTP14EUp6yncmzBQRXBfCq8oBECtBSFuN8MAO69q?=
 =?us-ascii?Q?vICloFOXRnr85p0TqXYHzhL/2UtWcfC93Zn13/SI2KCoEpN4XKx8LoXcsg6M?=
 =?us-ascii?Q?RRdlIsnHN0+L8jVDshop4lfCfD11s6rKS1i4j01NHI6ebaGULn2jb+9dQcVL?=
 =?us-ascii?Q?SQwGJAYt6ZG+fyh0gwOPFx1ie7zaXcahbRioXSc3wAnw7CEqJGqIUrb//BDE?=
 =?us-ascii?Q?jGvZU0xBuDMoQUhl0XTPXx+bZuDrPo/Q6MGTyGgXrJ3GSsa8Ux0JK8anAD7x?=
 =?us-ascii?Q?Qts89NvMF9ZJu/c1kn3syz95n0qT+8r6U0xA0z7TXFqMiWdidT52OSR9OA0q?=
 =?us-ascii?Q?yhdIyeRwW2O+rsK8do6aPmesyfus8MthW1e2pTW58v/wWEMbecY1aDTREJ1p?=
 =?us-ascii?Q?Cuygsc7aL35lThQ2Z1W8bIqD3XzZ6LLgstAIv9XPcd9CjU0BTkYC3F7EA6zF?=
 =?us-ascii?Q?HJMYsY2vVQoGmM+PSGnOR03iq0rIZYS7eNBiIfpRGDp63/qR5OY9Rrd/TCWW?=
 =?us-ascii?Q?oNZwOJET0wTJr2M3vDNyt0jtXcK7EkX/RePPNs8CT4Y5OQuD2STL//Y1LFRi?=
 =?us-ascii?Q?+UbSs8o4FmWD1z0AFLNKBMcbCzY45NKbot4JDsnGvYQTpve4VztiQtUR4j1n?=
 =?us-ascii?Q?2v7aAcKVrwD3xRlFuatdHK+yyTKbNOq5XdJBJ3P9XrbJ0Zcf4wHvn5uR/tXN?=
 =?us-ascii?Q?eCkn8QmmosYjoI3hKbaB4quer8Nqr62kuFZwPOy+OV+DbhbQeZOluq444O5/?=
 =?us-ascii?Q?2EKqi5YHwBL3BU0NL5uJMLZSIVnhhpkRPrM3+qKliHIknaipextKVj3tNjIe?=
 =?us-ascii?Q?TnivsqZdiKVmUHw+UeOpq7FVM4ClRPFp8nr/uJF9gSvojo0Nx3vsjd2f2Nuf?=
 =?us-ascii?Q?grjecZgMHR6ZQT8TnFJ+FC5+yxTJjNMLuw/mo5O+kgh5W/NuwK/4Jmx99J6F?=
 =?us-ascii?Q?wWipCa52HDHgV2EWqsyxCH3VJQq2rodFCtNWNqPN1e6ltXLyXHOYcm8bcev/?=
 =?us-ascii?Q?bVxfLLhjVohl3is7DXS3Hniaiux5VGdQzJF2SGGY5Ys7paS4BTwKwkqUCKTB?=
 =?us-ascii?Q?jYCcrK61wDHbWE2Ab5fghcrCIYTqbCyLbQFOoFER7hxZIAXOEasPFZvzP2Cu?=
 =?us-ascii?Q?sH6JyIejjCGVvh9EoAqYkHgsw5tg5/yC8RQ8sOYlGV+WNFvCS/kFHRXvrdFy?=
 =?us-ascii?Q?R0cgzE/w8Wc7x3lubrBTO6G06TjLMWngmPw/s3/OVjZmKu8vKfxi/w6g3bDE?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1BwjZP7jfimXvl9/9hJpKtjbLX83VCOI4he3JSNZF749U5kNEn2eBFc0K/Ihlsu1izkcXX933xoVVzi44jFaWqagHmalHt4K3cbz/rpVdhEtf1MO8KMAxVPqwnI8sHkzpeMztPje7WPCzjcPKUxNPnqPrinK+CL++NtX9roh/lCZWTo58gQSJEikO6UkeFYeD6JgpBYzEN91Ectr2yYS2BPB+Vv2JJ1nbXU67WsnsXrifnTY8wCNIOebIEXDkS5ky752Np8VgZgBvN19rKA/pEEo4L60ViuEKtH1g/oxlyOHyEt+SVD60EfTaMvnMCLcawRTXqpJ9kjTk59K4CgZYFbF8gMoOiyKPDIk5uJ7sOi9uQB9BJO/ShtXSblc5/u2DB5FrsE3fK47ojhYsnP+EBHWk1yZudkdD230Tv/UGQm72zeCDjWzVE52+v6LC6OkO46+xP8SF65zh5cP1f24bpgZ9vF3cjtCF9WmKuRPpcy6tiGiMrmGsDsCsCDdlYQI7ihyR6m1HX+CUEDHN1mJyuJmYeYCWEGwenU2e5rS+4uoX+O1Ji+VWHnWt5Gr/moLIKFo2IfC0C4RF3y6ygA1KQVkYyC/Ncws9+hEcQGDa1ctLskFw+7DEbATic/bU7W6uz5+4gZ4GNBhdljueKS7yGC0SZL1CyIe4cJAV6mLXBYL2LgkKF0dfL8aczh3JLnAEBUv2vSfGClOCJKw1lR0Tgd23QX2BDLoZxh+Eswo2BMzxTs5WtQZg/OOMHtCXaPvWn39Q3x6bROqkC45UOCOJQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26c9f39-7e61-444a-47ad-08db2025dc60
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:38.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0txJ6QLJ422pk5K55Cu+YpLYSXEW+RJUoiY1ewYL25oyPArI1fpLqCtOh9y4KylLzfhmwyUsVbB6XBvWQQxyYKC2x92YcHBlXRSGDoygvKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080190
X-Proofpoint-ORIG-GUID: HVa_Sj6X8JmFlkcvC4lbeZniDDiYuY1M
X-Proofpoint-GUID: HVa_Sj6X8JmFlkcvC4lbeZniDDiYuY1M
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
index 705250f9f90a..2ffa4488e246 100644
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
index 55bb01173cde..59987b95201c 100644
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
index 38be600b5e1e..955a67261dc5 100644
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

