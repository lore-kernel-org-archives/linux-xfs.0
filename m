Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B837AC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiAUFUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:08 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6318 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233792AbiAUFUG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:06 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L043Op017784;
        Fri, 21 Jan 2022 05:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=x9gjtR4poZ9x8gJyxdP3vODSwZfFQmfBDTc5TlLuE/E=;
 b=inVuHDbKoulTWqA0y4YaPnM3xbWbgm/5gqVPGxGqglfVg/3c6KDuuCBuWYnJnlYx0kFO
 AQT2lkZjio8hvlkR4tPG32Ju5JPfGwL1kTE6cx70Y1kZ8TeP9hun2t6wDGLxtmAfnd7A
 zCbRGQvG++PM1FZKCqOIux/wYsvCMpvGCKvm14/e30mwFoPZvvhYMlOJmQNujmGvFS/q
 0vRgOvLoWIgO/qjheWeSiakf14OebQye6VfBai3gm0ILXJtM493jLQQd6HDmse4kfT7D
 KKXOuha4MuVR8dsQwlkNeoSWLAIaYwFz4CI4wIGD+Lpl9CshwIaKEZuH7FQ1ltIsGA3x Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyc0d37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5GYTV190410;
        Fri, 21 Jan 2022 05:20:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh0ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGPDb3URkNQ+glc1LaJNXH7SlVTlHDRShAQ6o8XhuOnTcrcEukuFbGtl39D4HuABRJ7CuxBW7QelcaBnuhw7TkjLiRtJYjRYf15Bv4m0TyiJQOyG8oSC/St/TBKGEd115FQYpm5APtwqSUieT6wQSxz8LJXhXH0JZdZTb2ooiWc2KUWa0k/cybdfcTrevvEYFDFcAnydA3K8HwBhQKnwLRDDjkLzblQ47viZSz3/lh9VqHEyoK5EF/5Kc2chRyX2YNwn72y6akqmo9R31V2HSw2JRrXU6ZWvLBiLo0074Qi934CBV3xsULtmwjw25fZfz0Nz1POOnQLV/sucwzbHSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9gjtR4poZ9x8gJyxdP3vODSwZfFQmfBDTc5TlLuE/E=;
 b=RgflWbWCBQdQg0CEDkoZSQmmB+QF9dWmaSjKW+7nUCwxNCY4oW/F+7x5LPtLXhM1cha/dkJAulFgbqifFJic7W1gHfQfauvFJsY2/5d4WkCBJqUh6qwR/VhtuFFb3/4DHX534UzBnN+aCgqGF7HgJvwEfyoqvgyG84E7UuzBEMwRyJM1tgFPpjUYc55pNencotTaeVHVI+yRAeD30S1TxXvALIEzgp6oa+KRZfMyPbAFELsEUVs2VnsdvvbpQEpRRTnrjKiVnm+K1U3mkZC5pEbmAtTYf14EpSOyZpQKlFyiJKVCYh+4J5K9dRWaGQ/ER6AbjSJWtljYoh7drAEqhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9gjtR4poZ9x8gJyxdP3vODSwZfFQmfBDTc5TlLuE/E=;
 b=QmU93EYSIijtmivn3f3y/USKOEkj2SozS7ANoTSCZlOuGY0hnZCwP0rVp4Mh7CaECyiFx00f3HVxAEEC6DT+gqq0plrgZKkdzMFhYmty7iPk2ApLu1F+2ZixezfGVR5I5zkjY2JNZZQ8BJvRsemXwFPtPB1Ogr0ZvQI9lTyEMTQ=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:01 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 15/16] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Fri, 21 Jan 2022 10:48:56 +0530
Message-Id: <20220121051857.221105-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e737beb7-d217-4f07-ebef-08d9dc9dac52
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287013DF7B31F9B313FFCA5F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OLQUv1tIbKucygeb4XhoAzmyfZjghyZnip5aOin0LewozKyDeXXIRNRbLMQOKZnf79+0k2zYTKSNwDQXUd9g2EYaxCkKtDmKCYmUnD3eAavMvJmhQNFwwdE9WAgYfTOUeB9EZA9LzObV06bnWanrS0kr1L/MQql4Q9O5OXRlA2GBESLELy1NEgYC3ge2XGiQMQ5ShU/Q66HPHYmo5nx8cAlbiHg7wJ+CcrFmGGFhyiB0P+PbbwgF7zJtc393d3/Wsy0ZsFA88Dm5k2XYMAlWmhaAiLCbe4mR3VXXxdzMQdpIUgePaaSmzgqCPvBoz2y2KzDs4hKEZ1aSlSO66HZzU7g1IMFGUAPrDlUBLtjmrkIjt9QxKEGIcgOVdMRqPjMEyCowQkDQGbKQDVX/2RdZQHiq6nqUoqEPZOaYghffI0ORw1Vus0JMuWl8VARvjEY+qaxLsPZ42hdvxZJcjclUHsKZxVjxZZhZIZMKNNS22BYJ07RJ6wrfj3ue6+RVDStyZFOMYAYGnGVWCh/Xt9YtlPupRQNF/e6lWxBJdjyaTMQ4Ke0ONYvj0rhz3ni/WoY55wgSxAvcH41te2O55hqDkbufULak1fI2boRSRz/1RDi0EUG4cezYDlxEGCffov+R1J0My+zgZbpiZSQLMT3OOOwxLQSM2KzLx3LVC1SCTIlaUr5h/AdrkCqAekqhh3pWiPFwc+NntoXBFcmZdQtDMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(4744005)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?beCVbp2GGQ2wS63ETMaeH508ZRwbsWLHp6YjtzijELV0nB1cqmgzz24/m7U0?=
 =?us-ascii?Q?xLYPU1pgDpqi5ULx2NcKrr7Ni0Zc1nipX8Y7gzMWtXS4iuyAxCzfLp/MGD+V?=
 =?us-ascii?Q?y/MEeg9fte+8QHiLqLcJIMbKisa7ChpnD97JVs+YzWIaQ8w23x9oHhnSfRFx?=
 =?us-ascii?Q?W327p6V9g7j8R5KCQj0DHfaVQENLDfbVAydaBIB8SNQbBSsfOUipdRmeMjHE?=
 =?us-ascii?Q?Gk5inY40Jna+hyNRCPQAUXLYj0ItIYRoAKRSROsRaEpYd6DtGY6FXKz4qw9F?=
 =?us-ascii?Q?Ed7AQXZPW+4UTDegLT/tzFf5NyPgGgXzXcF0/MIcPN3w610c98KYCN2R5CrP?=
 =?us-ascii?Q?UdidY/B27qjTX9XeEfY0pXjYPrtg1N2EAEKhhcHJ81jT2nCYMJbQzFXkRiTh?=
 =?us-ascii?Q?qrX054uqya5DXNU9JADFPtnKL/8buU+yXVYzCvDKyP1Gaa1UhZKkMzzuGPOu?=
 =?us-ascii?Q?Ww2DqNQOFT0EAuz+8vroVZLT3ndo+7OvZ3xg2AuuNNND5XKobc2jwuaOlPHU?=
 =?us-ascii?Q?dmB12/VU8Yjxcdqe8Zc4fLDe7ducjj84c1l7SXgBlBXU3REt2aWM908v0zfK?=
 =?us-ascii?Q?yj4NpRShqNChseftqFaZc9C//YvONpHo0HWeREYxNc3jQ+dPX7+ByXI2l+OO?=
 =?us-ascii?Q?zvNIdZ6i6zdWTeGP8Zh0ROQoUAFlJ12eVRM3OdX2MwEHr6OMOACzPAaIxloB?=
 =?us-ascii?Q?5T5qvNOUc9mPl7xdVY9ylUDYI1rZPhg4vSEWwLTdtcYUYbE4pd/abL32E7Sx?=
 =?us-ascii?Q?Cz0KAEZ7E2Ik9ZOZWA7VtTuQPvS/RfinSlJLNhxanEXXvfftIiM9s61Vb8D1?=
 =?us-ascii?Q?KYVracZzVwtSPSBH4wPT+/5Arfq4ivwVkSwl3q6yh2dgxdJ48fKsxRwIt/XF?=
 =?us-ascii?Q?zA2AQ2eChXjtgysAl+Nx8Exl2rVBoyefirpR9doUrZ5lyR2KVscp9jk3RTet?=
 =?us-ascii?Q?raJehQsOvlmf+JbTrv0qKWKmY73W98bLrxVcIOFPdci6x5wuBWVeFj8k/QcF?=
 =?us-ascii?Q?/R9b04J7IHjXn1/C4T/KLCCrgNevRIhwB0zadSK5nd99mzHYxXOCjXznjHTb?=
 =?us-ascii?Q?QLjABWfiu2t+Zl5ruiOGmnp+jrgw8oCcJ5Zbss8lo4HJZKJy4Ekeb7GfYBHN?=
 =?us-ascii?Q?fQPPgPOAxnIoYrR/1FWN6IBDW9FDPYj+FGtmNmj+RLN1klogRGZcQDwCrqie?=
 =?us-ascii?Q?Q4YPuU8vBUaGNRkI3qnmj+eqGsIEww8ihXbM1E+6twDH1CBcl4ao0rKCNbPS?=
 =?us-ascii?Q?9pW+8gNUjxfkSXlS10ZCy+2/RlI9IDyeY+htwgd0UuvH06RX4ERbOgeaXH5+?=
 =?us-ascii?Q?VMeS8bKC1AMGYmcs9Bt27fn7Nmhv6hVM8oKjrDO98PVEoGnukNSkr+ekHP7A?=
 =?us-ascii?Q?QtNMOF19jWEnBSSY+o7nutirf9IjIl193xygeho2JJWzwqz1FePdRL9vCqjc?=
 =?us-ascii?Q?WwdzYXdemlf1Z/Aftb5dS7i6aShiU9vAJ+BkN7vUReLesRC9NSMalXWUZ5m7?=
 =?us-ascii?Q?TVxZ4X+h3yowo82cLZla4BHqsSMzqxkQkx75yL5/b4OcwDP+EaGNuNLlp1em?=
 =?us-ascii?Q?WJG9kiDFp9MU0h8MrEiyYMq+5V/GGQkbD3PU87J0/m1OSmMhuAJO32FoFdiU?=
 =?us-ascii?Q?ZCs0qNiV+LncR0rLY0g3EEE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e737beb7-d217-4f07-ebef-08d9dc9dac52
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:01.1383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXshM5k/vzkvfKwELED7dUR7lIAAJIdLa25xmQRHOH5HPdFZ52ryrM/si1FZNQDIoa9UjjMarnPGqo18fFt6AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: tMqW40CpFeDweoxL0aCxG61OvzIcAYNc
X-Proofpoint-GUID: tMqW40CpFeDweoxL0aCxG61OvzIcAYNc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index df1d6ec39c45..b7521c1d1db2 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.30.2

