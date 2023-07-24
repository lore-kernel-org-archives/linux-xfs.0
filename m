Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD202EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjGXEiO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjGXEiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:38:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D191E45
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:38:08 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMMvMh025317;
        Mon, 24 Jul 2023 04:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=cR7dTF2NwPtSbdsyoCSrg9vC95EavuWNOilO1aTiKrXEAfRiyKK3iGb/JhswGXNS3J6J
 Lgz6SmzsKHXktkjH0p+Vo7UyFqydFGNaGIysFtWBbcRA+dhrb4V+9/k1o+C48GpJ+ceW
 qq3Q2xwMjnL+rMXfy1Gu4M7SQ5sLbt9dEfQXKLZh6phxIRFTSoa7v4VLROjLyRE7zck7
 QallAQmmxLue5V/pNQzuvSKyd/dF0No5LjiNRxLEw7lPVygczzrCJoFMjGhMd3GiA2NH
 gv8sTCxzWBHoVIQ7vuodr5R13uzXGb/DqxM+XIL9o1XA+edVOQpSX+yHDFk28Kpz1E5Q 4A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c1vfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O20G9x027548;
        Mon, 24 Jul 2023 04:38:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96cmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEz9yTPQbpfZyJFlOtG0GWZSymSaR3E7Ynwx66eqgdM2/84AKUciRW9UEyONXErL4lupOzKeV63YIC3nRDSFtPFY7LRCKkZLJUOQgKscUo7DSYQDBCBI778WwjMPngIM8fNZK2GEpVc+yze3de2r3tvyIh0MVgN1l03c3AuVY6cjdM3HlCog40L640ld84VNXM2Jt1Zcz5PMEm8MHlINAm1TkPNe2R099OkVu00o+MoCGsdwjtcVgok6kGie+IQgiEOS5bR/b/aLbMTJ/Ejyd86guTN/AV5BCJ+yhvVd/4vHAzQfPOjHaUSki/4E0KRQ2kh4saYxseZcEiQBsTDrSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=T6G4bRyiapzbMe+OUDh+drTkVZ8YRCQA2MblTUklWUtKdruqRsSnxqG4Q7mfkCCOiNpbSJQsAsShDCX48Rkz0hyh7qTLgCvqCNlKoSggPs3HJWUJG1keUOAPhY1O1DToH5WLolU+k7s6PYNklKK/GB/0Z3Q45rDs/ClJNwnltBX0uPe7F77LbkPp0pIXk5clmv6F1SUZiMlYTdpjRorafSRq4kJi653EcXx3+FGfrn42CVaOnfrY/hel+SM5q80cv3Vyu8Mh3HI4uk7irGRvYyCKmsGicd5eEbFgL6Jk90G+5XGpgZiN0d5cbBY31MzWYJqGQz/ntE4now/ksy5SVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=Ty39FbXvO70Rx5iU55qyD/CGFmcnWynDUo0kb0dWRwXAuafHrA3jnCy4TlHTlguOlE2kuuWaFT9IQY5uZMyAiszvL/Fw3aHDeor8Lxg2NAFOv0NcOowv1YZ6qmj/i30V/xZ236/umU+BOv1N6xTcZENN3hMfLfw8u3CTNAXi6ss=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:38:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:38:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 15/23] mdrestore: Define and use struct mdrestore
Date:   Mon, 24 Jul 2023 10:05:19 +0530
Message-Id: <20230724043527.238600-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0122.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: c33ee4e6-36f5-4429-472a-08db8bffc44f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LhByItiV1fGlQCtDMog5C8rm6KBkXO1h/BjkLjto3lAiBv6j9YdnRnGgID7A+jnTE1S2Cw0BoVbxnHDXWbynHAL0x/BqVsTVhWb4/nYYfcc0EbFmlclkNZhmilVsKBJA4wYf97wf1GL++0zNnfLcEDL2vW1YhHzL6bw3vHzIEvK1NshaZ+xVNnHokKRru+2au1xgh00Q6C+Y/LONXwwxZ6wSholsDEh933hd5zEgZqhr5H0ULhuBfxw3PyxjrkhdyUUU4El1RtXcomq1koEvbBtkH8cvv7PKRZiVdl5oKZfDqkLfnoVqK5BYUC+QbmhZm2og1qyuhKW/Nxs7dVzt34bdPUg+pDpxYckDt/m3DbcjUhXW+bk1DTuvLm2rxY3w99Bmxb1NvCo3FbGsvueLUX3+U6xajKiKWg/pTpOfeFOzQSjnCg3Kn2R60JcmnOjd/z4Gm8nqmtkrSCXV9BpPq/08YJclxEZmwXX57X+l1VAmC6oQR3XSrKKlrDux5rpkP85SFfZ0xR34oAxiyU80Q6l+aLdld9vQs+tUwPgTtmdqQN56iKCleBzShzeGKvND
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EkqFH+lh/knpARrboZNYzhmUH9mOAn0EcdhhwEkNLpb4RnGAM2tJLLzO0uRI?=
 =?us-ascii?Q?DeitmXV7bYizR7u97s2SQfjOSlFK8/BqKSCGfhB5rt0txfIMaxB2YUW+YAdf?=
 =?us-ascii?Q?F8CP8SsLMzZkGDXKLcJ6pz30CBVkvhL4h9d8gQwKam9qq0X35zRNlBtlRfSY?=
 =?us-ascii?Q?taCXs/vMmjCRlhQ03tIGXwA1KWUy36NeAm1MXDRLrurawrU4Ux1cItF9Zdmf?=
 =?us-ascii?Q?s806P2DvGMqxf/FPpnoHvTajvOsyUinzdnWpyRzvdNxvbzVe76ezVQS+qes2?=
 =?us-ascii?Q?j2P5TxwyceP0/zhy2tZCol+QiEdYdL/KmEtpSwcct5miWv6O6dc1iwe2ILw2?=
 =?us-ascii?Q?ynf7KmHlswknXzUNDMLcNHzjgr9fqbDCsL/MKR/TgvRiey4dJs04L/gbUozi?=
 =?us-ascii?Q?IyDbfErr+eeW18k4ceXwOJR/snZF5/a9OLFq51NvSsW96oehN8kc59wOsbQZ?=
 =?us-ascii?Q?gHSECGLsw9WMu6HI5fjIOYrVvhJmhAHwb1ya5LdaRBBLxnvOVYeAUNPFY78B?=
 =?us-ascii?Q?9n0s4ioa0cfG9cQgSOVl0Y/UKeUgd+g3OIPXsog1Sj20bKDvVZaEfuv/Ufhf?=
 =?us-ascii?Q?6wtQdQKI/s0ZlCfMpIWCyjONr97TyrHvwvAUUhQdbw84r3w/DC6lt2kWJVQh?=
 =?us-ascii?Q?VxHDcZig3WA4c1Pbb21KMMGFBr7rQ5OMRFv85GEhuM+oq/w5iawQuzu562AJ?=
 =?us-ascii?Q?Y6amnNJDWEa4wfyd2I4a/zAwW9M6LcW8Drz+61v7y1cUh0/ktfyhlOmvYKik?=
 =?us-ascii?Q?X42GC/fW83hwn5sRjO+97yCtaxlEPJV35BfJdELFWFu9C1W1s4f+jMKHWCU8?=
 =?us-ascii?Q?oCchXsUT1vB8s2ZI0GTJgs7y5PorasixAhirqnppMWyeThuzI+sjaVAiJB8a?=
 =?us-ascii?Q?sZ/zml45tm8UCKUSkxRjStEAFCr7EkmaWN+vPaQH2mm/nZqaf/8eI52VDNRs?=
 =?us-ascii?Q?efDlCDayv2CyuDxrM8n8ZiuI2/Uay9+i8+ojUTlSL7/nYJ/b5bV6yg14tI4y?=
 =?us-ascii?Q?B1EJzZ1lQhK6kBS8Pk+/75UMBrlNV1DqIlkw7Jp0AMlvX3ZmYl5Rq7N9WIjZ?=
 =?us-ascii?Q?krP9IN2mZM7t8+8Nlc9aiS3l8jqLjevFIeLADTqck2fXy1/ZDUjG9FdOkhKc?=
 =?us-ascii?Q?E+nl9/s0Sz85Zvp5F8mAWS0McD6kMq6WJcrfPbBTkra8yapBN+/P8SDZnPpM?=
 =?us-ascii?Q?zQcvJYbjG7vkxWUR7vPaEoainBLDkzz6DlhfUlrwNWRwKk3VxFHzP4bEBNuM?=
 =?us-ascii?Q?QSdK6sN9o+FznvywgJAEkk2cuKX/6ouheieA1SIg1Hfuwqq2IuN6N6gMBcDH?=
 =?us-ascii?Q?1ugAhiLBcy7d8u/FhVp8mpfeFzdXNR+1TNJ3Y4zUuhywgqBvjiyD0WdDTxaG?=
 =?us-ascii?Q?UcLQkysK8eralEu504ppAiVSBjeLu7iGJ2/S0yNehQUS+Nd5YTrJnjSN22SV?=
 =?us-ascii?Q?z2lYJ1Vm2aFkZ9M5mgT6akDhFDMtz1Y9oMIALrT3jSAZmIMS70FU2GETXtLT?=
 =?us-ascii?Q?mBBO5ygq3qrwhoRBKdsluZt3twG/E3wwsGUXrTcPqN/0kcTR8mVmAJxe9n0n?=
 =?us-ascii?Q?nQTI2Cw+ebjkcZDZA35lW9hBaOyViF/kOie0+LYbCKRERb2LVhVHzgTchag8?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qEu6a7XMubwu2zaNddvSFPF2Qw5SakkQkpy5mJjaeGvfx9WOuyw9P8Q73flw0q2K6No6C6owNrHbmBNDiRFX6+fKCshbEwGDldwZFO5H32CoXf7YrYv0s77l/4yy6ddGWTRYJvtJiu8ofWzktTH8GtaWzcrFEDvMT5uG+3aodftpYqWj2JALw5MT94wwSVLaO05mR/FMGGC08+WxrGymRz8LRJmJwRpM9XL+C5uMAjSh1Rz3BOItz+LVT+pA6yyjUgaB0l7KzKWO/X62C/4jOTgcMVpwGVlFBEnds53HJc+JbcKKigywaLjpKvWzTQWA86BMt6K729XjGF+oDzs9HH8sztklLS025STAoxFIxeM/CFbnWm5At/QOd4vynzgmjmj2V9FUPv71CxuzGfo0iw3bwHYajsyNTBmkWNc2FaZrKPy547eWHWT3AYueTmPYzm9EQPeho7SAe+JB1UQ3vgz2c8j1FlIpMtQ8byIjamTeVrahYbz3AHdWfhm1rY79fh2tXCJ74jSMGYt1xkAvZwvypcJpMZtCRWocqo2fOiWUPbBxtWxJcO6s3J7/XZfVAxSLDUpQo8e17f4mhb/TxeSIAo0w90yRtLJKG9SuRXyrsAIoEkalJYRuq3wexB+2FH++G8r9kEhb4VUlOZUlYJw6vW56GtRrtWQVuM765H/9YQ+niHO0aT3rv+qMcgXrpE0sN3o/+wNeQ8+QrEmrBYL7samLBWKa7j78h+0RV8jNUFIrw9bGEbnG3eOyCHpkl61MLmbNIpdtk14LM9Kwlmb2RBtRAJcRksUreQOSkjs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33ee4e6-36f5-4429-472a-08db8bffc44f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:38:03.2599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gu+s1bPD2DulEGyJBv/YvSaQnDwXEvsbTDh0n5EvFMpZVYMbZKnkcYxOklyqb8wAaQVWvd5eNQTVPl8s7NcH9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: FQig9GWGBZFHnFglvaeZSxokx5j0yDIf
X-Proofpoint-GUID: FQig9GWGBZFHnFglvaeZSxokx5j0yDIf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit collects all state tracking variables in a new "struct mdrestore"
structure. This is done to collect all the global variables in one place
rather than having them spread across the file. A new structure member of type
"struct mdrestore_ops *" will be added by a future commit to support the two
versions of metadump.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index ca28c48e..97cb4e35 100644
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
+		    (bytes_read & ((1 << 20) - 1)) == 0)
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

