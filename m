Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A12C0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjGXEiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjGXEiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:38:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5713EE54
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:38:00 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMM2uF006375;
        Mon, 24 Jul 2023 04:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=Mlw/5u+pld3Zt5MLocYT8jQ+TWdTuRwF0Fitw+qIPtiwTioXYFCtNDWZ8oetCXAMq3we
 5CfArUODzjlfE9B446dZtREsXXKwrpyt0RBCVVbrTRCdtCmuaItEmvtXslPqUTFbPl75
 aBViU6HBYtG8Hii2Q7D6iRFi1O8h5V40NsxgDqCVGcBN+cTCUCAgDhudGgpPzaVZwBGJ
 w26WxofJrjrwEhtxanZa7s5H6SWBzyECTIOjL8xBesMbwWeIzWah29JSjz/A/DFss7Ot
 +w/jO+RFxamswQzXeqvSeFCq2YsCSGUSr4Fx/5JXY0U93cNSwqV+jSAeXG5z82p/tOQH Lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d1u28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1LJh9028655;
        Mon, 24 Jul 2023 04:37:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j35yfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jn6tBvTNbGK7OpeQ2mNHDVmuHnYGkVMWt4627S06Mx3w9P0rTgvGN3VJiSQrNn4pFnQ63DtBQBPy1ceEO6CNEJysu+zBjQuFbBQAZSb3u9V9Xiumj9qFReVC/rkYmxz0jkWWmqsDM4yJmwTHNotdkcj/d5Tzw+IguAb0P+uff0Q9dMAfKj0ihkabbBDaoDhbvDzQJpv0JN/ktqqbaybDNvoQkai0B5RsUwXlONFfMdDGi3XZyMTlTYzBOZrzAQs9mZGfBECoGS+FXrwI2y88dNyZsKc7puRTMNt16NghZZjRp6z2yLjvVxV3VQ0pcBDQ4WcKaeAxcnaMiFs/6Z0iZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=d+c6+Kh964952y3mpx5+d6dcbL7z0Q2IsrPZEfAQ+cfbMHo1IZGe07tjJfYW+viSqWG6EW2Ar/r4SXnQedMqaiTpyJ/fYcY4Ek6alGf7pa7AvVDqqSw6u87sJ93otJGKh0GWA4X4b/QM+aJE/1dqmMnRjk2AYu88ZZuCE3+CqSATkMaLYelP5+ykOvmB1WPJu+/M5v0U2ytw73QgKg8WARahD0ktZq9D0aVV6tHo5CCyj5OJfkjwC7p4wnw0fAJWbBbCQd/Z2VzwAsnUSbLpbnMYaPiXIufU97iw7kBcSwtznQOyrpVtkTMWYAZayOrTHeWrSIwyeXy8PssWJFJJoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=CHxyfwhh2OfYbVqTEUwggtyn2KzG+VYm835hq9cjsEAQhT93IOeeeo1PH1eWtS7K/VsR4qsquUKj7UxP5GYIHcn7YBCluVq6e2y0clpxaT0dadh1hVbCNuEOcsJ/TYW5Q6Wp2SPI4Hk5LTnW+TBPWvTfJwTPnsVSGkUqHRCVcaQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:37:54 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:37:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 14/23] mdrestore: Declare boolean variables with bool type
Date:   Mon, 24 Jul 2023 10:05:18 +0530
Message-Id: <20230724043527.238600-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: e8ed66af-3f9f-4bc2-0519-08db8bffbef7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJJdOglSYPUt/a8H2eMkMprHSPtFnQnwL/BFmUfZAvi5spEU3JE5cfFC6j6mfsPXRSJK0j4wLa1QEAUrBKNnoN4ApXB4Y1ZFUDGP9qCZGYv8Emt3KZFIZxf0LYbZZ8/UG6IGuJCD6gaaSauyv16R2+NH16MUbyjOr+pAXeyqxxFRAH8Q472eiYtweNBmB+XzGt7Pq9SrN6n7vYGGzk27eVDC2iavomo7s+3nFarw35KL3I6JXrDT97J0kDMC9FOJMxgwwk0nGz6Hw7QwTV6fT+5gwDA7BqRa1jvTZHIFQKBtmXtXVJQK9+oiT7Q/RozdZMHn6MbU+rdFmF7ycABSY2VtR1x6xGABDwJtkNJjHjHfTAq0PmcVx747xqACdioVqkv0Z2IH68nIV6Rv6aiFB0O0UzreP1KWconpJf8VV6WSz6IbDO1rKY102M1Q77kOTe8vEGeo0V/x3ZYG+2zgCjNXrLX7IQ1hh3TinoG/fXEb2pYHUARuzB93aZ2Uug1d4TEs77AqvwzCE9DoRtJ+tg1Ysk/DfX+GVpzXWO3pto7JM2xJryo2syesX+VsLXZ+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L/d7EFgFuEOIsuoSwNcQen4Rw7Y0BhM10JBHlpKxbKGPQU4eMlMwetJ38/GQ?=
 =?us-ascii?Q?1mgt0Gt/bc89JhNAWzfpkj74Wf9/+gz9DE34N+6psVRUesx5P/VaaJaKr54G?=
 =?us-ascii?Q?nGJEN3ly5gkc/2ecLpdwYRlIumIcuX7bdhZAg/vz3tOhjGB8AHk6evMjzxN6?=
 =?us-ascii?Q?k9Tja5XXgziddt4Rdv0b0lp5BawfvI17XakXav0vCD0ipj0PM8h5/NZ1IaXI?=
 =?us-ascii?Q?7I0Zuy9aIJHcxMyl9SM+QzN9l0VBC+7c+hq+RJpvG3a3Kw+/fu6Ttv2EnXx/?=
 =?us-ascii?Q?qymz65oIBI23X970TvQKFICORfFu743VGqssltoGwR+G36cNdWpiYnueKs1R?=
 =?us-ascii?Q?8nSEuPe495r2aG6VKXe8nHwpLxYrbvPhySQZ0vcEIgL359sOT1TF+bnRqD6S?=
 =?us-ascii?Q?z1MLT/ndTSlKh5HfBefb/YxHV40IJA26YEAF91ZAgF7bx1Z4nS0JtGcSAakO?=
 =?us-ascii?Q?Q2jd8k0G2RO2k/tEeKHuOAvSxsYi4mvb0C6x7FAzUrFoievr5DjdC0BViOMI?=
 =?us-ascii?Q?//8HXVlRdycHpQLH1UrWvcGrt0op7SPRqjvN48WQX3R+S+DmHda5iFRWDrbc?=
 =?us-ascii?Q?f73HKBNpXGYqoXmDYVwxm+uD0Iy1/MTS5rCal4zTfb8UqLK/fd3GEV7giWSn?=
 =?us-ascii?Q?ZQfkVMuKrqY1NnYK0k1tLte5ez8zOtpjI2GMOwH63v0fh++InkpCIYHwCwWN?=
 =?us-ascii?Q?2U3s6Bw05oE7j/+vct9hfm7vuOrK5j9TC1R+sHKKFPzPK9oTZeGjfjnt9cf3?=
 =?us-ascii?Q?NARoH472COOHG9AXNKf/DkKs3BmeJ+AioFFvivKEFj3TyzliyLs3svCNlJgD?=
 =?us-ascii?Q?ERMQjxmDPoYR4lFIkntQOo5YUbsk79suUjHlRPJrH+Y8Y1zapkdNtOsSErID?=
 =?us-ascii?Q?pqwA3/2LFN7EK4c11Q7ZdKV3+FPKOF//xPzhbaCifDHuuyuvDkPS5RV8Fwzh?=
 =?us-ascii?Q?FFn8vpnpOrGa46FJ7mimsIIjWSc0AcRijnRTx82XJnAtPU/cLpeS1cQQEsc9?=
 =?us-ascii?Q?H69gVQs6y7ynJdB8mYNbYNIkhErO/1N9+dMVTrT7wIxnfntPJBhcTcwAf6Tz?=
 =?us-ascii?Q?EfcGwQFM5zPmyIbaWl6NhzbYXQGw1pwzRpz0vvL3SxDY5h29AqZSRqEIXNiU?=
 =?us-ascii?Q?55rdUWS887D1f7C3htpjajHT65zwSOAfYBT+2yMsili4hjRzdyt/JS8hkEp0?=
 =?us-ascii?Q?3zNT3COXkbkvCWqOazVPEfEMgjumm9PPivhx2Tg1DTQWSf4QuPqw0ClyAULj?=
 =?us-ascii?Q?gkzQw6cmymT5IAMHMmexGl9uePDDHN9QByIr0hr6Y5z0vxfRThHwZm0gznyT?=
 =?us-ascii?Q?VarAQ7nARIZWudy7KFm7jvbmiKV2biwVpqlnPJSZQMuyEkocaIqQOCv5sn2x?=
 =?us-ascii?Q?Zz8F8KwBOAqzGlNgLjo+LaSEtTvQT/3RUvAsHxwpQdbbctHnkkcVS3Fi5d8S?=
 =?us-ascii?Q?sVv9Gf9ybPeaMrnTFnkW73z3LrBdvmjIv0h6NahjZA9CKczo1g5mfKa4t1af?=
 =?us-ascii?Q?OFyeXNp7YvqBHSim58mnd1D2U+WQbHzhR4ynPjDjCRK27ZxAOsjS7kBLXVJH?=
 =?us-ascii?Q?PfbdFsvMdTlJNonbWeREH3R/YYARula97XjS2Abj6Qq0AsZRNv/GEG9A+XLL?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vOZUKQKwbBwGn5vAMTZEcRGsSEdLB9ousRczPv6+1kXvpcXL4FnWFBIjw04jegRc7pg0XANXQe96Z7UUzGdah0wzvL7icPByFoEx8McBkEy+5n9n0IZhhNgRp22VAZRnnM1pPR8BMhnlzzuSiOwLUq5qeRNGHbGRpNW8s1YF2oKg2JAAwbTP1RcW9qf8kjiZpx7n93H6dA8Kefqab7JxaQAUt2LYOXoeSCnzPezIETe8TvoWghjJMTiF8/NKO4I6fkX40xFai4yqfWwRltuOKJmTgt/hP6R9R6UnC7WARZ+4LRYI9zug14vYBYigDKaTMhVSLN/tdAcJmGQKtjq9qlTFp8CMPy4wouDTzlUn6+HFWUnza9MH1m36QnCqwz56qBVo1gYHnBK+4Cwt1YFziwZvFDLNYAnaoGtzOXxXW0D1ieB06N/afTTWc0JCij2CdXfCmglVdPLHo2T22ywRrxysTXOjWF3mQeLhvAHExDKXVhcIg5irsE71h5HoJNpJzwGd6hRNiMtXqlLvX9L3fTrdP84x8WgvD9UtdPjTJRhuVxjWO2BGSE7PX8+HwTr/A3JXzY4dzb2LetPxaEaHxzurDhpVFtUyPeIh6iX3tFuhGKnNrihM8LVopBIe147G6nDDgCLMpg7qjNjMwl2CpvaYbXGXyERh+Lw3pUaNP5/wIiqkzM2nllBiNqvrR0PmdVFHDoxvBLA1aAd77JgQcm01bh5agk48eX01n0sQa2PUAuEYvNXtipuaXxNH3dKjTA8fJWCn+1K0p/Sz5qd3mcKI6rt7bR1rMUfAqAqFChg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ed66af-3f9f-4bc2-0519-08db8bffbef7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:37:54.2465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YjTL7z7GwiTo8PrHDq/VzEl9Jsc7u73crge/ABxQ80XMcZKeriBItyPVyTYuWE3dNgS6JdKK6zsIeSa27egm/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: ihaJ9Ttr4vAye8ZdzsgELaySKURRNV-V
X-Proofpoint-GUID: ihaJ9Ttr4vAye8ZdzsgELaySKURRNV-V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 481dd00c..ca28c48e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -7,9 +7,9 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 
-static int	show_progress = 0;
-static int	show_info = 0;
-static int	progress_since_warning = 0;
+static bool	show_progress = false;
+static bool	show_info = false;
+static bool	progress_since_warning = false;
 
 static void
 fatal(const char *msg, ...)
@@ -35,7 +35,7 @@ print_progress(const char *fmt, ...)
 
 	printf("\r%-59s", buf);
 	fflush(stdout);
-	progress_since_warning = 1;
+	progress_since_warning = true;
 }
 
 /*
@@ -202,10 +202,10 @@ main(
 	while ((c = getopt(argc, argv, "giV")) != EOF) {
 		switch (c) {
 			case 'g':
-				show_progress = 1;
+				show_progress = true;
 				break;
 			case 'i':
-				show_info = 1;
+				show_info = true;
 				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
-- 
2.39.1

