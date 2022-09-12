Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83B2ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiILN2G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiILN2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:28:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C58303EB
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:28:03 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEYK5002664;
        Mon, 12 Sep 2022 13:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=onk+MzrBF85ZcZxyXwbnjDn0E52GZUpMZtRZupwhTWI=;
 b=SgbsLdCX67ezC6hNJrAI+zacEh2bZV1XgaYMhV04O2cPzpkmQEP7RTfmz8ysK37bXoJv
 D7s3u9q/eg1A0WY9KMJqs00erB9Q8vSjbCOBBeYdSVZy3hnEDmuul/ZEfc6jukkv9JA1
 G9Ery7DITbP+tNtAD0U/DDiguqBvKg2EOasWEqsIIMSALBCr1CLepztq2JZ0su2vRUlL
 +/94/sd9KdlzUU9EKr8PX72tsfoja4aDPSPfSr4qkLrjI4hXA1qLzXzHZRe6gzWLwGBi
 AaJ4dqYMqN9GzVTutpDqSSgToJcn4mBa3eIilv9PbDy/2R3x+643dEwoqUdt5D2wFLME PQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgh0c3fye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:27:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEghX025070;
        Mon, 12 Sep 2022 13:27:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12a741-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:27:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLCdmgFjRdPFO/J6npniI0jkOj/UfxjZBGHzbIbxlTWl4EkfxpwoSeFGmbH8qQQg66u927HLsG62O9CSlNdwOlzpSHfsud4iKr5NjFQ7e4zxsMBLEYoo4jsGg0EhxDQpXFq5SOfMsw15Em73vAy+yEBluhME6FRugJ6Bh2DgTPX2Q6W2DJTAKk7KjSj/rDzLfh0GERbMezRpYUpw22A9UsfJVjn5IScDgavr+v4iaRX1i7ZLKtYkwEH4P57O+BbYmpI3398JRjTU7IWx5U39bslDdkGMx6ad6JdePWDC8X+Hcx3VuKdrQIoHm5ejvGztaay4YT4VFUTn28xSfE5blg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onk+MzrBF85ZcZxyXwbnjDn0E52GZUpMZtRZupwhTWI=;
 b=XDHXfULhPbfXDVwoXfPg/jSwkFyjIeq0viI+fLULEqfaRGjhKrSsEjzDChb6Eoi7eVnZ/l6VsEB4lVRDIezFZqdIckZD4SMIsEnJxhuZN3KkdDNsD3ZsPKLa6YXenjjhS/1QlIgOfPmnEK4MBNfkQFuRWrG78os4fa0cp1fkuUpGdmZs623XV0ZIWKHGJfPKTNKr6jfuzzbgEQmpVakohJRIEvd1LfXxhxEjj9/SdaeqgKL67M1EgBIjFccAN9ykERIVRUrU/95UcSDhAKsqQFjRwjiYmWhZY1pXf43wT84Xi5lb8vN6KWDkw0JcfZFx+/aMAHiMVM2zUqqRol8QRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onk+MzrBF85ZcZxyXwbnjDn0E52GZUpMZtRZupwhTWI=;
 b=XxPPyKrq1mP2kEeJmw4ne+u70YZMu+rl4DD4kcG4L8h2GkaZ25pJzYzMpDuNuq3gPrW7Tnz3rj2e0zkFgfVhOUv6k2O4loxiEkhPeF0d6sR+HDvCRhhXwFiP+Ekif1mMeHtAi1Y45GZMraoOrUiysoUddDFQI/MxhUIb2aTTcmU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:27:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:27:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 01/18] MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
Date:   Mon, 12 Sep 2022 18:57:25 +0530
Message-Id: <20220912132742.1793276-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: f339b29e-ebf4-41bc-18ff-08da94c29a85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tXnhWLjqtYCzYiD9ckOkn0NFBOAHqmGz1eT6QnSBozbgcBzTKur8pVlRAYWdyMAAO0ZA6pKVBSh7lUvOSRRZkz2o9HBO5zRxt1URI8gfNHjavYSr4Ccee0sbTHlW3ayOvq/zbp7OrXr1mVlhCDw9O2vaT9KU9i6/D52aAp796BaX29RMx7Ia2nApm/oEs6sAFlxIBi8u+SF/okNkvRmZ93rYHSzB68qktjVB8r7+pyzeXO8yK1eLzS51nR449PBKGETF+wGUAMF6vofZsFXe/sbAyPwOVva1EhB7JMFO+JQ8ungr3FVAN3vvRBYqwMO5MjlVU1owK1Wv523ZyETPIa2Vq5RgzkPqyPwjXRPinEgq70LYmnk6rR8s3d9NqIXqlj0XaP5Mq8PFkWar3NcgAlY1jKiklAJNnbsttILiFQRBbqStrEtiMFXjlDD0M9f7at0KHXT5ykWXDKXSa/3TcV1jFSHLpXa3OhlfLUoyqYI89FT3t9qmcZlvKo22hmwskN6SPCg4fzteKvzSn9yAxh9EQNSM4hAEi3PSpgC/hsivapLt+t9t9I4p40oQj4N1pMqObinngimwLTJNu5HNtyBfVdzyg4qwL0md2Ognr/JI/DE9wKa+RjGQu7pLBBdSIU//lWpjbSXeVLC1LzFKcko3gbErG62GtXwpsnkvI5bRjhfy9Ro3FyP7YPWTUrVus+IC3lT/jJm84uKUOpEcDMjppylugRAxxac+22mbkC8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(6916009)(38100700002)(6512007)(2906002)(4744005)(5660300002)(8936002)(66946007)(66476007)(66556008)(8676002)(4326008)(186003)(6506007)(2616005)(1076003)(478600001)(26005)(83380400001)(41300700001)(6666004)(966005)(6486002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hWo9d46ugLocASYZkkX4ZnltVxOVVGnkHulvOX+5boNg6WmvJLuZLAAiieVy?=
 =?us-ascii?Q?yNZp7TWmcvQ9CFlIrJCSL2f67Kym4N3VJ7a/63CqWshniEflEuwuY2ANZdZ/?=
 =?us-ascii?Q?IG3N/zSAggfiboPkUy9mM5oJMY0zag4vWviuMvW39McrNymi0N4FKPDePrGM?=
 =?us-ascii?Q?F5NqOpniIRReIdQmD4Pq9t7ALhIA6FQdJNcFkVocLIoPAsaCxVC6gp4xGvcG?=
 =?us-ascii?Q?YOC/iaaxmukyq8fn7m11h3YiKESsei8yVbrIzpRY9EpJQghd/IXderXyk9af?=
 =?us-ascii?Q?eL4kJoOCh/ja/l4yaWfD8TRiRXVaVBq1di8w5ZRbE1Ud0MVA/7DXZOuwEY1g?=
 =?us-ascii?Q?XRZrLPr9D5jgnmAsOdVINV9k/euRj+zZQ+HEgRpwm7wWGfrLDAuWIZfqFcmK?=
 =?us-ascii?Q?08cJ5YrVciYBCrXnlGlfx4C5PwCAjhUdUCLdcEZTitQ//hLFf6uruP+bOIml?=
 =?us-ascii?Q?DHg5aA+8yTzoFLTJKwQwC8B95gK9JgqDzOagT2ql1pehidkKcXOhO2vBU3AE?=
 =?us-ascii?Q?tr1IJNSJKhigRfv8/dVn/hO4DkeTZ9FQ07RvUT49JLVVZpUDzbjdBOf5Cs2i?=
 =?us-ascii?Q?dlbqJbxH0T8K7yB97oxOLso8CNyOesfSPdXOV378ITX+J/pv/C5SJMnVCQ0v?=
 =?us-ascii?Q?5tXO3F8YiQK+AvYTuJT/ioYuDpCk4K/+7FgQcA2hjXAxJmGakC9QOhOVk/y7?=
 =?us-ascii?Q?DTE9aOnA8Ai3OBGfDbIaPh7BPqF7oSf/VKKMEkVTirozvqfvBSfLlssX/ijB?=
 =?us-ascii?Q?ACvs42zt7rOAm3eZgrbH+JrmJVYrkrYWC62RbMK/UnHysJm1xiE0gtRnTk9H?=
 =?us-ascii?Q?aT8Y4r4lMycTZhZ3cEMmFCRxEKBh/asatLGIzXbLBIebS/LLCY4uZ88qFoBV?=
 =?us-ascii?Q?x+RN5bVJDdwJbcEGtGOGmj9+qsGZwRD9l251PMghUDP49hThSBB1iEkXapTB?=
 =?us-ascii?Q?boDUyGSoKRQtf+OUdvpNspCh8eA4Bch+LEMMisK6vcA68YvJbacCO/zeyUea?=
 =?us-ascii?Q?ekCTGtZSnYCzhy/ooHNqqoNpU3g0k1TXGvoWjc0NKpsvHw6ZrgO3uRTtzWIk?=
 =?us-ascii?Q?c9TWh8HV+qZohv4bjmAKgI410cnzx+vXTII542UARnm0Tok7oK8W5LMTxLVR?=
 =?us-ascii?Q?0f7lFwoPQNFjFNLcGQGQ1AuxBfY5BLdAaM4eodH7XwCYzUjE0opGt0H7ZRuS?=
 =?us-ascii?Q?p2yGUEDQ5Ud6l48/JwpX9TR2cpRbAc0raLaBBFE1IjxovWF7vWdW2updBvR2?=
 =?us-ascii?Q?xPx5Uiyp4/p0SJAScpyPqTMyYH7WF8uFN1tP9FNHf8nS/S36x8TBn7KjSWt9?=
 =?us-ascii?Q?mp07p3QBnZyPoNunHNr7M0OvoaS3Tbn7dL1jhrgBh7kFrYxZMwcp7qut/+A9?=
 =?us-ascii?Q?+XnVBJsVl3bIHt7S4kc4g3KYBioXPF65Ypit3QbxMvDT3JY1xxIDe24yFffI?=
 =?us-ascii?Q?LgTgl1+ZBg70r1wbiuiBT3smmYVmdkHa6kOstS90iFkAmtpVXVmfLhRu3GXX?=
 =?us-ascii?Q?nMX1TylfsMDL/3VDMOlblwAmw5sFUBc/wQPHF3sUsQ4gtaA9GlwSRtqnC2uz?=
 =?us-ascii?Q?kD3ABb3oCMhW93a5Fp8DRREHDV7s/zQquuN603UCvObLZsyo49fqVwVyG11L?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f339b29e-ebf4-41bc-18ff-08da94c29a85
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:27:56.4264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5kth1tHvgc3ExEmUdIUF3U87nyEOTXxBpLuGrKnvMzyiBZnvIK+9cnzc6MBTIwGTvIFrJ+ed5EbbeiI6jvmZwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-GUID: uzGeuG5emqS1SsnwQ6ndzr0SAbTJyCq2
X-Proofpoint-ORIG-GUID: uzGeuG5emqS1SsnwQ6ndzr0SAbTJyCq2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an attempt to direct the bots and humans that are testing
LTS 5.4.y towards the maintainer of xfs in the 5.4.y tree.

Update Darrick's email address from upstream and add Chandan as xfs
maintaier for the 5.4.y tree.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f45d6548a4aa..973fcc9143d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17864,7 +17864,8 @@ S:	Supported
 F:	sound/xen/*
 
 XFS FILESYSTEM
-M:	Darrick J. Wong <darrick.wong@oracle.com>
+M:	Chandan Babu R <chandan.babu@oracle.com>
+M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
 W:	http://xfs.org/
-- 
2.35.1

