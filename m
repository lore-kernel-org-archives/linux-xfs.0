Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B605C742A7
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjCHWiX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjCHWiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D14E62856
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:18 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwfA1021962
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=RphG63hYNnC4bzASBxuytRlm0jX14DR9pFbHBErpnkM=;
 b=WBdu/E6mZ2E5IWC9+NrYHltWsiBfbZ2wv1d0cW0z0rpElfdl22Pt6otQOPjc9CpSSAuY
 fCrSnnv7aeSDvbUl9SMKuxOYAtq7W6myt9y/MiSTG8ralcQvhFITUQoW4FCBErn5bjhI
 Uj6/d+P+vJL2v4sJJ0mgHHDlq/u69rBNObR/J3v1Pt1CMlUSdxr1l+Czt6EcRaN7y4M7
 0H6C8DxiZHt0O3Y18NyucEBtKE85OL7X6HPGjL0EsKW+WjaYwBLpHm7RiBeHXd4hRooK
 XmUn7E7AUgLDWyPiLAw4l0xZeTbooe2CS5cko9rxuTDYrGHamHnFcI8viu2sijk+h5LR 0Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168se04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LVM0i015688
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6femx3av-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4/1QCvm01fDYWjABklyiFSepvcoyioBbVODWx79qNHmuxVjy+tnA+WoBd7MkrK6KJV+bmNpCVyOW7GX5M0Y16bKCXv++jK8ZmHWJOOzTggQFieL0QR3bTe20I4ozlHj/v7GvOiv3JQ9FMNsdwuKdYfd3TQH/MkWt0vxwvEXorhvUzD+OxjRSum4SHFFu34PyfDfIZmbGFHxupgaNJt29iIHcitWpqnUcCV2B5xDNrnhOSYCv2Fq5QJM0WvOYdHJ1oTlo4gS9v9tCSj8p0zTrWBX7/SU8lfdKoY681FZuTnQH/r5+vPb948P+PyGVVykq/LFADiDbLImNp7JHxU0LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RphG63hYNnC4bzASBxuytRlm0jX14DR9pFbHBErpnkM=;
 b=dXZwI8lZc1kseZpRugfDn1/x73nL8ZQdJOdYo5orY0YvjM57nfhlTQ6Vcq1g1GdbCbohSpNh7iz80/TEPc8mxKIERiEJF/zqpisxK1D49h66FmDq+FHmqbyIzoDTTYXThCkLL/MnEbwByL1RBWlr7Hc2bCEIa/+gUlkqQQvV5a/ZpboJ3VqVo7pO8ocdZsWfF3wukyKxP38TtEUenta/xlJ7eEFwrhFmPUcmy7rCRi7hKegEQyE397NzSsomoC/7gbhvsPXFrP/RsI6arcmpftETpNtrOEBI1adSGjyESpsGw21IJWYxIF6ppkpAtwYXGAGOu4myt1zj4nogLc+CuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RphG63hYNnC4bzASBxuytRlm0jX14DR9pFbHBErpnkM=;
 b=O+7CcpVdhzNYAR+0dVXBC1TymBMvLLDlLskyPDFnOK6BhRZzVQLcaUik8WXGnzPuApEcE6VQYLwQhZ0gkweOPFewIfHT8ZqHsYp3NBg7RPRqKx6u4nehwNw0uVLaqyfTUQyFJu5xpuD1ySoVNU2XJDqmxgM4VQfPpLYZa6/TMD8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:09 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 07/32] xfs: Increase XFS_QM_TRANS_MAXDQS to 5
Date:   Wed,  8 Mar 2023 15:37:29 -0700
Message-Id: <20230308223754.1455051-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0240.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: e2c2a1bd-9c14-4728-c693-08db2025cab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WL8V35F+SL4OyMwYFg5G8EdiXPNwtcwXUHzSsTDVumw4l/NDbpELUij1gJPgMyMz5CoClD0E5eRdcFr9t6Z+HFZDrEn6mBn/RffnUpSZOHQFFmarx1odxwBFe47s5RYf6hb3fZJMUKOtfef6yX6K26PLlxPo3kFLgoKg22j/i6LTJZLNB4ThIEefEOd6GrIWSS+alg0FWP3Zj2XY3UQ/qtuqkYVd7mQxRAPxdAg5ftEHV/MLEyAYiHaag2dQJN26qtf7hpN9NHcJSQaRKZksI1QrXlQ5jTzBONMNMCdIo+MfPvu9umGsdeGcZ98LMH2rna9xn5Nx5OYXhdIz5ERtxgEjGOkYnnYClgOGRW3dH9OCc9+xGK69dln7s8S9Av4v+5lW/TP5JrCLms7LgMuHDvCIGP3yNNd7QzPaHgAydJanE4zaUqIJ4kpqm+WsYPXqNDYs1Y2GvmxuGDwaGwA71CjF4xlTROvHv64nqWRR5zxET7cZcQDnURDGB+qcwnMHXnlHypQz4oqlKSMIW7hh19NswSXNldctki6iXKONPMrbUM+i46d00nFSTgRd7GvzFbx4UqeHfxzNSKrvI1aA/VGAHjNGvmkvV3t3yBAR6o0ZlytfapDEBI3YmGv6iTxktoAakIw/QnwTHQexE1iT9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4A2Mr3djx7N51tYPkcjAsOEzftEYYGPCUi9xYde4VdhSEFZrApIw2OxkMZu+?=
 =?us-ascii?Q?RVUX/luJcumAq/d79O1Hk+dbmK4EUEOWGYnXHTtHqV0m7FjSsaKiv3JGEyQE?=
 =?us-ascii?Q?LsBMjXWMQx8tbkJtNMbCSfTE0kC+Z1FDmaXX68A+TlU6If3Kms3t6D6LoaYn?=
 =?us-ascii?Q?QaCMtPoDS6B0vdW2ooEAI13+m+VPOITSA979yScEzGpOPtkBHD1uW5gZEgkN?=
 =?us-ascii?Q?BOvUs2r7D4CWNavKg5OOS/h19R38ilxjzWpbNgzFXQyNSydgO/GxzCqo4Uyb?=
 =?us-ascii?Q?JrHIH+0PdDT3LZEYGg6jtsBiJTgXZavvia8/cHKL6/kus3NSYygg8ccPONYM?=
 =?us-ascii?Q?Zz1CxXYlHnj8eFVi5Djya2Uhl1CoDmBuuLbKI2/JCOrDca/BFfB6iwYzsFxi?=
 =?us-ascii?Q?Er8KwZyAY2cm8MRd95t3EpHc5T9hQdz6e71o0lCFTeqduKNs/FuyCp3cCCpr?=
 =?us-ascii?Q?X2vHafTANTfbG7smp6xPRz/TpADaAWFjdUoEf0FG7eyxJydA/8fEJJdTYhAh?=
 =?us-ascii?Q?750yuKgWGXc0yb2IgysmjyDoxbFFw058iZHAn8Xvpz/ea/04o4Vgtb21OMPW?=
 =?us-ascii?Q?4MHQT66jo/ag0RuD4VHK5AuJtULrdpvY3FY3CH8p19r5Vh4SKxz2FRV+AqY0?=
 =?us-ascii?Q?fuAp7VC2hDl7JfKEPx2JqgxZ1tVPuwh83p3+dhcrIyu7V4HUKmEF9KaFC3rU?=
 =?us-ascii?Q?uWCfBbkumBHtPeeD0IdbB+fqcsmsyRpGW9nRIBqq9XIb8IluR0DJ/sW6jWBY?=
 =?us-ascii?Q?XqtXpk/HH/rrFi6RXb78Gos+e7FjLulpyx6VFLGey2YmuY+cm2KVH8dXmT++?=
 =?us-ascii?Q?2qxdIK6YRmNn6C5kLqEh76UoN716fjaBgRw6NZCMFkwYoTEOWc3HCymHm6/L?=
 =?us-ascii?Q?gZ9hFPtuWv1/XVcmzyJZHk5/8yPrqgW4pRAW+4+8EwDCt+UV2d0eupXBJsSf?=
 =?us-ascii?Q?9HZkYd36mtmI9bk7kdUaXhNacgW6GHGvu61S0oVJaNt1D+lw9keWQaphk5Ml?=
 =?us-ascii?Q?TeuwAe+thEfphT5uA0BGrsmp/msc02ske/v6O+wd0RmYCa3rVs4NBnWOWfDL?=
 =?us-ascii?Q?nCsaUf7QDcVxmNVvxuAFn9BMlGR/NTGheuwUspPtkj2qVqc3g++yKofMnXS3?=
 =?us-ascii?Q?GmhdHAFLkuf8Wir2ifq/iGa5aGpBSNSZ17FXmQjG4qIEQt5Qf4Sd20Kqcqwj?=
 =?us-ascii?Q?MrjxXuTKLlyjdEiA4Garul9W6V1qAqxso02Y1ltVICRi0irqL4VXh1VuYPA5?=
 =?us-ascii?Q?YoTz26SzRf6MavQZBO5JWzKIWdBnwHcQoZkKGw+Suv7RTgHiXkI/K2kpfn7p?=
 =?us-ascii?Q?2Q9ne61tn01e8fwwPB3V499w02IfcKDMmlYuKWen56meQ5KejV0S5Xxyu3yw?=
 =?us-ascii?Q?slOckor44myjQg15zRcy4f9RQEu6HuGfltDSxTR2RKDkFReZFL3FBlrto0kY?=
 =?us-ascii?Q?pVoaqo6pONZ41KWViZrcOL6G2+wl6Ln0zmXcpFuCSLyWsHI4bdyQCH4/qngP?=
 =?us-ascii?Q?a/dw4RAFIW3D4sA6P4wrRKU3H6N9ZVZReFZpq6Qk8guztCn/bplWnF3pHelB?=
 =?us-ascii?Q?NR9fSSqHMnUtgj722rF12oHwefGy2vBZqMMYKB5r7oYcgUn2den45m9v31K6?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0Bp6xZqQK+14QaTaxI9X7CL42+FJ43B7wrFjDPkYdIoDPiS9sVnHH+QqS2Uec2BTCmJHjWXboZPDtmhnETlGdlN2C7OlPvudx4G+5ptHmpfOg+mPxvOK7se1cF6HIbYskRZ2HxbIPhfetzyT5vpdEXAOfYWpr4W8ABGDMO6sQONdA/cvoXGgWjlu+DFCt4sdsnb3t+d7iovFfuHuOMKAAQHFcrZFqqIU6zEwN+qzn/JE9mfAGoLXmrmsDj2GvHMNZCjI+4H86a5zHfQ3BeaA3ahJpXBBTOIF6QkB6tScu1vxgk2zCMS6nGEOwa3psqmP/QKKqcEZljhQGr8n5lgLsYk+1gXzZZ4quUzAkYBcsk9MbFJiDFHtaw8T3GGbqYADtoG+9tjdvC1JbAEB989a330wI56cta9fyzd2QkfbUe+tR0807h369C2iffaLQZT6n3MJwPrrn3J0zpEDB2Iy5WR6E3OzeM6zNaEkSmSTVTQNDN2HusJtSu50+K/jPkU/ArphhJOE2p+Gck7Wq9MSzwXTTJ3zk6YWbnMntqnbYoVG4FZkV0ZcMECyMmg+Oe4Ne2Ks4lmGVurN/05BENcosOfSHvqJ9hAT9C5R10xiruG7lRRCZEiewg6zvmd3h9BEgQ5V2JPJonx0CXVEpKhVMG/JCIeT5PrO8HTOmZ9/lj2/AQKpXZ3/P4b505KzRydo1kA1FoHDq1mQztSajLGvYUzS2c8hzuYhSp2+87T0aVdOmhttzUihgS7bI7D+O6+jtEbUBmTZXmmoNykV+DjSVQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c2a1bd-9c14-4728-c693-08db2025cab3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:09.1121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DRaHQfZI51FnkgcIkFcPDpWpGrOAcyuPZQMddqyVwi8+pnrVQiA/DKtotbGU0Z05x4sMi4VhxxkpX/t1BezhmwmLPEOlPju7Z8Qv0uT1duk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: b90vVSNLOT4Zlji-OthrSD0MDnzAESQk
X-Proofpoint-ORIG-GUID: b90vVSNLOT4Zlji-OthrSD0MDnzAESQk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

With parent pointers enabled, a rename operation can update up to 5
inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
their dquots to a be attached to the transaction chain, so we need
to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
function xfs_dqlockn to lock an arbitrary number of dquots.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c       | 38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h       |  1 +
 fs/xfs/xfs_qm.h          |  2 +-
 fs/xfs/xfs_trans_dquot.c | 15 ++++++++++-----
 4 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8fb90da89787..9f311729c4c8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1333,6 +1333,44 @@ xfs_dqlock2(
 	}
 }
 
+static int
+xfs_dqtrx_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_dqtrx	*qa = a;
+	const struct xfs_dqtrx	*qb = b;
+
+	if (qa->qt_dquot->q_id > qb->qt_dquot->q_id)
+		return 1;
+	if (qa->qt_dquot->q_id < qb->qt_dquot->q_id)
+		return -1;
+	return 0;
+}
+
+void
+xfs_dqlockn(
+	struct xfs_dqtrx	*q)
+{
+	unsigned int		i;
+
+	/* Sort in order of dquot id, do not allow duplicates */
+	for (i = 0; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++) {
+		unsigned int	j;
+
+		for (j = 0; j < i; j++)
+			ASSERT(q[i].qt_dquot != q[j].qt_dquot);
+	}
+	if (i == 0)
+		return;
+
+	sort(q, i, sizeof(struct xfs_dqtrx), xfs_dqtrx_cmp, NULL);
+
+	mutex_lock(&q[0].qt_dquot->q_qlock);
+	for (i = 1; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++)
+		mutex_lock_nested(&q[i].qt_dquot->q_qlock, XFS_QLOCK_NESTED);
+}
+
 int __init
 xfs_qm_init(void)
 {
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3..dc7d0226242b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -223,6 +223,7 @@ int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlockn(struct xfs_dqtrx *q);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9683f0457d19..c6ec88779356 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -120,7 +120,7 @@ enum {
 	XFS_QM_TRANS_PRJ,
 	XFS_QM_TRANS_DQTYPES
 };
-#define XFS_QM_TRANS_MAXDQS		2
+#define XFS_QM_TRANS_MAXDQS		5
 struct xfs_dquot_acct {
 	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
 };
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72..8a48175ea3a7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -268,24 +268,29 @@ xfs_trans_mod_dquot(
 
 /*
  * Given an array of dqtrx structures, lock all the dquots associated and join
- * them to the transaction, provided they have been modified.  We know that the
- * highest number of dquots of one type - usr, grp and prj - involved in a
- * transaction is 3 so we don't need to make this very generic.
+ * them to the transaction, provided they have been modified.
  */
 STATIC void
 xfs_trans_dqlockedjoin(
 	struct xfs_trans	*tp,
 	struct xfs_dqtrx	*q)
 {
+	unsigned int		i;
 	ASSERT(q[0].qt_dquot != NULL);
 	if (q[1].qt_dquot == NULL) {
 		xfs_dqlock(q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
-	} else {
-		ASSERT(XFS_QM_TRANS_MAXDQS == 2);
+	} else if (q[2].qt_dquot == NULL) {
 		xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[1].qt_dquot);
+	} else {
+		xfs_dqlockn(q);
+		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+			if (q[i].qt_dquot == NULL)
+				break;
+			xfs_trans_dqjoin(tp, q[i].qt_dquot);
+		}
 	}
 }
 
-- 
2.25.1

