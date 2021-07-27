Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF51C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2777261108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhG0GTw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:52 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48262 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235508AbhG0GTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:48 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6Hge0023061
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DE2KwluMVBHitQsexNUwKY8Mdp5Qa9bxOnYXrKGF48M=;
 b=fMwYRlLj/LS9HmsnN5/vs8OSc7DIxDrDu4xkbvbRHEcQCrHcPaDUl3ipTQKY5zthr6S2
 6EFUSSuLmxb0MjMM1tOVKRyb965UgPtVocz/QuJUlx+l3DojnbV1BUwQ1+DzHULw6DPU
 +T0zHTyGXNDSQI2hCnHgewjp5c5ajPm77hEhVX9IH8Qj4eElPZFKZYLys2TMf7b/qb/y
 LrCucf7aLKtkDwhw/1hmH+bfH0KXPwDZsw1IzTc58Cn+2ihjl1/mu/0Tq9luAfpyeyF9
 tjE6SLs/ghqC9w/2f4PJCrjPSbjuueSWIXXR18iKCnudJal5UP4u9WfKsvR5lmfHSEZX Iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DE2KwluMVBHitQsexNUwKY8Mdp5Qa9bxOnYXrKGF48M=;
 b=Kyg2uA8tLyj2Ca6zVJjwo/7/U9POWZYtND5veheey72rZm7CY2dSSgPULI6Rtwb154jo
 9aQMJVSkNHwCD9xirG+BRrY0mcEhy4uA53DWa/7djfHBiiN850D4yrOUnv5g+Wu8aWof
 yEMcjlRFI55CY64YDowZmWQI+qOqg228LTse2bLzGPk0DilOaW7WoBP/4ti/LyG8C9G9
 tuKKdMwTECB4TOdmYihJzYEDKCSJsJOOw5yayeZMR0rHWFUH8goZOGAHu8v/Ap/Q9sJ8
 qacw0K8byewIIUPWIPcC59IKS1xV13IPSlChjzWy7hxa/oBmc2ZF8JK97UeE8+hfDOa3 GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJ4114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiJaokkKGvvF/FrbadhfxBhrMNPInOUaCzzPmyoRqpXqigRyAPCcPzrboPMPWyFmCdQxMGO5uIOFGxWy8k/r14y7kT4TG+TtTK2a/epBxv2WlKwTX3RI1Y4AUVpq+vXEctwcYsB6/xoj9PqEHmnfaq20P5f2PA/fEGhQg7sZBM1oYTmR5+KMtEdpQ9KZSIM7RGlRl0ho4ob05VQ9DqPQL8RwbBQ2tDXCtcYRVKSRWm5lKoKskfkU376s23tq21oSO2n7dIbOj/O/UwhmzmTKdI59lNmEsakpuIECzqjZkn5Wn5hKz92g1qxBoVoeDSnxpqMsWw4ibIqFR2C6mrtgbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE2KwluMVBHitQsexNUwKY8Mdp5Qa9bxOnYXrKGF48M=;
 b=WH1879dA7JSP6dcmqc0YSmH5ucnmlXQFHZrbBNGzlkpLU7kAWS59jUNQwcb6vK1lynDqyo+b83fizfHdPYqznRndQVDY9PFP/4MOn6ui4qiUFrbZco3SO0uBi+gZqeEi7CBQiok4pAPrJnpCWYtaIQodqYijee/C09gkob0fd6oC8bFaRF1njsBH1qxrdwlb7vUBfyfru/orgDgJpT9GUX5566bnIHjSvzCLsq6BkcEGRhq2GdLJEHcuBMV74JeWXP4a+oz7SDpI6gG3tDBWf7j9HZ8BAZ09ivyaBtIaypy6s85aqPHymjfOMGTymUfEiIP31Pkhprp+LAAl/h3+CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE2KwluMVBHitQsexNUwKY8Mdp5Qa9bxOnYXrKGF48M=;
 b=NXRHExQuKnSx3b7PLA5pG52iwGdQl6qlgn8cX24EIioVsRynAccDhXNwV4vSSqTUMTwhMN3K+ezwq4jaayCObl3OOa2o0bMx7D9ydlUVPss1+wfRk3bhZLaqoD3+38kBxoVQ7PKMtj3NBoJe4uYzX7TUxrajB1RT3H6V3HtGcug=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:45 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 16/27] xfsprogs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Mon, 26 Jul 2021 23:18:53 -0700
Message-Id: <20210727061904.11084-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96fec0c8-6670-4518-add1-08d950c6872c
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2709E4FA27F209553A7E9A5D95E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gTxUggDay3GRlXJ8xleYk2jpXc2NbDrYES4fB0vvBJWy1OxI25CB2nJvKlpOehu5MK122j7E103kJj8JDWKQIKqeHWTA4vi0LxUdfJ5PH/auOk5l8UobyphkVlHdJY5LvK9eYCdqSFuTa1RPRisJ2xJ05N2OEw91M8zSfPsz5E1/KoJZGrJnnKTd6dyYVsjK1vLDXnfcEOrzY9pPL0UwB7y7Hd3xfClyJgkGYreB58veJLlqAfSggqy1HwYyXGyrBxafnVaHci8mGaAKWxM218C+Dv/ktIi+B2hkIrUTBQjfpevdbqr/iAAKTGLq1xrnrCKwZlRM+zX9rvcvJkiva+lr/UWpUf2cMUfktsn7dWVN8H8DavW8vbpk/l712TtmHG9fBz5MOeo4G1PK5kZ76VWqWsCIvdJpbCXxww7gu2GlWLiy75hR0vaBO2LOlmpabxOPjfCWcCIxzi/Qx8ODAVuK7ScG9o2+kstplr+qwAzPF3FXhwOv8uCLSnwTvlmY7A6qkl6CxqU6Hlid09A8+y9O1KQJdUSMm+OHserF6czl0L/s8hnmHYa8G5q+1xH8UTd/xvQVbczPy9JxNVhetW03uEqJ5TdONOoda25NdIEYlpf/GGMeusvnrD8GCex/LzPbjWjF2pNDL3CpetGuJ+hgWuTgwSg/TTe7+KKYhdxMNBdasHuS/C//CNHiJ/4P4EnQlz2sBVGg0pP8TxfpLsqOJbnYtTx/ktboQh95cElnoNL+oYsFM/P6olxafW3UbHBzBFubMWp8FXAyRR8qEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(6512007)(26005)(1076003)(66476007)(66556008)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8968PamijWEjK4xkNphI1J3wSRJwCNu3UQ/WZU9gKyZy6oCARFNuhCJ+zir7?=
 =?us-ascii?Q?XPhtQyev90YZoTT9vleOMcrGvLF4VU31kaWcH365dnoJZy+GSdaXuNAEhwjP?=
 =?us-ascii?Q?yUTqSIeATEtzTQYxACSkHfATHw5WoS7+Ucy4n71wmKI6hh0sUkt2wI0FuiUw?=
 =?us-ascii?Q?ZNQjE2DJaNVT6z2NTJhngAg671QZv4/W7KbEcUON7P+zuHKixLNNZeRFrXZu?=
 =?us-ascii?Q?6ZuAQG2oPSfV/gqcIIR51OaykcfoDm82Q6nR7blOlsOxMOd6vxzBKPjHEMs3?=
 =?us-ascii?Q?IU9xLwbYNM4bXKJMoT456xRQbf7ykcrJPRiYli4JqBg3ng8M+zlOJ8/+npQ2?=
 =?us-ascii?Q?Xav0xavB8ZLyoWBQCeDwC+st16X+ZxWLYjMeabz0/sRG3h3D1BCvCRCa1Kwy?=
 =?us-ascii?Q?7ohUUN05mkZeD2T8AxKHJj5dHmJ3ToGH9+x1/4Aj2MAVBjM4ECOJaQfSe778?=
 =?us-ascii?Q?HK/1kCIn1dVmhrOrYDX9/ks39xFq/WUckzQjrvWzuGHy19lhkUG/8zPi16pp?=
 =?us-ascii?Q?wXtjDg7orBVcuTHZYcCUbhgOsXdY+ydDODVWAILuXFOfOagmqEgW3+jLyvKt?=
 =?us-ascii?Q?pqS7W2ID6WU0949P3dOhG9p7n3VGwrCgJ+4lYcKfqIPdD/Pxqe6m5XwPwS1M?=
 =?us-ascii?Q?mCO9QwEE/7DLOEtl6r3iluBNeJh/Fzv2PCWWxb9+PKSlY0Vy5WxGZnxfXTtE?=
 =?us-ascii?Q?Xva25D7CwJ88+dHOe5d0EIMQVbzTCDdcxLo4Ya80RjgC4HH4LoklFkpD4C/l?=
 =?us-ascii?Q?iFv0bgS8dW8kJXf1Fw1l/Dt2tBTJpT02mZlJ5P3sBiFpfi/m1s7w8Yhc7JiP?=
 =?us-ascii?Q?8bHgTYynlpVEui+gZXFwWawdn3ZGOURZGP1ZhpAD/F3cZ2J0z7DQWLhxktqf?=
 =?us-ascii?Q?KBAkNzfbTQBrKXEVkC8qixx+DANwIjJIRXuYEBYks6m0lZUUSIY6Tzll/4G0?=
 =?us-ascii?Q?nYd9lA27J95MD47qK36MV14AzKp/tiLaJiUGEWW1G2UlaXWzFZgATg2GikwO?=
 =?us-ascii?Q?6rMqu7fuCiN5/SDdOoCvWFsZOnpH1o44JxlhG8oMdyuV+fLgyka9rJqx5bZx?=
 =?us-ascii?Q?KcwEfWZgi/XCbGctkjfWHEQn2OpGtCOayB/8KWaRyd3aD1dYyeXRVY69cP3v?=
 =?us-ascii?Q?SO7mXx5fjCt2ITl6BS7kwxUMvhw+k+q6/QL5jNYf0j+1o3ZBJrv0RCiN/cTJ?=
 =?us-ascii?Q?Dcco2D5IXyrY22gMapqnMcg09F2xL2QcCZqBWtJzPLzKXp0VUCJTOgtGOvP8?=
 =?us-ascii?Q?kz+mgSd1OS4dof0eJ1JcKtw+81wFF6PrMbaTX+RojL0tQyJDM0dkm/oDxkon?=
 =?us-ascii?Q?JdRyrPHAIbH0EVfx2WdVsFGq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96fec0c8-6670-4518-add1-08d950c6872c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:45.2728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+OzzHNre23Ok3d3saXjuGhqBiXdwieCO4DQTB/87+wBHIvwRBh7j+dSxHmm8wf+pDfcDU6RpQ6Uo+ZECIra44nNWhxBGLLJoiADfQxBuwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: UEfZC59EQ85wSQ7oqo2mH_EBsFGlt9Fo
X-Proofpoint-ORIG-GUID: UEfZC59EQ85wSQ7oqo2mH_EBsFGlt9Fo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: df21062113850c5aaeaa38b5194ee4c64767fb7a

During an attr rename operation, blocks are saved for later removal
as rmtblkno2. The rmtblkno is used in the case of needing to alloc
more blocks if not enough were available.  However, in the case
that neither rmtblkno or rmtblkno2 are set, we can return as soon
as xfs_attr_node_addname completes, rather than rolling the transaction
with an -EAGAIN return.  This extra loop does not hurt anything right
now, but it will be a problem later when we get into log items because
we end up with an empty log transaction.  So, add a simple check to
cut out the unneeded iteration.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8f6f175..84b88f9 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -409,6 +409,13 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			/*
+			 * If addname was successful, and we dont need to alloc
+			 * or remove anymore blks, we're done.
+			 */
+			if (!args->rmtblkno && !args->rmtblkno2)
+				return 0;
+
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
 		return -EAGAIN;
-- 
2.7.4

