Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E952C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 05:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244012AbiEYFhL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 01:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbiEYFhK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 01:37:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E8333A0C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 22:37:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P01wlF018271;
        Wed, 25 May 2022 05:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=e9oUSW1hSfOVzMG13JneSY7wUdU3yeDQGV/9zNpSavw=;
 b=i3pQD/aQpCJ/jps6KQm2nWMwoxV2NlIfRC1uFUvBe+csebD+gwEvwzBSO05rpYWV9ubH
 XU+VqIx0e74sj37y7K5rpLAydYpjpQ+u4XJwXsSfWXZWz2rIBL0A1rAERbOw1JjzEZt6
 qCQ4fu0KhavFDkpLXXzAIZRU9a00U06VdgFLIRh9IE2+vH24UwTnL09Nu5hy5mM6Kmds
 vBNQVNthzoH80RwsoiIYE1mUJhYkX9sm04LFPHCxDD7pzGg/As4dzJJ0ncUixdfniS6t
 bKZtZAwocVYSWMBA/6OwFqrb5e/iNeyKa1To4C0dNgX9GCWE9HCrlGZV0D5VgBQ90qBH fQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tas47s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:37:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24P5Zt1T025272;
        Wed, 25 May 2022 05:37:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93wydkaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:37:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fof6j/6GpR5V68/BOqumW287jA3MY3Wdbx45wedvhihjWC1CGUk4MJtbOCei5i7YAPvjeGpE83k0ArWpzobGi+WW8JtIR1uC3S5D4csKW+TZI09PzCMVZnHcgpyDZqRwV/Z4WPOQiNvjU/ZSIOzKJHsRxjANLFOHDd15MxODPGKNSsbAtPGiD86VLtqEoODgm6mv9byWh8ayu6zD79Ek76aAjkW03GsQTdNFWHbr3KTL+Jf/b4xGAXyuwMlowoNogef0L/lFEECUS7BvhAewgN/NgVw/iNjvchtqY05vcANXbFFWOv34Z8gU1UgAGRbFgiicz0rtsbbRYoMUG/mHHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9oUSW1hSfOVzMG13JneSY7wUdU3yeDQGV/9zNpSavw=;
 b=KF56pDrqtM1b7fyz5nGs+1xxJ7mA9soZZ6s4cRodNf9tVJDfvSpnR9wO0vDXHQpQSUYeYp3qw22hxomWRYWWPLkYrNfMmFGbSXAIY8uklDvBF6ViazlKqBl22FMZK/CSFUUL+4N9b51MAs7bPizppTWTBvkugJwPY1OIAWqCgPBIf1839efz0B/qH83GFjJBdxt81slFm0rWXIMHPZauGD/aN3bTSYJeYukAGeHF3JubclVMx1g2WbkA8BGC09B5uqsU2f/nKVVTayx2lMPVfEH/vHBrFCL5x+TvzR1vm1sIF+vd33/cel4P1DUulafaxIHJijGf53xsuTk/Noxj3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9oUSW1hSfOVzMG13JneSY7wUdU3yeDQGV/9zNpSavw=;
 b=vLOAi+EbLEpoiDtmFm7JRnggs+CUzQwABlXVWHFkPwH7Jo2IconUPBosV1Ep9Zb+XM8CBgGgr/4y2kWzg25fipqvKGH7NU2QXKRZB/bJkESNGe86xfF9VmXLGdLs3HxHHr+Y/bxH+0jaxbHgawkVfpjibVIC0DHQ/sAVr2lmlag=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 05:37:02 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 05:37:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, david@fromorbit.com,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5/5] xfs_repair: Add support for upgrading to large extent counters
Date:   Wed, 25 May 2022 11:06:30 +0530
Message-Id: <20220525053630.734938-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220525053630.734938-1-chandan.babu@oracle.com>
References: <20220525053630.734938-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0047.apcprd06.prod.outlook.com
 (2603:1096:404:2e::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3afa340-bee2-4b60-d877-08da3e109824
X-MS-TrafficTypeDiagnostic: BLAPR10MB4817:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4817EEDF2C34B43DC35CDC97F6D69@BLAPR10MB4817.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTddyC/7XCIUbDrnXfeNTXUgPJQABj/WqyDewOG84GQJdkOjhau8PIeiafMZSammhb1GLdj7jB0uMAT748cikece0cr8GHPqn3m5Xm6kiZK/N3eDFrZkPkZrrHLP6CdKPsKtC9LPV5vi/5J1ZbN6g04lPME75WCb9BcDMorKXQwHTgvYUJeIspn+uGL92XGv4bk1s6ernrBolZk29D/QQ17NZQIi3uk+uH2Hf4aTcVJ/EPd7jjo7tvSoH6LdfX1uGz9mrjwPb1oJyXnH2x0ExNaCCZkGuQliPB7MjT8P3lV7CiZNjmkdlwIUxmqhfnrxP4NkALnNDLIeWlSbMXEDvkbbu1PUi02Te9y6op/+6DGm1YzxtQym9FoRXU6DYfWF2ExoPa1LDwKyIBIvZDcGzKG/NBeHFopu/u8ZqoVhh8aHsNc8ZNy69MUBL7QOSFhFIjrSmbGLF8kFRljgsbSBDYUt03A4uUolv8bG8JjJqmxScJmCbKdSzdQhswVbOMPAyxypkGhWmr56Bef/IXZ84OZ55UR+y7owAHCtMN5FBMdUVPppHgu5ZOWtxNHHcIpy5WuvINxkhdWJFu0czxo6nuC0KOoldASPjRj1fpynZOdbO3ylsNAXcz8YzpB7I3/e9Vx716pJSkXwZ50wblEL5YFE+3Zav+gCqAWWK0pPovP2l1H64I22P/bf+anmYvPlNRuUKsgeZC8g3weXtrT0WA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66946007)(66556008)(6512007)(4326008)(8676002)(66476007)(83380400001)(8936002)(508600001)(6486002)(6506007)(1076003)(316002)(38100700002)(6666004)(52116002)(86362001)(6916009)(186003)(54906003)(36756003)(2906002)(26005)(38350700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rlM30xffBETvtSDtxc/+vx4o2yI95WG63FLdVYHJtVdPMFklQhs7ln0MeyMZ?=
 =?us-ascii?Q?NsMT/z8qL2OyplZXkLQ5wYp4ShQl4OQ2W8cuSO2G6nuyEP8LUQW3PQEdVIyv?=
 =?us-ascii?Q?K17Pw/X+U3B2gwDtyTBtAH2DPw05w6MbmQgBnoLXl0OYaN1xO+iZg7fQVtEY?=
 =?us-ascii?Q?78YbvoDMYDlb8mOn+ifOzR9n791XSGVXy57/soNg+M3gxzIHKRL4BW/J9Dhw?=
 =?us-ascii?Q?bU3K/9vKEqC8c/icxY01Pt0ZJEM2Enha/qOWLUr/ohvALfz9NB3N0tC8YYSf?=
 =?us-ascii?Q?djUTNMZjiljvEZQS3vJrJuX1DtnXFyMChRU4I/HPaNaaAtcu3aE8pIWT/JZH?=
 =?us-ascii?Q?4EfPZTWi10yTMKP7GNeXdl5DLpgqU79wOjsDYVGL0TL8RCmcgFpwLXgK9yq7?=
 =?us-ascii?Q?ypAPoTYSumVAvsBFGdZFAuBjMqmuE+GV1HQ9Z1paPLO8DI4mc5CmuOQ+OrtH?=
 =?us-ascii?Q?+dpRVR+hlddEi3xoXz0BZTlKnybpZfB6XwWJLsQfSWWuK+NHnp1AK1ijGASk?=
 =?us-ascii?Q?yMZSBJhZJ7II2vkkjtKITgFqqFo2zOtvrMZiigNJYyXdKmdkj0Jk4ecBFzO8?=
 =?us-ascii?Q?UjZsRnZTqhJL0JJtf6k9MVA8V6jnVp9RxALfUC7Fz23Cazd9qbNeAfpDpAkn?=
 =?us-ascii?Q?SF4h7iHNoAp+ZFOk7VhTyF8/cPWhC9OpZdsyYXxkYmv77AyGCDo566B0P8pn?=
 =?us-ascii?Q?AMud+bwvhcChd+LW0KN7/n8geHphNjp2hrph3ri+2PqPFf0mS9+bY1VBpIFC?=
 =?us-ascii?Q?3e/2EllAIWX8CaUhSpIYCsPNDfmeUoaJmqF5YeOd4TPgm6/++KrjtHzPci57?=
 =?us-ascii?Q?5xARNon/Z8Wmt6LrIwmHwfJ1gXUcaeTulxp7TDuGnk7aUZm1BRdJYuPm75Bd?=
 =?us-ascii?Q?h9IxmPBOzRe5WKRHbFBb/agt3w+2NBE1LbMZbcvoltem0Gb8cd5CnhIIq2m/?=
 =?us-ascii?Q?a3i/1i9Wsx3Y7eU2LYc870itFbSE0NFngyk1pRv58fFFsVcYWRuCPAtCWCSw?=
 =?us-ascii?Q?p+YGd1sSLgmpFHGaWRVPEQ1ARJUugM4e+M6z4SUnQ3uMMzo1JZvpXmKB/e7/?=
 =?us-ascii?Q?rRyQTJJ50eiun9jTMb24WyTcrTOd9Qx/oAwzn6IcusMPc5R3bVWpd22ryP1m?=
 =?us-ascii?Q?nhTe5V8jgXGC8QEQOR5K7AYrEKLwGpU1Q0kznjIccpV2AVH2D9O1qd/19PSl?=
 =?us-ascii?Q?sYR/7Kk01a+rTq4bGZiBkaDhAR0zf04Yr+bMHj/TF3F1jDk4YWP8ELY4uFna?=
 =?us-ascii?Q?C68p1wetcxXndvOHMWPVY+tA0sGY+r6sFx/ck3wH7pu30EuZFJPGaX2GGnPE?=
 =?us-ascii?Q?meNJdIzYlOoUZHYfdn3srmcFuEkMM3gYBzEieBUJUye3+xfkCl5B+ucqFUaU?=
 =?us-ascii?Q?PZ71SZf29ZgQLsC5d6nUqCyoMcKLZsm7K8OLwajKq/q4L+yHxNuB2uQGHdSC?=
 =?us-ascii?Q?nnj96eoEoY8fpFHzSAokzJsBA4+V6Fqq4i/NmC+ENWbBJuoI6EPDwnDNT4Jk?=
 =?us-ascii?Q?AA2fcCxPp6WX0eOnq3u7lQiIqgdw+8ViXADeGKQyCFvi0H9+YIa9lY/ythTI?=
 =?us-ascii?Q?fFWt2dqvB4kWt4SnTYdXw1R52eZUISP+kUWeJczAhMy37Vms1GCb83TeJvy0?=
 =?us-ascii?Q?s2XfQXrrqQyjkOlrlK3id13eOfv0e/k5q4caySMgGOFn3cMNSJc1+fGfGaTK?=
 =?us-ascii?Q?U0SnjGvo+UlXwNbuagsgIANfyQTZ6a52He34zxmCHmAN1FppmEwl5OC/D0vd?=
 =?us-ascii?Q?drVs8BIO8j/4DZ0GhVzE+7nywVy7suI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3afa340-bee2-4b60-d877-08da3e109824
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 05:37:02.1172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ileag4sE6t21KeTAjnj69tSj0VlL49/5/9hD7iu8pJ96ZjyubYAeMsyeAg/sYZYwK7ixDLc5MTf0juXGqeoALA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-25_01:2022-05-23,2022-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205250029
X-Proofpoint-GUID: Tjq3RgPHR994SKEkSQ3uPi84-_GUMI0j
X-Proofpoint-ORIG-GUID: Tjq3RgPHR994SKEkSQ3uPi84-_GUMI0j
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to xfs_repair to allow upgrading an existing
filesystem to support per-inode large extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_admin.8 |  7 +++++++
 repair/globals.c     |  1 +
 repair/globals.h     |  1 +
 repair/phase2.c      | 24 ++++++++++++++++++++++++
 repair/xfs_repair.c  | 11 +++++++++++
 5 files changed, 44 insertions(+)

diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index ad28e0f6..4794d677 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -149,6 +149,13 @@ Upgrade a filesystem to support larger timestamps up to the year 2486.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be mountable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B nrext64
+Upgrade a filesystem to support large per-inode extent counters. The maximum
+data fork extent count will be 2^48 - 1, while the maximum attribute fork
+extent count will be 2^32 - 1. The filesystem cannot be downgraded after this
+feature is enabled. Once enabled, the filesystem will not be mountable by
+older kernels.  This feature was added to Linux 5.19.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index f8d4f1e4..c4084985 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -51,6 +51,7 @@ int	lazy_count;		/* What to set if to if converting */
 bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
+bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 0f98bd2b..b65e4a2d 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -92,6 +92,7 @@ extern int	lazy_count;		/* What to set if to if converting */
 extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
+extern bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 4c315055..2c0b8a7e 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -181,6 +181,28 @@ set_bigtime(
 	return true;
 }
 
+static bool
+set_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Nrext64 only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_large_extent_counts(mp)) {
+		printf(_("Filesystem already supports nrext64.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding nrext64 to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -380,6 +402,8 @@ upgrade_filesystem(
 		dirty |= set_inobtcount(mp, &new_sb);
 	if (add_bigtime)
 		dirty |= set_bigtime(mp, &new_sb);
+	if (add_nrext64)
+		dirty |= set_nrext64(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index de8617ba..c4705cf2 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -67,6 +67,7 @@ enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
+	CONVERT_NREXT64,
 	C_MAX_OPTS,
 };
 
@@ -74,6 +75,7 @@ static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
+	[CONVERT_NREXT64]	= "nrext64",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -324,6 +326,15 @@ process_args(int argc, char **argv)
 		_("-c bigtime only supports upgrades\n"));
 					add_bigtime = true;
 					break;
+				case CONVERT_NREXT64:
+					if (!val)
+						do_abort(
+		_("-c nrext64 requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c nrext64 only supports upgrades\n"));
+					add_nrext64 = true;
+					break;
 				default:
 					unknown('c', val);
 					break;
-- 
2.35.1

