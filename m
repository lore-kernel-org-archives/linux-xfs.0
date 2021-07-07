Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D12C07E95
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5108561CD3
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGGWYH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36026 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229717AbhGGWYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:06 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167ML6RO000583
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=DJXuIsOve6/zQITR54tnfKQl77V97kisH/QqE/P/iCM=;
 b=x6nv/Dty/7jdibP6HBOZ8dcI9U91yCbeeP1TmQ76O48QpCAohMPgZWZ+dT9cQ72C7EZv
 ADKGkLY4eRhZp9vAe6i7p019cqi1CI8ZVrMaa/BgBHczXVqM8wRXuo5OhMhjpmDRZ0IN
 /NpS67HcPdtzA4DGiceXd6VVPdS3DuxuX0WnAUSUmyj+VlGqXfvhcOrWWsRK7Neix3/G
 cdzmzPAEdR73yAE4mnmZpCbW42k8fGtq9iMmO40LbucgmX93T+jy/ubQUWTC2o15s0BI
 7oR5pvUOUt/OfZwmV/TkZv7H8lGGG+51C9WSfyaeQX1wq7YlJKZR3+HNUa2f11YPAHAJ sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39n7wrsqkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSZ092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsys2v16RBJPB8+RQgDlbckAt1DniOky9X4cHKZZtmb/Dy8CEVpdFjeGD+AwbALyQDMabaLxg7RW2zwiDrcdJpvaRuneyAU4S7L/yI+CxAm+PvGm2/Z36G1ZNYWsJS+E2enn4ZiXtN7B/ifla1LK7xWB8JgHNGG9mUlTP/k7qXrMQy6G8DVy3btpm+88Vng+T17P9KegfBVPP6PhdWtkUIFwJin9XP58d/BMjSVXW34U75eZX3RKlXRyWkD9pOt2GJykRdV0LHpdyT+XbW1Kinw1SjX6zAoEoLmZuGG/qO9zjHqjBqPiGEnDFxUT2HaL/aWKcKX1H830+sLiUOzvzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJXuIsOve6/zQITR54tnfKQl77V97kisH/QqE/P/iCM=;
 b=ZX+iXGuDXKMIzBq3+d80SeuTkAIpc0e3qpetiTDHbNcdgccEE0OIN6HXUZYy7CjBXrNGngkUF9QE5PxcU5vrgY38usj46Z/U2fgwAvTf+6pUWLre3PugB6ErCViikilTfUZomMChStfadkIVrcjA2NZW+Jw6+vcra0wZ8U/ks3IEZcx0lrxRcIhvOIwx5C8j9zPkqydN6/VzGqKEa74Q0PnNGSDIT/9gKeqYRbVE+vxWboqffK3JR0bnIswXIVaIXGP6rQe/BA4kGZbZth6RSv0yd8ILPMllntWS1Kx4x9ZA8Gz2qfrMRIeeg+XXGYarJUm5dUcRiLEq8nhhsVcPKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJXuIsOve6/zQITR54tnfKQl77V97kisH/QqE/P/iCM=;
 b=CuNAIAk6rNCc/g+FToWpXm6MgHgH4WswvlwryoIPvMLK0bYf2N8fMB2KeAE/sgT7EHjn8NUJt5kdcfCw0yGrLhxc4sgb49/XnBgUCh8xPDiFOSaUVU7NqyaYvqcSqPqrSQKrlAC7a9/r1fvpcK50/wWm7uVdYDTqykdyCd5y89o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 00/13] Delayed Attributes
Date:   Wed,  7 Jul 2021 15:20:58 -0700
Message-Id: <20210707222111.16339-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56bc6f82-ad32-49b7-76be-08d941958cda
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2760854F04BB90FC8E2ECC72951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/xXmoMcjG/OnkMTAyBz95XNRU9qaVR/hje06gqXfhiMEf9CvEy4z8sW1Rq0zKvbwIHI0YaJu07nefod8s45n5hrzwAKKm0PFBg3tAUGN51oUpClUp7FehFaLilCmGbtyHhcQaynGhvDiiLq77lYMegonC7Hb5xGK1M0mQA5/GKxy2D/Bms2gZ4dA+55djeh7mJDbsc0n44Lzlq2puVdUa8nR7zLZPU9v0yd/aJm4FLDN8sANJxwqJEE4u8n0gJebliHmvbfde+xbDUg9ews1+lOq/22fnCgk+jic2qgOwwFtyL/JTAXJeA0hiQObwHhUSdbiEl8e5w8F2kCFzrtlwEpYLYDuXrwoBKAGIj7pJpjlUJE+Hecd+e2ZNa7TdUPV1WdZ9jnLKx9CFtPhuzfktRj/tpCdVmcWRarIQkNW13/0ENbId4SOI9bqUftT36xmrVSh/sGWDdVBhO+x1oSkfm3kFY5uQDWLwFVv0eHAcoimhQO0B5VjibwoQFnPTvQqsJ64Fq9ZRwu6756LzPtQP1bnnB6hlgyP2JMf9UdD5EsXGdRXD93jcsUrikXOm/52jCAQdQtoO3EIn3Rrl8urSVBO5IyrILrJH5BhHa634QML/GCrJLAhMegh2ldu2Bi5xblP6gIbxYa7GjxHqz5kr/3tZPAEd9HBspvKm6p30AgkAnBpmhTMXBdBwocJQUCtwLegpHoocU3j3YGGV/uHA93TDusAQMUdL67FLKiPnjLHEpmuQBRsiUkNJpOtdUHWjhTfGP6VF4iqKorrqSCtl8PiQ+Z7bfaJMS344rGGDHVy/IsPP73eeuIeLyGIj2E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(966005)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q/coiuOjrQyhV+yumNmN9s2QhiEmTIdrKHJr0CSYeRkyYi675qRet/YwoeBD?=
 =?us-ascii?Q?SwfkwuwsRu6UjUFWtCu0G3mOqYXjyZRHmc6Y6EHYzukLijnKlx1QrOYc/6a/?=
 =?us-ascii?Q?uusRpXlxbg2va1AfjzRbgkodKTQK2hkQmpABDfpdb1fjaFMIP2Kv3uFBIeZE?=
 =?us-ascii?Q?tkQ8fTD90MTWjC/H1gvrPPVlSdNYHRnm+N+hV8VLwRlNP1RbS2zdx8OXwBPG?=
 =?us-ascii?Q?s+hxE1/mHxQmsiWKHfCNg9yEdb1fHaQYvIczOKBJ62ImPXc3wKPFDAZiiKY2?=
 =?us-ascii?Q?re5bJlsSneeizXoxUTXQ3L2TWexcjDYv4X1U35QoGfkU9HniZZnZ+WyNAlPe?=
 =?us-ascii?Q?3tIf7S11gS2DSflomSXOqScyvAM/a/AM8jkIZPBVGRkzQ6W8esBHp0MSNMJf?=
 =?us-ascii?Q?x8W8mIt59dXEHtAN8EHIcgqfhv4wdNtGb5saBEFy0d4K0wwukU5NFB1FapJ4?=
 =?us-ascii?Q?vIrK/J9zrkBLxx+SC1TxiGUI/O0pPQUDF0y4tZBUDr9J8r5E491UdScB22H8?=
 =?us-ascii?Q?QIFxd4+/8RW5c1BcXzxFNs8eXojkGL/rJamrlfi+6f1hdWE71A9LJ9igsb0P?=
 =?us-ascii?Q?Jq6PyFNVqneP0nHPvEzpCg5aQ6aEZvJKIf3KxkKOLKgszCF2nWCH88AKYa//?=
 =?us-ascii?Q?z6bHpw6pR8PRdvRwat4onNWFCBsSfybG7voAQWIJeA7o8RhH4rt2CmJD9Zht?=
 =?us-ascii?Q?F1mUshS6alHG8wPNxpqB4+xROgM0enr6MeLDSTlX+aoKkhwH1Z0GLM+YRMpb?=
 =?us-ascii?Q?xy9x5fZusnHYC2VXRYPytJIlCEdbiEj/xe1YDHm05gGokfMFTkZMY7SS5/H5?=
 =?us-ascii?Q?mb8LonOeEGMqfY51dLuW1NzqCM7z5PCqB82n6P1a7Qe++GzvEpJiZYrHY75N?=
 =?us-ascii?Q?OJyAWTDBx158yFZW6TtGhrGm1kzh53Dg55HWtHG8wZBVUP/1K30+ewkCxIkm?=
 =?us-ascii?Q?9zyBr+RdkvPM4evdSU0OtloVLJlnOaIYn6l6Lht7+jac8tz/iF/l71DHg8jj?=
 =?us-ascii?Q?qKpyGCTSJ+81c6ZlUw+LcYL61pQ0yNMnUJhy36Xlwr1uEb1K9MBD+zvZMzcG?=
 =?us-ascii?Q?tjuytiXlE/5DyHXdFLhO3bXImtq7dCmryPehX+sI0/5vN34lChtDWLu7uHyd?=
 =?us-ascii?Q?lAmrNTJ7b7jNmcnScawJuU6sc4LIbM2KWXgfnWpvClTEJ6fyBgpzhEX2MZiz?=
 =?us-ascii?Q?0o1hZYPIla6lNYSlL+LvYr7rvyaavZiWX4PTZ5iqH6KrH3HHgRv1ginaQyR7?=
 =?us-ascii?Q?VvmetmCkjiHkUHk6M+1HJyezmA7HLAoff+4npwu9MaoUTRM6Uq003TQOzPnN?=
 =?us-ascii?Q?ZvjmcY5O1A26IsgUWszQM/A5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56bc6f82-ad32-49b7-76be-08d941958cda
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:22.2967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4APJ0GspgbOT8DaBbYNWSXC2gGILcF8HLMLzYe/9y5R79CmZI73ya7XtHobQz84g29qkbMAAJoPGCdy3Tv6zab1Na4GOeaiD69D3rnhbVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-ORIG-GUID: rpNHmjzwOnCoSSUIwKB3vy2gVTBjJd5G
X-Proofpoint-GUID: rpNHmjzwOnCoSSUIwKB3vy2gVTBjJd5G
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series parent pointers. Delayed attributes allow
attribute operations (set and remove) to be logged and committed in the same
way that other delayed operations do. This allows more complex operations (like
parent pointers) to be broken up into multiple smaller transactions. To do
this, the existing attr operations must be modified to operate as a delayed
operation.  This means that they cannot roll, commit, or finish transactions.
Instead, they return -EAGAIN to allow the calling function to handle the
transaction.  In this series, we focus on only the delayed attribute portion.
We will introduce parent pointers in a later set.

The set as a whole is a bit much to digest at once, so I usually send out the
smaller sub series to reduce reviewer burn out.  But the entire extended series
is visible through the included github links.

Updates since v20: Since this series is introducing a new log item, we need to
be setting the incompat flag for older kernels that cannot parse these new
items.  I have added two patches from Darricks dev tree that handle setting and
clearing incompat flags, and a new XFS_SB_FEAT_INCOMPAT_LOG_DELATTR flag is
added and set in patch 6.


This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v21

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v21_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv3
In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v21
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v21_extended

To run the xfs attributes tests run:
check -g attr

To run as delayed attributes run:
export MOUNT_OPTIONS="-o delattr"
check -g attr

To run parent pointer tests:
check -g parent

I've also made the corresponding updates to the user space side as well, and ported anything
they need to seat correctly.

Questions, comment and feedback appreciated! 

Allison

Allison Collins (1):
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred

Allison Henderson (12):
  xfs: Return from xfs_attr_set_iter if there are no more rmtblks to
    process
  xfs: Add state machine tracepoints
  xfs: Rename __xfs_attr_rmtval_remove
  xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
  xfs: Set up infrastructure for deferred attribute operations
  xfs: Implement attr logging and replay
  RFC xfs: Skip flip flags for delayed attrs
  xfs: Remove unused xfs_attr_*_args
  xfs: Add delayed attributes error tag
  xfs: Add delattr mount option
  xfs: Merge xfs_delattr_context into xfs_attr_item
  xfs: Add helper function xfs_attr_leaf_addname

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 422 ++++++++++----------
 fs/xfs/libxfs/xfs_attr.h        |  57 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  38 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/libxfs/xfs_defer.c       |   1 +
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_format.h      |   4 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |   2 +
 fs/xfs/xfs_attr_item.c          | 856 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  52 +++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_ioctl.c              |   2 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log_recover.c        |  12 +-
 fs/xfs/xfs_mount.h              |   1 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_super.c              |   6 +-
 fs/xfs/xfs_trace.h              |  25 ++
 fs/xfs/xfs_xattr.c              |   3 +
 27 files changed, 1309 insertions(+), 247 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.7.4

