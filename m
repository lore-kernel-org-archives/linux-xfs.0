Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A538C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 480B5610A0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhG0GT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25072 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235612AbhG0GTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:49 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G3X0022411
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=clLrO3wURWOpYHZifA6fowdWRQQ3mgCpRSj9coAlpws=;
 b=ieJt49HRryWO1N6avHIxzW28brYRLSoQwwW/W056Ra+80lGuou1Hy0WNGzVXU7WET+j0
 WnZtOD8lLTY0NH+Xh/zq1GpbW1zVFDUt6siZeK6pZT6lMliYU07g0Gk+N6iStDGM+T0U
 nlVWeYoOEFzWfzS+J9Z5dkl7+gWWHiLBqrG4EG+fMQK1kbf3d3cCHZ006xVjnHo3DY2N
 D77dZBLSDudjVxjeWCuAJIMFanyds0WjM5A/XSYR4swtuoCrFTAXc8CZFziveq27AT/q
 8YpLRuQx0mIIItfYjZo2bY+PzvoISglEEhyez/jGdavcqq2QKMueMxOW6uXUF6dpwc6e NA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=clLrO3wURWOpYHZifA6fowdWRQQ3mgCpRSj9coAlpws=;
 b=AVBr23dAcSK9suY/3N9kNGd0AxDgvtYpcdt02gTRBnPa3hVbxiS3ML1a7eudh3/ZI350
 CwhPYPw2G6JnPtK/8f9t1Hrwznvbg0+r3chPU0ho4nLHPAk02xkzEVJad2IRXY0KmsRe
 vgrjnXQsvpbpziiN0LhJXXjbvq0QvTy2mSgMnjCj9wmU6DBBV5unTfrl2FkYda/BZvnm
 wxQwICMJbswFHd2WJYyCSJYwjWRSd9RK0q94EfZQ9Ug4KSg8ctIcUeeMdK7EmGL9eL2S
 uReYib59BnVieiuABVpyBZwlpc5h/2VD1HushHAkdQ2baCOus2RIQBUDtOiCy+KyEA1M qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23588umv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6EiaC065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvntm-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZ+aJ2tHigSlaSjth9nlrDC0l1/41aj0dRH+hP/tQCOZvw2IZjyAhLKW4EAgXDPOMyJJi9mfXtflTpR0ffBf/z4vWxvLZeeUKlYv+2AV7PafWZiq+ikdVz7OX6EgXN1wcocW2Q5rHCy8VxW34vY0RumtgcTNrWdGK7N17s1n3n9HvxlOkrdkkQQyjfPZTLunqFZPZfOLdJfQabRPXGOSl81SnPiX/V5B0PXt/l3l4yFOIXqcj7mPH2/a+nEPG0NQXJrCd+Mv/bYGXXgI77OBOOpRtj+y3AnCydtqWvaCGv7My29UAZZ2AscFTHNG/9pO4Rs62X0cEpsCEAC6ePsrVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clLrO3wURWOpYHZifA6fowdWRQQ3mgCpRSj9coAlpws=;
 b=PPJJ+3WVIgGE/d6NjquIpkEPAMQKSKsYLSonAlSogddl5wejADt/iV58NdN4Fj1e096kmXA8Gv4InfcRnbilSOJDbjY7C8ERfbu7M6MbCTWBxYrpwMCJqs4cXGi207sQV4yZNQ+pMVr7INlpg9Gr89t+AdMuxmddvmJjhwIT19iQKZPZBmOkQ/6PIXWzhDbgVpMN3nCLZeCQaIO/m0aCsRrI1HPhdq0OdjHWS0rEtUtWX64wybzRyMJ8IZ/3p80Ib8QDlvvgfEzIA0c3DxZRb8dglMsRB2pTBaHTtq9qwu4l7hrtjQjrtLCN1FukGXPAvv6w8N1rzpx5+SF5bsbUHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clLrO3wURWOpYHZifA6fowdWRQQ3mgCpRSj9coAlpws=;
 b=poSrP5yMA/AsqSPrfvO84qw37Es6DQaqcP2iyrb2WmotNFI+Ps0IZBxDAHhROgq+j9206loiKd5O8eYeujTvXMYCnuN54lUqTKop/jgfBObQbe+xdfQGohgu3Y3v8rNxMHm3wh5VKZIA+nJfHs0i9L0GDjtBL+IzgoCd2XF2oR4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 07/27] xfsprogs: Hoist xfs_attr_leaf_addname
Date:   Mon, 26 Jul 2021 23:18:44 -0700
Message-Id: <20210727061904.11084-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34d21b5d-1162-482d-903a-08d950c68525
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB366903DE7E05339D81033E6395E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wlFWZ9MJO8iC9PKlx7QyDd+G2HlfoacR6+XbW3RMaPC64uWxjuCU5CkZjAzS2lq+yGsa8I2ovfThqwxvV8mSIQfXovxkjR7JdTyAGyVOmngPHA9MZ515bFSxkRJ6eIRBDJWhdt3NZ9rhBGxoU1848eMJNlxJ4btvTLnvG6i6g+cSAoeI7ub2MlLEiQSmYfmmpz6InGkh3yq8cSQ9CHUaYO9tcOWZw3SF/78qEX9+o2O2x1QLiz6TIQ2ksS8Bc+YstEI7pSvA4yBKrgf7fU9tVfe3SRvoK09tcuRRJYkBRGljOkXDqVlnAW+Yp5LWwB/Uc6toz/0Io12gbd+cGO+qbpIBnjChLivo/vrfMozvz2AaB7G6PRpynbaT/cF4WWRag88IjP9lTGkCy+OvJ/jAwaaVRvhQQ8fw57S6lanQ8GZfHAhLVAKkqHlem+a3Vs2fvTgmywOBhG2YIIKahE36FWfj0vqSd1cI2VbYU4VyKrmiKmIYVll6AR7JkEFa6VSy5VlYPuHMC67IGFW+dq1Y+LgPcdjIthfQh9IKytPSribVMZ1Hxb7hKpFrN8YtPFXYJh1hs+Nag/RPzqfffR1mc/KysCQwazIrpDMsu+GcckmBl1OOxfWLc2LH2no97VFDY9ecjp4/mPagfGoK5IJxUA8dvpDi6qDwQyRk1i4Vr4ovGKB4Qu+w1uf5QXljvVTP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XE75LDZGEjNkEdNiVIbRlQ6oW8WugWWM7jm36Bfg98ArXGsgKK2CUcyMNbqT?=
 =?us-ascii?Q?OsF82R9I/Eo1ZX5tuJ3rriZxukzD9p7Vyj47GnEnxKWyar1ryDJ2V/wbKQ9P?=
 =?us-ascii?Q?UCXbNvWtZQuLtKRbVznj94TbfPRkGrSzjbJgtNCzDXdO2uOln8qlbCVJfrkn?=
 =?us-ascii?Q?dbqoRWDGDsy1a0/xkREBUQ1M6Pa7ry/nyFM/KJFLed1uj64OEF5MkRy49OLF?=
 =?us-ascii?Q?gaUiz0HEqMkOHBD/A/oqsAd+6jZxobL578+mWg7UQlL+Lje4I7C8PD5rryOd?=
 =?us-ascii?Q?2zgG34JDL9Uk9lhS9ZRmxFRFQVqCfo1nC25UfnyLA5sjAn1sNwpeYNK1zXvt?=
 =?us-ascii?Q?zcPVpaOuwRZWyEs45s0q+eB23Odx8oRCmpvwNJNe52M59B/VCGh681oNGghO?=
 =?us-ascii?Q?9VpMw/iorIhWBOYC6tbWwGqjhRdUnbFfnhl7zSkQZYjaKDASTvmeooUbKapP?=
 =?us-ascii?Q?U8q1rxMJAzIZxbcG3i2S2jbJFBu25timOQOQVKOjehh6GCDX+qDQ5NBEWTZC?=
 =?us-ascii?Q?HxhZm6lD5R65UHjq9lFmEBD1hSO8mOFwK5q41xc1GxmzW+0RrnBS/RUr6OaH?=
 =?us-ascii?Q?otpH1TbV8N44cOkth8p/BtXm/CoIPHgZt4KmzcWLbYsRjtSASXAUh/9RsOuQ?=
 =?us-ascii?Q?tKYEhfKZH4A9QZAhfyVsZ/oMcG3TvajVGN9YFpKIiPOrVOiAR1OYCWvTaWkm?=
 =?us-ascii?Q?NkVT0X0M2QRaLP7k3J06f4xy+lYmi4WrNGPrXBxVuftLW33+XiPX7LyT+7K5?=
 =?us-ascii?Q?PRz0imC9LoXfTGzi3hJ72qUjdvzYlTrzskA7DahTE09ObEAfYp5Dmdwi7Axw?=
 =?us-ascii?Q?vslVherF3snr8azNacMt60VBf48pOAo2MI+QnFCai0dQSMbSa2kocO9Docul?=
 =?us-ascii?Q?ikrvb/C9SaELaxtYrzWYED3qHfgM61RNVKP5LBM+NWIIrWSyn696/AkOorUI?=
 =?us-ascii?Q?ntkKxFqYEilqlXkgnDNtDlPrpYEXEX34IWRxX8Th3kjXff020jyF+xp46zhX?=
 =?us-ascii?Q?wGdCh4yNZho96KxxpTcjCaiwqKKzvIwZvpUpkmnbTz3BJXaJf7JFuQb3Hyic?=
 =?us-ascii?Q?lmmTG7s99J9X5OzdnE3VEKHBTcsFn6iD4o4ADCEVUHxCbcdODctkZs5asPh4?=
 =?us-ascii?Q?mmRnQIAtgnjPSLrP97ZdtFih/lKn2PtOn/OrZtiNnLnokuEm24aJPLkutgRt?=
 =?us-ascii?Q?/wKZ0brPzRTyIl66QJAHYwtt2ehw9l3RgQRfwXODBudp0fLpzTHukeJlFeh1?=
 =?us-ascii?Q?5RFGIq4nvKz1XirLQ9b/8gYrcqPYI1ZAxMQCxsLcj6tuAO+H3rxzeEXgM85V?=
 =?us-ascii?Q?KD9XXp1POiJ9bLUmffdoABP8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d21b5d-1162-482d-903a-08d950c68525
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:41.8727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NweGSls3O/Jai9BxM9FRO63hMAZrLgyal5HC/aH6zeryGYTdTAvWiMzaOo+k6NR8l815ccatZpP0LHAJqaYar+XorSmOhoVONKiNCY/UbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: YdaNm7zKUI4ngBAqbKBcUILR9kOe-5kD
X-Proofpoint-ORIG-GUID: YdaNm7zKUI4ngBAqbKBcUILR9kOe-5kD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45adc55591f5d91b9b6c7752fa4253bf3de33886

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particularly aesthetic right away, but it is a
preliminary step to merging in the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 include/xfs_trace.h |   1 -
 libxfs/xfs_attr.c   | 209 ++++++++++++++++++++++++----------------------------
 2 files changed, 96 insertions(+), 114 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a100263..fa4d38d 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -148,7 +148,6 @@
 #define trace_xfs_attr_leaf_flipflags(a)	((void) 0)
 
 #define trace_xfs_attr_sf_addname(a)		((void) 0)
-#define trace_xfs_attr_leaf_addname(a)		((void) 0)
 #define trace_xfs_attr_leaf_replace(a)		((void) 0)
 #define trace_xfs_attr_leaf_removename(a)	((void) 0)
 #define trace_xfs_attr_leaf_get(a)		((void) 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 16e919d..9dc518a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -44,9 +44,9 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -291,8 +291,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -307,10 +308,101 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_addname(args);
-		if (error != -ENOSPC)
+		error = xfs_attr_leaf_try_add(args, bp);
+		if (error == -ENOSPC)
+			goto node;
+		else if (error)
+			return error;
+
+		/*
+		 * Commit the transaction that added the attr name so that
+		 * later routines can manage their own transactions.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_set(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete
+			 *flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+
+			return error;
+		}
+
+		/*
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 */
+
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			return error;
+
+		/*
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
+		 */
+		xfs_attr_restore_rmt_blk(args);
+
+		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
+			error = xfs_attr_rmtval_remove(args);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Read in the block containing the "old" attr, then remove the
+		 * "old" attr from that block (neat, huh!)
+		 */
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+					   &bp);
+		if (error)
 			return error;
 
+		xfs_attr3_leaf_remove(bp, args);
+
+		/*
+		 * If the result is small enough, shrink it all into the inode.
+		 */
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+
+		return error;
+node:
 		/*
 		 * Promote the attribute list to the Btree format.
 		 */
@@ -737,115 +829,6 @@ out_brelse:
 	return retval;
 }
 
-
-/*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- */
-STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
-{
-	int			error, forkoff;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-
-	trace_xfs_attr_leaf_addname(args);
-
-	error = xfs_attr_leaf_try_add(args, bp);
-	if (error)
-		return error;
-
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-
-		return error;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		return error;
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		return error;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
-	/*
-	 * Read in the block containing the "old" attr, then remove the "old"
-	 * attr from that block (neat, huh!)
-	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-				   &bp);
-	if (error)
-		return error;
-
-	xfs_attr3_leaf_remove(bp, args);
-
-	/*
-	 * If the result is small enough, shrink it all into the inode.
-	 */
-	forkoff = xfs_attr_shortform_allfit(bp, dp);
-	if (forkoff)
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-		/* bp is gone due to xfs_da_shrink_inode */
-
-	return error;
-}
-
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
-- 
2.7.4

