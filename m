Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EA0C43217
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245497AbiBPBhk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243706AbiBPBhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B7219C28
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:24 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMrYpj024654
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4wwFvNrnxCA24XKP+CUAmnz2wB2yjDXD8MdeUdBwiIM=;
 b=e+pTr6YrXDY9Whngd5++lft5YgYDp4bUA68lRNXST3/XTbcbWts3zd5m/WGMB9QNKN/r
 I5ggXmaq5T80QpE/3pBQh2gM4MOeLV2Bh+TXg6sMBm8yIXlK/1QQGLnRGHILDXGzlcBx
 gN6HpXeaWpXO79tEwNhZjX0/unPXowKGasc/oBFBUWG7tbiJaoCdXPg3llkyzWwNPThM
 +XB5bknRSbG55h/2FABjH8fjLIpGZV45DAvfyLJN/+spd7DmC9hUdl55TeZbOEK42nDR
 iQnmNWq6DxwRMXKeZ6uUdLRJIUFAGH1VFAWXbBkfGB/YREdsXLGR4KBkQ3c8/hlmIIUp rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8ncar777-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1VQCY138909
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:22 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by userp3030.oracle.com with ESMTP id 3e8nkxj2rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/HKEmhh3CZdyIxZOCbrggSw22DglFZRxZC0EDYEWSi9Hnp9yHCJ3s2+M6uip2SAZzqiOnw6ocuUwiIti+kne/5mGpt7GLKpClyWsaqCUEOYx4sJ7LdrUcm44Okbp4F6DBMkWdcWpoy/2slqH/oUvsvJJqm/o0o4A0gyzE4C2UNfCq0a6GtU7q+ojLMI9CecEzQq1zG/2ixNxOB/W1AknwKFu3OgtU/jbxV6N0eljvnphYyDXobafNxZ+xCc1azHwgYW4TWyGIIJU9Tfd5NVVDphvRPNj4SDAoUuxvqPpujmKGG0+PgNBtTfWAK+t8AeqJEsNFa/a1hytBy4bKZElg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wwFvNrnxCA24XKP+CUAmnz2wB2yjDXD8MdeUdBwiIM=;
 b=Sai0ridqBavbB81TIL7NqHySWA3Up1WwYoLpneJCATYDK56mbLbwhaezLJHLKFjFheFLWPwBcarHT36qN7mYToSGK3p0KnYqu/9q2MUyvA8qBI7YxQRWgLqfFJtKFzw49ilyHk8lJcofbizGj/1G1AtBob5mDec+p7uX7bvyzf42NXRoogqPz4B5wk2C9Yg97yoCP7T5j9KHPh093LFUKrNkXGbB1juhAAoQg9VI7inWqcvQ2/D7/KbqUageQx5kkcPdh8SlT3DlbEfEFoIDFn4l68kPFlnVF4qw0yZ54W6wTffRwSHNH0KlMNUeAVNnthVoC7RBvFLMJoxDYw/2mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wwFvNrnxCA24XKP+CUAmnz2wB2yjDXD8MdeUdBwiIM=;
 b=sE8y+zJqYf46D48hN3xQi6U2dX79T3Ysg2+O2CWZiXaGG57gb5ctdb6eRcJZPerhFk9OlNWBev7hcb9Mg/UWbE7v11Xn05vg+bA2X/b6WBHhm9LZiShnkg1A65wjozf8dRMThXfFS1RCE7EBUAC91VaYlP70bMNMy+T3lLogsac=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1283.namprd10.prod.outlook.com (2603:10b6:404:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 16 Feb
 2022 01:37:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 00/15] xfs: Log Attribute Replay
Date:   Tue, 15 Feb 2022 18:36:58 -0700
Message-Id: <20220216013713.1191082-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d93585b-960a-49cb-4fe2-08d9f0ecdf4c
X-MS-TrafficTypeDiagnostic: BN6PR10MB1283:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12838C338D503CCE0C0462FD95359@BN6PR10MB1283.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QxGoGsHRd7rXge4VBMlme8iPjBTRnvmSTI+M/9jX7nRcCn07xqjCsS+13GUEzZjEtCkKbyAr1uYDyQ7O1RR+F4XgyQAhcnqZ53QmITMcgHkCKY+fJ/IRsZw5UYAiDtxxrvDM44PpAKqVEXSqVpl/BjXYFa/lQQM6dsgjb+xTlJT4vfnxV3wihSn3ZUmaKbzhuGwO/it7G5ygYOjQcpglPRHq+rMY+6Yxhbd6rjhSkIpFer3gzwK53iXpcnd54OldrkxgdSJSSpvuZr48f90fWAD6M37qE4rSxmjRzmbsj1AdnjR/EbiUPXT7/83KUW7OhvL7jRkvuU8mzy1YKA3h4VOpes9w11XKoUargg1KVEnwE6LMgNDqGtB3J567rI1oyIDtngNjdNV7KppQoU5x8qcwAIedsXEvwvTQEZKWvYY7E//5u+w59bp2HUiRnw9X371P8DKMHr8k5KS5PqbUqHjcNA21rpZrV516an9Ayukm9+Glj0VQaLGsApRro5hbpv1gsaxa60TqsyU4ZH+bflVAcRLt1YO3JLCfXjdkzukLgnXMbO9lwBQJ1lp4XOqs7nW5hrJ46Ak4FqJbgWL/A90wPMUQmk1IUUfXIqLiZUQ/9Rhf1U1zcQGHeyviLGIHvS5qGHH38iDA+qZttTgAzQ1igcJbhFa60IUDWKbdDLcX+M8YLsHdhMguzDgLh9k/3cwMClcHViQFtCxHD6MYGZ0Q3Dw5BkahUh/2prQbmjRzGoTngYnseBPsN5PTt64ThvVwuFyaUbUk6AwcCkkCg6fD5ARs0SSDCiVX2wc9sFHoxGyppb9xzIjgWymQdx/k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(8676002)(6506007)(66476007)(52116002)(83380400001)(86362001)(6666004)(66946007)(66556008)(6512007)(36756003)(38350700002)(38100700002)(2616005)(26005)(508600001)(6916009)(2906002)(5660300002)(316002)(1076003)(186003)(6486002)(966005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLEYCFrfJ7+bUykSSsPcggRfAGotY6YeoA+GbR2agphAiSzLMxBju1X7m9+j?=
 =?us-ascii?Q?xjzZbKcsEZGJBwhVdq43CPKbUBGpDfOfOSRqwV9O81v4iQs/bL8kou38icXp?=
 =?us-ascii?Q?7UFAtTQbBxu1AObYUJVFZA7hBKdT8Qn/a9eAx0rlxWl0xMETwJSag9BuA2mE?=
 =?us-ascii?Q?J4o2KCi3MGG2L1aQ3yEd0wlvtHuL48bth8Muy+c8063bWCgWGgEgrvfnBj26?=
 =?us-ascii?Q?SFnd0bct1D+sKliBsMflc4f5c/641uy3iotp52MJ0O+3q+v/HIwlGX2zZM9s?=
 =?us-ascii?Q?QbripHIiXrW707Y+vpQVxrss2gk6AoCNHkkE+PPwbvBrGm+4u/+rPnZLIVVy?=
 =?us-ascii?Q?AYTRKUExxuaWVqcSkZBx4VCNFM6mKnXt7O1VHKcKn6CZ1y8XHYPOiYGAN3h4?=
 =?us-ascii?Q?ZVTJzFyoG9ZH81asrCduEb4jt5jrXQBd59JuMXEAhgL60rN1mJIscMsYiYAj?=
 =?us-ascii?Q?bheqwY/yNkm5Rvu8c5gaOiLx52at7lf2gaUYncxA1+B5Hh/btaE6Go4WjHLw?=
 =?us-ascii?Q?3vOKwOj4VKa7E0EWyC4x+LOe+UAZ9TFmTzOpevtHhOZrGnB9wgENIHpPTdqU?=
 =?us-ascii?Q?gCznp8zDNqz0oJ6Gb/Ul4vKJ0RQrC028sC+dH4bpKe269TjqVIUkUp78LdnI?=
 =?us-ascii?Q?50JmbfqwwktoqASxM368VT5tnv84qkaATEPzKQM26CLez0/IZK1hbbBDY/9e?=
 =?us-ascii?Q?DkO8GG9fpLk2bprBUNOTOt7y+lFa1qHvN2Q1Gz6U7zmLJCjT5e78+zRWQYwg?=
 =?us-ascii?Q?aXg/TCwooU/+ySD7m+u9u0VAR7VqF1err6p1lzCNNzxVSSoAKikM1/k47y2X?=
 =?us-ascii?Q?TddQ7Gu/lHtHzbOOG4v+6Eq6SrUERI/RRaBQ8xsA+SKqYsWOl6KpusgBPnoN?=
 =?us-ascii?Q?BC80B9+DuPinDwaxD6lUI8HqhJQRmoqdSVbGmK4xG2pKt3RqdkhTmeLjLfUk?=
 =?us-ascii?Q?u6NwZlYJsLB4UmEa9O0/ZSGd/Jr4kHjEyJl89QSB9AiFfXGzPcZ6M2SGAlzh?=
 =?us-ascii?Q?agyFt7cSZZaRYFWxg1J8tL2loLloK27w9XMI4uwVckchT7pT7S4CTmaeQCpf?=
 =?us-ascii?Q?GzaCGPY1Pk5zMMPFB7cT2t7XcCbcuwv6Nk9fUAxWvsQx/OSY8Mwv87LJIiKN?=
 =?us-ascii?Q?EHU270sNg/mr+AwnsCxY0JQHRnfBn/YHw6P0ekRgspMRPwUvyg3pMOSWfQJd?=
 =?us-ascii?Q?kwB9bPP8JDJ4P1dfJoidZyNWh8i+z56oZ2vKFpjyF24KYFClnpVfhUBrg2px?=
 =?us-ascii?Q?5IPSCueVuqFJ1SKiuCNy4J9CCK8ZJ2Y3Y8u2YtKG9vKgQQ07nOYX/HYZkgSv?=
 =?us-ascii?Q?S/uXdLbCUG6TiihO+bqIaztg8u4PRezq6KolwuX7LZ2dInecdf4gl9RnSsAo?=
 =?us-ascii?Q?rs/8RfgA7qEEF+5ohzd9PiG6jTrEsFPTfYmndV3wCZ1ijCNvuxcZXbGcQJbM?=
 =?us-ascii?Q?w6QzxL6hcXH+jQOBKRuuJ19a7E6mc9XvF7AuYmuhs4BTWbig5wNMWdyUibsW?=
 =?us-ascii?Q?Op8oT6zaLK4HMGS90/CXilkMLuz1MrP/JdJTVDQOkiNdPK1l3WKVWVyvoFdD?=
 =?us-ascii?Q?ExOEqX2SD6CeEICJn2Yg04C7k2GfsFFRQY8nLsMUvPV8NDT2sSAOCmk/hx8J?=
 =?us-ascii?Q?/yuOmJLuqlXGJ6ijR9anF4uYPWKU5VJLU5tidWUOLP7hkSIYvIBbyqIrCUb4?=
 =?us-ascii?Q?smky6g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d93585b-960a-49cb-4fe2-08d9f0ecdf4c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:19.9997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQjxbiQo5yBiKNojnnXGROVi4TV76urcbswnJaiuTVuGjNzkQDaC/OYPMfftdgWLfwR+Cp91K1fqpOEHTzHUhu3I2KJfiw4/PryJU8Iw770=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1283
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: WixrsnRX8PBmTgqZSL2P4zRKNHN4gmFH
X-Proofpoint-GUID: WixrsnRX8PBmTgqZSL2P4zRKNHN4gmFH
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

Updates since v26:
xfs: don't commit the first deferred transaction without intents
  Simplified roll on dirty logic

xfs: Set up infrastructure for log attribute replay
  Fixed year and author in copyright commentary
  Indentation fix in xfs_attri_item_format
  Added error report in xlog_recover_attri_commit_pass2
  Fixed comments for attr item intents

xfs: Implement attr logging and replay
   Investigated removing NULL check in xfs_attr_create_intent
      Skipped since attrip can be null in the case of a large name/val buffer. 
      Trailing buffers use kmem_alloc not caches

xfs: Add helper function xfs_init_attr_trans
   NEW

xfs: add leaf split error tag
xfs: add leaf to node error tag
  Added from Catherines xfstest set

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v27

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v27_extended

Allison Henderson (15):
  xfs: Fix double unlock in defer capture code
  xfs: don't commit the first deferred transaction without intents
  xfs: Return from xfs_attr_set_iter if there are no more rmtblks to
    process
  xfs: Set up infrastructure for log attribute replay
  xfs: Implement attr logging and replay
  xfs: Skip flip flags for delayed attrs
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Remove unused xfs_attr_*_args
  xfs: Add log attribute error tag
  xfs: Add larp debug option
  xfs: Merge xfs_delattr_context into xfs_attr_item
  xfs: Add helper function xfs_attr_leaf_addname
  xfs: Add helper function xfs_init_attr_trans
  xfs: add leaf split error tag
  xfs: add leaf to node error tag

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 523 +++++++++++----------
 fs/xfs/libxfs/xfs_attr.h        |  70 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   9 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  37 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   4 +
 fs/xfs/libxfs/xfs_defer.c       |  35 +-
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   8 +-
 fs/xfs/libxfs/xfs_format.h      |   9 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 +-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_attr_item.c          | 795 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  46 ++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_error.c              |   9 +
 fs/xfs/xfs_globals.c            |   1 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                |  45 ++
 fs/xfs/xfs_log.h                |  12 +
 fs/xfs/xfs_log_recover.c        |   2 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_sysctl.h             |   1 +
 fs/xfs/xfs_sysfs.c              |  24 +
 fs/xfs/xfs_trace.h              |   1 +
 28 files changed, 1417 insertions(+), 279 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.25.1

