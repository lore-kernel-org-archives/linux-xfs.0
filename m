Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAA5C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7080261B6F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhKQETY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:24 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32536 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232840AbhKQETW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:22 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2FTYF003522
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=LKxYY7sXrJ2PLyezysAEilS6G5Utcl4XaxQajG/LcbY=;
 b=NS6+W8hrtI4hM6E83ur7nczGe3SUb1V2/b2ai0uHVhXap5bnX8sJK5A4OMDgmzst0N2/
 ME5MUj6EA9RxEw3S90Hj5UDecMqnCm9EzxAWUbFffXPSOwifOMFPATz1WtuN8E1NPEky
 5VdbnadW1bx8DMZd0yIc8e6BNNgUkljInzyGGluyM44Ii+8iKOk3nbcze1clGATrfcLg
 3SIoXmtRWKffA4RwquEuWM5udG1Mr4WayEjEEXdUTK685DQSWBMoCMfzm4wEoE7MzQ5g
 3ItSH9MSabHIsDW/J9irJpGsxFs4Mzt0+N7DP+71XAqkuoj9mbCcSmPp0Raah5vtWun4 Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv5dru1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKg180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ha7RGetlukY5nGgCCAFjr6u43z9Qwarg2DvFNpAKh9JpAoYCh6z1ami80yj8E/Pf7qs9Ung4vrdanPIntogu5gHzyZF8GwOvTbyNlsa0NKoTv4Km7FuXr+QidP4egF62guAnOdrvfRSfoBuHRjWf12fohuO9ksHFR8WAnKJV2CO1hqfgmihbE7FmqU+t/2b512umLk9/u9zqiLYxwdY0OtwrHmPFNf3O2UFGVfjwkfQrFGS8ZMjemaPPBdvSFBaXAnQKHXP4KbAM+8+GTv8Xs07OJ4ntnt5cmTkVaV3w0Nyp+G8OnmSosS3BjZGlsEqv/nbBlVSD1Z29SIQ49x1sCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKxYY7sXrJ2PLyezysAEilS6G5Utcl4XaxQajG/LcbY=;
 b=K2X1sypCdiC9IsaOzq82JKv2HSf/hXs7duW+05TA+vCy8IatLsSpDau9XhXYmhiwm6AU0xJ1Wz3eGKgAyXD9clqFb8klRodLKL7HbdDiqtss1ZSCwnZKaZJQtz+eaGkzS8/6tT6vaO3H+9mpHw/vqeyK5JkZwzjYm0bWbVV1UKZ8QrdaXm0FoaUQFoHKfeyJhfPoMA4OoZUDGYI4mVwsUVQeJY6ZiexFjuj01KR4wQY12JT49GofQ68BU/vDnBL21vyr5kLdqQZep4nPMEDp84bz6L9GAI9jf6i4g5hB4VA3zi1mbrACo6mZVAFApURdNIC2fqn4nHMxB0kNhSebHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKxYY7sXrJ2PLyezysAEilS6G5Utcl4XaxQajG/LcbY=;
 b=Tet1+RvApgfvKfX1JuqPXOcMdikvPrXYDhcHITlYnBMfRlqkQSOBOaR33PuzwFjNIpHoAFL91HSZYdBhT1VDL+2OL4b5Ht4zeDHNhOEsmxekU4eUv3GwNnR2F5NN7NzFOoVbjb6Y6GP8FmvdCDJCuq3CiB3WahgAby3qBpwadL0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 02/14] xfs: add attr state machine tracepoints
Date:   Tue, 16 Nov 2021 21:16:01 -0700
Message-Id: <20211117041613.3050252-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5caeba5a-e7c2-4bf4-82e5-08d9a9810238
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB40366F7CCA3D573DF24C6304959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:199;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qdBM43EU4Y/tKSJEiKOVJIhwAdxpCPCJ3s40w/Z014RQEZwWj1MAe52m8aTXUkA7SIDL77OptI1Zt5xPBvsYQWiWSzqDWSjRYL7AUE9eGMGY90T0zTQ/R2z/moUUU+xcAn/uilNxqSwSJdFL89PtLxukzJVpJ2BIcT34dbvhQs9awOSipMjE9BnP6M9PS2Az/C5PlxgVDFkfUnq1E/K8k3ySsmFVHmM1GSmBIFICGOn0eRvTQsp48obPHvRGgN30k8yIgWwwRl7aijoNiMt976aNWXFbrFmvvKC5kDqn+RnG7QQZq2jkpGWKlvSyQ2xnahfdHErnA1NNhP3HY7rlBWPAlMLngnhXG5evTIsF4zqj2IW5fy9cfrvm33/jvwlDtFfTsMh/p22gRBE2rlp4NYr7R+1i8t1ImwJIRM6YreQHwCxpSab4LMZ4fVdd6nF3Sz9d1sLuI/qXr4aovp5w9GKJin75NSSBey3C+nVNjkoy821fu3g8UpdmhvHXqCMqxDC315fX7gQjok5ufcDdn0J3QT9FcvC+wrMFHGEDa8a+AZw0BMi5WBgvIvUUg7YJHrj8sp3pln4R9I8Ia3VaOdPbFWcKB24P25Cy0n7qgUrdly2g6J/nFLXXb7T4mHCOdxtzrZodc1lkKop9aOzaMQdHX5msXrlOUKslrY0z52myl8dboLl0tkopmxFKIArejfL4rwt4TvKbZ7F4ahCv8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2mn4qVGHPrtjovZfSb9JyRZ+21kFS0lCZPRUiNqxtODcuWyMAh2Vgln78qao?=
 =?us-ascii?Q?qaSdymJYtYuQoiQ/P38LuwC5vD5YM3RV2paQgfFXqFjSqo4IFEQuuzcqHW6g?=
 =?us-ascii?Q?QwT0b42jc+KUOZvcz24KlrPCRVl5svR08ztKZm6zkHK4ZNInXN4a/ZVQUU4N?=
 =?us-ascii?Q?1Vu9m5Nc/bL1bW7kdGyuU2+L2r+04ryb4fr4vIKQb3fQjaxgwF3aKU+cLpxh?=
 =?us-ascii?Q?6BXi7JcTK3j38zI3rEAxhLg6EttPt2XK2CNZNGU5kBGfarFgwQngLxLwtJd7?=
 =?us-ascii?Q?xp1YDn/OxUDGjxPgmOX25A+YthwcP8CtlHSnEDZKhrrOW6BIP5JPxqa1BJ2F?=
 =?us-ascii?Q?9MtTjaPYw1TaKBu1arS3+EPsjPmBTV3bsquO/0Orjn7t/qLVOJNFa0OsaoXh?=
 =?us-ascii?Q?4f5pIWe617aAUHeAwvjfnGhupdQ/iLlN2MlxKUm0sO4l284KA7gcmX1rsk4z?=
 =?us-ascii?Q?fH+ziht9slm/O1bqNP7NXuqigigKjSH1VOAYzhMm3dmgM2gkF+imwDV3Kx+Q?=
 =?us-ascii?Q?1H9pvpydRP62oEWi8kXvIU51j7vFbMDZHNC/RM/NHQZ24FEIH5DObdhlrVTL?=
 =?us-ascii?Q?IvqKnb2pHn3PM2yLHyI8G1PxfS+h/X1AMVvXOJ+m40zPsBetveVGzjvFquPr?=
 =?us-ascii?Q?ZVedsSogkHzmuaHG/+cCz5oaFGskZjL4tbyFXBVnwePYmdyuJpFbMaZtZVxk?=
 =?us-ascii?Q?jVvvXZojA58cWKBp1KqmrI8HQthVthy4bxgX4G5ECfZLaN7vlpfpw/C+PEMd?=
 =?us-ascii?Q?J6lkr7IlEox6hFEezWxl8/h4E9q6/YqZXbwAidJpkTGeX2U+fTwWSg5Rqz6e?=
 =?us-ascii?Q?m6TesZ5LR1a2j1z2X5ySItnmWkSec4aXxHAI5OGG8xanWIKGGBzbpTvytysl?=
 =?us-ascii?Q?qpk8XZmG1fDJSUOtt+jzIgySwk7kfuX6FgOuRzZTXIyEufnFV7BN27N3N3F1?=
 =?us-ascii?Q?QwL50qvXyHbtExhia+LZtI+BfZpt3j+UYwkD9sFju5ojFmvtAZM9LT+VTGVB?=
 =?us-ascii?Q?jLn4RD6vsOs8WGG1sG3yAGj3fa1rtengK7B9p3H2U4TUudyJqMaU/VUsZptu?=
 =?us-ascii?Q?9zql8QTulK3p8NwvoUefCk3dCNu4sVX12Z+eq8pHoN+ElguZzjhe5ng5zmc2?=
 =?us-ascii?Q?vgCKEhZhW/+S4XmXaJDZ8Ntm10z4QgiNHhibFE1vy3tu11XkVlDC9j664OXv?=
 =?us-ascii?Q?glH9WabGY1QaZkcAjyvkHCrZY2O/xr9iP4NsXMu6N+9T3MWgwzD6cUVbsB/H?=
 =?us-ascii?Q?rGlSG9UiOTmSUAsFp/cZWmEpmuEj15G7w1np7lJ28WtXqQiT9AWuibw2Pu+o?=
 =?us-ascii?Q?uxkeRNfC+7ZeaZkHmMsVchQdLfcJ6UVzD5yt+0Q7LXhRWLIr7gnX9VwOAwJa?=
 =?us-ascii?Q?LX3uyTncBvPd3RnTSJ2Kl+S0srAZjWlgPV0509Fkw/fvQdbEnkFjZr5kIxVb?=
 =?us-ascii?Q?o+4PjQJgXt7lveaj0jyNcNmC0zxx3i7TAo73/hCzB9I1/MqXcjOyXnSJ/ygQ?=
 =?us-ascii?Q?Ra9hd7jSSMythCALz/O60iEO2LlEn8sefYCUnqRAzSQozCpUKK4ERpDgixey?=
 =?us-ascii?Q?/IU/VFgw8NDEAmqm9zAk7WWU6PPaZDkpRX00FVyeT4WalQoiJtGw/7ZqVsDf?=
 =?us-ascii?Q?uJZVgWolBG3ourXSWioWxZQ/0LNvaT35IIHgd+2Z/lmvaGkF2LQ2pxQ4TK9W?=
 =?us-ascii?Q?DUyYTw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5caeba5a-e7c2-4bf4-82e5-08d9a9810238
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:20.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hypc4z9dQ1K69t+joRr7zvIIn+iV9TxYY/tbIPuNE4Fr64I9hiPKpnnjRpR7LmU8oIWT9vQh/zML7ul9ulJNmHQx8eXpIm93BfZ8/6a5NqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: fIDFL6epfrD2-4V8T3Lr11Za6qn6Eriq
X-Proofpoint-GUID: fIDFL6epfrD2-4V8T3Lr11Za6qn6Eriq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: df0826312a23e495faa91eee0d6ac31bca35dc09

This is a quick patch to add a new xfs_attr_*_return tracepoints.  We
use these to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/xfs_trace.h      |  6 ++++++
 libxfs/xfs_attr.c        | 31 +++++++++++++++++++++++++++++--
 libxfs/xfs_attr_remote.c |  1 +
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a1002638f39a..227193a1e8fa 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -314,4 +314,10 @@
 #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)		((c) = (c))
 
+#define trace_xfs_attr_sf_addname_return(a,b)	((void) 0)
+#define trace_xfs_attr_set_iter_return(a,b)	((void) 0)
+#define trace_xfs_attr_node_addname_return(a,b)	((void) 0)
+#define trace_xfs_attr_remove_iter_return(a,b)	((void) 0)
+#define trace_xfs_attr_rmtval_remove_return(a,b)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 80a6a96fe2d3..354c7c3fd38b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -335,6 +335,7 @@ xfs_attr_sf_addname(
 	 * the attr fork to leaf format and will restart with the leaf
 	 * add.
 	 */
+	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
 	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
@@ -394,6 +395,8 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				dac->flags |= XFS_DAC_DEFER_FINISH;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			} else if (error) {
 				return error;
@@ -411,6 +414,7 @@ xfs_attr_set_iter(
 
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
+		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -438,6 +442,8 @@ xfs_attr_set_iter(
 			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -472,6 +478,7 @@ xfs_attr_set_iter(
 		 * series.
 		 */
 		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
@@ -489,10 +496,14 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 			if (error)
 				return error;
 
 			dac->dela_state = XFS_DAS_RD_LEAF;
+			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -542,6 +553,8 @@ xfs_attr_set_iter(
 				error = xfs_attr_rmtval_set_blk(dac);
 				if (error)
 					return error;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -577,6 +590,7 @@ xfs_attr_set_iter(
 		 * series
 		 */
 		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
 	case XFS_DAS_FLIP_NFLAG:
@@ -596,10 +610,15 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
+
 			if (error)
 				return error;
 
 			dac->dela_state = XFS_DAS_CLR_FLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1176,6 +1195,8 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_node_addname_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1422,10 +1443,13 @@ xfs_attr_remove_iter(
 			 * blocks are removed.
 			 */
 			error = __xfs_attr_rmtval_remove(dac);
-			if (error == -EAGAIN)
+			if (error == -EAGAIN) {
+				trace_xfs_attr_remove_iter_return(
+						dac->dela_state, args->dp);
 				return error;
-			else if (error)
+			} else if (error) {
 				goto out;
+			}
 
 			/*
 			 * Refill the state structure with buffers (the prior
@@ -1438,6 +1462,7 @@ xfs_attr_remove_iter(
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1466,6 +1491,8 @@ xfs_attr_remove_iter(
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_attr_remove_iter_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index d474ad7d969d..137e5698c15d 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -695,6 +695,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
 
-- 
2.25.1

