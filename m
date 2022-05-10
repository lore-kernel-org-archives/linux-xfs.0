Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E904AC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 20:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiEJU2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 16:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbiEJU2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 16:28:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E1B1FE1DB
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 13:28:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AK344A021122
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ZN+5YUtBoEog34ly51hOa6LAvS3Im+uupj9tCbzzMyI=;
 b=iPJsU8K4nHS29py+sDmP61ZFUH2zDip1swqpbIFGgYKWpJwUaVWVbPpDqUZtLGcqEObs
 kvYwGzpFiownvcjUo6JnmAY0gJiz9ZUESnr/DF4CeeVgTQSpLiT9kI35krK/7d2PCHJ3
 TRAZMUDKmj4YR0mH7ORzX1yniuxuRd6zh+gtc5xDz3uo+1iVvGodZ268ILEkqLMglDUK
 olaITZc8ZPN1hXFKahjAnxo0LgxyAgQ0lKN3jpU0iH2cythS6O+tJ6S+CyTWMDmSQnUX
 GvdzCy8PoyXLv8IFu5KWGIH1LDMH4WqS+rI/Dw3TslUOhuzWwbFTKnjc1NcdybRIBuiK 3g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfj2fxg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AKLNOQ036202
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf72s0tq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZ7ds9Bn34gmh+FaDH1ZiweE1CwGoEIg7xBkwSz07gPkGULx6EdkjX5EQjDaVg8G7nuPECkgInGil9L4HVNWgoL3s0whXBQNZjLIDGh56ZdPlFC0CgibYC0rG8BqGsmQ0H5jLNTryns7E/MmxZLCXi6oHxO4RbLo33mLp9LjxouU3QMqFEUiEbM3tr6tjz39B77oQBv1DSk4fq+0rh6HQlhtkjhQsH3rfthbuTG7HJMiq8PlV6jyXYBSyGin2hfukMpUHHVRFvzHrnDIlHyvLay7b2G2u9cQw6Q5hFPSkSNYZedgRgZr+e7yzdQFeePFayRFeHnpNUSleJ7InfXUgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZN+5YUtBoEog34ly51hOa6LAvS3Im+uupj9tCbzzMyI=;
 b=VhxtC896JSODzGxDgN0yS8dqwQBamPWIn/0+e4BGcx+98I1Swm+6UnrA/EJKfYNm+dR73YRcgFviyuYovFgu7uHPxo0VCXAW9htiUkK6F7NPdBp2Q05vY3C+Knp5zIfDZTmMtsfvVX0uJFQoNwWcqXHw5+v92bL8LyJfBbJuWzhU+LEgd2lq7S8tQrMdBNMsTS8Nmg7AisUYhaLsJYRSEKutiZEOfcE2+79mBykaPWj2oGPxx7NG+sYJQzRSnRhX2iq3nPDhD6m/hoq1wcgyARgiBHb+hTSJ8iiT8jFlglaG/H6mPbYkan4DbHgxnZ4VlmL9QK1GdH9XXT+HNVfNwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZN+5YUtBoEog34ly51hOa6LAvS3Im+uupj9tCbzzMyI=;
 b=LfuUnVrkqzG63felPKDyTlBjMVwDnlvqNBwUAMfSVv1e+MCm8jn3tSnPI9vyRZ0Z9ZRnLhYQsuEJaST4qGzajdRsY5VZ6Tx37uiC+ckC0txHz5fFwyQUTv6e5p8B1HyVaT8uEJf9f9WhA8A5+rf4eKVHyqE34PyoBmHO4V85gLw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM5PR10MB1626.namprd10.prod.outlook.com (2603:10b6:4:3::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.23; Tue, 10 May 2022 20:28:10 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 20:28:10 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/3] xfs: don't set quota warning values
Date:   Tue, 10 May 2022 13:28:00 -0700
Message-Id: <20220510202800.40339-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220510202800.40339-1-catherine.hoang@oracle.com>
References: <20220510202800.40339-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5280b34-9776-4e52-d64b-08da32c39912
X-MS-TrafficTypeDiagnostic: DM5PR10MB1626:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB162695B3AD26C371484E734389C99@DM5PR10MB1626.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRQv/l7W81skEWJkdVaZdBXR5PoqfXPpwqaua2c3aFHJOKXbz8w8SyqVgn2O+at9dQDFsioEhs1Ij+GdNnh8rcd10MKGF7GLW7FA9hgli0yQw60jB5Ctln1kt8FIsTnTgCbYYEDww777PvTkr0VLESAQfWC79vzLRBf1DvszKbb2fO3qRKk9cHK+u25e30mYon3QiK/rkpGuAkkZeYcEX+pw6tr3HL53yyEH1Tjwy5FhAxl7GvEQYvLjOmbuLOs3kuFZv5HN3I/abXb+lRaSIGUZf6KI4vP4E187t/mGoXmg/U92dWVUVKPlekloAqpege221JsLxqq144Qhky4sBywmbId3dbYvshhAT9ewEjSbLJiYlVbjV91HyQ6Mfr555rMR1lhxdpFI9RUxVEcJQ4Pb1hM81XrvmVigG1iRxeO4cRfy8YQPWU4qw7x1Gevc7JSbe3KHN+KswZ9/gGzwOExcCSEQSbzedyNpRmz6PR0uRLcBu3sh8s1zCU/P2uaR6A+9KIXN83TSHMWW8vtm6LafX2GR1qi8f1sSvmx7JHQsmc5Mf0i99E5zGuGJF6sg5eWpj6/eXzbSbI1MlEkzIbmlWQHHmb2vphYE/fcduVFUyn22uTOzyvQMKdC+hr4y/75hbaBgo21tsZwZa/ZeRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6486002)(508600001)(6666004)(86362001)(38100700002)(83380400001)(186003)(2616005)(1076003)(8936002)(15650500001)(6512007)(36756003)(5660300002)(2906002)(6916009)(316002)(66556008)(66946007)(8676002)(44832011)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cWPO08NOeELjJ0mLq2Cr9k9oAlEARB4DACglCvA8vFTe35OTkBg4vtmVNpog?=
 =?us-ascii?Q?uddtFfSWqQzUMCyqglftTZObcgp2k1bkKnBR1286UDpkRJjUH6D3zhXnu82y?=
 =?us-ascii?Q?iyuAVLSmG9hqoL3Oly1FbkfsjAicMJO3PP5kN9Xow2MD+d4EBETf/PaE5HyL?=
 =?us-ascii?Q?4C48W36xZckBFy2Bc5c7pTjDebIx3qYIWHeGnKiAFmMJfyX+B+agyQ1JELKC?=
 =?us-ascii?Q?5KoasUHxC3a8pZGu/yQCFRegpRQZISx5VefTXANOoip/Twkg3H2tTzOI6Wlp?=
 =?us-ascii?Q?WRWbt/xpyV/0gwl5/qhvWEHRF7FcHH25SS1mwZu9jD7E/M9W+o9TPa9CroCv?=
 =?us-ascii?Q?FiCTcziW4W4425N+viyshksbv5kUUnIl2MO++2pRXgwE92ZfsgAb7MMwRAEJ?=
 =?us-ascii?Q?jVu9DMEIgFuRdFTfjwBU/YK/No+z4ABziQdsz4En6TzNz/L1/OXn7aVypE1x?=
 =?us-ascii?Q?3W1l7/cRVCsaBu0HbqjSyABh1WHS+FRGfvks66Z9xT5kE6nxmtdh3v0Ns3kp?=
 =?us-ascii?Q?Nb1wldCSLgXwXhOp7PAz4or88CkI4MgIFMfIlNjucyj3FeeN8o/ra0LmfEsl?=
 =?us-ascii?Q?N/CO1t1u9Xx2GZBWM+42C+cHsV9HV0niQ6mRXKmD9HjaSXm0F24ffxDl7DcC?=
 =?us-ascii?Q?dqL3NUoOKd5qTgttEjfgrGsXgpHQ6EMOQlNHlznHsySAsh9jlfmhlUaMGFsC?=
 =?us-ascii?Q?9rCScUv6J4XYbzDA/7A24mNLNIghN34pXe573cOMuc+ClcVlppXSm48JjL2Q?=
 =?us-ascii?Q?Iu5e6z6Jhc+ocUURqvuajljjoxmk/N6FeXLKWOQF49RkFd0AIrrPZIQGDbzY?=
 =?us-ascii?Q?LX/QYZ9AdZhXLQDbSrDuIBA7SjhSfknmghzyoyxL8x3Ig8yFDTiD7GDUAbuW?=
 =?us-ascii?Q?vC7KddXFHRLb2+Lu4Z3GN2GOJIkmX77tbDCMyKeoJ1VvPpzH7N4cK/NrSZ+Q?=
 =?us-ascii?Q?MsRMUuE6lK39Mu9M2cCR48+vZRXdR9dYGGLDfCLRdl3gkkK/lYN79xBNlDwy?=
 =?us-ascii?Q?hFdkdxzv9tL1EYhETZnMsQTOF0fDEZnHsKrJvBU7fXAiQC+p1UQijh34yrhp?=
 =?us-ascii?Q?dtY2KP2ojLb03+R0BH9cpppgQToaexTeHxJVyI5aIL1ccezC307ubNSG/ohd?=
 =?us-ascii?Q?ez8XrDXNdXkVJd8UFd7KEpTTRAXIA1X+fjkOc94XU0BIp9DMWLX1yO4RyHLA?=
 =?us-ascii?Q?5xV5UZwg2vtAMGOgXOGh2X+PelEuEI/iPzX8GznbFXzBtGHxs99PQDrD929I?=
 =?us-ascii?Q?SO6b6J5r0cztxEHXCiEsTa94L14W6Ole++XILRpJObhimT5IINhjB9svyT3z?=
 =?us-ascii?Q?opsnen4UJrL7V+CqAsrDVYelLNoa0Ib5mB+VsD51GY4gxdcyKJs47+Te9s5G?=
 =?us-ascii?Q?oMC49ICK3e2drCfakq7ZSeAWjH2faoZFSG4OdTxzFI0Sy8SAZLs4ol6GOjYj?=
 =?us-ascii?Q?JF2ziVf06UiFQa3xv/KFdXGbr6LoUpYxQMyJGl10X+gFiWU09NHRKFsE8h7g?=
 =?us-ascii?Q?i0msEAnYhC9z2tq0ZzDR4X1TBhr1U568EIBkT9RY7HXfrdF0hTjJ0KVSNUUK?=
 =?us-ascii?Q?uWFxkE2jsMb1y64JN6XJdfydi3KdA/JfQPu9JiSQSH79yYHesuDMv4ZeyM4G?=
 =?us-ascii?Q?GulDBkNMVd9RwDrkYAlnj/Di9wa2e7aChdfhlsdFKhXTOvReyvZHKNRyoElt?=
 =?us-ascii?Q?oYNxThaGODRbTvOA5Rkw6bqydEWNFPgXq098Tcjrdu33JaXeUsvXi20qQBKb?=
 =?us-ascii?Q?1RWciQ8pJFTf758Bqz/MUI9B5jU9MmLHB3kF3cIBIS7/3HVJu+k+s/QMicBG?=
X-MS-Exchange-AntiSpam-MessageData-1: 1N2HadyyUqzK5szJNwdFiwwCwQN5A7mD5BI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5280b34-9776-4e52-d64b-08da32c39912
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 20:28:09.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /lgiYdyph0XJXlQhrmq74LU6ocJ9OKJ0FiOeI45s1x2CTGIjQS1w6+TsR3jKTirL/QHNYlirEIGsI4aes4b1xDhDUgYr0CU2fNxdvxnsp+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1626
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_06:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100084
X-Proofpoint-ORIG-GUID: myCTDzKFY7hS6dGi_kSDvGzlepQHz5H-
X-Proofpoint-GUID: myCTDzKFY7hS6dGi_kSDvGzlepQHz5H-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Having just dropped support for quota warning limits and warning
counters, the warning fields no longer have any meaning. Prevent these
fields from being set by removing QC_WARNS_MASK from XFS_QC_SETINFO_MASK
and XFS_QC_MASK.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_qm_syscalls.c | 3 +--
 fs/xfs/xfs_quotaops.c    | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 2149c203b1d0..74ac9ca9e119 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -217,8 +217,7 @@ xfs_qm_scall_quotaon(
 	return 0;
 }
 
-#define XFS_QC_MASK \
-	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
+#define XFS_QC_MASK (QC_LIMIT_MASK | QC_TIMER_MASK)
 
 /*
  * Adjust limits of this quota, and the defaults if passed in.  Returns true
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 50391730241f..9c162e69976b 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -98,7 +98,7 @@ xfs_quota_type(int type)
 	}
 }
 
-#define XFS_QC_SETINFO_MASK (QC_TIMER_MASK | QC_WARNS_MASK)
+#define XFS_QC_SETINFO_MASK (QC_TIMER_MASK)
 
 /*
  * Adjust quota timers & warnings
-- 
2.27.0

