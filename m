Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1274C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhLNIr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:26 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9738 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230389AbhLNIrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:25 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7tcQT005519;
        Tue, 14 Dec 2021 08:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=2xeiU0cVekE3oivvjR/a2gMXpA26H9sMCs2gOojwGxc=;
 b=Ah/ehK03oiRC6h6uuOeEi48go9ydSGubxSPwfXmzSF6mjyjwHjIsSbzQatqJZbB54deB
 eX+YdsNBzGSelrE67KJ0f/GHx5CiXozMM82a4yn1fc2VDCrXDJeqxB7UETI5nJ7Nn9Hn
 0J0nddMiX0epg7N+w1P0aAEzk5ab2Vr/e16z+rIV4imnhWS+RbTGUyn/yzjbNLDkzYXF
 AsgpsyY8PcOD/Fyj2D6NYc43Ah/lFJsD7Xc7MWj50+7s4SN6GHfEKd9zDkIyBWqyyFyi
 8gnu1Qe/3BXqUppvf0Rvz398f2EIYFyFYwkehjhcoxMdR+PsV95xTNa3fHsrpVe3Q8hh gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2srq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eSH5074180;
        Tue, 14 Dec 2021 08:47:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 3cxmr9ygcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZBOENBOJjFZppLtjc4DDuaJBliyNr/dmERfXv+zXRvji3Bn8euBi/Asihz6Q2iA30ZMkJxvhxl6MDnhkQN2WIlshBF9Fdt1vix4nXEX02r+5KqIiubiSMufDvBY591pUMiwY7mKP479DPfbUFFXyTUVI3PGVeCBoBtgt8w9E87yFX9CT/frPPVGB/VFpz0uMI+zCKg04jaLGLOD+/BIVOTKHAWpqKC+91VdPLxubbAKn4dj1bOMnjrb2AJeRUyJpBn6Abycn+VZP/+hvS7UM/XiYXWsAKWZJjZk9I/vsB7haysrer2nBd5xQE5Xy6yHsa63ANNaFoTNy5vtgxlRaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xeiU0cVekE3oivvjR/a2gMXpA26H9sMCs2gOojwGxc=;
 b=jD8z9LNp4b6K4oHsiMBpd6f8vXFZeopxenR6+PXbfSkTG0NIqLwVzi5GTTeJIVdG6doab/QXTEK/hdR8VzmjDjGbTYmfyIW50QoqO+iC+Kof7khzM3hjVEI9jLahOa9ezNTgIQ/+btC0DdGxX6w/+0PO0ZC69HzU1wOrBmebkcaJJb4nv5r5PfurkMUgom0en4Arb6JzrMEW+OdzSbm/stm3fxTp5THcHFGvG7AAthQ92dbZtx4452JyLvwvej3ngTGDEELQkBYJrxhR0L27Zihvfz/79bj/AI+gmeGLdaLhqsrUNn3aKkqVZAWxZMgt4TQcJ+a5seDOGIQNBX1uWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xeiU0cVekE3oivvjR/a2gMXpA26H9sMCs2gOojwGxc=;
 b=PW0hmqqp5h2K3/flR0tYcQ4R4uNE3IetbUNgEaTEvx5o42zuHWK0KGKONwDGdUy0AyJUpIrcWvbc5444tw4kpJCfXkudiiZ090IJyIhDL7bxVUfA2WxqbBGKKpXIhy/vl/FT8WgxC6hdLXb5yW/Rc8GUd4oxDHQ9NYZZx9ZuDvU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 11/16] xfs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Tue, 14 Dec 2021 14:15:14 +0530
Message-Id: <20211214084519.759272-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f797fa90-2a38-4264-3cef-08d9bede5742
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054878B7A37FA9445E39686F6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6CHJtSdV2EyTS2fhgr8IW0XBOLgjgZrgZiHM/nILCAoNRpOU+yoP82rzO9YxF9ieIqNtwZ+4cCUfy7CbOaCn8r3EEW42VYL0h1w0kJcM+4q+bmwOLjgG03o4CCrit28su9hqr05XQVIsF7vRicFLQMFhdNgi+uYwoerPsboWiCeRMz47P+C03Ru1NBbjFhA5yWJS85VUaIcQzPPeFwPY6DymgyWSRAFLOkCmBKH+WmCgonzCRW5CJJKbMtUiepLWbLXAwP22zslge6YP+9JVIfuMLAhmFuKN9D66XSFaM8ak+ghfZ1fzcHcNL9lme0yAEMLrtOHG7+W30BNkNl3x4trV+3sn1NVJTcEGplH9bwrw3co/XxH8Q23yYOWwPGi48kwPfYpGLXqmxHP0P33po57VUzSiLa0TYDSBjFfMxcxx445mbaIki1N3spFxDaiD/5GJNMPlOz5O3AtqZuzrIXIw69RKkldWWUTHEmz6hWks/O2sRByUhf3OrHQYOd1WiX9KsLrzJSANWdC5vbRV2Y430DAoZwbwYet1HldUvoAOQkjmROJWdQZaUmw2juuuInQirnamvp7WGtJZsfWfBtnX2BYM4KUMfxxbD0aLleeKw0XFqsjUjn9d+49VLXOyCpU8WRAHk/oMv8POKQTRlP9xNlTvNx5/zQ3YlNFESrpDc/ZgabAsXN30a2KoCKhWp+WV8vCVR8NWLnMHhfKWdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TlBbxDn8J+mdaxUrEhYMwasIg0Cvc28igdO9yIO4Mi9EIIkZki9krFWQpfEH?=
 =?us-ascii?Q?Bv9quFkaqudIuQhVasQGy7b6wUEvJahPwZDQIjjx8DPwQ2qsQWoSZjA8/FSZ?=
 =?us-ascii?Q?A+oGrJgvX/UB3ADtxSC+mN5SfGdlx5yBgwJhWq1cXywdz9PGg+pv1OmE3Dkr?=
 =?us-ascii?Q?VdEpc0ubAY8tsp5wP2p8smFgrfZRJmYxeRbajKvHFJv7Vu6MO8CGWAcxf06A?=
 =?us-ascii?Q?7CNI8a4pg7RW4oWTPmedqPLTXamj/tyFDh+h6dtp8HqjrORL3IJ/yJZOUrS1?=
 =?us-ascii?Q?WmKtckBUj3YYMoL3JdOW+UrAPBFvSStjguynpPpKzawbW2KnEaC5GmrybwQs?=
 =?us-ascii?Q?SR34AFfaaSXuqRtLrCdmEHnHtWo3k/p6KeZQt/fz4wsD+22TePmO4MtqWvOR?=
 =?us-ascii?Q?i822IUDNion0N5G+Hi0Uc81ZKjc2+7/4Y5Y2G9z1khRVS8KrBB710yBg3VHr?=
 =?us-ascii?Q?rKkcVd+uSJJR18QqnuL0+hmF9YUyw3voBT0HCsZn41EAV7zAncJ774zJeVWY?=
 =?us-ascii?Q?Q83OlqRDOmxm9HEo/6UUgPeni7nfwEZmHpdhYjrmbnqjkaqw/c50qh+JQmp9?=
 =?us-ascii?Q?bP1IxR1geMcOC+Ueb6KsTX9/va7lUqMFIHS7fqmrbX2i2mA1HW7UP2tRfngZ?=
 =?us-ascii?Q?ID0bDs+fBa7JvOXME2aYUOvf3gsr4MPT1xNmKmqWJBfGWOytgzFoiVbcUfu0?=
 =?us-ascii?Q?D9Y4xMv30gV2WFpR0H4HPyKNKP0BfZ6K1hiLi1WJgkJ9uQmNrlXfFcSBMmsS?=
 =?us-ascii?Q?0lbu11s/Eew3HSqRRMSwcHJcwpHcu1ulwWDmKy1if2keSoUJripkYoXyo+wd?=
 =?us-ascii?Q?wUy9R+rUclcaepSRZpJvLGMgJvoZIr3sGLuyGfSIxdzXgkWKwTfY2m4ccLeX?=
 =?us-ascii?Q?b60pOqnXcPf//Lrb62PLegtQn+xAMQjaweqqVd32EEKqBm5qa+CYPgHAcTJ3?=
 =?us-ascii?Q?I4brM/M5Z5mdaorbBAzAlqo2DJyZ5Rh5nYQ8KhfSIc2UnoH7UZU1ZUwNnvc4?=
 =?us-ascii?Q?XFByqZHkVIJR1rSNzK4nPHY1wA2WjXyoVWt86ljar0wYSGqHEx2Gra97yqLs?=
 =?us-ascii?Q?NxHNgRh5xaU/N8+pXPW0Zk3ehr7nK0rYEJs0sSxE5CfpHGAa7Ir89LzfG9Qh?=
 =?us-ascii?Q?cU0lwATKIGtDPFCFXxp9NFKuyuNAe1xq05IVO/ouiEhaHmsr9D+R+LpXV3F6?=
 =?us-ascii?Q?gwVnkyprgrMjReVtZ8SSu6DMYwy7r7NZB2yY2S+sxTdfm02SGTcXdTvJEeEV?=
 =?us-ascii?Q?MABmys9kwh0TFJ6YLtZznzIWTgJn8s4ElUGf8t2Xyol+F6GEy/J2v+XdFwqG?=
 =?us-ascii?Q?t+rQvfAU60pCx71kJqmRMjhH+Uw7Kb1hI2vkaDepc3gV32lciOit50xm4Az5?=
 =?us-ascii?Q?mbkoJlB5vJpJFcUWK1cF0OQHCxSnfu58J7hPFDn1bCkoqYTNu9bXdN9oBQX4?=
 =?us-ascii?Q?ur+PSiMf5rVIkOmSdjf0a3E/NTf4zXWWfgXo92wdyJjdt6WSTja7+APygHz/?=
 =?us-ascii?Q?aVkUURHf9VFEZdiHUtCP/lwiQ8FSvqpjR2o7zF5vnrWLLFgM9GgrD8JfJYmC?=
 =?us-ascii?Q?gfhDhs9rcwE4r/X4pKoMrT66GKZQuWUEbo5qVV46Sef+3jDIHVvW+8j8KLGr?=
 =?us-ascii?Q?4ITfUZqgb9OwGWuvZ+/ruB4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f797fa90-2a38-4264-3cef-08d9bede5742
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:20.9046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iVcR+B0cKuEM+I/SoZs7UNqwe98nI5IgifiLNpPKvjVzQVfD2niZsGcWNik1dycBo4+Csf0BEReA6QLGgsHiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: s9QQMAaUFUnQJkvkibLMVAKlY8hf9kre
X-Proofpoint-GUID: s9QQMAaUFUnQJkvkibLMVAKlY8hf9kre
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  8 +++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
 fs/xfs/libxfs/xfs_format.h     |  8 +++++---
 fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++-
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
 6 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4113622e9733..0ce58e4a9c44 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
@@ -74,7 +72,7 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_has_nrext64(mp), whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 453309fc85f2..e8d21d69b9ff 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -611,7 +611,7 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_EXTCNT_DATA_FORK) + 1;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9934c320bf01..eff86f6c4c99 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -873,9 +873,11 @@ enum xfs_dinode_fmt {
 /*
  * Max values for extlen, extnum, aextnum.
  */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define	MAXEXTLEN			((xfs_extlen_t)0x1fffff)	/* 21 bits */
+#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
+#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 860d32816909..34f360a38603 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -361,7 +361,8 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
+					whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ce690abe5dce..a3a3b54f9c55 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -746,7 +746,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4a8b77d425df..0cfc351648f9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
-static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+static inline xfs_extnum_t xfs_iext_max_nextents(bool has_big_extcnt,
+				int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		return has_big_extcnt ? XFS_MAX_EXTCNT_DATA_FORK
+			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+	case XFS_ATTR_FORK:
+		return has_big_extcnt ? XFS_MAX_EXTCNT_ATTR_FORK
+			: XFS_MAX_EXTCNT_ATTR_FORK_OLD;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
-- 
2.30.2

