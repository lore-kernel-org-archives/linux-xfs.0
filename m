Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AB8EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjGUJtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjGUJsb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:48:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9432830F3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:47:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMZ7f006783;
        Fri, 21 Jul 2023 09:47:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=b9+tiBD7+UdwsjhKIjgfR3gvihJ4KQosWar0kywW6A5brYjmo36JND3UNiowMahzjmXi
 PaBvTXcA1Xu75Jjf+ybDys19CpxgwBpPVypTxyBsqXIxiNU/cpWRmXm7LgoTExOAeG4+
 uE0qdRI1DMOFR319nTWZQ8C2uANKLrCb0n/RTkPRqV/HKhzLM9eetcRKUNXO2ZelBM0H
 kuihienU4t6XpEYF0D3hXZKV4SyvtwCfPSz2Y01dxoJMWvK9LsztRxuyuj72iH/YnpLP
 Fmrrut3SZaA6+KIpnEFMcvfGx4jWnucsuC3+lwzyH3XPHeyntkjexke0q2LiDAG+SdKI 0Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run78bdth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L9KtJn019174;
        Fri, 21 Jul 2023 09:47:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwa927p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aP1NWqdVorwg+esOdjnz9IXOhPKcnfVlVCPy1ekigjoQ9E5V7Hq3lKIbexc72REI4Bwwr9f0978WhrkEFUBm+xL8I6pXeFRuapCJqL9j2VyxQ4wmdnt7W/Hu4ExTn8tG5NuYWLVdyxN6ISsm2HyMp+fKU4z68Z0koJnAk9I4S7WR35UKLI7o5lZwm674Ld/2Al7oEpLWIUdYAnthUynvbp/jSXkix4OXmaoc7Sh2bXL0u4e2JDk93uV3ePD3Wd/ajEjRC/4wjnJuGhttVUE36UpxTNgguVw+9bLKVtpQjxgCS+/fv03onIRBabN0hGaD4mJoDHhUTwiSkctPxCDSXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=YNdTKE6/IDXJFJVj6xaSDxcJLU90zEgOEUYzUnKb6OV6Nu/FJ8jYiUIieDEBi88zR+gocaHAIAFwdF25JISp1wOw+D9bc8gpfFewZKOfpXAH54v4ZWkhXlxJ2j+LY9oa88/tcATN4GTuUiAvBDt5ZRp7vxrNfPrbu4MTs7eER27hFAfnSUPVvy/B5IYNiLxL0ME7Fieh/e+uZEfZM+J//KOkLb74c1z9zwnzQvASOcnXnp49V4x+9j/VAVfdmYKFASZhXU7jDTDxPK39UEUgnX0lczG/aeuS+4g54pXwJdueV7wdtALbdTQIGVX4Zps35x1ooIRjOxSK7St6fWhVeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=fyx161oNbi0bvYTyjkFm+tSNHpEomtOiNv766jMnTttfdjIobcwEK5Qr7EdP0dRXwPxF8vUhwUsP/BeOBffXLVUhXfRdqjnoi3FEDW9AcNHZXAvcCcCGu+jZC/wXWpTIrnPSPRiMFZt8GwJDZrQO2Qkaz/IMZpLAPlueQqK8wsY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Fri, 21 Jul
 2023 09:47:31 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:47:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 14/23] mdrestore: Declare boolean variables with bool type
Date:   Fri, 21 Jul 2023 15:15:24 +0530
Message-Id: <20230721094533.1351868-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b690aa-d6f8-4cb3-17dd-08db89cf80d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qaVVbbNShGgsSUnFpRjI6QGLoOoRYTvETwCkbDwOoShaZv2lWqpfJKgS8zxbm0GXVGrZ1ZFasGnwfvHlW58VYavjCVhHtLxP8grjUaLUkmJB6xkzk5nCJ4/1c7gd2/aRjB6njcivlxsQ8kmcJ8WB9qtztLGzFP5vJj9HSIpfjBAEZHt0GG/4SwPaAPv+ZjhCY0AQW0U7V91EW1NN2q6BKudUaeTlvix6YzCjNs9k0Oapu3lSk7DhYaZYpEwFjQU6SSmVMgDUO73AXUJg69eXjyAQIUlslUgAMfauCOxfGej3bPSqZXXKTRl1TIHATjGUVAc5DRs/Z0Dltbo3NfzYsIO25p01yPej4xiedrG6yvWtc+INVe2eoR9WKYCHmiK7lT20HO+3QoGDL9E0CZpSHT7G3EE7IG6fSu7MY9oAVMfMm1EnDxSk0ZrwDOGBrdsXR7cqqxlp+yicNm1QJz6R3v1y/t4/k7+zsI1nJueRZzP3OtZVpqt2jmLFJVf8QOymYWo0w/ksHzzDoGRcMl8raJkbRmP5a+9apsbGmZDXsIS4YhbZm4ZXFJLF2BVOejNe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(2906002)(83380400001)(2616005)(36756003)(86362001)(38100700002)(1076003)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(26005)(186003)(41300700001)(6506007)(478600001)(6666004)(6486002)(6512007)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TYAm25LMhuy/zUAs0y2Q2g4CH0jD7hfZTN7WOsuLa7jhYInGsD03z34lR9r9?=
 =?us-ascii?Q?UBgb6D8UVWX7PgZTi9HP64xigd9zd4ax9S9hgdxQQI0y80QYkDxbzhn1SjUw?=
 =?us-ascii?Q?EznJh24tymjJ9ksVX1jF1BjrlfsAH6Lu/EVEoLdIS8zmrYQSGSWo8wqPcE3d?=
 =?us-ascii?Q?ZCiEptkmPgA/UrDA7uic1PPElRXNpLOI9eWFtGSxpxtkGoIU7dRlvkchpm5/?=
 =?us-ascii?Q?zCDcjLuRv8xSkKoeX8VqWcnXcdVdRDapGeebGY3FcD37mZbRf0pI2TzkC8rm?=
 =?us-ascii?Q?QfirK/FpvyZ2Vkw0CC9EY6KrOMQFCOxpFygynXVZuYi9Uziw8YKFTI2KZzv5?=
 =?us-ascii?Q?xTZImjatfzb0qBJIkRPnswApsTk/z4J98iuuHFBpzA3FyKBPe7b/RdK+3yVX?=
 =?us-ascii?Q?txgKIuE9uIcvJrWnxAyIGebFdf4xNAKLgeoUp6c5rJS8Rnj85VwTuoa1lvaX?=
 =?us-ascii?Q?BgFW8s1wA2svj2tPbqT8N8wvmx389DLqRIEdyEuK5VEnL8KoWmkIJLKanUiK?=
 =?us-ascii?Q?BOnKiK53jQ+FvLhtClLFLlRYLKMO0QyWjPokSqmzS0ATBEpTZRW8RWxD3FOM?=
 =?us-ascii?Q?eSySeo2dLIqMqUEC265+zijl2sF70IQ+r0rUe5GmLUZAX8nPZ9mq99PqUFi4?=
 =?us-ascii?Q?WJbfxpmqMKwXebADlnMspLsnqNmhRBFzvdOtseFjctuz8AwjT2AnXAUbnrqg?=
 =?us-ascii?Q?Q9dovCV1eUW5Tr69DtmSV4E06qpPTMDf/X55vZoNSPfsAtEFHJzdBIdRJrL6?=
 =?us-ascii?Q?YZJt2m9bxlaVYSjN7Pq09ZdDGJXUJuZ2r48i3OwCoqE45YcfRyJUzx2m61xx?=
 =?us-ascii?Q?06o7k4IHybVKoUibSwiztMdzX5lx+C+Xms6NY9kU9gvY7Gnfrdf40/yXpyMZ?=
 =?us-ascii?Q?7OXMaoraSOsiNKyLCrSRG/7M2CEwBK2LtCF3BwFXbTth3njjQTpfOSqArKnI?=
 =?us-ascii?Q?7PCbpxw8MVTflyOt+Mk1Nht9qURind70nmYusE4UK8b02+rhOhi+kHcpMtW1?=
 =?us-ascii?Q?fTjgM41llr0tPiUYhiTNi8mO8E4opt65O6JjrCyEG0ocsu5faNjklZWn93IY?=
 =?us-ascii?Q?UvVU+zWZvOKL/9NvGivDSToboXPtbWCZE0qaqLoY9ILe2nhQQvv84ZyW2arL?=
 =?us-ascii?Q?jdbLqGRJzlXY2KQgR1Bn8z+0QbokJCMrz1l7/QzDbu3TqNOeF8E2cOprjjK/?=
 =?us-ascii?Q?GKrG9WZ+zm3eKphFBQUNnlppXev2AxXg8DJCjmCctub9CJqKK6BPaLoWPK8f?=
 =?us-ascii?Q?IW8BpwOepHOQpJ75wzyuHawpPWpNt18sQGeU6x8eO0UrwFjscMFZ1b4O0kgI?=
 =?us-ascii?Q?1PEDNiB1te/uFPxjW/vsHTUcEhbrNRgO1EL/SBOCBDrMG7o8Yx06hNOf11Qv?=
 =?us-ascii?Q?wRdYlT5sTly/4HuqeZgXgVqRuEHAVWEqsjolk0z4eN28Y3WO0IiB/NBPEmY6?=
 =?us-ascii?Q?C0bpeFM44ZsHfQX7mGCX/IiiAqWelIY6pRWUKSrAFETwlRLFyww3I0A5Egzi?=
 =?us-ascii?Q?rNYHw4GQkGqed9parjwap7/F/1o28+AVD9wJFJKpIPQAboF1vrfhVMOy93xL?=
 =?us-ascii?Q?arruDZl9FXumiH5Wkpmb9yTrPalu3tcHkeyoY6qrDvmN9hRr1QxCdbmSvmt9?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SOpnyGxdOeeituf47yDnzP8GJoGH1h6uG8TZwzm2/p56tTRyoO71ULU940VaB5bXLYva2Oz7GXGiFRlF8HmFUgbdyA+qyKncWRccLRvsK6SKVzpZF1I9j2dfNHIyqbV1llTMyNkxa6/+PBOs7SIZxYTzoAw0umhgXVrfsIhSc0/IJAD16d3zz3umk+WlvvUds3Aso+a4tPmLlkAROQCM0PJkWRWOTKusiDDKRSCZIK1CLpzm/LUhSc19wflsu0iLA9TgCkfOb0wcjOS/nf9YMJI4edYncGldtpaGu331js64Hi8JgaaWbgMJsEC6WltReS/VcK/TyT1XDZ2vNuig/XG512/bkVpNjFayX79cDT9P1h79WNlFapArLM4GensJzY9IgIxBZd7YbirnkRWOGJltnkWMNPZ7+CiDrtpAqEdBG5hJZ7NM+PNERXEuqNAAurdQAz/4Y1pChnfmV5Bug2NPlL9GG8ZyVEbQpA6VY87dM5AXgSvhghM6LobRj8zZUY60n94wOXIRW5pAflRydf6DCmEtXm8sF6NgBlG7avQfz80bOeYPJFJVVNjERg7J2Xvbw9bFMkJzwf1M9QLr5YbYNfb/eLt/pDTcmTfi1diDobLlcs+j0k8eAgzuSk6tEgldL1VCpBtcJl57fMfqFJtKjsitD+S850mUvu5PojR4ex5gexsDI77Mf8qen+dIR4PrZR+pbJ8EsAJHxjBxzOw283yPP7H5IIurgtfp20SIVf/JzFKKMnY2IGYLIY9ty91MU64hcVJCq5rIaMG8CmoQUoiAf3+ntR1vIm3nQlE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b690aa-d6f8-4cb3-17dd-08db89cf80d3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:47:31.8238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCzfCx6d3SAgJNAg6PiiwSGltNOtHvzdaghccmNaW+q7MVtogwoiYSUt8lt+jX+Gqe5780H5Vt2iAfliACJpXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210087
X-Proofpoint-ORIG-GUID: DV0W9a-mbOqEhRKRIYkh427eYVT_3lFe
X-Proofpoint-GUID: DV0W9a-mbOqEhRKRIYkh427eYVT_3lFe
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

