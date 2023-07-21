Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6077BEB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjGUJqd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjGUJqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:46:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFAE2D46
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:46:30 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMeUX025821;
        Fri, 21 Jul 2023 09:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=M1Fykt9drEa1+zTcVi1eSPiP+NLoBkqrG8TxDFiEwz4=;
 b=ryXo89wfp07I/qBPec/5Rl+vZVPoBxas14LU8Jjcm52tZseSbpURt7/XhUHqwoGUnrcf
 tA15GNek2gHSv0MUDOGT900/QssoeY+BdqOmJn7LwtupkSvEEF+1RfhJ2cSTJLQxEGYB
 p/3UwwuEfz7Gn+OFfwYyRVMnYvkX9UgGf7oZFtpp9+rIFXu0VchUxAVtmsdrD561AJhq
 rVYMS06/cnV35F9EyzjKY5LlXKt1IwkCyP8embgX9D1v5CxqEy+N834q7Jb7AagarWd5
 Eckpu5z1wWDp18gLap0DaEzbKrP+cUPxaUqOMin8unXzb9+ik1viOhQA8/zkDhWwIkDl HQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88upbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L8PwtR019176;
        Fri, 21 Jul 2023 09:46:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwa91gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvgNnH78EvwbUqnuUaP7Kk3SyJo3x/1nJw88ArF3uCG9ufQgDJBG/2Wmel0jX9X22XvUuGoWpe+QuXTpNcE6bAZ10q11OiXp6rUUpvl3ys65ZsqLjndSgU3gM0IcnB6ZJAz2a/tQvqRd0V/sIt96ES9Tg4FXX/BOC+J0PjCABjiFf8r4CIX2ahjRL5tZD0QTtOqVan6p/2+AFFtQ7NG/ZUfuLRIdVXpbSulRNEqJsJfdht0QkXNTg19EXV4wSLJRE54Hk6nZnNOdfunJhA4M93ueFIfZEHCEBbekydY6QcTUF9pmsQDOTye2yvqWO4zJ7TbzFBnb3HA4FJGzs2olDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1Fykt9drEa1+zTcVi1eSPiP+NLoBkqrG8TxDFiEwz4=;
 b=dBLAywu3KxQDWpG/G1rvfafkLk0FSr1qccp1jTYxmvdSvXgYaOrLpx6Pmhxvrsm1RuT4pCew3Y7fTUushkWh2O1T2Zyg3GyOvWMHRdD9VMR/y8sU0luc3ecI0frLZGrVec3sNtA0H7zwJMarBCbUszFX8QwBcdNGDuet7k+VIYLAw6je5UHJZIUZ2foiiUr1vt4c1JVP1oVk75oeJY6ckrmxsCT3L/yTl+8kpYjJfZ1QbzofWAshlMS7X4Nq7YG2FiPpZwhNLBnMRzxEtDD8FlMUTnj8IhCL8UAycWvCLbflHcoGQqhZgpRkQHn6KVyUlp1EX1Fl1ezSfW17rmAqwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1Fykt9drEa1+zTcVi1eSPiP+NLoBkqrG8TxDFiEwz4=;
 b=UjJOfOyUUZIo5bGbU3h9LXSLEFTwFQlZkN7t0j+CsXebos9dioeL3eUcJqXrG/U4YuQGEi9AbY+FyylRI926JrYWFHOiLWQqhlnStYquPAr/v4DxXIgTsSv74m0EbdCIFVGxtfrv0V+dLeVZw0Ur/apFfBLxMVFSvgzP9S12/JI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 09:46:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:46:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 06/23] metadump: Postpone invocation of init_metadump()
Date:   Fri, 21 Jul 2023 15:15:16 +0530
Message-Id: <20230721094533.1351868-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0239.apcprd06.prod.outlook.com
 (2603:1096:4:ac::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 847d5cae-ea3b-4792-3210-08db89cf592d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1TyFCoef91Fu2klcSUThFVsdWtbRG4ylG+aRjMJul1vlzi2vCuOc1wR6OY4s1WQKjh8ZS1yPh0ex4mpb+kzwaISVqIF1b9YzcIdleISNNQqDR4ogt3vGIH0fkjHcO1DGQXMEgaCAt7YCDI0AYftiYrXrjgI1oVUKyT9OM8JJ6ac5ij01vP2Lk+4w2wwSUgn/SX/rTRznxydTuDLJ8V+a+BwYs7m6Vg+eP4pkudkX365B1jWLCwTYVIZqoeaoebWqrs7cGkfz9o2LZF15ONPivB1cFs+SGiYnJOJNm/MvqPzi8M6Q8IYcKTr4ofRYIwUSJvbv8La66gz2NhnGo9rCT+ypFoSYliQ9O/6nwVYv0NsYBpHS9vCvCK4w4QMcV8IBFHsi+QP8TcYDDfxzf/YizjojmmbusRXK5fxmL24D5YobUXeVHUL+epCFSXPPA+cb85rj0hRoUG+tQ9h35nDmwZ6dYZUG+U8PmxriPtq1tW1uuXyjJ3WqIaeyWiI0NACFs8AE7faGHiXfnVkW5GY74t7Whd0O0SiPVILpgMLCeiZw9Sfk5O/3IDEXK/cWMtro
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(6486002)(6666004)(6512007)(83380400001)(36756003)(2616005)(86362001)(38100700002)(6506007)(186003)(26005)(1076003)(2906002)(8676002)(8936002)(316002)(66946007)(66476007)(66556008)(4326008)(6916009)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yLJ6mZxqvO55aaewKIrJ0vonDQa5gLpNzH6zH+ARuySHyVV1BumqgAm5C2af?=
 =?us-ascii?Q?iPb6KBIkye0exXwvk80qxJLKrRLfqUOZLMcPEc3OUguF56GiD1L7DafcRcuO?=
 =?us-ascii?Q?l7tY7mE28WQdRMmOCc4/B75TvMi1wSH8cu/pV1RC3OYPPI+JXWrFFuUqLD7o?=
 =?us-ascii?Q?bZLUpqwqW123Q5AO8bropJLToRAaHimzjlv+VGmf8k+0Po9xOljEoMZTYamO?=
 =?us-ascii?Q?SrrRcLYTNvRJPXSq/QKqe0ktRB+XlBQPTOz/NQuGj+eDi+Wp085esdWNjlZM?=
 =?us-ascii?Q?1zT39ounykZzFIMJIghl0Rcm1gP+Cpd2uxieNx3LVzpN5wfWGz7WfkPbYItJ?=
 =?us-ascii?Q?PI8TKMiY0QeZYCveHeckyFYkuDPaR1aqCTLKYrmjVrw0jFmAZNsXBuzAiuOw?=
 =?us-ascii?Q?8fYz52yixgc1k++jqfanNcIPIoUohDQk+M0CqvqbxdgqZQX2WezI5BeHxuAM?=
 =?us-ascii?Q?RwI4OG1cgaKZoCa/zfl2hs6U/7XxGbZyZTmTEn4rzwagjOiP+XqDXQHxhMW/?=
 =?us-ascii?Q?lSUujDPTjU9xyKrvZQIiU0/h7DszVfp5tI77kFU2ngXlJmPOjVaSrMdTYVnn?=
 =?us-ascii?Q?tE/sSZWCZsf0e88OaFRdtDA0nvEUuRTy4ujJE9SEhcXpM8FoHfgBoRIFxA4t?=
 =?us-ascii?Q?86uPLdKMAdClFVC7JNFtVNUipTl4wI1KLBHI8xTWYpgE8TBJ92Xgh9vhEzDL?=
 =?us-ascii?Q?crhuz+dES0aWlZVcMxRKyDFep6JKsclT5BeZQWmRfjH4s1ccUj/r5CmIq2e6?=
 =?us-ascii?Q?0qeuHw0OJM5cNvxkeqOXypxBKIMK6gGRuB38896ku/JlbBrK7HOaBWVWNoJW?=
 =?us-ascii?Q?rsLcN+Ltp1oa5UEDwlL1kVZO7lhHXvnZiJr6esjzs6Bs2u8SbYRG0Bym+Kaj?=
 =?us-ascii?Q?TcSl+hiL9O06/EjpE2EifXd0yqs1ZMvCcoNO56hw40dvVJnpDrUdxhuaAZ3j?=
 =?us-ascii?Q?UjEleX2QT2I7a6lm/66iq0pFQ9jE/ED8Wh94tNtiX0lealytEeUqtqT7BNhq?=
 =?us-ascii?Q?ghCWcP3BuF4DSfw51jUTXdawIipYW3fZg5tq6HIL9gC8AQ/7DIFps7jO1L3R?=
 =?us-ascii?Q?68S8HPfIwQXOiWNHe7z2tqetVKwwEzPDQLI8EsgZxrMVRq1ZknSt//o+TEOo?=
 =?us-ascii?Q?8WbMltZMqdOWdzGI6Z4vEBm4ENl23PxWO7Mk3LQ+mm9CDQn1XG3Ke/04sIPg?=
 =?us-ascii?Q?0caT+ansTVRZDgnDfPAqfeS971eJjiRxA8w5e/1qBGaQtnnKIiMYNrNyZxrL?=
 =?us-ascii?Q?jZA3siLypAa/QtlZ9vGSknggOMQ03gH5TrcaVerXYEc+sltM/OsCGjVadEkH?=
 =?us-ascii?Q?phVzdcLp5jCkKrahf7o47ISB0oKmoQ6jbGdhaUDAiFiODDJEcWYkI/VMsutA?=
 =?us-ascii?Q?usIiT4dam7E1NIVKnoW34dkwizljhZ9IQdV8gF+vXeXAm7BJo4Js2z9jog9V?=
 =?us-ascii?Q?uy10tNXtCclFXeY9aBGbrOewwwO/1LkbDA17grrZwapjBDg69C3skqYC27cP?=
 =?us-ascii?Q?aV3WYrKzVEwQ/lKA7rXyPIY54IvoR5m7TL9v6ODGX0dOAddOoiAUzfT8ixkv?=
 =?us-ascii?Q?LT2THzJEA2fD2KtSbJNAHyEcnlJRiTnSq3BZ+dK4D/NKuQHrs7ZbhLmc3YTV?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0hHKxkI891vxNtO7TwmfB5XbTUANOhFGs9lNXRGAPAFjSwv6VKYAG0ucY6bIUj6F9Rc6nabHpgvBSbNiT7RCuulUAsTbgCQhJHI5mBG1q0N8HgI94xw7b9/wxsN69FejJqnHKNEUELJfwAz2gCLj3kxuQQth/HPU6rxX7AWoNgaDpjTGZGVs0qJSqiVzHQKsaUhMb9QEOhDd23goX6B0fiRrgHW3JVY8u0SINCZqBAf/CrSzST6ewdJq8RlBMlzXkqIPouLBBLsWxKL35V5MNR/5xXyUvJrLBhnaO3+LtFQjqhNapRUQ5SxB84cYu4E/1mXh9CpPey2e34TIbvrZz+F8S/onfun4qRR+rto8V2tdm4kLZg4XEsMzXQi4RJdm8eck8YfpArhZuR0Vm9SPISjlzKB2nrMQesQB35kCFY53Fq9gBoTN6IgCjU315PWpue74DXM2ETUk8kOqyxYFlcMdd6E28WkndY+ph7jytlMPoD6F12adyCEsm3EpuWeWgetBDwEzATIZfhC3aOMk+lMxhWBxn5PYZq6at+9naxaICDRUKnyThfzTOZ8y4fdQbp9RST+WwADbjPlJUYdqLuCLrfiHMPj0Wt6lrSREOOz5JqX0AaVIx4gbkJwlRvQyRLPDRvF6NGTOpygLHnZyoi0oSL2VkpugTizRZ9WzT3PPZ+e4JC2ugIW6t3Tx/v4JKlIg3XFijXQ8Xf0LlYpqdYXz4N3CbatyVp5VLM35UmQri8+uvREiCtZffZmHzRtmCXHLKejvkmFiRE82bbLi7g3dJYa8A27nqNX6Fgy8W9A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847d5cae-ea3b-4792-3210-08db89cf592d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:46:25.3127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lU0UzqWFjdYitanR7adztVlb6q65qbAiwhLuKRRUj76OW1ZbxmWGNkS0WCuKHzpONyFKZIsPPKKBz1Ik8NwOWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210087
X-Proofpoint-GUID: 0JQcrXQ1nuspuJZesWndr4mJ7LByFdlS
X-Proofpoint-ORIG-GUID: 0JQcrXQ1nuspuJZesWndr4mJ7LByFdlS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The metadump v2 initialization function (introduced in a later commit) writes
the header structure into the metadump file. This will require the program to
open the metadump file before the initialization function has been invoked.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 8bc97a6c..aa30483b 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3125,10 +3125,6 @@ metadump_f(
 		pop_cur();
 	}
 
-	ret = init_metadump();
-	if (ret)
-		return 0;
-
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
@@ -3173,6 +3169,10 @@ metadump_f(
 		}
 	}
 
+	ret = init_metadump();
+	if (ret)
+		goto out;
+
 	exitcode = 0;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
@@ -3210,8 +3210,9 @@ metadump_f(
 	/* cleanup iocur stack */
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
-out:
+
 	release_metadump();
 
+out:
 	return 0;
 }
-- 
2.39.1

