Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E90ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiILNaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiILNaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:30:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2213313DFC
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:30:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEUF2030573;
        Mon, 12 Sep 2022 13:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=aXz8Zn1pvGqZ91NyHpSd7Dvj2nNweefo0N5R5lQ0a0A=;
 b=s1mPApwCyI3PEJugYxQ212I3LWAl8q2BrsGa9/5zHJYiRvYz7hJPqdLDTOoTZoTjDMAd
 CEhmzYDEeDm54z2pdMOv3cCtkbRH0PB9uWe7rioLRngjC1200PlrwwosgLsnNLalQq//
 aopBK/6AF6IXzRlW9vjjSitZszQyGcKMBSantrF5e4v48Ea+3+DGuygYbIFv/BSnGFyl
 7As/F/OvBcUGs1Hb6TPA133kF8hKs4QpkuVyruoUKL2RIXFTcIIKc0GEeqOln88JlJfe
 cEjxVde7jx0+2g5zAD7gDAFvpZ/upGBX2jxla0x/uB7x8oWb8gVadZ63rKclQk3E0bIr AQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jghc2kgxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:30:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEg9n014574;
        Mon, 12 Sep 2022 13:29:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgk8n7ujk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ0JFUDv2Xv/nG7DeJCEUKvowDp9sBd0QjTTmJaE4WCS6RAQtRB6FUbfUf1Iz/N3cmDZ00RL/TZExnw28xNaRwotVjNmVAOeC64OYKT3mHyBMZRH961bzmlV722sLjrUSAXdLgz5dGk7cn1ZWZF09CFx8C/T+Ka9vykKr0H1UL9749evQ6KBAqFAuVvlt8uokpXG5/0n78QkOiScXrMX0Y1oG83hrbe8+nEWHOb7mP9onSXgOjh8uUjGFvu7TEKcWuQamR0f8NklO4Qx1yme5U+kMv3Zx69wfvs3uXtju1n/nCpKDKd1v+/g5ap3aXvDAKJMpjzPeXKWYaxrzNCfdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXz8Zn1pvGqZ91NyHpSd7Dvj2nNweefo0N5R5lQ0a0A=;
 b=nqfzsRXiEPD5pcEZjaxAWluYGStzBx8zBbcWGsijcPowHzIifcpUYTBkPeyYYVQ9tYhHB0Qsdl3Q+2HN18ffVjUJkQC/Z2fG91gJbWS6MA92D0gOOXYjvb75QfAMIExKz3YHZ8O+M7TwItXGnOFbBhx3HVBzZXB8qp4TKjYMB/570zhmBnUXQwNsOAO9bV8SDILfZ568wyjSnG/tKcriuvz392Y3julSpFcky0ypOEygmjBgq8fFTei9CygUX3AJWQtrQ7PaQ12dE7iUQjvhshS3+uqAPp8nl3hRDuTOT1aPZbZB5HaqBwk1EvYMRvTUF5duK5RiRorOAmnnPT83tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXz8Zn1pvGqZ91NyHpSd7Dvj2nNweefo0N5R5lQ0a0A=;
 b=jT9xrwAiYbkzieXYPxWuRItbgwv6IxHt6pIeBjz4kjZvvrF6M4Y1fDVXVh2eWo3GMZgrfmN9qtOddIxImy7dh67z/sjZRMH3PHxw4ZeLBGMZJ0+u6/DfGo1Pqfm0Cj20tvQbwc9JULz4fIKVrOmk4mZcTZMxZy0pMFCHK4+h5YA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:57 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 18/18] xfs: don't commit sunit/swidth updates to disk if that would cause repair failures
Date:   Mon, 12 Sep 2022 18:57:42 +0530
Message-Id: <20220912132742.1793276-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0123.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: bcd4ecd2-7ede-404f-4716-08da94c2e25d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSKH1rk77TLjplGTMeJOuSWaQC8eWIwOIDBCZbM+SU0WwZxyY+QsDSCE4Xqn4L4URJ3fpdO9ZX2eUVVQHFVU2h7+wCBX9hoERnldIqpK4UjMf7eMcM+H7f/C8NTENVoR7mlC47ZQQB+IiyxD0bS9BUSoAaNPLBg5Qd430YoHrN6mZHny/+OMY3htNe4K5ynZNpkBT0YUrM39KMDBaP1ABu2IPCdo7Lj03eMc/eSIqMTwmTQS77nUI2BuhKUmPD+fYG7LtwudfAd3jH6Dmo+ywJcKp+LuqPUb3LJgEYiiDNjpe4T18/xuIiczfy1FVrCcO9Vtm9Kv/gSeW6b+iGr4hy/rOTuJV6DOWrZe4fuKbz9icGtpFxQ623iE10u1WzrwlEPUq5/iLh1CGWhdAdkSeSAdwhThD17GFXzi3Ebix4FzDnDsFMd1CoGeN48taqfp0yGXoQEVEWRMeCKoG0Ick4S57SqgQfGJVs+ER+SwLduw6s7vFI1xYBCuC1fdkICwByz7AQauOereVZLqpFfUaVZ+W3VxrJSctCxOZnOuwaG3vjODCn/nGvZJyoF8xFZZ348qDONIW611KQs74b3GwChvBvfZC6fzFVastZ3D6D9hwaTCKI2AOf35e9B4MetXddWS0go24cY7FsvSAL9Dq3DDD+InxZ8GRco7CGSLEHbL+d0OLTAKp2WGkP1OR6SIElT5KgxkgZxFWNUI1eInTA62bK/fGCFQFLzSB5F9Z3e5Sb2Ccd2t85y+2HYU84c7kiFVW6cPfojTx5W6WB/1rOWb1c5EWY4NX5e1bcV9H0s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(39860400002)(366004)(1076003)(6506007)(26005)(478600001)(6486002)(6512007)(6666004)(966005)(186003)(83380400001)(2906002)(2616005)(15650500001)(8936002)(5660300002)(6916009)(316002)(41300700001)(36756003)(66556008)(66946007)(66476007)(38100700002)(8676002)(4326008)(86362001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZFDxgHcvkQsUqTMx9+hVI1ZoYtm4lc/MOMAEJ54KOgRAuuf7D06VLQr18Aal?=
 =?us-ascii?Q?gWBiWCDR7GU9GlbrVdOjACH9VecmLHojRiKfwSR0WusVAKWTE8B4SjuUDxz0?=
 =?us-ascii?Q?tFN1XoN2hMDDLaGtr4jOSxRwIT+UTXuCP9kIGKpM902wsyEtADKqg63YFgTa?=
 =?us-ascii?Q?u6UIt5hRzHAl1M6ktcseVol45eeZQLug3eTOnHJkf/yE2/ra+E4Ddc9obgFM?=
 =?us-ascii?Q?kLhdiPSDOxuO/DcpUAemHWSxT+z+ExL2MDyw5Ptzq4u3DbM4r/Sr9UlI8Ptr?=
 =?us-ascii?Q?+HQIoN+n10xl7QDrsYeGPl4AL+dEuPWwAPRwR0bwh7RkZrptuDdyyCe+Sysz?=
 =?us-ascii?Q?g3zjvag8N8sBia+hmZiZoxIVn8s9x6nPmW0a7bfKIS6C8qiTUBgFofA9aph/?=
 =?us-ascii?Q?oPsNw3CZVr2W1bKlXHM39HACC0vfXk8JRRH9Lex1Yl+j8cGPc03XdVm+bUZV?=
 =?us-ascii?Q?FYjCVAG2ngOtjwwKLUgY7VgRez2w31i6F3ANnwtLbMxR5MNK2jZcQrtBPcyA?=
 =?us-ascii?Q?9VfkXf6e2lgLkZUROuKYTgr2NGuc/SoSQlRPpbCuwqRFXDVZdtqcPIXNfRFy?=
 =?us-ascii?Q?NZSGze+8Ers8Xp/k8uz796KpCD+QC4CPI4eXp1pGZ2L8HqFOLPwMYDECI4cL?=
 =?us-ascii?Q?9+4dlXvQOAZQ1MH8c9rJoAYY9aG7vYXFbYamfoRL2Xdy+H9+mfZv1kyygo5e?=
 =?us-ascii?Q?civc36kx4L0ZUngHYzaJz277r0EdDkBpGRR3HbwEuR7IBOOVciu2/d7dMe2E?=
 =?us-ascii?Q?Qc4h74TY656ZbTGIum75jtdVhBeE9rUXM2brQdlMQ07ytaqa1cRkU8/pxM+w?=
 =?us-ascii?Q?rcrRjsGrm56rQqszvhh+hQQB4Rlt6FX5qbeaePn/5lxFLjbsU7TJcldNGhYE?=
 =?us-ascii?Q?MBzL6FEyGI26CoPxgBy1hvWMUpuOgdC+bcReTs87X1X1bseExp+UOYJiUiEN?=
 =?us-ascii?Q?XoUNF5c0RHo1VscGD5DcEU64WednARaUcE1+XM2S8vidGZ4+rw+w/JHzyG/B?=
 =?us-ascii?Q?N5FL+Hr1GQjdtNGAOn8B3DGA66ep3bc9aDjaXTJzHSzThGcwgcHchOSLyRWD?=
 =?us-ascii?Q?mTkzWgv3WLWEgcBdmvlIfe8/5haM9hhVRVIaSOGS7CdVs6As21lPU/zD3XAi?=
 =?us-ascii?Q?XBTbE2QAQjWV2mG34LQjd69VVr4DuV6CSs3hPGlT9rzCLx9KshqmfmrFxXvi?=
 =?us-ascii?Q?B0aBENE31a19mRPFgqQ/Ok/khbtPgjSjvseAUlislyhC83lYdLPdgiQcUlBk?=
 =?us-ascii?Q?+VF2dDJm5o1FawoQ4a4lkyEsiEIFXn92DZoLerKm/PLnasMbGZVze5dqzfFj?=
 =?us-ascii?Q?7NIgdpqXgKVFwlseGzej7W4UrPgzx3WOf2D/OIZIqSG8pVjSceJfaToN1xDY?=
 =?us-ascii?Q?p5jhpz+mF/xAs2sFOL+6ou0ZRJ9Dk7m8XfLjauJQln+F+9Ib+lGVtg04QQ1D?=
 =?us-ascii?Q?73ooO8MEhezhnlScht8lcKYuf9SnDDGdmUm/VmvA10w0pHQ2XfAoxEbmb2UA?=
 =?us-ascii?Q?7AfsXWakhyEpgCB7lE+pMVjaVBvXsxC5BT0nWVMtwHLnx1+L+xppJmkikkxs?=
 =?us-ascii?Q?MbSxUzFljRTDSV9viq479b1VyqiG77VXVwThlSlpkLohn7t/bdYs+OdRp7xv?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd4ecd2-7ede-404f-4716-08da94c2e25d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:57.0864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHwhWiQj+1wJzrv2uR1+F26aKcdl51P1lTG2McmGwGf1wfiQm07VegLdBJ7Sv/phH4V2ujwatJrV0KC2u9o0eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-ORIG-GUID: nkutgzstEva-vbi2bT69kesnS9x5sOQL
X-Proofpoint-GUID: nkutgzstEva-vbi2bT69kesnS9x5sOQL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 13eaec4b2adf2657b8167b67e27c97cc7314d923 upstream.

Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
and swidth values could cause xfs_repair to fail loudly.  The problem
here is that repair calculates the where mkfs should have allocated the
root inode, based on the superblock geometry.  The allocation decisions
depend on sunit, which means that we really can't go updating sunit if
it would lead to a subsequent repair failure on an otherwise correct
filesystem.

Port from xfs_repair some code that computes the location of the root
inode and teach mount to skip the ondisk update if it would cause
problems for repair.  Along the way we'll update the documentation,
provide a function for computing the minimum AGFL size instead of
open-coding it, and cut down some indenting in the mount code.

Note that we allow the mount to proceed (and new allocations will
reflect this new geometry) because we've never screened this kind of
thing before.  We'll have to wait for a new future incompat feature to
enforce correct behavior, alas.

Note that the geometry reporting always uses the superblock values, not
the incore ones, so that is what xfs_info and xfs_growfs will report.

[1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d

Reported-by: Alex Lyakas <alex@zadara.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 64 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |  1 +
 fs/xfs/xfs_mount.c         | 45 ++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h         | 21 +++++++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 443cf33f6666..c3e0c2f61be4 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2854,3 +2854,67 @@ xfs_ialloc_setup_geometry(
 	else
 		igeo->ialloc_align = 0;
 }
+
+/* Compute the location of the root directory inode that is laid out by mkfs. */
+xfs_ino_t
+xfs_ialloc_calc_rootino(
+	struct xfs_mount	*mp,
+	int			sunit)
+{
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agblock_t		first_bno;
+
+	/*
+	 * Pre-calculate the geometry of AG 0.  We know what it looks like
+	 * because libxfs knows how to create allocation groups now.
+	 *
+	 * first_bno is the first block in which mkfs could possibly have
+	 * allocated the root directory inode, once we factor in the metadata
+	 * that mkfs formats before it.  Namely, the four AG headers...
+	 */
+	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
+
+	/* ...the two free space btree roots... */
+	first_bno += 2;
+
+	/* ...the inode btree root... */
+	first_bno += 1;
+
+	/* ...the initial AGFL... */
+	first_bno += xfs_alloc_min_freelist(mp, NULL);
+
+	/* ...the free inode btree root... */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		first_bno++;
+
+	/* ...the reverse mapping btree root... */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		first_bno++;
+
+	/* ...the reference count btree... */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		first_bno++;
+
+	/*
+	 * ...and the log, if it is allocated in the first allocation group.
+	 *
+	 * This can happen with filesystems that only have a single
+	 * allocation group, or very odd geometries created by old mkfs
+	 * versions on very small filesystems.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
+		 first_bno += mp->m_sb.sb_logblocks;
+
+	/*
+	 * Now round first_bno up to whatever allocation alignment is given
+	 * by the filesystem or was passed in.
+	 */
+	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
+		first_bno = roundup(first_bno, sunit);
+	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
+			mp->m_sb.sb_inoalignmt > 1)
+		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
+
+	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 323592d563d5..72b3468b97b1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -152,5 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
+xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5c2539e13a0b..bbcf48a625b2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -31,7 +31,7 @@
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
 #include "xfs_health.h"
-
+#include "xfs_trace.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -364,6 +364,42 @@ xfs_readsb(
 	return error;
 }
 
+/*
+ * If the sunit/swidth change would move the precomputed root inode value, we
+ * must reject the ondisk change because repair will stumble over that.
+ * However, we allow the mount to proceed because we never rejected this
+ * combination before.  Returns true to update the sb, false otherwise.
+ */
+static inline int
+xfs_check_new_dalign(
+	struct xfs_mount	*mp,
+	int			new_dalign,
+	bool			*update_sb)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_ino_t		calc_ino;
+
+	calc_ino = xfs_ialloc_calc_rootino(mp, new_dalign);
+	trace_xfs_check_new_dalign(mp, new_dalign, calc_ino);
+
+	if (sbp->sb_rootino == calc_ino) {
+		*update_sb = true;
+		return 0;
+	}
+
+	xfs_warn(mp,
+"Cannot change stripe alignment; would require moving root inode.");
+
+	/*
+	 * XXX: Next time we add a new incompat feature, this should start
+	 * returning -EINVAL to fail the mount.  Until then, spit out a warning
+	 * that we're ignoring the administrator's instructions.
+	 */
+	xfs_warn(mp, "Skipping superblock stripe alignment update.");
+	*update_sb = false;
+	return 0;
+}
+
 /*
  * If we were provided with new sunit/swidth values as mount options, make sure
  * that they pass basic alignment and superblock feature checks, and convert
@@ -424,10 +460,17 @@ xfs_update_alignment(
 	struct xfs_sb		*sbp = &mp->m_sb;
 
 	if (mp->m_dalign) {
+		bool		update_sb;
+		int		error;
+
 		if (sbp->sb_unit == mp->m_dalign &&
 		    sbp->sb_width == mp->m_swidth)
 			return 0;
 
+		error = xfs_check_new_dalign(mp, mp->m_dalign, &update_sb);
+		if (error || !update_sb)
+			return error;
+
 		sbp->sb_unit = mp->m_dalign;
 		sbp->sb_width = mp->m_swidth;
 		mp->m_update_sb = true;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eaae275ed430..ffb398c1de69 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3609,6 +3609,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
 DEFINE_KMEM_EVENT(kmem_zone_alloc);
 
+TRACE_EVENT(xfs_check_new_dalign,
+	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
+	TP_ARGS(mp, new_dalign, calc_rootino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, new_dalign)
+		__field(xfs_ino_t, sb_rootino)
+		__field(xfs_ino_t, calc_rootino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->new_dalign = new_dalign;
+		__entry->sb_rootino = mp->m_sb.sb_rootino;
+		__entry->calc_rootino = calc_rootino;
+	),
+	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->new_dalign, __entry->sb_rootino,
+		  __entry->calc_rootino)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.35.1

