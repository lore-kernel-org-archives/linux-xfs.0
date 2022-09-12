Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671E1C6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiILN3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiILN3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F7A3056D
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:24 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEhaN003079;
        Mon, 12 Sep 2022 13:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=udWJHwQTbQMzh+RPRoQjjJRKxpW2w+l2RGZblf4Ct+c=;
 b=RvmRGDgh7Q71/sLRcbt/YLpAlTN4KB8j+MkWs0ieJAkRqKB68RBZYXs0pqDV8JbQxexi
 /0kbDXGMnyl+IfofCsZa0/3idSo3v20RNyuxBvTk9TjCZlhAP74SSeaOtPLkwDdmZjFV
 UGQyu/0oJEZerY5meD2zxUjaB23gi6fSqkjvTtfF5r05+ZIWgU7mpQbMNpq+tPfNBbee
 O+3hlakWnRYhYJW6nyjWtDYFquzFjafFDN2Rut5E2IAFsHuWOfQYjCIxj0fq9PcQAbJp
 HkDs9pNN0373emDtnydOm00S4/Zu0ixoMSTjELk21uNi1FpyDk8v6RDQ93YQmojjnmA/ 2Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgh61khkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgE2014576;
        Mon, 12 Sep 2022 13:29:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgk8n7u60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m08fmvsVGOU1ILoBrf5jgLKsS+0Gc8GKY4lhp+wpOlKNm6zCipUc5o4WXjdbFDG2smEK73q8bsLwaqsYIwhOivmfYq8VQ+KaPdzu0f+I9078wSlsV54prkNxBZeC3B57SSgXVHYGeiK7xDCcF+qWq4AD+ju/WMldNHC8b3TrZ4Dzt7FIqnvakiXSUEOpVUaB3V1JT9NbqhkPfrDY+gbmRwsSq8/Ky9ttwaxSk+V1U27XgCWZHjanIHd5v8mxcnVPQapFAFZE9Z9+sHSg6wRIVrapCqQR2pMaDax71NCk0RZd/2ne0DLdDcDA5ki5yukYAaq9GZM3gOXvMVGzCVoHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=udWJHwQTbQMzh+RPRoQjjJRKxpW2w+l2RGZblf4Ct+c=;
 b=hmTlEoTjH8z3W1gh2i+6FM9si+N9JXx44i2FsU0vss/Ab2P8cDp40qOLDUgZsRdjU+BIKvaCkcuTgR6aNo/088L24Df2MjxdkPId+RMLuPqp++Hfz38stbALqT26q+LUnRVaCn3Fp0s+f7QNKtYsuHDCVOlE9SQRSNP+YB0qwom3MXXPJpVXPF3StMmTtfNtVWFstsTehbnzwgc9edZJC3ANQUeMkpnJoEEC5iG8O3cE2ZFJy8b5he9vB8FirRg+zS9BCwYGk3F1GJHmr8PlOgWY6+tCF9okHHqbNs2AN4hPluqr6nnwg2xOSfUsyUx1Oe2VGg5nQLNpz/+iu/hRZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udWJHwQTbQMzh+RPRoQjjJRKxpW2w+l2RGZblf4Ct+c=;
 b=D0Bvtmpnkkb2q203I91TkxLFjITwa72FVV7kqrdN+wmc/eLrruFAgkniOAGqH0nlXIAK0VAHRDO1j37VbBLU0XOqGBLSLNeLV+Z5aBAPiQUytPZBwN/YquhxMZkJFx4fiijk5kLbh9dn6b5szM422uue7KPUDqD4OrRaL++pwrM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:15 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 12/18] xfs: always log corruption errors
Date:   Mon, 12 Sep 2022 18:57:36 +0530
Message-Id: <20220912132742.1793276-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:4:197::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: df75b574-531a-4f8d-1a50-08da94c2c995
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A/dsH0SuzA5ZzpX0/OPZyBB+8tsEXDlwMZ3HiKzFRXvy7Qy6TGYWS7yseroj/lglzXDP/SdIaJSiD6bwZVQ1OTXo6nGrerzuxzW4o64gL5TuMqreL1LDRVz4jJ0qsRpzdErIMW4NjjVgcz9q9LJg7sc6Mi7qDyPTy42YRYV+n+b69kSjd49Njtd0/RileYoi3E+drUN5mitTnZrBrx20nHRlNjeTKUE8G7TLrJOAJdIqhmia7y3WL9O52ry9AXe9KrMn2uGhwjXqULUrdf6X3dEBp3ED+yHAgmkXlmZ6JSoLICxBoU2AGFKFEPYmZiIysYPXJRhqiw+JGGsJ4V2JwUvzOKtozLDf+F4bKYZT6RajcsKSbzhZRVLeVXsYyncrKWGBXWWbqdpZjdOoz77TPERUnnx/JEFmEpaAzmw/dBmoFYGfa4xpS1zCeIU2JBgKLoRWUGzmTAMLBbI9Tg3Bd5TIz5l4+MbRkbHCkV6ZYB+je5C6YELceZkDp8tbwA7ojsrniQiMcHg9WrIz53cPww6RIgOdaSWibrEssLayO7zkg7AG0/OWk4GiXsI66/6l7Z8IAUmpWNpD4CZ3aabX/yAkmhANVFXijlLopkDvhh9muPnsMW1zucB8SuuB5RS9bc1pthWMuDvhZuLRwzOL8QYdKpzHPxCbLeWWi63K6PW1FyBUI2DlzZi5UQ0Q9WxcS2ZVY6XhjkfKt1s7xBkcFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(6916009)(38100700002)(6512007)(2906002)(30864003)(5660300002)(8936002)(66946007)(66476007)(66556008)(8676002)(4326008)(186003)(6506007)(2616005)(1076003)(478600001)(26005)(83380400001)(41300700001)(6666004)(6486002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y9Zw1tHQ9S/4vy00MioVlTGE1hXezFyWy0vA82/zAp5UdJFwZVFOGamaOUCF?=
 =?us-ascii?Q?iFtqGrPnua9cDDZiUbMN8gRPgsxZGfYwxcvsemoT4/N9MwXIfPvccBt+HVUn?=
 =?us-ascii?Q?ujAiVmgM9JsSm33zy399oBfm9A8HkewpIkPmmsqow34vB/o3TM5IVs92ZJSp?=
 =?us-ascii?Q?GaiijZ3o9YNtCOwEPuFeb9/Na3vZm3Azc8Z7QIVivgmsKg6ga2YUZcTqvd8w?=
 =?us-ascii?Q?TTAethrqpiE7QSD0NINmGqJ5hFMJ5B5YuRdqGvi13YEJ44jL+aXJMjWkBQVi?=
 =?us-ascii?Q?dfXdJFm4bVPC4TlnF7XoBsQlsrqek4YBvfEKA24v53ypx23fGgHJIxrxYCzn?=
 =?us-ascii?Q?XaTvFXa5ga5xHRZHO3X07lUl7S+bdwUK8t26fCK+mDSxfZ5IgW/7JbCrIgeS?=
 =?us-ascii?Q?EwHJ5BAH3DQwHwPxhUoULPxYOoaYGddK00czJ62yRQ2+ka//PjfMgN2YlU7M?=
 =?us-ascii?Q?Ad6VTd+NJahbIHVpSW3TZR1LPnXgYfcYKPch79D9jnhCR1LuzO3iirnveNLf?=
 =?us-ascii?Q?2XjyXKMtCO5gv5U3eeqd91F3j1zyy55FygNbHayA+VMj+mMVpD1EbX6RKXwU?=
 =?us-ascii?Q?OzgyljyQ6QV7Y6RvQnRrqI0Rw54dhLjOvO8+XGqZ/OJIYffJaImEuAjEM5/u?=
 =?us-ascii?Q?IRSrYVZ6OXwBoKBMC3jh2vKa/RJQZ9h+KeI5l8av5g0PmErgjaYgZlRy9Ysp?=
 =?us-ascii?Q?sF7zS+MTbpxPTSxN0G8YfZwKMPeBb1p9HUkhy8eYjc2dBLVeCOLntB3zM367?=
 =?us-ascii?Q?8zftsLlDDx4JthPj+nTr9I5jFXwjzj44ACkCwg++AgLsNf9tfV28j22WJhsf?=
 =?us-ascii?Q?LhVuyQGEvIsVQtNytqJb1dyeclkpCMtO/gcOMyDH7wiOQhjIjYuiyr9cuvAO?=
 =?us-ascii?Q?iTi+oZ2prxE9mZGNIlBjHwsnfARnHOrROwm3VMruRKKujSIsCZmvH3svA795?=
 =?us-ascii?Q?nMkl3buXqSb2Wios/yDACxtaBuiMYqqkdPecIKxTXoZXoOKlZI6DelsTNRp7?=
 =?us-ascii?Q?FKf5p0pOK8G5RINGOBQ4luo7L6yj6KAQn1d8YjtkZ4H1eOGnG/+xuYMtIIrT?=
 =?us-ascii?Q?ap0o4/XliGWz80NIAxa7qw698Umj1sha1btEMOBNGmnJa8++gxqExwOLvHX8?=
 =?us-ascii?Q?XS4wsgNfVe+kS6uCuH6IUYZXUZjjndiIgj2A+YXXCaAf3aU0s7ZmxBZ7mfBN?=
 =?us-ascii?Q?GtjK3JU5N6wR26u4W7gSD7O46v2mjnnzH+Gk3KwY7B7Us9GrecR+HOk840yn?=
 =?us-ascii?Q?dexbLrTjBSjvPIqwbtyjXQPD/dkVSzfKGkSAG5RPvBA9/MHjupY6ZvcIpkA1?=
 =?us-ascii?Q?tnNDyoMyIWNBkhlVtr/j/xPnCicCh2DlABVj5UbEVSPN2T4B8apw7nhxSo/G?=
 =?us-ascii?Q?/gHr+tW5Gzj2RGTLUVOTvdpXfP4dO8aFre1pRoLWWD+Ft1p/GIqODGCyQv0r?=
 =?us-ascii?Q?FfLqeIOz/keCeUdC377HT8b1/twUZ+7pk2QLwqj/TffM1G8GDWyxlZ3GM1Lk?=
 =?us-ascii?Q?+XyjRMtoncJKehXh24Rnr6myERvXz+LzGjl9fsvT7o5uIoBbTsxqNzZSQjlm?=
 =?us-ascii?Q?rapyzli9WnDiepwR0+rVegZVfKY+sQlFBumdae+o5b6zLRo0hFHC01m8APnO?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df75b574-531a-4f8d-1a50-08da94c2c995
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:15.3998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ck5mAcm3B6/IIYimDwy3RDcPBBfzsvsxiE9UC5cuuoVG9ssWqrRHm7tzUull1lLTO4pCl3nBiQhAxTKO6lmycw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-ORIG-GUID: IQZSFiHxP7VF6xqJPp6nyufoX4M_9wmG
X-Proofpoint-GUID: IQZSFiHxP7VF6xqJPp6nyufoX4M_9wmG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5155b870d687de1a5f07e774b49b1e8ef0f6f50 upstream.

Make sure we log something to dmesg whenever we return -EFSCORRUPTED up
the call stack.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |  9 +++++++--
 fs/xfs/libxfs/xfs_attr_leaf.c  | 12 +++++++++---
 fs/xfs/libxfs/xfs_bmap.c       |  8 +++++++-
 fs/xfs/libxfs/xfs_btree.c      |  5 ++++-
 fs/xfs/libxfs/xfs_da_btree.c   | 24 ++++++++++++++++++------
 fs/xfs/libxfs/xfs_dir2.c       |  4 +++-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  4 +++-
 fs/xfs/libxfs/xfs_dir2_node.c  | 12 +++++++++---
 fs/xfs/libxfs/xfs_inode_fork.c |  6 ++++++
 fs/xfs/libxfs/xfs_refcount.c   |  4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c   |  6 ++++--
 fs/xfs/xfs_acl.c               | 15 ++++++++++++---
 fs/xfs/xfs_attr_inactive.c     |  6 +++++-
 fs/xfs/xfs_attr_list.c         |  5 ++++-
 fs/xfs/xfs_bmap_item.c         |  3 ++-
 fs/xfs/xfs_error.c             | 21 +++++++++++++++++++++
 fs/xfs/xfs_error.h             |  1 +
 fs/xfs/xfs_extfree_item.c      |  3 ++-
 fs/xfs/xfs_inode.c             | 15 ++++++++++++---
 fs/xfs/xfs_inode_item.c        |  5 ++++-
 fs/xfs/xfs_iops.c              | 10 +++++++---
 fs/xfs/xfs_log_recover.c       | 23 ++++++++++++++++++-----
 fs/xfs/xfs_qm.c                | 13 +++++++++++--
 fs/xfs/xfs_refcount_item.c     |  3 ++-
 fs/xfs/xfs_rmap_item.c         |  7 +++++--
 25 files changed, 179 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 436f686a9891..f1cdf5fbaa71 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -684,8 +684,10 @@ xfs_alloc_update_counters(
 
 	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
-		     be32_to_cpu(agf->agf_length)))
+		     be32_to_cpu(agf->agf_length))) {
+		xfs_buf_corruption_error(agbp);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FREEBLKS);
 	return 0;
@@ -751,6 +753,7 @@ xfs_alloc_ag_vextent_small(
 
 		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
 		if (!bp) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->mp);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2087,8 +2090,10 @@ xfs_free_agfl_block(
 		return error;
 
 	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
-	if (!bp)
+	if (!bp) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp);
 		return -EFSCORRUPTED;
+	}
 	xfs_trans_binval(tp, bp);
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index de33efc9b4f9..0c23127347ac 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2287,8 +2287,10 @@ xfs_attr3_leaf_lookup_int(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
-	if (ichdr.count >= args->geo->blksize / 8)
+	if (ichdr.count >= args->geo->blksize / 8) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Binary search.  (note: small blocks will skip this loop)
@@ -2304,10 +2306,14 @@ xfs_attr3_leaf_lookup_int(
 		else
 			break;
 	}
-	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count)))
+	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
-	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval))
+	}
+	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Since we may have duplicate hashval's, find the first matching
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de4e71725b2c..e7fa611887ad 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -729,6 +729,7 @@ xfs_bmap_extents_to_btree(
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
 	if (!abp) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out_unreserve_dquot;
 	}
@@ -1084,6 +1085,7 @@ xfs_bmap_add_attrfork(
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 	if (ip->i_d.di_anextents != 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto trans_cancel;
 	}
@@ -1374,6 +1376,7 @@ xfs_bmap_last_before(
 	case XFS_DINODE_FMT_EXTENTS:
 		break;
 	default:
+		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 
@@ -1474,8 +1477,10 @@ xfs_bmap_last_offset(
 		return 0;
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
+	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS) {
+		ASSERT(0);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -5872,6 +5877,7 @@ xfs_bmap_insert_extents(
 				del_cursor);
 
 	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
+		ASSERT(0);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 71de937f9e64..a13a25e922ec 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1820,6 +1820,7 @@ xfs_btree_lookup_get_block(
 
 out_bad:
 	*blkp = NULL;
+	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
 	return -EFSCORRUPTED;
 }
@@ -1867,8 +1868,10 @@ xfs_btree_lookup(
 	XFS_BTREE_STATS_INC(cur, lookup);
 
 	/* No such thing as a zero-level tree. */
-	if (cur->bc_nlevels == 0)
+	if (cur->bc_nlevels == 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
 		return -EFSCORRUPTED;
+	}
 
 	block = NULL;
 	keyno = 0;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 4fd1223c1bd5..1e2dc65adeb8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -504,6 +504,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
+			xfs_buf_corruption_error(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -516,6 +517,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
+			xfs_buf_corruption_error(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1541,8 +1543,10 @@ xfs_da3_node_lookup_int(
 			break;
 		}
 
-		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC)
+		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
+		}
 
 		blk->magic = XFS_DA_NODE_MAGIC;
 
@@ -1554,15 +1558,18 @@ xfs_da3_node_lookup_int(
 		btree = dp->d_ops->node_tree_p(node);
 
 		/* Tree taller than we can handle; bail out! */
-		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
+		}
 
 		/* Check the level from the root. */
 		if (blkno == args->geo->leafblk)
 			expected_level = nodehdr.level - 1;
-		else if (expected_level != nodehdr.level)
+		else if (expected_level != nodehdr.level) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
-		else
+		} else
 			expected_level--;
 
 		max = nodehdr.count;
@@ -1612,12 +1619,17 @@ xfs_da3_node_lookup_int(
 		}
 
 		/* We can't point back to the root. */
-		if (blkno == args->geo->leafblk)
+		if (blkno == args->geo->leafblk) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					dp->i_mount);
 			return -EFSCORRUPTED;
+		}
 	}
 
-	if (expected_level != 0)
+	if (expected_level != 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, dp->i_mount);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * A leaf block that ends in the hashval that we are interested in
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 867c5dee0751..452d04ae10ce 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -600,8 +600,10 @@ xfs_dir2_isblock(
 	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
-	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize)
+	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount);
 		return -EFSCORRUPTED;
+	}
 	*vp = rval;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a53e4585a2f3..388b5da12228 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1343,8 +1343,10 @@ xfs_dir2_leaf_removename(
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	if (be16_to_cpu(bestsp[db]) != oldbest)
+	if (be16_to_cpu(bestsp[db]) != oldbest) {
+		xfs_buf_corruption_error(lbp);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Mark the former data entry unused.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 99d5b2ed67f2..35e698fa85fd 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -374,8 +374,10 @@ xfs_dir2_leaf_to_node(
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
-				(uint)dp->i_d.di_size / args->geo->blksize)
+				(uint)dp->i_d.di_size / args->geo->blksize) {
+		xfs_buf_corruption_error(lbp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Copy freespace entries from the leaf block to the new block.
@@ -446,8 +448,10 @@ xfs_dir2_leafn_add(
 	 * Quick check just to make sure we are not going to index
 	 * into other peoples memory
 	 */
-	if (index < 0)
+	if (index < 0) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If there are already the maximum number of leaf entries in
@@ -740,8 +744,10 @@ xfs_dir2_leafn_lookup_for_entry(
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
-	if (leafhdr.count <= 0)
+	if (leafhdr.count <= 0) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Look up the hash value in the leaf entries.
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 8fdd0424070e..15d6f947620f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -75,11 +75,15 @@ xfs_iformat_fork(
 			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
 		default:
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
 			return -EFSCORRUPTED;
 		}
 		break;
 
 	default:
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
 		return -EFSCORRUPTED;
 	}
 	if (error)
@@ -110,6 +114,8 @@ xfs_iformat_fork(
 		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
 		break;
 	default:
+		xfs_inode_verifier_error(ip, error, __func__, dip,
+				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
 		break;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 9a7fadb1361c..78236bd6c64f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1591,8 +1591,10 @@ xfs_refcount_recover_extent(
 	struct list_head		*debris = priv;
 	struct xfs_refcount_recovery	*rr;
 
-	if (be32_to_cpu(rec->refc.rc_refcount) != 1)
+	if (be32_to_cpu(rec->refc.rc_refcount) != 1) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
 		return -EFSCORRUPTED;
+	}
 
 	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 42085e70c01a..85f123b3dfcc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -15,7 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
-
+#include "xfs_error.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -70,8 +70,10 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map))
+	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
+	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 96d7071cfa46..3f2292c7835c 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -12,6 +12,7 @@
 #include "xfs_inode.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 #include <linux/posix_acl_xattr.h>
 
 
@@ -23,6 +24,7 @@
 
 STATIC struct posix_acl *
 xfs_acl_from_disk(
+	struct xfs_mount	*mp,
 	const struct xfs_acl	*aclp,
 	int			len,
 	int			max_entries)
@@ -32,11 +34,18 @@ xfs_acl_from_disk(
 	const struct xfs_acl_entry *ace;
 	unsigned int count, i;
 
-	if (len < sizeof(*aclp))
+	if (len < sizeof(*aclp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, aclp,
+				len);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	count = be32_to_cpu(aclp->acl_cnt);
-	if (count > max_entries || XFS_ACL_SIZE(count) != len)
+	if (count > max_entries || XFS_ACL_SIZE(count) != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, aclp,
+				len);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)
@@ -145,7 +154,7 @@ xfs_get_acl(struct inode *inode, int type)
 		if (error != -ENOATTR)
 			acl = ERR_PTR(error);
 	} else  {
-		acl = xfs_acl_from_disk(xfs_acl, len,
+		acl = xfs_acl_from_disk(ip->i_mount, xfs_acl, len,
 					XFS_ACL_MAX_ENTRIES(ip->i_mount));
 		kmem_free(xfs_acl);
 	}
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index f83f11d929e4..43ae392992e7 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -22,6 +22,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
+#include "xfs_error.h"
 
 /*
  * Look at all the extents for this logical region,
@@ -209,6 +210,7 @@ xfs_attr3_node_inactive(
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -258,8 +260,9 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			error = -EFSCORRUPTED;
+			xfs_buf_corruption_error(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
+			error = -EFSCORRUPTED;
 			break;
 		}
 		if (error)
@@ -342,6 +345,7 @@ xfs_attr3_root_inactive(
 		break;
 	default:
 		error = -EFSCORRUPTED;
+		xfs_buf_corruption_error(bp);
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 00758fdc2fec..8b9b500e75e8 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -258,8 +258,10 @@ xfs_attr_node_list_lookup(
 			return 0;
 
 		/* We can't point back to the root. */
-		if (cursor->blkno == 0)
+		if (cursor->blkno == 0) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	if (expected_level != 0)
@@ -269,6 +271,7 @@ xfs_attr_node_list_lookup(
 	return 0;
 
 out_corruptbuf:
+	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d84339c91466..243e5e0f82a3 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -21,7 +21,7 @@
 #include "xfs_icache.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -525,6 +525,7 @@ xfs_bui_recover(
 		type = bui_type;
 		break;
 	default:
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto err_inode;
 	}
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 0b156cc88108..d8cdb27fe6ed 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -341,6 +341,27 @@ xfs_corruption_error(
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
 
+/*
+ * Complain about the kinds of metadata corruption that we can't detect from a
+ * verifier, such as incorrect inter-block relationship data.  Does not set
+ * bp->b_error.
+ */
+void
+xfs_buf_corruption_error(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+
+	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
+		  "Metadata corruption detected at %pS, %s block 0x%llx",
+		  __return_address, bp->b_ops->name, bp->b_bn);
+
+	xfs_alert(mp, "Unmount and run xfs_repair");
+
+	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
+
 /*
  * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
  * values, and omit the stack trace unless the error level is tuned high.
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index e6a22cfb542f..c319379f7d1a 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -15,6 +15,7 @@ extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
+void xfs_buf_corruption_error(struct xfs_buf *bp);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 1b3ade30ef65..a05a1074e8f8 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -21,7 +21,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
@@ -228,6 +228,7 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 		}
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8990be13a16c..70c5050463a6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2149,8 +2149,10 @@ xfs_iunlink_update_bucket(
 	 * passed in because either we're adding or removing ourselves from the
 	 * head of the list.
 	 */
-	if (old_value == new_agino)
+	if (old_value == new_agino) {
+		xfs_buf_corruption_error(agibp);
 		return -EFSCORRUPTED;
+	}
 
 	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
 	offset = offsetof(struct xfs_agi, agi_unlinked) +
@@ -2213,6 +2215,8 @@ xfs_iunlink_update_inode(
 	/* Make sure the old pointer isn't garbage. */
 	old_value = be32_to_cpu(dip->di_next_unlinked);
 	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -2224,8 +2228,11 @@ xfs_iunlink_update_inode(
 	 */
 	*old_next_agino = old_value;
 	if (old_value == next_agino) {
-		if (next_agino != NULLAGINO)
+		if (next_agino != NULLAGINO) {
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
 			error = -EFSCORRUPTED;
+		}
 		goto out;
 	}
 
@@ -2276,8 +2283,10 @@ xfs_iunlink(
 	 */
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(mp, agno, next_agino))
+	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
+		xfs_buf_corruption_error(agibp);
 		return -EFSCORRUPTED;
+	}
 
 	if (next_agino != NULLAGINO) {
 		struct xfs_perag	*pag;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index bb8f076805b9..726aa3bfd6e8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 #include <linux/iversion.h>
 
@@ -828,8 +829,10 @@ xfs_inode_item_format_convert(
 {
 	struct xfs_inode_log_format_32	*in_f32 = buf->i_addr;
 
-	if (buf->i_len != sizeof(*in_f32))
+	if (buf->i_len != sizeof(*in_f32)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 		return -EFSCORRUPTED;
+	}
 
 	in_f->ilf_type = in_f32->ilf_type;
 	in_f->ilf_size = in_f32->ilf_size;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ca8c763902b9..80dd05f8f1af 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -20,6 +20,7 @@
 #include "xfs_symlink.h"
 #include "xfs_dir2.h"
 #include "xfs_iomap.h"
+#include "xfs_error.h"
 
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
@@ -470,17 +471,20 @@ xfs_vn_get_link_inline(
 	struct inode		*inode,
 	struct delayed_call	*done)
 {
+	struct xfs_inode	*ip = XFS_I(inode);
 	char			*link;
 
-	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(ip->i_df.if_flags & XFS_IFINLINE);
 
 	/*
 	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
 	 * if_data is junk.
 	 */
-	link = XFS_I(inode)->i_df.if_u1.if_data;
-	if (!link)
+	link = ip->i_df.if_u1.if_data;
+	if (!link) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, ip->i_mount);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
 	return link;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 796bbc9dd8b0..02f2147952b3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3537,6 +3537,7 @@ xfs_cui_copy_format(
 		memcpy(dst_cui_fmt, src_cui_fmt, len);
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
@@ -3601,8 +3602,10 @@ xlog_recover_cud_pass2(
 	struct xfs_ail			*ailp = log->l_ailp;
 
 	cud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format))
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	cui_id = cud_formatp->cud_cui_id;
 
 	/*
@@ -3654,6 +3657,7 @@ xfs_bui_copy_format(
 		memcpy(dst_bui_fmt, src_bui_fmt, len);
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
@@ -3677,8 +3681,10 @@ xlog_recover_bui_pass2(
 
 	bui_formatp = item->ri_buf[0].i_addr;
 
-	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	buip = xfs_bui_init(mp);
 	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
 	if (error) {
@@ -3720,8 +3726,10 @@ xlog_recover_bud_pass2(
 	struct xfs_ail			*ailp = log->l_ailp;
 
 	bud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format))
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	bui_id = bud_formatp->bud_bui_id;
 
 	/*
@@ -5181,8 +5189,10 @@ xlog_recover_process(
 		 * If the filesystem is CRC enabled, this mismatch becomes a
 		 * fatal log corruption failure.
 		 */
-		if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
+		if (xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	xlog_unpack_data(rhead, dp, log);
@@ -5305,8 +5315,11 @@ xlog_do_recovery_pass(
 		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
 					 h_size, log->l_mp->m_logbsize);
 				h_size = log->l_mp->m_logbsize;
-			} else
+			} else {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						log->l_mp);
 				return -EFSCORRUPTED;
+			}
 		}
 
 		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ecd8ce152ab1..66ea8e4fca86 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -22,6 +22,7 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_error.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -754,11 +755,19 @@ xfs_qm_qino_alloc(
 		if ((flags & XFS_QMOPT_PQUOTA) &&
 			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_gquotino;
-			ASSERT(mp->m_sb.sb_pquotino == NULLFSINO);
+			if (mp->m_sb.sb_pquotino != NULLFSINO) {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						mp);
+				return -EFSCORRUPTED;
+			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
 			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_pquotino;
-			ASSERT(mp->m_sb.sb_gquotino == NULLFSINO);
+			if (mp->m_sb.sb_gquotino != NULLFSINO) {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						mp);
+				return -EFSCORRUPTED;
+			}
 		}
 		if (ino != NULLFSINO) {
 			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index e22ac9cdb971..d5708d40ad87 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -17,7 +17,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_log.h"
 #include "xfs_refcount.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
@@ -536,6 +536,7 @@ xfs_cui_recover(
 			type = refc_type;
 			break;
 		default:
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index af83e2b2a429..02f84d9a511c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -17,7 +17,7 @@
 #include "xfs_rmap_item.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
@@ -171,8 +171,10 @@ xfs_rui_copy_format(
 	src_rui_fmt = buf->i_addr;
 	len = xfs_rui_log_format_sizeof(src_rui_fmt->rui_nextents);
 
-	if (buf->i_len != len)
+	if (buf->i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 		return -EFSCORRUPTED;
+	}
 
 	memcpy(dst_rui_fmt, src_rui_fmt, len);
 	return 0;
@@ -581,6 +583,7 @@ xfs_rui_recover(
 			type = XFS_RMAP_FREE;
 			break;
 		default:
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
-- 
2.35.1

