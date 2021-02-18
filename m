Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1533C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9291064EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhBRSru (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhBRQyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGmxhH185318
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3S3Hhw/i/yOG9xMWB2Hm7OX2IWpJcx7J9BdJNvdZ+WA=;
 b=Uhpd/TC0zphgLuPMemC4oawloCKfy3nk0/KrfMbfJUaoX2KPPwrkvYdSkKic7QUUzWVx
 nb71tCKfAuxpNbsVeO1+0fFjUJ+jUm+5HcPBRH2wCsFFXcdeI7pFGAYsZX3vC6zLQXbv
 2EZNAVfxZer2NjW850eonJ+mkmxieHw5qOjL9hMuSl9g1NRDHToDFBsO2mFlKbdV55it
 gfS+hhgTF9UdZOd9zBA/wzwLEm8/Cje20Om9tT6Y5CH0UHs79DQp6pqIsTJJczXfRT8N
 pzWKWBU/JbWx2OxgrVcb3isJcDI0KTGtubPIUxQxZdWIUuf1Pbs1Z8xL3a0EsGWSJC1D jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r6n8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoG3M155234
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 36prp1ruuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INHKz0ZWUvAGfuNk1tMWsYOVHVmmhxARY4AwsjoOYbRBD7yvw6LPcxmp6w5PxcefQH9oyA26iI7X1CfuoGTqxN1IzoB2RJlFVfl72d/uWrwFM5zM5yWhWs/F2MtTomM8NbMACDLXC5MRj4yJBDtw4V1WPrC+/9JxrY8D7wSkZVcJHAqwSzDyfkHOJn3WzYAHG8kYA7ZB3tidsZXXlLsgYxX7dwgtrbMVWCCqiSX053T5UW+QwzFFdtL+1m4R50pzLjpW8kKOqv+GqHpK5QBpaU2N4ejTWFqpm0QkA+FhzxBdhpnVmpP8LAgU8yOlhNGOeiPmFPZaE/7SbFCD/IW0Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3S3Hhw/i/yOG9xMWB2Hm7OX2IWpJcx7J9BdJNvdZ+WA=;
 b=LMUCFfwI0z9KHPi9NjoExg8IAe2TZh2mLGMko1o8IIZVuyT4GgArqUxq0abQ36CBJAK4O7tbphtuixiiTDVIX0Mol0pdO0w6qzucBvVywIjPnf6qzU8fQ5apwjfT7m/zCSnyxTtuIPgSuRFLwhor5iLiBV8XXDhGDX5MsmWmwdyDHtX/6hk0YI9VURSG4rZMak5FsT5fOnm9IyWtjO2Z/AJWCg/vLWRVufB8L+33Ll2JMxUIeGX1h/DCwz5F/N46yV8cSzriybu8GCFNRQLoNecSZlUN5PspOgVHuA18e9L3CVGCDB+6qKklpG9hx3jVkYXpirfs6Kc95p1fFNyUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3S3Hhw/i/yOG9xMWB2Hm7OX2IWpJcx7J9BdJNvdZ+WA=;
 b=F3vRndkmeits10KQq7/vbkxEVrkxgL3EmWWD/n/9BhZgAE9P4HTzEWqtyfSrD9jnoNifXP1dIQUjXIPpx3jUZbZLEjUBXXvYxfPB4ebqbQDFr0GmGmglulz8vWu1vuBpQrVAfy7Mz6j94sRxL8yKjXsBzV4iV0R4hUzTbp4frR8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:04 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 03/22] xfs: Hoist transaction handling in xfs_attr_node_remove_step
Date:   Thu, 18 Feb 2021 09:53:29 -0700
Message-Id: <20210218165348.4754-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1232ea1-1a5c-4bb1-503c-08d8d42dcc65
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3381D2FCE5BC02FD47C8B8B495859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M0XSaHISLF2CnEpSq+hEyjnyLqgRWuw1PqnhxhgY7wMV09zYd8spbZSbfBgK7GENKvqQOUngwPcqb8u/2DW/V/TrHkUc/aFokAqNHfg7bTn1D4nElU0kHbaYtynZH7+0lLCGaCHRkg0fkEJ3l9VjIxSP9SuJeCXNfDkGR7HkJfy2gr4xsx9ltczg3CA85cZ2434LsRtlzay/b/7xPEI9rUTPs/mcSUjitJrpjyTDfY+DD/74zfDPZJy6HnnKKr2ApwrG0JWVq5P1Z+IcU6LmHmeLf+njH94dW/ltIsNn74RovtcG4hNtRBYB7sKqGEzWXzyZQ0nt4G69c5oYMgaYR65nhD6eTCECdBqWmYmXclrN2E3ng04MZxosv08IfT8fkhzOZZWjswXCL53oWDWSf7ULmaXfTwlRPti/TptInbizpWRB7fiVGYoSaImRs5HEDwgK6g87/KFFdC00qBgUJT6E/JZaHmqDQQbFGoui41x7PbRu7AjFRf2JsePhh9T3zf+CrwsvaOoo4NIPLH6TJC347f8PoaBHy4uTapvZ/YyY6LnxkKY+8sZ4RmvhGs5SnOzg3yBS/c9/128VCCLxbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uu7JObaOkET3AgGdVcy7b05Y7D46seu9PxqlBflLVwEYSUO8jjKd9UjgSO/R?=
 =?us-ascii?Q?NfvuVAgBX/b/KDOFvw7HiqvXhabeaZ5Gi+gTn/oxY1siRUeZFnLHjkv305Ij?=
 =?us-ascii?Q?u/jrwfv7I7a/iqNfO1TUB1VIbVgwRyT6bXavKfU8PdyFhAiPc+g6Mcfin6eQ?=
 =?us-ascii?Q?EfdqcvLriZtr5M+mveD5MzR5qzh2musm4zx/hkG6zwyEvD8eatvXC5RYchq+?=
 =?us-ascii?Q?j5lmqf2omgccdgB1QZ/VYPOO6/Yxz2EX1ZME4+PFFlGkdeZ5/qTFUZTx0Elq?=
 =?us-ascii?Q?dkLqUuhD5VrAWKd4/oYB6mKAzaf8H0BKdsMJI6RYXrInglH43jotwPSoya6f?=
 =?us-ascii?Q?x25kQ6rqGVOzVFEneMtokIYx+ZPk1IMMfAtj/hzCBGV/qr4h2UwYGzyHeSiA?=
 =?us-ascii?Q?rAR27SW0X+UPgBp63mruzJt0NTsUqgiGCS7OjIc45NaGRymL5rzOCDpVt19I?=
 =?us-ascii?Q?e8OR+CZJvDBS316qrt4Dc5bqu0fBZxSxSCj5s2AmHkUBFX1PRzAlZvyOsbI8?=
 =?us-ascii?Q?fxzqBxiUhr9CEXPBOIKBWNiIiUJmlTd5ugjEZiCSVD6GfV5IKjvIRmeEL3Cy?=
 =?us-ascii?Q?FcdWgos9KEq2ox0T+/Ngsxi7vr4v7LizPNSYSCaFR+8E2BCRu8QOGp+MgOCL?=
 =?us-ascii?Q?dFQeQxhl3JhJnVfBLAZTT1bHAKwgDsZMW+TneSKMNm+Vdba11agRpVfFyScy?=
 =?us-ascii?Q?4rGQMUthremH0f3NF42DiodsANJA/y8MpziLI18cckF9tscgpSg8r0izg2Lv?=
 =?us-ascii?Q?2HjP3NUh8dRC3Iev6kajfA1tUu4BGhqCGlhjW0TWVdO8Li0EYRz+6AKz4bfV?=
 =?us-ascii?Q?7P8p7QvenJGh4aTwWaTrN7xjvob0FzG7ZJ+UQ4L7AT0dSx0wIfRi014dNOH6?=
 =?us-ascii?Q?LclTwQVBk+A1g7fzlQ0TR7W3HeXwR8u3FsBQ56JK+rIHvUy7WRG8RRYG4cQn?=
 =?us-ascii?Q?LWDqIr4rGs0QWSZtrvE84/zmRvlRzlAqMwas+K4zsARGCouHfQqBtMuVRA68?=
 =?us-ascii?Q?JoHPG64L859ozENNs1FkWikeqfTWg/26DC/Eea67WMf/YdJanQdeqEj1o3dr?=
 =?us-ascii?Q?aFDNkQcDBLEOoxZcPBYi7KElrmxkS8L/hn/zJdVcXlseicV8IK5Y7qXFUKNu?=
 =?us-ascii?Q?eCg7ZIZfxx4Zi1MusKp+h3wCEwvqnd2N6keJsGZY9S1L8i9+ivKupzJqeKKH?=
 =?us-ascii?Q?HZzSlIhOwfScH68FWkTmnPEM90LjaZ7Ly0X8kYNVRVd4zuxjtSep3IHaglCD?=
 =?us-ascii?Q?SJJo7MMqFy0S2uYd7aLMF/EGaSB155/Uiaq5Ou1TJIK3UK9ldV0bXIFs9fri?=
 =?us-ascii?Q?bu1jaH6oFKP1kRm+SI5JpnTX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1232ea1-1a5c-4bb1-503c-08d8d42dcc65
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:04.2047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 973/gQOYwwprF/YGPn/kdV1QPxiHRkzEiwKd8r9/HDNXnUC2oOZAUqSpKuoRW/5EgXULZUEekRMEzerrr4yXz1mtk7I/TNzvZY9+iYkz3v0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists transaction handling in xfs_attr_node_removename to
xfs_attr_node_remove_step.  This will help keep transaction handling in
higher level functions instead of buried in subfunctions when we
introduce delay attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4e6c89d..3cf76e2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1251,9 +1251,7 @@ xfs_attr_node_remove_step(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
-
+	int			error = 0;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1265,25 +1263,6 @@ xfs_attr_node_remove_step(
 		if (error)
 			return error;
 	}
-	retval = xfs_attr_node_remove_cleanup(args, state);
-
-	/*
-	 * Check to see if the tree needs to be collapsed.
-	 */
-	if (retval && (state->path.active > 1)) {
-		error = xfs_da3_join(state);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-		/*
-		 * Commit the Btree join operation and start a new trans.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
 
 	return error;
 }
@@ -1299,7 +1278,7 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state = NULL;
-	int			error;
+	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
@@ -1312,6 +1291,26 @@ xfs_attr_node_removename(
 	if (error)
 		goto out;
 
+	retval = xfs_attr_node_remove_cleanup(args, state);
+
+	/*
+	 * Check to see if the tree needs to be collapsed.
+	 */
+	if (retval && (state->path.active > 1)) {
+		error = xfs_da3_join(state);
+		if (error)
+			goto out;
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			goto out;
+		/*
+		 * Commit the Btree join operation and start a new trans.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			goto out;
+	}
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-- 
2.7.4

