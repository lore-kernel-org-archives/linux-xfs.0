Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42785C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0092F613C2
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239245AbhELRGP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55684 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239712AbhELQPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGAB86028534
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=PIq+0/TMBhYMaU948zTJqSJozdswrx7JQNw/b/6onPd6f8bCk4mfOlptVQ38g+FjnY/b
 mzbPazTV2Ttj1cuHJmUCAVEmV0b4RFLwIlh4BckWg8Cu96bp/R/GujL1tP+DEfpxN8R0
 5w9p/50TtRVyGI+Jgl8LC3UzTHfqzmTQCvu3XGM+JDkUZ18wNE9kqqMUplFESnct+pv+
 gCm/uSclSDSxCw/sktdTVINO71hh7sjfq3Q5lRR0m5ONicxYuaQscFsqR8wXFQZMMAbM
 HaqujDakt0J7sxw3oko7LrY/+2KUXHv/4qLNL0OHDlYIZ0qWqVB2jmwnNAlfMvPUrtUk IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38e285hua4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9fYW021006
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by userp3030.oracle.com with ESMTP id 38dfryyw0g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=II9v9os+Avw65DABfT5hyoHVblVJMbTKvnDS6TRrfqzwllPsnmAjfkRrD98Bki3lq5QXNDpm1CXxrYQ/ZGGrR1MkHIzshwOzNCUDlyXcp70FaIal7VUoQRf6GMifdbdJVwbmTez0rWMtTvPun8ReC4+SbHoCypk8OLriCGM5wCSJSpZhePbsHEdRGxOjofZjXV5dO1zHVLh1zHxTUqYF0twB7TVmK4J1pwZRwMqTcAeDDW85oZRuzVD7d9BVp7sckdeyHBcKP+ARiTqXDb+djd6hr2eLMeTkWSV171+4Zs514unRO/vrGuYiZfcz6Mga5A61HcbHGll7b903tSSvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=f3/hqDFAEnKwA2BhfrvM9AzWTqKu1bvGycrxFQWpDa8ddOzgFJIWTf1Yrjlp47GzB3kgscGJWXTPKgGsaasDhqQLiQ101wI4TCBoAvkgjfU/wBYam+9mgrBx83+cVps47vi72nsPo0o4tIVilOOSq2hUet4AzbkD/zUV6eqqH8ngySS6y8IIbGOPvkmlYIbqGY7PDAGc1vjjEfxg3ROGsnwZRVXi6hQgbI+fHzA+cpFKXEvsc4s6CwoNcfUzKljXki8D+4xhS5jPqzAEFMbGCEVjPWKc16SLPaordFDDDayOJN2ulVQD2FSSmkZGkjd55JcJ9TfXS+EGv2lVFzyKvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=itCbZbLUPZqChu4g4e5EX3H8+gV68nSZvxwtxHqFPsT5Dz3hC4SylEbp4FGGkQuF2zH4U6qcSU72P3Q+JDsPzXttSA88h1bEdR8Hb491P1NlN6PKayIubK60VY7TCHut5NAR540+lIb3RpZvC9IuxE5RyDSZnZnsHmSoNL0AghA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 02/11] xfs: Add xfs_attr_node_remove_name
Date:   Wed, 12 May 2021 09:13:59 -0700
Message-Id: <20210512161408.5516-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512161408.5516-1-allison.henderson@oracle.com>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d2d62ce-f14f-4bfa-0fc5-08d915610125
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31120211A056D68BEE3DD89895529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mD7qRVOoLFmTAvIfMcpoIK4pawCQrPniXpSGu6MAlZZqwlSv3YzBMm8SE6v373t4Eq6j7+QdES71YBGjNvLLa8kUm6+nCTTFqVtUy2QXx7ACaCu2RTV5Dq/yplh1pFD9rJ797AVBVk5srm80fYAwXs89RQ2MMYbkLCGh15Ow4GMm8MIyhCg9c+ENz2A2ICMfa5GDrqSkcYrk6eUVL5lHPtIYLdT8bw0XOc4giVoNOeu2Lvh2qBw5gsnKALGGLsv3qYtJY6jw3/fFHktk9Upgu4JM6oitOP5ugOqFgAL2DMSRgAzSA9PftMJve27ZuyItgGqvYlfZIbS5I26AA7W6k6JUkbeHbzKCJktYG/LjT8MzJCE3kkW0Yti5e+gA+w4tytHj+uB3HBhtnxI1mb/K9b64l52eR8Endz8bQRGzFcMs23otEZWR+fJQydlymfm7z9hwskMpChNagrpJdBeThGyDqZb+oOiDsoYgoTRPDzLTx9po8HUnbY1w4bO4vEGt4SRCzBJv7+Ym7JTm7yYmV/SxotKs2vMU6B2yHsmVhJhAJeKqYblYKMziCUEzaSm6oYxgTZtAYH0hlR+sV+5GtMnQrOrHqfudBtI4PbGzCZihbG40t4AWeFIwDAzQORFsTgXq+0bNHm/fZS1gHC3cIAAVE9k2kBPtJfkEdM73JEZlacHCLbDqDQ1NOizTupzf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(83380400001)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+mnuYFwAkHJmxCUzov8e20lwQpcn035NrddSiCz4uHYg2JtiH3j7b3kFS5HI?=
 =?us-ascii?Q?Xik9+MQbzWq+k1+XCbPObJc4zsKYL4OVwmEkVRTbBA2rip6gPcs3fW0t7umP?=
 =?us-ascii?Q?YbfsZ2CmjQM3DWq+dRIV/9pgf1rF0OZHSpPiQesz21swLLFO7XDzNtEMPyqc?=
 =?us-ascii?Q?5Xo5xB4l3EtzA0drm7UVPTVmLM/7A2AJEznx825fF8yA3pAd6vzFsOr4NpBr?=
 =?us-ascii?Q?U30jAMVOssowni/2VBMNoVQM20B41aI7B22WlwPl/eo5/iro7scWfGg4Dycu?=
 =?us-ascii?Q?g2Ibxzqmv/limsHRR64Xh+Gprkxn+w32Hzeeta+2p3+d8Cx58E11gihz6I5S?=
 =?us-ascii?Q?RPlE78s2Ww3T+QNl4je2yzsxi3v7yfnj57lQwMeagirUgBwfFBjbMUO/qNtv?=
 =?us-ascii?Q?fxk2SEhDCXjDYgJ9NuEu+w8fzMLcqmQ4S5x0tR35nMFn5LHF+f9XNOn4SKv7?=
 =?us-ascii?Q?tlawnxAKdiMNBHQs0bLbtg8WqS4uHQZ1wBY7UGA8w4VnM2KFQ/QhjMfHayTS?=
 =?us-ascii?Q?POKRwcNdlaXGhSswqc8zUvOIPd/Wlrkyi0TstHJ3vGOhQ1VlmG5zHD0ERUOM?=
 =?us-ascii?Q?kGtTdOo40FDdCsHb9Uw7RNk6dvTaBHtwOb2dtSWLtXI/2lmc/+4HT/v85az5?=
 =?us-ascii?Q?UTsIYvIosfYNEUYMBiHFxhzDqstxPy2/KksEQ5kpYifnJspu8lRXHsgzY6WL?=
 =?us-ascii?Q?LbrfRSfRAlNBsh58W0uCNBJ1dQCONxVBjhpPIBU9e5V6UZalC8fU4yT72Oib?=
 =?us-ascii?Q?1DJJIrL8u+Nx95ZAuDEG0nG39eoYBhZnKXrKK/R5nu5n573f7XzwsRGIuhyD?=
 =?us-ascii?Q?BtCczDQErxBpFB9TcLN7N1L/i2ECm5uRP9udzg2YzUNGVml2kr41gijh/vaM?=
 =?us-ascii?Q?o4hTek4kbfS1GPWdQkAcQYV4XzqRiRFAtWNtXTElXnucBxeYRh5NHtxHsjr+?=
 =?us-ascii?Q?zuPP4nDfDdPQWpfsGFY2awcBjJUmABhtcqwMPKXf0tJpU43aMlm5rw0X0xHn?=
 =?us-ascii?Q?eBamoMShCV1f1MtDGI5BXSxd0r4t1+aIk3mkQ0lXH9/4jhoJVnVK2dcL2TME?=
 =?us-ascii?Q?JsxNbFXaPxlBq79iX7sOFlKVFNKS+24ObftOeAsmYuy5FsAQIamrbKsJjigQ?=
 =?us-ascii?Q?JG2VNsriskANBDebPtGezDKsJ0cY02UoagFJFPR8nrMCl8Ueg4BiNB/rXF2/?=
 =?us-ascii?Q?7s9NJW4bBZBo+D4Y0KIw06/4vlZ5+qMiXeokDTdiqG4JhbQ3NiJI5z0Kpq6m?=
 =?us-ascii?Q?EYPUWMOJB5QyY7N+Zekb5PMuKsEIkldzj3zU2lSnxm6B2zJUHxcPJ/T87tnY?=
 =?us-ascii?Q?5/g89G4XFAJwZcTnvczom/Vs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2d62ce-f14f-4bfa-0fc5-08d915610125
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:22.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIKWxcbcOzTbjlFEMc1jmPdBEdQpzOuh6gkoOPPYU+i8XGYaHU31hJhSNxab70DTDvxRiPry0Dg5g1JrEQNDM6g4P2tTVmouLCVFXZC08UM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120102
X-Proofpoint-GUID: 4IYKrX5BwTsPMHWw3WgWu7iomNHcX1TE
X-Proofpoint-ORIG-GUID: 4IYKrX5BwTsPMHWw3WgWu7iomNHcX1TE
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch pulls a new helper function xfs_attr_node_remove_name out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 190b46d..8a08d5b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1214,6 +1214,25 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_remove_name(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1226,7 +1245,6 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1254,14 +1272,7 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_name(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

