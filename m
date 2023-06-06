Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FF5C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbjFFJaL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbjFFJaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714BC126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:09 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566FO7Z009963;
        Tue, 6 Jun 2023 09:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=khcOiKP7FdVbfyXrnzOUJXr8D2pCtkwLy0RqJ0MJsts=;
 b=G7sNiyTrzGdRoK3/8JS+uai757eD1fHdvnjSjp1ZjyI/UV9jmb5YE6cj/2pBTjQQkrnN
 7m5KQeKbElpGbe4r6ZntEckfGZMWCNcINhYn2YlsbGSzbWrpE4DACc/k7jCCFWi45UO+
 TXuOnK1t3EeaackP1oFWJ5LHwkYoMzkPCCWaXbCarJQy0GtSB7qLN6v0Una5qK0RzDNW
 9xbu4BXEYHiNbfps6XWeH8WvM+J+8dlhuBF6BvcoQVPm0KQhhRIjkJX9EACgAhg5fhTK
 5sgZlV0Zi5XRhUw9I8c8IDsZBbh0J0SnC0AJkyKnfnKRdQsoI3d1UD/SqEIwsO7WFGiO 3A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx43vvp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35680if9024018;
        Tue, 6 Jun 2023 09:30:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkgvd88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdIht+nHy0o59tTHY6HXZvv75u3dbwcxyL2dFxpjp6FBo4YwWZlsX7yAFn1FhHnDYMywFNKPcu52IZQJVwQIt0MQAmEdBUzlo7nGSpqc5xHCAskkmZxbH7M1v7UyS9wZIwCocFGuMzc4ySuF1ky1BdnP3ilPN7pfW86udpvAkRuajsgco1QCZowNLSIiHezqht+omJhtcd0cFvnasjDy5qcA+FPoW1YdxRdEtulW1vUdJmdN5CKhF7vsxNziUFsDueICGEwtcsLL30vNprZqW+2lUMxOYGIjYlqBXf1A/okPzmUHPBXd8VWnvYtXZsVfgD6Dowcq+lImnA4N8IrYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khcOiKP7FdVbfyXrnzOUJXr8D2pCtkwLy0RqJ0MJsts=;
 b=ALmeZb4XQz+3sPakgtDl65R6U/j1OAeVa9ciD/YABk7ikFGY5Co+6KO49OtK+PZnVuhNAvxBEewF2anVGsVeNGptsktAwdt2DFZpOyq92i7JjPFJ4s9DLAyjiCoHgqGyx3B5q/oOjIwS8BY6nyLslPmoW8YTjZiuiRng/YKkYUA5tNAkDOVNdiVWhnqsvi1Y2cEmztbKcAmkPQnZVnZT+oeljXGJxnrZNjBc+61n4LOokM+zOtDVtwM9kakf5VTw5nbgigThgKOrcBGn2VVIuSbHTCSXdexPnINU/E4Zuc/OkMHfcgDAgev+6m8bB4CInl8deSDXvV0PlTxSNWGfsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khcOiKP7FdVbfyXrnzOUJXr8D2pCtkwLy0RqJ0MJsts=;
 b=UT/+zKjOy1ke0DiFIxCOTMjEVMYULzQQttYkU4F9bOl6OT5Q7hKkgjWfmFqCulgi1oEscbr9qDsJpshRcPiWv+BrCgI3WpAqvqoayY78RijQ9sG+emZwFotSepLOJ7VZnBMjxMNesW4eKSSMGwaznOtCbEEZY26/g5I/P1zvtKs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:30:05 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 14/23] mdrestore: Declare boolean variables with bool type
Date:   Tue,  6 Jun 2023 14:57:57 +0530
Message-Id: <20230606092806.1604491-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0172.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: f944d33b-1e75-4822-15a9-08db66709c3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6h1tBzlk/ZwPs1FZEgxOUrlS4F1xspjrgrd/CEmWsLUnghKa+crA3tbjmxBc6Xsc/h9Ymyn2xwc/JlheP07QP+hTZrasdA2DKij6IoqJoUtDTSjdbxHjXDLetqyJpDoAt3d8EryQdavcMn9X6hm5DendZL6Kw5P67NXhzVeIt5aIBeKkc2l0iObkEf0kUPhVvPlVtfG16b+X37C+l8gM07SQ4gxbhuHNzASLm9Fhotdc2E0ETk6lpPcZZ8Ky8hZR4O6AVDZSOmqmynRqY5RphcLw83oWSPiQOh2VbRvvlwZegxOyCh101Qg+x7thQ8phshoUmvRA5pQV5dRkPwCgehjCHyEiAj16gh+bvizdLHpYpthvnE0bMaZcqsmBoTkSWTiSxZG8H9v/JDQ0E3ifuyRIeecW90lohd/Wfn806iq6dLAQt2+UITwBoKQ293bIaIKThK7w6g3W4Hki7Nip3c0p8q8EGmfIA8mVi3T87kRX0AADhawKYOFGd8g3+EjTxfUB8NOB2inYTTKwH5Ac/smGEWRANqQUDNDyHy6IISaFpdm5yPDm29EkzbKbo0ma
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mw5S9vWvK9yeiZZ1+1PlSEJ8AYz9+OC3SS8rOjnA7P5g7Ek3cmC3J/i6e8/5?=
 =?us-ascii?Q?99t5GPOXbSe0P7foa0uMWhhlPCLIRycA8uVwnJ7XfNWtV2WF5Z7Tqj7U2cAg?=
 =?us-ascii?Q?DPjjMx1oTD0UYW5K5FceaDe8uaPvAm0V8pdV4RJ/R+ZoKXApAEn7NvGxu+9r?=
 =?us-ascii?Q?5+f+31npPRRdMwetxsOTYjjDZTV2AGb2XDAGZRkZQbXGdDcebj/A9grz6/Lm?=
 =?us-ascii?Q?ls2bIKa3Qk+DL0nhU2AU4fN7972/FXOm9PLVebAGkIF+qNijhPD4ZLLxWfQj?=
 =?us-ascii?Q?n/6qTUqGYdYv7/26h+1ntHVLiYteVfrjLgRuEtuAq2eOTkBT70mAqgLkLgc/?=
 =?us-ascii?Q?6U7ymqN0O2FRR/0lFvzp3VWuUXUPigoc7soUWgues7hJ8vi+YisL/Q0lZ2BN?=
 =?us-ascii?Q?h2Is9oaa/Ps2BideSmco+hNEC24/47gjbr3VxzQhll7LhkHwyfT4LdJ+IT7j?=
 =?us-ascii?Q?qsSrFPndFOM1dfGlUUgTg3g10mC5BO4MOygDBHI2VNtwch6FQxZuH1RBLzqK?=
 =?us-ascii?Q?IJnPLKBbRNXvoFw8b/tdq670JtRuwHaqDjdotTWZQkVfJ6W//fXSH2mxwgMT?=
 =?us-ascii?Q?ePZLWQw8Rz3SYsFTYenZCVmEO1SdrAqy8HDB/z2pO7eOyJ1U3BoFQVSD58JQ?=
 =?us-ascii?Q?RphlzwcY2MVMEsAXPWe3Wjw7/OmNfcxJF6+rA/mQxuKKBzZvqwYI4Qklh/Uf?=
 =?us-ascii?Q?7ZhxpTWQdRPM/jhyM31w9b//UF2j65CDvo3NDl59R4Jb761ZoWdIR9h1EnP1?=
 =?us-ascii?Q?PlSFupUQ0JTAbC3Q4pAasz4+0SSBsT4ohRkRmQMDm2fG+apTR3XB4RTU1V7v?=
 =?us-ascii?Q?BI6p/cvfMFFECulRxfalU7Lyk1TCqG0YmiWPojlwmr6Mo3iC9d1kyN9IZe01?=
 =?us-ascii?Q?UkVqZtkoLI253sZwUc1QWwvfAFtfOLsDn3VrKb37K6QagicERbu88p9hja9h?=
 =?us-ascii?Q?6vHZbwQo8aFhsUyHdjR9RAFqRmtrYRgn5sBYb3d6FOY+0kUclW7M/DuhZjXK?=
 =?us-ascii?Q?8GvwcGLvCFRxWQ5E8VMx7lwm8ZEy8SFFZyIIiJhcWxHMuCrXqVoReedwwXXu?=
 =?us-ascii?Q?hYpL8Mu3fKKHWCAZIqSimK5Pl/GMANlSUe7HSXMWiscmZAiUpZWJtcppE0Xe?=
 =?us-ascii?Q?5rOtGavz6eAXPkw3MJVwDgLL5Yq0LtoBRdOjP2mRQOOLf6nw7Cqi52/dAeFy?=
 =?us-ascii?Q?iwZJi3luWWqrA8epHRXm0yCdEKGaCbVyXVl07wvw2OjUnPWHfKFidJk+24fI?=
 =?us-ascii?Q?shegtXFUGRfum7A8+pzz/nZ+PNanEHfIOB7pJ1cK8JPFXJxaJV8tH5LTI4aC?=
 =?us-ascii?Q?HBvp94q8Z5sYQ9br1xeKiIsYFmWpK2S33ogt5QDwYAfTAlf0QYQorMBdP2p0?=
 =?us-ascii?Q?uj2mpxfxE2vuS5i7EcZKid1LkZ2nNuHfuBevRmlYtg+L1O+DGWcl9NkPI9pL?=
 =?us-ascii?Q?2V03dnryi1zkl+7dogK39baYs3EwvpX+Iq3Lcko9Gd6O412qKJ9raJFeHdG0?=
 =?us-ascii?Q?UXdFlLi0JrfuAjQTxaXm+PWiPtA9TjBosKxoGABYDA6C3FUISY+oS/jiMa8S?=
 =?us-ascii?Q?DYC6lNnHd17p8FESgf1SPU9MwkAh7f7GWzcN0cN4GWVZfBTV7y7Ur+w4Rvxe?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qOTIieBJBjXth90M/1fDfrxbuuM3BcVrIrxv1JmvuIwku05yaV0/vqrLeYwRRMBh8cOHfgpTRTGrnfN3VKXL6rqME4HljcHNfVq8OLZlL+sFlm/eQ9vkk3q32LtXrtDjgZcOnqjMCWMwdg2UUcQCacW7NH/d2BJMG5+rHkv7x+tmWEiz3FJI0XWCNJQELqk0vwzhNI11iZC2Gdd30HIqGnoP6JU/XLeUfqcKbBcDb99gKZR7fDhDJm83f8C0BI5+L/qBHXmGrgdNjrK3e1Rucx/yhsbF8M/oxYmuqs5IPy9qCSsUvcUfxh8CPsEYI/gJQlCOizGn5pKvpmxO3gEAnt37H6WESWqSDf1fzEapGXmFzAsBECSrlPqaUhb4IvShDs41pjV/I8JCzcUCJtXVXcf7EjWzAqwBTize8oFxnIhLdM/rpylBAEWVSlNAJCTWvTd9GDcSpL++aklHuaHZ1sz2P1eEVqeXYvc2F7cZsIpummB0Zzttu+aP2DTBiwUNeLOIEICUeAdHwUXYBXXeaM6yel7dWVXPIE/tz4izMIzAjFfiiVHyHj1T7qSzOY2VyzN+HPUkwnzdk8DwZgNaSALwL/sQ8zeLmXFSfb1pciBk5/+N0LvfP8F0oT34txOtefM8kudBcikXBC8ve/VQXPFMt50B2oA37WpjXIX/ksCw4k6PHpXk4NBVqr/aeDOhGtrrAftdIKanJ9WIewswnF+kK7m4wwn/jvOl/2v6oC4jjDGQFPkh7UjuFwtg23QavrdZWs4kIw0tJWVFAx1dt7fsDSOiGPxCTsPcdt6CkmA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f944d33b-1e75-4822-15a9-08db66709c3e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:04.8733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Eld/mMS3DjJNK3fSJdBOok2r/V3sAfp4Fs2UWcvOydBfm2VkepLc0Vk369wGxnsrAE2lmwrxLA++3G9lrl2Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: q8jr8harFm9eiyoq7p2FehX94KtDlGhU
X-Proofpoint-GUID: q8jr8harFm9eiyoq7p2FehX94KtDlGhU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

