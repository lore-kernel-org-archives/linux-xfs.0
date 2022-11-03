Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B981AC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 11:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiKCLyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 07:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKCLyP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 07:54:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B043DB3
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 04:54:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39O8t9013488;
        Thu, 3 Nov 2022 11:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=uUV3ZIGF05G7Vv0QVtIk30HY7XcrJBfxisi7gS1t3iU=;
 b=ZHVoMJuzx/4HCBXSC8hA8dUvUBVHiorErxXgrtF8oDP/F8uJWBXiEK1q7H0+IcowdRAg
 ZajI4XWSeuX8NF2i0t9yhY7k+0wrfyj0PZZac2DRqqcLCRdpBKRiLduovhBybIBTDZMh
 S4eKLrAlHdd+fLa/OU3vQ8JXMfSrQLdC6hMu5IK9oOL0oK8JIxwdOW/ZbemHJ3C2Bqb+
 nIAplCyiFFwM1m56KLU18jY6NdFkzqMVRQ1JPb5lSrlZ4DM9WphvRPm18s1WouQU3SLM
 fWqHNkRwmVHqlT8sHCNyAHjzjmiiBQL7N402prvoMpMJAk28FPdv7WnH45ADpHTPkPve 2A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtmqku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3BmXih029718;
        Thu, 3 Nov 2022 11:54:10 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm6hh73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8Z6QTRxEg0ohH5XMoQW5Qs2taMKbIhjuAzU+CCjo8CoPBEcXkjG9uhFqxx7VM5T/mOxWOqADWzhyMTsyqUAcrn4Lq9S/ct9wessmTK9MElpEW/JI8OfZRfjzSq/tFzYUKnmeV3ycy/V3u59+uCZR43TTynoSY0d9TW7hlOSD82T7WM2YcRbm/peSecy0NOiAUMUcaSVhj24+0Dz7ss1BBA5TNOUptF513ttAGbv7DZ4dXrQdxIYJk9Qti9LsOWVEKzs2f/8pflo6xN8m2EWkj5MRwyPDAueUp/JMc/f9DfZypz8A5MtMio5d73e29tLbXhtVaQNzeVNsxUXHIKe4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUV3ZIGF05G7Vv0QVtIk30HY7XcrJBfxisi7gS1t3iU=;
 b=Zck5v8Sk0ff5Xl5h1Ak83h8nbruIFdvXxUJavdHcex7PsW5yUYYbuVGCBDye0fxUpp9vJ/Fu33Kzhxxqr/6fjvN17FMnhTfc++7X33xUFuVDTb5JCvS2qVOEOUFIAatOSvmPJisEv9GKKW2GhmZDtR8dnHlgjGaMnl0dfoSZazvyiDqb5Z90SgXB3Gdliny8Jx/IpqBYTaPw/aMwn9okm5RPqnmIPyec64YBtsmZwK8hC0Rvg7MLzGCqxzDX9L9jMmxNtlDR8FPRZlK7TZWqZbdYq7FkKDvrsEfWLT0jVOHm3QND+Lktywy5qdPsahIirtjZxA8sau/VvuTLHMEcIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUV3ZIGF05G7Vv0QVtIk30HY7XcrJBfxisi7gS1t3iU=;
 b=auFc704omX7E86Ta1nCuQf9guuvGTWTcXZOJd6APiem+E3qQUGorbXf9m2qXl6TW6Ys9LhB1AtEwh8MwqsTcNLZixrYo/dJxrAcC+kvXJ1ZCWeWIkVVMb/JT7b7rC0C3WdLRuCoNUB+CNagBg6NvyoUekvldu0QJmoee7xM3ciQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH8PR10MB6598.namprd10.prod.outlook.com (2603:10b6:510:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 11:54:08 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 11:54:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 0/6] xfs stable candidate patches for 5.4.y (from v5.8)
Date:   Thu,  3 Nov 2022 17:23:55 +0530
Message-Id: <20221103115401.1810907-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:404:a6::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH8PR10MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c120ebe-b86f-4f41-d97e-08dabd921d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I6tLCzne6mSpqaDLaXyoUUTvqUiFq6MExJJY2ci6TVdpZWHkLw100YgIZ0f2GLhNtyaLhTcuR4nrt20pH4aDZWm9EXVZqs2/QOP+fKqVtuZko8e6pj/351/7zhj3aC3pXiwtuYX15223ms7SVIWmdtevzNjSPwkSXpOC1jIr6HmGnrx5L7CirmqwtM2qACNm7amfVDdwECfKL5RFbHJ3qlksbF2lfNtRl1tLG0cOXFgjctDAjGbeqv1FxywkLBw1WNuVDT21XB27JZSnH75EHwHG2OS2D6UuJZt0+5B12/mC8/6q4ypSp1PcSRwT5+pruwdkGCoRm5N4Hdv5Jn4zrgt5t8sfccG0kuP/qQrFKeA9piM5hcWLuia45k5JUi7w/MoIJ27I4UBm0OqS1Xo5KUEaafzL47nrYa4zXXA5iEBTTJ5z6tN0PQT5d/qOqb2psT6W51w6KXFFl3dYsPajbIA7hlruYxbcMdV2E8ZjueBRISz59perA4yHesLakcWqWko6Uja2QioUurbRK83aIPWTUz+U6g+UZH7eABwyv/pqdEWzJ1jDoltbLAY+J/L+1e20iRTJi70Rbgu1hin8n7bgj/fIbg6ILqxw623zwsnAxkShocNzEUS2bV8LM/49Fpik2sSgFb/VtcUfPAZs8CMkft0fucG56z90pfdLgfjOaVp+frUGMYzQj0GJ/pSySOtYCdn2JkToOyNKEDnpeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199015)(86362001)(6916009)(6666004)(316002)(36756003)(5660300002)(38100700002)(2616005)(186003)(1076003)(83380400001)(2906002)(6512007)(26005)(41300700001)(66556008)(6506007)(4326008)(66476007)(8676002)(66946007)(8936002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oHRRs7rxu+g3u8ag4S02ZTgVjxIfs/QAruHajg6QzSmaonRyMOoLqKYYuyvE?=
 =?us-ascii?Q?TcCGPfVZmLoFOXDdGuy9MTGqy3rj/fHBQvm47y9zQbA+YKkJaXHzL9Sajk4L?=
 =?us-ascii?Q?W2l/vv9PlOii5Ac6WbG6cjBkriuvrBuzXIpo5B9XcEAiGE9L8/bsekCA7sy0?=
 =?us-ascii?Q?6dGWR7hrqEj4VksCTAscPOura4sIAzX2mluIle6X7+Qc8m2OvLijG84LzyOn?=
 =?us-ascii?Q?KSxLoIdM4hT8jXweS1mdtOajgHXSL3Q638JZ8a/YfE1JD26DsQFGdUdPWNNA?=
 =?us-ascii?Q?NHGHLeoXokzgdywgdwZG142eS2tCKauALkuSS+AiY+dyE6zLKKFkG8MOGk3X?=
 =?us-ascii?Q?MSipZ7C7uzA6HTdLtTNY/qg2vM1CHq+Rm9XOjcYFUCWE53yAzAtumS/0uDh9?=
 =?us-ascii?Q?2kc3xKAy8wf9gtOa4jUax80qkdFSLSNdELIveLcOUKKE7l1H2ovTxHykPQf8?=
 =?us-ascii?Q?KyAOdqwZegxeBrhniK2DkCRejOlQToWoM7G88+EKDsgYfzD+XBhB4i8sQ07z?=
 =?us-ascii?Q?ZaSyyvAHKa6giY9gkWRsU6ODUlt8SqArXWjl4IDAQ/Z26BHNzPG3Sc2L5cka?=
 =?us-ascii?Q?lP8bayfU2GNJid2a3ccyju0udImPzwDpFncF5ei6bpHalfw3KdXuCU8kpqJU?=
 =?us-ascii?Q?OnKeZ4Cj84x8F/0c88AE+jK0Yv8v/RnISMefchvzFNDFNCHmgEzUu6h4LTRo?=
 =?us-ascii?Q?xukMhIe9TkD30pP5LfBN8ipGyUJG3n27sediDV/HD9+DJlG8EhYf56nNCC/n?=
 =?us-ascii?Q?aETuw6DLNVwDq/FaNlss8fTwiMNF/7JhKeLLSJdAhALKEQXgCx6+2/ps1jSh?=
 =?us-ascii?Q?YvvaTNJnj3lvdA1/k+hU2oJ5l50l8XGCaaVeiHDkotUYvEKb1+vDibqdarfx?=
 =?us-ascii?Q?r84dConWuHXj8IXzxk91l3H6JW59bS63CIm5hOjGSVwlIBCWe4+O9uoYvQI8?=
 =?us-ascii?Q?zAyqqNQdZ4jFhHgnx5Xov7QWZbCzV2YKDJLYaQeRkMqmuHvP3OZz/ZYNTmBV?=
 =?us-ascii?Q?KGT381xfCcrni4wKZcd6pPSJhXOgYp7Qb40V3L9/MhjX4IjBlebF61kiApxR?=
 =?us-ascii?Q?toAEampVRxMmNPVDAmmJoZUXRn3eNVto4d5z2oHF4++61pegm+8Jh9+EmA+k?=
 =?us-ascii?Q?eQpOty0XmPopjXZP24dRDMlouLg4sZTFU0MamkXz7LYmL9yyhjHX/dn+BO7W?=
 =?us-ascii?Q?TgI5803lh3ch3tCNANa64BMEFIKe1eN9BdEKlstN3tokae1YsoBTsr9E9X5Q?=
 =?us-ascii?Q?UDFSA4W7GpqZUNg3bvMNjAzfaGnqrZ6KDqBijQ0r4rpNGU8b3rIFxVnZ4epY?=
 =?us-ascii?Q?PsAyms7CJGFYxdgi6042DDfsh6hRxmTVO98ovfCN4ZS2p723ZbBZ7fxTi5NS?=
 =?us-ascii?Q?5YzvfXnmxsgTN9oC47i2z6wkOY1UTtStfjWmJmRIAFtS/SIZiccXKhFIT6Dp?=
 =?us-ascii?Q?rY1ouMqJ3p4Rd0gh639Ugz/P0A0ze+DGmF8kCfaGoVlsGh2E9O+qRRvyxRA6?=
 =?us-ascii?Q?6w6CCOi0kifqnxf7dbMZjYz12puc+4+duaykDhcF0cjllPmrTycY86YuZcHS?=
 =?us-ascii?Q?c47h3bu7CcC4uK0JWxsvdO9/NgHtMQBipiFc28r4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c120ebe-b86f-4f41-d97e-08dabd921d89
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:54:08.6981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlg4fyVBdaZzGlMDPe4kAHrUpYnTmqdGgfRMZsF4ncKSWeQHgNKNgauHQDxT/fXPNsAwCuw48lDyD/lVnOCFrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030082
X-Proofpoint-GUID: ogRnpAJTr7_KYcfR57fmi3ZFwW9lDCUN
X-Proofpoint-ORIG-GUID: ogRnpAJTr7_KYcfR57fmi3ZFwW9lDCUN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This 5.4.y backport series contains fixes from v5.8 release.

This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,

1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

None of the fixes required any other dependent patches to be
backported.

Brian Foster (1):
  xfs: don't fail verifier on empty attr3 leaf block

Chuhong Yuan (1):
  xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()

Darrick J. Wong (2):
  xfs: use ordered buffers to initialize dquot buffers during quotacheck
  xfs: don't fail unwritten extent conversion on writeback due to edquot

Dave Chinner (1):
  xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()

Eric Sandeen (1):
  xfs: group quota should return EDQUOT when prj quota enabled

 fs/xfs/libxfs/xfs_attr_leaf.c |   8 --
 fs/xfs/libxfs/xfs_defer.c     |  10 ++-
 fs/xfs/xfs_dquot.c            |  56 +++++++++---
 fs/xfs/xfs_inode.c            |   4 +-
 fs/xfs/xfs_iomap.c            |   2 +-
 fs/xfs/xfs_trans.c            | 163 +++++-----------------------------
 fs/xfs/xfs_trans_dquot.c      |   3 +-
 7 files changed, 78 insertions(+), 168 deletions(-)

-- 
2.35.1

