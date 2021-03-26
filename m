Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559EEC433F2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D97261A40
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhCZAcF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhCZAbw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0QUuc112704
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vuw0zBE/nJWm1btzXP1ms1VkVUUIPHiyYBmQbALBvEM=;
 b=f2ySpwSx6ld8p7klrCtS8ocrtI5z97R2OZpYG4oxnG5tcsY6C1C7uRJeBILU/7kZi/Nt
 ZWFb8QXzOWiRTDvt2Y5YZKnX0D+LWLXh3fOM/NXEHYNhtcIQavH9jZrFXcyY0ATzRsaN
 ndWnz4UjcbE/isngnMpE1yaTKCeLpp8v4Nw0JOgApOgI2FW4PU1RJanxAMZ+Lb5FDutz
 ylk0FvyVUnavDLfogOMjNqR7AGdGV2huhecUNJR9ikGQpGxXxIJdvAwEi7P7TBXqc4B/
 vatQMm3Pq62M8mFRZuSjdSYSgyqybyGOz4YEfIJLkyXKLXeznVUQrulGVRztwXNI4B3S jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37h1420h6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6V155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLILr7volb2sQeMofx8XZwQNovuTWllOyQzUe00eJmrMzdqnQpW4Pa6SJcC9u0brvWQUkzx3AYgU5QwrdxPBvr8geeQIVxVHcj6jDmn4chADNJyPjoLg+ClzLg8LQ6miJuKBGMaEXC318RW4QAkJgq33zV0A3L29kkLhz8noaCQkYSAHiqTfswkzqd17IYx/VOpHou4vPrAdIAzW05TZFMIUBDqEgcizIEPzMYKHwgKfe0cPNBLoyCYXDCvhIOdmuFC3w06aXpxQJcJEoc3SOgENkX7ZBFKTqW6nS3wEHRH0zL3SxGbKh+uqlcFRrUHo4C43+M82DXSP10bbm2DYUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuw0zBE/nJWm1btzXP1ms1VkVUUIPHiyYBmQbALBvEM=;
 b=lpdHeEzFvjQ9u8CvZzJkv8QsvQaIZzfJcTzY8aW7YvBsVuqLix77qKTakB2KotfuvsaNOtnLc6QsVWb7DAPi700B9JPL8+J5FXSMcWjjn6/ZWlpyLCq7phj6dCIJMVfVFmmlpvshjSR13zky+XFOwBhhTJy3DRdMsDtN4TjkPuDw38mUEm4IaAtR58ZduClPIcVZKoj/RPLNww6+TZNO0y+O9u0z/az8FDZYR+kDkoMkixOR3T5jtQZU0hSQE1gfLeRiHzSIOfmDb7z6SGqvbgP5H2JXQimxpMIOHOuNTJidNqsssNICgh4aUj4kIYQkf9vm3+tK4xJHCcRsped0dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuw0zBE/nJWm1btzXP1ms1VkVUUIPHiyYBmQbALBvEM=;
 b=w77/WSKr+bV1EE31w36SBwFevUhKJ5EZbpO4CZYk9xGFP5ASd95lodVMzexbcr6t8uCCI1sBrMkzC4jmQYN7gML0fJnuoPPxRNtg3rN5cMwis7UY2oRCGA/awc07ooRWhQpOOw95JhijUgQAhXRStX/4DB7ptXZ8tq5yhN0N9HI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 13/28] xfsprogs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Thu, 25 Mar 2021 17:31:16 -0700
Message-Id: <20210326003131.32642-14-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5da27492-cf73-49b7-277d-08d8efee899e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758FE110C70F5A9AA00F22B95619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WM372SnZ8/bgZ91SGumOg3nMvw2TlSlxycZ9phDty2rDteYhJq3JoAlYExUDZPcGGucW7js4gK2CXqQNFf7/vXJVatWVYvmVLY/4LVBXbolOqNGYY4Y2NdzFhRWNrhd3oyzn3n/J/sWTsOyQkS7IdHuQ7ASgOcq8Q0NY8Fs5gnzamkkb3jdOR2J1PZL9XBAUFWv+PylskMnRy0k0krm5I9IA+7s+RKulTR6C0FogzlZw2CzJTs5qDPrUJE9tpjw540dhlAfKOjo4FkQ3Lw2iRSt1+6pj3uq+yk0IFtG/ISsCapWd0R+oVGBxJSQCvfRJiLbaWqEpoK4tJhW3sdqgKovNioR1TuYUYvkedW4B1HMgrZ1Imayq2G+yRkrKDs4qUXPsQgvijmKSjTCr1SWZJrbnI5zkoKK2z2hGYgZDItRSogqT09WFg9kc/OjM6Zya0nZS17g+hPFevENLX8KB1c/rTmv6NRqCaKyVz7CZBYWf9gU++CuJOdZNIrvv+MYfktRQWREQJtybW6K7C3ChZM7UvtJNadZYkVHzVbuRh2VY5X2YCobQZmkKDVj/EzYBjgqS3czHQ8QMNvETN9GLKSKPzvc8lAf/6AKJNwmJ1dA6ORpCNoegew7eIcoDCct7z9YPTXdo13HYBfj0+c9upF5Uk3MEQ9U42ad0czbV1X8pENoHZYi0JWBJ6/4/iprL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZmAy0d3hwVqmcet21DsitgJbsq8lFlpODn+HNrAimT3Ci4rXouwOwr8kdRo4?=
 =?us-ascii?Q?s9LqIhxR+5MmfgFLV1neU5dATSIO3lCWvRpsPyRGxyzPdLNZymcLE7SjylX7?=
 =?us-ascii?Q?qNhzlrnFdf8ZgNGend+QzWE5AzgsE1PBXJ+j5J6b3QxCietEOxGp00j4nRKo?=
 =?us-ascii?Q?N1wTJHfMk7RZjGRS5KbfcqNaAl0kzQtCTnhzxLZPy1d2f67fUAn5R5Za85FG?=
 =?us-ascii?Q?ZAEUIgmenfeT2WQlaV0FfSKgRe8mnW+crU7G8dH3A4N8amv29cOvQwwQQ3s2?=
 =?us-ascii?Q?upEP5fmf1J8944DRIa9KGzoaHr3hCcvD/A8WnsUPp4FQ/3XHaf+ymT1fyLD0?=
 =?us-ascii?Q?T8eJtWttq8rFEEJdv6tDKqgTS+WnIHdBNitt5VllNvxkgxlPe2WjTpj2WO0d?=
 =?us-ascii?Q?trWB7TkCkdps3enE0U5bAVEuLPqSJbpa73NUKuyI0NBYkAGikuByOEgX8Z5+?=
 =?us-ascii?Q?Dogl0CGyLXLh84OQLTS8cr1fl12XAg/iKD0rZiEoP51nf/pAcq4sjxUmUZqD?=
 =?us-ascii?Q?JOHQ+OYTydISOT8FDrcE1OSe1HeI6KFbFNvG5EC/rth9QEnzvnzryFKDKT4D?=
 =?us-ascii?Q?T8Ws+irEL0I6glXMam2Ce12ZEcXhWnuDwDQf5xp0y/HyUDcoXzz+iWR0hozx?=
 =?us-ascii?Q?iJtMMul0xm7Z47qHpMVIiGoU9Dg5Xx3gMm16J5g49ij9fjvsvFXtOoOv0U5Q?=
 =?us-ascii?Q?SNyOvkyeUBjjrti7XFE7dU3N+nYL9PYH3R59yNHWlkHNFwMMDzWZ0DeP0SOb?=
 =?us-ascii?Q?mOZeoXA5tXtyx+n2qcqO+eJKmurbD3fGs7HbSQR0HaRz3zI4Qg/4Vztp/PEb?=
 =?us-ascii?Q?Qoey8vUNm/lWVgHroIiz2swrBVUJ38IIzgy5R2hayzALD6A7Nwqemldx6SGw?=
 =?us-ascii?Q?ro8LdYLD5TghuuiPwD4SvZJpe5BJHcXWqS8WQcZZSratVBp5PD5Yi8oHvz0T?=
 =?us-ascii?Q?cU1lz+8bQ8858X2td+5xW3sDIuNdcyETmjdzO3h4ass7KQL8g9Jfga0DZYsy?=
 =?us-ascii?Q?6vPL+OnvdMF2YsSvtkcUtvXkzICZixpuoctx/kNGZ3P4GgynP4bC2D2bKNUC?=
 =?us-ascii?Q?3WGAME0Dl8r9tN5tB50PfQI8Xw11OsB9dMVsr3oueozypuY65EnJTEBqoHmz?=
 =?us-ascii?Q?N2op8SlUUHqkZAR6zwDazOeq1QzNyQ0SfOQONiUD03klxVmD6JUg1YkW8cN2?=
 =?us-ascii?Q?+wI35CPEwNidhpTZXYN7/26uJKwjWGy178AwbiQOiIMcvgwnvVqYgPapwOh0?=
 =?us-ascii?Q?56S0ir3EHjSHtyzkAYcoyMnA2ij9MPixIYQiVTY6r7YwSqQ3FyEsidxkPkwJ?=
 =?us-ascii?Q?qWF4dJR98EFSIgcE154Wiouw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da27492-cf73-49b7-277d-08d8efee899e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:46.4287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mv4c9vQNV3gX9qdJfTJEnubEIPiK+y4/T+frnZ2CYuiL7FdWz+L6/5MTbqYn+V7V/TTDR/OMuLVFjMVNJukrzX1N0KNjUFC/brhu//F8Mao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: M3wBAUgh6VSI9MgFHV0C61CMgBGelfga
X-Proofpoint-ORIG-GUID: M3wBAUgh6VSI9MgFHV0C61CMgBGelfga
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: aff4db57d510082f11194ca915d8101463c92d46

The check for verifying if the allocated extent is from an AG whose
index is greater than or equal to that of tp->t_firstblock is already
done a couple of statements earlier in the same function. Hence this

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e9c9f45..836e5a5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3692,7 +3692,6 @@ xfs_bmap_btalloc(
 		ap->blkno = args.fsbno;
 		if (ap->tp->t_firstblock == NULLFSBLOCK)
 			ap->tp->t_firstblock = args.fsbno;
-		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
 		/*
 		 * If the extent size hint is active, we tried to round the
-- 
2.7.4

