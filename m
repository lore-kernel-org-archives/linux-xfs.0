Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8296DC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6781E61009
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhG0GVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35788 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234349AbhG0GVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HBMi010846
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=S0j2NL0yPmct6BrHb+yH9/zboG7SkUcAIeB6kJtwvuE=;
 b=Po1xsY+Aanp5P4z2Cqkji+87sZCfKZyfTmcCAVlxkdh1N27fVjChPt1tiEVHDCztEIu+
 w0Arb/Dxwm9USTEYXlU8MABFDPFW5lSuZlvVYMFqMRHAlpkaimcrlJtYlwFM5uFtg3qJ
 XX/CPBfyp3PZ0d3efqJ7RLqHTCeDeZS6yek3fUAVYgm6LAXeBC5qnld6mYeBdJWzSMSx
 6YbLIQe09AbriCo2xANpcklkzCoYGu1EP1BUDy4mCSh+ou/AM8syVWwtSThS3+Yz993x
 6WVbhxV4eXd+icelWgalcWfUvAgGvlYSGMoH1RWBCZGhTRhu4ZP1T3XioNpPJIawu2h9 pg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=S0j2NL0yPmct6BrHb+yH9/zboG7SkUcAIeB6kJtwvuE=;
 b=DtnDY3WAtdwvPRpwIIP96XHEV73ApTKyto0F6qnQBY4ZR3mCy/GSEp3KZvC6eURKgE5U
 9VeNIvgz0ovey/UmF+hXjtjOO2xhanw+OlrZWWWG4FfQG63YeqjOuyvcp6g86ra//fup
 zIBx5iGD7w55UYrSDdDZa0U5vbaaSGGfOlB+5k+9rmKl3eB4sS2xesHaCNOrpEwqRYzw
 B1DU+/4Hwt5yJECwI3dmJVy26nhwE8alSxMo9yV9EWfT4OrrQL6Js678i6LTq0xusxvT
 dkdnh34LgvPmlFWGg/ONtL9LHb/Xlv817LSl11hRI8Bx+5cSoC4+ppHD1V8LwYJ/2rm5 XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0v9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FUt0019936
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3020.oracle.com with ESMTP id 3a2347k08d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEpgHxKmJRhlSJx+rjGNW+3e/3gtA3wZwPczaDKuPhPCkWJIiu6jwMx75cIuyiXOJDKFsAWXRadQogFNTCtYgncXubcfca53GvFZMvg9Hxk93RAnedh+X8yaRBjuJM+O7zB8MS5mMwezkVWZI23gHUEemvTiA+3SKtdaJ3OjgRYfAATcj77I0/ogE+er0xqVCGtuw7RXrZpi9JJq3KhoDnXJJARsqbIR0E6L1h6anqBA5ga1zc3ahi7VJpmu2c6/kORovFwyVs5vmb974eGLuOsy17GjI01EI1m7M3pNOcXP9KuLgYjmh9tI3q+10BSFYLwsw55j/mWBppOoihCZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0j2NL0yPmct6BrHb+yH9/zboG7SkUcAIeB6kJtwvuE=;
 b=bF9LYc8d5RW/NzpB9wVPqXj0OIhNZEK5KZYQ41vA9wJC1GgN504XZkaIVcWu3S7jplYEYuuEsK7Rn3gfRe+NpJk9/QSK6W1yilphzN/PAQUhGOIxbxenP8NHKhss+SwJbjAA7b66tGfZIToe8ku+nhf5n0NSz0AuYy1dY0tKKvRKEE+RXtKlvEfqF3sJsOiEF+hXIeftxxNjdT0rTBBmTD9lV3ToQ4IQdEnUBa54OPHIfSVV3imoeCokHgJbnQsIuP9OymRVYI7Hk2etOFIBOXBF42hYyH418k7Sf4j+Utivr0KuSsIODnCQmBB7zoN159lYcIzEqf257kb6/bcgdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0j2NL0yPmct6BrHb+yH9/zboG7SkUcAIeB6kJtwvuE=;
 b=n2xSUyz8+EvmOF0vPH7uLOdAFEp/N2W0S1CsWPeqrk/z3UK6930iqbZ1evNOnHpx/DsvMKQb194+r2HXXWjCj8RReybGFAOXYHUB9PjA2X7in67QTFrCKMzdTt2HSnRN4Ifnfx8jRUKtmiJnxf8JjdDPnySaA9DxqlsLXc0HOy8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2647.namprd10.prod.outlook.com (2603:10b6:a02:b2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:08 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 00/16] Delayed Attributes
Date:   Mon, 26 Jul 2021 23:20:37 -0700
Message-Id: <20210727062053.11129-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0184977-ce58-4aa8-0ae9-08d950c6b88b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2647E025ED792EE6C686BCCA95E99@BYAPR10MB2647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5KP2dU4LBohYNZQfql39I9Vg1mHaYytW/AzxqylYTZRc2/d2ckK1I+DSIavr4qbmtqRMrzYNmdnEqhZfI5tm4gdwRFSG9saRSLWeV1CoWEhL7V+bhmJcbNj4XvrQaQvH3qUVbYSA+jjZmt6gK/2pGbKtCX3hfxFRxxcSN1tLqxWAs54rADlMi2qoc4zICTsrs5Qx0NCeYP1AIpNuHxq3mDz2sAbYCojD4jxe7pYeNzu6XVJhk19I9DWma7oETCch8dkjyORkv+xoUMcs7RwiuGrS8WP5MEWv0fEbIMcQ4t/9xF3u6FtYnLP2vgvuKp+Lc8L0E9uW6+ShWfdK0EU2llQX9ktk7Lp0/TfsTEh1fT9FYGhgYjNCwOY5UHGjyizH/wHKy4nPicYAAAeOpWs21mtDJa7a1tsaAp4w7BAlDczYFYBql4AhLvWbd3S95P6P7nla8JX6ZFaGNq2EVdsIc1vlimmy3p1kR7SwWUMINFU0IhNv807Dp2dE9jHX1flTP/bw/AVau48OU0/tI09RYDLIM/pKiMCYiHIrEXnrQhjfR60uLPRzPoAQqGmeTKUhOdanYuI6oWhx2YOOp+w73xtnJd5X1ZpWN3BEGUCC4/9tnupKt1eBu37rGbCd+AGVLyuXQ1lf+OlllHdo8sxckoQn/UdMyqUAKAMz0uVjUotuA+xVT0wiZZE/cp7qGTLWToSYAbkvTzBMOK88V8ZNqdVVZt+NqAhQCbfIs/s2h55puM3iOlx9ZXCTWyfo6beJL+lGB804DTKjQelLt8X7ULkp2d6uEzx4Uy3Dwv0CLZiNLVG4o+U3KLMlL8kXjwsL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(2906002)(6666004)(316002)(38100700002)(52116002)(5660300002)(36756003)(86362001)(8676002)(38350700002)(6916009)(966005)(44832011)(83380400001)(26005)(8936002)(6486002)(478600001)(6506007)(1076003)(186003)(2616005)(66556008)(956004)(66476007)(66946007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1zLDbHhvAzCzeLfNfOJ7SCT+UCRCuV50iAfqrltKp/1/g8/n5hVleUyhH9FZ?=
 =?us-ascii?Q?JjvsWqn5SiZED8Gh0VvVNp+mVKSnaXaY3pKcvamBgUb5BWlCnxHI7eaU3v3S?=
 =?us-ascii?Q?U15hyDRHd+0AXBEKKodAt0rMvYFoZElAn1WWR68EcTpRyctBsyeFmFkhELYg?=
 =?us-ascii?Q?yR3nxbcGK4sPgabMqwl5xYX4FnhM+uzEeuuMjfVdK1Xj2G/sHCVC1YbsLkxh?=
 =?us-ascii?Q?vnTH6BDLyJHEtgfyGl84DDd6RiVRzCHABuVqQbppqpVGgN8l4gCwm3gy18PN?=
 =?us-ascii?Q?MyQUXSZ3ni92i5RTsGqg/+gnwM48WcUwyxIMLhx3fQrVtFuySCyOnIWF/RTz?=
 =?us-ascii?Q?RVCGTfaDd5C46YrFgoqkXCfP5YwK0rfCPGi96FxcIws/py3Rtd+65HjDxD/i?=
 =?us-ascii?Q?X7rJb98oQwWj7FRUVQatMfTDyNBPoeMg+pEhoDNe0oWagoB7LmFHFiipJQ5n?=
 =?us-ascii?Q?U06Lu4RWES1h34Yv3T908Ksy+AR08W94AOfHK3cQSvs24WTBszmUf5mgQYIE?=
 =?us-ascii?Q?C88gjpZtwtvwyDUGuXzcBf4z/SEBGEEdLPm9Bi4MoD0J4qfjz1nzzMp43NYv?=
 =?us-ascii?Q?3hQuvGVx2NK6VOjbH3cQLbqkr92qF9HmT9ATGCEJGzKLs6LVjZaYCVb2LShz?=
 =?us-ascii?Q?BOR0/EZR5tYG3Vq8ZAiRbSr0WF71ukoxxbiyBQGPIzVelm4S5mCFjXLSv/k2?=
 =?us-ascii?Q?5/fn9/iGyFtpMgQbZckcpEj1X4Mjb+xn05+LeGRvyRehHWOPqMKpbN2KPNjy?=
 =?us-ascii?Q?smY2PWToExl6n0EOG/WG/JPP6OcA1+0CMuND2EwOy8bajUxCT+dS5C0s8SLN?=
 =?us-ascii?Q?NIqjcGMcF23j2G4fbYqqqI+Miurp4mtI+rBzyackLuOcwXoXcc2/DTrbHXaq?=
 =?us-ascii?Q?FuB9u93b2CNwTBlVawH/LrsQP7IYFeDs/29CQ4L2Urh5R5oqDB7StW9gKnFv?=
 =?us-ascii?Q?AvISWIU2vXDAMtePApIst/OJNOp3QI9SXVYlS1g52AbBBG6g6ajj/WMISyVs?=
 =?us-ascii?Q?0cvv+HhKUNWSrviBwrU02+c7G6/Dz9L5ISaoK/QlIhLVMf/N7Sm+zo5iUUXI?=
 =?us-ascii?Q?d9+w19FZBOVfaESRfZJZrYMrMXphDJGUOjTuB9PMdOdRdZR7rSbysd+JUv8B?=
 =?us-ascii?Q?morP8drSMPJLp3cFjE05SGBieBPFuNKz4oz2MDPBSLtV8Zrw4OHVbskEWIpe?=
 =?us-ascii?Q?m6NXbagK47/iKRlNOnrDQctcMbu+xJyEW7HnW9vhbCijc1y2rkPfqAPrh/Jb?=
 =?us-ascii?Q?Y4XKVk+U1NqRnLDqL+uad9z3xUe2arAvq0HtoAxwVwswLyVKnJl5uZPN4pri?=
 =?us-ascii?Q?QRjkx5iiXHRRKT01fzcHsG3+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0184977-ce58-4aa8-0ae9-08d950c6b88b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:08.1005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDVdPBqPFRkW79ZgUQb7UiQkhNMSuroSaNxhfeiLkfUIRyLjimQlEd5eOpXQSoq27qmLeSAc5+V7fom5IxvwtMTPCreklOnKZ9Vxmh5stNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: j-wR0LZghHicsUsKAlYT1uiBW3cdGzL1
X-Proofpoint-GUID: j-wR0LZghHicsUsKAlYT1uiBW3cdGzL1
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

Updates since v21:

Added 3 new patches from Darrick's development tree:
   xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
   xfs: refactor xfs_iget calls from log intent recovery
   xfs: clear log incompat feature bits when the log is idle

xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
   Modified check to return 0, instead of error

xfs: Set up infrastructure for deferred attribute operations
   Changed xattri_op_flags from uint32_t to unsigned int
   Changed XFS_ATTR_OP_FLAGS_TYPE_MASK from 0x0FF to 0xFF
   Removed comment from xfs_attri_item_size
   Added error report in xfs_attri_copy_format
   Variable nit cleanups in xfs_attri_item_committed
   Added type masking to op_flag operations in xfs_attri_validate
   Added XFS_ERROR_REPORT and -EFSCORRUPTED return in xlog_recover_attrd_commit_pass2(
   Copyright time stamp update in xfs_attr_item.h
   Rebase adjustments

xfs: Implement attr logging and replay
   Added function xfs_sb_version_hasdelattr
   Updated commit message per review comments
   Added type masking to op_flag operations in xfs_trans_attr_finish_update
   Moved incompat flag code to xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
   Added call to helper function xlog_recover_iget in xfs_attri_item_recover
   Reworked attr in xfs_attri_item_recover to be allocated/freed
   Added error check to xfs_defer_ops_capture_and_commit
   Made xfs_trans_get_attrd and xfs_trans_attr_finish_update STATIC

xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
   Added helper function xfs_attr_use_log_assist
   Added calls to helper function in xfs_attr_set
   Fixed kernel test robot nits

xfs: Add delattr mount option
   Added CONFIG_XFS_DEBUG check to mount option
   Added Experimental warning to mount option

xfs: Add helper function xfs_attr_leaf_addname
   Simplified error handling in xfs_attr_leaf_addname


Extended series updates:
   
xfs: Add parent pointers to rename
   Added incompat flag logic to xfs_rename

xfs: remove parent pointers in unlink
   Added incompat flag logic to xfs_unlink

xfs: add parent attributes to link
   Added incompat flag logic to xfs_link

xfs: parent pointer attribute creation
   Added incompat flag logic to xfs_create

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v22

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v22_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv3
In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v22
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v22_extended

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

Allison Henderson (13):
  xfs: refactor xfs_iget calls from log intent recovery
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

Darrick J. Wong (2):
  xfs: allow setting and clearing of log incompat feature flags
  xfs: clear log incompat feature bits when the log is idle

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 435 +++++++++++----------
 fs/xfs/libxfs/xfs_attr.h        |  57 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  38 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/libxfs/xfs_defer.c       |   1 +
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_format.h      |  25 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_log_recover.h |   4 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_attr_item.c          | 835 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  52 +++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_bmap_item.c          |  11 +-
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                | 108 ++++++
 fs/xfs/xfs_log.h                |   4 +
 fs/xfs/xfs_log_priv.h           |   3 +
 fs/xfs/xfs_log_recover.c        |  54 ++-
 fs/xfs/xfs_mount.c              | 110 ++++++
 fs/xfs/xfs_mount.h              |   3 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_super.c              |  11 +-
 fs/xfs/xfs_trace.h              |  25 ++
 fs/xfs/xfs_xattr.c              |   2 +
 30 files changed, 1593 insertions(+), 258 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.7.4

