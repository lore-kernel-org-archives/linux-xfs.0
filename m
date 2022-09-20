Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C57DC54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiITMun (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiITMuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:50:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E13D63F28
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:50:30 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAQSY7006015;
        Tue, 20 Sep 2022 12:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=O2GXSQju50JxKL+G/PLnSpjynbQvLzPK/CoT+QeiwJKH74HcgCJdxw1a5mORCKNIU9FT
 ri1Mn+kRoyYGO15HloC98DBICyrBJOpmVXkDcJEelzhLxdFHmB7Ho8+ybf2eRx64m9Uu
 Fza88WZ01dcZVv36l2RSISA0kzIHqxJNSxwdHuYKs/9rnNxOm37+ypUH0dyUOp59A7pP
 GnT87U6EpQP9mcqJXYRSLKzV8q8cAMhjTxwsw8swz909bU6HpOrEatagQx1HpsCIZLXD
 ESd3ti9CjK8B7MpiDp58+y59UUOwHpy5cR5908WpOCq4y+seFdCDkMiKG+7RyfPIhT3x +A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kptam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KArnIj007880;
        Tue, 20 Sep 2022 12:50:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39k9t38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XT1VQS94fJ1PJd3X/JjZeLAlm9daUiWIKx/YLVHkBmMWZKuCmW91nSdceN9iZsIWZ6utpOCKSVoRdv3IB98HsPdHWrGJfLHR81H/gXys6QmWjH4s3dXib3rD4RQszAPkDiO8lpKiTAAFbtNVtgEFKdmhi05XhHBfBAU3hxistwwbWKehhV7Wp4P/W3gzk8iWjTzrU8UX1zTdTgHNqCDBnuZPuVGfIixpo0Kz//egRxqC0TXU80elO/v5umRBFhmdlvR2/wm8OYO6IZNNnX49Esn2Lim/V2w1yc/pAUhgRPpHne2b+drj0K6ypiuiSMyKhc5NIWfA2XdmKW0tYRfFAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=hl5d6QsC8tt5JLolmcK2cu5VeQQYWuOWaZbjGFmAgFy9gHrl2GbEIcktwqtxZrq980pDwQEe7VgtDVGcXFsGDhdDrKxEqf42DcSTFtyGU6rPq1KbwN3rZa33IxhiIDGSaHUiOO8E0CvODs6ILCPa2Y67g7EpnlcAV6Unqd9MrFLRJXWIwlg1uZT/bXrmAE7YSB4SLJFIVXmfZVrJH3UcXXts+Y/jyt0+xYr2ug47M+moGyYC73X1xv4eR1ctJsL9/Kd1J6vMS/qOYEfq+qR3oGzYI1wjSj8ydKsckw138TZGL2btK3bi90WE+dnmW5KOcHE937vGLVd3GhaSV/41FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=vGNtUG2gOi+RkFkJIQvJOL1AT8ANd0roLrUB1BawcFis5AO+eDxrFLCCRtbSmE8uhyEbV4dZb7qWKg4X5W0HrjBouv/I3dXYctVXx3w5aoSwgxxpeW73AIYdK6723jYYiogidRjUg2KDKb/4gZ4FUrJoZteE3ZF8zubfEtPqeSg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB6304.namprd10.prod.outlook.com (2603:10b6:a03:478::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:50:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:50:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 15/17] xfs: refactor agfl length computation function
Date:   Tue, 20 Sep 2022 18:18:34 +0530
Message-Id: <20220920124836.1914918-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0032.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: 58bc7d28-13d2-47d6-cf91-08da9b06af21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rNg2sDDprqJ+40kEDNirjAvDE51MqPaW4URvOd7N5DkySJII8i1Taw9pUK3Y3MWzBmZch78x+QElrGcn14QIKhKLcs/f953KCFNkRgfidV6K2z1p9U4EfsGlOi2rZuRtEuM1d6+RuMjBsPLeg5PALgHDHR9HBX5q1uO+zgeynJAZsMfJd/MHKVO4Ygf2/NofgkapTVPT/eH24VeQdvZa0nhMsTpdcP73fRQp1ilGTsBGn1gQnqA8jVvnZMSTa+CTpG2QYq2h3XXUxY56oNBk+zL7fPgViDYSCDhBFv846ZIyIhvqlZe555AnAXGbMYzLZ5/M/TZpiICli/ynDjymm2TaWiSNvShgaccLsRbV2WGgH6YAXH6vWzYGil04LxElO/XaYqDjmOm4s9inkv4roWHauaAl74bs6qGk+/MSIj+an9c+3Pduq0okzRvfin2DpjRnXSv8eLMkUQVHlnHWqV5YOZbWt+Bb0AAJ3fgbK/D3BwD2ctE690ffdJiBSe9sWDkAWemF1HA/7IXrq3rYJwQJqLIfECzvHaalMBv/HgNsQXptYs3edYw0HHHojkPAtIl0a16lO96ZZIK9eyoFG0V/hVkugIh43Ngsu2rXUhNCc0ncLQ6c82ydxdQ4Ln0U7hodlciiUDd9kKfZC7+XTOyH+nl6PgZQLqBK2ewLOlVKj0pBv1tkQgClQOBjASGge6+Mm8BgHl0gYpIeNDOmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(26005)(6506007)(6512007)(36756003)(6916009)(5660300002)(66476007)(66556008)(38100700002)(86362001)(186003)(2906002)(6666004)(1076003)(83380400001)(2616005)(4326008)(41300700001)(478600001)(6486002)(66946007)(8936002)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Av8aHIMGS/SG6LDiOJOe6YJB87a62Gpv+iyKw6wx/jAH7qWs3E60ygBYNrw?=
 =?us-ascii?Q?Lv6PS+iQzu6kGOrcAyki5VA3bI3r9Y7y3UspJ6hTe2qc9ggoJB/43nItdBym?=
 =?us-ascii?Q?2uPesAv1QfKPOOgzjQD3QJ5ArtVHmF658XWSkywALfK2v1s1YZpzCbon6a4J?=
 =?us-ascii?Q?OJ7cyVOWoXqSi2PyAhh/e37SYiLtaeEJpd5z59P2K6kqGukijsrG7idkLr4T?=
 =?us-ascii?Q?TLarZYv1ipZT+QFLpd9p6I5RAr8Uc9TcR0PAespf75hTIH7DutTkqx9GTi0R?=
 =?us-ascii?Q?6ZFINnFAh6baV66YedTw/F4HfjkqxD1/XCe5conXOUoD6O9ORTAZXTmg0mNi?=
 =?us-ascii?Q?T514jWPFYkH5FU4f7AzAtYdwNCM7rx/tlkNoyr6ACpwgo/wOf5K4OeUYz0Gn?=
 =?us-ascii?Q?TW9+GPoqPGfjp04GCKOHy2Xjf99UFQR5K5KhfoGL7ShbxjStdsl1uIrujW1v?=
 =?us-ascii?Q?pSZ77eYZD+9lFhtIa92hjBXHqDTH0FISxrmKP4JAwu0mTDEUi1/uFbjhl3sU?=
 =?us-ascii?Q?AN+36cAKzvCSD/cn8MnfRiN3cHeQsV3SN45NbZP89DzMdK0TgCmGxBLHN26I?=
 =?us-ascii?Q?aJIb0dGKl7LBgXtGL4Lqhqh05UCxojvzl34SbxTSSApYXhMlDfUk1G7Ur962?=
 =?us-ascii?Q?NUVgArRQdPWoVM42K9+sfzC1jzmHV7Atf0q3CA5AhD+w/7gzGICVOCwqJcsP?=
 =?us-ascii?Q?VBdN3kJRqgtdo45juE3gAZgBq3R2+hUQAs80inkNSWHyN920h+zn7WaRD6kt?=
 =?us-ascii?Q?WJMPU2R9kj0Je19PDUJI4sKmyoDm02QqDBN8Gtj8m8JMwPX6ZjLxDQFGEN3d?=
 =?us-ascii?Q?qoB9D2hl6TF+EUiUTX12BHao0ORyiT0ah8WSpKt3r7ExOJo+h6FJ+uHIBHfd?=
 =?us-ascii?Q?XEL3edxYlQqIL0A3/UWQXtMDEWaabV5aFl/r+nqslaDmZAYLz6xwuiDvw24T?=
 =?us-ascii?Q?Zynkyv46p7cjOO252uFawm9sq6PXuDNMccqlGiL/E7zzxe+qcZVlF8RPFfmC?=
 =?us-ascii?Q?V5SELFb/3E23CZtn9jlw8Dw2jdPvf301xCgciLPn9YqaMo2G1Y4GwABqtmiM?=
 =?us-ascii?Q?PTMlE9UckQt7crN8xquSEWB9aHta89mb2ke6WJLyJSIjQ4qoD0a/9kmpr+h6?=
 =?us-ascii?Q?Z/FVLc4aUTvN9SSqu8++VljJS1qy19SKGa/nY/e0wfpcb9CkpyoqqoXOa38S?=
 =?us-ascii?Q?tTbQqNKFEiocqyD3EyqX/o2dH3AqklJuPBJDzL75GrNvBntE90Mng05VVwQz?=
 =?us-ascii?Q?tCDrRYR7PEuROh7bQCUPY95Iza4fhzD4srtORgZTwqZTjhr7miUdmqP6dxPO?=
 =?us-ascii?Q?9hXUbQCIgWWRVuUbZRm/z35PcQ3jSXeschMii0l6wnUmSbv9sMdVS3yyHP+b?=
 =?us-ascii?Q?tthVBr+5CXx5nRGw4LOFoS4AoGV4J9jeKgUrzQkgNdhBkfRc5mnq+sE8VKV3?=
 =?us-ascii?Q?oq/++snEFlNICzEH/Hb1zzAjQ6gezhqml5hJsWZ4eHvWjE4YSF3+QpP6Lk4H?=
 =?us-ascii?Q?rmk2FJoaLKk2nW94d3EoMe3un75rDaTLP7co9pwXUgoAHwLgg3FToj2f2g/Z?=
 =?us-ascii?Q?iqLKPJSbRNCOQyIl/OweXBEWXwtfNun0hfZxLqr39Uwo9yDeeooFg2UXMUVN?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58bc7d28-13d2-47d6-cf91-08da9b06af21
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:50:23.8715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0aI2hRI3FuWGcgMb7ByMpGEyD41LoWkfNHri43GGdD6eEIlek9tYxVRWr5O6hHrQiEh3CUOlIvxyGSFop/ZNyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6304
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: v82LgszezhZW5phaFI2NDW9cL1YA49QU
X-Proofpoint-GUID: v82LgszezhZW5phaFI2NDW9cL1YA49QU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1cac233cfe71f21e069705a4930c18e48d897be6 upstream.

Refactor xfs_alloc_min_freelist to accept a NULL @pag argument, in which
case it returns the largest possible minimum length.  This will be used
in an upcoming patch to compute the length of the AGFL at mkfs time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f1cdf5fbaa71..084d39d8856b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1998,24 +1998,32 @@ xfs_alloc_longest_free_extent(
 	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
 }
 
+/*
+ * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
+ * return the largest possible minimum length.
+ */
 unsigned int
 xfs_alloc_min_freelist(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag)
 {
+	/* AG btrees have at least 1 level. */
+	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
+	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
 	unsigned int		min_free;
 
+	ASSERT(mp->m_ag_maxlevels > 0);
+
 	/* space needed by-bno freespace btree */
-	min_free = min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_BNOi] + 1,
+	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed by-size freespace btree */
-	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
+	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed reverse mapping used space btree */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		min_free += min_t(unsigned int,
-				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
-				  mp->m_rmap_maxlevels);
+		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
+						mp->m_rmap_maxlevels);
 
 	return min_free;
 }
-- 
2.35.1

