Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB5AC7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbjFFJaU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbjFFJaS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8712C126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356612eU009154;
        Tue, 6 Jun 2023 09:30:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=bwoEs74Vh3Dw80zN8jiFW56tbx58MwyXDnWCjeWwXIQ=;
 b=PGvYn09rgMhudmbiO5LPJ0K59N0IdiAyI7fZrH3CAEgjBt/dREWV0og4CZtxH/lSIm42
 P9UZ2NYs/tK2cjf7K7+W3YuX9YT7kRuRfGzpOFOVBqYSBDMyptJB8JKj7IY+OgqIhuzM
 nq7ankLpDCCycD7m2dEVRl6HYrIDnP9C5zjyzKIIpUPhs+fwn6BE8nhE5YOAq9ajjSuo
 eCorLR4s0GCuzrB3RfHP+yv6ijiBANGR4MzAfbn0RYZkff85fcHlxvBOnm7vHklypB7o
 mfoqtQaxyzsSM8rrOF2kqdFaJI47HDNkwEVdSQGSpA5CrcpeINZIGLBUn0PRnc1Q4+XG 7A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx1nvx71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3567fuee011244;
        Tue, 6 Jun 2023 09:30:13 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tk04rtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fowf8LqrOIodr9j1irovSbO/VsPoOuTHw4LS4W2lNzTQB7F7074fBtwsxqtTzHOlkt3pZ/Dxx8fGMb2OA/brfAPpBVomP0SGTyZVVLuxjHBYrGUdd5oRzOrDWVjpSM+j9e6FDGIRBpx+tZfH2LIks+MOy1f1eARbtkEpIGnqhX9jyu4tBr6kYcFuYvvsvUMRSD3s0woaiMOTFmMlmlCSm+Y+vcscnGqqrOlq9+4jAZoxhw1yZTfcUcW2ipTx04vbwcaszyPCxNIt7RnimuIdJ6wZNUk8JwVfl0zKspgehFO+uBM2XYP0//v7fG9aKbpWi7zWIzO7eiksUbu+ezoqqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwoEs74Vh3Dw80zN8jiFW56tbx58MwyXDnWCjeWwXIQ=;
 b=cOsPZULrIzrTwHKkITno8HwqS4wnG+UnE+TSZ1Mhsv4qVwKwGwr4yUY1KWqLVNWGdpFg+qblVtoeQwwzvqjFxtUxvB8T14D+ZaKgPukzWrsxbo/Wo/W0wd1EFOaApKbpxBesJI+H7pqCI/T6tk5ePEk5p0XZezNH9OxVii0odaMO0IngG0UIeFdkVOx74pMXVGbhOIxCTBAsaNsL3zPDiYYm4Vl2dJgdBxD2Px00TMPVbp4q48NMdA3sIue/pu3HL8uCjGpamD2iSAhf61/LNv/aZYVnJoIqSVqlNOWoCPBHeFez//lD7V2SqG+Yy+W3jqa/FC9vkb0+UIzfnCP++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwoEs74Vh3Dw80zN8jiFW56tbx58MwyXDnWCjeWwXIQ=;
 b=m2LvOfZSq/rE6fxJQAeSL4WWC65sBculX0/VEkshJipwmEEzTPkKRSyPV9ULpv7cGp1RqwUrrWT3YOm7jFSD+JMDPJrjPl+2kkUFVdQ+SEmiSd3O60BULFBdl1HRrnOdIOz3VSDAWwetMRQ+ijgqq9IPMTD86LkfBXcaGw+5rlI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:30:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 15/23] mdrestore: Define and use struct mdrestore
Date:   Tue,  6 Jun 2023 14:57:58 +0530
Message-Id: <20230606092806.1604491-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0185.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::29) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: 4501e754-10a5-4023-8a8a-08db6670a054
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: agpL4KWN8m0JrJj25LumNNDngwdNGr0slKfcqlp8b2mfR8UyDrK+TqJC1OMcFRJNbembbD+z28orVvheOjU+MmhkqGgkUrAWJU5fSOetF3pGwJoukVVOHyCpdJKGVk4SdS/z941XkKw8Ees7Itz0U//oZS9iJCCQLaGUKH3GiLJKyqY1OlxKiw7GjUTsf6zFh71Ofe331kvktl4xqFvwwkw0TVjvIreHeDUlAl0fGdFdv7Djf+w+MculPFA7nftREUWpvQjKio6j+YsTzHHvwLyYKkDswQAKoN1oHDCehTAwpvZjX5adn/WrTgNjPDgaR7TvjXGHqjlHKJoJCS+EPKLm72C4srtKg5BMUHsueivTrKTeoAmspPznGnbSSHQwzKShfcsTkj60IQ0uPFY3np+YLtexF2HjfN57ZHLWztqnqqufVAKW4PxG9ugZfmJUdhPjbFXUo/ROVxaDOKEwH5HbiJvXZC9wzJDLXMHYDro7RNHrxCZ2jFWOiNjqF6bVNR1moceFpC8z4y40it1V5SjoM5cfJdbQuj4cxS/lLWLqo4IWwam1DLxFnMmxK6TR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PrqaqcaK/FPdd5nphJY1rVuBHyJpCJwcVly8jsJN2bccA4FekA6zFWZIP537?=
 =?us-ascii?Q?XUDKjVGzXpiXRn4FXtWyNaPbNPNtjthwQpHZrXwUOgW3rIdQsJFnYkipbzUV?=
 =?us-ascii?Q?9GyxoA+EXNzRwvEzyniwouPcdb43vYFK+q7Ckwu8YQTL0MTI+MpCpWgsBfT4?=
 =?us-ascii?Q?hMfZw16+gCkpRDHgu3wX62czchLzKsYwcp7/JVk0EyKXglhb3lU5jj799t/1?=
 =?us-ascii?Q?RbjK5YXDzh3ZfN35x1TJ5N5DBRrkd9224X+0R4ssBqodupnUST4QOqzAHNHC?=
 =?us-ascii?Q?mTO2+0XxvPJkuYwZfzhIsWjcZzTP9HSL8jPLrXQgfJTD4bpXNBw7njNgrutS?=
 =?us-ascii?Q?Q/6WmKQX7NDE2iGYjU/JN5v/BY4GDo6NYHbjsS6WPmS8zKwNlTksDRdFRD6y?=
 =?us-ascii?Q?1FLC1qphjVvNpwmm7KG7LbOCp/y7ePcRCVHAMTKpyJblVZ+k4TAtvUkyBy16?=
 =?us-ascii?Q?ZqcBJjaR3/LcfQLESteKIDX/JptX0FdUVbguMwNm0dy9+iib8rWfUFIlJALm?=
 =?us-ascii?Q?AVPUpkK/s5xirwJUXwOBD1Txg1pXfw78a1wEF9fCINWWqsiQ8I+2UaZGkiiV?=
 =?us-ascii?Q?aF0R16rT1oq8ID2woLsNPp1O5F+RLunMTZOTurp6H+AuYDglSMb1484r748F?=
 =?us-ascii?Q?+6YoCfQXdOaGlzRBZZ44Khe75RCNyXrhB7dKKFMM3PqVM4SfYuoHflEnU5cp?=
 =?us-ascii?Q?5hXEu9jeP0Xhz8ByJDQAqBhJVO5almhLSMvrsWsTw7wKFnuUNJr21FrKVHjh?=
 =?us-ascii?Q?05EiZMlHQTodDRCHe0joqZsTXBfJi/Ir/6mhSOSh3+gZ3YKhC5gBWmpB95qJ?=
 =?us-ascii?Q?5TJKZSmsi92j9fVkt9lFUS3y0cQmaWvpad88vVGtJfG8okvF/V/aN0DltrKd?=
 =?us-ascii?Q?3l3QtiYUeznt0hVoCWAYDjzgeircp3Sp3sr+HxUtSHTkeUK8npxOiqdDKysC?=
 =?us-ascii?Q?10q6oUicLgU9eHqrBz+uyiqiJ+jlFA2pZ7+LVBdwmo67NUzKpaQz4+LJSCjh?=
 =?us-ascii?Q?gPcTN/KlpDKt7WQTxrKgYHtoOhU9e+4gC95Z0DipHX6cMe0HmKcONGzZ47Kk?=
 =?us-ascii?Q?Nc3R+vJg2puGBljXt3A6ZzHGp5UOuNASr4K2LR9/s5MemxnX4akBKvUxx4sB?=
 =?us-ascii?Q?qGEextWvArDbbyjtsiO16sqn16yp9NAGRozzqvxKYvtsp+R7n7tQpIyURSVl?=
 =?us-ascii?Q?dfmb7Ddx64trh4UgHWke5Uwqj8Ii+0p15nXdQr61QnpMPDz1l3pkR0KgGt2U?=
 =?us-ascii?Q?g2lnZTl7yG0uwvfaVsJ36MrXiOIh2Og4ohLfLjdpS9kPHJB2g6ZAS3vwGA/J?=
 =?us-ascii?Q?MsDfv108j0pJjeYePUWuUXaeDHPH8qZ5HbaNQ5IAMr4yqG1TmyoE4zLc+LP1?=
 =?us-ascii?Q?X0QotS+obHIrTKDRjpryl9c/tAuyTMlBo1F8900+DU0n2ufJh5a2sxuWGK2j?=
 =?us-ascii?Q?Nr4+0FQDACLTqQ58AFDD1Kpy9uGx0gQCUiRKbwVQSyKdGnwjabdDv2cYJwTx?=
 =?us-ascii?Q?WaNo41q/uCcZK7hvnxvzFqB0weB3LKzba9eszRNtBlRkKHs9KXGeyNVta07C?=
 =?us-ascii?Q?g+o8SCqaiRbKxZLNcQ6CLxLyGgb5erepHyqV9NaXyhyoJO4EyUzySyxCTFu2?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0OENNQVdmPQMOdW3LOE5PPMdUe28p7W25jtD8pb2t5a0aGmBUtH2K39t/yLqj+hmUzB/OXY47a7wV6d8IlzH41Yp6Pn24vwPUVBm9aMbIvNXY3F9RPYbsgjJ1PbD0dMnpd+SFCfrTXrB9agOgytbrGu2X7xWHKABNR+f5YcuDHUxdDoca4tRu79eY2n80c64rvlbv3Qfu40bvLTIX9Dij0QmpXYs8OLNrSbzGHH0jqCddS902ciKTOIAFa7jdbEfaJ73jhCUq+QGZ8ZbXtP7FQ5xGBazZPs4m5idozqk4AXkDc0GfFkCUgLgAx4Ew/rnf40NS+I7zir1S6sQr/oGg43avN8NGm0to6nV2256fTrPGaiTHkZlkixhkN+g8mY7opoqLek02GEPy9UtnT3s6Cj1cWJzuRQvfG8n4s8lHtpHarvOmGCyLKtTdUm1fJNl7BQ2IAGkjoXRz6cGQ4b4bPtbGogtynM3uuV1Cc2RPMbcJb2iAKwigAwl0jfZXppzNN+EZKJpnDed5yPUvGPzwt/P3954uHdKjL5JHHfvgx6/D14U48Bv0sGDpoI3yaRCFtBtVAsErY/zEAh5lu48i61ysfn1K7MtzhqsLWDqGulKIKd0LVkB0rZ2oXCTLEEwmoBBSChJoeOD7OtruaqyIu2k5MIfboaXfpxdGVz8VAGXz88MuYfvrywi/EBCYEAj1C6lUXEk4nP3YQIHEMituDSAB+B/Pm2SLG4OBKNcAQ8u3upPkIAgxtN3ZJl+UMcH1z2VcLIwwA6uSuxYXHszr+jThI7pXLo+Vw7w3rpOutU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4501e754-10a5-4023-8a8a-08db6670a054
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:11.6095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xbyafoKGq8fbhYdj00mpdeCWWnyDt1h1P77aZLeUCDBMqwVPNkBoKs2ZqhSPiWdszueTWQW97l8X5Orw+dDhgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-GUID: gPqjKckqptriOTes6zrYF1ygJhVSvQNb
X-Proofpoint-ORIG-GUID: gPqjKckqptriOTes6zrYF1ygJhVSvQNb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit collects all state tracking variables in a new "struct mdrestore"
structure. This is done to collect all the global variables in one place
rather than having them spread across the file. A new structure member of type
"struct mdrestore_ops *" will be added by a future commit to support the two
versions of metadump.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index ca28c48e..564630f7 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -7,9 +7,11 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 
-static bool	show_progress = false;
-static bool	show_info = false;
-static bool	progress_since_warning = false;
+static struct mdrestore {
+	bool	show_progress;
+	bool	show_info;
+	bool	progress_since_warning;
+} mdrestore;
 
 static void
 fatal(const char *msg, ...)
@@ -35,7 +37,7 @@ print_progress(const char *fmt, ...)
 
 	printf("\r%-59s", buf);
 	fflush(stdout);
-	progress_since_warning = true;
+	mdrestore.progress_since_warning = true;
 }
 
 /*
@@ -127,7 +129,8 @@ perform_restore(
 	bytes_read = 0;
 
 	for (;;) {
-		if (show_progress && (bytes_read & ((1 << 20) - 1)) == 0)
+		if (mdrestore.show_progress &&
+			(bytes_read & ((1 << 20) - 1)) == 0)
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
@@ -158,7 +161,7 @@ perform_restore(
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
 	}
 
-	if (progress_since_warning)
+	if (mdrestore.progress_since_warning)
 		putchar('\n');
 
 	memset(block_buffer, 0, sb.sb_sectsize);
@@ -197,15 +200,19 @@ main(
 	int		is_target_file;
 	struct xfs_metablock	mb;
 
+	mdrestore.show_progress = false;
+	mdrestore.show_info = false;
+	mdrestore.progress_since_warning = false;
+
 	progname = basename(argv[0]);
 
 	while ((c = getopt(argc, argv, "giV")) != EOF) {
 		switch (c) {
 			case 'g':
-				show_progress = true;
+				mdrestore.show_progress = true;
 				break;
 			case 'i':
-				show_info = true;
+				mdrestore.show_info = true;
 				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
@@ -219,7 +226,7 @@ main(
 		usage();
 
 	/* show_info without a target is ok */
-	if (!show_info && argc - optind != 2)
+	if (!mdrestore.show_info && argc - optind != 2)
 		usage();
 
 	/*
@@ -243,7 +250,7 @@ main(
 	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
 		fatal("specified file is not a metadata dump\n");
 
-	if (show_info) {
+	if (mdrestore.show_info) {
 		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
 			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			argv[optind],
-- 
2.39.1

