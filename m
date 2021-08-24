Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96651C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 710A761371
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhHXWpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24870 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229840AbhHXWpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:31 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OLrRMk015014
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ncy9fIfoR8J9ug74+k59S/EA8Vjw7S1DvrQfkF0MIug=;
 b=Dc/rnDoIkz0F8pg7ZKNirLtxsvpygNVPsUAOg8zcrBjVkpE7we4n7SKJB+Vc+BrrEMqz
 eGHPJJGAChMxV6D2KQl840Rn1eNuLcmtNDU/9Q/m+vHLKY9LTX16FczimdWUxSejGeaA
 wUDdJXJTGX9ShAXagaCJp5/jk+dZlerOgaqGmt69fH8N5VHHkqrw2pyI/0SM89tRuVXP
 41EECO4lzfsuQd//IPkHiccd6t11bH0PJwSxu1JYu+WTEPNg7bXkNpDYXAyqrP0Taz3s
 F31et+p0xUK3uVrl5waAo8UHwVr89K7DyRGSscPljUYiGiEAxtmj/mRj+ZxfDmNETAy/ uQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=ncy9fIfoR8J9ug74+k59S/EA8Vjw7S1DvrQfkF0MIug=;
 b=plFJq18lkJ01QdZA1RgaXXPSIx8Of9/YRQHj8L+KxLcXPOZqQJBeo2ZTTT1K01Mhl+Mx
 2vOLYsW46+qU7r1S7Q5hWvowIfKCdmc5VYjNUTbPBqTrpoecTJF3W+0xDzAZIg9TQRKN
 wlL5VQg6S9IoF5HPKdTJhxDNDBigi8p9CFEdnRTvVtf181QBiw1Jbod+R1F6maOmhNY1
 /DWrXdlb+QiMqOVzDQvXEh4m3FGvbYFLrYAuKym0luCUBmFhoRcPOxgfx4xd/v5nIDAz
 sB7cGAQ7FB7m9OqE3a4o10OL/bfoANIfGaXnByt17Ry+Y2BWkmrMAy/kkSAoV76NCKYH Tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwh6hxxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfLTE138047
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 3ajqhfehfv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOXChtl5FIqMkYIR0PJ0OEw3cQwXsO6JdUw1b+9AxdHKFhY99j3vBtzqZ6FLKHIyGEFThLW3t80mBI+6GfLu9H/f4CKlfxPU3W34G6y7sPLna6Sxfd+mVkPcC/0R/5ffl3jdLRlBjNm/aBVoL09ZlQO6E3Us7GsaLNFPW+5ibdlhxv8W3EYxG3GZWDy+GiZKf3DnMSZcVQJjMHXa9fFzuDpuR2pTOTGbnX8/tlJQqjjii8kYKZVktDEU/OYsseHNZQjQAnCX/rJ0zmdZAdnmHKdQ+7rIRYE9zRvnul9eVp21jWMhkVXBuXenkuHYLasxmyGsothqk3Uxm/ZJRSzsZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncy9fIfoR8J9ug74+k59S/EA8Vjw7S1DvrQfkF0MIug=;
 b=gS2i+AqD2eGPn7BJ2MUV7Hik4QPyG4b/9uSlsCnBF8p/duH9k8NtJvXajdqKeYShvk9nwcSrk61b8PVUWyqhgVOTqgwAVAglM12Rrq+hobhU9tLb0/iNUo+USdGI3WY2hBPjIfZU6/srHnWMCW1nA6LZ0+Ofyw9h5FsmBI7zvMNNzpj/pauWgW9o3+qTN1BednPkTBr4W06DhAy53CzmOsfuw1frrLVffQinbS/vDF48e42OkBp2UtIDeVUw7PdVKsXzdVZJ24CvLvnJaCSl3FiEYDj8GJAQBTiXz/08UJHzBTk7GrR8sA+G+Zpk2X4Vh3PRfzLwpqG4kknEGUzBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncy9fIfoR8J9ug74+k59S/EA8Vjw7S1DvrQfkF0MIug=;
 b=r72qD976W+/92C09qvjWlu3vU+fNdSKTzRNd1lDitM3VkO+5aiQJxiP8bgXqLn5LuHQHRzSkoK3NThsWaKUN4TrQK8DA4OoaHWm1HXaeXv/VweMWZoHp5i8gXHaawo5pGb0L0SrRzbBVtfSt0rb6Z2in4NMYnRpm6ZhlHQI7wSk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 01/11] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Tue, 24 Aug 2021 15:44:24 -0700
Message-Id: <20210824224434.968720-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c08c400c-7fe2-49f1-8779-08d96750c2e5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB465336821DB96CFDD191894595C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0KMsIRRMrYFdAH3FkTkcCbE1oVxBcbcSpnZ6JmMyRu6wnDAu+KQgZyhCfuobkPGq/ew9LpL4PqACMe/dUcm2zaQegrMGK/6q7DdUnS++aYdTIRrjNcLntcue73dk25a5iBtBhlXKO2vuvOudu/6RvQSJ5dVOamIyF4fjbGHUPH2f79uzgDp1xGrQqFLffzN5pf8B2sSmHKmP4jdqii15IaCLekEC8g+fr+TTRbGWi+b87WlmeuT0kEbfz2/2Vvoegpj9NDn4hrQPgfBbtCqwCgH6NvXajBDROY9PyR90lkuqrEd+ZmPp9+InxoSzrJWmQn9RQ5um7fX6y5yo22OGVZeA+cBDh2GIHn5nF3diT77LbVsbDKvRSwk/NCgAq9zDkmhp68YWNjNOHR7GYadOm8DvNfqgQ04eIS69ejZkpEE2Qzx9H5JZWJDugPi/4rnpVI+E1mE+xtM7NpIs1NIw+JsZf7vN/m8O82uCRktqM7LYuqFzBOF3iW580DXMhc/6ADsVEJDac4NaPYqAgHNRPYTFYTQPs2GEgj1RV/K2eur/uYIrxEexaR6iInrwGKOaZP9OJD5hEvKEn5IGQ5e3PfSFceJayBgVom20PTFUjXkecvrqgzUuKLbO3/w3vK/2ydtvJUVn0dnBwNquv+ZdCtX5HQ2d3XAljoS6IK/j7nivd+K3FkUK3pVLmIpptK3lwzCs8bu567xpQZBkuj8aj3svkv6i3zacyZdjpcHcYWIn/NzKczqE/V0Hce4dPo/cfDSa1br3qeyXV5S7J+eXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yo0rws+9HYb4qSuzBTdUG0yG8TOTN/z9vF0HuAvuAXou5swuzqQti/izRbm4?=
 =?us-ascii?Q?aJj0QhuLsB9R9J1gSYw9wfG/41DT/q/5JVJ37Zue8bI2oMgtNwajM7KZL7gh?=
 =?us-ascii?Q?SmOa+vLcdwN8UbG3lMIBKrKzhRMAJqnhIi6DT03hWcy11EHMGKHfgIQuXd2V?=
 =?us-ascii?Q?Pf7Txx8EueBuuEBYCD7Kfb3YszJBZ6AD6Ci1lo8z8rf2OrmgIqwuspgdrpA+?=
 =?us-ascii?Q?ueyE2GOcvdA/anJdR64o59ulgJlCxlT09aJFpR/oWa4/H93XE6zlGkU60Zxu?=
 =?us-ascii?Q?8Q0CP2fUoiyWAQFmOrn8NdEsX1OFsdS2iYlOVG5Bk1xwwLRvN/0qmNidUHDM?=
 =?us-ascii?Q?HaC0qQ1ooTCF7YYmMyAonNtR14hSnO58SjpV8TT5d3/4kByn9/2sB+tYoXZr?=
 =?us-ascii?Q?TMZ7ORRFhi6KgjSLoge70rLVWXKugagS4qKm1bsdBTGNhMJO2uQcJqVSnxmP?=
 =?us-ascii?Q?kosEB9YUSGAthIaINdTSO7r1NH2WHtq278qqBNe0JNPUEotrnF1TH4xUH9b/?=
 =?us-ascii?Q?vIVEmrrTHezWOHMQZhIlQktxb8WBIy+qINwWcLuEsGezBqpxk37F3pbSO7Dm?=
 =?us-ascii?Q?9sRSm5MINgOb6hTARMz/dhtMevTs/Rc8pYMVPHFkNIACF6PfBf4fntGGkKac?=
 =?us-ascii?Q?VUIUkSqIRJwXC0Er0H4nG0d7845H1kCB6GrbB2O8RU1ngUHcKU9DQUqCs4yP?=
 =?us-ascii?Q?2eK/A2jnwgoNQgAxcrKgOJi2W6A7u2uWb0n6Cy9pMkWu5sbOueqQppStJbtv?=
 =?us-ascii?Q?d1UNs1vkn0wEMPiupekSOvh+JnmW9exW3m8Rg5+aWlMW6gmi4z0S74Xc2qNh?=
 =?us-ascii?Q?Jhz9v3H4vIcWOS+zkYp/Teyr3P0gOet2UNGaVgLkssVmuZTHn63iFfdvZCii?=
 =?us-ascii?Q?eiBK8MXpSXcX89+/6JOyJx5RWaC8iaLjKvjplBg1dlphIzlbyeSEnjd0YJcT?=
 =?us-ascii?Q?22NrmCC8F8lvkjuxxC28NRvZhdSzlhkH1faDNroVPFGK7jEy5K8Poic0xtI8?=
 =?us-ascii?Q?tTNmihJcvtXWm3S8dajq0a3loBULfVqAOylZHAIZDxdXFJkUkK/8CIfBe0rq?=
 =?us-ascii?Q?ZIGq2XTVsg2iAlPdiXqGHFqYb6RLaN0mxzcIVsxeSngjSzkwu+7J2MzRF9tF?=
 =?us-ascii?Q?mthZoRzfII/bUf6LLavGEC4yog9zO1NTfWB59GSc1IH4Y136lSiuJFWhVOr+?=
 =?us-ascii?Q?WpuKYY+6Zbojs4ozsCma0dvh7qXKFwCzxA7sY2gbdWT5GydkJZjEVygZ5wlb?=
 =?us-ascii?Q?5ybizFUfAp9VsgBZJ1sXECStZ3Ryx9voJ3E83TRpZ7BUKjbyS7B5o9ziigW0?=
 =?us-ascii?Q?EnhmSRsuJM55mPndlt9KEbit?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08c400c-7fe2-49f1-8779-08d96750c2e5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:41.6185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cw6L0MkPhkgGrBOzzI66QrAyefzy7v3yuw23niyOzx8suTTOCP/oAYvuQrvOQcF27SXSHXwwYol23IBrufo+muof13bHCpwF5FMXj51daGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-ORIG-GUID: wKpTDRZoocqd3eR2AgZbowIaJNFR13Q5
X-Proofpoint-GUID: wKpTDRZoocqd3eR2AgZbowIaJNFR13Q5
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

