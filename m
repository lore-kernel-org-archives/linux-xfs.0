Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E38C54E94
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Jan 2023 00:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjAZAdY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbjAZAdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 19:33:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBFB3D0BB
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 16:33:22 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PM3kqt020683
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Cz8BQ324LBPiL0xOHS8/aTDxgboM26a7lVEg4rh4gi0=;
 b=xgsyeeglXdvwg4FNAQlseTRSMJhXiAOwCBA86N0WmcXmRNvtyuyJ1HKzL96ffXguKbYg
 JCzqnTOODXVJAGutXoD2a+A1yo4tQEpMJRDopKLPeFwhRWRFkg0AuGuRd0Zygk4Uu8jK
 o0YAzvKG4EPl6Xjk9iu3FF0yupsJUBe7FWQfNdXVEnxxcRiRek35mgJXEXFEy3I0jmDq
 L036vXM1gNejNvruFegJKInXWtOw3qytcyio6dkLtKWg4Bh4y/zmdm3yzWkEn1p+CPnC
 caRiYkhfu/AE3jcxve7/ub4bc275JfZrMqRWBpGE48B2oOcxvz/CvCa9GsAfvFQzA/QB cQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt9d4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30Q00LrQ031874
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g7a3uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAzNbZUR09S1PV739PVhzkqzz807X/UCzY0T0guzY3pNHJJZLCKd0wO8UFr2+DPWW5bnki4fkcawQe/wV7vlfhn2g7jAIlw2BCMnrxp8Nmrhttd2aEk9R/q57uNK7fiLIH4S7sQyeNTn/PJAP/oNmq9vCXcnVC5W6b6xVWrTlwiFNIhm5pLv8i3URSo2/t7AGPeUE1dKb+xOSYEoqds+FNEAttY6ZL4G2PVKzRTqtqryUPCphtXNLIAPmApBMUQomIm8YWpqKdNA3SY2N0j00w/mrE1U8ZwzW6MEA0uv3opaLETT5rnXn8RyDIvDt6Z7j317piWXFdizXJk4/pBLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cz8BQ324LBPiL0xOHS8/aTDxgboM26a7lVEg4rh4gi0=;
 b=Txghr9+4xVgDPgWgIUcICkO1Ra19c09rSMcuw533/XWMrw+JNokUKnLeisTM4qpdUM6qLCRmoIUlY5cdP+RvaK2a3B9gq3oOvriOTYLsaB9osd1TRZPQ0TNVB/SIqGk8jZidhPn47rkiyMnCI7MgqiLxgVRXnxJSUUkVifeaKMM0F6uiBUSf9k29uworhUPGlqjuDs/2QehbB+JBFXNop/CK47OSdxNMSHvBmcYQaNd2FRCZlU5PCxxyPykjarGopjnGOGcuOi9PGMcMkFX2Bc/YWbf/aAecUBHGTLVSdrrrClZZCdyeBRvKxs2hmVor278GNpaQWW4UZY+8ZvdGmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cz8BQ324LBPiL0xOHS8/aTDxgboM26a7lVEg4rh4gi0=;
 b=TsRDejYEHDSvHQ8rK9sKhYX1m5Jix3vk9E5bk78aUZYsgWM94gZ8vcL8g8bMXECElR1ooiPju11ZuKK4rGnBHKOJO1WBiKg9mLJaJmUnb3j5Qp6y47b/G0gd/V9NlbMGqNrHWAIfA0c1dcgaEiYBLrOwfacexkZZT9iFg1K3UO0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5034.namprd10.prod.outlook.com (2603:10b6:610:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20; Thu, 26 Jan
 2023 00:33:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5%5]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 00:33:18 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs_admin: get/set label of mounted filesystem
Date:   Wed, 25 Jan 2023 16:33:11 -0800
Message-Id: <20230126003311.7736-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20230126003311.7736-1-catherine.hoang@oracle.com>
References: <20230126003311.7736-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::36) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5034:EE_
X-MS-Office365-Filtering-Correlation-Id: bf1f24d5-1f5b-48b3-2304-08daff34ebdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwBWrncm5e088b4fazjw8w1/TEb/6J8NGO697pu2bqqfkwJlb08Kz0TBt6TgKbKxe2o4m4lVQpwWPFOsXYbQ7S9+G18tuhvwubtcnQaMsbkeh+vAeoo6lr3/YebvJITBiv3bWEFymr/zNBgBE6OhfVkmFT7grHPZC+k5DhFdjJrbm38Xv3se5VisTCPlYUvDoYsU80rQyK9GX5v4fUsQRWUvJ/nVk63IQIX6nrq0gH8khGfpdNXjvt376NntQVmFhj1y01Rm6b0tTnRuMrr1/V/0yVz4O6fYEgfhFF0yrG7h2as5exau1H7AZrxYQFpsBEhzFdnxh26RNpVIRQkTmpUYzciLtM6M43Xcbv1Tryje+u5stC0SxMp+zLAkAec306weYrUJE4RlQhAh+tVC8pipWXDppMX2ahP+7h5wdT4epDF6fVvil4AGUbYcXs4gBGelcgQw+KjyOwaEZI9u0RoA9Udt/zeW8bzYp4yL8cs6624v4VffwUr9SlIbhQ65gGr47Q37IpKEq0ujuCFFatm/wveU6W4W2XSH+EBZNN8SGMYRK+q/MPAJGmoCzLDMA1BNjdLKm2wVhNHaRbjAJVK/u4VzGbn/y5DaPZnO41/tEeIe6ThxiSp5GaYhzqKqytNIZm+OQmUpRJ5feTGVCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199018)(1076003)(66476007)(2616005)(6512007)(6506007)(186003)(478600001)(6486002)(316002)(66946007)(66556008)(6666004)(41300700001)(6916009)(83380400001)(8676002)(5660300002)(8936002)(4744005)(44832011)(2906002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ER2JpdqpZIFS9+ncvDgpuUMSeMgcxK4f6hL7jmoEBXs+sP/WVhcikN2JOxH5?=
 =?us-ascii?Q?EIgLCNx6Hm3PRzIUha/vmPZRDARe9EelYWn0buz988XotOAoU5/MEEQ2bMSP?=
 =?us-ascii?Q?lpXaBZUfYGej8JopR25FfTHU0Z2vZrf/i/XTYjm/cYm/L7jDziC0KWNwU8vM?=
 =?us-ascii?Q?LAJDXBItrzzTbo4Ph/MpunQylwWmT/25UsJXhqUnVuInPEmkfccrVq5eaHzB?=
 =?us-ascii?Q?6VlghQ3mpR+2Y2ci43R17c86nHSd3NPTMde/2X3TkSmCw5P0PlyvBNG+vNnU?=
 =?us-ascii?Q?bP4o7JyOIjvTY9oxoshNm530y6vZMRX7zwmt2tw0WZEqhCKZ7/MYpTDkk1Lr?=
 =?us-ascii?Q?1GvtmQPCR4lKZ+w3BNDGgG/vuAzsSVrhX+wA6sFxYqsfLzajH46PffU0/tU2?=
 =?us-ascii?Q?mBNWLlLqr5kAUXpMzi3SUa8yKovOQRrjHo7bVaaGdEFW92kT/tmDjEg0z4IY?=
 =?us-ascii?Q?EeR5VoxgNeMGkjL4+a5QPiwEPLTY2Zzp3XQ0srxknG6FimZX3mo0/iZbm0+F?=
 =?us-ascii?Q?wkDEOqtDFX+eD1KAHRlf5FfqQ+bvXl3glC3ZwCTXIvGKaAvWxoTwbYgLuRR+?=
 =?us-ascii?Q?BRuW36txRF4FNOcF91UpklVoSzFWTbIKtENCpkwEB4iEs2fsMNTz3tzv7dGD?=
 =?us-ascii?Q?+P/LYnZJ5mWz80Sf3AWjJ32uGlBC2lf3TTktjukPGrO57mZT4V39nazXT4Yq?=
 =?us-ascii?Q?UKXM4ImCHMCleyFVu4aVTOP0JsR7QR4fYncZu/IRek8ilUzF+7NzOsgOWGPB?=
 =?us-ascii?Q?55tmIZaSivhZ5mmUUZ/elq8EN4ASaeu6QpU4Vdzl+F2g5+Q2zDxgdRFqrLm2?=
 =?us-ascii?Q?or1PJlXkoA7nZ5CQ2xVL/Nkbn0t7AXOkd3U5764fUltCdsDQ09HA79Gzu3Qz?=
 =?us-ascii?Q?mmtye+TDuN9M2LbdKBIb3wfJEx6g3Qw6vcRksiKtJvAQN2qYE2S4eCTYi/EB?=
 =?us-ascii?Q?pNjx9caS970h1GCpEbrPNMOyYlwXqVfGC2muRjp4ZveP+h76buIYrDW7LbII?=
 =?us-ascii?Q?vxLo/Cv5pSIA4foO0fGpAr4N1i06APpRtaW91VC3LGSnMrxQbX35Y0YX0/l7?=
 =?us-ascii?Q?W8HRVjbxgNQTjEFNZEZVdzOwT9F/k0oE1uLj5gsSwOSPvWMT5rODioMuQ/vH?=
 =?us-ascii?Q?xvplTVawHzT7lnmSsQFjXqiFJEPClakoMyrdESaFYRF5NGSanuVlqKWP+RTN?=
 =?us-ascii?Q?R+LJfo6eDvXoR+44kwrQSqfPBV+zpRXN11lopV4qZ+ssyoNT9G1uRoMw8YWJ?=
 =?us-ascii?Q?6JRYjIseu1j+FBVSbxIb2KLayPkFpum5lzLuPXdHWtl2sVuwQDVRiXlsol3u?=
 =?us-ascii?Q?aD0DZ55qSnYCLHBQ4vXonVYh1p2iIC+ARqA4nizXJWtYx3Tk6MtCHA19bj+O?=
 =?us-ascii?Q?IQfWjvdG97mLfLLuzBmDIwgjf+q/bJ70uqV0i0b3/O84aDSGPH38dhTI+R08?=
 =?us-ascii?Q?tpCdyZGEMIKyusTHa4XOBr6jyTXrpHyVP4IcmEksRid0FCnD2TQn/k6bXu3w?=
 =?us-ascii?Q?+6CY19I3XfyEU55wJoh7fx5wFhlnXaO1qDEWoSpzIKmj/1gSARcEZUbn7e69?=
 =?us-ascii?Q?njfdv71h+hpRSib77YWb56WFfoG71E3PdShLTQqGhY1CAbV0qcilI+WEw5r8?=
 =?us-ascii?Q?4E9J3tes1phI6DBHpArFyE+uZN1MfdvsQ0Jcka/NNWeMvZcjDW7QGLCCgZnC?=
 =?us-ascii?Q?+ZbsKoYRy9q0dLS7dymC8sbC/R0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: O3ffm0CFV3G0+vaZCzOG0s291NRIfiMqO8TDsWLAveFAqlMHfhM0xfDqfxDwFMzE1loWCfuWzPlw2GZNEkLAiIwtshHWcIc1rgPzyN21GNy5kJGUurF0gPMulgjx5n3KW0fGl3Khlk8HJXhRpYdjdHFLoPgC/njWRfsHMy68KO03qTcFzHX8H53rZm3QPyE72TiUiF6v17CKeJXGyBe9HnjvmtAmFs8BBM4A1CM0fuH1Nt9UNcV0Fcx7ALI7ddzJ1yVq/g0JrrMUShHnmXL56oRIJlNFShTtYHaaKSHC7rhBtaMHbbUBWZzOWdSfYj82VweTVxfEAp4k7HG9EWeFumU23gE2dPlwEPas2Kv+D8KuTFKp28bDUXXlPS94eF0ik7082DH71V36829tuXrubUqWhpRAUOHW6G+92VuJigas/4Xp5NZZK/7mv1DWUurwvUDn2BqpwmYPBlBrtdSOQwyY/i5AOq84Zjf/kRQscrNzYlAzKh8h8lcmTPm+6rEPhClVYLXNWUVrRh1Jelj82cbdelVUDJM+wRBKIRoOE8DvE26Tr7tqD5pM+FFd59X3p5T1h5aVxtz31aZz1sIGM4WzeYkk+w7yGUnvfm12RmiNCbxBLP32gwx0lLjboOBYEoq6ykro+851xzYc6I8xTuNEIkviRdjiduVAB3VoI37COIkI3QSosy+0oYJlO1IGx7kcqjaBzoBSdPN6FaSSY3hTfqhMDTcheDxvdPZrZo96CfDEIZH1oHidZItING6nI2FpR9bmq6O1yrfsjoJTpQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1f24d5-1f5b-48b3-2304-08daff34ebdc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 00:33:18.8051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +r7mRXMbj+n5qvV7CIjQ1ITRqFDsdCTF8d791Mof5Z5xo9IWmm5L5RhNrYaeRUuZSIAmm8z7rC58FH2+nojyhvYicCHsMP9/U10AT2UaZRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_14,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260001
X-Proofpoint-ORIG-GUID: 0qiXn-hTx4lThGFigm5V5H2acnIeYglr
X-Proofpoint-GUID: 0qiXn-hTx4lThGFigm5V5H2acnIeYglr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adapt this tool to call xfs_io to get/set the label of a mounted filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 db/xfs_admin.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 3a7f44ea..cc650c42 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -29,9 +29,11 @@ do
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'"
 		require_offline=1
 		;;
-	l)	DB_OPTS=$DB_OPTS" -r -c label";;
+	l)	DB_OPTS=$DB_OPTS" -r -c label"
+		IO_OPTS=$IO_OPTS" -r -c label"
+		;;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
-		require_offline=1
+		IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'"
 		;;
 	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG"
 		require_offline=1
-- 
2.34.1

