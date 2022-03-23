Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B35C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241006AbiCWVJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240996AbiCWVI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:08:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491498D694
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKY4qh001345
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Je5+0jeFArvnuUxCBQtPbJmGyU2QhjJWGKgYkcIcZIE=;
 b=InlHu7RoqZec2gydr65m3saYIXx2sLevlEzOo02dejpTq3ixoQTCKbl8rn3SrB1zbpmj
 0wPmzgs9OwjE9VAgFGYN5O/Bpn7gpawZgi3OW0L/KMIQVajN2jO1DKEh0rUfwm1NXzmV
 kNeS1pgFUeDHI0c5DoEMWCi9QSr0vMkUfuQHIWubUF80YvI1Po2FrWxAZjzDoY0bBeFp
 F+MnfgUZt2l0kz42pMwRZkStAz5LbuNGsIxMeEEYoMjPYuo/BzqO0cRiUrGVhw9wGg1I
 rH2vZLv7dXtddZzuh3w4xXXNdK9sdK3FKGU/DywpKFOsvTLONMHXxzdYPfE0qJRnjPv7 GA== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ssaqnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6Ld7082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmmqOqpVYyukmtvPJ/+n/0OBUAH5O/VXzgoriFif124v9imyswpCbs/jJ76zyzZmuVxY44QBctX04100g1CoTcpR82tfaKTgGBaDJTIh2fjH27wQJxubhwUCwm8sEAy+yqjhRilVf1bu+0WNeTytmODQOdupWMUNtwwuYLZczDs64bWr86vKtfAQX5/c3t5b08N0KU7nwUlERlXzKp6sqM5VYR8VTQCkhzcreWSy/whLvJs3udvz4c3ZVJTfaxuwCeE6xC7E28mMW2CmznKJSUCvvOb1oJr9pCdJMUZYoJwd650Yeh/zpn8E2gRARhZNVB4Sat09bFRLE/4864SGIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Je5+0jeFArvnuUxCBQtPbJmGyU2QhjJWGKgYkcIcZIE=;
 b=BqM0YQ4sX+iZFOQUjglJiDJkGLcO/czNBGGDuTiLca5KxIFr57OiV4Bpp+wjR8yvhyeB2ODqHrU/FPdZMgkj0fxSvBHXQI3ruhMTJdY3XGzTocFKn2WXHRjkaqvB2wyFUIprTHN77AzKGpfWRtarAx1b/5j6yRtIcbOPbnzoU2AwH4jJBGEX8twFPv6mOoNm0P6ZG3CoYR+paUYYuwsLf7iYYbCg3sEE4zvFO4jqRIIovNYEYx/PtlQnEtUSBWr467I39BfQg8LPvD3rXDsUYHEN5u0DeRDorvnAsCt1H1g8/2KfTS+fez0Tj4jeicx9MqIJhPuDzo2L37IB/bSwjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Je5+0jeFArvnuUxCBQtPbJmGyU2QhjJWGKgYkcIcZIE=;
 b=yRLkY03E/gj0jarXi2r3S95oUm+kSVuYxpdkFxwTd1UYsTGJf8SbuwZZ9qrj0NDp3gENZ9B5MQnJjfaoeEu6DGJskPFLmJuddRZfj7IMOYuURKGoFfbqMYM8t0OpBmdEjyehFOHEkpNGiK7Xm6KeoaE8Lu0zc4IV/zX2zUia8Wg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 00/15] xfs: Log Attribute Replay
Date:   Wed, 23 Mar 2022 14:07:00 -0700
Message-Id: <20220323210715.201009-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea0a7f43-2448-481c-7993-08da0d111fa1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB474464DFC7FE333E581F556495189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZivYk0fTsFqI26mxlBOkrmAocXAvnvaDpH+RIdQSEaX8UeB10TpIOtpdQoG+xitiaWgPYQVnYqDT/LX8P/eLKEB+fvHmHIeu2uuY7SEUw0OnPvuC+sxvpL3YU1NJ9Hip/dch29Wx1WecPDcAGlgQFhJvNtj6h9agfPsKBeyLYNJLOCd9t0pKBHb7Fw/9BsNpeeL+QW95Rn4pTCOVOveoklLm/5SyrC851NQEolHQa6Ehx42htUdzk6YjhnDtx4zZvKEk3eX0V/05OPKJkYG2jpjkbNSJNuZ8pT7gttsXuJILawXMxHk0mdWjlMiqmMtn+fP//Q20yCqixJCBTa0XW+1oTl4+hm2UM7YYJJTNCDjpXfszWrAQaHi7wFKhin9pdWYd33aeP//i0nGllshigvJfzDXoXyrlX2wXU1KrdODOZI4YxBpZMoBdjJhFD2H+i4M2At92oh/JCAcnOQqClw9MvFtMNEvIpj7MYNWL1RLiPcL6FNGSLG+2WQpy4xJPTisZo9dz7ksKFs3UCFk+t/mweNqINL2bZgzVxy1rowU5GDXM67YLp45IOl7kojzPc6vUHUxZGdaNyKiAEidL85X9aKvNChp9S6NzRMVPcXDLKQxSx0OVUO3HFpEDeyzrW7pLmCsrw0SbYj/ux8Gae+zpWHvMZXHFpG/I7bs5rzqvvGzYIgI9Da3ngU42v725Z5aklakcKJyhbSv5M6vDlfPOHSX3kP9yHe8Ylx/XdXCCAvxWBGlzExWA+IAqdG9CQh7GcfNnMRfBPNQeIL0/m7fXSOgj9EHM2vq/PSfgb29UBUDB9V2IgoCxhnXYg9l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(966005)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3QhPaxI379WXTCN3m466eQGP2Cj1bgJ5jngMz6DV3BAGXwehhT+lmL+urWs3?=
 =?us-ascii?Q?AvP0a8uVAo0+xCW+GRQIZM7DXVWNC6tXf4QwFWuALUP42brVa9ZBzPJ1plCv?=
 =?us-ascii?Q?xgemjlVmuY/p+jSE1AvScpwnOo9gptjPMOgvJsJc7fw/ASx0eMgFwhff3yjM?=
 =?us-ascii?Q?ozFIalVhXztuZLNRBMgM65rtGhRK5wWJ0ClLkEyAv7KcXZtn+Ynu47Fvt7vp?=
 =?us-ascii?Q?BuDIcloTzUlXQ+5KJftloLLzXPZeVREm8bWtlVBuVu6MCIOonEROEhXO0flt?=
 =?us-ascii?Q?ku5otoMRSqQXcyGUYBV8vle0kqpVIA6qDjLkjdNp+lCLFpJbVcHY75Lgs0P0?=
 =?us-ascii?Q?P8cnHcRAvIxlUGJtSy9ok92AjwibV1LPOMEFTXaNsGDJeF+JOFZCdeJ7kqLM?=
 =?us-ascii?Q?V4vs3b6SBaM4rNELDkT4y3bGo6vMyLw3V5rFqcAX+tV56WMgS+7QITfWuolp?=
 =?us-ascii?Q?u5rG+DDp7usuUCtLEl7ggpJkStOTE9McYL6vElr84QrVB4b1QAdH/Lfg6QJg?=
 =?us-ascii?Q?VBvQ7CYvJGi+nqM59O5SgzM9wclOyTEZIeZ6Scpeue/kxF7difR9DqGL5NzZ?=
 =?us-ascii?Q?2S/wrVYIawxVTfshFsdAekTmrc4Daz3Vfd9GYahvzghXeEs2FnYhyyUQCh4c?=
 =?us-ascii?Q?CZRuHa3axDNwol8dRf1DFY+YiakrepPf7L250/8EdPSzTwnK75kkWFXrgZy8?=
 =?us-ascii?Q?MtjZ/6qCSL7fufaoFsW2zqI36uTg1CXqzN9jEzvNqtPxv+1XRSTUe9gKuTWi?=
 =?us-ascii?Q?34RRClsIqUu/1+kLAkONb3VppsT/ZFM+uBVwuvnp87yhkPh6dzU03IHfiHSW?=
 =?us-ascii?Q?L5SUrLq+9rOHZXW5tOSG42+O7Gs2ho2BnlR4kjOYC8JqqdUR41Udcpbjws6b?=
 =?us-ascii?Q?yQKX/CE9TczBb6MIojUzIf2+jXO8Ih3SOqT2sS5obLL+MZWd0Iz+YFHTuK0Q?=
 =?us-ascii?Q?4cIMVo8w46y+M0IpHgK9oSMZJexDBK56V5w+/VV4Qtstr08Qg65dG4l8td26?=
 =?us-ascii?Q?14o2E3eu2qIG/4EvdFuV1Kv59mssyBIJHlMIMkeR3ULPWNe0SDyUmc1UEs0X?=
 =?us-ascii?Q?E3T3y/rNdyiJpjqFTyanTw3iAlfKyCY3sP6FptHIeDu8gL0aCtF9FO1v+cma?=
 =?us-ascii?Q?XDWYB6JmcKzXMaezaEllWuqu+X65fjRdXrEQGInkhWVJevO/Y9m1lLh16bF9?=
 =?us-ascii?Q?WZATzuWnvkac7HWomhm4Zbu72bobaj/ejbp6tFZW41QbdHad8C5OIs6quuA2?=
 =?us-ascii?Q?WYo1LWJ3Gob7kWz4W8aJXNQymG3+mV9oeBHeDT2X/X8Mv5CorZozKv2v2q1r?=
 =?us-ascii?Q?I/9OSQwZZdVzpehvSmSgVZyOl4JR3QweAkJUtYh8K4lZQxvNqcvvWIy1nQh9?=
 =?us-ascii?Q?sqWmf9cUWG9desfeVh8vJESf1K3lfuGxdx0D17E1U9bKTMrUo1oOa5T52cf9?=
 =?us-ascii?Q?E+CmPkfCjiizHshDPdYNXCW75rmqe6TtL3Wnx3OnFZENJ+Eu/S5avg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0a7f43-2448-481c-7993-08da0d111fa1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:22.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jK9w0/hxWdSVt3RD6UkpeuSOejTBouuVQHZtUVMNA1q66xaUFEUlkrtjlCPQYRmnmYt1+ySEvQCQgUJAwhmM9pZUnh06+lH3ZsG7+w1wQEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-ORIG-GUID: 3DMac03zp0MpiBJO2rHGZ_0EYC_1kylN
X-Proofpoint-GUID: 3DMac03zp0MpiBJO2rHGZ_0EYC_1kylN
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

Updates since v28:
xfs: Set up infrastructure for log attribute replay
   Fixed xfs_attri_init to initialize shadow buffers for name/value
   
xfs: Implement attr logging and replay
   Updated calls to xfs_attri_init

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v29

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v29_extended

Thanks all!
Allison

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
 fs/xfs/libxfs/xfs_attr.c        | 524 ++++++++++++---------
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
 fs/xfs/xfs_attr_item.c          | 810 ++++++++++++++++++++++++++++++++
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
 28 files changed, 1433 insertions(+), 279 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.25.1

