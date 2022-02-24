Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6494C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiBXNDT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiBXNDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBE320A96A
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:47 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYIAD000620;
        Thu, 24 Feb 2022 13:02:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=C/wcOAprfm06ym0WC8Is8oCMFpGNiIJSVgv1SgxdZjE=;
 b=Xy7agY6eRO3VKYSsCJ6itlkfwD/w4DPQnlxn1Fzhp2xl9WA08KLG8XgSNqsh+eC5jxvb
 Zla0I7u32tkSpDOCy54/pxf1DoV0/kAEwQcvYZFeOWE00a06o98OZzvOfzwmDnW5leZf
 OO36fvDQ57WMvNp0NZjctDd81Pu6RCSaLXD3CgPL5D6+Av9IW2rCf0XRJ2mZ2v7J3zhl
 fiupWXILixWFgH8W28et7R3KMuEp9gv1eAs5sstpdWMhRXlMD4ONB2N6D3u8LxZdyOi0
 IPql+5xM+R7HgklOyR6QXPJGToxI9ftrUP+qg4M/LLGwwXtdT7xjYVmv8lcVJCp4X4oH dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6ey5r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0Xa5120526;
        Thu, 24 Feb 2022 13:02:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3eb483k735-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJxt5nmC6DiQZlG9/LhRQ4/pqdK/xCi7HAY07Fsy/pQ6Doawa4iXltK85SC7uJ0hKesk1/T2i4iOEn8yPPhuDzumGNMMV8ZjwrgN1c5hMxYtGqkm17imUY8dVjigNDdEyPpNebjsV43nagB5OxI9iVVhKKxrNCwg9TdZfz1q1oP+Ue598eFKYRy1nEA38MSSQhnGGXbDIg2psIksF3vKfLLfpwfC/TdUO3uqVNWjuNPXq8SmbaEdm+G7W4jg5w82EwBteLhP+33OzgGqQ6dCJYi3knJxcpcNSE1jUQIweaObsuoMg+r6oteUqowBTZXh+GuKO/iS3eTW1rBXKmKf6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/wcOAprfm06ym0WC8Is8oCMFpGNiIJSVgv1SgxdZjE=;
 b=dWc+uNR3DoDXnVVZIhxv7TMzDpuVsajf433/AtMh/FaP1QsLIpGBpnNToB6KQlIaeEKMO2qRg/dNAVrHkEmnx/y1fqiDvrHHgo7Lx612ra0jazTkxikAttYUZrYOG+ugmS2uVQl3lOQ4jiLtD0j36rTYMYjgUT41m4f4Kf/TsBG6WnJBrt9EQUY4keCnlNhsP/D4s1dqdNnoqkn6d16o8guvE1TrnCm9pwlMaDvkoREXw7HHAkiCBE/mc1kBHQNTB5wAiVt+oOhgEJhkZFvQ7dD/pW4MZppvLG+An9XN02ehkabb2/92syWBTWJuWCf1G/0We5wPnrOepO6pf6ODZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/wcOAprfm06ym0WC8Is8oCMFpGNiIJSVgv1SgxdZjE=;
 b=k9w7untuYj59BsrHlX2r0aY/9EWtVkHkHfRpDRqECBLtBwobrouhrOvac+63Ajrymawwbbj5eiJ00j/e4C7pWCXySxokaQ4fVX6yzYvQhjqDPX/xKUyTTQ02rM3agOs1tFCdrIvLH1TOmPGiMOfk0Tbw0EwOSuE1J8cLR/dsFiE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 03/17] xfs: Use xfs_extnum_t instead of basic data types
Date:   Thu, 24 Feb 2022 18:31:57 +0530
Message-Id: <20220224130211.1346088-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0f881d5-d4f6-4060-610f-08d9f795f0cf
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB366569DF5704B9C15B884211F63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tu4aCDLDK+9AkLJGsV82IOslxzMIsd3P/U0vO5WKTQgQthpArOAgFTPU3ZXjXKVdwzIyAku9kAMCT+iVJNq/fh/YDjLORIecagdpJNmPheiBbd4hDlCdF3sP91QKhqCzkuvttysGygYjYbU73ACDM5oTJtOpdftz5w6dBKm5gh0tAA2a6RIUyk31oqeRSs3PcAJm8gl0k9ArB2euI1pbqsxBqqmMcR/dMbLjNR197UJRKh6tiaCqp2SlG2TlT1dAmNnB+KvW96H6lVn5VDwwaH7hKN/pv0chnk5F6FA/O6WyMPEquqMTFJ7zk292O96QOSS3IswubWkgSPVBCjjkDbPR9tVk3KY8oxx9bTmE/xHqFkvgpM4mMEbGBCNHQxrN3nuBGYS2LzAeKB5t6hXhoo2SV7b1MU2sp3gSB9OCf2yEkA61UZI429XtLhoim+KE6MRvtlH15tYNMbIjbbahE/E09iXkHI/Ggv0Oj7KIaNOQHDbXVUfQAJ3U5NV9456ilHJ+Th6YXqnKRgWUktqV8ih+tbE5R34rzHRiMxG5H43+yyGpRxWQkJwFr+guy7pzl2LYDlTkhz069kSiLKo3M8w4FEHXsZ1PbjCZsLIMGF28TClHdrCzpHD2eA+IN/9Voq7Za+QqMFvMJ9wNnozdOxdRLnvyzWDpcOQXmvC41DjVdhE3K54TpLTK+m5QRpGJyyHV/jZH/Ay9ERiK3nj/5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?51SfnVPNBu5S2CkFmQ7bpR4aSP8eBjP/E4fuczpbQakGqhr4WE2JXB3/oIXv?=
 =?us-ascii?Q?MlLOLBVEr0T9EjzaCbR9evGTdxWEq/BNHYRFqGm7WBAgtzHO61ENfaynzR0C?=
 =?us-ascii?Q?W4r3iQAgxqkmdgheRwharWYXMZIGpSEi+0zBG2S0oS01Gi3KD5jFN6Dm6fuC?=
 =?us-ascii?Q?ZBa9YnuzP0SKJELmiM8Q/SiipDYp/eaE9mmm1aq/I9oKvvN2D5ACtNzuCjTG?=
 =?us-ascii?Q?gTKCt1DfNfbSjc95+0g1QJpTufhjZ2+exeqA2xOzaVeXC+Ta2oxnJ3Ra5F1b?=
 =?us-ascii?Q?LGAAi9Ek8cSOd7ax7NZfUVALuXVeQK+XYOOVvLZchBUXRDo7mZhodnwLDhCX?=
 =?us-ascii?Q?Awf9HG48qBZXIOYBzGF7JEHk0ASE7Tpk7uXXfZPK/cul4dc2HhSTSnOB2A/N?=
 =?us-ascii?Q?SlssLXowE+iETnf7OSNzQOSAeb6oufAayxx5ck09i/3PQVpZpdqWDB4nCfV7?=
 =?us-ascii?Q?kJzHH449bFHDFC1uTHS5Hw0RSQrQJhVyuc+xO8sk3+DchFrPA8BxTLo2yZzq?=
 =?us-ascii?Q?sAoZitbNwr1rFE1WCggp4Jj3XnA/8cP5AQ6MUV2ECL1J7/ZzAHjZBOBN5VRA?=
 =?us-ascii?Q?Z6VpjMWnjEbO9ZJGe7JsokIjxiySxoyt+Y90+kfjwqsGuVjJrZHZTn+2OQ2V?=
 =?us-ascii?Q?1PVOvOkICErVJO4sl1La27jtr3Nkh14xY7B7YxLBrBsz5AdWJ12iFB4zHFvv?=
 =?us-ascii?Q?dxrFwi+k8/BnrVCWzp8yAaoIW3Lxtfc7CQuCtHAV3w8sJoReF/Rpr2tPl01f?=
 =?us-ascii?Q?QsbO+WAVpu6LVVzbX+FxJ2nte3DIVuH7TN7Dj/1SZIgs8npUTaUS0OjGVa6B?=
 =?us-ascii?Q?vnyYxxuvONQ1xoP+O4XlfKuie3px66KqF/8lKifkdgrsjxcpAUkVW3CYUmym?=
 =?us-ascii?Q?iCm2zZ9GRRYk6j8novRjTOd6mOveiMrIqu0Bz5UxnKZx+pI8Qy5DNxsipnks?=
 =?us-ascii?Q?Xubo+Yk+mPx/eiHmcmXyrmNj6k9a84IGFHHtFeFc//mLGy/IjRX9WidGBWqd?=
 =?us-ascii?Q?o582cl+6TI3EEgekR5zli2gHNZ/EtxF7xJE2CpXNjN5Vptkinx4qVyx0uMXe?=
 =?us-ascii?Q?RWG2V9+hKaRQlPGBk+BmwMvvZVHc53N+lnqNWz/W4Nyv2Sk/a9YwlCLdNpGZ?=
 =?us-ascii?Q?dbVNZAH6awzH4dl/P/D7zpzfrm0pTAUJ2S0/wWHNNcEHawNMAvsH9j4FtQbn?=
 =?us-ascii?Q?Kyn19Rhbrz6vrYRPvP26MyQuaQZuPJSbFMM20AGcN0JlNeU8i+G1pErgIl3V?=
 =?us-ascii?Q?e1DUtMMF8kl98mx3a/L37cjSfzqs5J158txbhJk2Ao9/JY9EyE+GgTk0I62L?=
 =?us-ascii?Q?wTiFMQ6oqolVA1C432+CtG8DJQv1ryDCd4ayyT2Erx62k/hHeaGukgD8QZfN?=
 =?us-ascii?Q?ESPt4YZiPKpOdbtsAxUrU1ov1e3AHLyyd1j7JPR5g5F0YfXeV/Al8n6pDlYq?=
 =?us-ascii?Q?6WrjITJORZkOeAVA5G7ThXnjC1RhWjiSya/qDobP6NchVJ5TAq9ql+73mlf1?=
 =?us-ascii?Q?G2+CALQUm97UheGnHjMFrl85+yVn88sLF8IIEY15X5jzsbaQtGryhmJJ1xhO?=
 =?us-ascii?Q?0S2yfYTB5RE29F5BZsUwE+vHEcrktgghW5MS3bnxvi0UFO0j4VCKkkK6Eu4+?=
 =?us-ascii?Q?0Ku3eW03d1nM8s/APGt1mC4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f881d5-d4f6-4060-610f-08d9f795f0cf
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:41.4602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2tp3fpF3tkjrTpB+JBYYX0uMheKgiqqgkAI9pjj4eXm/RV82MB6QLa//vOHaaj+700k8o4pRyI3BW0YtK1WG0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-GUID: 2rrLmwMNGrwoCrvut2vFFDAot_rvatxX
X-Proofpoint-ORIG-GUID: 2rrLmwMNGrwoCrvut2vFFDAot_rvatxX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/scrub/inode.c           | 2 +-
 fs/xfs/xfs_trace.h             | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 703ab9a84530..98541be873d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -54,7 +54,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e6f9bdc4558f..5c95a5428fc7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,7 +336,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e136c29a0ec1..a17c4d87520a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index eac15af7b08c..87925761e174 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -232,7 +232,7 @@ xchk_dinode(
 	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
-	uint32_t		nextents;
+	xfs_extnum_t		nextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..3153db29de40 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2169,7 +2169,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__field(int, which)
 		__field(xfs_ino_t, ino)
 		__field(int, format)
-		__field(int, nex)
+		__field(xfs_extnum_t, nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
-- 
2.30.2

