Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05284C4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjKFNNK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjKFNNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA8D125
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:13:00 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D2AEY006802;
        Mon, 6 Nov 2023 13:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=k9+mjxxIKbX6Qhzmb9dVC2kqTzofCdx4KOEesbF4pCz8Kv9BfMcq2gk0LMmEdBZFyzEs
 LaycCPbblj+Llu1D7sW5igtE8MHB4nF39aDVNofFqZqBaKGX6FIoyM2knV5BGPw+1zfN
 IBJsSs6QA9eZDCmFRlP/RWbeRUDbkttniRuolMnggAop8GR5bPu25hgY1TCATr/kRNv+
 NOc3BLwc++0TGm2YaUXUqdzAA1ThaKEF/cCX41C3rYOiElcCcLDRjngeS9mWb3/BbBev
 3YotHfVLBvCUF+A+Nvrv3qd1qmJq8YxGYM/M92z4Qxkk2NHZ6sZA9B8XguDvdUZ9JZP1 JA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcb08m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D8Rjj023535;
        Mon, 6 Nov 2023 13:12:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4tcfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM26XDAceA5WbYCWCB16kc6qDVSZcndacVeaPRhw+57JDyunnM+YESYlgIQcE5+Bm8Y01xZuyO+9HiEw33wx1eoVxfKT5ywo5+lWo3gCV7hpxDmJE/9QjuB7uenLsIKB3VHTf2ESyWk3br83+X3xVbYAUIivd21dxncHprU5JkKLh+sPM2/IWwBbSp2GTfSu6Tya4PPuXSSz/GdNC3c2a11H1XgnBAFS9W7FfrresoC+crGIMJpv0OV3jyPXeA/Qgwa2efiWr9X75h6kKSj39D1K+8csnu4T40QNkBntxc4meO8JSHrFGw2hEZgMwZR+1KlBSYGcM26S4SnUYfLlVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=e+CWMQY/9L5NmgpkhWXwgiEJXddfBDsPpLU1bMTDWp/kUXhcQGV7eDSOP/hVSyhRHTLnN8nZxRpCJR13DdhSZr1sduJz1qwqU36WXEdPJOLXuQzIcLEMOVFL/17dAZFnH1LWhGSqybX/h4L85B7L7Jyc517McO6xSqTavt4jga61Ml8xk+m9wmYxSP16n453eUrCU536ziOO8Eisqq0KKdR0UTRRlSHBraLhQ7RQ3NiyfOFMX0cty3wppQ6hd80N1oFx0roktSq5Aq7pc8K76ve1CGlpbK4M0YFbDzKnU2zddJyjSssoFuToKvUd6Ul/jWtutx7Jj8Nnns3cwJ66dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eo2H4ZdqcZj1h9U9KJV5dXdRK4RG40qHiLn0E+r57ns=;
 b=Vs06s6VxSrNlUU5cM+b/IbncFMlvIwTkiTjP1GgMwBgevwZpecfaSozanFqUapNDUASxJrnJ1lZskeM7/MARQxo2qgxBoNZXhwqV6Ep+9qvqV344fO14+Z+OsCzkwEiGE7/blqrrauwYGwSTXU96+M1trb3mLJFA7gDBWd3gJ5Q=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4513.namprd10.prod.outlook.com (2603:10b6:303:93::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 13/21] mdrestore: Declare boolean variables with bool type
Date:   Mon,  6 Nov 2023 18:40:46 +0530
Message-Id: <20231106131054.143419-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0181.apcprd04.prod.outlook.com
 (2603:1096:4:14::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4513:EE_
X-MS-Office365-Filtering-Correlation-Id: 49014c4f-3204-458e-5498-08dbdeca037a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGsOxKqOVUqfcDrPve3sqCSRpQtNhZNRU3JQy27vn6HuTh0ucRCvhCuIMUXfl7j3TNRJjsTP1uEKR15GykaGkeBUK5tigGwUP31rezHGKS2POmPv54bkyJlKuAonWidQ1gyJsYzohzCEI6/2pTUq+1+/uadztNHAnTDab/alUBcmQwf8tDJXXL+FstG8YhTuITFsrIbTf+OF7+za5AskDOMSaoyHxJvJCpspHPKex9PNpvPT5Ph7Wbd/AtzLaM6738icJ3HkBkrnxHGrYpKejzzD7OEO9RAZNrRKCrRaQWASrnNa47QsGIxzqKd1a6Jn9G8dNR1Ar3LsyAEIsGsNRCvibOV1WIZ7pBSxrVhxqRBAVSgCbxOsX+Hyiotm7gZoLl97o+iAAWJ0EIqf/lGlf5kGzeiDRPwogfTeNFuuZWYuSuGynS/4BUVQGJij+ThZsz6yEaoOvskxP3yywangy8nVOUhAHxUeOLTuKNinHVy96qF74naNdgZpMbrqUT/7VuPCvD9T2To7Yx9VSLLxgSQwn4AU4eZ/ww49WlxiYYAeJB9D7d67nvmslmkMyzCWd0u82XrZzgnCs++woPOnAtrOvBjcFXCETIQ0wgdF3k0hIRJ/FibpZMgRHlanqN3R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(186009)(1800799009)(64100799003)(451199024)(6512007)(41300700001)(6486002)(66476007)(66946007)(66556008)(6666004)(478600001)(5660300002)(6506007)(1076003)(4326008)(8676002)(6916009)(8936002)(316002)(2616005)(26005)(2906002)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E1fRuRCf3q4jq3Zci9YIhsvzTuIXeTEbF560AurqLjsO/g2BtEj+d0epXBQw?=
 =?us-ascii?Q?Lvy8CN9e40Q/SMd8Iofj0Bi2FJb5meSLiS6PfwoIL3mAnHHr9jOLKKxEz+f5?=
 =?us-ascii?Q?0uAFri29bEuovTzg30sH+TWF8tmkbSKtvXH+YEvX2K32W5VLsqkY/P0v7wRO?=
 =?us-ascii?Q?Z9JT9EAJ/lXIgPeo/x0KxQciVNTd4fUx9wkd3qm/BaEPN+MuiJYz7ch9vwlQ?=
 =?us-ascii?Q?UvdVNxf8oQDTNV9RKrb+amiYRV71jKeFDB0k7TsrEHQ+fqVKRZ/ZY3+Fgmq+?=
 =?us-ascii?Q?42D2CDERJ4K6GNWK4eECQ77twbRd0YKCkbgVXq4G4s27ftZs7J/hwyaC305E?=
 =?us-ascii?Q?oGNrpK+HVa3/uZDIK3U9x5c+auJAgBQ+5FIAk9tUq5jBI5gCgW14RyFW+SIT?=
 =?us-ascii?Q?zfxan8q8QoRxghSW3biWJJS4y/s9jovW8aUkgDSt9zkvQUBq5utaB+kF2Qlc?=
 =?us-ascii?Q?4gMlixvY4VM3dNK0tXfWbEYwzUa5BKnTlyr9dWgSgJ5L/MfUQ6++2pWk4sN0?=
 =?us-ascii?Q?qat0Og73V+bvQc0lBADlfHhEcJeyxcMCPQqdvFOIF5WiDBnmqn52rk4mahQS?=
 =?us-ascii?Q?hLXEtA/4c+4T4BmcYuqIXZCqzJ6biGf3JaspmhaKW1J8SDroDRtsj8t5B5AG?=
 =?us-ascii?Q?IYEMB2ik9LMwrc6Vw8m5FArspnXnrnPKuVr4F4LqKsYYQEnpse4w7h+wX17i?=
 =?us-ascii?Q?090557Hd/CZ7+rg+vhZLt/XcWRMhCXs7dO7U7vsD2osKSdb+j4JaApJ0sSZJ?=
 =?us-ascii?Q?x8zC74S8C+STRzHiKPG23wt/C7BCmsGt/LdOF5mR7bUoGFn5YiukdfWENBQU?=
 =?us-ascii?Q?qzqscUg1t8ANivANdTE4SYCbiN8sjPirSy9wh6VbF2mR3WKwTq7OaH9fzjBb?=
 =?us-ascii?Q?tNGO3Tg+1XMHLXirNzmCkBRoEuN55mW+aiJUkRyTrOwcT0y489Rrg4u3KgbM?=
 =?us-ascii?Q?lO6Z8onHf36dF7AlVR0dzzxN5dvlbxrJQlnjgTlrORktxu1ZqlDq75LoUBfY?=
 =?us-ascii?Q?3ZeVnkMf5OdX5hZe/WgIcbPoCA3XSJaZSnoiOPyTa9H0cMoiziibIQuKnI+p?=
 =?us-ascii?Q?lbfsrnkqXVkfI1JrYxnKwPS0CNLAy19f2p8xiGWyZjQ67o0U64kb0wyLaoko?=
 =?us-ascii?Q?ATY8ZVyk5mpEnkLzZ1hz2bMWLHhQZiYOwVd/C9RNl3MYOuFOcbTWjlVAM0tO?=
 =?us-ascii?Q?+k7P+3/9K2dDT3w81qg6wO8cSFBVgtEfkiHmaoXpsaddjMS927cC5gAJEZ5O?=
 =?us-ascii?Q?nHUkbvLZ0f+IvFlP/fGznSphiwFZCR7yiO2fJlgOfHEEVfAEPuCv+vVwA1zs?=
 =?us-ascii?Q?CYKcJYjxR4gaBOQHBo+7mvWfXyu2GYVUKG5DokAU5l/us/KmPZrv6TmpiSEg?=
 =?us-ascii?Q?6FujiMrMYcQ3x7mpVxhYsiujpGbiJ30CXGDvtbbrFRr8xfKskpGsoSDzd9F/?=
 =?us-ascii?Q?g3MjtynbzHBtZnT6tKu/Px0ZpQZOl+J5S3Un6O/3DJP5RvcmKuY13umau+21?=
 =?us-ascii?Q?Yt2XwjsZGh2z3qBfcTkoS/5MQqPprD1sdwv+L9J6vPrSs2pCjKh4DnS1kOtS?=
 =?us-ascii?Q?LEyzoREUVpNgLpb9UkLS1c0RLTjo9Ta+S7UuwlCI9XWQ9rraTOIFTR2R7sy6?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /MfIj5dq+YtfPglAlYcW9aUZKpunR8YoWJkIFcsNzE77BLLH+CinMVKaZiCHZn4SpgbPq+4aWKyBCpQnhWGzof0jLB9GgyJTwhzWY/iHgJx5PkfGWx+38292eMuPkZbmA/mtvfZ3pjwQuntul5887qKsbqQkQscCoK7iY7F5qDPs4epjVvap4kIGOWjgdNbUMc7PZPaKXx6gFGlNcIUoaqSBV1hRtSzBUHbQaAup3ntZxIyY6/PZx+vvKRjocaInJ3tNl1l1wkDgASsgfG2qIyOamZJ3SRW61PQH16oW8l+htPeviw52pRLcdhDn5zI1g7uxQEKl87+xohJiS6VUMY+rwVlRJtCJweSSAQgIa1Z+nBW9FInkTI9G4Z40ArLxPdiBV1rDGWibfW03h1yc83CfjCfrkRAutkvTJTD8YfaUDM+5p9lE6M30ar0n7tnQABRdJSlvgvMxuMphFALnGsPF0ium+uK3r4q6ddfWRkuYqy7VDwTiGzZLPI/p/OvzsSpa8pQ4QZsS1gkZQSvlEAmHiPbyFx+Cr3SnwwO1Xq0Q7l/wHC/6hMOuxkev95E2PYl63XONI6JEvvk15PYNXILXBtRiPnfupjABGU1YgQ9ZoUAZ8ed/vnTH7N6PHSkT+0q9vY+Y8KQAnFIDJXovNloLBGpmUEemIn8FDH/xD3xzHQxsftPO4xyoUQEPKO86zxErJFWMBXDHedrUQciWAT9wUVti0fKWGXPddSGC6/boAOAoDE+lFlPoD5YzMu18AQ523JTMB2nn2S30mp7kB6aqUl5XNJh2h3P/TRTRYR4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49014c4f-3204-458e-5498-08dbdeca037a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:22.9155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Xve98O7GydvlO+ScK12o1r/7GOfRwQ5SI39/PjPDNFPzGfSt0AfC2Ureatxsecy9/Yz8TxV/cXFNCbmqtTJLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-GUID: 6ZsshsMpqPoX-UmVUE0sU8AJy9UlJDV6
X-Proofpoint-ORIG-GUID: 6ZsshsMpqPoX-UmVUE0sU8AJy9UlJDV6
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

