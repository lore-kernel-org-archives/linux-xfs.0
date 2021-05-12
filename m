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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B881C43611
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C57DC613CF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbhELRGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239717AbhELQPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGARNA005181
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KCetmiGa5dHnWGsOUmK2gGVSX5hK6fcSyKsnfgmTFJU=;
 b=F2jTapP7cpk+FwDcz/zQoYR/BYfSGe8QCi8t2PII+ACTsJJTIE/m5PTvwpQvTZ7f8tvg
 ZIKx+Awv7pWgspU0NwMfYsTMHI1sry3LTiXn3KMEhfvhx/dhzaabCudBKW2jaQbdiu6o
 taiCZXdjLYSTruxYHihI+Cots0Av70XLVi3c5wO9AFb2ZiK2nbocsEzSt9sjAILkCMbH
 R7etchkfh0z5YZrco2bGNM9sDUwYr3hF/dAoB61qkrC/99qZO86xzUaNHRzQobxmns2X
 rzURJaNee4hh3C1vIM3fBuXgg07dQijL9d5kOzmfTow1bQEJ8TAH1rFF77YRSmPQdD3k 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmjjn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9swo194902
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3030.oracle.com with ESMTP id 38e5q026eb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B09UUsR41iXIPHM0UuQ/haky8uWwXBOwiEnXuERzJjaKwTx+P+cosVBw4fcd4y/lH0mreLmueOmMcLyuJ1CLgwcJ3C/LP6gSYv8pirgrghH5c81vgnaQ6FpGvj+3S/l9SmIYmnUJq0q4dmiIoOMvcNsqkaEa2RJW6Drg2UKM1OiCfXafG7LwZBRBHwe0aAUSazHK/2o0wYqG/npEkZEfXFTl/e3E8a7yM/KKsNQ4jBK8j8ccRIYf1HujPQ/h+hrOTHWAzW7KhbehnbMDI+TkGv9qBSOFF4VJbBRgn+B9f9+Z8pj1t8QBqX5/+U2M2AW516lFyWwNogTTREXJzSQq+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCetmiGa5dHnWGsOUmK2gGVSX5hK6fcSyKsnfgmTFJU=;
 b=P4PN/M17WwzpDtyExJui5bg40zFNmpnvW9vgI1flLvyyMxKZmcl5Q+sLmv52uDjzUMfil0DrIBtBXtloDbDgYCzrRGdt5WKm8Go9tp7+XeuTeUrDAS1W/16mrnDUnmQcWULEmjH7KHUpWBxna2hPXbSVWIYLbnWGNo0+VzLAR425SY3KMXNYy7XMnfTrqWotWnPcTa3HtItfrTavQm988VJG7dH7XNTdaMJZbz4PoApdh4xh21H5j//9PqJ6fEzLBTauyALYaYsG0ebtqvs6VjF9BsGPVanZ7RCrHQHZvf9+sJweMigX6C3gqdpDCJv9Uym8TDtrz40ZP3srFLLoKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCetmiGa5dHnWGsOUmK2gGVSX5hK6fcSyKsnfgmTFJU=;
 b=lh6eb01s87MJduWC97fnFxehaTi08ByLZKtWPXu0s/Nj3yAlMDn6DSMAWy8cGXrL9utb4ORKn7i+s5xyhXDK+bQnryyRUIoM/JmSNAhEJVKdd77/Xvfdc4EPoGmtB0+x6Q4C1DqfDhx4/caw17RxSY7ODub11TvHMFDQhicB5P4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 05/11] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Wed, 12 May 2021 09:14:02 -0700
Message-Id: <20210512161408.5516-6-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74261f36-a059-460e-b697-08d9156101f6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB311255D46F93CDBE7FCAA25095529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8otDWe8qH3qZquq0BLcU3rIOkrgCyhQsycxk/U1uB4AMlwquFwb2QuoMBB0VSRFLPUWw9irrNN7zjhx3cN4zaUL/cUI/8IIILcZQoORUA5k5vu7o95FVWVE05BUptrP24YHBuBHK+PY5K14zDP2IL6x510UHjZZEfz2KuJgxdqEX4OBVAhfYOc+IzjtluGIHcJ1O+zswG7YiuQCpCPZ4LUIce7zLz5em+nUEld90rUZlPVg9/5uEUqmDphIRBY+81sIwy309DgdVCsdcM2neZLpq3EV2g6FuvRfNPJO6reV6smRQyS89obaiBhBiMO8ZDhinb42FQ4bb82RtEivUCbHqiCDat0J9EE3bEk0C9pqiEsYnL53SVcg1Vg6V6Zmlp00+XeYMqzBNQcN4FReexyKDjrDEYmxxY+pp+fdoEdZOKmPET8w1triePD61h6FdDJ/nqf2LG/JuYveZRajagY1qDz/24MmX+he3UVnGf0+n02X9WhstW6Y1Mgz6i+zSuh7Vrvmtci/oCo9RgzCzaXHQcpASCFTVdSIexW38WqUkBTbMc46ZHCB/VCR2eQaE+dViylBOrub2YLN3UIkNHLjQNtau+o26PnGbkaQ/WDttNJf2yzWfx4hH3qKpMD2DJw9UeHUu4GDGhnlr3G84QE2ilFcnz3/MRTsbHN+9ASBSYNhT/KIzus76xHzwB8yL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2oIBgylEH1znjpjcLlrVWaxufB+9bc3YsD4c1N+YGuDEqoeULVGnTeiwg3yl?=
 =?us-ascii?Q?MDZj2OzYTKcsR8rMj2gGd9JBIDc9Z379mOOS9bbckmhcB+jXagezXUSvW6Ab?=
 =?us-ascii?Q?yCUXrgmvncg+BvufIAmc+aK0r/gegjOz8s+/vRNVrSleZdCa5zCRjxGC/iv5?=
 =?us-ascii?Q?syiabPuLe6MUQl9EjGnjM51v60SW1pC6AOd4UDme6oKNcIWmFhO+AAn8NdxA?=
 =?us-ascii?Q?HYEgw4Mg5r6OTdWoSSMttF8J3cpDIP8KP8yX/yXb6LE4aNpXm/C3l9h+737l?=
 =?us-ascii?Q?v3qcCa1NKjMXK7VKOsh+KMAV74EFuVG1JaZFrlammxqEI+FZPaPn/OKayFSk?=
 =?us-ascii?Q?2yx+GV1rGG0QXjdGCGTWb7qjt1+fURGhUO78o54AiKJUXH2prSvRFfY9ibe3?=
 =?us-ascii?Q?MvGZ7YwJ5FLRULWSS6wArHG2LcM26pZp5cnRMdmW/Khtgvzu18a052ircXEc?=
 =?us-ascii?Q?zgsJuPAzzXRwkaYJ0uUZSvIcxMOZe+WXjxEKO9NCksiGh4o1MNCac4AsHnXj?=
 =?us-ascii?Q?wusIZoxd6fsE5vKvCKeoZOm8xNDCNtOwQLMz9OvdVnjXw96th0CsSiZBylF6?=
 =?us-ascii?Q?2TnCw5nQgEd02xi54dzBP0H2au56tuajWE/tFjFHr6OaDe+SC2iKKquB1RLY?=
 =?us-ascii?Q?kzUhzPCwD0ptNvE7K2KyxBnhRSBZK7Ek2fO0d0w9N3jWwO1PT6qbWiG2Nj6v?=
 =?us-ascii?Q?DECWXjvRj3a+QAgYrvz0eKAaKsN7Dl93794DTj9/0kdHJ6HP80XEVumGYY5Q?=
 =?us-ascii?Q?iLXekgAOhZqyVHFiP9+Hz1CuzRJiaR00hilxARvth3n1cWEaXhLQp9Ov0sOr?=
 =?us-ascii?Q?RUvHLYmwfN7Y6DQ6bs61AHKQkdXl/pt1qo+Qb/3ji7yTESEEZp6PymMSv0k6?=
 =?us-ascii?Q?f1N3pi1bdLGGii+q/VLlEgUGKKiwEWzEVXKSQsNi6qMi05HiDYvV5nJtlfg4?=
 =?us-ascii?Q?4SRHOl/2FfFFxM5qZswNrRJ7krR0OrI4y0+z03Rw5gQ8OEjVyPqcqLk713gz?=
 =?us-ascii?Q?lD6aIdmmOtCOw6GR7kiCSvGA9xZqQpBiq6gqbCkg70ODIc6Ta7AIaMxlCIzB?=
 =?us-ascii?Q?Q06SXsAyf7fL822Itn00f2AQM/MuUWrtMTueL/lIY5XkbeewBzYnhY9ChHdN?=
 =?us-ascii?Q?dwuCcr2e/bkUobyVZlcUw9KsOjdiFHEPe44E8MnRv8Mh0th3zsrIdsYIYc68?=
 =?us-ascii?Q?IVHKMdBrvUXMD+E93kUk+FkXpotcY3vlJQEVNrwJzqgRlBLcMPf0WeromZgV?=
 =?us-ascii?Q?/dHVOJ8lm9yikCk/jQoPKzFAtQiTIeyqh0CZ7MUOPO6e7RpgWq57eKORIeyG?=
 =?us-ascii?Q?8PEAQWTh19HbbVQ7wfupNku0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74261f36-a059-460e-b697-08d9156101f6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:24.1241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4MDc7cD/ZK8mlmmr0FfX4g8DnTCvLpqd/Feph4klUEwWfC0wp9uBtJe/fDTvY2JseXBojc7HkCynD78duGKdepTIJA+PMC/XHp0fuKAwgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
X-Proofpoint-GUID: zfGhKrD0OX8bBMBgMDieYJ7y1KuSvR2l
X-Proofpoint-ORIG-GUID: zfGhKrD0OX8bBMBgMDieYJ7y1KuSvR2l
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1a618a2..5cf2e71 100644
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
@@ -1073,6 +1074,28 @@ xfs_attr_node_addname(
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+	if (error)
+		goto out;
+	retval = 0;
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

