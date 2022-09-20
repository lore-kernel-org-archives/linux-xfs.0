Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C06E3C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiITMu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiITMut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:50:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD9272EF2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:50:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAP0YS011935;
        Tue, 20 Sep 2022 12:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=kVUQqz1BRchkvbP0st+LcEeDEghXMIvWw8N+Pz95OepfGLOqvwQt0IcSuj22CaVWQYGT
 Fj805IjOcrcCJN2sJC3z8+ho1iJbb7M5i/XlbWHzdUHSAoLRQUP4+mzbudXxN7MjcyZq
 Xpl3EeVuHg7sSEA/SkJOc6ZYZnMEBrHBRzCc+JCKyCTjeqRTIJOKwc1yA1S5SThQjPGg
 9sWfnuk4ru6mljtn+FJeOKpc13cV5PAva+mVFhky7PJXB5b9ZaiQRkLtzJl34JTJKLAk
 xaF15j5/8GJoMSxyAQiPA7nfPXY546Q0sx4aSRtmCS8KUUCRB3Gzmk9TzMnG6Kud/5pR zg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m6t19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KCoEdT025625;
        Tue, 20 Sep 2022 12:50:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39drjxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAhbST0Cdr9SQSmxRTBmR4haeuSCEO97xcVeZjrE7bGSwGbzqIN1ZSbumKPagmsJr3vGuvjb+unrMztRXIo7pQK7/7lATPz031OxASmLqxpn6eAQn1CCpaPlZPNNXuMaGCtVeCn/YIlI2dR8+2047T08VnMnHCbtR0eYS5KR8Hlo32b8dFYfcv2qrQnOcUaaW7394/vfdRIP/TtcdIyVe0TF/cD+toJ3MxZmCOD8RfXxapu4hKLZvFXjofgtlYGasigoOPO1v3oHaM4fs7T3c2r77ZCzBBqV/ykxxBWx3wT2uVB3BMWBSoUIWG00o4fRtwlOEmitmoSI3sRPqyb1gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=DzSE9EmEO7GQjl8Bsq+z4LRCaDyxBGbb+D+oReTvWIp19L2aJSufGOZG5fOt2mRoCbErzbN+/TEfQgYDJKfKnqMB4EXew1qSYQYUVzVvw/WRuSaxGA+1na6dErV+Yc/DKLUI/p3riJuiBmzriqJY2gJTEyLFKHtId6L2ItlHTsd8yyQr4yPDAA3EOvReSqan08UEF8KuNQ0BZdnnJSFKhoLv99SGiHe5RSovYtpMGJ9bkf7tUbul1mU7L8bxFSvqsW/2fZJfXvBjbUr3KuY7ADhOPwwji2aC7j+wfVuRPQgk+14lOczoAmlDzTvbogv7b4bqZlyShgdTdKSFs4b/ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX7XJuPxcvIrHE7zCnPO1cphrX4cAw1wIwSBpW2pW9Q=;
 b=R0Z2Yqs9bz1DXcNRi7FuBaIKMBtMvwBVyCsOY73vDLu0sM8fBIy9IHmM4ry1kI0FuYvCwAH9xkXuaPTP3nTsjNWJqEJgFhYkDYdfSdjwCuFBS447MD251jcMLxtw5I8QwFtBPf0vJOKsgNcydi3klufIuqTohwM9TKlRiI3RbhE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB6304.namprd10.prod.outlook.com (2603:10b6:a03:478::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:50:37 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:50:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 17/17] xfs: don't commit sunit/swidth updates to disk if that would cause repair failures
Date:   Tue, 20 Sep 2022 18:18:36 +0530
Message-Id: <20220920124836.1914918-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0122.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f5df213-782b-4c42-48af-08da9b06b74b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nMFDZ0QtX2mpCFHb1AkGYfs27qyB9Aive0QeBelikh5pE8YZDXnOPg8LSRoiAwIEVIjrXt1YifKjzCF3iL2W6jt10YoHDkrnmC2g7zZ+bYzHQhpySptPrcHIYh8n/OxvLd6Jw7TDx+oFnFGBmRhWHAkcZdXYpeNIvkqgl9g9pU7f8si8LTxib5vSzCRKLddvrKULfNzFs2WNGLsf2sA40xg3HDWd/9SMQxZ6t4OyQvBHxchKIEE/NeslkOEEXvG8+0dkBxozG+hF6t1HOgKGciZb0wVKeHZmvKeccAZpp6/P4Cuw9tv2ByWBR1FQb5P7LCvre7nJi4k7v0AGdMI6qXay+glN105EwtiCx7fQymaaPrMzuzRsQAjVFkDopLI3UyGk9/Dl1IfKxdDLMWD2uj6pPOUc6TWEtAJ6tx6hlna0mCm6XSLi3RWxp6E0T2dKwPyMwo56eb+/wJ5yDYKNSDC5HF23Sfjb6lRR0/FbJwre/STxI+NfWj6vrRgmu3euNDi6A4NF13sX482ZADnYbu09MWHk8QyHwEykRADDzXpfzAgTNiGW3Ln93e8IQkI2a4ubfYJeveMUgWETnJMtW0YUkALRFvED55mmS0nVztZxeFfQwAO1i2SAA+OiVaj8CSNfnwV80lzQGjpoMPN2KQQOvkxdbMMAbKulH4tLdubaNv/IQOoCYVNNPzinFo9j6jsEl3d8o1oubaIqqgNaK4r7tm5GM2dpKC9b7Sy3CJkYKRcKBPdonS3jo+19w4l29LMSSuQRlyM5MXnu+JDUwpoFpIGIwJlH9w8d52jIgNg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(15650500001)(26005)(6506007)(6512007)(36756003)(6916009)(5660300002)(66476007)(66556008)(38100700002)(86362001)(186003)(2906002)(1076003)(83380400001)(2616005)(966005)(4326008)(41300700001)(478600001)(6486002)(66946007)(8936002)(8676002)(316002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WxRzxp8pYrwqxE044hJDj7Z3/1qopcnaNrGonXip4J4EXemdVAktu3EV3NPL?=
 =?us-ascii?Q?t3hCHK27fLn5FTAx/E/FnUJ3TKXlRHS/pneRWi1mrHnJIxeQ/AOw+x2tCyf5?=
 =?us-ascii?Q?dB8nbn/3PV6bGRk/tDDcNQk+Qt2UwMKuTNxFuLGijz897It9+gdceCbZjQTe?=
 =?us-ascii?Q?o9BTg7w9Jvo+ViBhWLWl1E1baCoPTrNMR/UL53WXDtWnxy90B/u4nf+okuFp?=
 =?us-ascii?Q?WwjnMCdEaH7YHNBElmubzk2zgncIonD0CfBN85niejKCPHKF7SZGB4LiVkCF?=
 =?us-ascii?Q?VLbR7f3CPe61PvahYiCf9WBm6ToqR39IgB1GuxSOHDVBP9ry9TS/liyobbae?=
 =?us-ascii?Q?iXQmmLyMOjShGBSs3ekez2D/+aFVANLF1OnqJqcfNqOUT4oavd/X3hXGWxEi?=
 =?us-ascii?Q?gXrlox8QEd3QwidIMR8rKS+/dzCV39BydL0yjo2CqBa+eHOtLaUbu7bZmVJL?=
 =?us-ascii?Q?FVi0Ppx/iyuW62YX8D9U2VwDjDScAslj0o4ujaBMms5FO5z1s9Y7BsfZD9jr?=
 =?us-ascii?Q?3w4teT3W9IBfomPDWqFDIcwDjISVj6c5tsvOPDhpPwKSb3a/4ojdXMNwI89M?=
 =?us-ascii?Q?ZfcrT+L4fZTnmHiGraHPyCstZE8xx0+vxlSRC+duirIZt+krGjawayVJUUVd?=
 =?us-ascii?Q?ANIlJmg7ry5jaraXee2Gu2oMe4R4mf2gYMDr1XholJe+H03WFJy9qyY1EHLL?=
 =?us-ascii?Q?F/0dt5iFJ/62BHbwh11EPt+zPvBmaYeHIOLoe8bo86C2JIy/gemOmLYaeh0M?=
 =?us-ascii?Q?15sHnTAFN6I5ANJgQeesyKyydhToa/rd+lPE/kYv+0TRT9PXNUTal2Nxn9J5?=
 =?us-ascii?Q?85+linBFvwIXlEvVkS0Wbdem6CvL6YohxTj5CLlFOy9GU3gHpuIBwtTb691O?=
 =?us-ascii?Q?OpSfRWrvGCr5/viuq8hY2R+6+ocghPo9XuNAa87HdbnHYK+eD/KzYt+guMiO?=
 =?us-ascii?Q?8HeTEAFEjMBilZu8VieA7e/AxdU09EtwiHDRWA6A5NBoMTutA5Rnz26/JWdw?=
 =?us-ascii?Q?G3N1/1MX9k/mbA/izj0MyKaBfl3tqo0i2VnztGGXkxRYRqrZxpcZCYNQ36jV?=
 =?us-ascii?Q?LFCHeze5Hmbi20DmuS8Z1ULv8asi3ofaOwCNXrmsO8d4D0mPcUNKABem1Cmv?=
 =?us-ascii?Q?GgTUTLJTOD3k+KFunpO3u2eyDbG0P2ph5c50rbHGN2PX1PGXKoniFpCdJEQD?=
 =?us-ascii?Q?YIlMwMi75c0BfeY9hRn7YcZR9MAYq7aK8AIqwwjuGTEm30T3adBITNHEt+dA?=
 =?us-ascii?Q?+3vnrzkRCiWb+P1mgQ7McK6yLUojcTfoa9cFvZ18wvP9KSFziP6t7Kwp/wwJ?=
 =?us-ascii?Q?WlEWDp7YwKZu0+5KY7vbom3undCKCTAdrKILErkb+nwRj6mHrU2j7C9KFe5y?=
 =?us-ascii?Q?HyKkn1irc2i5o0KiD+UMIYRQNgkw+grqkcklcxmSq3WsbPN+99C6R00mWtxs?=
 =?us-ascii?Q?F7X0Pvw61JFZCRKpCmDzZFQ3VOKHLdT9bue3ezMRlIYF8Yvrw765XfIipZe5?=
 =?us-ascii?Q?odbIagNPzv/C59kaQsm8tyQIs5XffLeh6lz4Qn9yBDCvln0nlRSFYNXaQZqe?=
 =?us-ascii?Q?hy1WUQbNzlpFUVi2J53B1upctqKEDst8jhmxKZqaWAcd5AOsL1NV3zeLWJ0j?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5df213-782b-4c42-48af-08da9b06b74b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:50:37.5806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhfE44Q1C6jN8C+w0IvHJEh+welLOQQXu5XaV64groypiB7g8TGIj/uGv8KPloogSAl55BxhboO8GlQUEmzY1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6304
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: Sa9MwGwKHvWBA9bKijG3IsbpRH0S3OQu
X-Proofpoint-GUID: Sa9MwGwKHvWBA9bKijG3IsbpRH0S3OQu
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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

