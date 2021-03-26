Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19086C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C9B61A44
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCZAb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:31:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCZAbo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PObj040752
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=gdhw8h4Ds/XxuACz+SlpHuYDYRzamqedhINyR6g+MM8=;
 b=jNparjQ/Q6NBiNpWqmCh/q3DBb17LPf057eNjpEEYvE+N35xD1Br+GexGAl7YmgVukxd
 eGHsd7ctG/WZsKO7t6jRex4VfMvVUFFQCWEgUWlAys3uTF/h/YPTklNa8eLqu2z6L8Mv
 nmc5ZTrBV7sGHZI5Sy7inXlHR2/0MCqk3hQed9hDdXMCLlWgyY2Enmseyh931GeJ1dLW
 uAy6uRHQj4MqXghxB4qN3AZzln0WZ8VaU9eJgs1jAALLJ2vFOiEOkG8/UzjGi4e2h7IW
 elUoz0WpWeKpeIf6gJzJ6td7zkjmtAE2TYeM8lHoOaKKmNJNN7IiOy9ugA2MLye02A3c 4Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37h13rrh86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6G155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ox7u46hVVc5MFpkmuUx1YW7c0ielYWguBiMro7tx+z7aobt3ieN9yhHpxDKVdpc8GxN1Jesk/f7bchmMLVgheFblgVenU0eyP8D/6zt46mQXedk9R7Tki7JNLKr+A+csPz2BkSySodeWy6nTwguUZK/LwHZ1VkUhSLLtEcUlc4gCGVAHahMN7NdT+NJqIpR4KdTmAXWyoBVVyTHDpX97GCqfN4wmFzz6xlVEOmaW0P9BS+8/INwdJXG+r8qDNPpFp4BgVZHVJ9AfLNW7n2RXSI/Vm+iIszEXFup4csTG0hHOS7oVPxAKh7nn0xYfX3aehM22Du6fcBXROWYEQTuVNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdhw8h4Ds/XxuACz+SlpHuYDYRzamqedhINyR6g+MM8=;
 b=TCt3hWp/4k+PdEPtQgTL414NHAJQEuiToXVFtJiKqa17kfGDv+VpW8G+ZuJcRbkF5V8cg+Fvg6MFN3YLAUpD5m3LvxrQB5U2hf/GALgjfLeUS0924F0o+KJFeytJh/rxoHIZu+j87jScHOSSPnu+gsNmhk+F6sr70cdu+qO5F3BWZhUsyu0cyjJMYsYuFVBcoD/lkedA7dGz3Yj6hp0KS7s3pDL3Jlq6VCU27fE+i9VnyOinSI2+BDPiDI8MgnsIBlkCXufD6CRtohmJqKF5873yBBCTw1DKLW7CpAq7v5HFIqBfFIPbiHfDTwZwHSZfCh3oj3REdGwf212ek/Y2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdhw8h4Ds/XxuACz+SlpHuYDYRzamqedhINyR6g+MM8=;
 b=Oo8wYUCst672tC8/JYqqTwoFAqO5LhY0YRGDA5YvZxkuSUDtlltoTgJUZfKZmfZucLTftNpjYRzO9Xbth2hCyCwVZoGZyL7WGoYu3tAWdqjO8/SJ8/kCYX5fQ1yCn7Ug1jJHNG8hYxJh6ai/2k3sIx4IOhltip2KdZdil/wpxwQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 00/28] xfsprogs: Delay Ready Attributes
Date:   Thu, 25 Mar 2021 17:31:03 -0700
Message-Id: <20210326003131.32642-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aab3ebc2-ee9b-4846-f5cb-08d8efee86da
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27588C5C1B6A297BAA8AAA0795619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tn+++ROpQ2Wd0utW+Pwy4OFNX6wmGeOhw5MwkQELcwIULaMTKxeyzmpcOSP/Hq3QhYWqz4X3xLUBi1lwfgWOdwoaD+x7Hmv8JKEAwEt3j0M2RxfoTRuk+i6bP9d1mBeUNWad/Aiv4fnR4QR7vmxvI/akquSOPRQVfWAYWJAn3t4IVRRXh3HVypNKwVpBjwH44m9UIbPj01UNtjW/VRpHcVoAGFCiJbG4FuWK9RktGBZNTHELS52LdNVnE6CL2vLxxDSvjljqwJt1EK1deGRpnTWKbixVm2PNyW1WkxTkpWDOI09ddwQT7HrV8wfabbVYeQj3GqSYm2R9f31FIzAkP4yY0SI097OXTUUDMzdX2L82z/ScL+YqE1YNj7MrOtV/a2oBkiQwc1WjdBw4UfrnBVn1K6y+exTxnQyNy5DR3pRIXrFceVlgJCnRfD/i2JBM5XHLf6TudVljiaQV7SQj1IzP/R6eC6+74oWURGoNCS9djCNoPFsG9OtcE71r4sYBD6LEIJGp2F9udj96E30B+qFkrZ2XIT9aAyXBGaUIHqpWMmcBcD8KCmZqyYYcWwxvS8NIUDGcxnuw1KGpgog4KKMWbD0jJSnIZWSYEmMhMUZeME+barAquCy0kvpFzjffHTN7G5guOniDGPqNbBoVUu1eO2nstz8A4qdVGFnTtzD0VmnV3doVDe4/qEt80aPzZSdLu1CHKCbJIGubv4QvOaHqAcaRIwAMikAkiI2vFb3D7NWpOvcbFL/pTd4UE/+wWc4Mt3Cf7+rWI3j68Sn0gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(966005)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1gWxd705ZIlyZNYQ3FBBgUqdwXE0tzzgS8eBHgMl6QCQxmtNHx8Wm7tewO8r?=
 =?us-ascii?Q?1Q0HYNscLHEumf88GxhFzpWLfS39m68i2laCm23VwHZuZ6yGmaRBRP1s6zzH?=
 =?us-ascii?Q?n/0J2rB14sc+p8AmAHlGGbaRoP6ZtxB4Ho5/Gfy/AM/SeVNcJk7HqqKHVNcb?=
 =?us-ascii?Q?BO8sKnKKgL9OnamdGdpaMQZ9chly9RW0qElUDPxU7oO64aLDkhPx5V0wEBGy?=
 =?us-ascii?Q?+qva6+K4z7fczH87zHnPURVycEDgYg+v1oZHK96BqDgj0nggAk5MlVBQM2vO?=
 =?us-ascii?Q?tO1WBm/ciBypYjAEHrp4WV81tYqTkko1BINU2+y1Ox/xlepbvlL6annyQdgQ?=
 =?us-ascii?Q?wgan81qCwJwrzllp1NEyXd1V5yNV0uqFBRHbiACBYbpsw9AqWI0HwtY2TmPp?=
 =?us-ascii?Q?E9XoNn/b1AiisTYcwdfNVjWYClzGSvgfODUPH/+RYbcIMbToajDf0kW3IG98?=
 =?us-ascii?Q?IYFjlttEv3+Aub30vO+aliJpXZOsUnhQ6yEWQL6CSrxG//Rw2dTwV1YecEuD?=
 =?us-ascii?Q?Hz3p1CMX7Qj8uSyjzHziqQER6z+mMaXTbJu4qSs7n8yYd8/yN01x7OjzTGtN?=
 =?us-ascii?Q?9LLW360iPmqEgoQ1a89hq+yO+OgN472N9blbbMVBAYggHtvbnyyVfU0wWxxH?=
 =?us-ascii?Q?kWGfcgrW0vgmS1lEQ6BGJ2yJHhCdAjLP3xb3xRfDcBEuq/OX90HTKM9AxkmJ?=
 =?us-ascii?Q?CRvQZdwQfoWtfvNVDY3FkrCBGBl2Ph8LneC+vm4ZlZYSIVXiK7l0YcYCoslm?=
 =?us-ascii?Q?Zrm9pwxyFbhOQYtwct09TtCXmaD4M2K3KnQP8vhu5dc14v890hS3ZKoyoGcA?=
 =?us-ascii?Q?bhaRWuVDLCaWcFIFGi6VfecHZtxJLW4jBJmRVDEfNMu4A1JV7n52x9IZIn4a?=
 =?us-ascii?Q?p8tr/EvxlgFcNpcnuCty+KwuKM+HqkpFGP7toqJRSiKGrLoqGJYheA8iMtZ0?=
 =?us-ascii?Q?g3d0J3ZI0orramrVbs8k3tqhS38D7Te6PMOu1f3b8nS46CDXSoBo2nVwGT8o?=
 =?us-ascii?Q?ax9w30L/X+WpcBQmqQYPFrl+EDeTDR/zf4iYYqlTktLBbJDdeUIjgrGRCOuw?=
 =?us-ascii?Q?xxa0zyP5+MB1K5ek3L6Ezh7a9jKqzbOs10HsXFfQXXBCryTPerugH6nm+nX7?=
 =?us-ascii?Q?3wI2cMHwVYMnmucG5OOUi3/8Dt7cDV/A1scND8ksKw/j9QYf924GeQTJ1g/l?=
 =?us-ascii?Q?Wxb57fQX9G3zyT1sIIgHgszfZODTrU10KVToTegH8TO4YVCLTItOiZDnJXgj?=
 =?us-ascii?Q?VmzvRqJAkii65dMl7ER944OyBGs21oxkxyunskbgAxEtU9mmlWCrFTbYG4Nv?=
 =?us-ascii?Q?17UHVdGbkWl9NX5e6nyhw4uQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab3ebc2-ee9b-4846-f5cb-08d8efee86da
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:41.8040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dncFaYaHHBfWje9++RXWj33njAigLgdOFtzSDBg0VbiMO55P75wN+ReAqQKELBz4ows7D4Cs9Hah20AzRtrjlkcuBbinDGTv0Za4/8ws7IA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: JC4wdkNK3ik6u__9IFMT94wT40ZANhma
X-Proofpoint-GUID: JC4wdkNK3ik6u__9IFMT94wT40ZANhma
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set applies the corresponding changes for delayed ready attributes to
xfsprogs. I will pick up the reviews from the kernel side series and mirror
them here.  This set also includes some patches from the kernel side that have
not yet been ported. This set also includes patches needed for the user space
cli and log printing routines

Lastly, two patches ported from kernel side needed some minor modications to
avoid compile errors:

xfsprogs: Introduce error injection to allocate only minlen size extents for files
  Amended io/inject.c with error tag name to avoid compiler errors

xfsprogs: Introduce error injection to reduce maximum inode fork extent count
  Amended io/inject.c with error tag name to avoid compiler errors

This series can also be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v16

And also the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v16_extended

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

Chandan Babu R (15):
  xfsprogs: Add helper for checking per-inode extent count overflow
  xfsprogs: Check for extent overflow when trivally adding a new extent
  xfsprogs: Check for extent overflow when punching a hole
  xfsprogs: Check for extent overflow when adding dir entries
  xfsprogs: Check for extent overflow when removing dir entries
  xfsprogs: Check for extent overflow when renaming dir entries
  xfsprogs: Check for extent overflow when adding/removing xattrs
  xfsprogs: Check for extent overflow when writing to unwritten extent
  xfsprogs: Check for extent overflow when moving extent from cow to
    data fork
  xfsprogs: Check for extent overflow when swapping extents
  xfsprogs: Introduce error injection to reduce maximum inode fork
    extent count
  xfsprogs: Remove duplicate assert statement in xfs_bmap_btalloc()
  xfsprogs: Compute bmap extent alignments in a separate function
  xfsprogs: Process allocated extent in a separate function
  xfsprogs: Introduce error injection to allocate only minlen size
    extents for files

Darrick J. Wong (1):
  xfsprogs: fix an ABBA deadlock in xfs_rename

Zorro Lang (1):
  libxfs: expose inobtcount in xfs geometry

 include/libxfs.h         |   1 +
 include/xfs_trace.h      |   1 -
 io/inject.c              |   2 +
 libxfs/xfs_alloc.c       |  50 +++
 libxfs/xfs_alloc.h       |   3 +
 libxfs/xfs_attr.c        | 916 ++++++++++++++++++++++++++++-------------------
 libxfs/xfs_attr.h        | 364 +++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |   2 +-
 libxfs/xfs_attr_remote.c | 126 ++++---
 libxfs/xfs_attr_remote.h |   7 +-
 libxfs/xfs_bmap.c        | 285 +++++++++++----
 libxfs/xfs_dir2.h        |   2 -
 libxfs/xfs_dir2_sf.c     |   2 +-
 libxfs/xfs_errortag.h    |   6 +-
 libxfs/xfs_fs.h          |   1 +
 libxfs/xfs_inode_fork.c  |  27 ++
 libxfs/xfs_inode_fork.h  |  63 ++++
 libxfs/xfs_sb.c          |   2 +
 18 files changed, 1374 insertions(+), 486 deletions(-)

-- 
2.7.4

