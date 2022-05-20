Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878F3C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbiETTAp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiETTAo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412D5D1
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIdUuG010259
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=A9lItAokeprONJDF4NbviTVay4G3IVc9IYH3ljFIs5k=;
 b=mKY8kqld5lxE/tdUzlYg2+BizBdEVmzV9KwdF57UVVw3T5ezwz0gYtmQdAZ2e3HmfRMY
 ztkrWAuH8gNAQgwo4QyChrsBKLcRsGusQiJ1G6Yi62P1y7QNxbtngd62cXQ13MrwKKQK
 9DB4A3jrPXgo/cz1B4+jl7Xv7CBYBv6KCTBPeWGhVK3dfrH7wIuZBwiNRwlbk9bxPLZm
 4VFOYtc9NFDD7OkoJImtf+JpDkzdYgfs+4Eu59+9OfCSboBZTdEPU33r8gxOTY8J34/j
 LaK6rkzDS6cb+A7PfTSnlhTOOYC10w/MxaCaS1ZzWtiC1IO2ilfo2wOHSt1EMh+oKNLi OQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sfvp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KInuZN009768
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:40 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6rkwr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STOC4TDKsgGSB+98+drjt7EIDVs76S8pZM3+i0eXJlce1cwle7hst31Ci28uuPK8hdyhMOtNW/qXnREvbbsBCU++sCjWHQBWI+YBUkBl4iFkDhroOjG5CBmEaqoUxGwAirIwmTH6CgKaw/d1n0Nc5n41hkuVaQVSy8RE8zKN2vVo4+1JjLjnpgQKT+VmAeYh4iEX37QF6YF8eYTG3gEXxh6VeBxr45M1qqJtKALKENe4kzQDGYP0TZ3pyIDbUNWVZQD4MZSo8bhFh4DxBudsG9LGIKB12g+cC5+fXtSy4QGQmbRotCBAk213Ui0TqcGFBJsbU7a8RMEeQUUiuTA7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9lItAokeprONJDF4NbviTVay4G3IVc9IYH3ljFIs5k=;
 b=PlXZ2oWg+RiuGUzdYWYL46TW2VUeYySAHqLoyTNUEzgggTHPr4tweclYhOYX4ZfDRMonpi7M0nnbcf5JwJ4IXpfI8gkd8dN18D7ZjAkf58ef74hJyiNyIvG+XcwgkFXxx9LoT0V5pG5Se6q/+rZtVFeJwCyMC/PU8xtpeDyq470YJg7wX7bgYikskK2Q17ARkeMK9TeNwoV9a9dTapPNDEiKT4QuRL3UD7QUYxGKV7KxbbIJ4OQ53UUhODuBJtARj8t1lrpOni/v0NC/fkIeLZ0dW0DkswMijxVFsVkEGxdaePDtesveY7+d9ngoJGD2hOZb15UShsPvdU8MTZ734w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9lItAokeprONJDF4NbviTVay4G3IVc9IYH3ljFIs5k=;
 b=v5lQ5GoBIl4c4hRmvy8mQ4x29aHLSHVxEw44o93KrUnoEjjN0na17KF0/i6URa4OWKrn7q/yRyKJmN9e1D9SsuIllANgJvRncKRizVqsA8zOrhhHEy3dfqZ4X3vwwgMjqpFg244duxYoDXMmdREUe5D2uHYumG8ZsrcBCXbLZ6c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:38 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 01/18] xfsprogs: zero inode fork buffer at allocation
Date:   Fri, 20 May 2022 12:00:14 -0700
Message-Id: <20220520190031.2198236-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29c583e5-295f-4a23-56d4-08da3a9306e3
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658E250E41193589CC306F195D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uc9HnAb1h+l8kn7PlvEUuqhF+VUhX8N7wwjmBK8aQWi3yfugcD4FoK/KHMRMJ8ESDv6xeBW4kJrI3/BXI8ElhgD9t+SzoIYtiuT6rX9vbUr1rI1J5zbY7wP4YObhT9DAcxoCuxToYpLXnHiluYYEKjqOQQF+ig7iiickPija8gG0dn3NmyGmcXsqSgvTsTk+GRdFTWVzZswUnxz/FN7R+TCtcp1FP/7As3+ZEt5AHFEj4r4UN+PT7v++Xmu/Ql0eivfkDioZT5c04ljm7jSqUSIiVzXylElO5u1yqABWwq0+0NiHOHWHqJY7c9km2qUzX+1c84ks9f5UbO3s3X6A2Rx7I1S373N5EvkEFMJIAgJIxABG2CtDTAZnKMfetoTtNuA5Tcf4rqetD73HVazaNzLiRXK6Um7RDv4T356XuSUjB1cTsO5zOS1bBc3nvU0j6czER1wx/t0OdBiTP0P6i6nkO2H9L8zqVPip8e1FTcg8ty/io8TQmq5FcnDNGGWbp3OVK9NbuGijZfRap8E7R1eIE77iA5Dqwf/Or0+mv960+Ux1Cc+JJmuVJNM5kEIilkVqOAfjrTLiIJdA9fqfr17hSPzR/KWR+jsfWlFHn5stUg7SNxSNf8jvsJn1n+q5WpgFXfyBEJfECYnzLrjVNqIA81zq1uczCn6SS1D1JVejWUSst6rrSaMGhFg6k5wXvUWACKtSR2bTQ83Gi1CYYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b6MjxnbiCOteCOG+11KyAJXkHYT1o0QPi4fv3odhm8MeWy4vW5VRRK+T0vGY?=
 =?us-ascii?Q?UQhvWRasGun656kCWgopZg+54TqzOnudEwgprSHgHNNRjMHFKHfaNDQhmmnV?=
 =?us-ascii?Q?TLfmDtCl2oSHSTvyHQzERI5UZGynLyzzmzvRp2+Qt4PCN0i2uJjfB7jjzhti?=
 =?us-ascii?Q?BwRn634inrqO0sSnXURjauB1UMz7geU/t2GMOvX/g6o0emi6ABs+Oeykj0Tq?=
 =?us-ascii?Q?IJYp37AgmqUwoVdp5tS6srtwy7gjbzHBmemEwuc5JaJqEG1sxg2niCWh8/5n?=
 =?us-ascii?Q?1k7kx4BHRJsUcA8YxmqSUZ/IdTj+uIZ+QancG8rnBIIASLLPiKBhdZNnSHUe?=
 =?us-ascii?Q?I2ZPmv1mvkVBwfw0O5owWQi5h1hWX76fi4FmfZqUjxLobD+piIi+YN25fFse?=
 =?us-ascii?Q?7VxNGXtnNI1115YG/0A+9vH4b7KoZNTJtOhpPuyoCs5rTnubF/R0GFRZrCLt?=
 =?us-ascii?Q?qacGmTv+mO+s/WxD9or3cqRrBYmsElx/w+WLqKUG5AR0+t8vxGDLbOq6tuA1?=
 =?us-ascii?Q?MHp2uetS24/fDcYdxbgi6leqNKOf2hzB3dPPdDFKyO3ljeRLih5rctCoeE0D?=
 =?us-ascii?Q?qSgt3eUwlU7zPr9O4j1yBhxtDjWmzxdhE8VJOQtq2MAu0m1b9qWA4LgBxDYZ?=
 =?us-ascii?Q?04AuoSQn78gWu4XYZ9WCn0FhEIRk7lpLuVSOR9f83eX2rMKeOFCIFpbfeHMg?=
 =?us-ascii?Q?/mrfRivV4+h1nXZoWoaP5wzZNj3RXBA1nOyjhFwiro3CSPvS+yrDZM0qKw0n?=
 =?us-ascii?Q?Cq+qetf5Qgd+CP3o+JH5+lIJvjaPy8aMAjzkE58vrbJiy3riSVrZ85bXU0V5?=
 =?us-ascii?Q?HqhSW5N3voId6Fia/l+S1Hsic0eWOrVGbC9KsM44vYA3yJ0374uSMB0Y+gtc?=
 =?us-ascii?Q?VxjwO5OOIqEIoojQKUOfU3RegWCMz1suus1TBOTlqgu9md4ly4Zo64z8VDYW?=
 =?us-ascii?Q?MViEFeKcOZw/Qzygzup5gcdd2Uv5DbixJJ45SuxIgEBcPvVus8hiAHN0RLf2?=
 =?us-ascii?Q?9KiqdkSVGBD6B2LxWZopLHONliSaPl0b0HDh6/+aLiVHPVOkL24k87037P+a?=
 =?us-ascii?Q?AuS6z2a9Tb1NXEGWv1HDxkTq6s5rHRv/zripjzLYo7Uo/yKcAaevw3EtoRqu?=
 =?us-ascii?Q?0d1Wqqgy+AF3Ic4XuuOxBXaTVSTjhZrgEopCczYp9WWfbANHYb0StlQjYSVf?=
 =?us-ascii?Q?C7CnjRpu4PQGEq95wa4bZwiJcPJzecTU/tb/f/B3kkfO36V6zlqKSjZvTgUn?=
 =?us-ascii?Q?fGYNwZtDOJF0mQlxKb1K53l/6F7XQQ30euOrsOtDB9c9gqmN6ZCi4vRadmgs?=
 =?us-ascii?Q?XivnAz6HpAN6A7nKzfd66gIytgejBLPsTXp8bTXSsBV3A6/QcP5zSAgkUuib?=
 =?us-ascii?Q?oI1KBLk7FeNjrgc+sVlkGCO58B5Zafp6vrVrFQWq4e+0StDKti6txVXnaGba?=
 =?us-ascii?Q?t+YAnQMD8laYT22NJEujFDqZS6iCrNVm3N1gZNmLsnLZAosuP2puwAeGt6p+?=
 =?us-ascii?Q?CpwG+sRIj0QLbKKpwgrUiDmjbA0uEfLaY9Hyzhp5OcKaS4BSqE9Y55OohJoG?=
 =?us-ascii?Q?IKWYSKQpv5ZRCRi3aO/kBeSp1JMzuPVBRNo4g5j4Gmc/9yPEtI7wI5mGYUdF?=
 =?us-ascii?Q?b+N/1TDibYYdJuIFAgEUDjt636xNu971ejL/BOAoIGLg1217qEfgsvTkrisu?=
 =?us-ascii?Q?kjozl/SLNEWckqfY01W21q08pSo8Oa5aIHmaWuUkEXgugg91MFs81jUqdk+/?=
 =?us-ascii?Q?G0Oe2QPEKoK1Yy0fKx6DLN2zFNsXkTo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c583e5-295f-4a23-56d4-08da3a9306e3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:37.7449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDTids3XpHuXVOIbINa2HIGo5XT4oClb/XPfjUlHBZiTb6itHYtALVmxi3hxI4l4AuBujP4RyqbYVblGbkMGIPPl7utct2LiXi4K+Oe/u0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200119
X-Proofpoint-GUID: 6R4ydRq72lRI-SmAPN5lBtv_ACaPfEG9
X-Proofpoint-ORIG-GUID: 6R4ydRq72lRI-SmAPN5lBtv_ACaPfEG9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: cb512c921639613ce03f87e62c5e93ed9fe8c84d

When we first allocate or resize an inline inode fork, we round up
the allocation to 4 byte alingment to make journal alignment
constraints. We don't clear the unused bytes, so we can copy up to
three uninitialised bytes into the journal. Zero those bytes so we
only ever copy zeros into the journal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d6ac13eea764..a2af6d71948e 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -48,8 +48,13 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
+		/*
+		 * As we round up the allocation here, we need to ensure the
+		 * bytes we don't copy data into are zeroed because the log
+		 * vectors still copy them into the journal.
+		 */
 		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -498,10 +503,11 @@ xfs_idata_realloc(
 	/*
 	 * For inline data, the underlying buffer must be a multiple of 4 bytes
 	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here.
+	 * We enforce that here, and use __GFP_ZERO to ensure that size
+	 * extensions always zero the unused roundup area.
 	 */
 	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL);
+				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
 	ifp->if_bytes = new_size;
 }
 
-- 
2.25.1

