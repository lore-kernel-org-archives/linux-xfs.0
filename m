Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B92C4338F
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Aug 2021 09:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84A1E60F92
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Aug 2021 09:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhHCJxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Aug 2021 05:53:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1152 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234506AbhHCJxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Aug 2021 05:53:47 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1739qNQq010412
        for <linux-xfs@vger.kernel.org>; Tue, 3 Aug 2021 09:53:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=5ES9oSzaQf/aQrXrSliBbhD3oShwcWKrB59tOPGz0Ho=;
 b=Z2pebrAUDBY57zJWReriotPm0y20jDttMwqkRlO52Frdun2Q8pvdKB/pJdvhfY9oD7g3
 XYMogbSXi91yDiXaMfYXeQpEF/NCiCNx8BSWVSqVtP4lkXh+Go5tRDsAVkacg3G2lX2M
 tDTY4jBh3CG1w7ZzOnWt9Ns2DplV0Fqn4Zn5ph6veR2tof0a97SzyBy/C7RQF3/V/OPd
 G3Bb4KjJ1LAgh8K4gV7CtgeeDlF2Lw/48O/K8HWZBbID3aNq8ht1t/X8OdBLzqA+ypgv
 zxATEd4g2fGgxRbSgoHqi0T73JociNK9lePVn1jRQRD6cV29O2tuQB/LRrts6hdkIiMR 4g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=5ES9oSzaQf/aQrXrSliBbhD3oShwcWKrB59tOPGz0Ho=;
 b=SfzGOd+4Eq/lIjlwkZlBMkYgDCUQkU6lj4k5KEl8lWS/UgSBO/6o4u4YmF6SvQdcyOin
 n8yR7nlR9wfVDtF4LIXA9CgrGoI8VTqqLJvuAweQVQCZ9yiYlB8IJbjjaRdV8CjROyOA
 tZL//Uo9w0n9fFqutkRK+lYdhr/Sj4lcHzU6CLxzROfrzHcvqszP8uBH7NJ6WXjajeQZ
 A8PIZNONUOW6pB40Oj4puvRJ8pal7yyoxUi4sZCzAOBTVK6WCRovoEXFSkmkfvQDcaie
 skO14w/1fdKUXb3KZWauAiSnasikkJz7Le9N5C/YrdzXGDd7DRo7YDxqQlQ48PxFnC5V QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6gqdanes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Aug 2021 09:53:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1739o4br178830
        for <linux-xfs@vger.kernel.org>; Tue, 3 Aug 2021 09:53:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3030.oracle.com with ESMTP id 3a4vjdknxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Aug 2021 09:53:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8puCAuFxnEofixUlmuVkIwbEmSMQwuv1hymWtGvbnKEAtz1mQR3hMVBP0CDQFEpymM23wisAmXnRcKPxnvb43lPjgbezG0ViOKo0hPY61YMeagi9rKffmjNpLiK0J69eRHZfmXxpxF5rZgXRvlj3RojgDjU8pX+31CuXIFx+HHs7bR7L8lXszFQMiwQlN7Z87pwwA08tP6IZ3iR7HF29yv/d3x2DMyH2YljDvCQpwqfbKD0FEzYfkRwgqPJoxpYgOtVLpoLo9KS3GJ0odz6Aw03swVc7Uq8xbdasHxgA2/I8etr233lEhTPgW0P45vA9eFneAk/E4854DowlpN6nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ES9oSzaQf/aQrXrSliBbhD3oShwcWKrB59tOPGz0Ho=;
 b=jayVBoCuS+R7rtFLntpOWh9x0GCEfNbW8keMOZvwLw8hIqZ4MV8dURRmAfGfPQ1z+LIeXIXBel4j77VOFr30mAAbk8lvQI55So7DD1ehiSnOA/tvmQw5ZpMv7Wiwik1QYk6svGy9MXCDNjwL5+Mw1T9lzqAy9q+lMmKdjY8xbBl00NVGuq9Pizs4WZwUYul9iC08QOshS5ElAhwuMsA4luDkzeyx2vJhCqnjQ6uomxBSYDYnla4K9iNC3VencgK8GS/g45y37UdxLl76DMAZ1pwbqXxoY8RwU4hGN+SsXyf7251G+rmhJTwOTCCY8V9mG36CgtAdUyA49Naqs6xSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ES9oSzaQf/aQrXrSliBbhD3oShwcWKrB59tOPGz0Ho=;
 b=orxdnsAniWOMiv3DOlYhFiU8pgtbklNHo5jUHtHygg/QUiY7GW88DcEuEfJVZlHzXKEGqTyNGFLEUJtE35EE4CYJh5Xwtcw8DaZUsGAh/Movr4ZYLY5W5XGY/Eusc9z8eDD4R1I3dag5OgXl0PUf9vh7icPbWP+FbcINfj+vefo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4305.namprd10.prod.outlook.com (2603:10b6:a03:20e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 09:53:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4394.015; Tue, 3 Aug 2021
 09:53:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: Delayed Attributes (1-7)
Date:   Tue,  3 Aug 2021 02:53:24 -0700
Message-Id: <20210803095324.553403-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR03CA0045.namprd03.prod.outlook.com (2603:10b6:a03:33e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Tue, 3 Aug 2021 09:53:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43aa556d-ad96-4644-56db-08d956648e51
X-MS-TrafficTypeDiagnostic: BY5PR10MB4305:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4305CB819E83CB463A23711C95F09@BY5PR10MB4305.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+daGC4QdEThuHfUlwnpcUbjarBemKNLGCxrWbgtu0cMcttwinGHSE/Oiee+ajVfgjW4gyU/xhjhw3iyPwEaoDhqzCIVRXPVt6XPhaxwtgxJ57ffg/4cDj2+wCgAn1HRBoY/mq7fo7CNC6sc0qXfnZGRbcgcJQskIIxBrDCzYcm6s4HFhHv3Yb/HKIVVSC/wyxnLQez53d6+C7KfNkqB/Tb75jTf8JjxeJFUTwzQ2UYIHqlfpLdiSn0esSOV6IpExko0Dh2OEpPx40cz4Fahp4R6WhBfGts67hBMEJe7xOCcZuSYR/5v5oZfK9f+lV+7D/vv8Zwo9yKt8J2RT1759ih+vPKbfGPXcWN10LVj9CF/oygbWVMSu6qOd3weheYPIbx4pQ7RwD6Ef+PdIQfJgzCn0s+1laqYm3Pf+0IF41exIE+AdlF3XRdAhln6V/62JdpWK1NTfJq4B9b03eVSy7t48TFLs9vwTEDQh4Qo48mIw+IItggGXVhBik4wvupTzludvju+TThqBMln0RAC/k4vhnzgEm664XP5msy5/Z2MG2TAwqem/tz+cXJw+Wxqs1gfIRUZUXuvqfGf3qAF7gpwKqcqOZ6m+o1CrwMxxmBFzDDQh5Bm5sTZc5NlRyPy/W3VIbILeayLn50NYCvmyYR3gm6w1hi3a/Pjk4snN9AhfQFEL2+tSrGx0+wkf0FWfGbW12Uf4NmX9PbVHNOVffJxkM4HQewimye8xXMXWy/ipgS3/S8+4dn/tdbLCjfZl4v6arCjCKXu3O2Ae+2P1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(478600001)(6486002)(83380400001)(966005)(44832011)(1076003)(52116002)(2906002)(66556008)(5660300002)(66476007)(8936002)(66946007)(8676002)(6916009)(2616005)(956004)(6666004)(6506007)(186003)(36756003)(26005)(38100700002)(38350700002)(86362001)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AfMu7st9TDeavHwhNHXllsZoRVLaB8+80iF5YTpG6G17SmiyXyi/TAoqh5Fr?=
 =?us-ascii?Q?ljjbE8u2chgG+jSaIjec/YkJ7E/EISndl4BwhBC5AsN0rl8p6biC0+/OTxqc?=
 =?us-ascii?Q?8SINb6D8ldYZjviNP6+3frykNGUCHHS1AzbMxSIL2c+Uv4C/7s3rYZfRjw94?=
 =?us-ascii?Q?G/nYFPXUN+XYLKGhHP7R+9VpVkZwvvsAXYPjSK9DN0a3yW4F2sE7Tv4bkJn4?=
 =?us-ascii?Q?wAePUWboKSIf8OpHTU4Km8ECCSaINmPfoiZ5eciUJJishZQk5HFBu+N7bZ0J?=
 =?us-ascii?Q?RhNSvNFOjWGg4DnmHnoa+Hsq7lKl/ROd7ED/dQkez3dS697K+GHq2l6kQ9K6?=
 =?us-ascii?Q?D68yRwkwmD+hEAgZGvmxkOqzf/aadX1p2QA+1j+z8aPQNUOk04h/+H6ZIETQ?=
 =?us-ascii?Q?DMxhsenjhW/Z4NZjdwa/nrr4BRADWJjfxc4al9ao3Gmo1Y27ifA0UpoEv5nj?=
 =?us-ascii?Q?qNJnp9ie1Akhl4XbOvwrhKYu3zLn95NiSpD+oe339jcHJ0VQOHwXSnuwna36?=
 =?us-ascii?Q?5q01xS2CLyn0cy1ibkIAXvopoMOQrNnpp2NJ3PWvjQDaQXSZ5UTF+qG+xzBY?=
 =?us-ascii?Q?G4IgXJp3WifD0E+BEZa4heWkvU9Z3KQRyNGf7o+Fc/s/w72cznB2+/kbCCpg?=
 =?us-ascii?Q?IeyJCpdpKOXSZ/9ddRu3jKcwMXPAYleQ9tLsZZMlTScX0YHBK7A84YXCA4Wq?=
 =?us-ascii?Q?+Ybe0ywCH1lKvZex7xrPE9GUbeaFSpQI98ICp3A6Iah0V2Ex8Co0wZclIGur?=
 =?us-ascii?Q?9esrXj8tYWdy78hXXWVcvmFBlK/V9u/6myznmseJCUQ3AGU2+9Y7LmUZsRMM?=
 =?us-ascii?Q?MKxm8XAtSSQ2VjcxXI21YgrEGOaocx8JeVO9egLr7dD48f8RrzT6WcYZqLWD?=
 =?us-ascii?Q?Fc81+4Cs2JkPk0ZuV/m14VlyO7wbP7z+zVehZjvz4cmdCWmO8lVV0Xmdtrkq?=
 =?us-ascii?Q?oRFB/v4hVnjQp821VXshDlsSYnen/EMzmdTEVLT86DoEKOTfjh9odP1BruyF?=
 =?us-ascii?Q?arj0O3aORPTYTfQqQtHGvz1vX66Pos5F0f6Th2+sQy71l78jx6hNxCgkBBLU?=
 =?us-ascii?Q?/QNRvIRVI01BHSKOR0QGfIg/E+zIWkXpOBzHm0w5OZEwP52c71l/ubpIrUHO?=
 =?us-ascii?Q?opdV1Mab0Jy/866TaUWyHr0zZx7+5uv8B/sg1+OnaEIOh/hnkB23OdpsYsQV?=
 =?us-ascii?Q?ZoNzuCu4KWVdrsIgkYVxqDKCfFoAisJzf52yQRwUIBbUoyK6PxeEgZX7H6sN?=
 =?us-ascii?Q?dsJc3JqBNtR613rQrJDBSD9XyrkCVy5KqUs2Z0dFM1Kzw+g4v0dvPfxscl9b?=
 =?us-ascii?Q?46C+l/3kpwjpXK9IfmEHseYP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43aa556d-ad96-4644-56db-08d956648e51
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 09:53:33.7325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yMnJtm+snosqVJZEsrxP0CzLwSovoGW510Khhy0aNW4M6lpcyPohTFVO2aYHqpzJtaXy60sGJ/XTP834+AFH9mJs2gyb4X0HGGgAjyJdhak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4305
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10064 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030067
X-Proofpoint-ORIG-GUID: rA1tygUHE6sN5bykwnOBgrtdfhflVtT-
X-Proofpoint-GUID: rA1tygUHE6sN5bykwnOBgrtdfhflVtT-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

I've created a branch and tag for the first 7 patches of the delayed
attribute series. 

Please pull from the tag decsribed below.

Thanks!
Allison


The following changes since commit e73f0f0ee7541171d89f2e2491130c7771ba58d3:

  Linux 5.14-rc1 (2021-07-11 15:07:40 -0700)

are available in the Git repository at:

  https://github.com/allisonhenderson/xfs_work.git tags/xfs_delayed_attrs_v23

for you to fetch changes up to b2bd4f4e45867d3b4e76465bf5d74a54fbd828a3:

  xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans (2021-08-03 00:28:18 -0700)

----------------------------------------------------------------
Delayed Attributes

This set is a subset of a larger series for delayed attributes. This
feature allows attribute operations (set and remove) to be logged and
committed in the same way that other delayed operations do. In this subset
we do some clean ups and refactoring in preparation for the delayed
attribute infastructure.

----------------------------------------------------------------
Allison Henderson (5):
      xfs: refactor xfs_iget calls from log intent recovery
      xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
      xfs: Add state machine tracepoints
      xfs: Rename __xfs_attr_rmtval_remove
      xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans

Darrick J. Wong (2):
      xfs: allow setting and clearing of log incompat feature flags
      xfs: clear log incompat feature bits when the log is idle

 fs/xfs/libxfs/xfs_attr.c        |  44 ++++++++++++++--
 fs/xfs/libxfs/xfs_attr_remote.c |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
 fs/xfs/libxfs/xfs_format.h      |  15 ++++++
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/xfs_bmap_item.c          |  11 +---
 fs/xfs/xfs_log.c                |  63 +++++++++++++++++++++++
 fs/xfs/xfs_log.h                |   3 ++
 fs/xfs/xfs_log_priv.h           |   3 ++
 fs/xfs/xfs_log_recover.c        |  52 ++++++++++++++++++-
 fs/xfs/xfs_mount.c              | 110 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h              |   2 +
 fs/xfs/xfs_trace.h              |  24 +++++++++
 13 files changed, 316 insertions(+), 18 deletions(-)
