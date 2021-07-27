Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8404C43214
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A989761131
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhG0GTt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23154 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235323AbhG0GTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:46 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6I7sb006844
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dMgTBZvovZyAossUjIP5PcShwGlzv1iisl+yEsc5p6w=;
 b=gmNt9PGhix0pAHfJ7obLfXHBm5ZnbT4eImqEoX7Q9ixwjW9SYORmjsomWjHy0ibeLwGX
 ceM0geWpdf/T7iNpFdbHMt4T12Gi/Rrz3XYOuohg8vU4PcGdT+PgWJAiO4F6SNrpQ6C8
 QIP0qxDXbIZWtfacDQAlGJGfGV8w9QS5FSUV4KKf3P41Uoad7x+z9iIWgdvKWQIJPIwU
 YXu/Y9HY6vXkiu36wYdrTQy9eYnU9KRRbTFMddVNerd1Edfcg7zdReazg8IeZaK9XlhF
 mgd2N1t17BbE1w7IL9DNPl7pQi/tiPy7MtCSTIg35lc9+yohKEPatFZg9SjQt0Au17pa xA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=dMgTBZvovZyAossUjIP5PcShwGlzv1iisl+yEsc5p6w=;
 b=ZPO99uWC6+o623AbphJp5C0sWOWryS5OzdgzBUcq6ATheDTpS3/OQiq1KhIlY1gecgZQ
 tjwYSFxQdGIO4AwaKIRB5LG9S2gdw4WTayBB5bmmTyAy+6+xH9difz0qiYk9Kg7b6/4x
 5UjkxQBXVy6v2+gFkwQ30y8l/2hMErzLtm55TUwTrk+3k9vB+V6KJ7PcYcdkRRvuhkPW
 RDPHmbzZgp7SclYPPwq6tQfEpDyGawmfhWiykXKz/hLAN+exuBm+hWeUXUuIL8uH5dfu
 /0u60d3jJV9V6d/4HCk+EnWnSJxhIHh9t6ZfXi9wI6UuJw1FUH/uoh2jztFh+fXI30cf aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2356gua0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6Eia6065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvntm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDHAhX93h0GSN6T3xG3vatBs3QF9ildFBwh3SMxyo6psRmev6VN4YFJWt2+Gd/4NLLA63bGmoHaEqriPBk0voq09cwUODu5gCIX1ArSLImT7Fr1MCzfM/E/4SpJ2r1eWilV6H9Rhq9PRaax63izx+Eyrzo6ZGvV/kVuANzEhtuBPd1AgFwsR7rle17+yQ5D66Zocx2Xz4cTxNUANiZ6jmBTgaaBfjj9R7Z71Up3mB8VCk/LzEGqC73Cp3QXdg7GF0W8cCqkUdlB4ANW/HA4dk8+wvFZEjPdmrHXwIAKIuPsNQgPd5sjlhEJZWFGvUkPJad/+O05TABPrDPQS9C/uQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMgTBZvovZyAossUjIP5PcShwGlzv1iisl+yEsc5p6w=;
 b=MJdkNWIwyJZtEToBX0xEiFBBRpqxiZZSeHlhYGSngErkduocx5HM9rdg9rojm49qE/QnyZAHkAaiqlkTJ4t78wB/8pGFYiNuUvb5yEqpT6nJ0hj76j2sMknhoHOR+n4EqspOZdb3b4XROK5EeDxiXlvtt+tddYhTRvQ6Wgji9ffD8kg7QLsV+1S3lPOL5zuLSqxLKcaZDBbA2SVL4rAtreaYI14+uXA0+fIopAhgblNfqO+hVW3vNVlkmAUDrdz+JhyEFECN6j711v7NyKGTipMe/P2vfWme0qxSCHhvdwvai4QLc79GzpuB10k9YcRtUyjjcrEf4PlUZzrsyFhZ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMgTBZvovZyAossUjIP5PcShwGlzv1iisl+yEsc5p6w=;
 b=FVVz+aCYOfU3AeUjiDAkZMo+ZAR+o9dvQ4nrN4NLuZl4T/9Qfads3tZ6MraJ7xKCZbJlvkIJZxEI90Z/wBZ/wp7SgjjiqgEuuE+p+vNgU+qRqCF0xaIjgixvsQO3pFz13NtYNtK246Yatnrey2n3nlE5cyhpAC2afKaXSKvSgkw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 01/27] xfsprogs: Reverse apply 72b97ea40d
Date:   Mon, 26 Jul 2021 23:18:38 -0700
Message-Id: <20210727061904.11084-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d9fd56a-2a52-4a3c-7f05-08d950c683b8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3669723F9CE814A5DAEBE85795E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9S4j/UnePv/qnxydZ88yMtvKYa8Qv0PHkMWGFCTuXwjJsIdO7+n7ee7t5NdXJr8LeK0+KnC8JJFkNoNgcADoRKcc0crHrCMoNmaMfn5I4w3EGUaFD10MwOkuC5PBctu6kir4fBBk8yfh1tSkKofBYJyUKbKPFkc8WZzL0RKjLsEb30INTje4fsm/YHpKkj6lcl0yoiAmMwg47LDTSRlrxK+Kndf/lI4rt+QejTBj1ExC2yYKv5ZRZZzgL7y5YwIVDKfqfkdZT4l8g6v7wIlcJQCGymyvIevrQeRBpkgSvQOO6BJd6+heI364aCOfxxjrH438e0aR5HKKR5zsaae+dt5T3kxFcusWCQVVDJ6/sGRraaXFAMk91E/q3fv/EOT2MOEWYTJyYJ8bvTLr1XV9yjXP+5BLrqJbFFFCZD++HKN1QWHqWI5GWtJvSgVbreuKfSHo3+BVl2ZQeYl1chcyozMUvEAECTxgKBBBcbRjKXZ7LfcFaWkntmDpdklwuodtBUTzoMh7cHc4i8pvjouLoYqKs+KxmtSeoo5JMy557TWQuf7Sc6xNdOPjWQsnyzEr6Jz7txudCW7uXL6zVVYljqQ8thkJYtn2ZRpzTFBgmR148NAYTQZ7vw3FO7AA4EawhsHWY3OQfSWkCd0eTP5OLIpXNxbVJiQyPr9TkPQQm+vTIHsIuCoGr07prd0wf0pe/3oc/QweJ78WbLR0+i2kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VkqhK+fPn2KcvsTXw/lfcb+PCn7ZRMYqYwrn3r28NhVZKlzXVUxCmooZD3eA?=
 =?us-ascii?Q?EfIYmEfvfEHqoexDENaaw6Q2QQ0Zdj3pDMrCsbpWxZ2v8EUJf1VDqMsHQQqN?=
 =?us-ascii?Q?lxKb3EhfZX3W5rRngageWF4hXSUErdf8PJDDkRRCbDvWuZktwCjcSGMLZiQ2?=
 =?us-ascii?Q?WIYNEHFQqbx2v6Jugeb+dqzH6SxafkpU25SepeLfrtvlRVa7hhkl6PHkou6b?=
 =?us-ascii?Q?f4AM+xFac5mcP/V/Imin6yN9PC1sIOxKzU36wyTxmPi2o6tubzWl3WAuKk9R?=
 =?us-ascii?Q?7oAtAPc5ZmuCAkKcreEt8A0IGKg1GwaPfbv3dPqPlMFXkZRT1h5bymib7RAV?=
 =?us-ascii?Q?GyR+P5ih38g8uCvFLPWtH0YKxnEpp/4LZeYlUiGoJ4Cw151Y2BJsRmV+yEix?=
 =?us-ascii?Q?m5KI8v4xDf71d1sDdFVtrD7dGORWdUDyH9D3HwIVRmXJ6dElNz7TgIESNBAX?=
 =?us-ascii?Q?Agh81Pi84ClTfwQPzQsc0/U9/WGl5KiUgv0ks1StbssNqoGIR+kgGESMiSDr?=
 =?us-ascii?Q?UxUF4LZ33LJFlQstTWTVR53j40hJbkwFo3bl/1y3iqp7mMoRZnGdaqrraWEA?=
 =?us-ascii?Q?7RU7aD25MVknCXsgRFGzPMm6zhpOnOuaXmRbM4sp2htNVbq2p/cl8ZREMpPY?=
 =?us-ascii?Q?tMG6XHhR6KkKAocgiBEzWQf0kJBvXMc6FAnHX72iBUwP39YKnJIjNcp9sT96?=
 =?us-ascii?Q?nffR8AuU3pxmkjZ9rlHsexeYHL7jb2mryGZRwE4KPvGECSC5Ewi3zSCKbyfR?=
 =?us-ascii?Q?SN9RpXdmeq6Zg8/rW5IpzXm85Mw1mWwYJfWmweggRa07Rrdk4IBiyOxObsuq?=
 =?us-ascii?Q?H1mK/t+5U1bJeu4aGUAO4S6VNOZagtMp/e3eGEl80bHi5bTKmN/mzMz/DGs2?=
 =?us-ascii?Q?Wax3rQHT4kEPxWq4NJwdS/3KemxTi6WMlX27nr2icl8lT3yJbDsMPJKt1Yrm?=
 =?us-ascii?Q?OSytVURBCsbzVaUA9K5rRVhRvDSGx74xE0y/qSptPYcb5s2YBTFklfaqi9fD?=
 =?us-ascii?Q?OKTnsaj+YONFmi2dtHneT2xiSftA5FO0CVRLXnm67VvkEPxC459urww3GfOK?=
 =?us-ascii?Q?RB4YxO/iyodZfiMJbLsi5ApuEjm3wiOApqXIAY1riIBmLXxBSz9p1astLjup?=
 =?us-ascii?Q?LQB4lNkeMan6dS2FR1GC445cwfQhJzACBBG6y8LCmm0FLItg9ka5x2+hdERQ?=
 =?us-ascii?Q?qReutuVthm1eJ19y5IyTYyJcXKJWozOMigYCYsWJQh5CpSN/ALhqcKxRBWoh?=
 =?us-ascii?Q?5Ytbn08CFgdFH9f+I3rrs7qm2cx1s7grxqbM8hpTyMaw6HA9/eO18H6tgJe7?=
 =?us-ascii?Q?redQ7WYxt/nm/8P3yu0AffQT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9fd56a-2a52-4a3c-7f05-08d950c683b8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:39.5220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tl2hwOD0O0mcKtQWX0oCVOiWSO1zg6cbl1l13b64pPvD5yTPJdLiNPiywKaEfExm2IWlrVaDx+QWI9He9LGFaTahn6p0Tlfn/l4Grap5g20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: BhmeVgSiuEOwcS9bUytuodW_Kzj8IblM
X-Proofpoint-GUID: BhmeVgSiuEOwcS9bUytuodW_Kzj8IblM
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index dce7ded..1c60bdd 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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

