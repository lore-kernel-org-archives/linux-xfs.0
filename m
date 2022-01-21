Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2E1C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245363AbiAUFWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:22:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35096 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348151AbiAUFVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:24 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L03rY6001013;
        Fri, 21 Jan 2022 05:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8zbs6EAFd8pRQbgqs3lbZQ1tAv9KenYT23xrR1FEnYw=;
 b=0XUGPTrPRRHyrmLv+2UKiNpxYPU800U/UChbDu/xBlSiiVKmOhYZ5r99VY5cw1nDBNkv
 7MhtFb6iI865MNjPucSnnLI2skEU1LWjFntWzkQ+kXVkMtCMKA765aHGoOLUcZmuPI/a
 TId2l5VzuVziE30GOFC/PTceVEbBAYIGcf1lIwq+2kFyIC9KVqlR7cHqciqTe/mmsadO
 JhNJoRwe4Cp08yjGEJpTkvCcvCPUJzXlfH4zmK3CUoyrk37ER312FnmP9UIVTNsPeyrF
 bIMGShBOsmabjxfKgZYHvFD8ZZODfXJszyPJvN3ADSA9kATwdQwAljwhDNCTtdAtpuBi lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhy9rcq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KVxa007045;
        Fri, 21 Jan 2022 05:21:21 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh1dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0KzWmLo3pLUhTbWAuNOESwrBt9l/+o/f9lZkc/LHhDKLt9VvrvuDgq3NbWvxxsVVsNdurRmQJG/jcvGwc9/zJUQk8kK/HW66ZsyfLpQroZpiV3TxVI0ZphWLU9qy/qfYHmTqRU4dJl+qtrwfrKtEMMsB58y94BTECBQ/v6hdqPEEKtwnro2DZ0W2oymXjzcZflRtT63NaYh4APuH2Ju+NByMPMOmerIgrdy7YqYyPA73X+49c4LloWmHQXHA2rXz6YsDmfJbBvOfF/hMtCedyv6c2GdoWuGh9S9N1Zt2LxOVxulHhPnkWuIFelZL5hsKkytdWooDamJV7ABuubIdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zbs6EAFd8pRQbgqs3lbZQ1tAv9KenYT23xrR1FEnYw=;
 b=emAUfdL78mQpiv2YKr9WtXGHclAyPSzitJVlKHMNKOMT/8XlXSNf9CFC8s9rX4S7FaTHtDejQR1OBLA92Oz3Qvx2qBoSQtAQJ6lqc+LN2C/mZjMKN/cZqHvGB8hR8X1ZAwZvXXNsRVcCtxlObskJI0YS4T8NRtihuqHGQi+Hgot/6D8RoIHsNBFhoYhECVb9qYfTSl5q9p0XmeE8DOuzCJ0lGaMS7Xje0ZH+oXQTjANPRr+1BCkgLhis0fgvAUp0hLf9NUedAZ1ZU8JDL0/46FeYObY8mYHfbHx1alZFmzxQFT4AXdTXItIp7oG+27ch46MNH75iq+qjLn8DenfTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zbs6EAFd8pRQbgqs3lbZQ1tAv9KenYT23xrR1FEnYw=;
 b=0T3o/b0YwZ/dicW9+hohUX79Fm/UbQRuPL9tjb8GsBe1dfjiRSg0iQV1ekPmdn9JWCbZZWwpChX81vO7tYDXqD87orulINAoXXUsnQSVvyRW0JT2TuCz7fJXBiOBr4OJwUrPyAirk+IsuO9UkPfQ2v/4Mh+Fl3ZN2LfZqRhTbk0=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:19 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 18/20] xfsprogs: Add mkfs option to create filesystem with large extent counters
Date:   Fri, 21 Jan 2022 10:50:17 +0530
Message-Id: <20220121052019.224605-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80eadd12-a6bd-4066-e8c4-08d9dc9ddad1
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5322B1E89E9E3EB6F34E77F2F65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Cy6c4BI0lzh3IbQK67IC2oVZo7voWRD1ejnp05pIg271Ncl4+xjnLPBlXwLajnbOECuinuHOfy4XvSrr3h1l5OqmxcvJXKY6mzgTuFftKsx67535LOqsUPJvQz767SLS26ziNPB1RiL7s2ChKJW/8rNXUDdPGK5lnHGTdjQyG7JH81U2CLQS/kagsXog1JQ7F401RvfxvTYzrD6xG9auCI/pDfx82s1YK0a3bQxBH5lSO+BcyjV8OsocL7YVaCLdgNM81qDZnM5RJJyUa7Tk6DTrkzlUTMjVctz9H3Yh4qRP9FhXAlatOxCqc49a/DPadRI1JTRLBOdWPcSobdHVp7Z57MkMhT7sGnIbXcc1ANwA0iIfYuiO+OnP8E8ARADgyT5TQETJH5rJ/oAOFS76qLHz4Id95LFFcQ6WMOjgbRbud/H8BAsmTptrd/lED6M02frkJZH9195KGGYCFXZUvGr5f/134oCZ8eY7Y+cRoeRrncoaUtbZjvPKK+HFPaiMIfglyCmQSEtDRxtvweXOKUBb2otA5dkD50ta8ijTey7gKbsNj1Cj4/V6cJNA5inwPu7DSDYw+lV5+0NoU9OI14sIEaLKWgNm5GSHQRWTMTGSp78mvermKxNcp9hdCXvM17VggqAR0Cu6yv1vl+XC4fU0T4kqSB0u7Yj8nlO8Hf2V+ogYPimNHNjLh6sLK9i7Ddkq+zQO//YzLcsMr8fLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6g5u8GBOb2Wrr35GGuD3hV24+KYoC2Et+JSJqGSSOshwu0nwiex+VTlaFtEu?=
 =?us-ascii?Q?8/RW923pMajZQ4+TmJnHtrCam8asEl21Rbz4kKkW/saKvRGICTK8mHD+tRzh?=
 =?us-ascii?Q?Q02cDZ/Stj2M63MzSh1AmLWPG4l+XpR14NBIKn4wj5jdkr5oyfDXosY3pFA4?=
 =?us-ascii?Q?rpQTTylKk8Mmvrq8jBCCiid9KWLi7eca4hwWvwCoLRPyRjtRqUvFYEmf7Km2?=
 =?us-ascii?Q?cgtnQVDMWoxoiYbb+9qJWTgoB56e9RL5Is3hxUyV9HFMDNGPUWhIfBWE2yTd?=
 =?us-ascii?Q?MunUOkmjNt5al8TBvJA/sTFQuKszrFxNReXv5bQ20J8p2F7TiA2AthT1nyLb?=
 =?us-ascii?Q?ZQBQhU+pNPKk6suV4YI95zWro78aB6QrQLPDpmKwP1dqhwMv5RGVAGu/Yn+T?=
 =?us-ascii?Q?9vgNq1YP0fJI/SQ9x1rDAuqJhCH/0X7x1GmD3WZBgc986PL+DI9sN7FsrsM2?=
 =?us-ascii?Q?JKJjQQfySLnTJnqpdq6cOvElWaCg4YRKC1JZBFYAKy0k+/0Uyif71zLSVE7r?=
 =?us-ascii?Q?QckBa+SJI87gXVB5zuOM6Vw7BamgEGVg7TDvpKB9M4j+q23A6fM+awe2ltDR?=
 =?us-ascii?Q?xawmOncpPneMSfqk++OsNj8dF3bXOPT0NbNYY72S0I5IWeANm2fEhMkDNaQr?=
 =?us-ascii?Q?p/ynEPFU0aZ9a03iUThGrj6w+mhECwbFK7esa8uluABIj+DVUVkoCZhTrCCd?=
 =?us-ascii?Q?DCXmMWfOoVzVYn7wpKZHyllbrYFyqh9Pwq3cS0wUWRGMXS5VIYvZC7/iD4r6?=
 =?us-ascii?Q?CF2X7+qlF8tAasCt/F3VmwofxNHabI3Nn2l5w0E23vonM2pIkm1UMGGnNIU/?=
 =?us-ascii?Q?wvNr00/CjYQFhU/rJJ2QkXY/59EXBpUx9K4URkVnY7LLZ2R3mE03Pah3h3l7?=
 =?us-ascii?Q?hj15RN82JmO1mCKYXslyNI+agXv8xqdtlXmIADQ0ZVe8J7bqfSUebrrsDsjM?=
 =?us-ascii?Q?YGCuLJjvamNdR072EVbPZJ/88cdMJ15dyaeFtktggF5dWqdGa2fdM6CFW+0n?=
 =?us-ascii?Q?LhPkhj0bCjETuEFFU4rxTcs1y4MC7le9b0SEk+QRKyXlUdvSAY1VB7nelM1P?=
 =?us-ascii?Q?jpaabQGAeLOhmwiiEatZ3pg2PLKMYe96FgLkhi3W8tGjH/yLFw3ooMYe1ljh?=
 =?us-ascii?Q?nVfECGfCtaP9mdfn+mBMd8bW5J+RwOJoy1t180EKby2xQl4KNx1Fcuh9tprv?=
 =?us-ascii?Q?iKGmKBcgoUU6gNhyHL/7Pb0tAu91z9CBtm3am/DA8qtetgFg1V/4fnW5r7Y6?=
 =?us-ascii?Q?MUHmxg3bosbSGaQk7zxhPCQkvP5Ha7V0ioQy40gcq2R7PrSn6f4Q+XTlQyr1?=
 =?us-ascii?Q?wzQbmMYUIbu/GjnpYbSb9rF/aywLqTIkceG1JkDg/s93maepPYOKNPQSciqv?=
 =?us-ascii?Q?LZE7zLrSfEv5h15vcLmeeXLV1vRDggJZa8Y0Yya0d3zH7mpZky+E7+6GlLXV?=
 =?us-ascii?Q?+lsF/eZ0u9hAUe4lbffEtipjSj6B/pDOV93jzh24ti/iE/jQdWQ4UIDBuk6m?=
 =?us-ascii?Q?FIxU2duSxKXrdjBDnd2j8IaRZ23IBpV55DnEBtZKOamL46TEq0GvOPQJxpma?=
 =?us-ascii?Q?nEnRoZ4gVJZyJQdvNzLlovXOBhctuXqTutXSBs/booapytooA3RxgH/XXFVf?=
 =?us-ascii?Q?3IcAsJ9f5MU8i4B7vCcRGiU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80eadd12-a6bd-4066-e8c4-08d9dc9ddad1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:19.3332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTWxITAR22US91B7Ee5dg0VKoFKspYbL06crPuYJlGtadHU8NRjfRiB4P4uvAn5sV2Qk9S+myh1iA4eYV3IJSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210038
X-Proofpoint-GUID: 6MEKD5WMTDfWkJq5LlM4sZU9NlenT-Pw
X-Proofpoint-ORIG-GUID: 6MEKD5WMTDfWkJq5LlM4sZU9NlenT-Pw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Enabling nrext64 option on mkfs.xfs command line extends the maximum values of
inode data and attr fork extent counters to 2^48 - 1 and 2^32 - 1
respectively.  This also sets the XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag
on the superblock preventing older kernels from mounting such a filesystem.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/mkfs.xfs.8.in |  7 +++++++
 mkfs/lts_4.19.conf     |  1 +
 mkfs/lts_5.10.conf     |  1 +
 mkfs/lts_5.15.conf     |  1 +
 mkfs/lts_5.4.conf      |  1 +
 mkfs/xfs_mkfs.c        | 23 +++++++++++++++++++++++
 6 files changed, 34 insertions(+)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index a3526753..7d764f19 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -647,6 +647,13 @@ space over time such that no free extents are large enough to
 accommodate a chunk of 64 inodes. Without this feature enabled, inode
 allocations can fail with out of space errors under severe fragmented
 free space conditions.
+.TP
+.BI nrext64[= value]
+Extend maximum values of inode data and attr fork extent counters from 2^31 -
+1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively. If the value is
+omitted, 1 is assumed. This feature is disabled by default. This feature is
+only available for filesystems formatted with -m crc=1.
+.TP
 .RE
 .PP
 .PD 0
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index d21fcb7e..751be45e 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2018.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index ac00960e..a1c991ce 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2020.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index 32082958..d751f4c4 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2021.
 
 [metadata]
+nrext64=0
 bigtime=1
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index dd60b9f1..7e8a0ff0 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2019.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 96682f9a..28aca7b0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -79,6 +79,7 @@ enum {
 	I_ATTR,
 	I_PROJID32BIT,
 	I_SPINODES,
+	I_NREXT64,
 	I_MAX_OPTS,
 };
 
@@ -433,6 +434,7 @@ static struct opt_params iopts = {
 		[I_ATTR] = "attr",
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
+		[I_NREXT64] = "nrext64",
 	},
 	.subopt_params = {
 		{ .index = I_ALIGN,
@@ -481,6 +483,12 @@ static struct opt_params iopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = I_NREXT64,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		}
 	},
 };
 
@@ -805,6 +813,7 @@ struct sb_feat_args {
 	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
 	bool	nodalign;
 	bool	nortalign;
+	bool	nrext64;
 };
 
 struct cli_params {
@@ -1595,6 +1604,9 @@ inode_opts_parser(
 	case I_SPINODES:
 		cli->sb_feat.spinodes = getnum(value, opts, subopt);
 		break;
+	case I_NREXT64:
+		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2172,6 +2184,14 @@ _("timestamps later than 2038 not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.bigtime = false;
+
+		if (cli->sb_feat.nrext64 &&
+			cli_opt_set(&iopts, I_NREXT64)) {
+			fprintf(stderr,
+_("64 bit extent count not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.nrext64 = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3164,6 +3184,8 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
 	}
 
+	if (fp->nrext64)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
 }
 
 /*
@@ -3875,6 +3897,7 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = true,
+			.nrext64 = false,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.
-- 
2.30.2

