Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDE4C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbjKGHJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbjKGHJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7D811A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:00 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NkpO005334
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=267yZrXpJF3qjHIfh0Y8QqQXjmGFI4T0sdmcpehWExsMnsnDJUyeuiWkN+eU2HpEBpbG
 4cncoSDIVjhHaf5gwVM6cC+Qy6NE/PJSJmmVY0ClGnrSE67nVjRpksGmWj7CQZug72ig
 1NasaeFzBoRMBkSCRXuLNxrDDNwKx0ciuYQKkVZRiBODfLU9VTyFDCEcMtISCLTURsDD
 xDP0gNAuxJA0myymdM/uvS8gtc+2OT3miUDAeKwl9Z3mcQY5gfAROfSaEMyheennc0tI
 fORX6FtTTNzO5aRJ6Wzkduglg8V6/5qWrvBEat7UqSxti7LAOCYvYbfEP6i6BYzDMUor 6g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5e0dwae7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76PYwD030550
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63fev-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAF250eVi8usqV1LAScaS2k1g+6dFbMIlOAq31WufylK16cxYYhaF4f6nTNnvUC40FJwnxvrJjhL1iDFS3iS1JH7WvUY9+51aFov/abQ8LA+6Sz1/W+wDBuwkl1xFJczZbvsO58PKTyeiJQrmg/t2tLm7nopJei9o/vgQVdsYMMFv5Tq8mdxKqGdbN+1LqrsP6OZnu0oNgfKYJHEDKE1ML+OAShtBM2rbEIBnOLqk8+vPlE1XMRUMzwbKJgSns4ZOwsbSyxah8arVLFDNXRAseyKDtTPF8dJ/O/0WoQtbkQKPiHb3zFfzeADaY9G3UQHBuCYSdRijNYuDyPv1bgYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=crZ0fX8QVs0litzyT3Zar5TU5/JWxs2/s2ZWigfLIZAv4uK7Px1hp7Tl0fTFnLO+pXt89hSYFlcrqnkPwEobvLWEizO4QLm/RaZOmRg25R++OD+o0mFdAGxCsyEczA6Lh9L2//pC5ecdoKuePEEtUxpjvKaS9afHunJEc3gzvdJm1RU4t9qENITEqFiVp2N9PyAn3IJoAkB2+XWxc/Oyvyawn6VDvGfgk6uWPLCy0LsCaCgC/GA2hKIjYjTN4b7kI1lw86fltjJ0IZOnrceWkAYMR9Tv7+ywovG7iPXT7LTcTH+E3mUsQ13xaqR8cIVqOzoD0OKb+uot+l0yvLlyPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=qIRUSUPozAbdaapucJdOqw54G7vtoLA1vw+iNjz9YlQ74oqpebM0O6BTFGv3kI3B6rWWopBeCKLq1K5M5Q3Cy7TW7XWr0+jqxStgVXZXD96pYfSMdA0lZeVSSj4B5qO8AghyKUTG9STu8LyJ+tOUH54R0EQ3sEKRzmcd0l0x8Sc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:08:37 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:08:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 13/21] mdrestore: Declare boolean variables with bool type
Date:   Tue,  7 Nov 2023 12:37:14 +0530
Message-Id: <20231107070722.748636-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0287.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c8::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f84dc10-b006-4fd0-4212-08dbdf605d2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OFMi+6+ESi5QTRaCaXJuzV5WTrZD1VYBp4cNazAqV1hwI6wma249dpi7ssMV96VtfOsvc8ved5Ij7SiJ1wd+zJFG8RjnjWudrTZoNb8Pefn0gABopretO2eCMy7n9ghu+EdTX7UHDu2ZidNzBicIGiOdIvCkieGFvJ894afh1azqQQaEbCInJ39h2O5vf229Mhp/0KS3MEB5vV+uwl+oP04B+Zbd7caFnEoyQCyQKs2rxsA4hPVnWFj7upnsGdBz6lTS03EPBw6qh/U/ay5Ap4zVHyPVNng7m9ebebl3qrpgGmRFvuhghWGLM5UYAvJ1PgkFgo3QQcpU+8ZAYsHOSr1HJrvQcaUoc2P2JgsNKwi2ikGLxshHCUKU5M7I2NuIPZRtq876ZhesCWZSkx9S/72LtcXOec3IZWn8e+D7UXkdQHeqtadHGyVwic5D27RGytxzNsHJmQIISit/bgUphjkQBJ5RuTSXlmc/u53p0cq2vYJ69kzZW9tb8RnUxptDoSqM3v32nNt8SlMsX2BmM92wiMHTVOAPknWEI5of7A+RoEJOqjQH/KaGWaFDy1/aOoQh6lIJgeBwKisojwTJjnfA34FS7pECOMQ+rv8rgVYjtZ2HG43X4o63OsB6a4oF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(230173577357003)(230273577357003)(186009)(1800799009)(64100799003)(451199024)(6486002)(478600001)(6666004)(66946007)(66556008)(66476007)(6916009)(316002)(26005)(1076003)(2616005)(6506007)(6512007)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NzO9t9wlHL5aB5hDfLOQvpYPK2Vb6AnWpDGoD5HYWajdZMkOFVMTBbi6u5jd?=
 =?us-ascii?Q?uKlqHhGdqZJZWKswKw9rrXg/lX+5TDdk2T3hrtmpICmFJvP7y6rL0dJGcjUF?=
 =?us-ascii?Q?e4Q8vKVgL2onMa/QWjLX6O58D5S1WW5o+vPTz+bztiafbTu0ptz1bzGHZ2Ch?=
 =?us-ascii?Q?KAE+PLh1V9wjPC1SoIibafXFbw9aTdcPkcTLYs2Gc8IN3OisWmPwetlE4eTK?=
 =?us-ascii?Q?fOdAqK4feFrxMfGeW0ObIrmonUAZV9BAh4/Oo0HnTJ0aX/hcXqOcLWStS59t?=
 =?us-ascii?Q?T/jT0Pb/oBf8CEuDlF76htGVDiSrn78xrVCXYMw2lOLn2iW9WxINICDma4V3?=
 =?us-ascii?Q?pFdzPcYXnYabnRVsZL600FmUbarTdXaZnxC58GfSt20+amF8pCFX0YqoYbUu?=
 =?us-ascii?Q?5g+CV2ucXdYonqPTKUg8jdEqjcQP9BYT1z5yVAvUpznCkULXl68W0sM4/M1l?=
 =?us-ascii?Q?kfWniU95wQj9660sHuyPq7fD/JyOU5v9qYrAuSogE9W2aawK8wvNIWh3CHF/?=
 =?us-ascii?Q?o/zTsVL+ixGcIgsAfKeVBsig/gWpeVcI4sXqf228tA6g5Q/lMfW9ij3H2+8c?=
 =?us-ascii?Q?45laL0vvtTqzprg+mCgGvtb7ghuwXmVU8zl7VnC1qLo3vw8YDfzAPrgPE5jq?=
 =?us-ascii?Q?64R739qVmpnaETJk6YYYkbReA8iFh7alQDKynDVpZrA9brmjiaadExqcRJKb?=
 =?us-ascii?Q?YWxOnjLOAzyCna2J/f461DIgln8RLD0I3zkkmbCENsPOaD4AP3b/Mmc3oDQp?=
 =?us-ascii?Q?R/TAvhjt3jUfWli5GL17B6ZOi4NEruk7LghgBvDTkK5EtgNckVZu0/Z94cF+?=
 =?us-ascii?Q?JyvKQoe4O7VCj9YadeKENt9yY4HN7WyR50YDJI28sc968bifbBK7FQ0KIaKy?=
 =?us-ascii?Q?wtovuSZoNu6zo4LxNrsYmomPCnvlfKcwCV9vpcB8t2NotzlgKJSfglj9jwaK?=
 =?us-ascii?Q?oeBO88v03ShUzrLN2Fdwz7HhKfbI3uB8agigEhwSb0Az7rioKr6rhHzZaxf7?=
 =?us-ascii?Q?uwBhjpyRniBb4N1m7SAQOqFXsfTUq0HO6tUP6kUH82ngbNPu7xZHw808HpiI?=
 =?us-ascii?Q?gD9mPoJz81CgAwDLEm7BZTdjJ/cB0x1LtjulB0D4HpBRK5R9fqXrjLCKaM6J?=
 =?us-ascii?Q?fzrSa301zDV3Dg9udRy14YWKVqAgNGrSfJxV093eVGzKo4yKHDNFBkCGM7tR?=
 =?us-ascii?Q?p6yNxfxx3R4sK1eUtSaghfAaiAX4T4iO3c6q9EYuHTxADbO6O+XI/2Op7lm+?=
 =?us-ascii?Q?Fb8ugxvAy0yYZgcUzcd6PGZ0jsJ3O1elTQ/R8vX10URfR4TlUlQ/SyWx/trE?=
 =?us-ascii?Q?wRHbLLOWroS7Hps284SveImoBuHc6fUdGEYO5CbrNQX6zgzIGNSLbB7SZRhI?=
 =?us-ascii?Q?/ygFCA3PCZbju06eBe3YEgaTH8A44mpwZVYUNbMjkCT+hVA2msQnEQFU6U6s?=
 =?us-ascii?Q?TXS5ijBp4+JLFHjFnE3EvV+uM9A//YaBRaejhYT6PyVXpcIiq/QCWKX2a933?=
 =?us-ascii?Q?ExB+MZZpCw4SlKNIX1aWGFVeHJ+IzASVJkReB3y7iuDEudBLYMpS7aXblw8K?=
 =?us-ascii?Q?hVJtlJCS9P7XKvvks3nQdC30qvbv9HlO92rS1YVsoZTHIfuD56Fjx3nVAI5O?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IpL6Rq6iOshUDqwbV1qdzDjBBs8/8yPPcbJXVakLQwwBncAei2h7FPjgDf6rRFr4LrOjpLkmXXjzYZTubBVse4EQ8oW0IKkmjMkxLZ/85pGCKlMZKEwk0itcLC9xB/pRil8e0atVIky+BQIdc+xFDRe+jRFPKKeWr3n70y6NcacZ1oV0yvDzDmhSOAUBr3cAH4PpvYOdcy10D4ydD6Qbfi0Xco5DOCPEa1Nurq3txTIJriffeitB5YzEO9+pvK1rpNJYPhg9TLiamA/lLA765ha2v84l4So41ycbSg9yQrfRh7CpGNwN2Qoop9XUqEUdLkvwRtgb9P/ZLRq5HYK99APduRzrcCz52jhtRRWRP9Rnk4he+qVwbPalfZhs8JnnXhAgLcqvfxX7pIpFpEncV/Roa1mdy83YN6n7w4NXm20QTTKbot2AHadh8qtP67vGC1Wo8eckCgFc6sGnbTcsbpUqHPx1OVVqNcideqrcL+m+3xayYwqlc6Yn/rFIjHXVmMrGpDzMZwseZF4egP3yMPYveMZmkkS0LC2k6oR1mDiH+s5AmQ36vz3jPZW+ZuwAt1AbSGUREM+J8xIfP3Hx6+QMpKmiyxafekS/b6WMbEU+yrv+h9KiRnVptIj9rSySIqQPGkmFL+u1Y3v6HKNB04nN8AdvysEJ60yq7LaoxuvvrvUxFyIWx7lXZxFTSSd/lKbJuhAScZiOXxJDHAGGc+V3aKZVFOgs0d641QISlzzlJcLxEUjIIsn/OGzWSgI6A9waR2VyBXCOyqj3Evd+eA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f84dc10-b006-4fd0-4212-08dbdf605d2e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:08:37.8156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9863hgPIG3CWJwYt9L3wVXhNczovsPpc3i4IG+w60HWJ+0eNprRXJscj56sf3Us3CJe/bsGf30KGGzZxzWEiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-GUID: V5Je5XI94P_fB5Ej13zaci6a8uTuAXXC
X-Proofpoint-ORIG-GUID: V5Je5XI94P_fB5Ej13zaci6a8uTuAXXC
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

