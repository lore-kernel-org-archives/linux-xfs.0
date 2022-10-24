Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF14C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJXEy1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiJXEyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:54:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8269179A6D
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:54:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2vB1h026245;
        Mon, 24 Oct 2022 04:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=NOSHV9j8SoCNqkgkfNn3JXvn68i0hXqVqP6Gof9aCFA=;
 b=tRd3VeRFuCoN721ywLYGRvv5NbTYME6qLFuQXMIbKhQ5RqUEs9CQ4HGbXeS9VjKLfFwg
 rPAfRxCMTYZsSWP23JBod1CNUdqMGvoDBDem+g2MS+nGfXAce8e/oD9oWEcemZxunoXO
 wzyR42zpcPmPo6sPamlPv03/B5aFQNgfzSylaI7yMPHj4Uc0lnDoQeN3qFG3NPLg1YeZ
 BFETzU04zEe5Oot4LiiCW37FO8LEVvzXzHpAXzdDQXiCs2LIOEUV0RMsErE27mCfVno4
 z1iCYiQn1zzaROEAtSB1gaaUyk17z2yZvFXeuNJQmyEb+hNnqtfC5R2/mNCFBHRn4WSP Lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xdtn40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O02vp7030706;
        Mon, 24 Oct 2022 04:54:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3bmt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbh+0lRbhxmrwxuKfkel32+UgF10Bz9UPZJ0i54zhanKyQqY+4pGRP1o36A81gjJEoBw/TL8mTleQtb+wcRYgA3ptdKDvAI3+l7AaFA4eARtxSI0bto6AOcGf01vpZxNdkExG4AhouXq29ch5f8bSY2K0W9cnrTO//0kk38w/ha1oiCAf8kRLZY1iBRm+MC1Ha0TyShyOm+kIQMQw+2M3gQdckShWwu7sv5sIjNVnTRLDQcvp336Z08Ng0VdfJSruoh9MBGIbBmwpOJ5kZA3VSPc0kpOPaa0n5i5omgSgsF92FbwZdQ1j5uxoGyrRf513ZS4w5lv9REHI8tzBF0Jsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOSHV9j8SoCNqkgkfNn3JXvn68i0hXqVqP6Gof9aCFA=;
 b=PiHQmu6m62PC3lXO/g7nvRebGtPY0ztIpi8dQMTqWQCSV2rBsxcsucJNhikhAipfhfGqH7Fu/jVVbPR4yZoBjtxAfUlcqQ/eNE9KcYpsHtbkzrv5tZkxEsUbQQsVazIb6dhlPAC9kotjnjvO/HxlQtLCwLLrpac8jzJkQ0fP0icSergvm04oEBeEBB3K3xVz+n0frUVSroXoRn8ZLR/M34+ADUKT2T4ZECaJr5XSFO3bpRs0274MRpneWo35A0xdA2E/925zAUIDY+HOJlBHZEYlCXokT8GGTpy4/uIvvFZTAh/1ZnHoDjTz7GLB6njo+JDrjRONypzlb9vRCFDMeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOSHV9j8SoCNqkgkfNn3JXvn68i0hXqVqP6Gof9aCFA=;
 b=GVdbBDCujIoS3mY5KYBNbhAuRKMvbEciVft22U2BVezWq3acXODILQ+y1RUmTqAPOQypr/F3GZ2Y/LE7P+8ep5bfGo0fn+jntC1S9Uz+nR6gG/2T75+bYqVW9ovZuRnW9UNdnLXn8d/BpWbfwy7KHlje3M7xip8cA3cnfXtwNyc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:54:12 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:54:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 07/26] xfs: check owner of dir3 data blocks
Date:   Mon, 24 Oct 2022 10:22:55 +0530
Message-Id: <20221024045314.110453-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0106.jpnprd01.prod.outlook.com
 (2603:1096:405:4::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a7f27db-089b-4df7-e1c2-08dab57bcb3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8hir+TyBhkv5vjhZ6ORHpJ7wicqbtJGtzqMCZnF7RZ+IbdbDf/SQE35GxzZuuxEkAnOIIRc/evgNKPzPcnR3JZtPgulkNdkKFDF7nUFZ1q11+QjehKiyQS+OdaVI9w3HFkYpudK7gc74YFnQglRIVL9D+7jBxgHviEgwwSvCkkLHW36NiQXjUs6Ornx5HJBh9Q5KeFIa0zBPGQBr8o25OqvopsLBMsAXk1HNI1SX0Qd/bJw3dowJtavNrHnmgWuajAOmsay0qxU7sjA2TNJTAh4Yj4HZdJfc3nWDN82OH72gbKRcgp1VR9mo+5hwLP7iVB4M6uwNz9LmOv/XxvyE4TebD4JSpGULlXI0tX/5Qn2YQyUI5XObJYxS0ruI0lufBBs0BUii5UrJwGYI4s+INhEcdR7QDjIzvx0vqPdTm5CXcavqi/fpwpxJBtR6a+NeqFThrs22K+rdXM7PqHjTEfbD9cpmmE3YVxOb00/DKeu4qgiBVjI2OyWJH4VQmZvzfzmcxy+2l3Qi/xPldI7tThzFNq33wXbmHWb4JuMHfIL1IYjjiFmFhyXTieqaZ/Ra8omJRBatl/ss/EONCld+F20ccXKJ7xLMzSntLD5d6dRZKxD6sP4GTHuChYsmVsmb0qWUFT5NcZA7BNNqLZMRM2Kg9S9Oo51vNHWkWrhqWxU5Xd9L0mS60NOklsiOQLpl52vJhZcgFyKGGd0TbQxCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2wAUYQ1grN51YOIcqIQb2NDL+mbemGZg6Vg5FkKiN4XSlV4JLfiuAs1I1dhW?=
 =?us-ascii?Q?KmTzXNoLCrlckwaoj9wQi8OqNEhrIXmimMGmrBSxvGDUc73mJVhLxReGrXsL?=
 =?us-ascii?Q?VFxmhdlB+OC/XqmpaVZ2oTvCRAuoHki3ABCzDvNJZSsumGbgC0AlPiWIL5Ci?=
 =?us-ascii?Q?5i8nWiTD5b3WfdnBiCX+luk+2EFKqVqc3H6zzICk8TBQqKDlQhI0mzemsv6l?=
 =?us-ascii?Q?qzzoycUO8ajpo1O6zAqxIRFardwW+Zklef5zVWtBblSJLRz2Q07PmXpY5jPm?=
 =?us-ascii?Q?tItoLAyeaYeMhk2rLSqsJUFqMajgsRuuh3KtI3ErEjX21nKhgv4JdLa1r5cL?=
 =?us-ascii?Q?VjcRwEVMR9nqDVfcVdT7YykDPjzp1+8SYrO+Sa2zjoYkxCXY55Y894ubv8Gv?=
 =?us-ascii?Q?VwkNdj2fBgw0UkHqqdafO5oB+UDQeopYSWADwj7elOtgPYDlTsFNDYwGnxlI?=
 =?us-ascii?Q?4JvGcyn+17ltXzbBf308zAnMaPCzl++h2aOaDlC/2/7zva32sBfFujw1NO34?=
 =?us-ascii?Q?yjfsDYFgsqrvFeXBN0ZdqRfoWHdlb0VNvN/eB82eJLhrrhGaQhIXENcd3tbx?=
 =?us-ascii?Q?cXzi9xP1ntobMe07iPdYRobycT4VOTLyaMMktJ2mo+LWpebTElyh9Inf0Suf?=
 =?us-ascii?Q?WTtGamR3u8hMuf/NzxqyKH1oshwQH6PSR0dtltyGLRpIpoZLPy452aSJHGGq?=
 =?us-ascii?Q?Ynw7bPgPrNZeXZjaDVtDAuC8D/pDu+3GN4n/FWx0MUdcHWa5MT2uvxlnE9k/?=
 =?us-ascii?Q?HtNsoVVxH9HlnXnp9nGzFB23UKHCyKOGypUQeruCuJoJnTaLN+9iSz4m/lds?=
 =?us-ascii?Q?N2TCNrYWzIEG9P1WmWfbw+/f/3MYyFuYLmIhdqtRwoSSFzom90Xpt1cfC5Om?=
 =?us-ascii?Q?uBny3AmI4qx8+3LJF/jw0SOD7CFoABrCkN37wjZdcVhkrQ81RyefhXhHHtD7?=
 =?us-ascii?Q?U2V19dSj2UH82v0lWKI08eRIMBg+eG8DAa5SpPljSsjJ73BFKANzjhXE7WkM?=
 =?us-ascii?Q?TsmhSG5WXaGQjkK+XhSyY/1afY4zXFMwx8TWNXxWyqBBg9qODwLKAk1jEgTL?=
 =?us-ascii?Q?LPwW7EryjE9YhqWtCmL0rK4e2iTaiL7PSdM3KL4jywFOCgvKUXy7s2Lg05Pv?=
 =?us-ascii?Q?QunkgXjRnJKBcmg4mFx8iYIryoU0yJFQ9hDgqUODJgzCwoEzUD/ruCzKCCC4?=
 =?us-ascii?Q?GPcmEj1lIim8pth3PEbhudXO6RVJ05Wbf9jvESNLLFce4lFAfyRCiEzn5o/K?=
 =?us-ascii?Q?HYJIwnm60Aezdv7eXW1qPFHxuT7U2pjGgVMs8FIOb8ex/Rd4cAB2sDHSfOsj?=
 =?us-ascii?Q?xGYOEj/pZU5IJ0YEnP9fXRlrMfRRtqdmEedYZ03A2LCGz+BixXsppdgAZVg8?=
 =?us-ascii?Q?rV3OQy7FBQDmAxPBpC1J9WGHHtocL4G+zx1rPyma7RUCXoiLcERCjvoAArMv?=
 =?us-ascii?Q?Pw/osuXOUQOcbGQfJECYxuqE1snC098xgRNR1UMfb45RQt9XPa17d1f/oU5X?=
 =?us-ascii?Q?Hd9Yva5NkNlTdBDqnXzp/R1pHzLGmQOvlp+DF3j6N/ZqEmH57VwGeL6JvFwE?=
 =?us-ascii?Q?MFc6loYqzNQNpXEoNZOzLVFK8qLOAtFMy3arIXH3CDn/xFMfHAVify/OvbSw?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7f27db-089b-4df7-e1c2-08dab57bcb3c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:54:12.3903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: udrKTPIWj0TVzm/80ZPGMdwN3D5AjDdDEk68TIR/ZGzk8YqC8+Zo/7f5Op15FPp5pxsZc/XyYRnvkXOObRnlSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: r_iAkLrFNlEgaZOtBLstBZwu4Ad9oBA1
X-Proofpoint-ORIG-GUID: r_iAkLrFNlEgaZOtBLstBZwu4Ad9oBA1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a10c21ed5d5241d11cf1d5a4556730840572900b upstream.

[Slightly edit xfs_dir3_data_read() to work with existing mapped_bno argument instead
of flag values introduced in later kernels]

Check the owner field of dir3 data block headers.  If it's corrupt,
release the buffer and return EFSCORRUPTED.  All callers handle this
properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 2c79be4c3153..2d92bcd8c801 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -348,6 +348,22 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
 	.verify_write = xfs_dir3_data_write_verify,
 };
 
+static xfs_failaddr_t
+xfs_dir3_data_header_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
+
+		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+			return __this_address;
+	}
+
+	return NULL;
+}
 
 int
 xfs_dir3_data_read(
@@ -357,12 +373,24 @@ xfs_dir3_data_read(
 	xfs_daddr_t		mapped_bno,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
-	if (!err && tp && *bpp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
+	if (err || !*bpp)
+		return err;
+
+	/* Check things that we can't do in the verifier. */
+	fa = xfs_dir3_data_header_check(dp, *bpp);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		return -EFSCORRUPTED;
+	}
+
+	xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
 }
 
-- 
2.35.1

