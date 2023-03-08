Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10C3C6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjCHWiV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCHWiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1737A6150A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:18 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwgdQ007284
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=iWom3jx4wcywWJgX+9XH3WoN+TfLOur+VdCgW2ffFso=;
 b=M0xBWu4Ay4Gk6GkdGGa8/oI2cMI9GdeQyEEqcm2ZlcywsobNTyG9RYhUxVsJ2GxNybs3
 gbbkYt/5RyLb1iwbPf+SI18aW5OuRNZCuUrB/Hcq2pUu9z4GrQG3+46sgB8Yj+lX0Ulg
 74cf2zDAAd1LHa9Gt3RbHkFNOk2YMOlbqEsVgZ1MSqjomlPGn8iJdvtoczXchkbZPqjM
 WMfFrb1K6513ojIlSBrA/MXzhRnvcSK84awIopQTA0U6O7jPKSyEy8+xulokmlieBdP0
 m7xPraauf1LY/5/IwchOgGVX2eYl9SgU15+B3olEIxU5dYdtL6lLQbwryS/fWcQw0kX6 Gg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415j1faw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LVM0g015688
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6femx3av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ws+bDqmfm4iB4jBkqvJSaVB/yA3WOvL2C0SuB+w12AeBvb/7kcFUJCFksqjPYlfJlUDNeBH7GmCBrkpBds8DZt6nAPXNWMidN47ExIY02YobXxi1SUGTQB5FS2SWl4m1UQRxxt+sO5xJJtEkm/O9oBOigfNsogmIqZzxQWUMdg3s1VTaYxN1B0U4aU6m81RVq2SB6B6TkzRS2SfO8U+CucQg+tN1IwwCLyNauzt3HdgtrjxMklTPhCkTGWl1mKZKFDCCaYRUbEaKWQ+MKpoNgM2rRZhvt7IGKlTPkwIYV7ENXvpswcwmcNr4N9KDlj2hwX1VQMaWNU5y4KkApqRXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWom3jx4wcywWJgX+9XH3WoN+TfLOur+VdCgW2ffFso=;
 b=XH8yT+jEqsFG2Vvf/E98RfSVhJQQWC8FD8eeIVB2HUtSbw1HZ/qlpKYRD4UwNUhk19AA6Nk0twuutLU6qcovlBTKl0KkbzsxGIQv35xlGB7R7N07r9nMLYGxRbjRNdban9OWZsaCNG/37J7YJ7gkIGSXg434pNnC3NpC6PgzxNdTtlEbVhX+yeuNqSQ9uIlMyvpRGmeDt+Sru5/ufVFJYcmJevz/akby0CjXq0o0D9F4qGAG8kZWRUUfF7f1aXc+z3CRvoJJMq4kEB8lg07p65vhmYAaIlpbKaUFnT5emu4D4i8Nu/kYIu2ySlZRKm1E29uteuFncBa0RpvoIKPDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWom3jx4wcywWJgX+9XH3WoN+TfLOur+VdCgW2ffFso=;
 b=aqIxERN4kuE981QrqE1Unats3R8NRkQcLMg0ZIz+Rnssv/h30fbGcOSKOLAvYZNfzteOMWBJ7Hbt05+iuB4WOHGkMvJte05lsZP00YwpNu/jCbORG0BrzSbafg46Wn6s6ZJGnVEiBSObRsjblouQ9FcDrg1D5yUL2MPj0B9q2Ds=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:05 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 05/32] xfs: Expose init_xattrs in xfs_create_tmpfile
Date:   Wed,  8 Mar 2023 15:37:27 -0700
Message-Id: <20230308223754.1455051-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::49) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 999e1813-d854-45c7-e842-08db2025c874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I8vza+XELJUWOGr6f0NRighTLYgRojsU5pGZ7ZV7IdIqk0joyJRjPGquSRyfiVTlsL4ZiLEAMVmyEBhxO25rtLVgmHp6LBu3idg4Hah3okx0CbJPQeLOZ6MHpYvtlG491BMMRpol/gchwhtZyqVetKTGPGZENc8RjYQHOUJ5vjBo3SqiLI/ehamm1mm10OuQX9wFZBH7HheBtolOr00GaZAD9WukV5psX6z9OpBL9Vp5JCzj5C/rZhdxS+T9BxL1yFYStXMKnaSOVXcBpcs5QU/IJ9WQX3kFF+nA3GY4cdyH3XgvN32hCmikTrzg92ZX+60XCOfA4IjO/JsGCoMRNXzOa6oEr4BpsUTs7Ns4aBHwp2evBmmwWELdwojlW/wm/MsHJmEARNsJYlMEjlR9TYA7RgjSojKSeNWREt30/se1xMPzPa2Js8QFYBeRD89JRqFT5WuN0fn0vZJCL8KXbrz0gTzGvpmHJmV+rQm2Dl6hFBW1vYDEsE3bSHJCE6sQjrDokjbMGYtQqE+cfyrcizNd+b6wKg/4Fe9wFsFxmGS7FeV1+rmFWi/5snAOwnWmgaID5gaW57vqW6B97uv58dDHX8mBDR1Cu2QZxbBB0TeSebUrOSRPK1Epmnol2GNgc0P271LvG39F9VjM3xuxZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vFPPd0YHi7N74Z74Mhg9FYYNOnjowVXKaXvUCw1n/cSh7xIiCMrjXJ7fPcXO?=
 =?us-ascii?Q?pC7Ebq9jMJDLp+QBEq5u8idOQlO9r/KY5vTI80XpMT5lWxJJDp47wA2IFTrx?=
 =?us-ascii?Q?XdPY2Kzj4u4TYF77WsPmkFS2erbvt8gJyBtwOiEyHwCaR7HK5S2M8yDGw3jj?=
 =?us-ascii?Q?Hrg8Iw7sjaVTdvNHyDVaSRBiEJWkMHJnFmkfc2yeSDDKlh5tdd3GJAgvufpX?=
 =?us-ascii?Q?/wSJRa2iJY79je0Ld4YVRYUNAzFhkceXLOsbGK1MFBv9l+hkjDmbvW0V4AzM?=
 =?us-ascii?Q?5tVh+QWqjV3sSksxtj1U6ogQUJufKO56O9HuZP71RHYQN5GvMvpClBG5XP4D?=
 =?us-ascii?Q?6zEFj338xNHdodJBsHengSKbd2CcvK5z2/WWTAR+62OIVDxjlfCDPv9wcQDp?=
 =?us-ascii?Q?D1aGa46zwdM/eymvaxpqPTFjCheS0yzURMTug4s709dnK36KL02y53fjKr2m?=
 =?us-ascii?Q?MuWdRSiWvCqCDmEVM9VdrJxccf+j32oKRgagHxaEl4mkWzGSaF7cktLEFD6e?=
 =?us-ascii?Q?yp4tpbYBBqs5fAtLGWDxU2v03TugglSMb6N5o4vqpchifAmb6t4svtmbAzU7?=
 =?us-ascii?Q?ce2tMwrPg6zYxVV1iDAKHd1S3suMr6yRolRClqnNsqqpjM91TavjmrlYOeOa?=
 =?us-ascii?Q?PrdoXUz81c3Vz5yu1jrVvnGQuTPhD4tXsSNI+PO0OWWwdxMLZ3UGRJn3MnVW?=
 =?us-ascii?Q?xbsGYW5c7XcCHxYIamNF2MtUVQocHeicitP/ss6XXsiw0G3+NPq+CZXwjWsg?=
 =?us-ascii?Q?oi60Te2gtnCbj331Hk29vMFPQPoXEQEp530HARpxZTghVMzJGRFxy0jEnpbN?=
 =?us-ascii?Q?d3SDU49ChDu7OZWRa9zfvqXo8UelNoCKuvQEclhLeEKFFYkj+9Abf2ulVcy/?=
 =?us-ascii?Q?N4iq+w1GK1ZxNekI/e33BttN9ZFdfotdeW8AcpFHJ9u3KDqn58/bVUbeiXcm?=
 =?us-ascii?Q?Mtua5icLUuC3QMeRZbOn2LuGvvXFe6fw6K3/dEVyqAfi3fHK9Vg4unRriSB7?=
 =?us-ascii?Q?MB9OTsE0JRPBGm07ryuoKQePxYtBYqEtxxwoq1Za3g255d0MkeXOHKlZXo10?=
 =?us-ascii?Q?eZvrqJMizme96t2Fad+9iXSDZxqBA0cJ2tz6yxeTtDjX5gHyPWfNJNhHCjEU?=
 =?us-ascii?Q?Tq5NAamKUM1VZsJpqdOkBMsEz8wxkE0NXgHnMXARd8AKNPtMMzXInvXYi4po?=
 =?us-ascii?Q?G38q18nNlqbGsYvipZ/LwLQu/jLvBhcDWj5hpju2H9+3kWtC+RPTsbbatUZ2?=
 =?us-ascii?Q?duH8r9Swy7VA4hYHlLQSoPRo9AR3hogJQ5GR7iuUor9YW8ZmJeqjxwbyVltF?=
 =?us-ascii?Q?LuRtGhjYVRmoLRnZjBmcKvYy9lTnP8Q0syRaTJ4oNskZnfscfi7dIQK4Z0Uf?=
 =?us-ascii?Q?cluIK7HpNSrcPar1WQ5XKobnunOTA3027TV29ITK+EHEd/lOiNcn+d64A7Rx?=
 =?us-ascii?Q?Reg9OzcKC3uj4n1BzxUSkB3Dc+rsHK3lvP3GPKDcy9UveLkiBirTbul1621a?=
 =?us-ascii?Q?jX19KMOpaWtUV5GipWRr1f8K7ZjgASbPEzhmcgmlYYMUqONv/489uhjoXSfw?=
 =?us-ascii?Q?Vr8t1VpE3gYPgU9SbWJ8Xc/URzdoNmbcXYOL/WbPSaK1sUMGPzLUZt7IebCV?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OgG960fwKorXgjmBQqLqD1JztyBolGB65RwLu0eshv23/sbtPxH/AsNX+MdJ8VNY0LG4TT6Jh6D5PWC+UvJxN+Sx5oR8iLxYywWKWdupi1SojrjdYMh0GtKz4Nni03Fh4XEix9hZRbxAZ/1byO+cnYqaghd5QDW3Hklp7RjJWOHc5BhYWrs3qMuPqWqlr3h3H01jU86JbGEIKBrzZVPDwOi8+uZSPZiJtUdQRkCBbAvR5/RfkPEBqVFWLhb+S7cb+85tKnj1L6t76P22YC3rzFhFeBJHDrB/vFjWh1PQhg1QWB9barZwhrSUcJQVT3Qa5sSG4xU7MCxVzITnBIAXqngZ993/288+WB/YHIpEjiyX0L/uJ2edWJJiMI7s2W69Se+kvY4sfXoEcRCJrUuSEVhXn9idhXvCprcF6APGHSo931FjROX+dBXFbQe/3niOqFmn14MtW8s1pMjjeIo75B888+nM40VYRaZzhBvMVpZDqoVhznFsJQgj85gJfZ4wNG6HeTCLaKWyfiOVRKMqj7tQdEP2SqT99zifTAJWdAnGIZicI1CvbiNmtMR0HoK5RoWBRBo9xl8ytqbxurhju4j8jnGiMKKqnzJ1CkKsBPHK/KKMOCS2DFEfaL9P1oIP0AG1jRoP1YBKpH/mTMeMJq5unsRQdED3IGLKLWiGlexLBULIwd0PZWTuT/zjN4vHdhKgMmL2U1iFCM9e4m6UTzvTeFRJNtJZ1IVef9ydNayUZWVuF2w5WH66hZYSMH6JTjAhOx5nw4VRdM6I+ej05g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999e1813-d854-45c7-e842-08db2025c874
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:05.3603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lagv9z2YXjA/J4iuZnhn0wJUY8VMgH8yDU/pzpOmJfSaSGMgbV5ClnMfhNqfV7NCm/BfoUXwm7Nmj1nhlt5WLh5dmtY+GzAwjw/10/fm00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: Ww0E-85iEtSygwKLP9Lkt5kWej3t3_Dm
X-Proofpoint-ORIG-GUID: Ww0E-85iEtSygwKLP9Lkt5kWej3t3_Dm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 5 +++--
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iops.c  | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0ca2f9230afc..8aa8a8e17a5e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1109,6 +1109,7 @@ xfs_create_tmpfile(
 	struct mnt_idmap	*idmap,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1149,7 +1150,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2750,7 +2751,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 69d21e42c10a..112fb5767233 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -478,7 +478,7 @@ int		xfs_create(struct mnt_idmap *idmap,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct mnt_idmap *idmap,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 24718adb3c16..afc3cff11cf9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,7 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, true, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
-- 
2.25.1

