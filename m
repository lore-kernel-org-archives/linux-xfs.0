Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812A2C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiAUFTt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:49 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48428 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbiAUFTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:48 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L045iF018296;
        Fri, 21 Jan 2022 05:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JqzMCjcj82CXu12QhuyO8lS2WoxfPRYP4aceV8RiL+k=;
 b=rUIvovog8q2oEJfl1lRmUahj0FOV791jEpn0iMw0SkYoeXfWVU3/bsXHtBleRiMbiS98
 UEGHX/pV02SKKCQU0t4d6n8xvevS5qP9YX0tkf7/1cLACcgN1MDUcMdB6JCQYLhTI3W6
 hAqLigGhVvbPrqomGoOQ+NgGDEtxhr7nZBqqFNR9AuM6O5fFm8FyINtk3vW8RXMuTmwh
 1AEM71nQCfmwra9JpOQc+TAwHORZdVkfj1FvYm7PFPfTat8n4R4pn3lmEA0K6wSRFAr/
 /MsOJX9oTnM86aZ5xaGzGmeve5OB6hOdreOKHeNVcEFvEkUgUUpNcz9WBLjspmxpY1GU kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhycgcqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5GgjJ081948;
        Fri, 21 Jan 2022 05:19:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3030.oracle.com with ESMTP id 3dqj0vbk1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgG4YOqr2MBkjoQ/PH66Wjt5V9NBRBSR9DH6CMMNFXTrWmdT1Y2Qlz7wp/N0PKT5XX3jiI5IaQHg9VFLiRvalZk8nOhO22UVSmWP3QeNTeTD6ETocLflGY+pqZstBDx0GL7AfDwnhlqFZn1xs1/G425SPx9nDZWsFXOKckqKJP7doh3BJoZ9z0RsRdYd0SqqOq+8+/2Y9wwv9VCm0xsWUnM8dWxkAJxc0StUOzvl0oMBdmZqlX2/vwpuJ2IP5o8tWtN7YkcUbGRu+llc21N/r2/FBm66FRHZ9ccBLHUc679wiGzUDbJPZsRziSVw5SqXI6UyQfLn0gz1Dn1dLbtK6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqzMCjcj82CXu12QhuyO8lS2WoxfPRYP4aceV8RiL+k=;
 b=MqrC7PIMD4Ng2Pd9p12gNMfp1ZKO2PE14k1gdMIQL1jfTxeMJgYhPF8PB6hWKAbn1bZBib2xVgI81hl3TZ8UXXYMzy0x+B2HzE2ggKUOLIJ6uTyQQvSVuERMwRUdW6J53iyiqBihqq3bXCL75+fd1WMaTNjRA2AhMa2sSz7cB/JRADsK5sX4ino6iYaGUNwkvhEPGY/OqTaS5EwYawdPVy4dnnnVWR9DlFZG2zmx5yCxfXfb4Mxflp80iwsOWHP12qG4lYNefE4oTloKK9pCrn90xuh1O1vUSyg7XkQpYdwUkoUG4k1QqkzdDu9aRKHAXSnYtig2SnSTSTQ1mWNr0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqzMCjcj82CXu12QhuyO8lS2WoxfPRYP4aceV8RiL+k=;
 b=ex2Xe9ZSQv2gyQ4sBpEem+ThFYbWfBCPrtN0/C3vWBPVKgIfWggGw0fYmpJVcm7jWmo5Ve3MRAORRoPQuGNs8iYkCn783PemIqU6AW1HVBE6SxA+w+ajx6G0hBp088h9F2aoCMc6tOZDecDtJv+Q1ai6o5nF807j9WOWMRAABd4=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:39 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, kernel test robot <lkp@intel.com>
Subject: [PATCH V5 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Fri, 21 Jan 2022 10:48:47 +0530
Message-Id: <20220121051857.221105-7-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: b7587087-343e-4e99-dca3-08d9dc9d9f7d
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1236204EAAD32A2453E21814F65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OvHgrGz6ic+NnlDILrsJIjPgPVOgGvdpazRHeWBLKcvk9rrMSTZYopeteG5+hPMP5TpNU7+kJAMiTOLxY99gsPndRCmwG0j4NY0pDmXU49VfKxqZ3wu5ngrOsD84Mf0AjTZ1k+1SuFJdUiSsHIsP4pfroG6LjjzgWxhOW704sxbysDYBc1apnk9Ev3J5OWxqjgdgChl0q8CO8OeDbrJrf2Ydk6OeyJ3bDvGuVdUelSs/JljctiWzNoOFDV/067H0yqsCQrAt/vtVggVlXR2I2z5fpYh4Q8E4TaAgN9tIcTOrj3UKPWyOHUdxZ07QwmG0CvhLppFgFxm7t7hbOg1wnAKOQVQ8yH0SBc9imgPJsRw+RoXQcU4PnTicIVGF5IO/WC6h+VjRw+t6iD0g8ejgbH7MLNgOnWvMv1dySiKhUyYBBEikiG6ONqBY5zFTNC5KIGAYZXsxAP5Lwq23QgWQLSmFXu15LuT8pvMOY/jqBD8TN7oTz8j4nWxO1ziwhFVbQkawsgVENYTrPwjOtKeJKh77AA77SlT5G96yGkad2IpxCdXfRoMVdpmFTYiF3zWx1tApFjSmC9HEBfVFq/oTxCEnvIYe5asYDVGV99pQLZCOGbzS8zB90YCG2LNWiqU+Maj76eNdojelvF9hDCCl9fXwjQIvBqIzHQgbdwpaiTSd6sE8mz8mqP3KHTKDFRyf7u7D9vbpG1f7IUEv8kL2JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(6486002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(54906003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VRsXm/ICbUg1paXaGpKs3aGtGiH4mZw0xaMjjhGkdGJJiIIEwd/zku8IUmCJ?=
 =?us-ascii?Q?6Xk8DRMxXQVQtDbihm3rrOhRznn/9xnWx38fnU13wnBXJwfHqNf5qZKhIXRl?=
 =?us-ascii?Q?z50UCMGPV7u5GJkAWq/JErSKKP1uAKXxMmIYr9ZKueHoN2jRq7rwZqWvwT96?=
 =?us-ascii?Q?a6kXUDXlyVA2dcbdz+JTP8eXLrDXvTV9Mlw13PDpUTBbYzDjdZivRdUrIclz?=
 =?us-ascii?Q?GFT5ezfT+1b13Kl1578KUceig9GLOJgu2Nyj5fwNSHe7CNwZQI4jb2B/utY3?=
 =?us-ascii?Q?SIkwtYdbCrhkBg4iukMqb5lPwDlJLA9wnwr3JYRbCTLL5dn10++UMSMFf0RU?=
 =?us-ascii?Q?eAExB98W8lDUTw4NuJyC7XKi8fwK2eXRNIbOS5itEatWsLJZzE/vunN1wPeO?=
 =?us-ascii?Q?prOtb2R9ud58EutpNwf0DTPBYqsJNHd5pdbHQ0VcWGAao0lxNneQH7pdd4sS?=
 =?us-ascii?Q?hx9xyv3ZgDm9p1BgjjXfKI1jt03cr9Nn8WexwPVro0odOH8hTUUuYRPsRCSM?=
 =?us-ascii?Q?A3Qb3sD/YlzcVQllWP4tPuX22O59yIEdHY8mr+lczHh6qzo/ZiMlLGLuEb1z?=
 =?us-ascii?Q?h9Mf4TaaXRrh6zOlWcWwnnjvBJi6Oy5xM60OVoZdzsYbtdEQvbBLxVTsvy8K?=
 =?us-ascii?Q?n5d7DiIQoAe2PyxBlax3SeUScQQ0rFiMaHf3WgorRU9JG4PWDuFlo9S5hZvi?=
 =?us-ascii?Q?foQA8yDS7HmSlGKhZLtf++JUOUJ03aWUlxhOpLvN+8Gci4jkZJsmIMPpO/g9?=
 =?us-ascii?Q?E2RmajTHT2EueK8MqatIiSXBGCfA8kfV6LdIZRvnOMUdryyXJyuyfoYiXiFe?=
 =?us-ascii?Q?STa3tf9POAbavVtyrpv+ZJcZ2Ilgje57F62ONtJ2WkK46xtsxJ4dJjOrI+Ij?=
 =?us-ascii?Q?At+TAZiIhsrB1GnTxvd7aOpFV3iTY7QCbHvZ9MCxLn29SOWcjteqZaVeyLEl?=
 =?us-ascii?Q?LESBKhNpQFap73QGHao/TVfuW0z5YUd3xoVdG+6aREMsX8UrNG4e/kaIonY1?=
 =?us-ascii?Q?fJTi43fe/D/ZJ0d4KVTfwP1wmeEjyDYxUWFP5Zl3puVdkVMgO8qJP0TcaJSV?=
 =?us-ascii?Q?5a23T0qH+s+NRiByaSUHKXba5H9mkUQ/Zus/KrkUmiNJa3zsJL3dFe1/MoAg?=
 =?us-ascii?Q?zW0FEFzOHZMSxd+PrbpZucLf8Hsu34qtlKsramEF51xrQbf2ADymQ6mbClM5?=
 =?us-ascii?Q?GOkdIYuzawZeOP9IIxfS64mIKMAvxvc2zrlYrzfFCwkgschsyAk4e0ipI4X9?=
 =?us-ascii?Q?mccU+aXpblr8wfRmKsg4UCQhIfwHnRSF9JIIgJtipnu70QcowJ+cYUAeJksb?=
 =?us-ascii?Q?D7sbg2AMytBypSDvsBcPFNAtovjQFi0AXE6I+YliBxjvVInSIu7b4fb5YINY?=
 =?us-ascii?Q?729bWSfMNk3/vJKN01ovxokrop7FMWAeU9BTE7AEdIIY5IGmhapw/PWkSoEF?=
 =?us-ascii?Q?zOigTtV1TVU77SxCavoaropvC715zc5i6ivfxmJupwvfyqfXEhSzH0icoEZ2?=
 =?us-ascii?Q?rYICI6znmU9zKx2OLrrztdLDVS3C4qAnwTRSi1xUDbdO+pbCaizgGeep1f7D?=
 =?us-ascii?Q?squ7rCO0eMGp80DivELPDlobtuf8fToqKCmkDmcXsj6QzOKpZbd8+ASIphwb?=
 =?us-ascii?Q?/gsZiA2W+oG2J+K65oXeyq4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7587087-343e-4e99-dca3-08d9dc9d9f7d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:39.7199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: duY32lO/IG8Prz0TiWhNuAvnmEmZcDJ+cPVfT+A8E+PTRMQrj7DZ//l/DDfx48L8AyCmjYROZxniR0xdRNbTvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: jW-0mEBweXuT2EX1AEld0iaN9i-yTZU8
X-Proofpoint-GUID: jW-0mEBweXuT2EX1AEld0iaN9i-yTZU8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
 fs/xfs/libxfs/xfs_types.h      | 4 ++--
 fs/xfs/xfs_inode.c             | 4 ++--
 fs/xfs/xfs_trace.h             | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a0da0a2b3fd..6cc7817ff425 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -83,7 +83,7 @@ xfs_bmap_compute_maxlevels(
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
-	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
+	maxblocks = howmany_64(maxleafents, minleafrecs);
 	for (level = 1; maxblocks > 1; level++) {
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
@@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 829739e249b6..ce690abe5dce 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -117,7 +117,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7ed2ecb51bca..4a8b77d425df 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -21,9 +21,9 @@ struct xfs_ifork {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 794a54cbd0de..373f64a492a4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6771f357ad2c..6813c2337da7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3495,8 +3495,8 @@ xfs_iflush(
 	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
+			"%s: detected corrupt incore inode %llu, "
+			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
 			ip->i_nblocks, ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3153db29de40..6b4a7f197308 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2182,7 +2182,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, forkoff 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-- 
2.30.2

