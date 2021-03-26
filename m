Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17523C43381
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9CF361A3C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhCZAcI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhCZAbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OvP6066420
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/OVmoIwYaKKQXaE50pySevBeV6zennQ2knIea/hlj6Y=;
 b=nJn97XH/UL7p4FHso026elfHFRBzmrk30AQKv8yFWpCmTSXitu6vBHaZYMIS14sTPKIg
 zQg0FuFdbnx+ooe5qAnspNqkcM01rlyU8L4u4YXe79tOQKPdvRnZtRzJeuoyEEyiW+OB
 OUF8gY+T1v3/EFYi3vE9zL8dX3OP6YzC9l8/aJ9OBC95tRk364RZaaYxe0Iz1LZP+XgW
 XV1JKZE6qUQdkST6qL1B1BR/J7nMfuPZS7M/QkikFBQVBTFny89ie9HHg8+0sRXiJYvU
 IRDD1PCE2pyVGLaMraEECfDF+nksR7J/pFzSoSuckFrba1N7kXy/FpRsSp/Z0/O0ncNj 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37h13hrh5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PKkT155633
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 37h13x047t-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8wqrDes4QbZeG8K1LnspmNsPkUuZnldDCbSu5giuechme+xaR0OC+Q8/qin/5ETkN+/VuVO9M4/gHwvX/KihBOFiAXtM2aT9cSreAzUo0YD+K6qWexWwcwpYNB6Y0mnqIhaSINPqueikrtcHjyGt75kbtheR05k89le1A2q1K5yRG7bdBxkyJkFuWnOJwq1Cei6fzTOfPRJbfV5CCrT8E/FawyfTLN6u/Kdc+HRye4yJIbeKQ07vTY18ALyMtIU3cq+SdQ2dNnggOgSuAf9zWX+2oB0CSRUd/pA82tqSiDhtTOe6IOx7Wr9yl/uab4tv7w2N8euugZ44+W54TJ+6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OVmoIwYaKKQXaE50pySevBeV6zennQ2knIea/hlj6Y=;
 b=Uc9UDD2YoBP2s1LR+RtAGZIb1xxmussuRBPl8PMfyXZOozgDWOxcjL6pk7tZg6Gx8DlSY1PXaDApZWu3VVYUCeen1191iXGURcHFvEkOhTRyzLZ06BVCrJsj5NEnhtXU5UC+qC/h2fZXjphcH+i2jw3lVCPrm2TP6o0CdyGH1reP63Fv4eR/pQFakGpIE5aUqUxE0GdMbS89HCNKaYgTAwZUdTMD8OoFbSrKg3i7km/QBp1KTgsnFwJUTBgHTp/C8dSzyj42mrB4PCOnRgbFnmBhI8zzeiAvkrjBp4VBoVqeiAMSEGh/mRW8sJHAsVmh3RIzzebSZ80z3g7tY3Is9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OVmoIwYaKKQXaE50pySevBeV6zennQ2knIea/hlj6Y=;
 b=ADXl3iAZHCqWVwIi1dHvxCotVbDktrY7zAw3fq0yhTjgozklyq9bfwNGC+s0/9iHbRTZsIaqdaTeKA8wVAvhrRHZ0fAYn2M8+RJW12/afjRGNh+Ows9LB49rrfAowV7iLt29EwVQRCWEVnYJFv1QWww1Nn7axkYzWropVdWyT7M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3924.namprd10.prod.outlook.com (2603:10b6:a03:1b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Fri, 26 Mar
 2021 00:31:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 18/28] xfsprogs: Reverse apply 72b97ea40d
Date:   Thu, 25 Mar 2021 17:31:21 -0700
Message-Id: <20210326003131.32642-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18855184-27e8-4bec-8f92-08d8efee8aa7
X-MS-TrafficTypeDiagnostic: BY5PR10MB3924:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3924EE6B4430E058AB58C53195619@BY5PR10MB3924.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u8NcaDMLpNgR2/j6PeKlaOzgBacuJ8pj2OBFtnVEcIMyipQ0oW+M5exhBddUk/rZyqlO7tCSnM9Bix6Ovp8U5LwNu68oSPzVXPYk7phNw+TMyA5xA+VjNBwCBYOpUC6hZTnAIAIYtYAUwArqrPFUJUL4TSd2POWAsVIA6jrvTwsF+imaOYKO/noK3DsfNQqwUXVNYmuAswXMfgMMdg9VjmuZo1AUfJWhnzpgkAf1b9fxbe9Vjjqs39Js0VsjlVRv05eSvuX8wH7XaBLULJYLvuiv5ePbnwB93S8jPD7yHvqD6NgyVdVHa5WIQHIj4BPWqunSBNau1LASXUKHo3lU/dK1S3ISWk7j3ZXtyK8KbOhgaWbPWeLAMwvdSYV8j9DLOTXE00QNdTpywZJzErXqqezs2xtI2tRoB0vs2RuO/8u1D3Lmo+r4kePMBcCqDV1juzxVRGYQV3UApbDEKrKoZPEdZ3NEKaKn5zp3ya/nzWKhDiO1actx4FJu3mGRqZxNMpdmwRgJ7CCu5owZHwQTAxAh9lSiYvKB4rd+lH6ng38XVGhy28gP7dxA36oI7bUCnJdqjn0ACtloqVhfOJ1u6yv7zUi+ns99911kVTs54aUH2S9Ta9ozQbvSDoZJS1OhEk+pJEC8GoAt9MG1Dlv3u0uyYpY8rMMb5WWu67dU4NuS8NtMCr15AwG84MXcgke4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(6512007)(956004)(52116002)(316002)(83380400001)(8676002)(2616005)(8936002)(6506007)(6486002)(1076003)(38100700001)(26005)(186003)(66476007)(69590400012)(44832011)(86362001)(66946007)(66556008)(5660300002)(6666004)(36756003)(478600001)(16526019)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cDegxI0NZ88MWCWHUm96L9JoPetbU+NHGP/fmKindVwSij+o6Zou2kgkU18B?=
 =?us-ascii?Q?V/EM+aWMq6WmAoofuFfKWI10Bgr8VUbef9JhwWoa12J3BnoK0+YxXPiNCv2j?=
 =?us-ascii?Q?lVQIsh69F3fNzH56gIyDM/MlfuPFyqc8BvY+z6vpPkg8HZI4ygmexzJcmuPT?=
 =?us-ascii?Q?7I3TPrNyV1j13aT137bl4X5kyfruUyFmqWuTRIqGAvTlMpvK9k0GReajtDoy?=
 =?us-ascii?Q?U6FoZ8M5QQd2Kv3Ain0wrm/AEQ1FCApokkpKi1zBCnoIV2ngf+sCrwCGgxQg?=
 =?us-ascii?Q?LWLM9TyBtsvoIOQMSO7I6msL2YTQpSf6YAmoYm8covOj58GPCZNdz5XKdrNX?=
 =?us-ascii?Q?b+hvdsy/vkiV9DZmicOcOTdgJ9a9LsuRmZY2j4ZjlCiF743RBoLqfx9RexG5?=
 =?us-ascii?Q?ZVq49MMqL+2jtF/uBa6vzSw8Pg4ULJHtCzFS9ZheTz/gy3F8UdXO3YcPdd1b?=
 =?us-ascii?Q?AFgEY1WnBA+jHcZ2HsBjr66jkX9klfLkm69TEfNjpINMWkTIyZZKmUNRjY50?=
 =?us-ascii?Q?7nekA+7WiBlYVX5bnPwiYfTuNTiRA6SDCMNb4a2NjdMddwV0mhkxyhTbPBrZ?=
 =?us-ascii?Q?8V9MXWaHbgjPzDs7HWJOCTCgjoJ1+6t+u3uABe3MK9vz7iua1qGmz28qnH5E?=
 =?us-ascii?Q?cWYefHF/EJJXY+JG9GGM5zGBa6nlnoMnBSw6YajGpBUKOeKcR+lGQELPnZDC?=
 =?us-ascii?Q?xgyOKKRxNCkOnMGvuD1mctbf1eWl3JRw84UQPz1UW40VEOULftfkwb/QmJeY?=
 =?us-ascii?Q?MxbTwkPwx3L4GxRn1kiAZHjhgKx5xpNKtBxUrhUI9aAsRcxFlLEE6lt0s3jO?=
 =?us-ascii?Q?uHtya4LW0C2HolIduQY4ctdH2OR1Bjeso+naXX7+bSqwtu43EFNSTVp1u+YY?=
 =?us-ascii?Q?vd6Tw4st+twc5rJkqDwgarQcslJRWYhVcqLqjH6LeA1vcfSzFCkY7QMmsac5?=
 =?us-ascii?Q?kRGvS91Ar5+AoQ4p8aPsPty4pabM4QHgW2/dglvM7s1SiPA1ob5NM3TO2F6W?=
 =?us-ascii?Q?5tFHucQCSn+LJOUu3kZnvlPZkjMyCl+ngtRpkWhMnBRp2zQSgL7z58S+udec?=
 =?us-ascii?Q?yyXWp2fjJ2F12nxKbTAcyPzMFnrcNkTqCeiJjIQzWUfQLN1xhVjFRkRtY9HI?=
 =?us-ascii?Q?p7mnYL1ISxEk3/W/5UDyap1q7hKlenwRwKniU/LNvdTXiKnfpqd96Lxdc3hv?=
 =?us-ascii?Q?n8eQtLWI5l/zM0cLBRE75pBqzQOcSATXJHBQBjJbwEphyOowD9qzKD2x/ia3?=
 =?us-ascii?Q?46YMwbBDPFj3vkT1WOgAYFgvpuCSSluSAedbSMhDtRR8LN7lZyy+5sLi2eY+?=
 =?us-ascii?Q?uQtOUZXPiqsyQKqWwfEmR6xz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18855184-27e8-4bec-8f92-08d8efee8aa7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:48.1472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cG9t6oYVVwWFEpNVY4BlIQXfslV1Z42LJSxCb+j+WnvyZW3MBxthJUf8TUnyfGb2CSQQBPRpJ4BRuY0y++hzlTPB2SNfi00jHDH6mYEwCtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3924
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: 3Rt9x8Ttdv_DsMFmZTn78iLs1Iyuq-gw
X-Proofpoint-ORIG-GUID: 3Rt9x8Ttdv_DsMFmZTn78iLs1Iyuq-gw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
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
---
 libxfs/xfs_attr.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 237f36b..c01ed22 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1215,24 +1215,6 @@ int xfs_attr_node_removename_setup(
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
@@ -1261,7 +1243,15 @@ xfs_attr_node_removename(
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

