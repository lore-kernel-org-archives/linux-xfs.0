Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7936DC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjKFNLx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjKFNLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:11:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8E6EA
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:11:50 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D2ADv006802;
        Mon, 6 Nov 2023 13:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=2pyOlySe7vXPGm7Xsf4IULIzTasyZRfXCj9H37LiNiA=;
 b=GkfuWiQl4JsuW9gRq8W8KDdMQBrqEIHM7DwZTWe9VXT73dSIm9XU7lXoFdOHOrnlyZxi
 ZkKAc5QTLWRP3JDc3VjsDwijadKQp67tkwL5sCEsTUTW3Er2BdkDGR7YHsiyBb6DGrbl
 vor05UTrM+adoRC7fXbZf7tdXt+AI/mNbl7SZ6FL8XN0wxhGXFO7vF4GqZ6ic8Z9E2Ur
 /CQZX+ISxpUambPcAX0Fa1VNIMF43f1BNBtl72o72ixL/ihYRO716GvwxsHEg5x5swTq
 GfqaANn85BG9jD2JOGrJXeaN33cPnY4a+XdEVu2NuQEUTr0qDI2XnRpHX62y15eHnFfm wg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcayy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6C1B7L024854;
        Mon, 6 Nov 2023 13:11:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdba4c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZuG/WyWVIF3IeqxtdufNYFrYoN4aZ7fyCP6ACbja26ec0X5pvgrCkVeF9AZB30kgSwI5bCqzqQX23dRZmRnSsik95IJHFSZlymxFnuv1ZVZg9r8ReqTwxSy5Y7sFZRNidd4ZaoRSVFLg0f3AtODkJsvUpc1LA2VBDr9X+azdKYB0BSTtDiiR+CRm0Zn26eyNNUlXb3UzPZ/IPZMrqfTqcXz4DJpeL4kzqJajLMdouTJ7D3o9pzsfp2CVsbtZFfBX/YDk4e1Ald2ik4ODN1ntqzop/dT+f2PmNjyeWs1PtqVbLmd5x8FCPuc02FOlUkQGxu4A5CRM4oRr6uBHOmvakA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pyOlySe7vXPGm7Xsf4IULIzTasyZRfXCj9H37LiNiA=;
 b=TEQAGZRLI9K7xOpMGy+CYkXV3siGJmgopR0d6rugEcaCKMjtEBTOoPhszr44gtQxYddxajgqeuv54xucW5JcoJ2HwMTDYu9QjeYrdRuzskq/bniAdbbEUC09uyf6lYCjNpJHqmKGe+q+TRM/LgHEWMo755yXVUOv1J8n/D4jcGayVKGGZE3KLF9MNaYVV2pLyJnc4nvPjhXP8H+ujYI7qia/PXseIrPegwp1WlVlQO+CIFPVo0fkpJUl5rZWXUmO1lzCPPWUzz6Q+LjG+U5DZeEyZWqdaeE0fkv7z2v0ntrzzDy2YigPg4ldD/0pvWOE20SZO11CZfxZePwKI0/RdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pyOlySe7vXPGm7Xsf4IULIzTasyZRfXCj9H37LiNiA=;
 b=mSL+UgH1+jCoj4DZ2V3XBBUgacE/L1SSVciVn0+SYdA/dqsRXWocEzEnAvzXuEPHsdCkVySLdtZBXSo0aRtpnbUCD6/Wzh6VhVGlbBDq4JqQKoSMpp+33ia9yD6lrytx07ep+yT7KT3Hy+FxBZD4Z8WQqeOqQnjl+tjrvpU3VDI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:11:44 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:11:44 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 06/21] metadump: Postpone invocation of init_metadump()
Date:   Mon,  6 Nov 2023 18:40:39 +0530
Message-Id: <20231106131054.143419-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0152.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 032d203d-2172-4c66-bc50-08dbdec9ecb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XRdhIHRa5HJ/kpClyGGwTFwIy2tW9xDGFfmV4PTOyw/R8tv4hVzstZXA5vC4GoD2wno3fGoQjDahUWBUEiC8HxqsXD2rVOvSkRmQVBcxxNJ1iT/4LJ/usQhirDg0xyXN83ZfX3MDF154sQmYamFr5cjdEpbo0QCqcQ01XafSqWlyVz+mTTEW2Fv0sbYpSl+t4GiyXlftn2TmE/mooHBk9rAWTLH8izdkA20oYv9lm3TI/WIBsu/c4qlINT66AEAWqLI8T0FZnkJ7PzBJVFB0meF6IxdKwHS9bf8IW/S5vC+5NDLrcHHWQ7NvfPCY5WJL27oP82meXUmEa159sbLNA3GDmG2o3MH4Tt0PgnLn6dRLOiFsxI70xU7AULK/BgbgLjBREhMItNE9Y5qfoV/LAR3Y+vruJ4+ipr6YrcDFomZH5dIpZVDsCyHh5uLhLzCl5qQ84CJOL4a/NRlds9WspClJQ+Uoqh0DZyHXFGqxSnxl8nJyvVSscvVzjIWb8MIGMYx2Hf4uqJjqtXZ6jinYt6kg06UuAaMX1HXXiA4gxBPhhCgnoJJldpAwQ/K16mGz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7I+i4NdPNJkQznJxQEgj31Qt1QepPAbMAfDr6FJtnzWBapK2nkL9DQCXEVXJ?=
 =?us-ascii?Q?B5ZReDNKM8pS8k4vIvP8Ve0xJ4I7kXcFreE3QCBsliqWNKK4rTFS4ywZe8qc?=
 =?us-ascii?Q?U0O2HikgH17M6A2dx63u3ur8BKHVWHebiOElfsPzWn5MhmfqgK4GnXPlqsFi?=
 =?us-ascii?Q?IxdbG2GjVYQXTjVLz2qSaWJj4EzavCi1WvgQt5QonPnkBwV0Uguk4tg1xrPI?=
 =?us-ascii?Q?rxfm4p573F25HXKGvEefAg5nzXmI7pcOx4i9YeKs2pm2Y24Rd2BbjqDI8TFd?=
 =?us-ascii?Q?YF4ktsOL5ngj6+EHow8VY6bNUhs4w4otCOrmuQN4qk+SZkqbJQGpIhiXwZJH?=
 =?us-ascii?Q?CZuQwpJQusfcsK0q094/Skl4Yi19G5VamWiQcV76u2KdKJjXabf8ODrnpNLm?=
 =?us-ascii?Q?XxIveW116KdeeDyTInqqkk0PbZTiV9EE3RA3iuS51mogJXbDd4MRPk9GgF7z?=
 =?us-ascii?Q?qITEQ7p3f5Cxe1a/1pg4j2ejeRiF6UlcxI8JlPRKANZROjw6FyzLHZWVYfp1?=
 =?us-ascii?Q?1r9nyroSLO+PcXbiohkzTSkHhR/ERQwQdj2tK/c4C/OoGrdH1RDU1cPhRcBX?=
 =?us-ascii?Q?TJkWYsC8f7ALE4WySGZu19btBh6BlMYfyhLyvY/4cVSO7L/XbWMLK0+CgzHe?=
 =?us-ascii?Q?zMaotMhiwu/CCGjoF8uhGpDPaBAWKmim7g68GqeiGR/w2ZBEr/9K8JeuBaGU?=
 =?us-ascii?Q?XjwvfuGI/2GEdTu4za2B1+0nvU1QHNnDbzybFfMJCm7WNtbk3vw93V2Cthdu?=
 =?us-ascii?Q?tYie8jZs87f4Qrxorg7MTVOIUSc7rDHqXdLoVffaEVnPTMwweAmzy7omnQYz?=
 =?us-ascii?Q?QfDL4i2+RudMTdv34zF/rTRv6TUdS5Og/j92AdgljjHcIwihy15zqmnBYA3m?=
 =?us-ascii?Q?Iz/3UBIx1n5PTLi0N9rtso8nmQyVUM94RzxVTbucxSgrc+sUmiIej7Wp5hlP?=
 =?us-ascii?Q?AesRVWN3eLkgw+98iENNAEsKBiS+erEjtv79lWljRBh+/B5xr6NyfZBG4/hY?=
 =?us-ascii?Q?RKLoSFyU5UWH+0pYoFfGi7DAdbp31R8jAqUTWx5/zyZLDiTOKcPbvYRG9Ab3?=
 =?us-ascii?Q?ss2rjGBJ6n9dRhKwwMQA+HpgmG0D/Knl5pbVgONH0rN3gd4l7b6E5OgJ+OxU?=
 =?us-ascii?Q?c9NBYAvA8YGmyN5KV5NBLJVxOhT8LAA05/ISkMjpPE6H4qr9PZfun3qVBMAH?=
 =?us-ascii?Q?bv9l/kudcDMJNzu4JvNrL38PU3oMzIArCnSTOPRYw2elbC0WbXT3jIC2j5gh?=
 =?us-ascii?Q?NWm5IdAY/KTQ0pdJQvxzPUoSABWIG9XIroX31J+sPSNo4gq0WDrZH5jq6yu2?=
 =?us-ascii?Q?6QfyLd9M6amFIegRt4BpLPZV+h+99bz8ZJd5z08LrnBreeQMLfnlztpv5VQQ?=
 =?us-ascii?Q?6gv+dcPmCOP0kfpqJHoNu8ODhE6nu76doac37U61zNks6c5INVShpw9CRcTl?=
 =?us-ascii?Q?Ef7hm+/XoTvT6JmPm7NHk0+jjAWpmh5BvrlDYAhWMKrjs21MBb1CIUXaUWwP?=
 =?us-ascii?Q?ybraWKlAQQFHvLdFctBBCkwvswzKvZnx9Eps+qrPS1Itgz4GDbplP+8g9WjC?=
 =?us-ascii?Q?w/6cTss41RF2A7d10neYZ8UH6qBQcOgH/IvcDg2E?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kIp3k1dKXlPl9imDjyTyuUWqoRZmf5FfP00s9TibAFZyLUDHuqdqgnsFnQpkoKqL/HkcTrCAkZ2f6d5DTFISMt+kJhrpe8Ppd80iamEcM0/pkQPjz0vgyaU4uRntVsl5YkGutG5IXHi88ciuRWEAPk7lPZX5stjGxpYgTZQBbT7ENQ+niIbSKJbvAmB005rFHS3wpIsZdEvYQf/2buKCdx+k7U03XLpuAM7SPb1qFfF08tec7pLYeHrWIqenYXMmdD0op+A/CSAw/DrdYPnqPhqAZLiAZsgfIvMzh16ymURGSw9vuKrfHB0NgtK55WRqvpaEfZQDCEySufTvtgW7Ys9GdCDwG/JcvfYJmLWiRXUZjS/wmXqTut/YFlSrM2yEKcqlbJD/QhEjSr5l46QTLry9udrImVzgEP1pcIYjporVVkXQMPvEY2+5Yboyy6OUZ8mz9V9c1kPADhxJxf4ojXitK3o13qsLruP2QXVsLRhrUk8galav6Uf31bOsiWTa+n6uH0uPsoRL7+lyTK9wOD/PS9JMHS87zF8PHSJcypGPpSrHMM0mGErRpyvDIAVc5fPV15QwyGMsTW+9RH0kc7+9EBZJPCVKFj7DftylRuPHpmW/AU/DL8wbVgRkHoTMnjP9gN87Z/xvmLJXaXuJ6tbLLIRSPpncHhKZB1+pba0A4gZLMPIjBM2BGn6Yb87NbX6hHKUxh4lNuIXmiCrAjQg3kQusMBbJ9uXoHejLv6U80m/Qvg9RxrUsoWsecJGr+xh/8DNTr9pUE6aIVbfU0kIfLJmQ7Zsoe78yJmGa8Rs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032d203d-2172-4c66-bc50-08dbdec9ecb9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:11:44.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jr+Z+dTmP1pW56/yLvZezY04v5ql7txWoqly0PJ6KVhFnZHlh7zhViLgu4B8NPmZiG2nfl/RrPh6Eg1vBeGQ0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060106
X-Proofpoint-GUID: b9aVw21I4UNM89myojrG48bmWiCpCjbi
X-Proofpoint-ORIG-GUID: b9aVw21I4UNM89myojrG48bmWiCpCjbi
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
index 8d921500..24f0b41f 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2805,10 +2805,6 @@ metadump_f(
 		pop_cur();
 	}
 
-	ret = init_metadump();
-	if (ret)
-		return 0;
-
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
@@ -2853,6 +2849,10 @@ metadump_f(
 		}
 	}
 
+	ret = init_metadump();
+	if (ret)
+		goto out;
+
 	exitcode = 0;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
@@ -2890,8 +2890,9 @@ metadump_f(
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

