Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2075C4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjKGHJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbjKGHJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6460F11C
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:04 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NnqD031636
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=csTdrH6tCuHH6XsUzltOQLkspdwiX5mtSBL1flybw+TSodSRjR7fG/BfZjZ7xRqrpRqe
 ohAuPCkWPYFz1kPQZKVLokTtetckTy6EC0pLoV4/iz9PiLdnlIB95g/H52qcZ5yhEXF8
 s3SFqAlntvDLUV/GGj0peF64au711H+M/nciDz5Ul/YqT/ymgEw+Rq65uq9P6tunuL/z
 /prs615L1mMeq99CH2RxV6YnMUuCLqZ6V7wwUTXKa9yRF2fXpxuD2UifacHEsYc3AnFm
 xIzIAa8JQqJdr/+BTMqHrhP9XxYBHyRaHjmG8A1GpS3nbLPhCOdTeS0gldFkAXdIfseG Bw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cx159r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76PYwE030550
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63fev-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rafdp+ics2WGT+yUYdy4ggcnUWBz+i+MFJdEnpQg7erAv+Jb+VRdBjmKdjSTB4+PXEBNhCGaReQnOLjodfGjsxRsTov0jtGt7x64EObzhfSCQr0gIF+q4u2eTxsPgwf+EodbmJTEGii3ByfHHpey509DT749lcszoq9hH86eCtfWia1pObS6pSeCy+OBZzX+oHXdCpeaDASZWqXhTCf5n2BvEKaZOCTztQPM/Qg9po22oZ6Op1muNtjOAzlVOWvDPQE4fUaQGX8QVRdAUrZ6NVTAcCii/n7kR31KeQCgQbhZcGgXpYibgs1stEFIy1Hlv3U+OIXnXbZHsyuHLApzMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=hFSfzs7GhtRb6lymb/tO06Ha75sVQaJVAftUj+dgsBgvgCbjfZxQa8gTdqqedR5/BEytgS7sT6OTI7L6gr8mXyCTKl929akDT9G4Cc2zgLXZP5HY+xsPChlVDlq58U9fR3U2YFeMyDubklWDkT1EYbISx5SIa0lxE4zfHkyxyWWN1mALwq9fRfR+LxFpGwr2nCs95ogtbc1MkRdqXnbLMcFtp6Sn+1wO9NYQ1tcSQ/NEgcd5DZNafn4wtuu1k1O9cQePR5o3S/GGPzvHWSxHM05uV9WoMfbd2WKwtwYwgAqOPF8m/ju6G8iTtunnxceXD7a0J3JOwanYPTUhAhH7Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=cT+7gTLKpqKYEyLa6QfSUNBx5TQ/2nSWQu8Q5vUbb9yIctlSlOCTOXZM9szISKYMf6tbX/yNdgAZv2SNqGrYqlqHQw/G6bwqfAVwOUzg+pn5WEFLJFoba0vlb8nWXABCpUH55MH2GsYeeGSrbMQc0hY2aTEm9NPDh/KqVm9Vifo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 14/21] mdrestore: Define and use struct mdrestore
Date:   Tue,  7 Nov 2023 12:37:15 +0530
Message-Id: <20231107070722.748636-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0294.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c8::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: fb176e87-afbf-47b8-1b10-08dbdf606092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pr5Hb+yZmolFlnDLer0WlGz5WOP+jdQw0HfJuoZeh/qdeRG04upYb87lBNmC91wsCIKQ9DVsDkUJyCa0kA2wg+Uoc7iJOnKNSD3SjaqrcPe0Cw3DvFSQ6TdXz4Bv+kR7QVxCfxOhdWoGl0ET9Yl6esoXXSzeqPm6DdQMC4wxATAIXUOwiiFYSBYnSYWDbPFaDYyFE7Iwlwr+y2gANTPEgfmwlEOPGgt4xmDr/YeMv0eVmc853U3FyGryoGP4mZny9nQZ21UPuE0kedqmgk56QUU/xZwGUmgAYTxgzd1SqQqeoOmIKMXBm8B/iCl6MmBDkiz0124ganRXupLDatjwX8aCfjRfUBQWP/at8EaASZIkRN2JZNYcAHMfE5/X6VYbOZN9sBtC+Xm+IV7yySvu+e+Z/4vG5zhwASxlZVJj6BYtBywdVZbS+sc4Hd89nQV6lC2gQtp5ElRjcsSZ3zrhtdI9VYBdlE6gezof+HZsfwogOu0T1GDigl+8wAgjwpsojywIWLOUeAiLPXoUxzfQAQJWLwXIGaqpdiptp4CqMxd5BdQnA+qVTn6ESPkqfeQtKdB4XenFauVEYiNKk18+NRFSlfBCn/k56AV/li47+74vg/Nhy6zWihAeaWOeF/90
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(230173577357003)(230273577357003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1/6f/fBmgaf3OsPM/xOs655X8nzlTEFrWXU/wsml5xC0IxDzcWtGZjExO6Xs?=
 =?us-ascii?Q?Ib9gHwNS8JPls2dw5hrlizNTHqrHAClwUqVTfw1+vVxghZa/xC/3DVFeRL78?=
 =?us-ascii?Q?+XqsVWORDopsQ2sXe4ORJUgwovKN/TT0r/sThlxeTOJI/+Bz4tCVbpUdX7/F?=
 =?us-ascii?Q?xwaCHyHwi4bbTiD9ECVuYpPUZxPVmK34vJ7mAa8WIU70MwlIglK9Je0xz2U2?=
 =?us-ascii?Q?DVT32GI+nkzgvfKhw6ADBKtxDZY8mPXgQQ3zc15WvA3cyVzenH52VkwR8+k3?=
 =?us-ascii?Q?fQDKCgB0ADSL4Gcqofd+cBloHSLXulu2CP6WerRKw2I03MbnFpoJRAgLWZcI?=
 =?us-ascii?Q?cQHG9VmXYHM/UnWry6QlobTTGfp80E26Q40eOYbNOoY/V54xy/zrpJt44CHN?=
 =?us-ascii?Q?zUnkcYXyo5N/11vJ0edxSutelVM7YCdZaCaJ0Q7/ZSiZJmkuM8oDbbuymSky?=
 =?us-ascii?Q?afYRtPfxGqzuSc7Ot3RVxquT1YmdzkrqxoFGtPLkUxiJcP7BiJR6ou8EKZu9?=
 =?us-ascii?Q?sZJ0gCJaCAU1/KPu/jrWseDmFeU5cC+6TnbtJ3f1JBVQTWDfUA8G5XnqvJpF?=
 =?us-ascii?Q?uxd9kGzwxt5rroMGKCjk23F0kGSs4/ebp9dGNxYSOTJo/Cf6GzA5+vuBndJR?=
 =?us-ascii?Q?KyE7cuZmKKkKGO0fa5uj7KP2oTxA8u8paCOe2CKLvDAOBVqU55x5EEr6SKUb?=
 =?us-ascii?Q?Xg+Ya2wlhKmgUfiGLbGKn8rJQeDcrF8BlDZbDfSqWGjUwmVGJPNjNC1teCoa?=
 =?us-ascii?Q?DuegEU1AH+nC4DKrgFbEs2yUtBV4VoJndLolMBfF1GuFGDgTsvGX3X4dT1Ek?=
 =?us-ascii?Q?385hRyO5h1KnL/3Hw423h4bQlc1ISXnIR/a/6VK7xHoc9Bksqk0tL3jwkZKg?=
 =?us-ascii?Q?Ma77KeiR5HHxnyCFMpr2Zc4dxuJEH6Z9c0XclJDXhWGCjBCuVTPOJiOerq0X?=
 =?us-ascii?Q?GSkX+lQi+tun3IfFrP1ftEOrlLkQNsc/17VgkEfVEzJgwdWpl8qafsa4dPA0?=
 =?us-ascii?Q?LaYbm5+pViUSkyOew+XPKcRHBYj0SN9S23hrEr9EKBij+7TaoR3Dirj+DYt3?=
 =?us-ascii?Q?fXu49Oi8P4DciA/hOz+Dj3oB6Q0yDDpu/aUaEspcGfYkkDzAXMMcWQK20mWp?=
 =?us-ascii?Q?kmi4gEu6dSB9PpIiVp0OzBASjSNF05QQuB2lvzuXoTHnTgAvazMK4AfnyBye?=
 =?us-ascii?Q?bqB3QeOZisc0A6xU1nww+n+L1ETwFhvJa6/2oeUmj7e+RBVNncv9+DSBUbrW?=
 =?us-ascii?Q?QD9m3H5iYwteRFP8Gb4ukhknpEAzsfJy7/gObO6u94z3f0gz/XuSnvETPV64?=
 =?us-ascii?Q?Uc0Ph3iEhEZVoU6x4OrRcpI4dqwC5VqTTF1HCRwvzN+X7Wi2zq4fz38X1w31?=
 =?us-ascii?Q?CDZiT+oCeANrtpbATuGcrPishCEjnNl49AM1MrQxi60Y3Sx6+R+QpvFBLLTo?=
 =?us-ascii?Q?cV1w/CtTCeroC/86q0V3hgCPFnKw079ej6BHcobO5oLDJNpB2thiEuwvie8G?=
 =?us-ascii?Q?ReasAeNZcv32m3GqyeIBKVSbv/vguFPw4vyFmjJbVzzs7Nh9C4gFNacKE97H?=
 =?us-ascii?Q?h2klmccdeQZ5t2Hp4dCfy7l1Rdsw4m4Gib5eNACNXMqLKpUpIGYopociqjd+?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rF0eo73I1MBuTCjnWix2bLDJc7DFkArxRAkI0P7TEDqmfT+x8f33fUoWiSen1JWAvhaoHGLBTTjOpxngI5f+zWDjAgS3IUQd7g5gCkmo8fmnWpBVc61HgoFnWlTy7j71p534V7Jc1AJE9OwbVgok+1zqDFhDMnEZT9BT8155/2E7lAnTIi9ilcIVic6c7mXYjwQaNQMsNzg7v7prDzMAhWXb8wnBRdNkn2jog37Zq1RW1OSvJ8PM7mV/b6YO2NHIiFry1uByy1KVnp+2JEB2B2Gom7CTBs/5+wvxkC1FagwUFfXLQq89ZNEiesQnZNmuzd6LwUIFILzUxpoacKt1ATqtnUEgVE/5F2BqnnWih0maaaaTQFEHnKSFibPt5gnNe0g1yoUlYUTXvLyYApP7/oWvVO9DY3rIBj0LSfBFRP0m02n+QNTzpeP8X81FwztNr/qQ+Nf1auvUs9JqyC/4ej9Smj1K3KgcLt94ZWhoN+cInEqc4LwYp7px0Fzb52G0weY6bWVd714AGj5TDfd8SBpjd+c6tB/UT/YcZY26QR/Cbo+QF30BfgVN4PDhCN+wkT3WyyWphqrH4GByMFukij3Vf9xWdk4msD7utx1iZHil4HQX2Bg/StQ8m1sj/kG28UtEhp92jaSBNS5JPcADqdJ4Oaobzgsm8VLgsQ4yjWrni56QbZLEM00d9oPwPj9GyQysUiwmMzLPSJ/z6IX2dMFPZXFgL3l8iJYFf39D28iznHyMhAmxz3Uk3ifUGIqx7DYDUqVer1nqIlCWNplbfg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb176e87-afbf-47b8-1b10-08dbdf606092
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:43.3936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nbRT+oWkMt4BsogE+3UCciV2VUPNM8O3BViI/PZ4nFf5myPTwrnAY8C22hGlKvoXhSVe4bC3RN9luZ7uMFPlZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-GUID: JYCY76TTdccgr_ajTfj-nDl-q8W2mb2q
X-Proofpoint-ORIG-GUID: JYCY76TTdccgr_ajTfj-nDl-q8W2mb2q
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

