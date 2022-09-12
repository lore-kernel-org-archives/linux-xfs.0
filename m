Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFD7C6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiILN3q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiILN3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E16DF5D
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEGCg020724;
        Mon, 12 Sep 2022 13:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=D1keeQzCTVytQp3OFPOO7Zjmvdb5rQDgP1n8vzAz3v0=;
 b=od/qFa6mkay9cV6zNym+QKSO5b9mWLR9KshzKL8amtQP+e3alJtNDk56YN5pp1vXIEvH
 6eq2oX7uomW38R3LaZt4TEVcu1B3SmDeweecJQOzvyaCJ21tTSI21tnKdgcR6Ctes6Ma
 Xa4XdTpnHeUjWldGuqEtBu/MlhcDTGGekS3tKOjb/o8qbwcnIAUi5b4Gx3vY54l+xe4G
 qFNPchsXu2Lcota5X8QdIaMOoVtT26OSCpm26UJ0N4HHgcBgPsnFsERsaO620M0wFV9E
 3+99nE+7xf6PCMW3PXeyllVNL3Xg+/SyM3cD3/LfMwSKqVOzwjJtfEGTckj+IS4NkPJM mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgj6skfbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgeG025076;
        Mon, 12 Sep 2022 13:29:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12a83q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7nrquaF9avMgMseP1B4japBjrunkZJrE6AOepmgE+JX06SuUEnziIRxxThP5KVQinO5sRUpXOtL8DlINdPhDvDsCbx3dKD8NmwaQoYuy3OVLiynzKaTr0f+AnArQGMbjLUDdG2togXeHoT9ld/PnnSEDj8Fa1McNJvjRBab/hRgLP5H9IOXgewjfvnm/7W9GvkZAp5XJGKd8eDog0jSdCb2BQlN3pIWvueeLIl0Qzq9GEFrP39fi5vHZeHtMmcTxBXqjQzV4ThQ1rpGnFNizbkpC4ahsEOnAymp6OPeMmRCOoZMhu7u7O9lTuM/JniYO/c8R+T9yABt7E7waQ0TUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1keeQzCTVytQp3OFPOO7Zjmvdb5rQDgP1n8vzAz3v0=;
 b=UHlyDS1jjh1IftJhX/6UTh8zLBvcn1aUciNe+k7njc8vH6XNH0Iyg3hZ8sNnjseeR0TY6MVFPnu1zj8ZTmJDMcYvzn4IMP7t3DoFBV8HaH72fb/GiRM3QZDxlT/MWy8Xafdsm1WqJ/oLxgDWKEmuzEHEJwxQ4pMLZoCq7y70uXXHVE3I5RGGQFyPBRAf59F05PMcg9g5kNnPlxHt5vA3yL1hq46blX9geQHQR2TodpfdpbPY23mqjMfmlQJT/XIFs1qxjYM2njq9phHpAQBSpHPTcBcMJL9wSp08KGCwG3itRbBb3ctbBvkFRPDxZV4fCnJcypyPXBw3UIcVoOyB+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1keeQzCTVytQp3OFPOO7Zjmvdb5rQDgP1n8vzAz3v0=;
 b=VekjEfAGRMnxSj8kgqw1A7futRwMjidP9rCObBUPITGbb5+qmS5wmRZLwFrpBjd5PYe5U8dYsioPR/0NnNnEy+d2Nh5vvEc4Fk/v/lY8zYvxsqyfNng/j71xI6urVtONYLTONEnzQYoER7127vzkYc4GyPoCG8+XeDLYhkSMnJM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 15/18] xfs: use bitops interface for buf log item AIL flag check
Date:   Mon, 12 Sep 2022 18:57:39 +0530
Message-Id: <20220912132742.1793276-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0027.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: a804d287-a595-4e3b-8735-08da94c2d64e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jW+hBvqVSr3viOfuVPkSEDCdMPWN1o+1qS/vEAGHRUyhh9FtsGSQGwt2AW8VcAyHhG7yiT/2F0HclLfRNbsPeGFRya7e/dtI/PcVzbo5QtgC3b1bLOjDnz7AlUPSiQsbvgP95wDf8NZ72ZE3GndsF9l8kIl7yl0W6L+AQeenMtmTdSpmF9ly9mALKABs1jr/FkUD6g7gYlrpbg3Moi31eQF9kTjuszchFQEY5r5Btb1h1ptfklPlZxIFnvs9DXL7QJM+cWXJKtDpGwNTTfSCE7UZCLlSgYgJyykyvPdGVuOhIR0Ptks6ddssV4FG0O44Ork0sm6p/Oo6NhsaGqhBG3H9OX3ZytMBPXsApvOZpV1uT5w3j5AD6UUcfV35QSvWgCpDybp2Y8BVdWBRFqfC0sZoora9I7UA44Sl1jejtRG8Eq6w6ZHIoe4wU2miLoQTF806Xp7xQEB4KTlPkMyy5bYvSALo0xKZNnkG/yI+2u8EpfPwEEksKcRJj+3cGvOgNmlydnJHZb4DSFdzXMHeBcLBIqOU4XTS7c0hNy3bOCSGYUx5XI8YAQz6warufWt2uqoyYWfMjbnAuVV2LomoyATnzMqxE73HtkF1nHwaqyRH6mSIVxLPdPBPvZ85toDYLSFIxM2iFqnh/gTH4ipbenOHTCbBr26/WNBotzzooyP8ZdtjTtYLlumtYTqgEHMFM0Y6R3IeKHb9jcHF2ZAl2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(39860400002)(366004)(1076003)(6506007)(26005)(478600001)(6486002)(6512007)(186003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(6916009)(316002)(41300700001)(36756003)(66556008)(66946007)(66476007)(38100700002)(8676002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SOMDPXNLsSYZ2jSGIXog/1Mdb2EFcbSkAS0OZL0VfpQRiY2iIWzEMfZTk5iT?=
 =?us-ascii?Q?PN2WNwMrbmkEC6SSpY8nGJ/+NRvrwxFaH9YP7hxI9p2M+Lqy01fO9E7H5XBD?=
 =?us-ascii?Q?YMcUXe49sR8UVuAVN4nf00XtIGHdQ+U8iSjdReRVQeFDl8wdA2MvW2UU9gkS?=
 =?us-ascii?Q?LvjIUOfzM2LGC35687DHSt28AyQs8Rtpmsx9rsg5QpAET4H6r/uJldhUCDNj?=
 =?us-ascii?Q?J70FOymWuHiRq8XKgUGusRW2Q6IBK30D6ZyNkxX7XCsqcPBjHndIgkEqpUVH?=
 =?us-ascii?Q?psAMGJlBzgZaA1bMjYFWCPNBwupkgoLqMm2Yh3q7nxuFFjLSlPrHZ2SLmbau?=
 =?us-ascii?Q?ht5cLul7AOx4pRTevK6D2QAz3ema1zN5tkwU+o6X0/qxqk2UtxavVtNg9cyE?=
 =?us-ascii?Q?qnZ/GDu1++piZRoIEpztacBWh2aTQwk43UK22ibo/OggClW1EkM1uCvom60C?=
 =?us-ascii?Q?c32GUTDEQWM3ZeHk3s77L6i7ElCL37iAfFFO9u6TU351DGXVMkxCjf4Girl0?=
 =?us-ascii?Q?1tBrH2FEhRsYGrMNH9quctdfdWMOKggIOhorYnUYZ2YPTpvFrMvlRqtb2YKg?=
 =?us-ascii?Q?sykK4IsGepjsU1qj3dPApkP9Lq8J6Nxbp3fc4ZVGM9nEhcA2FmMhOT1vY+mP?=
 =?us-ascii?Q?qlHUXUV+8F3o/+YwcDf/HUr4iP2zp3MX5jFc+1UdTlCEbAcOGZ+BXoOCn74C?=
 =?us-ascii?Q?tr5xYTJQ9al4W+TWa2npZX53t9SKVP9CaT5leYxEpnwj2illBJ571HkmXvdb?=
 =?us-ascii?Q?5/njL+nfwsvPvNcJkzRVZxjLSuhHtDk69jlORVdSpem8w9ffz2rTggnfpFsb?=
 =?us-ascii?Q?7EkB3cBi/71i1KA6BBwHsUKOhUG4w65TW7wR8HnIsKmgTPVsrhq4SQZpx7M2?=
 =?us-ascii?Q?NPy+2+bnMJOUUxstN59FdBWcAcEBLI23BBVgtYcHdbTCs2UpZJ2WKXTHb6Nk?=
 =?us-ascii?Q?UhbFmRW0ceC2CEvR7XN/AtxEeqSKfjWWpNmKESE7r0PVYAImy1XzMGvTIYU/?=
 =?us-ascii?Q?1Z7BWnDypLBAh679tGjJYpDD8bq0bYjjzauCr55c8iBJUBv+Aurlp5DOLFPM?=
 =?us-ascii?Q?dqZzoXJgq76ZiLz2V+HhLCSFzjvBHVt4Tc3mMZfSRNvWxFSKog7ZgyUMppwh?=
 =?us-ascii?Q?ZsS/FBws3n8cZenag2SE8vyQa5BhKX1eXGrr7t8ehak99Lv/TtH+wZu+ADCD?=
 =?us-ascii?Q?ATQxXTeqxRok/rHXVeYZ9ArRgq9n7IUv3w01EmOuO9wcRv2QkKETIxknkAfs?=
 =?us-ascii?Q?JUAgOFSBcxT2FqrhMzBcynPkVJACoosZ1udy2AwJmiz8Wb9dvGIG9aQqkjSK?=
 =?us-ascii?Q?0Yl3NkWjkaZEGEMSZNN9Ksr/jAojxnCxVafKiWHEBBewk1VbcCZ446IKE9hn?=
 =?us-ascii?Q?9+3efMWegEpPoqlDXkw0nRS3iogVU5U6yPkX1ZQWfissQUSpfC/LEeNIHfdf?=
 =?us-ascii?Q?vhlnwGmu/C3nnkZX4NhEdepkajeTKoUPLt4YuZIVSCTr88NfPkDPkg5+hR8E?=
 =?us-ascii?Q?sMcznf7Hu/ZH3uF5YGGjQrYgqckgs/JZ0ZGDrmPRasHg124Ti6ysYlHFv6dN?=
 =?us-ascii?Q?5XSHqwNw+AnXiBIsRbOuEcOj6cNznyIt19X+FLVVJc7x/hU/atJGORaUtNHI?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a804d287-a595-4e3b-8735-08da94c2d64e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:36.7164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZzGZaxG6zs5KuDBt3DkCB7dRVYe5z8j8Au3mbEwgEvCnRQPEAfc5A8NuwnUjX0KQnb2uSv5cY9/7ztqsTa8bFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-GUID: cn3CfTVDSZSo-tPJuIcnyjP2zsTJqKi4
X-Proofpoint-ORIG-GUID: cn3CfTVDSZSo-tPJuIcnyjP2zsTJqKi4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 826f7e34130a4ce756138540170cbe935c537a47 upstream.

The xfs_log_item flags were converted to atomic bitops as of commit
22525c17ed ("xfs: log item flags are racy"). The assert check for
AIL presence in xfs_buf_item_relse() still uses the old value based
check. This likely went unnoticed as XFS_LI_IN_AIL evaluates to 0
and causes the assert to unconditionally pass. Fix up the check.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Fixes: 22525c17ed ("xfs: log item flags are racy")
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d74fbd1e9d3e..b1452117e442 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -956,7 +956,7 @@ xfs_buf_item_relse(
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
 	bp->b_log_item = NULL;
 	if (list_empty(&bp->b_li_list))
-- 
2.35.1

