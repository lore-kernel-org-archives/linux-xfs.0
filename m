Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355ABC4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C791764EB9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhBRSs1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbhBRQzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGnhFU069702
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Vl9eDKa5S1raQvDKRxamKSxRV2qq5u41mjrz4kT1pOY=;
 b=omI0yrK0JCiCxgE+4J9w/waumEZEHOffVQEtLVoq7crIecg2b2DYCdSOxCJxlckd/fo+
 IScAk1mjhbpYOwwjTwHhexXcGE9Cqc99J5hN86ixGoznNJU4yMPb1a4LLKFqv/RzeBcp
 w/mCJe36QG5SyST5D3K2E1TGbHZ/k2e3Cdv8gEaB/myMvB26RSGrLcsyZfQiEzbXTA46
 x1vs3jBbAOxy72NezlzhdbLmL1rFjS13sRppyxLW0Un/7Pvlqo9yJqP9ev4mxTDGJAA7
 V48hXM3zE+Hr6Tt/zLWhUZHhYggSNc22qCSPERIdBfwxbtn2U83cJLr0DDJm50k8/DYO gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGng2s162351
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3020.oracle.com with ESMTP id 36prhufdmr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnA6g3V9InqGfuKowJ8THwKn197K4+ebExZ3EmbiE9I3NpD/Zu0yzUHQKMl1b9on1kzVIeZf7W3kac++UGDiWkTkTLFMnDEER2ywFC4HDi5W0cwSGbJsE1NW97sFuxG2axR76VO2JzpJtG4gQHcaYYecokUTNXvNTnDz6jMiua6kqtSXtOth7G+7ja984WcUgzhrJUtN0ImCkH8AT7HH5X5I16r/Wp+yA4DxVZAxxAzev0FPyuVOna+l3q1jTXdLhzGfKqHINnxH6sw1QBVyJ9ataO8RKrVfzZ8xqoMn/1S7Qz8j1U3Beuf5vwCkGO70cybGVrucz3zidGPP+IX45A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl9eDKa5S1raQvDKRxamKSxRV2qq5u41mjrz4kT1pOY=;
 b=U3HCE8d7GY0vRpuVxy6Dwy6igLMkvCYLmo3pQx4ZCxPOsBf/7O1h7DK+4nR4ijgd86qQZcOOr4LHhZ1lRZGePyZQQEV2O0DaSHWBOkyWoFJi4h/Og44KeaN0akXNErULPXxaI68s+MeXed+irp5u+Jb+XY42t71E3rGF/MWYfvoh3uudALwxjGWjJQFBMmAv+IbRHUjtQ6ceTX2qM0S/jZNIBgVDpG8ROsnOE3D+qa03H+E0L4UEvwaeXrF/h0svcZ/ebwEJF7a5k76GAVVCia9HIHU1tCWZSCb/t2uOmxWWIRQ09FOytmXpgtr/5xQ4GeAgx0rGvlTB3i1pAI+5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl9eDKa5S1raQvDKRxamKSxRV2qq5u41mjrz4kT1pOY=;
 b=TXQwe38xNdCWjIOsIiKBFX7T/20zXS9JwgCPs9/OlxZyLWkDg5vhUDLAu0ffFLLETVWcmp/DR2ouKPdzfd5N6hRcLpm6YZv+vZOzel8v/NlVMlfwD8sIpwDnuXxGMbV/oiNeKvH9yx6uhFFw9kNc/PhW+Cd895T22JXet2aqC1s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 13/22] xfs: Add state machine tracepoints
Date:   Thu, 18 Feb 2021 09:53:39 -0700
Message-Id: <20210218165348.4754-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7946b9a-94b4-4013-79f2-08d8d42dcf55
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33818FB11A9AD0FCEC11B72495859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zrfJUAQ7GVxqWr3cvuuH7t9pJ/yXbIqFJY93k1wdMrqULhyu7rPaibJVyhmq4JprQC6PEo3kEYVEyAI/X9LxMiqISysoMEkUIsnIHBuFcysYXwEEqgpEFAezMKqFVUnYOFDr4y+HMueiFiaut0/FV7E4wc75PAcxvEXSOOFiGwcGxWxry0ukAwlPhZzXBcxj2DSfVoLbKMyrO5qWHzXhj0QcWDy4gpy5SijIvT1zOUCLSyZQHLv+34Tmh+zh2ATtLyTC31E9eDPt6803A76XpQbqBVpZBCwrx8LoRaQWdE/gAfjaeMjSwFikeaxvpIl5xQMs5g3y0jX1xfX9TqxTaPfG1jHyL3jfKKjCq7FjaH9q2VOzwvMYRPhTTPhuChdULu/HOe6YhZBDlekCK4XhhxodPkhFjxH7zPpF3xZwMdgh2oqUSJIZGi2W/ZoBa0fDBfUSEmn1DITr3DWQM4Axq0uxtNybUGahiEqL5mhoAxm6er3N53MA2jNDcxo8SysKSnfMh4mGYO0KiX2JAiS8KMaA2Ckper0Phw+ujMjOkeuJk+ALk157RQCBNCEWblP3gpixg5aohKGBKlplDL7eUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A3Rakw507ghIXujipsmpyk+ROSVopQRHx08HHRz4c1QdGpxCm8x2PAhY/OGG?=
 =?us-ascii?Q?PTDHcOSZhT1+GJO+Pv4uQENZJGzxBhuExX5YVLDbUEpcTeJEkioxZHv7eNdq?=
 =?us-ascii?Q?SdZ4D6wlBndbOagAutcy2a+AApRhShgsKPhDBz1SLdyJAyyhrCK2MpkjBy6w?=
 =?us-ascii?Q?NL90Gfp3oNIo+qjcwXr2tiOsixIDJlnq8I2+GMuI0UDaSAPgIQvuQ7f3NNac?=
 =?us-ascii?Q?yCWSOJue2sZmtj/H7HAS5yU6Wp2v6LlGszKDrvbRIt2OKv5GMgRbQTXdVhbE?=
 =?us-ascii?Q?imfprMlp/JylhKF1vejYqmYfLgps7IsxvtS7RraOWuOemSw4YPul6rVqNNuj?=
 =?us-ascii?Q?hvsvqeK1XKjJdzwzH3HAaeX8vMXZ3cenukRsX/O/jo9qd0wHAGzrgEZ448K7?=
 =?us-ascii?Q?g1vFPXrJtluw3kmrwuP+I1BUxQlytCEDMEw92AZ1xpmg1w+bRXfCgOo17NvV?=
 =?us-ascii?Q?vP6rdGnRK44tJEbkzyCQIfmMUeA03siqXWMP7B944g4/IVcDvQn35pgWwk7r?=
 =?us-ascii?Q?zTW1a06q5BWQWYBT5ymXA1anZJRQL85LtG7IacemBQ7KN1aFk9jwHUCtN99t?=
 =?us-ascii?Q?dpmCXF/xZUGr7fWB8UIDHx9+SeEf+NNcI8ml+pkuk5p+wJjA41fIKtp2BgjR?=
 =?us-ascii?Q?Yqgk4peTbofnn664MO1XFgm3PiMRDJJB4JtU0LaFqxxXtGFp81i+CyBwaT21?=
 =?us-ascii?Q?6GNw0iq3cgbVWvHtWup4sgGxvcLRV84YA21nUdLm8L5KgTULOhBs8UF+ECAH?=
 =?us-ascii?Q?T7hCVXiiCLBwMc646dptXjk3YpUzTqvIUJcyARpNfn4CWHOAPE8Jk1+Ldvfh?=
 =?us-ascii?Q?sT3dwa/jtnSaVueuxcCmTRzTqhpoik31JSFrJBajqjWm6hmoy7C6OMM/w2X3?=
 =?us-ascii?Q?LuOLNjVHlusCoFKnhgmAs1wxjBRCCy4SL9Lt9GP+R11jpxkrAp94ntzWicpj?=
 =?us-ascii?Q?hwYOxtd47Qou/cD7H6iK5WHheaYNBx5LtxBtxTFmsc3dSakO3Pw7HM9sVCiR?=
 =?us-ascii?Q?eM3uEOLvONyjLMW5o7L2r2lFPK9Mr3F8EUF5tGMcpnf/Q6/tMAnhemmFIFj4?=
 =?us-ascii?Q?TmsPaIhbDXsy1YbJTw52ubsdsj8ZbQV/VVq9Pdvtpq6Ak16ZBKiZKrwUsMfb?=
 =?us-ascii?Q?dnLHZAW6JYEV5xE2V0dTGaliyavahNLt2REhq58EyS2NkTcPAmvBTQkqeB2s?=
 =?us-ascii?Q?23YHuT/iR84yWPAUuT/v5H7KM6TxbGIercbUSFb4LpLolBHzCpCfMNjS2amx?=
 =?us-ascii?Q?P0LWxEnYseLqNaNbtMI60SglyDnYXLyPRXyDijQc2ULMf5G5FtK6YkGuXSIX?=
 =?us-ascii?Q?93IF8zBRMuab7nqElOaoyEU8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7946b9a-94b4-4013-79f2-08d8d42dcf55
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:09.1182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LeAb2uMYWlnBHerndnAGJ8GbGbv9lzKYlq0D4QEMWgmp2INEyKyh/k02OUzCTOczAqk3VFO3f2ug97B4Dk6KxrG+9xRe62gMSWtuN7UYbIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
use this to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 31 ++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr_remote.c |  1 +
 fs/xfs/xfs_trace.h              | 25 +++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c7b86d5..ba21475 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -313,6 +313,7 @@ xfs_attr_set_fmt(
 	 * the attr fork to leaf format and will restart with the leaf
 	 * add.
 	 */
+	trace_xfs_attr_set_fmt_return(XFS_DAS_UNINIT, args->dp);
 	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
@@ -378,6 +379,8 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				dac->flags |= XFS_DAC_DEFER_FINISH;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 			else if (error)
@@ -400,10 +403,13 @@ xfs_attr_set_iter(
 				return error;
 
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
 		dac->dela_state = XFS_DAS_FOUND_LBLK;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
         case XFS_DAS_FOUND_LBLK:
@@ -433,6 +439,8 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -469,6 +477,7 @@ xfs_attr_set_iter(
 		 * series.
 		 */
 		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
@@ -488,6 +497,9 @@ xfs_attr_set_iter(
 	case XFS_DAS_RM_LBLK:
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 			if (error)
 				return error;
 		}
@@ -545,6 +557,8 @@ xfs_attr_set_iter(
 				if (error)
 					return error;
 
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -581,6 +595,7 @@ xfs_attr_set_iter(
 		 * series
 		 */
 		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
 	case XFS_DAS_FLIP_NFLAG:
@@ -601,6 +616,10 @@ xfs_attr_set_iter(
 	case XFS_DAS_RM_NBLK:
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
+
 			if (error)
 				return error;
 		}
@@ -1214,6 +1233,8 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_node_addname_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1394,6 +1415,9 @@ xfs_attr_node_remove_rmt (
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
 	error = __xfs_attr_rmtval_remove(dac);
+	if (error == -EAGAIN)
+		trace_xfs_attr_node_remove_rmt_return(dac->dela_state,
+						      dac->da_args->dp);
 	if (error)
 		return error;
 
@@ -1513,6 +1537,8 @@ xfs_attr_node_removename_iter(
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_attr_node_removename_iter_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1531,8 +1557,11 @@ xfs_attr_node_removename_iter(
 		goto out;
 	}
 
-	if (error == -EAGAIN)
+	if (error == -EAGAIN) {
+		trace_xfs_attr_node_removename_iter_return(
+					dac->dela_state, args->dp);
 		return error;
+	}
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 6af86bf..b242e1a 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -763,6 +763,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 363e1bf..7993f55 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3927,6 +3927,31 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
 DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
 DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
 
+DECLARE_EVENT_CLASS(xfs_das_state_class,
+	TP_PROTO(int das, struct xfs_inode *ip),
+	TP_ARGS(das, ip),
+	TP_STRUCT__entry(
+		__field(int, das)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->das = das;
+		__entry->ino = ip->i_ino;
+	),
+	TP_printk("state change %d ino 0x%llx",
+		  __entry->das, __entry->ino)
+)
+
+#define DEFINE_DAS_STATE_EVENT(name) \
+DEFINE_EVENT(xfs_das_state_class, name, \
+	TP_PROTO(int das, struct xfs_inode *ip), \
+	TP_ARGS(das, ip))
+DEFINE_DAS_STATE_EVENT(xfs_attr_set_fmt_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_node_removename_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_node_remove_rmt_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.7.4

