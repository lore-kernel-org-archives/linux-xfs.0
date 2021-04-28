Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8E6C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F366661419
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhD1IKT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35790 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbhD1IKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S7xe7N010131
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=BCniwxsaloKhPIG3PtI0iZ+EER81xUo8hZgJVFX2HQI=;
 b=BSjzqUdzvWexBgDxEh/lO25//ZUiCErmMIvC6aQaJI0Kzr3ae7t9JOr9rp+WjCUwo4At
 rFHwQ/lFCsj0bMMqpfhdHMfZybGqjwf1y+j4VTM06P4rvvBQv9HgMlDLHiBhNtNsQCrX
 I5/PVygnQTYZHDTfiiuE9q5BHfQmfc0Q4vxjqT+I8Owks3Hx1sPuv8grprscKGN+ord8
 Y4nTHoQuWUaP6s9LTPTIkg7BVBZnMgDiPdw9GDLoC/JfLnepOwFwlRx0QORxdlg4tCAC
 25JJdf0K7ThzIpLkluHFiuXSm6Dw/eVayEI4p5dUd5Qbf2OHwNFqoxzNO+0e4YrHVlDK +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385afsyw2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJd196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:33 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcIJ+YS6OKHLyrHYQnWDVudvLjHcb6FdlHaT5e4HKws7HckFfgzFG6Y4sFMM1AfhMovFmGX8j+sn2BdygRqrXaV7XhdaHtxoYRXkxr+gQCTMcTIv4ObnHoRVPwSqizl9+nYUIIFgO37ED+wRM9bEmnj/C1tc9MonOPOkd/uwoZ5l84k8LDzc/LueZpM7a16xi5LA9QHmLmlePvPxLOFcTogsK1vvS+lzbLLvdbR+YtdUHMX1h1oIrRvfqTbtuOdqAArwqHPZTg5gu+c5UTvdZiSoceYtk3sqwdU28dJe8gojlNk9w7OziLqqUCiRQnX9E/KrUsU2TrhA/EKWOqNMAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCniwxsaloKhPIG3PtI0iZ+EER81xUo8hZgJVFX2HQI=;
 b=W7tUrod37Lnuddz0299N+WXJb7oX7kK5fSYkA1a44e8+c3dmQyhQRILlwAchzuT31q3Z6ZM4omv4m3w7GHRwKNBL+fhlsldD3278i3Ku4xJDxUDkhxxEH8eZMh+a4/CQ2L7ApFuVHyPgJRlIFrAtHsmeI8KfKNijcSEPjsSC4gdEtHr8BAs1cyOSVKeL54SG03kmfWmvJ3ofe7+P7oRffPfbXHJjcrzKpKdGjxMWJ2WXZuZ6xuBJ3YcI5dPtfQNtcVNjxfugi8XlycP/JWPDvBDqHuYiTho8HVQCQD3ORrenZseecSwIsL4rM6VjYH1MkUEB+dQmq8H/smhCAEmddw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCniwxsaloKhPIG3PtI0iZ+EER81xUo8hZgJVFX2HQI=;
 b=gb/4OnUK3T0A5lkNicRDuDdZQOQYvp2AkTUzUNdBhmLossQNBBt095Ri2L5UmRxx7/sUYT3dKxVGgKxAQJZfMSsGE0ZF2P1RIIwDoYq5TzKG8BXfX1vf8mdCUaoB0ybSpmO1r4I0iReJP9EqUhf1obZDCEijdd410eiBAEmqAjI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 00/11] Delay Ready Attributes
Date:   Wed, 28 Apr 2021 01:09:08 -0700
Message-Id: <20210428080919.20331-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4466598-0c64-49f4-2820-08d90a1cf34d
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB408662A744426656A716EA6095409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVdtlqxRU+j+t0ZceacSKwabzLoamfuqIrtNhZqSBlXzQOqGsyHPRgmXYy+W4RirWSXqHtDZ7E0rBJtjcQBytkha0zcW2W3Jb3WlyBz67CI6PbJfVxBEopSCkH84NExqK4SQzu2p4yZfEZlGLT/6rZEB8uqEztyDwHSxvbmmHmvS4zLNwMaEuRREf+9OSSOFqjeL4kS53Ukj/i+dw3o/bKHPF9iVLemH7HU/pIbg69vGtVtygbfGBbRY1xO+mi37+hWL7sAYgLCvCx3ex8qksFX8mGTKTr5zjkoOroIGdLyr++fC45cL9e9bJJUiYQscWdrLwwrJVFuE3DqDpsgtiOVIFna3n335nThvVmxO1iWFP13OqLVCB7bhR26DALpBjSaFNnjTAjwjnqb8R19E0SUaJ2bs+sp8YQJ36734HHrIwB7hXZX77iejZDDGT068SdIr1XKkXMUP3B+IXKU4yOhN3PJIrUtNu4A6JZSNejK1UcO7gafCHBHlgdaBM1bBCwadavtVcQReJfrGCKoDKC5O/3VMbBX4L7FeXZTzJvfOuoI2sodGEdmem7MHow9SQnHcNcYwpeQdU03TuWijHtoLCvf3uVr8uRX62cI5MlQ6QD7ZjNK8qU3vP7ajNkeDOP5ejLpBnSBMbUl/1uGE3MS6FXACMLF+VrLleqIxOEDGPcV/7mhshQVju/FiswPZUVHpwB6cTnvE0mm1ZPMm+SbWwUZTMo5V5b4LWstvWFS38+4iUbT/UAxUN0mRvhwoUd1oLxW4O6+EKg0IhWZrew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(966005)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BAzh5pSN6NHYyHrz/EaSyWIVte7e2ZZCVWqLoTm3AgFomNzv/jvwVvgatyJt?=
 =?us-ascii?Q?wq8YfAwYgTh5L5wvAVAKqmZkmMNWeKc3+Q7vTQLInizbVkuvPxSC1x03zPz5?=
 =?us-ascii?Q?nCqCSTkdiGtt0nmiNhrA66zAYBMhb5ZMZGzOrjOTyH6Tld1PCtKKphDAbWbK?=
 =?us-ascii?Q?72HTNdRVOEymyHvF5PFxA8f4qV20ZDtwjMy4eLUgYnTT7GAtVUBHiE1v4zWP?=
 =?us-ascii?Q?orqEj/5JvNLMnR61wZ/NfS5ESljbB/uZoAg1t3F79YqoDOROTyLdtOTBXSu0?=
 =?us-ascii?Q?9xcdpxDO2RuKebP/rrseUNwpGhg7Jm7H9kjqbYBs+NKyrHUhUy4h+aC/MhEL?=
 =?us-ascii?Q?X/EtWkUitY103YkDp+ayK4BvQpEDCzS4Y4uS3aRfV3L6qEjEAbq+jBry3xjY?=
 =?us-ascii?Q?QT77nBoje0kdlnPqELeefWx8Ub1F9CkKteEhFMlWqevYg8WTc7uV4hdOa1bX?=
 =?us-ascii?Q?u7kxCr9n3UTZXUzmrICSk6O2TquT7LcCN3q15b9FJ6+iyygANVnrLjwkKIl6?=
 =?us-ascii?Q?GGTBVD/l3ri+FaGbnJ068bSKuwLA7wy0t2tAMEZfAi5lW7LGIxmLpnJAjj90?=
 =?us-ascii?Q?KWX9e1Q312KtaFPLs4Dg13aJoGwm1uLxtDsZbSQe/KxPvLmMf14G6alA7Y+q?=
 =?us-ascii?Q?B9cYzxymrN+oqiCilBuhyyBFlUE0g+/mLwlLP7EZNOsEyfZrRiBqG2kNYkqU?=
 =?us-ascii?Q?PuHNm2ldslP5qxZ14uWzOC43m9Nwj0Tb8yeLGlX7da/NjLM1hhh9wujfIMsR?=
 =?us-ascii?Q?R5uDRiUWbjLTTK0b0VphbxJXxtzZb1xHO82BWWwq7u6/susUI79MkIsmo4oH?=
 =?us-ascii?Q?qICN3raJfIr2s6h9LEt0zqAw4gDYdXoZNdflkVgCj4Yj9GEGR6mNIgVtcJwj?=
 =?us-ascii?Q?/Tqa+Bb6UzA04ZRDuw0v1t7WoWrEGKcmzZCJO2btxZql+9sLTLL7YPQpn9Y4?=
 =?us-ascii?Q?Wvw/421++/N8RO+meIHrtum5tVcY9+kqVcXnW9NFE/5BkpSsi0dmi0gh8Sel?=
 =?us-ascii?Q?FJ/xg+YE7FKkMq03/Fdj7Ip7EoHE7VA/7CBAfDQ1dSm0jUjO6Pu3cSpj4GZ4?=
 =?us-ascii?Q?HKz36k0L+WpWTVdjeby2vXPnYGNfMGabIULtk1428qRwt70Sd9Bof3h27tkz?=
 =?us-ascii?Q?HZdABSwQNkNpUtbGoAy4jVTujI8t2Sqe3DUq7zE30eM8u2clib/nKIV8n3+P?=
 =?us-ascii?Q?IZR0p8VLFWeHY6r2UfunRxjOP5RlRhzs150OowXVi9LZ/ePD72+QV2IYY+Wf?=
 =?us-ascii?Q?TIQoMn627i5jvSBoLOGwti3M2O3YtwvUBHNzMd6E5hMU94SOf/oxYVJ9kSFI?=
 =?us-ascii?Q?68rgzpvtijpY2gHyinupQboE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4466598-0c64-49f4-2820-08d90a1cf34d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:30.9008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+hKn50OKbsyADgfLPbWNKWb3ZUPVvgXK7YV/LXILEJh15LcM3+eRsVNHCTZcltVw6hszBPDnBahRByGLDlpJT/jdh73uz0KSVcQuBcJaOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-GUID: b1BBsC4fMhekwHOuga-17SLGWGIWml_n
X-Proofpoint-ORIG-GUID: b1BBsC4fMhekwHOuga-17SLGWGIWml_n
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280054
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

Updates since v17: Mostly just review feed back from the previous revision.
I've tracked changes below to help reviews recall the changes discussed

xfs: Add xfs_attr_node_remove_name
   Renamed xfs_attr_node_remove_cleanup to xfs_attr_node_remove_name

xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
  Added extra reval handling in xfs_attr_node_addname

xfs: Add delay ready attr remove routines
  Applied Brians patch for comment clean up
  Fixed xfs_attr_node_removename_setup return code
  Renamed XFS_DAS_CLNUP to XFS_DAS_RM_NAME.  Diagram updated
  Removed unneeded error handling in xfs_attr_remove_iter
  Fixed error handling in xfs_attr_rmtval_remove
  Rebase updates

xfs: Add delay ready attr set routines
  Applied Brians patch for comment clean up
  Rebase updates

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v18

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v18_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv3

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v18
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v18_extended

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
  xfs: Add xfs_attr_node_remove_name
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

 fs/xfs/libxfs/xfs_attr.c        | 897 ++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr.h        | 401 ++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c | 126 ++++--
 fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_trace.h              |   2 -
 7 files changed, 1031 insertions(+), 406 deletions(-)

-- 
2.7.4

