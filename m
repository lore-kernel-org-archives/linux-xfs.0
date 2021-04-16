Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DD7C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66FCD6117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbhDPJVZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhDPJVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G98oHV036511
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=jKsBBKCjl38r6/99fXjab+i+0MS1CmPTQpJAHZ31lBs=;
 b=chrRfzDAUUNp5Uo/QRXtz61wgAtAzl2HPI3o6V6LQ5/kSlFh8fLHTP4zCrIRk815dhlb
 VVFcddlU/oreSyAw1emcQWIQ4Sc7+H5+VsjSaJOtupGwEkOBLbVWZVnCM0HpZqOxgZQD
 bhyKiql52ywtoY2hnN6/i7Wx9f7aHGncYJxvCEcszXodOb/+mgbzrLvuMN25ztAzH4kt
 gfgW2gtvW1Iyxou3a4qV/f6XOJBaH5jDu6RF9UToTKT449rvwRCksscmTMRYjufGWcWM
 FAybQrfZ/f9dl4HyLlsZkXLVVUeFaO9DoDQUJARa4bIQ6VLIKBxQ5tPbJ5jKCFa5Ndn5 hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37u3ymrjac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AefD093106
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:20:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3030.oracle.com with ESMTP id 37unktwmg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:20:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVVyfWJ/NsltTUdHcxwkS6ZnyLBIIu3NBYdjxkpXCAIZhDzqloNJBaEM9bIXSHA+A+HJq6glgfaGRQmzAQlEyEJAp2SFzXO3Llcs2YOHfBZJ2eLKuYdjrisfaCAo7Zyym/LE9Xx4LkkXb/bJ8zimL3zgzPXIXcKeb/A9SkizCN8YBbnSKBKJTgH2YGIpKq6fOWL8XWTw3petihns9mpv2UbaH7EDUlUfdnpzqLPDpJbmrXXGEiBBJUCAxonZF3vC2C32Yo+9sg5gZp6g/BY1huum5ROAMMpUSC5qZKL6AFeJZanz1f2KCByW+GP4gGVaQogo4gG7r1Svw6qxLayzOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKsBBKCjl38r6/99fXjab+i+0MS1CmPTQpJAHZ31lBs=;
 b=laorbb6TVW2iWlhu38FLCHKwDNtL2e1s5Y8Wk3nTQtq+lnd33dJiDGHHm+nU+pT3yZtjfiD8v+b1sLf+rdHtmGdcs/5biPLupT0HIorselxlByGrUgCB9wR2IQxN5STvfTdet+MeoyruN4MojXpFrV48EJGNSHEvIOVZNI5z6RpfuOmDC9oA4WaRpLw5Grk2GE67LW/C+0RAVYaGzAupauW0Hliivdwz9uTQ/TtMkvMZXy1YEPsUfCjT7lK9VzfIbvNN1L8ei3bJGu6dMBKevVdRJ06+bFjOvZpKUTkmwAls7qGkQlNlgCrcUuEcTuAQXOaImi3lPUX6GrsXYj7xIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKsBBKCjl38r6/99fXjab+i+0MS1CmPTQpJAHZ31lBs=;
 b=LyR1DgE25tG1feDseuLlZu4m+q9hQY/lwvMlhiaLWEDXOZfgwidYsV4slnOCsq0+Fw71NxSPW2kTkanvyJXaS33o56UPyzFl+UsohOSDElyfHkMpzNOTbvxSkmIkGkGT1xkXSQ7fcZRCJLYgV3OX00DhOE2zsi+iDhQikHfGMU0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3560.namprd10.prod.outlook.com (2603:10b6:a03:124::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 09:20:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:20:57 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 00/11] xfs: Delay Ready Attributes
Date:   Fri, 16 Apr 2021 02:20:34 -0700
Message-Id: <20210416092045.2215-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:20:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13e0f720-a59c-4f9a-ba06-08d900b8f169
X-MS-TrafficTypeDiagnostic: BYAPR10MB3560:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3560F22B7D68030BD0DE31CD954C9@BYAPR10MB3560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xnxt5rb2MTiBNTql3aAKDJqoegL7bto8k6YJkii2IQCkIC2Hqo39XxIXIikF4WjfEtjxbdoSLL2xsbd+8VLsqCIQN7UA+T6SGgHfNEG4qNF+RUTzbe3BtzzwpszWzZw99nS8udIMlerHaarl4kUbfJY6v8Sz42FJOyidVUuhlVWIIWxvA05uR6aHxbZPbj98HfS9S6nLB2cJEvzlwYo6gaKcnBNIrFyYw9PE99my9mUMiaE8qucv+y4B8eZXNrd3tjybmzyK6SDxnGNTfVbzFi64rd5Qt/YlGMJ7fAEXAbT1pKAZX9OYuzWQeO6cK5dCdkBeP7LA+78JiR+Oo3AXjy9GmvAbZhpEQfWb4Ds2JdeacPQPkqcw36VctmPcrW8KsSVKYQ6M6ZNCxwVdu3WxFEUtoO7GgH4jx/jJVvA6I5ulCUCJ9DFH5gbUnnswIcELGSHiNhhk78S622xZGwFLiuTlXwo/68o9QX2OrJVXIeN4WLaLgKUOj912Jpvl5AFCZbK/Za0BCt0UQLtHRDl+qQE7eSxAUy7xFoPdkXFQ4VUPmHa/QVZ7bbFwMi5Zeke/s3qVYv+37HhAUrCylG8bGTO5MT/v5K0BtyztWP5PE/nmcd8daG96oJyzjWDUMsBVXGdmEE5aKDeTqxGmrILQ4DYxU5tEWbEa7XhI/n/aVklAa8BRZN2AMt7QT1Q0gTr7u71zt6hKJzZMinoDPyCdG2mCBONJ4FRoy/0t/w6uEgaNwyxZbc+JiXVce0HzQ1+UM07iv0w3HxrLuj3zAZ1grA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(26005)(508600001)(1076003)(38350700002)(86362001)(16526019)(83380400001)(38100700002)(186003)(44832011)(69590400012)(6666004)(8676002)(6512007)(66946007)(6506007)(956004)(66476007)(66556008)(8936002)(316002)(5660300002)(6486002)(6916009)(36756003)(2616005)(966005)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bkfYhAXQzbmCg6jqmhoVnDkp+ZdLL1YvJuykofAPWdcgdVrBpsBrfyNs7GbN?=
 =?us-ascii?Q?OGyK174Wnm+ZvZabK0y7dmCg0NuF6Tvxj6oEPfgyJfNzYqRbFqufJ9gGD3BD?=
 =?us-ascii?Q?k/LsjO6raBca+Fol1VuAu0Q5J42x+rqGL/kWjgCv42tvG6QgHqsH18HybuSI?=
 =?us-ascii?Q?bOee+pQPBu0fDyS1QCkXa97ZXwBkB2ZOaA2GCgfzDWfnXBCa/kYvfsB4ET6q?=
 =?us-ascii?Q?GUhBFH8FF2vcvdTIsSfQoXRncZPmeiIHBt+xup8vGEPMX/qXaiwoRYRptREc?=
 =?us-ascii?Q?pSfiGLcW4WZ7hfRCk8aOf8av1CoHJ4F+67gAI6a0109DjzBQjT9YuyNDueSd?=
 =?us-ascii?Q?uPSTzST8Mk72mZkz+7+tElPTBCWYBhuhezBBeubrjLGI+oDed5DbyTxMjLUp?=
 =?us-ascii?Q?YItuduI9xvLyQjLx04UrZUlXnCs2CpzRAFODA2iUQEes06FL7hGEzsGhJ989?=
 =?us-ascii?Q?QMVd06mq8xHtX6ERmwJb4mUl2jJzlnaXXjuefuc1Mb2oZC2Bnm00L2llkSxm?=
 =?us-ascii?Q?f7T64pVk+dsc435D6xk42q7rXHuwcPSIzsgvRf6ce7Rd9AgCbhIiSL4Gj6ls?=
 =?us-ascii?Q?/EQRyWPQkTRs0oxD0chd2u0iLUYD92e1ekGLszGDkFAgjWKvZhZTCC3OCcX7?=
 =?us-ascii?Q?GB5Rt3aW1jl8TY3EEyYYTkJI+DcRD+ck/HPcYLuVMVHzWnXvMGydf5mhFFa7?=
 =?us-ascii?Q?hretQpcNPtJ6ZBXTzmdxNv6QBkpvRAqojsRNxSzsxGc+IcfmFbkfdPC7iPjD?=
 =?us-ascii?Q?4bK7V5gVjbZWJL3/i8VSzbCN/el0XUGVzxAnKrVyx1km6pe4uVF0RbaSmfGe?=
 =?us-ascii?Q?98oTWoSiGdcSNSQPyJ3oIBq4XFz2ufUGJcPrg6/frPkvqE4vH+pgvC3aYfvF?=
 =?us-ascii?Q?HJ+bTj8jiGWfVNi+5DepvTBYbsTJMt45osN1Wg+R/XcafJm4+WT/D46/FHMh?=
 =?us-ascii?Q?qEB7kY1TjlGbJQsJqkJ1gOB3te9KT71A3v1IeQjNySQ9io7mQrosClUdfeZQ?=
 =?us-ascii?Q?gtUdYpk3z0TQhFygBM9na1mt2hhh+qujSaU1WieW2H362vprfNyifLnWCWpp?=
 =?us-ascii?Q?XEG4uiGniX2D4TPictOKpwkYmvqNsLbR7SW29Jxp0XqqOIY8MHyoEDWmmcaK?=
 =?us-ascii?Q?e2gl7uNR33rQ8OE28LDEoX2bzqX4IAJMyk5Q4qRRpeTs/50rL2IklHUEifBu?=
 =?us-ascii?Q?Fgm/OKIGe1y3Hyzs6a+7bofAlt9AY10GM+DooWYeVF7qzi8c0H+XcDrIrn3n?=
 =?us-ascii?Q?CHJ5INOSlwMIzLdc4qkdbyX/h17AcFs+qDZqdWcMTtWGQzLZqlvbR+ZRfTeH?=
 =?us-ascii?Q?C5xzBc0p0FpwHKLkV9ZiFc5O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e0f720-a59c-4f9a-ba06-08d900b8f169
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:20:57.5300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHc6KjNpfHDA1KF8ikr+xP9flp1Zp7meHoPxHVaEbEd/ptFC6YbAp/DfsimHr1JuikZPjHsG+OuPFXOXz0MnSODccljYfvd2ezcoVnDBsnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3560
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-GUID: N74cg8DmC0aSXw1ptTd368NNeLhZSufU
X-Proofpoint-ORIG-GUID: N74cg8DmC0aSXw1ptTd368NNeLhZSufU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for Dealyed Attributes. Which is a
subset of a yet larger series for parent pointers. Delayed attributes allow
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

Updates since v16: Mostly just review feed back from the previous revision.
I've tracked changes below to help reviews recall the changes discussed

xfs: Reverse apply 72b97ea40d
  No change

xfs: Add xfs_attr_node_remove_cleanup
  No change

xfs: Hoist xfs_attr_set_shortform
  No change

xfs: Add helper xfs_attr_set_fmt
  No change

xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
  No change

xfs: Add helper xfs_attr_node_addname_find_attr
  No change

xfs: Hoist xfs_attr_node_addname
  Moved the xfs_da_state_free in xfs_attr_set_args into xfs_attr_node_addname to fix memleak

xfs: Hoist xfs_attr_leaf_addname
  Removed trace_xfs_attr_leaf_addname from trace.h

xfs: Hoist node transaction handling
  No change

xfs: Add delay ready attr remove routines
  Comment for xfs_attr_trans_roll updated
  Return error from xfs_attr_node_removename_setup call
  Changed breaks to gotos in xfs_attr_remove_iter
  Moved xfs_attr_node_removename_setup into the uninit state
  Added extra state XFS_DAS_CLNUP
  Diagram updated

xfs: Add delay ready attr set routines
  Added a xfs_trans_brelse in xfs_attr_set_args when xfs_attr_trans_roll fails
  Fixed misc nits with if/else bracket consistency
  Move XFS_DAS_FOUND_LBLK state assignment in to leaf scope
  Add extra -EAGAIN after calls to __xfs_at__xfs_attr_rmtval_remove
  Added extra state XFS_DAS_RD_LEAF and XFS_DAS_CLR_FLAG
  Diagram updated

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v17

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v17_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv2

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v17
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v17_extended

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

Thanks all!
Allison 

Allison Henderson (11):
  xfs: Reverse apply 72b97ea40d
  xfs: Add xfs_attr_node_remove_cleanup
  xfs: Hoist xfs_attr_set_shortform
  xfs: Add helper xfs_attr_set_fmt
  xfs: Separate xfs_attr_node_addname and
    xfs_attr_node_addname_clear_incomplete
  xfs: Add helper xfs_attr_node_addname_find_attr
  xfs: Hoist xfs_attr_node_addname
  xfs: Hoist xfs_attr_leaf_addname
  xfs: Hoist node transaction handling
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines

 fs/xfs/libxfs/xfs_attr.c        | 908 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 401 ++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 126 ++++--
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_trace.h              |   2 -
 7 files changed, 1038 insertions(+), 410 deletions(-)

-- 
2.7.4

