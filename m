Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903DBC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8D461501
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhKQEQx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:53 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13450 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhKQEQw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:52 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH3CImN027666
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ncy9fIfoR8J9ug74+k59S/EA8Vjw7S1DvrQfkF0MIug=;
 b=vmRzpIUIbiykryk5azjGhyBEV4LBc6FH37/nQGfROKG0zcEomRnnEc7bGitjw7YFlWk/
 Z+xSOf5U1PhWX5+Gnd5ikVS7ZpcjNaQ6T3OYQTaQVtuouMjrXxV+yUsQ4lmUU9606qxL
 zq7NLX4rktWTc4BnmpuVBaQ3XiYvbpWLLyVSuf/FJ9Mv7ufuBmO5AgYHnwPiy+HZhRiD
 1iSiOsSI+f0vxTTll8kOtVNq3tPsdqECxQPAkpOWKYwwv03H1hQTXdouSlxQgopfXa3X
 4owXGrhGJIo0RCSSzpmeZ2FkPQ+SIbUK6lKAf4mUHeRW8QwxFpAEAj3Psnmj385DGHf8 aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhtvvpc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4B6AR184801
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3caq4tncu0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOVNowdYqpGIR92bTPDKypnDJ3jXnM4dvKl2WceqYPMxAJa/ZUdYp20NfqNpUYHPYgGXkJcwZy2PiRltXglotlDgNWAJOXkLWhwYryfZi3YrGabjJa5m/4GGO/i8ohmwDSZq2TvdufLolqp5LrX8kh2CBdqslSNA8aENplJmwgUgPwJqAUMiejd5wFZEkl7D/Qak6mCW1IltuEdHCaTS2K287mo5y05Ki0vaABW/sB1WVuXA+HCJv9BlY8PU7FZdCH1a3IiQRmzbZsZEm/h3sQSEPtiSiFEY9XA1Bm4Qdc01HpQmnFLERVwtMtmcwJr6FSmBkEl4v9jgbItjoRPDhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncy9fIfoR8J9ug74+k59S/EA8Vjw7S1DvrQfkF0MIug=;
 b=g4b02llnQgrgxXQa4/WSjk6F4/asU/0Zr57s27F4gX5i1BlFEkx+B18lPy0yVHeGClcLL6mAG+K3LH3nerdAx43GCMDf8Iz/zhu8mvVPEAaDJ4Qb8K6egTEMfUAAk/k7Qn3tDA9NzQ1K/aPG/u27RSK9MioPcPq8vSsHbQxHha7otl2D6tUWvWRe7kbFinveeAIB4115fi0MxCLvmKUsQXm2/RS1b92evwoettyQoyCMjwfcKGnPDbTIVIFpq4o22jpZlA5Ao2P7CTHINWLmYzJD2/MHdyTDOjRX+8vmSS6rZtYzkwGHxR/huPQJQuBCpPjIvURqklSItugjVbYDoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncy9fIfoR8J9ug74+k59S/EA8Vjw7S1DvrQfkF0MIug=;
 b=bQaEtQXgmNzC4yvIl9Bfj8GqocOI+zjvgN1+6pXjbdqDj5Ujt9XyWWHCsr5IQEVVnr6AuamB58NOZcOwPDSIQf5lp9/M5cqa+h+ExDNH0QqYesj5MFDCtO0TVoy89jlhVgoDQRY79G5dKJHMZmPGKTi5bGbMrG5HYS8oZcYTvXo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 04:13:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 03/12] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Tue, 16 Nov 2021 21:13:34 -0700
Message-Id: <20211117041343.3050202-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae8408a4-3057-4594-9bd3-08d9a980a87a
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB4086663042A773D471C41F53959A9@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPKU/rfFmEmTHAR4JZ9yyz+MKjGuuSbGWvy/fGMmsu+Fhe9BhPTCQniiaynkQDH7DRQJm8jK3KoEcyLHQTt2uWACeGsBOd7bMizJaOMT9RXnfBcoK1g5Jnyn+dMO/Jndoguq3xFfgLGsZQzFO+jLWgTzMdyflzrNqRtZGF2b0tE5HBpTe3of/iHe6jnc0B0bUPiMNektdvdKAg4ounjVNzQRET2X9Zd0XlU9afSpMQ+LMdeHzG427+Uf+Q9HmNZcCs52O/SqFI/yK4JCuykXZ2fgbEhHhHxFQkAeeHx3V23s3MxXG06IgtUQOeyTN0dM2CjE4noCcpfckHpBYA9KnaxVaeDflS82n29Tv/68zID3IgjA50fWmVccq4qRS1hrmDPQ1M63I/javwMNJpdlZk2z4bn8PrhKwJb7ZOe01qIpDo7rN50i7/ii+CUHjMEju2hznpSDyfHTxwq4lk2CeF/jS5vKDuuFNzhc4jKUU/CcUOBJ+MZ1WIKoNoDQTwoDmkoS/feMF2NVLIUTmTxDKBGAp7OA8E/fUStn/YONM24f7JNfaOCgZ37DTwZVSTejU/rbaycN24v06RmZKizMWmEyn51ZwDj8tyxZ6soTgDQxYnMGFL8zlltyqjslJ+62+Go/IVzhjLn5mvuSlEOQRjhqJwWo/eBNryoOTW4r/FdEaTPeDvCDjlPurLj4la/AFjH0uvxhZW5m4NlaVLHgJmxTbj/22Afv0s7POR//wiwTcvrgU0fKVJWGJoOjtf6LLqk8COcCBi+snp0GbTnHemnkV85xduGvI+H+dS1pXTk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(38350700002)(38100700002)(6486002)(44832011)(66556008)(8936002)(52116002)(2906002)(508600001)(5660300002)(8676002)(66476007)(6666004)(316002)(6512007)(66946007)(956004)(83380400001)(186003)(6916009)(6506007)(2616005)(26005)(86362001)(1076003)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uykQkhq3H7FZRD2HINOU4XfTCMRUjAIWCy32xkYjrUNXqNVDGoniY7H3e9S5?=
 =?us-ascii?Q?7nMPlmFAsJ9zwkjr06Vd+VM7YOK70nk2d3jh225hKKgmalrHNF1Sd9OUopRj?=
 =?us-ascii?Q?UY/atHO3j7PRLMvYBXQA6ei560sQP4v8RuK4kdiQg0EDP1Vso9atGhbdqAYz?=
 =?us-ascii?Q?HUWNkYI7B4S/Z6SOGuSoQocYEdHYN9NOBeJb/dvVPB934hYd3JrQMiUevaZK?=
 =?us-ascii?Q?Q2K9Z8zhbMr/qIskyiw6MUlNzLZPrnTtSijhLDmbeDgK2ovMMlnOWMvIsTt+?=
 =?us-ascii?Q?TUCNpJCvHkVpH7BqTjmKANaxh7PiL/wUkg1KZLUBvHN3Z6Fa+oFaMBPXfwJf?=
 =?us-ascii?Q?2lFTIRnilQwF8LYDa+2b4oKzSI2tHa1Mg1/s4chTrZ6Q5mUmvTqoYg8stE2f?=
 =?us-ascii?Q?vwtbx0wRpJxsbD9Xugtq1JBDIaJN6qlbr5rkoizQ9w0cic0v82NexHpWnYI9?=
 =?us-ascii?Q?1k9ssvAA5cqd+3iUP7zjOd0RQUKVmDg9oICRVAR1XUTOYMwqWJeuR1vBkal7?=
 =?us-ascii?Q?QvHSHPAiv6fjv8ivzqiJFoaD7VnXiE64MdI4PnAyAIFxUZSs5lEdZR16UYk/?=
 =?us-ascii?Q?1XaKAo0qjomXuMz47Advder43/S7pt7SLH9WZeOmQrTY0MH6hoKwaA4d9I6O?=
 =?us-ascii?Q?usnvW3yXn+vkVK79JuYPIy3wLARd65nzpXpfKUigOJQgID1bw5T+jiZpQHVM?=
 =?us-ascii?Q?VhlXAr3M/2xC5vu7lU4xFqF6WmeGFgif8RiJHpH0I2Ed7vL8my0sZCjcN07E?=
 =?us-ascii?Q?+gJ4/mD52VarebZfr53di4wisihfMCmjpCm/fmmkDzGPbp2iXmAHfgePuys8?=
 =?us-ascii?Q?8+fLteAzlsiXXB5YszXF1XR2BzYKWRjLWZlJHpIrFI45OLIfVKPDPpZXRNrt?=
 =?us-ascii?Q?Gso3Aeev7QlfCcoO+UQH8y+kY0uvLiVSNyyYKkXGChhK1q7ImNszdcl2N3vC?=
 =?us-ascii?Q?pOO3i4Ka510O3IMnUvVsj53jfEQZXtkS2mtMrbpy4BOlFFWH4KsQBFmhqGLC?=
 =?us-ascii?Q?HrzU0jWWHYBPe/UuoRoH49GQ3FoaW9fGl48cz97JfrQH0ABk8677dlAmmGXE?=
 =?us-ascii?Q?cdCMdepBggFK3BsMBF+k5JqGqEJfOA2eGMxDDhksJx7T1KGChj3C8PjpLH2N?=
 =?us-ascii?Q?R+ItpiT2RvWKWzOOXSAlB1HmkWBpkAlOmwKHHRlbU6Z/h2c2mXbYgk8awWCg?=
 =?us-ascii?Q?Rw5iCZXihtN+y43HzRg2x0zljZXfcQfwl5aykCZxLO71TZF1/j0IsYBIr4z4?=
 =?us-ascii?Q?hdlHEnxA08wOtAeIFHghtw+3VyEnMq7KYwRs4NQkJu6+X3smEC4YA0zca2bf?=
 =?us-ascii?Q?Cd7YPICpnzUO5btkODQTFezYxZE9nAZQvGTxEU49mnlbLHWY9k1Z+M99m8Fv?=
 =?us-ascii?Q?MkS8azJjMAEQ+fIwo6/oF4F88dRNbhVHqASzcJjRzMiWImB179A5/uBA3Q0+?=
 =?us-ascii?Q?mec+bNw0DwJ/hqsrlhcLY+M9Z1/dJcBS5e/rsVDUv5k7iV827JZtO8knarxG?=
 =?us-ascii?Q?VbvFTitXBvVrC0VliHK3JCuen7JIh44t13JFVSNDxbdRYyMJeT8c0oTBn5SJ?=
 =?us-ascii?Q?IQOb8CULjRGGkmVbj6Jx/6YuPGtSl6k+dqfCXiSMVY/+A6gcCvAVBIfTHjld?=
 =?us-ascii?Q?vxxi73wUjjDNND435g0WYrjl7zcRcRYRcFbW8IVeynlVFF5iuXQ0dd9bjDH5?=
 =?us-ascii?Q?9O1hCg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8408a4-3057-4594-9bd3-08d9a980a87a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:49.8246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kpv4xMTDsYqQGoj8BqsP/06Mu/fi9OLChz5W+G3iYo1CeVKW8qH+yCYYo5E+bvf3HEHu86S6UAf8p/MDkvvUJiWPD8s7sVxvTuOwp8MPom0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: k1deemM2DHaPmdbAqKUluD-C3kUfFcZF
X-Proofpoint-ORIG-GUID: k1deemM2DHaPmdbAqKUluD-C3kUfFcZF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

During an attr rename operation, blocks are saved for later removal
as rmtblkno2. The rmtblkno is used in the case of needing to alloc
more blocks if not enough were available.  However, in the case
that no further blocks need to be added or removed, we can return as soon
as xfs_attr_node_addname completes, rather than rolling the transaction
with an -EAGAIN return.  This extra loop does not hurt anything right
now, but it will be a problem later when we get into log items because
we end up with an empty log transaction.  So, add a simple check to
cut out the unneeded iteration.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fbc9d816882c..50b91b4461e7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -412,6 +412,14 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			/*
+			 * If addname was successful, and we dont need to alloc
+			 * or remove anymore blks, we're done.
+			 */
+			if (!args->rmtblkno &&
+			    !(args->op_flags & XFS_DA_OP_RENAME))
+				return 0;
+
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
 		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
-- 
2.25.1

