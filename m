Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16C1C43470
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CFB261418
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhD1IKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33862 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235983AbhD1IKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80ZPW136854
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9B3JttikW7NWuVWI8toWfIcSinNX3j9FKB4kzTkT9c0=;
 b=ifcbU21JftfggyjHcx1YBtw17aRiu2BJ5LLPeZtQvNskcJSqz/r6FAttWWCf/eIFFZ73
 ApWb34bTFZ3AFQ6zABwiAChbjcCGGfP18uvjLHCtoYyRcnG5JBTjUyLXfaHIs+/qF/+c
 U75GGIpP1Z6C0hU8t4UqyitvlccHdCsXqoMMEeFpviQQjeQHjk0rECLWgbWbHaoYkBlQ
 UOkig++RWqtETGR2iuURAuQjUXYIHiweRG/jyMJ58yNKiX/fVDAgBnl307NDkaM0WIsp
 FTeqF5lsjfAVpznRc3wNsAazIH8Njb3BnaevObLsjqxX4x7COpgy5kKvu4RyFxBtf1o9 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 385afpyxs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJe196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:33 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImwUAYk+XBiBvaV4yAsAG1ZF9HJ/hBwOKyrmnBklRDckgqZHl8QRza0M6A1MRhl4Gsoro1DgrE1rWXPIfwkDyiJmltm4e+d9/NmLNTuj5kwExGexSXkQQ/gjV+4LXQPyG5fdxZIxtukR3yRMR04s3kPSQvASa0BcKr9kq6h12NVOCmwTf1mLWg32JqOHBQJ1qSimWc5S5t3Tql9n/WERRcQME4ulCurW4voc2oywvUNgTGZ2zvurFuHOzzI6e/11Qkol8jTHixv8uWpof2wnZLa1mzlaE5eB8y5KDYXfphO08rlqL2HU0hi7otI5GmLQl1pa7oFtPw5BUhs/eILvDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9B3JttikW7NWuVWI8toWfIcSinNX3j9FKB4kzTkT9c0=;
 b=KOp0Bk1ZMwvZLydasiCYuvR7UD40Hhhj5l4Iu6AiDjyDaOHDPQ8aK4pQxinV8i9uKaOd0sEVCjzKnQqjsiBSj2/3YdPeOorvdx6dsjhLmGWETWLghiC6VN4+2vU7Ij6Xo3Wirsi9xVLYMy8Qw2oAe2c/WqNBtxaIa3wIsRLgixeckgMtiSWZMzXSHCgWw/fAUB1cfXMmuVxVZzhqfjJGA0P4MsMrt8UviksuFeSAN49CLaWMvwDGJ4beW5pe39xw7/MxXIkIL/bcZ8b4G4v7vOJteW3OvBPzPI1iEhZvap1P7AMF2JM+qjKlg5wSETpEpNymjgb1HG739Dd4gXf6Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9B3JttikW7NWuVWI8toWfIcSinNX3j9FKB4kzTkT9c0=;
 b=PQZMuUiBxxLVWwjwBsCcwnlA/lmNN1C5g9NnaitcK+IAd5GTVKoWEZJ+xlVahTChnJJj0KtXNkJaALAmvQKwSyn9DaNw5+c7MSr21i6zbLO7NbOPeBzvFsYTvnjDs+chj2VLnwI8ZFm6X/WDXac7FDkAYzHShWj79EjvdUCaz/8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 01/11] xfs: Reverse apply 72b97ea40d
Date:   Wed, 28 Apr 2021 01:09:09 -0700
Message-Id: <20210428080919.20331-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fddfa0a1-91d7-468c-6bd3-08d90a1cf399
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB4086D3AC7A6B6556ACD1875D95409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ilylbAWN+o6Z2GQbRMnZ6pCHmB+1DhPbXSsLWZQZq2WoGzE61zCjBGqX5aUTAEItViwmETWW9BS0qJJqJvbbA0t6NvOmxnuFH9wV11lT7uPXk0iq0uE1Xnqnt49Sk9+oEgQuU6lfiIQIC90dImnsmwjlzyG3phkbMPdp2Ha4r/vumwnp1wu7FEMtPPRIv0x7QS0Au9lF6qXbhvuJ1kImwXKMWuaS0QWjR1IHOWIuVCTnF8L1z8Q6xOcRQrhKCEhNBJee/InPoSYXYeFMTt6/YdjaZ1DNkv0rViuC4TU5u1CzrTj1nM89BO1oXH8Tu0Hj0tSXO/+eSUWpFEk/w/b4x4Eq3gX+IHIjsDQAg4SBHXUVWIFnozT1nYoKHZmGss5du3VRcyblCkCUTWpR1KOuWeCgpJGNbvlryFwb7aMW84cTsUKk5+M8EsKHr4s1MqAfxMt8nEnVtZVkJH0PN2ek5N+DCgJ8YGgkv+3hqG4IPrGAoXWsD+aEvjFkNaCG4ZotCMoEVSeHyX8bUE9UwaKCyRSZ274/GTgj9YxHNXrAB1k2NOp2g/i6IcQIEhRIpaL4autP/rUxmBKXN4z4yDIUbvARhOkD4WJUvr7+qp0pgppw6LTaY58KEg1PlXPMLwYTwH06CGU+/PnketnKmksiPA0nLd/u/AM12epw1cfvEsK+4tl/Kvs4dSB89KzS/XE7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?54g62cb6VTqohLwUAxH4IskJv8Tg8ntdS8rsgMrd1N5u+4lgQp8jSwQMURm+?=
 =?us-ascii?Q?SuMuUVbGNtJOkg5Iu9M/gpLgivEEav1vQbVmSoNpymDrQXliN4HC6Ms8lalp?=
 =?us-ascii?Q?hWYk6KhJeCNpYbahd5JaBpOxMcaMIqr6GEjqGbV9i+YwGULTy8+7OhMCUJP4?=
 =?us-ascii?Q?vSc4jpJPspo+PpWN67R5XX6MTPYP57uXqctF+/irpVI5okGHMCyPwjCkqo6b?=
 =?us-ascii?Q?KNjrdQcF3TuEWcm8+A24UIWOEuGpmvJOKqAf/QJcBIbg+SQ0Gr/d8eR54VQj?=
 =?us-ascii?Q?MzSfQDPsS71vEOSDR69NAtEbuXo4mTeKUwE038EpyhXQR2jKTdD0+0/G5YrT?=
 =?us-ascii?Q?lBCYA3RJ5h3lu3Z/+FA8NpB7pWuTyY3yNVetCyZrqlQY36SIOBeXLhjVk8Ru?=
 =?us-ascii?Q?soE0CojepiQFZzOagHnnf4XglWRrPec1zAd4ANrfwvfDJbbaTK0FuI2eOnuN?=
 =?us-ascii?Q?t2GUdsgc+hr2Xj5oFzHFToG9qT+N8Lg3Y85DqvBdAXwyzgBOCGipYJag5jHx?=
 =?us-ascii?Q?g3oagfNHd7YXWdnLvrDkjcY+6rLFYXm6e8HxHz/bE+oOOBNyVoTViib796yr?=
 =?us-ascii?Q?fRLfDeSoelGobHtBwNPokcU/caIqg1q5+SIOSGUSmqkQAxSpL8k0ofWNdKUr?=
 =?us-ascii?Q?+KJU4+/eDa02vCfCzNAmSS9KejucBwjUAHmtwAddN3U8jxqgMFQH21+dEKQ9?=
 =?us-ascii?Q?V7LLhJnmB2V2VkmHCpnrdJQ7dMf4xc1m7CooVGx3sO8Im44Lhd2QDnOwlatR?=
 =?us-ascii?Q?DhehAYKxdcyah96ffPt1vHoJYYbpTwNU+cToZzX1ZPzrkD5RL8sIQsoYGBJQ?=
 =?us-ascii?Q?/07OS5q/R43p79aSsy88DOkUvkSaG1xOK5O2tkOAPgxKx0KVcYzsL82e18xk?=
 =?us-ascii?Q?Lahy1YqXoQk4ZiHR3oWoCeZyPtmnOJ/v2AZks1dtYV3Atx309+hPZ/AfG5Pa?=
 =?us-ascii?Q?cGvlLnmhP7Si/8CpMNgQIQO6iQOI4h6m4Ccn9mkI+H/gg6YVwZuwmwWDUN5/?=
 =?us-ascii?Q?0+KFFlvUb7KWZhl0r44N9a0+0o35cCev7uVVFfqFZ6iKO9IqpuGtFv5yZho3?=
 =?us-ascii?Q?du8e8i4wOSjkxlOEmCv4FPsL7cjONIq1bVDKDnJNSn8sr/OG9cGcSmJEem14?=
 =?us-ascii?Q?TNzEJ34UdJrJVWCHEYB9qCDT8O2vQC7gPmegmwJxpZ83V/Cc/Lru/tPRRJZ9?=
 =?us-ascii?Q?3hSGqqPCk/PwZNu3ppQqvE261Q8nSnGecR2jpxdyTvYJwWOmnLB/ekscI3vJ?=
 =?us-ascii?Q?yxbD1C/fy66UycnmlsucSryNNwpNNWl1YI66Ikm12568Uoqv0UlOlBh8Hr5m?=
 =?us-ascii?Q?Oujkd3CwXJKVqLma7NZrWHyo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddfa0a1-91d7-468c-6bd3-08d90a1cf399
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:31.4504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMeKflncm11UCPHOHGs635R5IzaPOfFvYSLy/8p1YuMpaFz/m8A67pr1x8UhjtZDFEHOlrsryYf5iNJREOeRfI+TQexyuJ+Ug54wWdXQ3EQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-ORIG-GUID: v5khLx0aEe0xKSfvbAlR7fCu6VIpI2GR
X-Proofpoint-GUID: v5khLx0aEe0xKSfvbAlR7fCu6VIpI2GR
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Originally we added this patch to help modularize the attr code in
preparation for delayed attributes and the state machine it requires.
However, later reviews found that this slightly alters the transaction
handling as the helper function is ambiguous as to whether the
transaction is diry or clean.  This may cause a dirty transaction to be
included in the next roll, where previously it had not.  To preserve the
existing code flow, we reverse apply this commit.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 96146f4..190b46d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1214,24 +1214,6 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
-STATIC int
-xfs_attr_node_remove_rmt(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
-{
-	int			error = 0;
-
-	error = xfs_attr_rmtval_remove(args);
-	if (error)
-		return error;
-
-	/*
-	 * Refill the state structure with buffers, the prior calls released our
-	 * buffers.
-	 */
-	return xfs_attr_refillstate(state);
-}
-
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1260,7 +1242,15 @@ xfs_attr_node_removename(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_remove_rmt(args, state);
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			goto out;
+
+		/*
+		 * Refill the state structure with buffers, the prior calls
+		 * released our buffers.
+		 */
+		error = xfs_attr_refillstate(state);
 		if (error)
 			goto out;
 	}
-- 
2.7.4

