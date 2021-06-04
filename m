Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1EDC4743D
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56CB9613F4
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhFDXo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhFDXo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NgfDc074018
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=3X1czXSTEVBeiyGFMmByY9aLibop8oGBX8OTMvzVY7c=;
 b=Iq2sV5njCE3CWOjmG17DzdAYja6QsWnXBgeHE0QdPblZqTsqTRr3K7MRN6zWKkFdHh1l
 jWePuAmVWMPClF2BXCUxr+eYDXZg+EhRSypT6sqCmxlTh3O+SEDa68UtvKQU2Ij7abDQ
 rCjjBXcTNa+KjahsRy9eFA3vMxJ/RQDbTt76juOUQ90xOq11DQz70ozrFCkJpA527kwM
 mfq1p6tg3ANrye/iJxYNQ0LO5v2Q5ZY2STtc3rHCxDDpD2pMzpDNLux1DNoA7cbFrh7s
 ksO5+kNEIIR/UVg+BeEEYg71tUg1EJ7qqG/XFPKCATzmZgeUFCVOmN+b1rXu424M2aOD 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38ue8pq0gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NeeWB056334
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3030.oracle.com with ESMTP id 38yuymb0mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOAJojMZeXrshCiihz9gdBDE/2Vdk8JCtKc/q+tKiAXqhJ6HnWLbLBMlVFeDSYZ1wA61Bn7JVyEIAJJrRA77CTwPX4z1lpC205+GNkix22ASSiLjJ55TCzzeGtBm25NoiY+NOiY9NxGbH6egQqZzNL3I/38bAdDNWS8730Rya9flMCE/AKG/oR8URLSjozAXZUKkK7x4RyV7UIpXYQyablfTHKvC7gHCxeDACqB75wdGkJXhwdIdo/cVKEf+hP3TYhvy90xZhXgcK2LrIlLHUU75UbDwj2pFbAmQSaigVZXdI9miRWMZymbKER8Z6r4IfeK0At6XBPgHcFrmL7QG0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3X1czXSTEVBeiyGFMmByY9aLibop8oGBX8OTMvzVY7c=;
 b=k/Cr4iNvsmS6tjCtpqhaTcwkrZOqLE06VCWZE2N/YSCBHEMsSDH0UY7bATE4JHVT3TdUJMUE9ayRa4TbmrdU3Ehz9uH/EmMVulQPApTlwzxz4GfcDDVA5+P6o1LQyfHBKs3tjoTfzkvEs2Ok9YzXOiItOGNW4GSIGHwLp91LsHm1t0CDbvHLwSWE0tIwLgID/MxsheYLQdBJj1sDHdGAzoM2htNFEMgmzKIN9ncMdBTnIdc1P7++vMlD1R8ZeWQPoMMAkSYuB1beyZFLUguJQYmvh2Cl0R3AHmvX7ebNxdyRWqOXUhdHZ0qG/PDyCUxwP5gWxVfv/tIywgb1s6M06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3X1czXSTEVBeiyGFMmByY9aLibop8oGBX8OTMvzVY7c=;
 b=V+SYRsQBfk7usK5k4dR4WYOwsbn9kNmjuz1uCNVPF/yDfD9OxZV2U+x78ISDNBxS0BWSPcKcy5suZOWnujlek8HDB41XT3P1y58x06sQOkzOcJt1lNZ+7eDpaxjwAthhrr6nFqwuDjsv5ayDV3XxcXF+TAk/njUSLXK/Kv22Zcw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2485.namprd10.prod.outlook.com (2603:10b6:a02:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 23:42:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:38 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 00/14] Delay Ready Attributes
Date:   Fri,  4 Jun 2021 16:41:52 -0700
Message-Id: <20210604234206.31683-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR07CA0095.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f256c82-35bb-44d5-0773-08d927b26eaf
X-MS-TrafficTypeDiagnostic: BYAPR10MB2485:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2485A46DB31C1AF6D6C5AD96953B9@BYAPR10MB2485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: up4+FYktfqPZGnu1OkkWPlLzDGGkq2hcBaQlS8aY6JNpqORInPEeGaGO6SRYG7PFu+4N9PFfwtKrihKh86aDtNWOlYP+GPovd7Ka7Vyh7rzKri68+SRycTiXM66wNV1sIUwD3A8eEAzW1ie/cPcPG345foHo1i6322yyXAQQW31yHJGDJpmF75NJ3/yyoGAPOSNPNvcvQS1TVITjhRcGPFMd0195L6y55tqAGv3du5OOB5EXyVt0YWk7J8yJtzKTKYHMjYPDeOpo1vx4x4RlnvZLs2WQptIhrkRzeuRTPerx02AwkR6fimC7YfOMExTEG/pNFllUM+7JHu8c3hOtpulg7Jc9Bj8DOXfxWYi0wYCDaC+gdXWqt6TxyH5vJUdqLlmxtsfJ1C6OgsOE8ijkCW7RFhY5bZAEDqkDNNHW3XWuTE9nYWJpEOcnTTfnFZfSA5CD4uH88eebqHZ2bMnbNboox6M6ms/NsNbJGQcV8XcbqqDXr7To/9c9IsGJgcwTqHpxwuZx7PujYyYfevHrGl3VgKH5pMeIy7saR7AJZO5cp8hTP34r9wcOOSWP3JAkaZseGSCC5omFNCnDvNEqCwxK137CLV5Dk4/ZCXs54uF8YPccO2lzi4et8fcx8EBjdZOr2oCoKt42AiThZXuN/VOZGSXy32JgHIuN/SFJvc/ev1bfBRWrU00pdfGJP0H43pjvYI/74IEAxCU80HLChaVW2YLnOhWRpvT2etw+Krh7m38x+LDU70fRJhQCSgRQQpMAHeAnbc8c1MXS8l3DkEhnMN9m+BMMPIX/YwiETpg+TFt5FPOlRi/EIAJ8+LI9LS5N+KteAZhueBSXWkyPwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(346002)(39850400004)(316002)(956004)(38350700002)(2616005)(83380400001)(38100700002)(16526019)(44832011)(6666004)(966005)(2906002)(1076003)(186003)(6916009)(8676002)(6506007)(6486002)(36756003)(8936002)(66556008)(66946007)(86362001)(478600001)(66476007)(52116002)(26005)(6512007)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j8f0zJ07dvo5j38MjJtQKu+K62PLsTTqjXkIujwjlCdl6Iip4gAdMSLos8Ls?=
 =?us-ascii?Q?8CQEJPRtLth67QAaT9OwdRURmAkBGnWN9bXDrKQa1+uRVZpAhghGpzUDYY2E?=
 =?us-ascii?Q?Ng2r1WQnkVCE2V6d73PPPvrUD7e2CXfmAfgFqQG0HZYnA3c01nLWCoXH4HR8?=
 =?us-ascii?Q?gJDZOkTi0KDsqysJjI9V+yDrwJU0Bz4Y5Enw+uLi4H2VGq8yVafBNkS+iGFY?=
 =?us-ascii?Q?RnyBh/f+UjqKveEW8V6BNsROE1MymIM/+oVQaf8FwUav+/PepaqTwv+PudXZ?=
 =?us-ascii?Q?zbCYL7ktVmqOakpjKgo1lI37nYohZrY9M4uzQhpj3B2gz7ohzossVlVOsCQ8?=
 =?us-ascii?Q?xEr/ITNdqmntXyKKTvvB4sVFY6lISNK8XTQEXPIz5/wCOc9AKhEK7pYFt6Zg?=
 =?us-ascii?Q?C+MJeN5d5tNwVetEE/b++lVffMp7sRfh+/nsri5Qpr0po5gRDYsdO0fYf+KL?=
 =?us-ascii?Q?AfGb7kF8pgHDWkAPwrcDyC1cuDflI2T9WTPKqpFkQXEaWGqMUvfj+ai4CYjv?=
 =?us-ascii?Q?tF9c+FgrSew+j7h77ZYAmvLLE1QBEPNznnG+dskEDz2QX27j2YtSVw8bWXhL?=
 =?us-ascii?Q?vKtG3x8XU+DJUOWdjZjzYxioaQFgB4vTHPVke1ONlxahp92GRMIlUwZP9Pu2?=
 =?us-ascii?Q?mTC6ILittTvgwzmlp2rR7Ya/3SSz1nXUIdu//NrIB49br3YYLhW7itDJiHBo?=
 =?us-ascii?Q?H3UbKoOtKCE1g6lNeh3ze3Jr1j8VioIhcB4rDKHJU8J0YkUfV/M6Z932am7e?=
 =?us-ascii?Q?oN6jQxZ7K3O7wOomG1shy617kxbFqkqufYaLqCe3EGFFVlA/ydJRdfK2VgGI?=
 =?us-ascii?Q?PELQ3ehJJ5GgLMHrX9Tz8hFjVdzdXdZ2SEFlPZWKr27LBRm0UNMXzMsKqW6c?=
 =?us-ascii?Q?oqi2IHh8oe1hoCAl6tZsuQMTXuGnLxxiB0a79QfzsJYMWMnopM4RbvwnsDcy?=
 =?us-ascii?Q?nzgpMLVJGUVT4nZ45azd4148st1kx4wa/jzNco/jfwM6nmcf7YxL2Qh608wp?=
 =?us-ascii?Q?B8HZ4TjjwzTTDbQjMz5SA9fThr+FuC/ftG5VdzU1dhIqCwiHAV8NH4ngbQgN?=
 =?us-ascii?Q?3aoxfhQY2mi9vf73nCCj+TIMOE0zk5dB8qyIeBuRK5t4gTzJ6zuOXhUPXFcZ?=
 =?us-ascii?Q?0nlLSSFU0wSBcQIucsZ9QXADDSkt1guzg0dcH0rj0DtD3pAgvh+75fpqcRRi?=
 =?us-ascii?Q?0ZUYTTU8Z8/+GWW0rnBwybx45MxEdSXFMfnfxgNbQoCPxPl+4wGbKiKobo9u?=
 =?us-ascii?Q?Q4Hrf5U5HsBJpJcTUKkHRMpKrftJ5/R2l9a+u/ICwbmDiUbYSCOhNRzDT314?=
 =?us-ascii?Q?yFgBAU/c36H0sjqjBdW+AXvi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f256c82-35bb-44d5-0773-08d927b26eaf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:38.3995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kpCbJjFtyWf5Y64BCw2aVg4stDxSMeVRa+wTI9RPcl7XZR0VHH98PEZCGwai01JBZ7g3/X61jRTbIXzt+OlK9Yejk3cYFLfyZOnNpItkeJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
X-Proofpoint-GUID: pQ73UTLWaL4CMmNfVu7d4xyHaj45Tsej
X-Proofpoint-ORIG-GUID: pQ73UTLWaL4CMmNfVu7d4xyHaj45Tsej
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
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

Updates since v19: Added Darricks fix for the remote block accounting as well as
some minor nits about the default assert in xfs_attr_set_iter.  Spent quite     
a bit of time testing this cycle to weed out any more unexpected bugs.

xfs: Fix default ASSERT in xfs_attr_set_iter
  Replaced the assert with ASSERT(0);

xfs: Add delay ready attr remove routines
  Added Darricks fix for remote block accounting

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v20

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v20_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv3
In order to run the test cases, you will need have the corresponding xfsprogs

changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v20
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v20_extended

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

Allison Henderson (14):
  xfs: Reverse apply 72b97ea40d
  xfs: Add xfs_attr_node_remove_name
  xfs: Refactor xfs_attr_set_shortform
  xfs: Separate xfs_attr_node_addname and
    xfs_attr_node_addname_clear_incomplete
  xfs: Add helper xfs_attr_node_addname_find_attr
  xfs: Hoist xfs_attr_node_addname
  xfs: Hoist xfs_attr_leaf_addname
  xfs: Hoist node transaction handling
  xfs: Add delay ready attr remove routines
  xfs: Add delay ready attr set routines
  xfs: Remove xfs_attr_rmtval_set
  xfs: Clean up xfs_attr_node_addname_clear_incomplete
  xfs: Fix default ASSERT in xfs_attr_set_iter
  xfs: Make attr name schemes consistent

 fs/xfs/libxfs/xfs_attr.c        | 910 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 403 ++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 167 ++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   8 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_trace.h              |   2 -
 8 files changed, 1032 insertions(+), 466 deletions(-)

-- 
2.7.4

