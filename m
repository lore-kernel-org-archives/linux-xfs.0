Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B716C4321E
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 17:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 274C861104
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 17:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbhIIRnW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 13:43:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53966 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242040AbhIIRnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 13:43:06 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189Fdr5j029613;
        Thu, 9 Sep 2021 17:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Z+A289xdW77BAPzyhkhHL2Q05rqvjwmIRFA/zf9YOF8=;
 b=WQZEhn0DEtMR3RbVrEuotLzXZU5FNK/0VB+TnqxnZS1hQTmJWQ407OcRG0xMJxNrxoJD
 lLLThA3FAlrw20FfVQ+MPZgw5Lv+1AyQiqC8Km/YZV9RSdFiSP/feVRHSmHB0Ra6n3gJ
 C1tQO36fHQMF/azsMNKxFbYmWpaC2RQln9B50JdC2RwjvsboN/mMVPeUuGneIUKMxbVu
 knNzeCIpdCuFp/G+xWn47sNFghx52jYZXREB0CqLqhSME/9OaSQh3Vp7elP1VkcbOts5
 aJtJWLQSq6QsYgmCY32m2U5K1cLW742Ub7RYf7miV8VY48Mp6xCLyZedrsWNwv5eyAd+ 9g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=Z+A289xdW77BAPzyhkhHL2Q05rqvjwmIRFA/zf9YOF8=;
 b=spPif1BGmcpr/4TbZYXwZBdKHmP7MAHItAbOjUeA83CNLSGtcPVW8BJkTrKoao3A0tLm
 wvIfDwaMC/En2/FJa2aAoRCGp2tgpsox55ZOhqBu/Y1XBv1/hi77w0WHdITfk8Zezbor
 ELR/dwPn1DjowP4uOvPq84D9694nYF0IHQMW26+vWoQhrFR47aDsYmXH849MuUHpqR0g
 ujqlMTuHGO2nsnvpZ6Twvodjdolfe55EfmoQ/pkf7cqa2YD9eTa0OtJfHvyBZeX62sAN
 uq7fNPGFwRxxpJxjvharboEracP7NUCLyOWxrAQuzBiXBnbSubZ5wz41PTq83RPBOEIT CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ayfe91k96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 17:41:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189HQGZ7172333;
        Thu, 9 Sep 2021 17:41:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3030.oracle.com with ESMTP id 3axcpqj267-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 17:41:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTr4IVxEGazoMZgW8QOf+ksB7h26cbkTcYypzZ95ChpOp/a4gcoZQ3MMJQWs9B6Z8r1RYqDuAgZlmcHGv6AeaQRMADRAAkJaWLcfXlNgy+G4YPFxOKC6gcbxaX0LqaeZaY+ZDW6zk9c8r4MCmtTLsf1N6NSuQtMNikhTio7wcX7H1IaaQHuf8gbEBCn6E1+tLfqBgG340pnsJL4WCflILJkx3THvSJkujNmz6msQWCOKQhRjfiCvCwadf2QVrJmrKo2S26ogfmSV3a5WZjbkVVRFUxHI2Aa3mZ/BUwTtB+auk3mqnI8JxGVJ9ilz2dT+PBbEhPHrUXCQqimx8Vct3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Z+A289xdW77BAPzyhkhHL2Q05rqvjwmIRFA/zf9YOF8=;
 b=hMNZxP9wxBqN9p9j3u/rbKq10SAWVDMbBMDtSmNWuIyrKHwUPgSRvryNDgC74zEOwc97X2gSukBXeUXjcjpCOJi9r/YVkrYSjSxBivisDzH0zVMZbEuxsWHqt7qJrVkLgPu80tYo7rIn+2Oy8axV460/plW0q0ZzBY0RcG6dh4qZcK86kjn/t5rXgKVAs3FJKkolVF2asOTmtlXHeApuPZooInjc6z7SNNTBe75AmKDtEbMcl55tfFBN0vGn8viWTA3bJxkrhhb/M5R+X3VjYFag2yNY2LKWdEIiA2jdVFZvaSOe68a5QIHgHvJ7TPcg6IJc4pkXFmSTBmcZRLlsSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+A289xdW77BAPzyhkhHL2Q05rqvjwmIRFA/zf9YOF8=;
 b=sV/D7P55iftCDvn3X6ImdnXjEDio6USBWqcTuL/HDuJl6e3Sj29nb/+C2XWPpLBsGEW2tJNFiSAc5rTfgZLPPK/ChDnVnoLxNIDjtXC9ZGLM5tIlBPKJ24e3PZDvc6HZ/8DZvdVuvODktWPLwKHWPJ16X7BNnODqcvCkvPvtWTw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16)
 by BY5PR10MB4321.namprd10.prod.outlook.com (2603:10b6:a03:202::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 9 Sep
 2021 17:41:52 +0000
Received: from BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::4cf6:23af:2f90:3e64]) by BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::4cf6:23af:2f90:3e64%3]) with mapi id 15.20.4500.017; Thu, 9 Sep 2021
 17:41:52 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 2/3] xfstests: Rename _test_inject_logprint to _test_remount_dump_log
Date:   Thu,  9 Sep 2021 17:41:41 +0000
Message-Id: <20210909174142.357719-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210909174142.357719-1-catherine.hoang@oracle.com>
References: <20210909174142.357719-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0349.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::24) To BYAPR10MB2791.namprd10.prod.outlook.com
 (2603:10b6:a03:83::16)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL1PR13CA0349.namprd13.prod.outlook.com (2603:10b6:208:2c6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Thu, 9 Sep 2021 17:41:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c728bd9-6994-4f1e-7dd2-08d973b91ba2
X-MS-TrafficTypeDiagnostic: BY5PR10MB4321:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4321B8F0E52DDD1A1E62095089D59@BY5PR10MB4321.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhcM7hVwgHKREJ82WkdR37dPitwN/h1F15YpGQDG4nw/bvTYzql+Omq1B+TgJ6e2qCihWjdhNkZijW64HYu2s++zaqkN6Rfymf4kH2LXxz9LmI5PH8BQXNlNPvyqM7aBEbwGxkRON2Mx3TRE481iH46+lWb0W14XE995r8GcQvQ4vk8gOGNv1rXAVLOPQczBSVmksAZ8N3p9KhFnCqwkirWVrKAW2JHvnS4WfL3iUdndZ7x82ZQ3lhqg4gNoEifvjDsl9Wwj8gpzpf7X3Sl1a1NcSWBqkfOSS6UAcajUBXCyRnzir5MEJsUk1cspui++yeBBI/AyUHzOmnbYemVDmhNw+qDJYAB20kje7LUxBHY0wOFnUmKEgYP0cPgBGs31fpIAG/XvHS2OtJRaWOT//EpTirVUHfksfrTtveMLqYp/2y8M14aLRoz3UbPTWQpWOXxBFC7TASGNDLTdfSI1p8xNVHebUnATKPQd9CryQ2wcpmR7HiT3wINGzro7U9O0LhxKj9dqEYxtG5tAZv8NtyScsaGtp8TA9GNGUbzPxRvttUGRFVA6Rmy88wU5ezxEslGiOP9xM9Q65piWYWgOVXqmjuD+sFGOyqETGcvEnyQLul4j1EtUhQ+t9IpiGpqFYcJ0bkabFncanidPkOsrOJ/22QNgY9w9R9hytOIVTsc6FO5lCmOimv3ybuuRfaXoTX3+o3ifwbYdl84mXAd4Fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2791.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(956004)(4744005)(38100700002)(86362001)(38350700002)(2616005)(6506007)(44832011)(316002)(2906002)(26005)(66556008)(83380400001)(8936002)(6666004)(508600001)(186003)(8676002)(6512007)(1076003)(66476007)(450100002)(52116002)(36756003)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sOZuLJugYWGuDGKC4GYXJBH8b6DWrqapoW0HfOhCTwTZ9VClErL8DcM1q5Nm?=
 =?us-ascii?Q?tkQLqq1prwvGy+wlh4BS3P66cAt5yA4ilEgReZDY/yH43ROHlqiO2Ib/Dmdg?=
 =?us-ascii?Q?YQBq5IL6P98boG5HYoptJzdMjM7b5sSHxbbV5B5ljbNP5RB5RDkMWmyix0L0?=
 =?us-ascii?Q?wrpBo995WM6G0/CWPiZMC1sk63HqIosaQqDbqM0tI5UhXfOoDPrAl+k5O26+?=
 =?us-ascii?Q?WWJz98/lAKlvupijVLNS1y1IhbQYg7zn401iHOFhjRNHluqUGvg+XKWFX5lC?=
 =?us-ascii?Q?T1qFtIKNoG0XvymOASdL4rrRTZ6pS+DyG2IsbPmBFgsnUIqaOmVvu0chJrPE?=
 =?us-ascii?Q?WhfttCSdOG9gJvgNG9Eo35Y5ZjM3sxORz20deybu5xj6V49nR7pi6n4lXSMl?=
 =?us-ascii?Q?pc9qF8b2Gu9QZs2Ql/V2sOV0dDX6SdJParSzJKXI8TJQFdYeVvZik5YUprNq?=
 =?us-ascii?Q?Nwb82+aX9OHIyLFm4Goda3r/KVd+Cjx9JWYzfHk/6/VuSkfXm84BDkVLoscJ?=
 =?us-ascii?Q?b8T98O6P5k/NNfV768wx7caIawgZKfZondMOJvWOQjKrVozn/SN2Kf/IC1lv?=
 =?us-ascii?Q?OL0NHgZC/Hby7k60IOYG1kts6MB2wD6B2e7My8dKaOKEO6HXi2X1M5KzxOTW?=
 =?us-ascii?Q?lpZnboLBiwtwRME3Op2eHaQxHjtRcxpO81544YOebu35Y6KDkR1328HquUO3?=
 =?us-ascii?Q?1zzpKMGNH0IQbeFDsq27vP0JJ1IvyYhQ79IcEsdgG12OAnfYO5mFZzNTJMp2?=
 =?us-ascii?Q?NHnBV+/++H3wzbZ51noG3FxTLymMj6o9DFsJJZnIqdyOL/m9mkDwZLSt4mPn?=
 =?us-ascii?Q?pG8sOXzcCfGXg8nnQ2xU9JpJ7Y8CoaN2nnJLPjgpi1L/8N/lhb2vlccIn7Jn?=
 =?us-ascii?Q?VaRAa7944m2cULbCs1Rpy2arbUW07QFrla9ywMhYM/NvgiWjZHO8ItHlHFVD?=
 =?us-ascii?Q?zluV0UJd7Ujj+QJ2pa3MmE3LLoEh/rYhy8eI69FSzraWDoTs/ZehrkZs/MVS?=
 =?us-ascii?Q?NENEsc+ey7t2tQsZcK94qWoGh8A9GJLY4lOCzi3wa0dbvfz8IvtPFqOC2r83?=
 =?us-ascii?Q?iSkyTM8I4AvcJmYL4RHSKOJfwkMIlsMM8vI5wjRujKedwdRZc3Fm6H7GNR7E?=
 =?us-ascii?Q?FRdyestR71zQ9yEria8sXQ4mXefmjmnH46UGC95OsF/U+IElR9YXnXaphhYg?=
 =?us-ascii?Q?Vin6PPoFkEpBKqmz/cwt/byXR8ow8eMyPTux6VP5+RF9e66aW2kC/XJJ7euo?=
 =?us-ascii?Q?6mff+avIVZpnjE8u8Q2TpPaAsU85Ptk/qVP1JjSEJz5LYGO4wtfdZ76Ck56G?=
 =?us-ascii?Q?mfNSaa1HfAcDwBpYRu2LaH0q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c728bd9-6994-4f1e-7dd2-08d973b91ba2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2791.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 17:41:52.1282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3I8go01VGj3z8SX3XkbFVzaWayAJ1Wb79ElIe+WR4D4zqKBOEsZh+VGEKpmvYvQTUonJgM71S75xoM56cQ1vXiwPypguFSZZxP5xAYPq4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4321
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109090107
X-Proofpoint-GUID: lvvOROpyEC9QmAmATxUWYxOB_hAyQ6n7
X-Proofpoint-ORIG-GUID: lvvOROpyEC9QmAmATxUWYxOB_hAyQ6n7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename _test_inject_logprint to _test_remount_dump_log to better
describe what this function does. _test_remount_dump_log unmounts
and remounts the test device, dumping the log.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/inject | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/inject b/common/inject
index 3b731df7..b5334d4a 100644
--- a/common/inject
+++ b/common/inject
@@ -126,7 +126,7 @@ _scratch_remount_dump_log()
 }
 
 # Unmount and remount the test device, dumping the log
-_test_inject_logprint()
+_test_remount_dump_log()
 {
 	local opts="$1"
 
-- 
2.25.1

