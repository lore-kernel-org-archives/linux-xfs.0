Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19217C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC67A64EB4
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhBRSpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCLS180360
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=jU5Ga5F63wRugoRoimbZ27iH1yPfBvtaeoZy4kWlvHI=;
 b=QeENqvp58r+NrjChAkySjYIjjdZvlfqbCfwnLNtpJbplw8UBcrRlg27V1hrYJiKx0Cir
 XWy8lrVdeBh25o10csoi1KYakDrJCG5n5ZiDCQFuNta/wT17PW1ZD2ofY6nxSHDdCsFF
 Djukwapnh3Z2z7HPjhnoQfGl/Sab6xbe7/qJuopktYY2LJ4liFk/DWEGfsW7hfkGulCH
 E4lPRopSvbUF/4qjcPB1VWvmvURRgnMrkluskpDdY4oi7qAyoJ3Z8AxB6uJTXRkSuDGL
 jD8qplj4FzXS3IruGVY61boUIaBQukx98+EYBh3IKhmdoITrCHuKvhy3J2YBL+7T2tXf 3Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36p7dnph1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTffo074752
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 36prhuf43k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsjKg4/JLVkGdqacZWmpksrNP5qEZFRzIodQ6lx71k1zaHF+umT7Tn4i6IRDEZf00A+A0caxbv+KhPPqQWK789qZJF1yMe1k3YRliKL9Lm1I0CYONdPkjuG7pDzcd+ht4KSTz6l06a9A115CJkzTaVfhatSLNzC8+oQpI0jPRDt/D+nBCxdXaYIOmVhJWB+wT3lrCXWjV0d7xxkMnsfWJcJSiF1mAqw//GJ6tUzgGkfCDKxZ9nfR6KY0VP5VHy7+ip9liBfIiv3w8/Nd6TyNPk9UF6Vpf8mjKTC3pVb0PjQpTVNCUtHpmyZj7hnF0fV/wKo7jinc7iTTaIggx9wIWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU5Ga5F63wRugoRoimbZ27iH1yPfBvtaeoZy4kWlvHI=;
 b=V7coM5qj4QI2F2Q8XtrhFzgAb4l3XeS6GPdDHM6Y3AztG13fzFHU6BHllnRryo/pzyMXj1LiXrPJD9wcgnYV6O9Uz0raTtodlC0+VXvPzHooeFXL36hL0nev0Ev8u0Gpo0Ag733fCitoI+wKmxw85n8ZEfUbpwjAoF3sQbjwRh4c53lP42xuWEH28EHiYgvhmhiDWIcHofUm1m/q5+5ropLPK6Ws2klc/5P8I8Jap6hQ9YPclCzRsn/0/WIOmtI2UGAwhzwkGFSA1tXcW8Smw/dgwKFbA4V4d5hJC8Ax2OhuToE7CsuW1FMBGgONKcRx1bJ5DDwAozgusjDof6IHdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU5Ga5F63wRugoRoimbZ27iH1yPfBvtaeoZy4kWlvHI=;
 b=n1s1Kxg5u52zWyc15x1BHY8VkFrYSUTkAr3u+AKeTRZe1Ks/eJv+qde5iMGWSEibb/njQDEqfIVsZQ6IHXlaMjzu5dfBvSEjoL4Ui3PZx4CsNSxul2u7vqfn3mIND3txvgKTzjpW0Z5SODnV9emFPvaOcI4BLmgUphOSQ7m053U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:45:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:40 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 20/37] xfsprogs: Hoist transaction handling in xfs_attr_node_remove_step
Date:   Thu, 18 Feb 2021 09:44:55 -0700
Message-Id: <20210218164512.4659-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7abfcd3-047d-418f-0e52-08d8d42ca018
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4495033CD5521E5A8F734F6D95859@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJg7fbUu3Z8OYaVDhqYEt/fZredf8193I1zY6vzYWzlWS636yvofv4KOxLnRSgKceyjZSNjUC8JJ7X0XBtBzZJ8d5htJ4cOazpHl3tOnLhCMNHr/h3rl4hKFx2YnpuSUTyy2O+JWAYuSqroVY3+66fuuwpCJzvuR/eNWjzxqU2vrWYlz4NFnBym/PCnSzNbPXq+N0LD+tpzFkwFgJIpUHA5q0z/Ly8GfWqK7Z4Y2hYx3kswR6nwZVAQTso/BCRWTfFKEYrsRg7CGFXJ3cyISCRozTk/Va5u2rOKWOpQbeKIdyr/Xq0Z+rfZXm4IFVtMi7umZwe0EHbMyKPlq2bioH0b6Bk7ItlmLVYWm2dDNrMi4DMJNBbSGZw0JYL/jQeTJMGp64eH/MidcZQI+075CPJKUSPk1P9Bl2LoPXIHVbiBHX+vHSAo+tuKOapO8x9TOgBYbYocZWVFnyxsYNgjLHKvgJzL64hB10BCWH8nO5JIEFmHp7Q35VUImIE0qao3eO1j6bxEjXviCJ2SFSSjwvf5nx+SqiDkbZ9QRws6NzzMAMHCUPo0D9sQbm7U9mBDp2hPkoeXA6e6NjdHmhtPdQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(478600001)(86362001)(6506007)(44832011)(2616005)(956004)(83380400001)(16526019)(52116002)(26005)(6916009)(186003)(2906002)(6486002)(8676002)(6666004)(316002)(6512007)(1076003)(36756003)(8936002)(5660300002)(69590400012)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Bx3nudDCdqS6yxsRAR+i+xSY5jzIeYJxhXUMixtJQSehVUBgwRS5PG2R0Ao1?=
 =?us-ascii?Q?IwjnyRiyRZDJ3V+Mtkmbyp+ZVz1qYi5mtVoRvwwq2ocs8REnOfw0nZK4qM7j?=
 =?us-ascii?Q?8g3JTkOqchpa3t8aUaQYwNzqnahuBNODRWQBFpccjfBHoCRRkRT2hRPqRj6j?=
 =?us-ascii?Q?hhYkOZoFf0QSSTV3/9A8gw0AtlDj5Z+Kga8AU1i7VJBePhC8iKzbpjMwJ9wY?=
 =?us-ascii?Q?Rl2ZPFYKOVTBMh+2Ko+40LQNaiGyH/qnHZoswxxDXBIvXMTQVpYWwenHCEDQ?=
 =?us-ascii?Q?gik16fZFZ6riMvdBVkkWvZ10fV+hdNAYrqWzO+g8mWVthboG4PsNy4S+CzQX?=
 =?us-ascii?Q?z6hiB3SVoWNPXcLrkANw1hMoaVfpxujrD5Qp0pP0gOJHBUlaF5Whhvade5tr?=
 =?us-ascii?Q?q88aOBzmQnbMJJuGSG9RJG34lwdMHuPH4+c54x5x+KGIxLgT4/0J51IUy//x?=
 =?us-ascii?Q?JtzReBDxlkPtQq7Bw5r6x2zf1TTfFlXsEjoAyVBIEI/uwCLM/7Qqx2+3w5J6?=
 =?us-ascii?Q?e82gdbfKGUT6PHd60eTJlUfASnWIxKQNvTQVWHkyfAr7R8ZXbYKwDK9Bjz5X?=
 =?us-ascii?Q?AFWp1VgUDyZycTW1UBswLtrLKSY/sqG+vi8XGndGSaPyd03vZ79NOlc5HoBy?=
 =?us-ascii?Q?X7Qg4arKjlPMk1Q89lUy0FqJ6CwK/DlsHUEOKDRTxke1pBHqA8UyMCzyGj7E?=
 =?us-ascii?Q?A91DQLaU4H7Xm+wloomI2M7KGsUBPMWMI29fOeEHoO9xko3G/IKXZc0JXH5D?=
 =?us-ascii?Q?sWs0yvWpFdDfA8037docKq5053B9wDG8xHjveVw0LqJmGCRELkfRe6kNUE1P?=
 =?us-ascii?Q?ZqOyksfIgMP8MN2Q2JZMf5wFwYsv6uO6AdYe88flkFRrYcL/dxPvA+rDV3x3?=
 =?us-ascii?Q?ONqRbvS3zvx9+5jQIOw3obQjsKcQFl8oBKtbc21hUA41kZevCMzlEH38gASb?=
 =?us-ascii?Q?xf4H6qDi176+SpNbCGNomZA8m3hq46ZKIZ9v0+LQ59TIdnOXF2mYJuvjR/JK?=
 =?us-ascii?Q?M+xHMXby6a5QphxwHrL1SVL3Sejju5RBXAZw2MA0Ir+aNORi1shepSK4/cow?=
 =?us-ascii?Q?RqsknqY41lDdUptRuPh3MqltRBEAHnwKHHFQqKieZ+L8dqyqOJgQtIlmvqH5?=
 =?us-ascii?Q?xS2lHlWychIAWXauwIvR0IiBjfxg0EKV5x7CjxTouv+t+I35/DvEAt//Kl0j?=
 =?us-ascii?Q?Eb3iex0Leoh063PYzQNw5aMOdsVE9wIGKcnyHb5Qz1RMp2eCQzqmLUwnBWwo?=
 =?us-ascii?Q?G/5to87vkieRuaAbD5jbCOn781gTIa3iB1pa+RP6nsHWL5wphBzgWmR+WSKK?=
 =?us-ascii?Q?lRWLILDm5UmIdV/ljotqPNjz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7abfcd3-047d-418f-0e52-08d8d42ca018
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:40.4457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KC4kpO/dU29WoyruCThsk0Jppkg0pquPD5hSk2PquoqraQvuoxOwhaeoynkbzv7y0HO3sCZQQz0qws0rOxGilx1gQXQPabmiX0WsrnLTq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: b091f22a5de672a88865e451545b447d139a9be7

This patch hoists transaction handling in xfs_attr_node_removename to
xfs_attr_node_remove_step.  This will help keep transaction handling in
higher level functions instead of buried in subfunctions when we
introduce delay attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 663c04f..1ee5074 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1264,9 +1264,7 @@ xfs_attr_node_remove_step(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
-
+	int			error = 0;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1278,25 +1276,6 @@ xfs_attr_node_remove_step(
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
@@ -1312,7 +1291,7 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state = NULL;
-	int			error;
+	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
@@ -1325,6 +1304,26 @@ xfs_attr_node_removename(
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

