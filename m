Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD42C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2766117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbhDPJTA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhDPJTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99sE1026295
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=aeSdkEQzyTTtBBjtPQK6UCqw+niSPnkrfcXaPRD5WmA=;
 b=OqywIioTxYEO0QIIwbz330Q901Th5Y+dxlLpJmPKzy+Lb/SJ7XG4pj1fht+/frldGLAD
 yGOA3Fzqiv1zUTfsj36twsNMEBsz0EuU0mJcgcG6QpVx2uWsENjcFReKzQFbqXHI04X5
 q6DYw2QvjRc8kL2GHvxpVHao6ENVgHwKrxf0t6YNtJS253RbpXiTW8GYm6mcgxh6BpGp
 3MpXfxv3/kHFo+GNqIGDHc9IxOGnDtA82G+Re7IUQBApnMhZKRkl7Fes1UKp9fzMMdg+
 nymL82idjEO0YIx6sgTHg1jZKsQG1/cD0zYJBqsh3K/gHnTbp7FfBx22JERprXur4CFw Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnrh8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99dBK182009
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37unswy4uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2Zrd3+HAbd2nPIFewy2b24b606d/LXUJBKLRIel6cznh9fz9DXvhQNbX4sm1Fy1jxQPhVLPSJT7uLsNKZA9Ox9SFcJ3e8bThLR/Jad7IdntHVrI6HVKUqDMjLEZKM6ErcgCbkIwscI4xVG582FnXQqlOkaQZFOMmeyNG4h68FKR8dhumnKLZ+wKE299TXjbKgXPNbsxhaHBtW0NHtVfXiXmc1YUP/7LmBFKH1KmTXIBh+vCsjxT4KbEdFvu/RcCEQpfbry77n6b+qNu4UshWU0OUze5ZOJG5iNZ0YYrB5JT/6VQ3aBzvdqhdvMlALsIXchZgZ/oCulYTP/SehItLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeSdkEQzyTTtBBjtPQK6UCqw+niSPnkrfcXaPRD5WmA=;
 b=lDvEUqsLAuMJ9dBUd7nK1r3MNazAN6WgrFQJu71Jb8X5qxUrYHcX1NcbGGZaB+z8s7D+pOf8QXewWTfFU/ItwEaz7MgdvdFHQL7P1qvHaFKuT0dQfFVeT0eKAC7MfhP69SiFP/DFYJhr0rnUYM8vLfRaxeNwagS8j/ssgq+QBQdVBU4YnXOMILU0BdHmdZavFnV8h1fqxcedAlau4FNv5WIv31XqOE+Dj8Ved9hY5KPGUxTO7yNhZ4NPzaI0TjGNrMqGSTeZ2E+UvPg39sVl6SbjakBxdWvfvCPwqQlVvsRKQ7aY/IR8bzqJqzdIXEvoW9K+ri9jmZJ0fQN3DLwdHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeSdkEQzyTTtBBjtPQK6UCqw+niSPnkrfcXaPRD5WmA=;
 b=xIAoDgGWJQGC8Z71JeW3VmXFU3Oz3E6Peu/bIPAlECzYql6ZzL4orF2Tas+nmGYjs0HdrGQ4ZsV5DC7KrWw8f27/CVwvY+Rfvzgah1p35pN1s2faGsZquIZPbp/Oq/NDkBeSRQejrQhT6ljmIHxeqZHkZzMl/CmhPEsppjJ1pTg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4800.namprd10.prod.outlook.com (2603:10b6:a03:2da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 09:18:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 00/12] xfsprogs: Delay Ready Attributes
Date:   Fri, 16 Apr 2021 02:18:02 -0700
Message-Id: <20210416091814.2041-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51666785-4fc0-4801-85ca-08d900b89a23
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4800:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB480078D9ACFFCD30A7A89FC4954C9@SJ0PR10MB4800.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vf0GYX9DdmdSZMgF/5MLjzb11i1enqOSDHmqy1fJZhtaRIRo3sMMEKf2W/kXwuT69727JoPCi1RNxQ2T7ftyCgp9xsgwV70asLU+2rdglz1uCV+QyzTORpeiT8hCh7mkNv154PEpcAqfbW/i3bndiVUsowdHTTRsA9AAuiOhoDc/UEtip2bkFJY7l1y0YLxcVhhVVdWgXk0lc2vR+CDJqPUpz8ApY3lF+sUDAwKPAlSCV1qM3TUwld/XSfXNWcnjUOSopgSqSJEg/i9uEr7+m1lnnsb7cxyhGf8fhlk2IvJ4NIKiIKHkt/GFNG7bEOu74d2rCuA9lxdJkPkAeDPlSt0pUH43T1wehM3hvHie6fLbv+inFsJcR9mp4ReoYVkZoVeIBbRAo/v44bm/rJ0VrLMZtNFZZIgI6MdqnBiIP6IJxcjBJcnppweiS7BCTlC9kqj2JE0U6WC20fTjppOgj4N6K/9XQe8rE8J9LZfv0GkTeRXZD16zoCR5qJqT//VKHs69GVYAIgswAv40qG54zdS7Rin652BtbpLQL7f5kcVd75XonOijbOE4KjJkf4fgQndRK5SRnx1I8ZCmawEdTj9rx7NoEOEJ3eRbZleX7jR+rAfxBNKMNbktTT6ll6RuBsao4jed0ullBvPQv7MRFwN6wEceE90r2VC4hBpv8cQgE0BNBKTWuxUz08zBRRpn16/YtYCEZzompHbDIMErFJcBFvI4nzo8rKXdlAOoED7hdvGX2/YsQ9yjwj3cgHCPnj/TgIewJqCU/ihx2O43LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(136003)(39860400002)(1076003)(83380400001)(6506007)(5660300002)(16526019)(186003)(508600001)(316002)(8676002)(6512007)(36756003)(8936002)(26005)(66556008)(66476007)(69590400012)(44832011)(66946007)(38100700002)(38350700002)(6486002)(956004)(2616005)(6666004)(2906002)(966005)(86362001)(52116002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JCNxwW8oWdtlwGAgtH01Sm1kmECSlP3miTiSIfKNeUumlsryuoZ+Xvzqu+m7?=
 =?us-ascii?Q?X5V9jZosUiLGIuv4jtCqgnUfX2nDHWAZ7Wc2U3StXeJkR/7uu/qXtvwqxm7W?=
 =?us-ascii?Q?LMbK8K5PUIR9b5KFuOa/GPAlRTH/CUOVhdBaT0LWrpsvUaOnWMmMTFFAPfH8?=
 =?us-ascii?Q?2SLNLuHAmkmSYsUTd0gyC//x4c8w2QyRhmcU2H1Lt/oxH22AbxY+zr4UV/kD?=
 =?us-ascii?Q?rmWU6nKXUdAXj12FB06dEnaDVaCMKKMabHd8hIK+86+6jsc27W9BiUWpzuVt?=
 =?us-ascii?Q?daAhHLbxYYa4OQyVj39BB20Ne2iQs2AWj6WYP2zNuxoSOecRc358rZbo9kMX?=
 =?us-ascii?Q?GOd1zKgd/x+Nrv+rH5dtuOrLSoT0y8ZPUMbab+ojcQGty2Urw821tZvvRCXP?=
 =?us-ascii?Q?HlYst6MIT6Qadaho2F+CJf5ssiSc17BYRMXAskgthFa2hFuqqrSq+30dFrYA?=
 =?us-ascii?Q?T2JczSWvM4IZrq0DZ8wevetJMd6QTBeozLwEaVnm+m0bINb191t6ryhxYvaQ?=
 =?us-ascii?Q?pUwpbJfxGMW3jkfwzTAeKJ5wgYIWI0jrzP/P8Hkm8zgq5HM0qVo4TCGwJ2x6?=
 =?us-ascii?Q?XlOLcwxhWQ4qpEQ+s+RN+8pv/WtNWvY8OVH0XgWG6Lj2lzQ3hIpJSRlS+3K9?=
 =?us-ascii?Q?kEFW78rANZxHB9kcwXiHVUCdpyN3II6n7I+l+BT1HLFVyMRiZ+4pAr3jGu/B?=
 =?us-ascii?Q?F9juOtkZlgO1wt0oLVI6THrZAaj9xHDIi2vUTFH0QNyEzO4nsV3revSBCNJk?=
 =?us-ascii?Q?OtsV+oiJ95weorHKEh+rD+Xfn9bd2aR/zcIV0DrRa6U4f4YYPT/IdCML8wA1?=
 =?us-ascii?Q?8C0pfgpvh4bIF9arT5fEBblaqp5Un2sLi1FgXciYItccFZcEzpma9Y8ZU0G3?=
 =?us-ascii?Q?Wz1ag6qganYdpc47kL2WEmEE28eWES2YCbZKYA3hSWFFcwPk/NSpTU62Nzmr?=
 =?us-ascii?Q?P0lv6COYvwRhj6XHY0DmNS5pUa/f6MbN1PcAotryKVc+aFaBOO9C9Fdipti5?=
 =?us-ascii?Q?3Y3aJ8t+eTwdHmcU9FB9n9LotEVs6mcwpehDCa68HfftNR3EpDSKKFvAKfMf?=
 =?us-ascii?Q?nia/8tCfsxppDBIRI8PnpcrN7VchwtSBE4TjQq1d9jRt3L/aKEwvXLpBGpbB?=
 =?us-ascii?Q?X9QzHJ8GwZWtMf3UDukjU5I35izgQ1va/RjJKOrQto1PzZXlURAg5RbBjyRI?=
 =?us-ascii?Q?NXfjKFf/TAmw3oj7ri+TG2Ecc2LTeEktV8Oiab1ShI0lYtqQYFMj8nOjxoau?=
 =?us-ascii?Q?n3xqpxiIYK5UoKPRydKhMsrsWV5G+kIf3Y5thWh9L7ik9MrRZmRu8I7xSbAA?=
 =?us-ascii?Q?IZcBQcB9rhNY4NkdFxwyydtQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51666785-4fc0-4801-85ca-08d900b89a23
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:31.1041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oy3aB0LZXk7gHYY4c3UkFCP9yYbkxZjPDhhJx+KSjD6RT5h6l3uZyin4OHS8Z4xnDYQN3mwqscPnVSWb0wMuHKXNacEyxwJeKbU3GMKzd84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4800
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: wbt9sQ0RZ4jHZc2MwqTGEwgUIA8BrjDY
X-Proofpoint-GUID: wbt9sQ0RZ4jHZc2MwqTGEwgUIA8BrjDY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set applies the corresponding changes for delayed ready attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  This set also includes some patches from the kernel side that have
not yet been ported. This set also includes patches needed for the user space
cli and log printing routines

This series can also be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v17

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v17_extended

Thanks all!
Allison

Allison Henderson (11):
  xfsprogs: Reverse apply 72b97ea40d
  xfsprogs: Add xfs_attr_node_remove_cleanup
  xfsprogs: Hoist xfs_attr_set_shortform
  xfsprogs: Add helper xfs_attr_set_fmt
  xfsprogs: Separate xfs_attr_node_addname and
    xfs_attr_node_addname_clear_incomplete
  xfsprogs: Add helper xfs_attr_node_addname_find_attr
  xfsprogs: Hoist xfs_attr_node_addname
  xfsprogs: Hoist xfs_attr_leaf_addname
  xfsprogs: Hoist node transaction handling
  xfsprogs: Add delay ready attr remove routines
  xfsprogs: Add delay ready attr set routines

Gao Xiang (1):
  xfs: add error injection for per-AG resv failure

 include/libxfs.h         |   1 +
 include/xfs_trace.h      |   2 -
 io/inject.c              |   1 +
 libxfs/xfs_ag_resv.c     |   6 +-
 libxfs/xfs_attr.c        | 907 ++++++++++++++++++++++++++++-------------------
 libxfs/xfs_attr.h        | 401 +++++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |   2 +-
 libxfs/xfs_attr_remote.c | 126 ++++---
 libxfs/xfs_attr_remote.h |   7 +-
 libxfs/xfs_errortag.h    |   4 +-
 10 files changed, 1047 insertions(+), 410 deletions(-)

-- 
2.7.4

