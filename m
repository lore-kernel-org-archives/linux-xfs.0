Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BF6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbiCUFXK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344413AbiCUFWv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22BF3BA5D
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KKxfvk031084;
        Mon, 21 Mar 2022 05:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xtDwGgb3RNZ0JWX4nRkfulvNNayHBkXc8538czjYslc=;
 b=x5GeOJXuOexsDEPgR6Gzv0ptxRDIHQ0Ym6+LiPvxF2Xb0+DpcClwqGRLgd9xl5RpStN6
 TqY1xdckyshtjLZHUnGLV9E15TVrkvJZRhCqoca9sIugeYS9ZGlfyrtVmVuqPnYEoepw
 8c9nBrmozaNiRsDIzwMFDkCcrzd+Y1u0+uHAUiYE1ARvyF58b5gEGRIHFvAvaMoNEnRB
 L4xSqp6LQp1RVydP5OfM3hLr6d4orNGuKZpjLECdKeJCVxDO+tEFhw5RTtcosz3EyjJJ
 cNkw+r8yTfmGWhqHEX5NyYcIvTMY5PxfQysPNbrqosBjCYrSMC+XspxQh4bCK3TyG/UV lA== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcj4u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5LJP9125328;
        Mon, 21 Mar 2022 05:21:19 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by aserp3030.oracle.com with ESMTP id 3ew578rnvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ni/cj89lJ2xkwLlodI/y2JhCNQkHh505sIdOxVu46Fkmm6L7DyCbX9KYoeUdxu7reWkXIe5Gm26+oenD+lnPZ/m1dg3NAJshHANab7m+IL7iK1lCmkQvrPHhBlw1HDSRAt7jD4hJWo+XAlo0R19v0fhLkhTzUW4i8uqCdpKhzIIJQ7SBXDyEeYYlcPB8j+UcLgmoQ2SXkrH3fXBdlY20pJj6GOY2w2dRKVLsUFIq4jM1XGtvqEM6nuRqG09IeTZwFMNiVNuyuXFUGQbR34wtzMigfpWb2NETtElEHLcOMsGCKfLCgU+eBDIJRY8bZQ9I6eyVVtP6IoHXcig10lONJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtDwGgb3RNZ0JWX4nRkfulvNNayHBkXc8538czjYslc=;
 b=AUOTWVylZs4+2aLAtypw6l9ZfspEFJODDaEx97OyA3WmgQX31Dy8Ll/rqKaL2wyPXbfj2vHI4AOuVclD1DLPPbI+W/94gYlq2Itvv+16yniI5tIuvrR3A3UHYlWPn9FyZ/q/4CsKP8w6CPCh6Qe8Pwu2INb0GsgCEbAielhdMpLDn9cE0FGLb+MObs3ssUvnYEJWy6KtaJDT4u3soCueNnNDKqR6TvZoNByVB8ps93pT7Rp0RD8umkyScAURwmk7gKcVfwM1qneq28WiOTXaXdExS4fcu8mAx/EAD0O8hxIoUZ6E4aeMJ8iN28poRvmAFwOoTFYoR1PscFC35MBjiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtDwGgb3RNZ0JWX4nRkfulvNNayHBkXc8538czjYslc=;
 b=mjhuU/aUcF/4Het2Ih6DM2E6hys0NViHi7veR2PFXavYwwFOUgRB7aoTHzTQ3U45l/4xoGdpPadOxvBjkAzkoH9a+85I/LMPwLXv94FQG+dbEJTbwZDlG6i/jk7nZ2ry6N4j2z5hoH6r9cvDfCWbJ8n5rQ4vLY7uZoWImIyAuo0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4473.namprd10.prod.outlook.com (2603:10b6:806:11f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Mon, 21 Mar
 2022 05:21:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 17/18] mkfs: add option to create filesystem with large extent counters
Date:   Mon, 21 Mar 2022 10:50:26 +0530
Message-Id: <20220321052027.407099-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f7f802a-3fb5-4eef-d907-08da0afaa060
X-MS-TrafficTypeDiagnostic: SA2PR10MB4473:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB44739CB006DB721DC38A34D3F6169@SA2PR10MB4473.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f62DhrRygT5unp0uGRGoGkydtu18A3l52GvMYrY0JM5l0QJv02B4cGhE2uwKIvbqX+MKyAq+15S2Xl5Etv81koOiygXE8Ltk2mj+va1KNxDHl2oziO3+zlVHjEm8FuI7qnwi1Kzrofw1NJDW5OtorTZ+hlewTDald3MLhxitTxbNXIpAN7rgCUCehBFHGpRw3URewa3rvjA4ALGHDhgTS8Vdu76SchK28TVXftmld1PT8PI43xP9UfFaMt0R65fuPUgNPX7iplNy8KlTc9KevkcS9VNJIGQDziBvbj3AGGrxGJ5EDdsFmH37GI5vFVp+o5fClpmRpyAFCMZXu8flvhR7Kgh4IPs9M6EcyK4Pjrx1h046KQYnUWDQoHFBQ86OjbHX/CXRqo8PtHUtgpTC3GJQw5jWMdo6KHDXYk6QmakL8eiAJB90nHJCouVsyNCUmTEu/p4ShxTyDyzfTSm9iHWiJc0K7oRtDvpK7t4n44w6h4SqJuPeFb5KRskjsxYVhoa3CyO5YX93eE1L22ZNe1prxqmxb9pLmZ4WfuAFM/85RoG5KI2fwePAniewMRZ220UImZxrTjQiWTcPjiAXxLKGccF/JC058RThX0vmnMJ79hs7rdz3do0rMwlzWhJ6VxilTDniVNHvUwKd9wPjqUdD01aA/j7BagusnueSi6+HqkhODwfLWBl3Fym3wJQSsv7HfUGOP4mdGtTZIDznDwYg3hAp5ZPj8vBWMX4cTcjp+PqYNyPUOtJHdkXzNYnf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(2906002)(508600001)(83380400001)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(6916009)(86362001)(5660300002)(38100700002)(38350700002)(8936002)(186003)(6666004)(36756003)(26005)(6512007)(52116002)(2616005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DrUEDqva2R+M05uXQEiQ1V772Zi40xrudsGuseWKzG9gjLWk7N8d0M8PShxi?=
 =?us-ascii?Q?Fpwk6HNwppBjE+ivh68LubZYUO9iae5ZDEc3xo3ky0CoSUvgixBLWZWBgztD?=
 =?us-ascii?Q?cmZl81YGrrDA2NI3BtFej/dsmCu9ae+CKJPg8it5KPeWrUaT4/1Zt73Ls9+9?=
 =?us-ascii?Q?sG2ERiwNreaeoNVFC4WufyvXoz2pLaGkM+OyRQVTEfM6djy7CpbdNoFfl2lh?=
 =?us-ascii?Q?SixMbBetSvT46sHy2p9lXeLI6AZLw0xfRmjzNwgd9YNkVEbQBd36/a3WuOMj?=
 =?us-ascii?Q?BNb1/mTOzHBQ0V+HwakjR0JaW6r4Ul3R66U2y3Y0pJc8HY9vSw9M107vbOY/?=
 =?us-ascii?Q?UHkHQdDaatEoSIuoJmnw3PexVGRdUR9BwmMNbvw024SHBRpOhOV7OHcyF1nC?=
 =?us-ascii?Q?qKyN0cyyjitw7lISxNTv48PlkMxJyCEt6geOASwc0yLCKRWHZb/+C33xZSbu?=
 =?us-ascii?Q?i1z/PboBm/x1iGNfgZcrQZuzgdXwAsHMb0wfzSR6Q7bgJ90ZkJp0cLdPRsWb?=
 =?us-ascii?Q?K90/djikXuqJlm44PBFaLht3vS4jm+KPEwLxKMYx7EYkeWknNV77Gv9eURmF?=
 =?us-ascii?Q?mXiKlGdwAp1iZtLeXdYlvmVixQF0FAp4Hi+qqQenflhcffCxcTmYxYzHBp4H?=
 =?us-ascii?Q?+BoCk/g6G6G4SVKGRyyT01ILIxfBJ2z830E5shj24n7BsFndp6FYpSy2H2AP?=
 =?us-ascii?Q?VNVHrhAJTn9FBRrIU4dNnhkMPB+8+fxCxqX9QmffE6L41Wi9D5rMOoncr2PP?=
 =?us-ascii?Q?aMdkg9AOy/uMtAxw4kfIRxcFMiegpXqFx3vHSd8HZr22IBFh6Q437ndlHBuj?=
 =?us-ascii?Q?Wqh4p4G488Hd1Epo0zw9O56uxstaWiw/+0f0Ru2gZZI6z8uoy7zpoJ+cgewo?=
 =?us-ascii?Q?5cr0uXzuNFGY+RpQyu47H8JSM6e0vwjZTZOQ0WVcpAqzwn/M2QVAh79O7/Ud?=
 =?us-ascii?Q?/1Vj6iDkqowoS9zIKMpC4jh51ctV5u/wc+rAe8uXIFADcSXgtATHnwQ0IRPI?=
 =?us-ascii?Q?fnhwOUmtp+df27qRZaE2akWCX+l/kyJP7fbmDbPpu0ozsDlWRoEjzKEnZ3y0?=
 =?us-ascii?Q?HCwiDgNT3mqEgYDr2hdkjWldcgkxMAnRfrI2nFLWitQ1BEzRrQOpcAbqIYtj?=
 =?us-ascii?Q?8L2jmWreB5+zwXop3TXSVG7ZHKtGwV3rD5wgPVeHp9sseXbd8vTVI0cMI9Rj?=
 =?us-ascii?Q?ZE0C5+uF4fNccCTfu52jQ49O6Xn0QGqEQU1I1JyNOi69NVcR7+lROEi3bWVB?=
 =?us-ascii?Q?oOt1w8/vHOueOjON036HlDzNm828Cpr2S4YeUQbjA+zCn5gVXZ4P5YulOFYL?=
 =?us-ascii?Q?CDx90U1Mji4MApVd53DI2JDyTYeEi1c6R5nGgl2MVeVeUvRN406bz5MHVbsN?=
 =?us-ascii?Q?xyxKQi3sUlsp9wr8co+K3yC/59/ot92o8O2KJRSHTa8QEAPnUmE7tn5Sl4ff?=
 =?us-ascii?Q?ZHiRlMawf8uNRLGCJvgnaLRpqiT+AlaobybTc1NWQwV6C1cq54kh9Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7f802a-3fb5-4eef-d907-08da0afaa060
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:17.7649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N2tEcF2cftuDpmFQKpkE7hDFmntV111t8PJmzhW2g6PAHPYFV35+fesI8WHQFFCFOIzsq6w/IIMKUpaIs++3Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4473
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: hxbanqYr28_H28nqdHmNiFMbK2eWEIis
X-Proofpoint-ORIG-GUID: hxbanqYr28_H28nqdHmNiFMbK2eWEIis
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
index d8bab2f0..8ace6200 100644
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
+		    cli_opt_set(&iopts, I_NREXT64)) {
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

