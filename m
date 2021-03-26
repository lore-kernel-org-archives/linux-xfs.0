Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA6CC433E4
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E89061A38
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCZAdg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:33:36 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39310 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCZAdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:33:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0P7Wc066486
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RqfGCr4FVABa59oylu389p+knF70YwRUQcBgnKN1qng=;
 b=g/CPLtmpaUd6kEL/M1TuhPEFBYgCzmbV9SGRR91rmGaXGrSV+rxTEJe4yfkVtE1e+/9l
 TbW8d9WylDbxo6+PwU8STYMr/cDrYbH55rXykHehSJLqL16HuODwmo1ceqkYvQEx012G
 U2Ecp9GIO8Zad32bgl8jedCLu8BoNK9HAZWDaEX5yeP3eGUKgctmdVF7kpRUFmfR+N/1
 1dkr99QCaEP+gDk871K+xnXAorySsmTGmuHSuuTFkz+RUEy4nfybnwyUXNAWYr3PK230
 BroLDFiMRx7WzwQDF6HtXeroFyfZCq3URAkeSPb5/6UQdOTQy3gTKkV+Dy7rrYGM15Bn vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37h13hrh7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OlNL009463
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 37h14mfud0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:33:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gx7fb7nmjtUj7ZpoL9LH89GeWcTs1xGU6UT8eyn8dnoDsLpufA9nBqIOL1PLQ0ckC0vgrSqhTGnHVPrupObhveHtvh4nmsBouCKrQ/axiftnzQ/pjpLH+SLnTO4GNr/OOwguXniYbCERPCiGMkatpuKM5SsErUk/b/48Gefz9zZ/JvRZeQ0TcX9E0RpBhJcYUGGilphds0A4BF1AGXDoeucqcMmoeWpdB1VWJByxMfc3h+XgBf/wF4AK9aCexwLsj6c3jBP4tLY/xJe+g2evBakCx6/6of3lcYc67SW1g2GKcphV2jruWEvOYQNIoKNB+pZLsB9+/kqScZ4uSVSavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqfGCr4FVABa59oylu389p+knF70YwRUQcBgnKN1qng=;
 b=XQQdk5v/QTCFsgdEzMk8F1lln9ZmU6QTkEon8IaC4GvWW7MTMFhq6HntelzX072Gub14d4XMNFKEWUG+JKr6tnNHZqfBp2FOv3Rs8IgFRh0nhmneyQUnISvrqp7wWe02cGR8PX0lkr9HzrV24vdebFFCDcTPvGKabbgqaJHfdZaZbYrrwXPDPqlT5afsQ+sKcqFdPYQi5+EUowBsuIguUa8PorHQIejFPqHw5Q6wPUhx0Wlkhpkt3oRydaTPVJHs4qdoNB9hENb+DZ9d7Ci3yztQr8KfE6GbP5w3ckXzr7zb5J4/Pw/qJYGOM+ffiFTDV76vqDO9Ex2WWkFomYgYWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqfGCr4FVABa59oylu389p+knF70YwRUQcBgnKN1qng=;
 b=GwmNRmQi22o1QDvrqxZ03LJNUy+dCOtfoKOSnVmL1w5liNco6IW7cMLTv/EcC2IleaNJLqIJriLkmSnDbgYYE1BE3d7DHpnftnM47SCUhSY61K19PZ8QX54YhNTWENgh2b+GYEIOSFhbwamuMlDfb+pdWvFl2xXJCBdVcaOmO0M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 26 Mar
 2021 00:33:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:33:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 05/11] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Thu, 25 Mar 2021 17:33:02 -0700
Message-Id: <20210326003308.32753-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003308.32753-1-allison.henderson@oracle.com>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:33:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f77c4964-c474-4cde-10e6-08d8efeec205
X-MS-TrafficTypeDiagnostic: BY5PR10MB4162:
X-Microsoft-Antispam-PRVS: <BY5PR10MB41623B124A336E5E8224437595619@BY5PR10MB4162.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PAWODnroDNqDvzIvdxYReBwnMKPxFbfnBHjc5XsWVH63d0imDzl/8r0ekhXjacxhi00XPC98rerV18508mMiVnWhoUyz3mNwwsIPNZrkN0QlDYfp9IS7QpkxGK4Fq42O8rST/Xy+ea0EpxMAPjxXWYEb8ZzR1fUG2YFmX0oT8W4KX4R9LO9u61slFKlAYKk4eCKXwSO47vutvD+YP37Lzh2KChcsKdLdHbyOOT0WhcgXIvpuHvB8JmPHSNPyZDekMJ2hEo6XJS+pvO+Pdq/NCLQMlOPHGFy3wVNqT3F/5wqB8bDoXn5v0qpQKqQ8TamV/QH2Jeao7SIU2c/AdmypHtgqP65MC7v15UwsrvDak6GBcMxiYkucnLs28JiLXqvZyPNfXNkWv7WTRsCIxEQApeCcCGMoxsF7cj1WeOtr2vkYoA1VgW6S5pGIevd67OSS3A3rgZBRG08kNKpR6iLcGnf5Ts4PUW8Zhn+uDt3LDvW1rJ6LSai6t+ygr2r+oC3Ka7qayv8RO90kYQkhjuAWgCmaamhoHp+kZxZ1fQ89KLNPMcFOxP9yK4sPB6BtwX7f7/vgUDyFd09MVqinbyLUfI7zotArIiIsymRY/VHHj6CGic1maRCHyasaGtR4IM1ehNRVMhRNZNcJAvIwpiwMwTm4/C9Va5YTmAwUSG0/PfQNuseUphe+t8UOy2zLSRH+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(16526019)(186003)(44832011)(478600001)(6512007)(316002)(86362001)(6916009)(26005)(956004)(2616005)(36756003)(66476007)(6506007)(52116002)(5660300002)(8936002)(69590400012)(6486002)(2906002)(8676002)(66556008)(6666004)(1076003)(38100700001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0RLgekKX3rg48wHu6S8u/maEynQnIn3Upda00wvv7wi6apTpBm/XEejsLIkF?=
 =?us-ascii?Q?N66VJXXevnVCiUF1xc9AODADwb9g3NIeh0Y81PCORMuW+kmzYyiNB2yX2vi/?=
 =?us-ascii?Q?kf0inxX0i4VuJqexJbiCAW9IUlCi1LK0zG069OGmW+6mYEND7PC2NwNwgGaf?=
 =?us-ascii?Q?u4k1GiqYxD2CFGst7IOmZm4qLz1nEn8ANbgYeryrz4ayuU71ktZo6YR3D9fe?=
 =?us-ascii?Q?phnRv7eJakWIbeVC6oRGoIoXdMtTzq6Voucnw+stpxryhjkwmygNYsQxyQvl?=
 =?us-ascii?Q?mhYOimKWZPFRBo8Rh18X/Fvp8Fw+Iketx0rSHenXuE6lVXW2KR/aFY61+Oh0?=
 =?us-ascii?Q?TGA+DHj7cc5qzFeEydzIyGACizBlRK5OErblAxF89XLErpB4EFiouR6XQw4B?=
 =?us-ascii?Q?ikgtNC3vht9WnUDZUoBSsYbNJ/PUUQTBO1AHwWoClouHbdXN5rRoFrw5xIE7?=
 =?us-ascii?Q?EobW91l/7THV0zzPl1GOVX7viP9rsabEFDEV+jTQCDGMxnjT8mjv1qkQM3m0?=
 =?us-ascii?Q?d6b0aG+zrstxAfMu0rLq5Lj9QVfKhq5HNE8zBo6NlSqAScP06KWr+A0ijkxL?=
 =?us-ascii?Q?2JnCEmIwX1kt8nwllymz4Zq3FBEtoGzSw+giBJtM0BfYDR01PFZHvezXbG8H?=
 =?us-ascii?Q?sZF2gnoYAPWvbQ5A0L1Vsoqg3JZsmm4j6Jw28BDMYA5BY0G13EBDfxktLgaW?=
 =?us-ascii?Q?7g6yHwZyZ+S0dVYG2MkXvDEplbiHBj8pRDi06QMVQee6MlrddT/QkPoy7Lw3?=
 =?us-ascii?Q?cHeX8DVQmPNE41ihfYZ43DhrT7l64VlZpTvc+9ci96WmCtrOxGkJMH5VItz2?=
 =?us-ascii?Q?lsTnwyljZc+RJGFcqsueV5rmJz3Uhr5vV+XNaAnH2fFrPlnELdTPGBllkxx6?=
 =?us-ascii?Q?opwrAIbcpEgZFsc9Qcg+u4HUnkuxsEP4uWZVo4RkHw5KjtuRrEG2IGVm13X2?=
 =?us-ascii?Q?h0CWCrc7x++5DV1HtsuSsRsvqkQXXgXu6ox3Sj6qQd8uUCLPITPwpCdPvcn+?=
 =?us-ascii?Q?m1VZtaSmSRGZls3COW0OBpoPQwGPjQJ7eUSgfjfUY6Qhbo+MgXNtYHwrGZv7?=
 =?us-ascii?Q?6tW0r2KtFgkvY/Ed3SuqsnNKnMO8vR4CHVy36z7QGzesDS6zVcVWZ9y+svlU?=
 =?us-ascii?Q?MFPtEQncdf0H7qucLgi+3Uvb0tMjGlAk3vQAiVRjOUY1KVFuXpDkEnGBPVQp?=
 =?us-ascii?Q?85G9yuMSjexR+diKidvTVCy3xjOMnSA2u+9EjlisEJFeeXyxm3wuDLJ9vZk5?=
 =?us-ascii?Q?eSsI15Q5GVR/pswhNiI9tHfsTsCo0okA2jKPkpzPGcD0jjEqLgjQ32yL/DAC?=
 =?us-ascii?Q?LNWRxeSlOZ7yjcvVkIyy/+HB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77c4964-c474-4cde-10e6-08d8efeec205
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:33:21.0695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tf/TwS1L4K+V/GsIuhGzysbzzs5iYuyGQy9rYD6lUfszfKKTmoxT/RJSexYTrJmAR78192/T64UX9pJxIR/zXtmQJPY92rIOo8cHroVdDdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-GUID: rNeuUWh-GhQ1ooFtKTYGTAPS_oogzvY-
X-Proofpoint-ORIG-GUID: rNeuUWh-GhQ1ooFtKTYGTAPS_oogzvY-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d46324a..531ff56 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1061,6 +1062,25 @@ xfs_attr_node_addname(
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC
+int xfs_attr_node_addname_clear_incomplete(
+	struct xfs_da_args		*args)
+{
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
+
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
-- 
2.7.4

