Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA9BC4707F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19665610A5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhEYT5B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37892 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhEYT47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:56:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnO1T034973
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=oBjMvtUhzlyLiVQZY22j7IyTsPVRZxtnYY+lrGu+vBg=;
 b=CMKnFYT7Oy9pT12dTSDjweVBhLzAu7Ie2AL8n7WQAZB4WqTzji+coEZeLq2ewPjYZH/7
 n9pwE0iumoWM6/vGJAkUf07wR6w5XV5uyjMvyx3WInDHHhH9SHD/TXHUqsO6nWS9B0GW
 Bcjz6ZOy2Xo0hc8/05hZSQLRUWdVgVTO0wQWINLDqYvMkM2nulAYADcztQWAaSMxywPJ
 OrznqsPKHOGtygBQ9rGXQavZGpNL2m8DaXmaWbXC0KAO9dSXQyGwd9MbWYsIF8J+Ht5r
 ER837ZCZMzGKPbH4M7VJYQVGgFmlECyKTsDwsfKggcL680+wN79YODoTObRzUFMGubw0 Tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8xkjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJotnR143650
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 38rehawt3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0xEM/TdW9OCZbvp7dPi5pUBPJrlHCaj3+tmcVMOWjAcaZ7p8fw/PkUmRJwD9JD8waR9kM+qIos2Qd1zsZAIANI7aOH4xyTsoSriXs6uBDN+AiPX20jXfKlNwU+G48isHSh8nSKbS8wi2IQatObdW0zeaqnK+ZDiVgurj/y+rB0qEmrlxOuj/qpE3oCDtpruJ1oudEDRv2lJTUkNpNS8UKl90SMuGjyuJf80d3fH6GQQfXGevss3/lKumPXRS0SQFBPMiI125BgifksxweShrFmxSFnJ+MKrSrtBgJCF7XOa/qJ300uXI6lvQtHn3RhL5qqJXRAg4EjoOG66+MCssA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBjMvtUhzlyLiVQZY22j7IyTsPVRZxtnYY+lrGu+vBg=;
 b=QMh06CoPkzPRhbKwT+j8iAy7Ys4jG/0+S49eiyb6Sou1z08lbVp1mFH6FN4ETEk71v+UXaZXfH3MKJxorQBrsJHvodZe6V8v+M1AN68n/b+nS7yUU9JkNmNoFoubSFn+iUUxfXcP/w2tzuqJ1JGQcLEzDTfD06yS+albO/q1DXFQoCPWrcbU6PxY7xYbxj6k5Ze1uBEnkAGkNCGIAoSGut1PQ0aQpoFtatUUTQCI1DGwYquQQNNKr//cp+1fBWZ3r0icTsZZLXqt8FAAJ9kDn/vB+daaTgHzN109BqV6yhYdT4fyMrgFVynlJGssowVaPL7wwZEFQTQIsxhc2JcN5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBjMvtUhzlyLiVQZY22j7IyTsPVRZxtnYY+lrGu+vBg=;
 b=gQPMEMCgMrzeIlaZY+VAOK51iK2MhCyHV5NiUJRC+MNKPyhWO+rWKJn4fW6O+xEOyeXO2HTUI5O7MavmPtZrRfTjT1kJavjDpSP3wMc/A+Jgh4tMeaNNzoRh1kROZiwUMop3nLZXraCNJ56kK27i23pVdxWRDvPBgbIFpn6bpg4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3144.namprd10.prod.outlook.com (2603:10b6:a03:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 25 May
 2021 19:55:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 00/14] Delay Ready Attributes
Date:   Tue, 25 May 2021 12:54:50 -0700
Message-Id: <20210525195504.7332-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83582875-4281-4714-d3a6-08d91fb70a27
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3144F844648F454F28CB3F0995259@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ORw2HPsxcp6UiYj156xspnKtLpm3x6zSGt9bxch2P14PqdcZiAmT1/RpaIh/6fnW5ysUy0oBUSXmewUFdI5xztrB1e15CHugxJkou1DvfwyHnW7W3eEmEOoTxBzJMpCb0Py5ZYKOABx0TxJlphex3HcQHa87rdA/RE5MpkSIH+rQSebQKmduN2tFa0/GyG3JvdRzd7LOriG5EyTaDSo7LVXY4zpAUnPXdCN8S9QmVvJ2QKkWeZHI+ZlwE8XCY7gTETCXGKxJdy/skgiE1fWtLWsfyPkoQke0WqpXTwFzAyWEEjTsr+9Ztfe3WHwzM/o8w3+ZeL0b3n+xBpu5P+D+8iFWxg7hKITi9uaOdiARrlKsLJsdlNaMROnN7zDIp5J9iKaFXKcKy2AnKfxvzGSWKpKx9G22KvJgfKwgXPBIC1JNNOR7Hyxyodnbb0QhlebXcxiqXoVbjRj7NBe2PAwjDejzZ2X2MXkJgG3lwGM9mF1/plG19NwfNxl1XNCfp0y/xY8t6NzhM6x/MoqjbOat3P4G+pO34RfAihOlB1dIFQ2Kj+PL05+q61tPWPYkszE01R8TWhPDHij1fSUliHwNzOrkLxxA8xwFh7Y5W3Osw6SqMJaukDaeN2XhaRc0IyhwzV5B9yutj/Qy4lrS93oMj4vW3eJtP1TCLAGtQdZItu8OasbsObI7OmHjBDfPe5Fd+l0Cind1YGoyJ3yFATKebqwcqM+oRkSx3ua7E6CLcZuRtFTyAjB8WwZrRNU0MdtE0TvSjqJBoP0jNtLJWGciF4invAvrC2Kd96EtYLUZCoZHFD8lwcDeFnTkc9Kk38N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(8936002)(6486002)(6916009)(8676002)(2906002)(26005)(36756003)(6512007)(38350700002)(478600001)(66476007)(38100700002)(966005)(83380400001)(66556008)(6666004)(186003)(956004)(52116002)(2616005)(44832011)(86362001)(16526019)(1076003)(66946007)(5660300002)(6506007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?C3rBcUuVSrFxxLTt31vVFkrKuceLsGluNKmEcI9qYQOFGt/0JCpOkzV3/D25?=
 =?us-ascii?Q?ERQMzMPD03EPM4QH2o12qyKam6yiESM442/9UvHZ9jJfzjb2oSdXJcckz2aw?=
 =?us-ascii?Q?4yWg5AnvLan4Nwv1oN3xR4epjDUJwR8Jy9S5DP2FknB3t1SP9p5D+iKgjTQu?=
 =?us-ascii?Q?cYhgvvW9HCaRKzEA2uChQO54taUX0Wi3ODo72vsMH7k4yId64tp5YMpMEnuE?=
 =?us-ascii?Q?/6D3Y8kOT34JDvNBQxAZyI1QLLNc/iroeKI2tkb1kb87n2zLXDNXnlvHoi73?=
 =?us-ascii?Q?92zMm5652w3mhdNS3Cw+mUVK0I8uOwrzkxHYO3jEhAIQF/e5RWwUqO6OPsF6?=
 =?us-ascii?Q?Zbh/UovW7Z8Nw8AG9gc239/JLIt7iJnCFH3/aY5MkcAR5jRCpEmQ4hQI01/S?=
 =?us-ascii?Q?NKFkEQc8wVeyFJiHkbeo4PFQV/1SJ0qen6bPz3oBzOwypVBr1CH4CG+Ulg8o?=
 =?us-ascii?Q?ckFBY6En5cDgAMdm6OnIwAK8AqYUdGFH2cMHnGxdSdvuzrGbQozWQl0mxYuX?=
 =?us-ascii?Q?aLgHi5+fp/2HeRr2MdnYv6K5AbFSuK+WG8WXPgU/rmNmCpRyaHZpbtPSO0gk?=
 =?us-ascii?Q?E7edb33m2TOUkmzOZoDiHOAjvhSRk3lPA92V+RmlYHcw8H2h3fIXooBehp8c?=
 =?us-ascii?Q?wc74zegQR6HZFAKDTbREri6X/83tcfef0n4yKB6rXKn8VzVMbJMk9sv4A8ik?=
 =?us-ascii?Q?93KgP2JzjLfJU+z8sX9C7r0XhFnhM5p5zO+6X4QMbpZVoQEapHsTy4G7TAZY?=
 =?us-ascii?Q?O4u71DYKP5+a6EPVipNrBcSCGoisEiBedbQUEIch79I1kYrrzDBMIMZu4TB+?=
 =?us-ascii?Q?bVLKn1LNaNWvv3VsT6NzzwbydlLd3ayjOGgadWKbQuFcPL8bemMacaiqYcMv?=
 =?us-ascii?Q?aK2PO9ocagKRPSsdx91QvcEaC4diQFWtxsvb3ceAHNUCYnVQVUlTqpy4bpeu?=
 =?us-ascii?Q?4MLs0Lz6DQSFsTMexQcFAG0/viJr85hC7ZKR/7m17ycCx7nViV6CTDJozFdl?=
 =?us-ascii?Q?gcPBxVm6Ttw/6hRi/U7uk0ZBqlhfM8UaV7DeCd219ThpJDz/pOLfMf3ZESVK?=
 =?us-ascii?Q?TJGkWNfYyv3HfvbegHVvyHEgCW1NDerP47m7QBJU3Qh1IgsrqG6PaA40uBL6?=
 =?us-ascii?Q?hbjVv+E0YG6uFC5kwgn6TOCWmXbZrshQ+J8BcTWVnWwFsxRQrSEpn3BsfP4/?=
 =?us-ascii?Q?DDHe/0YoSJ54Rhmv4ZDlAL5Gcg5qeo2U/8Vb1ydHUTZ2uB2XxFYBpoIBHfEp?=
 =?us-ascii?Q?Qjpm0qCdZNUiit6pdyP3r4tk9M5Kp2B24SplV+x/aw0siLqO2oDjnkZury60?=
 =?us-ascii?Q?mLXxuNh2QphLgKEFYfIFU9JE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83582875-4281-4714-d3a6-08d91fb70a27
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:26.1306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lP1zL/kCa1P/bJvPMPpi0JGdVJ4COfZNnw/Vkf8qC0d05wzgxj5KkUBrcNyDFteyC3hsWlBIw09OduF85mc5ly/qS2UF5fwo4O1A9QUNAw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: u6Ow-aM2zjKAnEimBsj1-jRv1SlQi3fd
X-Proofpoint-ORIG-GUID: u6Ow-aM2zjKAnEimBsj1-jRv1SlQi3fd
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
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

Updates since v18:  Very minor nits, and also some additional clean up patches
near the end.  Patches 3 and 4 from the previous set have been merged, but
otherwise the same.

xfs: Add helper xfs_attr_set_fmt
  REMOVED

xfs: Hoist xfs_attr_set_shortform
  REMOVED

xfs: Refactor xfs_attr_set_shortform
  NEW
  This is a combination of the above two patches
  Did some white space clean up, but all other functional changes are the same
  RVB's retained

xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
  Indentation nits

xfs: Add delay ready attr remove routines
  Flow chart and comment typo nits

xfs: Add delay ready attr set routines
  Flow chart typo fix
  Indentation fix in xfs_attr_rmtval_set_blk

xfs: Remove xfs_attr_rmtval_set
  NEW

xfs: Clean up xfs_attr_node_addname_clear_incomplete
  NEW

xfs: Remove default ASSERT in xfs_attr_set_iter
  NEW

xfs: Make attr name schemes consistent
  NEW

EXTENDED SET
xfs: Add helper function xfs_attr_leaf_addname
  NEW

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v19

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v19_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv3
In order to run the test cases, you will need have the corresponding xfsprogs

changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v19
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v19_extended

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
  xfs: Remove default ASSERT in xfs_attr_set_iter
  xfs: Make attr name schemes consistent

 fs/xfs/libxfs/xfs_attr.c        | 899 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 403 ++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 163 +++-----
 fs/xfs/libxfs/xfs_attr_remote.h |   8 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_trace.h              |   2 -
 8 files changed, 1018 insertions(+), 465 deletions(-)

-- 
2.7.4

