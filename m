Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFAAC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B34BB61009
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhG0GVQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38722 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235558AbhG0GVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:14 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HBxm010840
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cl4VCb7Hg7BkJbwab8UsVEv/RXBZa0o5CXp4Qsvz8dI=;
 b=zJROvCcCSjf6BAXyFMTDOHhxacwOLeCSjF08ELcGmv4xlcuVMmDwmifBTvEDd89V0kkk
 VuCa44FW3Uphfi4vy1RbuqlhefPUTS/6ZXAXXwwqM47sWd7foNcXVhGK9wvUX7HXCnpH
 YntsYVp4gNpjIp3aPj1f6/N8AF63YsQHqzg6yXzV8Osx5vM3TCt/cK1FuNh9qiO/d7Jx
 UOUKBfwcca+7n2uyxatDfYeAYzvQ66yIvSudvisFuzWYTpcaoRf6vIik6mtZCEifXo8h
 aKPzImZkElVyr/G3T4pq+2uxL0F7vwl/vpV9e99LbgFzLPtJGYrPe0IvrM0J8WZJEtap pA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=cl4VCb7Hg7BkJbwab8UsVEv/RXBZa0o5CXp4Qsvz8dI=;
 b=TiP8yE14YFw/hXXt5oueBwNrsDJx6xvphhTf1GaJ9PvwbxEI6axFTPRPDuSZw+qQfW2B
 SnySfTcw8dmaevDROIkD/jDYN9gctxaxtNs7sIB7lnXh0tL+f0BctxJGA2Wu3Y7pvu4N
 HSZu0MvhnImTXIWge+P4AAXOgwY6WS90AA0S0vVf/KW73DS6xUNayWyqq0JZO5CMCj2p
 midkKd+4b8aN0v+5pcJxRs9Us3dzm35ZffITAK2M2u6fVigv6Ai3E1xlJRSv3u2w88z1
 SrKKh4Ya4a53S/lJ4rHZTe08ihFgNISopxM+c26vh3BBSMTpXjcT8qDsoRh9q3ea5DSp XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0v9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjRq114857
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 3a2349tsre-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huURsjEN6Yw9CY2gI+IqfEQIwI0XApL3PNB249pgd+7Uy+0ATRv7RqA2Tz0lYMOqepYZF/Rt5DKAJCyyPeF/ve7DyLkNqvFFxGXA484SrifBshXCo6jEG2jyUyR8mOyj3re1kR5d/1G5HT2lWAAql30wNqiC+vxRfZnrDdCHFMTYkppoxrKoeyyK+m54hgTZlv+IKCKtAlEzYX2hedJh0eYioxyF0Vdqc7/Oex1b6SA+mSEOnPJG4s6KQ4B6a9r3kTNxRXJks8cYCx38B/ZolyXZHCmcsAVzyCOFkmYogVQSJUl775lLPGyNKORZ6SY2BPKdTqsDlFFi4Nka+ARsfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl4VCb7Hg7BkJbwab8UsVEv/RXBZa0o5CXp4Qsvz8dI=;
 b=ij8hUbPcC+9djSc+ZpXvJOA7tnHeMELQt98tOOn1OKljnmXsbLWxzeStKkazc5s9iGAk9np+/8L04/P+Y5SJa68l/vfHcmITZEML8tXUzmlJYFbQgdHQKTSUjj3kRqogFwTtDOk5HItv9elOWvIIcVyp0U24Y//9dvJ7OCve/IMVkDFCanLNHeVW22FfDy2TEYL3HPY0i03/qlSd3bsc3BYDDjETEltHwc3yaaYxAq6wiEaNf85tG7jcZAhLxguv99HJ2MayJ5QhO/FJa0F084JN/sU8hNsEjhUjXz6scHAUFQe6pKAMBpDc/kHEXIpSGhD5Eu/t9V1T4jjv7Hz6UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl4VCb7Hg7BkJbwab8UsVEv/RXBZa0o5CXp4Qsvz8dI=;
 b=F7en8vYgP19qmWF3rAZeNCZwbPD/Z3tARRwpGhPI6lfammK/44KDfUf2L5wQUiiT+S7vqDlt2WlvpOouO9M6FlmYruHJgsU6q0GUehGRkSDHQExjHaFviYKry7XrRY3nxXMGST+eykOO4TadUqPcqh3xvUQC6ZaOPE2w6BRFi5c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4669.namprd10.prod.outlook.com (2603:10b6:a03:2ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 06:21:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 05/16] xfs: Add state machine tracepoints
Date:   Mon, 26 Jul 2021 23:20:42 -0700
Message-Id: <20210727062053.11129-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81ab8ff3-198a-4082-f88c-08d950c6b9a1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4669:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB466936BB6AF2B93A69BA6E5E95E99@SJ0PR10MB4669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z8xTX7V05Dxqt9whtbnctosVhCRiwNAU1LA8yiJm6N2AlY9mbdhNoNu/7bkT2fKvE8BTMmUiGuP1wTYNV5Ft1nr5PluFiSo9a7jV/0R+Iv6f9EVu7knMnliWXkUodEDpw0+lLfm18V0kreOHCcQ56NYoNYiAH7n4XJdy0dETtZwwYKeHbTbGVrF8/9YHs7YtVyTq0M+uTobLuqWK8lMqAzIHV5Kitg+oDw6m4qK32n5e8dKZtYMVK8cjNtJWILHfZG+opOP6U/GEYzQ8mAhh/i0LG1oVZ1oI71K6tilKat2o2CJz2gQFU94SIKOkf4IDX6NWqqXIvsHM9BKUk4AYW7zFToyNyDML0zHshuVrN1rhDUr0A9oDDHKXGwrCi8EPu9/D7ZHP/6CZNvE0ESCVF6pbWAHXLhcwMSSdjhrmWXuJMxg7MD0YYeT8g6/vnY6V5o4i+l4YPT8fBfhcFGKCgPo9WS2JffE3FXfTDHJKb+7xrhVQdzdgAf6bgZVwGkOZoTbjEEoIRRkVchRrYkMyhdSTXtL2Qa+96843ZDPhfCKxoWg9ZSS9Md/DpY8g2azUhCEr6mcDMHPH1dl9+6hp8VKHusuvsLtJaBvj5DpikDsFUVUAICzrktXMsf0IZS+jQRii/MpESimJ9gdt85yscKO6q7uY7JQsU6w7UtKtjQUUeiRTRi0T44agq8bNbvvR/mIk5+OXy7AWy+bbfF/QVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(6666004)(66556008)(66476007)(66946007)(36756003)(186003)(478600001)(6916009)(2906002)(5660300002)(6486002)(83380400001)(52116002)(1076003)(6512007)(2616005)(956004)(26005)(8676002)(316002)(38350700002)(38100700002)(44832011)(86362001)(6506007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TAqa8Dh0zQW/eHlxoVJJTj2w6sgj4Bia75K8Yb+RwwLSKLTyc6zR16qKftdQ?=
 =?us-ascii?Q?7mAqVwklAGR7xQkjce6Asxq/fv3pbF442+9VW6LbJF+H9VGX5aEqh1K7sEDA?=
 =?us-ascii?Q?9L1Rx+BYpGFNCNt4hnc2oXm9hSZtvQt81Y9FI9nr4UXFnD73LOR8k0yHzOnH?=
 =?us-ascii?Q?cfGVefZB8DVmHNT1SL9hYYa9v/QVpIAJBCcBZ6OvuDilZBQJNxR4pwhB59yA?=
 =?us-ascii?Q?tBtuLg9joAKTWF/Pw+TMEvPQCb4FK97gPMe465DrNjdnxE93JJIPzw32Fv7K?=
 =?us-ascii?Q?p28xbqyAiScqOS5wryO8WMbuzGACmRXpI06gJa1zCY3HJ6o1gxFmQPBwXjPC?=
 =?us-ascii?Q?543jb1nZjlIGHZPbgejlLOEsLUCc8xOFuMItekJx4Ua6mIjBQxVCgR4vaCSt?=
 =?us-ascii?Q?BjQWhwfwnSoRgLMVzxy8PxdiGzlQ9sJg8faJfH8whehUYEspSi+/ghjUHC1y?=
 =?us-ascii?Q?0Be6YBSSAlMrnv+52tLOY6mggJACBIq6+iqrPEn/i/qTRRAUUJpBZGnA3tMa?=
 =?us-ascii?Q?RFgE9XOTDPrIH4rNmGPAHTPhI6ssjLKmqnBm5MXW2U61Y30tZpqzj7PX20PG?=
 =?us-ascii?Q?4Pbq5X/FrJVVOIAooZUvL0zKProkFJem7rIyVzBRi98oD2ovvDN+y0caZnbH?=
 =?us-ascii?Q?124QP/01+kP5anKhBPWTHBiQCJsAnJjDIvlhHf7yTJibqdC9SEVn8tjqVD5V?=
 =?us-ascii?Q?Um4gapfo/4J1AmtH3SrDT70u3OPRWSV5A8UbzQwak0TJmTK72GeT6ovMu7Dj?=
 =?us-ascii?Q?WpRzpvSxmASkVunnF/gupuJkag5YzFsIACRVrYEgNE8RmE90hxKxvHlS9Q9O?=
 =?us-ascii?Q?c9BURaBqu6TP0c+bDg+mhcpu1XYjM8dOx+vFz2tHToor2RRmu6NW4W1oJNzN?=
 =?us-ascii?Q?bgNQKA0K4i+hi2omeIXidAcRA/wU3NokQfYBMbCK2L++FzsINWQpG1NJaZ9g?=
 =?us-ascii?Q?16GyuH//Kc4XlIKczvre/kc8Qk6iI04sqFHC6MYAwNr+gjfZBLxO3jh0TvRH?=
 =?us-ascii?Q?Z6Um+kauX0G73O1BwI6SNPSTrQ95ENk70jArGMj+vHXyU4xW9fArp8Vc+njk?=
 =?us-ascii?Q?rltj+rqBTS4VVLmH+n9FHe+Eb5w3NRrH34mogWkm243yAzrI6uA79G3U41HU?=
 =?us-ascii?Q?GoO8Lmy3Gz1qjWrSOxV/SLEEg2200nisimULy/vmendZrdUpz5R2mdL4zLDh?=
 =?us-ascii?Q?Z7VgJ8mVmwiHEbN/8YjcGYX1XM/bOdWTv+paBJnyg4YCGBrQzphOV7Awnoba?=
 =?us-ascii?Q?9i6se6dG1h97W1ZUtYS7qIi8VR2OlqKmxjUV5c5aJsuRiiwV1QoR6Q+nFxzd?=
 =?us-ascii?Q?RuaCaI2T3I+o5k8mu+U2i23R?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ab8ff3-198a-4082-f88c-08d950c6b9a1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:09.9574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AurhlB2luIbSOiQ/EYNu/uVJCXnupKhAMW0u3Esy21f8hPQhshnoXOmQuJ35ex5norHXb+YiAfS19CmfZ6EnXuKxizFGd/K46udFOhu2R+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: C3pJwtFuJxucTFOJesMTF34qNxKI-e96
X-Proofpoint-GUID: C3pJwtFuJxucTFOJesMTF34qNxKI-e96
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a quick patch to add a new xfs_attr_*_return tracepoints.  We
use these to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr_remote.c |  1 +
 fs/xfs/xfs_trace.h              | 24 ++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5040fc1..b0c6c62 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -335,6 +335,7 @@ xfs_attr_sf_addname(
 	 * the attr fork to leaf format and will restart with the leaf
 	 * add.
 	 */
+	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
 	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
@@ -394,6 +395,8 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				dac->flags |= XFS_DAC_DEFER_FINISH;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			} else if (error) {
 				return error;
@@ -418,6 +421,7 @@ xfs_attr_set_iter(
 
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
+		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -445,6 +449,8 @@ xfs_attr_set_iter(
 			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -479,6 +485,7 @@ xfs_attr_set_iter(
 		 * series.
 		 */
 		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
@@ -496,6 +503,9 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 			if (error)
 				return error;
 
@@ -549,6 +559,8 @@ xfs_attr_set_iter(
 				error = xfs_attr_rmtval_set_blk(dac);
 				if (error)
 					return error;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -584,6 +596,7 @@ xfs_attr_set_iter(
 		 * series
 		 */
 		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
 	case XFS_DAS_FLIP_NFLAG:
@@ -603,6 +616,10 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
+
 			if (error)
 				return error;
 
@@ -1183,6 +1200,8 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_node_addname_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1429,10 +1448,13 @@ xfs_attr_remove_iter(
 			 * blocks are removed.
 			 */
 			error = __xfs_attr_rmtval_remove(dac);
-			if (error == -EAGAIN)
+			if (error == -EAGAIN) {
+				trace_xfs_attr_remove_iter_return(
+						dac->dela_state, args->dp);
 				return error;
-			else if (error)
+			} else if (error) {
 				goto out;
+			}
 
 			/*
 			 * Refill the state structure with buffers (the prior
@@ -1473,6 +1495,8 @@ xfs_attr_remove_iter(
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_attr_remove_iter_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 0c8bee3..70f880d 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -696,6 +696,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9d8d60..f9840dd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3987,6 +3987,30 @@ DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
 DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
 DEFINE_ICLOG_EVENT(xlog_iclog_write);
 
+DECLARE_EVENT_CLASS(xfs_das_state_class,
+	TP_PROTO(int das, struct xfs_inode *ip),
+	TP_ARGS(das, ip),
+	TP_STRUCT__entry(
+		__field(int, das)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->das = das;
+		__entry->ino = ip->i_ino;
+	),
+	TP_printk("state change %d ino 0x%llx",
+		  __entry->das, __entry->ino)
+)
+
+#define DEFINE_DAS_STATE_EVENT(name) \
+DEFINE_EVENT(xfs_das_state_class, name, \
+	TP_PROTO(int das, struct xfs_inode *ip), \
+	TP_ARGS(das, ip))
+DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.7.4

