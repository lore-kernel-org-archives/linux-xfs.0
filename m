Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7A8C4167B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Dec 2022 18:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiLSSSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 13:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiLSSSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 13:18:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41590B853
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 10:18:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJHx8MJ002083
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Hwj4E4nL68moHBXki5PPMi/9w4XZGduXF5W4TQtS3I8=;
 b=bpQwVOPaGyKwr/+F9lHtaVpB/K22M4qcbfiknTjfJvk6ql080sA7c+gN9DihxRs6Vpij
 kDgI8MFhCV3xM/QSpTujR5DY3e1f4QPfbqt3qlCqs19n4NjKUNgC2e5nuj81eb5+sUoP
 YT+EwudflAOZqQfBEoa8oeeL5SptcDMOrLc7KwoF4nzXAn2TmrBG55hkqjzsgJXIlale
 rfv3+nH55TAVSp3omizxAnsLZ35axTbUuc1j1QwFcaaPPYJCWtEhS9s0Cx8AGr47aDy1
 cGkpCn+v6aFAiMIOoDX3ocNeiQ/OFvdMR9wfoUZHrIbNt80dGEzDCaLN0boEhxbA0M7M sA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tpkjf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJHt6S4003465
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh473wa99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSqDs4MoEv6yQgUdCmsrxwDBvb/+939L+prKSs0srshkkYyvq/0elE8qPtHikMMIVhSavz5XgTqL8hFqC00g7BPUe/k7JfJM4J6YyI+ozD7yhZ2cg6gFyWhaWPPyciuRljk/xIVqK7sTXYtnphpkZ8NIhmOY09sMPCXnxvE+06qDGMMHqc6jitRO6POZ0UxTmDq7WZoD9WEc/IiihGKq+J87xWhX0yD3cNRnX6L6d0vc1CLnAuoC6wDfIDeVKpAoa0Yn+b6+vLjKoHPIaZiYrydsXL3nkbxCJxCnKAUdHsARBaq8rRN8LWyTkKhvf8LT86OaxxUJWFMJ7U6HvVTVCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hwj4E4nL68moHBXki5PPMi/9w4XZGduXF5W4TQtS3I8=;
 b=lks8gG1NXNjAJAQL1yK+ZiUCMc3HMCWQJh7tl5FbDX4moqQh2GzPsu6XuQfTOUWCIv+PReCr0xkr6B5ZvRBTloE1MzjLwtnARrfLk4JW6ckQHXH+/sOxgLlquAZqZSRfXWKHDh56CzfkFyacmuMWxsnVX7OiFgcbcQdoGsYUhscPDLiLKFErUSSVMNf8Z+MWXF4ou+4nPE7YXMm4Pj744GL/4UhCJxu2YDLSqo7WDO2lptgwmMQXzCIwl6syyRmdaNFkaeQ6r/pjZJfPC2MHv6m+OSF9VnuvANB6WUbhpSKzopVU8QWl7STN19155cTry+aip0xdkWSxA0R0iHWGkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hwj4E4nL68moHBXki5PPMi/9w4XZGduXF5W4TQtS3I8=;
 b=A2/qXJRadHMTEkFZ60PjiZwHLk/FaBNOH0doQlQ8qWG1P9yiLyWmalhF5NIxehUaLLhxDrFs0KNXbLRIXm9MJHdf6eOFPjPN2b91aBYQlupeTu6wXFd0qrLUQ9c+wZhUB+eIgP3/0ovWXaGzPdnANK4wvqzMofWBrqsvM8A2uus=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB4858.namprd10.prod.outlook.com (2603:10b6:610:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:18:32 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:18:32 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs_admin: get UUID of mounted filesystem
Date:   Mon, 19 Dec 2022 10:18:24 -0800
Message-Id: <20221219181824.25157-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221219181824.25157-1-catherine.hoang@oracle.com>
References: <20221219181824.25157-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0024.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::37) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e4f4dbb-73d5-4b8f-2190-08dae1ed6f86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1NN56CuZJy08Vjhs3Hn48x8IjyrHfjWkFM99i5UTnTa1YwgZJ5JGzdqRTzLAy3X5BVfJoD8Jc636pFqwB07CCyCyXRJPc963sRZiPEKm2fhS9sbIeVtDp4dLOfIfD3+BIvm3RHJWrTrciz+gywFoAiPYX1Llv76Ofbn2n0wKu1WTIvn7DiNl9X4cID+x5lK2IJ+mpFQ8T1WuchBl8AUizDEYn9DpB8XMhuCQH3q5poNgWs8GsOTzvVWl5fOVsu2dJjRxgq0VoLOhi88IJXGhAibFuRagXMujY2cPNuHKlGJk2bsPtn/QnKt9FHOrRmZZ9vCsd8Kkj7SU7yjLTu0hRBcV3m7EvzIbKRvR7Xe1Oi3NAMev8yuBI/LH7fqhlx+OLsnpvBCn8yh7s5X9jLXEzRSw0CYFOae4SOqcRUtNvPlJTV79wHTHnukQDyYOAWUsrEUNBoOUpZGhMj/d4LlXJsSnRuHVwNemfna20co4Ku35g9yrv0hO7BTOqttuXrB/YuD9+WczQ9ZXiQY5M3dNK9rWFkD1NzaYhQ2FbjO628GgC8CxFPtkUAB60YdpmHG/vlFbXjWL1fkd/ZJ3rn29nBcYv78/k+gtvR6gLQnJ18xEboMhlk6NmVyha3zTfIPMGf8gm3iHA4sb0rfjqewARw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(6506007)(6486002)(478600001)(36756003)(6512007)(186003)(2906002)(41300700001)(66476007)(66946007)(1076003)(66556008)(8676002)(83380400001)(5660300002)(8936002)(316002)(6916009)(44832011)(38100700002)(86362001)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vTKBqnWX9+uczIqeS38QRjdsduhXRuwZR5ym/AVj0nJDJtyiM3XOmqWp/2lb?=
 =?us-ascii?Q?5Us29VzO651UkXmzU4kx8y92m0OlQlwg+ltVLqSfsFp2F0Ri0nlC80e1o52m?=
 =?us-ascii?Q?K6//eLFPwZe9M1d50YGkAXrXCTCN57lsMWvD82cmyg6plx8PjGk69a1PzW0M?=
 =?us-ascii?Q?E2Tofrh42Ff6+N+JUWEbaFJz2weHBDPEeP3qlRUiTii2ATaw2kzSYCKT5q+f?=
 =?us-ascii?Q?KfcpzwAhViAyacNTVbdI+61mFOXKXYiBTfKInanBvUBGQ4oUoeFQvnAXuZV3?=
 =?us-ascii?Q?Hw4lJegvdrfuRH2WGQ7WaYDRZ0pyCbfktv1TX1LCAzV0spMj2Xyxexm5EUBg?=
 =?us-ascii?Q?heqSb4vQ0jBYit1JqdmvL/NU0uXCOoGNBtSio6hURaUfNJHp4sW9hj4QnoL5?=
 =?us-ascii?Q?nzsfj2aRPKuI/KG/ygl8rtfLhPtZjdcP7cq4OdDalTVYu/aj4AIVReb1TVhC?=
 =?us-ascii?Q?c3MW5I4bYCLgn+SbHZooMzXAXE5in2RYJcRWJpLvSnXEby6Rno2HDadUKlUj?=
 =?us-ascii?Q?Vgx9EKvOOELj7v6vq+PIQM5S2SjupBf5f4rskD3lQSGuZzelNk/YeLRG0ks5?=
 =?us-ascii?Q?dQO5myg2bubVD1tDVjupf4UiSIiTEILEE0Hh1vSz3wAwl8JLcgVzhtb9vIgJ?=
 =?us-ascii?Q?DAciZ5hmqte6Wrfz+7GQDeoYNBLsf+ly0yonRdgz4KCHL+3IAuiwWDWHt8xu?=
 =?us-ascii?Q?SFQqB8TZ7PvyGwHrVReWEJHyzQjaI4J/3wWCHAwr899KKuArR84mRXtY7PzN?=
 =?us-ascii?Q?WwYT0pbEDxdwgbdlkG5kwWiuOSanHiri+K4mxiN1VnhW0tcqMQ4ebGXJs48b?=
 =?us-ascii?Q?fCAYu4LAyT2K3kYEoNYsBr2DHMJ6V+NNVdH4jESgKtrYG98DKUlCUIJmdASE?=
 =?us-ascii?Q?5P7jpdzTASt97HpvEqhIWuHOb0Hs29y9j1LhMuOwK9fBkIpF38b8jqUuhhck?=
 =?us-ascii?Q?BQ/aq2vrUcZZHhEgwLbIvtbIeHNA+W3WpUT9D5FPJebagG8+CVrEEWVmK9jc?=
 =?us-ascii?Q?McMSHPYHr4y70ydCJ7xtjGWZ/jwcmfxFBrLx58QdJmmfzRBMNyhHtspAYAhB?=
 =?us-ascii?Q?5SrGNT0Kk4GpHQeEwHE30dII6NjH2B4tUUS5Fkf4j8ONDNdfVcio75wJ+xYB?=
 =?us-ascii?Q?ISRGLPYPhRwa1jCrY6c8zSu5vhu4gJjoq8jyCbS87Y5ZpK0bOGxhBo9iN22z?=
 =?us-ascii?Q?A6/67ZjRmKDf82bSkxkyDGYw0HLNIREq++Yx+z4CR+eC9wLJiH1doJtc+E4R?=
 =?us-ascii?Q?RCHCL0COnWmMSSHVzMoIWAVU/HZeLGobjD5+YZoGhA8MpZXNGVxhCbJDUF+x?=
 =?us-ascii?Q?VfDJh7wPAN+A8+nQjho6neKDnpaZJ7jEjyDWvp0mK1GmUt8qUqri6EBy55wh?=
 =?us-ascii?Q?gHeSc70t+Imj9TSXfXHnapleoHVZRPwT18ZYGzx/W568A3zeB/u0fXZXB/hk?=
 =?us-ascii?Q?Bnyg/s6BsjssaCkOSZPYdGB9C7xqhDDhlLYz+1l2UE/ZxTgM2V2Q55q0Bmuq?=
 =?us-ascii?Q?m0qy8oLuiBMoDYPsh/0dTWorvEUFFbSYMj9nzx/HfImaicEw0F86GcnP6098?=
 =?us-ascii?Q?M0Hwa5W/au3JHmIPNh7vfn5/AzG8/qjs2BxnYzPNUHWJQhe/UbYqqSEpfpCf?=
 =?us-ascii?Q?yztbHtQSzCYL6YeYc5D6crYrwk0UsgRA8krPmz1nbYbj8Mj7ZXopzjYNLaun?=
 =?us-ascii?Q?BFilsQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4f4dbb-73d5-4b8f-2190-08dae1ed6f86
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:18:32.5137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yuqRL9TTm5PwjXPCKbJeTalOAZdh54nmg8tS0jhwlhiGWchRps2lQma3vUtmNruOcp3EZHrwSjNefVsjoN9AeMSer2JoblZAZpeJqvkysBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190163
X-Proofpoint-ORIG-GUID: G_JHnOoHfexD__2-Ut5V0BHSXTy7QvAL
X-Proofpoint-GUID: G_JHnOoHfexD__2-Ut5V0BHSXTy7QvAL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adapt this tool to call xfs_io to retrieve the UUID of a mounted filesystem.
This is a precursor to enabling xfs_admin to set the UUID of a mounted
filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 db/xfs_admin.sh      | 27 +++++++++++++++++++++++----
 man/man8/xfs_admin.8 |  4 ++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 409975b2..cc9a2150 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -6,10 +6,12 @@
 
 status=0
 DB_OPTS=""
+DB_EXTRA_OPTS=""
+IO_OPTS=""
 REPAIR_OPTS=""
 REPAIR_DEV_OPTS=""
 LOG_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
+USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] [mountpoint|device] [logdev]"
 
 while getopts "c:efjlL:O:pr:uU:V" c
 do
@@ -23,7 +25,8 @@ do
 	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
-	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
+	u)	DB_EXTRA_OPTS=$DB_EXTRA_OPTS" -r -c uuid";
+		IO_OPTS=$IO_OPTS" -r -c fsuuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
 	V)	xfs_db -p xfs_admin -V
 		status=$?
@@ -38,14 +41,30 @@ set -- extra $@
 shift $OPTIND
 case $# in
 	1|2)
+		# Target either a device or mountpoint, not both
+		if [ -n "$(findmnt -t xfs -T $1)" ]; then
+			if [ -n "$DB_OPTS" ] || [ -n "$REPAIR_OPTS" ]; then
+				echo "Offline options target a device, not mountpoint."
+				exit 2
+			fi
+			DB_EXTRA_OPTS=""
+		else
+			IO_OPTS=""
+		fi
+
 		# Pick up the log device, if present
 		if [ -n "$2" ]; then
 			LOG_OPTS=" -l '$2'"
 		fi
 
-		if [ -n "$DB_OPTS" ]
+		if [ -n "$DB_OPTS" ] || [ -n "$DB_EXTRA_OPTS" ]
+		then
+			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS $DB_EXTRA_OPTS "$1"
+			status=$?
+		fi
+		if [ -n "$IO_OPTS" ]
 		then
-			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
+			eval xfs_io -x -p xfs_admin $IO_OPTS "$1"
 			status=$?
 		fi
 		if [ -n "$REPAIR_OPTS" ]
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 4794d677..2c7ddc15 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -19,7 +19,11 @@ xfs_admin \- change parameters of an XFS filesystem
 .B \-r
 .I rtdev
 ]
+[
+.I mount-point
+|
 .I device
+]
 [
 .I logdev
 ]
-- 
2.25.1

