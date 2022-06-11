Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B186C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 11:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiFKLLO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 07:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiFKLLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 07:11:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EA925E0;
        Sat, 11 Jun 2022 04:11:09 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3C5Gm024318;
        Sat, 11 Jun 2022 11:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nfmdeAJLLazo61NtPR9vbNaSmWh3wFA8TLdghIsXyIo=;
 b=H7X6Uspgb0kdHVcTV8h+i08Mox74quvFzsYBmUAxA6JnmfUmO6Bpf5zqnKD9ZUD2PzaO
 DeRe3kDmiVNc2n5nAKDcju4MXFFP/fmIkuCovsmuiFmln+12kRKoeYvGT5llf/I349/M
 w3P4xsXzTGzfRUodxMMzejups68zyT+qfq4xACV1Fq2wAHJK8EeKTchwEBL7Iu6SvFx7
 zBxwanAkcvj9qwSd/TvflIEpb4NJ5UPcAy894uh793J6dKDUGDPpIEC0weiV6e9BBJRJ
 B4ky1lhSARGgknc9bxqLXopIJesbcXwkwYvfHpClrBgU79a52Pn4tsZU+lEDy1y8vmfU /w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx98ck4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25BB5WoW037259;
        Sat, 11 Jun 2022 11:11:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6x256-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZK/pOEz9BQCqumw8hJcKJkzjQCkXeTPuTNyomB/YnloHNz3Npx7aDFzFDgSwVlRELwB76MkbYWYvkMcpJ7q77BZCAlBvxSHb9s0ARkPUJX1kRXMG1NH9mtocmPrRBPeGHjTs1knk2cIWwLfE9nGNMk0hx3rfw1TewscuJciHh+Ud0pSW3kf0VwbhxPuY3I986CYKCLrPWjSUD3no++iHpKY9u0dnFq/dEt5IBFdWazNFQvmnDgTZS9qmBPK+WJ7crKgxnDhLDPdxWHfNEg91advR4S9kiH+iItS865vBXI6+bTJE8WojGwhpcyKSEk4XytfJqjcHgFPRgIejSp7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfmdeAJLLazo61NtPR9vbNaSmWh3wFA8TLdghIsXyIo=;
 b=UNQ3rs/ADkqRnVNvqTSdO+xWp7WqqY7ZSWkKsDtiJjixRyNI0R4wWQwicyIQ1VmIGR4dpJDF+OZ6XgEZsx7qFbTitVUz6hsVLEAsaKE4WT5thhViEXW9E9gpkPySj5kupBRQQi+kQvXF8Ah15Q0s1FoZ2Ix3ewawc/xD/w0U8owQZU/OHskzKQAS5Ia0y+TNYRdG1Oc9cmZlDdkC2VuMGNqHcGe87pCHH4B7WhxJnns9auV9XjXNDxRNA4+e/pp15rZoHH01wwQ/K+NSy45bm4dDkvL44/QbQu8qKT0XwdL3XlQITxigBOZWAAsMwdKIyxl2ueS2Bmyzh/knWvXM6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfmdeAJLLazo61NtPR9vbNaSmWh3wFA8TLdghIsXyIo=;
 b=B8bou64rRJWZ4PnvfDyp+95WINDRvBWBvlhrB31NcE9Z9yBomv41iX6aHqafO2ul2L0YHv3Hn8eROcVOKk2EAl7ye8U+fBNOMOD3cR/xVBcU13jIRQAZyaXWej+BNsW6yL9TNHmOYt0/ntNNFI7DruWepb1HBTxA7P24bXt1gDU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3313.namprd10.prod.outlook.com (2603:10b6:408:c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 11 Jun
 2022 11:11:02 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 11:11:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V3 0/4] Large extent counters tests
Date:   Sat, 11 Jun 2022 16:40:33 +0530
Message-Id: <20220611111037.433134-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0014.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eebe54aa-3f39-41e7-74bb-08da4b9b11e6
X-MS-TrafficTypeDiagnostic: BN8PR10MB3313:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB331397AEAB3FD2FF341F6CF9F6A99@BN8PR10MB3313.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmOkzIzkdsN/8xwrthxnuRlIf3AHyKQXrahmXM2km0f9UOxottcHFfNhXPgtdSXCanfmCBGWmRWtZY6+WAmu+57DvGUWNIfhH/GzF8tU6s+6pv/ofOIOnDAoucww1v9FFGlBqOsP7gJ10EnG23W9UZXZqq6HBoRUyl9MutMIDYs/2vk1hX0OM0Jm1qbKJ3y7WJeiynILGFOZBmb0WQGs0tyXe4Av3O8Y7AULDDyvVPP1ojnLeKcE87LLAj/q6bHXFmbxQG5bgmIPl+EPnauOhCo3y2xqXuSTBKQk/MACNXTuwhwvce15DoRh9AjHVP3UYuQ2/1KZ62MUSnFT7qATTDDrgt0k6lSF3m5+kGuE1cvsummNa7dAGfcwA6qHO8uLAhLVnQFDmYZSDrjWOY2Hi/ibFcGGYJgS5wKMQffWXssPZ65AiNujCAjAy1WLQqJF6Kc7KtGMK3nAN9YDTVi03tyAjR3LdHI2561PJBGkYeVLJ1/+4BTpBxXTdhgZ6gpNuaOKaGqYO6w/mKDtelpO7Njb5wa5HJjmqjr57qZZ2awMo0XfIYf8043alO7D71Q0e20KMg1CLv+5zmTviQQ/6OWjhVBEtyQsItY123ftuZdFK0pCETFMviSyiKF+Fw8k/QAAHO3+Z1oMyZE3GbHTSAozsWUF/6Wqlvycj9dMbQlIiUbwJGjQoJepjw9BeZtnl5uxSqWq9V6iJbC5+74vlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(186003)(2906002)(1076003)(83380400001)(6916009)(2616005)(36756003)(26005)(66556008)(8936002)(6666004)(508600001)(8676002)(4326008)(66946007)(66476007)(6512007)(5660300002)(6506007)(52116002)(6486002)(38100700002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bGzgOWn3y0hzkl7kpA5RAHzfut7h4eeROZWmcLugj9naxMQv+RuglubkAUhA?=
 =?us-ascii?Q?0P1nsAxEjZJNovXkD6RBbWbgllPLYKjaIG7gEqNDxCteQzx+OIDAfujnPO9q?=
 =?us-ascii?Q?uXT8vjdxv8VHkxBlPnGQg74IAHlZo+PHVXdRFpaQjkrTHBdmhDQNnvUy0Ky0?=
 =?us-ascii?Q?Vaq8Wovk4gSX2Z2WoeoqeAtsf/LGxliuehUvUc1mJbl+jTnTCUojrfvkk2VD?=
 =?us-ascii?Q?Tw0aAgV1PynfwDuDNSBXXja0i+2VFsqgX6bj8dtTB8CHytEW8ey8+LfeSyG5?=
 =?us-ascii?Q?d/u+ft1BLCBi5o/mHMCjmnVz5g7XRo+NyWsqun7MH3mrEEkaESIDeFJAQm8W?=
 =?us-ascii?Q?4+obHnIG8Vx/nomB+PgIIf9QWmRb4Jypu3J9DuTdSLmZDiB6kBrjUKGbrDkk?=
 =?us-ascii?Q?1JOOBFbORAyFPZtBEORLtRzMLLIYlEfRnoZvGoUJXDpG90jn+k15XSrykyOu?=
 =?us-ascii?Q?dHc2Mmbfx1ft5+UEw7eYxDoVFbMGn9JWQ8Jekr0BJ8KE/xkWfYr5wPKPsvDT?=
 =?us-ascii?Q?Qo4VCZ3h5sCecEpXAcF8CqhrzkB+AXbyu0k6Jo1ApLbjJXdFKjdUAdOknAdx?=
 =?us-ascii?Q?ugkMlsFvWguGORL8UiDTR8f0w6Z5gNzg3dfDtnHTaJl318lN507bBNvGMOhS?=
 =?us-ascii?Q?xglOqc8H/iXBYa4LCWcHCckm253HO3Ij487T0DlbX5CwhwPESEi48iNyxSbh?=
 =?us-ascii?Q?BhLVU9Ka39mLoB4a1Mu+gpt53zhE2VwibipRxQ0AVcstC/JsZdhAtK7n1EVQ?=
 =?us-ascii?Q?UDa1SqJlVjw5nEqaBdpAEUm14QZZpzbIau9pOIEZlPhdFm7KmF2LAC/AmbZ3?=
 =?us-ascii?Q?F7feeD2WzmVMCs46WW/YuBxsL8MR4hv/qFT1GYgT1VZxCjRHTG49C96AJ0fn?=
 =?us-ascii?Q?WcAf0PKwwerFh/k4gWMeuaXu/nifJkQSu+HGaBbtx/zNSCZWOyR8vamgvC9/?=
 =?us-ascii?Q?xVKtC254imy7TT4apV2HPOq4gUb0DSSzVVWThQlQO+JwEF0dYEkE96ajsiUL?=
 =?us-ascii?Q?QFGrwpNNGW+JXcn0HdLZi0wLVMAcR6qVNHZH5xmKy+Vr83rjTxIpwBfRD3pE?=
 =?us-ascii?Q?SWWvzxTXtEbbZgcnjInwXSlQvAidfgss4Tc2nSjDmDnuJa8v9+quh8aJMVsa?=
 =?us-ascii?Q?Z8SIjFvuEqKpun65QmzVSMpEMGjB5waa4ak7XN/toCygOhKaItVcBFdRVExv?=
 =?us-ascii?Q?VOKmhNdFQoA9jKk+326BlQrsYWFsYJtuRPXL5QtUuXF6dWkHl5revuczBwHy?=
 =?us-ascii?Q?Z0ZaNhdPc7/KYK+F/bhGdgrGz40X87kPQESn4sZ7kZ5bi5ZCwZv4AXuwuZt7?=
 =?us-ascii?Q?ad4odKY3NYiq4KOG7LpA9Dr3PMYv6+kPoK4Sn4H80Y3Wlsq2BWCNvcVmMvjU?=
 =?us-ascii?Q?Yn90kUn7Cj0Ds2nx36ezLBI4qLfL0eAUZxBo475ZDJwQRpmT795aEUaLuym5?=
 =?us-ascii?Q?GGaDzPUffswVnW+PJHC9+cvX27t1xp29qdhuWqAN/HxexBHTpos6dr3k/lMZ?=
 =?us-ascii?Q?F4wklHr67Nvhq2w/daWQCt/7OmJXozvAvj6NJK4696wP2YUA9P1kzz+t9L9f?=
 =?us-ascii?Q?VOHVWpVRE9pUKPoyf0jyrKXaoylOngI3rFacfLvoiotFY5Iugr3MmdIyQ1a7?=
 =?us-ascii?Q?VG1lcRAM2yLSr3sb+1Turd+znVB+EovgrgUpB/UGRqjg3ggmfGl+fytb/W0V?=
 =?us-ascii?Q?I5ty7JWl9BhIKPo+hjMa9Y+JVnO9nP9ABpYq5p9m1Ykb6kb4wSIgK5+PU1JF?=
 =?us-ascii?Q?lqODIXAsdUpnBPXV9w/G1cXLteqKHAs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebe54aa-3f39-41e7-74bb-08da4b9b11e6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 11:11:02.0863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m2+slgWo2fnjFeDd+nM9K7YxWTqKPpBUfGPO5N1ddVCZrIEv6p9Oq6yIoTiRor3NxD3JHqKkZ0M742lwjocOgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3313
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_05:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=987
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110045
X-Proofpoint-ORIG-GUID: 3qFe65GnvndnDOW3ub1gKTpeO_ry9tUQ
X-Proofpoint-GUID: 3qFe65GnvndnDOW3ub1gKTpeO_ry9tUQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds two tests for verifying the behaviour of Large
extent counters feature. It also fixes xfs/270 test failure when
executed on a filesystem with Large extent counters enabled.

Changelog:
V2 -> V3:
   1. xfs/270: Fix regular expresssion used in inline awk script to
      match hex number.

V1 -> V2:
   1. xfs/270: Replace bashisms with inline awk scripts.
   2. Use _scratch_mkfs_xfs_supported helper in _require_xfs_nrext64().
   3. Remove invocation of $XFS_INFO_PROG from _require_xfs_nrext64().
   4. Use xfs_db's 'path' command instead of saving test file's inode
      number in the two new tests introduced by the patchset.

Chandan Babu R (4):
  xfs/270: Fix ro mount failure when nrext64 option is enabled
  common/xfs: Add helper to check if nrext64 option is supported
  xfs: Verify that the correct inode extent counters are updated
    with/without nrext64
  xfs: Verify correctness of upgrading an fs to support large extent
    counters

 common/xfs        |  12 +++++
 tests/xfs/270     |  26 ++++++++++-
 tests/xfs/270.out |   1 -
 tests/xfs/547     |  92 +++++++++++++++++++++++++++++++++++++
 tests/xfs/547.out |  13 ++++++
 tests/xfs/548     | 112 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/548.out |  12 +++++
 7 files changed, 265 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/547
 create mode 100644 tests/xfs/547.out
 create mode 100755 tests/xfs/548
 create mode 100644 tests/xfs/548.out

-- 
2.35.1

