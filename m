Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B013CC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiAUFWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:22:14 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38284 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348537AbiAUFV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:28 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L042Ln017777;
        Fri, 21 Jan 2022 05:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=c1t//zkbRsRW1wAvgpKlRvKyBTw0TeasVuTk9iwXb/0=;
 b=RwnVt2C5+XpnJ3qVFjuks8YUH3zksyvrYOdUlf6ayE4Bb54kUG3A41cbDNKxGhYaIPJH
 6o322n/rk8K1U+vzTFMy8xiS1NfHLRjh5YZO+NTiAgdWPY2SBu+fmxGrHAfdvKjRcWS7
 WQ89MYqWrvb4jYHaZH77v538CA6fispOD2owy4xmtDwME/MkZBRvqQiNtB1cxB6ghzTu
 CgMM9VWeAP/8zSg4Oe/bvQUdURqU856Zo/qgZFKUpmn8g7aXF3WWzEHbw8UJMF49BWP2
 uM28nxzoW9s9R6ibDTNTMXwy/p5JDEmSVhJRuiUcECD/x1016MHJatyY2Ng23gCvZPe2 ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyc0d4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KhQN094543;
        Fri, 21 Jan 2022 05:21:24 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by userp3030.oracle.com with ESMTP id 3dqj0vbmg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W192O7/B41ojq+atSqKngXjW4jax4kbP4u761VGOukEG+YK8Hfa66ILZLkkFAo1u3XLWIEDekOD0VK314CPK0iQq4iWiW9VzeCZYQToTziYnunpyZEDxiKHnQo4J0OxhhA2uuKKH7KtOtATdnFQlCy5hySyCEnbV5Bvwi8VLAY9STbBNQltBua4jBZvfCInxy8eZ9g66N+NPzBvDFkJtVp23OQa6zFxCGxB2QmnLIcQozibTGEPcNZstmu3WN5Yp1NeJbDiMye3AHlO7+KEKTswvNx7NYVR+AqHOZ7S1DT/72kBo0rIRwyHlpp2ry0tdaisCpx6JhyYOJokfE1RqHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1t//zkbRsRW1wAvgpKlRvKyBTw0TeasVuTk9iwXb/0=;
 b=itYGD53Tswadssz7Pb0jVD4ojDhPZH1zBTkCM3VzeZOc+7MQtXVCAgTKCvQj8gWvnDkSgSvW074zDB2TVCrehiJexl7RQl8BPAwxLThdj+iHbmSB0utDvK5T0vqGK1/a3EdeQVG/VYl15Zy6+tbhRtoSbIyXsoUs7K47uoulSfek+XCnB2I3D2Px4iTzIUA+pFJXyhmW8XKA56G3WK8yKIhGW8pRzCzGre+58vFrkJkA/QI6qPcrY8zeObgNqI91ECgY+ixPsi+FO8fRfq2t1phHGtJwZgwoUvPUMfox3QEKP0Kzo5hTyDvrWLVLgcNRwMNavZMKtc/zKFv+H6Sjrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1t//zkbRsRW1wAvgpKlRvKyBTw0TeasVuTk9iwXb/0=;
 b=JuA7KDUGHtrbMdO7aojSsM2kdlEXHv+bI0ISCdrTmJTSpqZCqZxdKS/om7S3xhM+kgBerDpdw3dSKErtMUi9aeZiT4Cgg7Q5549oGjy8Wj1UPTxZyshC4zVPeXxvvhiUciImjj0xYSomq2mmvqlBswwidV+AXafqHNaKfGbAtlw=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:21 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 19/20] xfsprogs: Add support for upgrading to NREXT64 feature
Date:   Fri, 21 Jan 2022 10:50:18 +0530
Message-Id: <20220121052019.224605-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3904b78f-7c7f-4a2b-954d-08d9dc9ddc43
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5322C8626B7CE73A16EAB79FF65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPKpjvLzQxSQ+6WppZ4EX4TjPd4mSBPBJ9M/WCuyIrxHxNhNaIWPRbTmaFebTDgWBYU4gUdsuHK528cEo0JqqTtLDNFOOh3fDcyWcoXsSiK615oG/NT+M5NS3cthIi8G4z4A6WlRwPk5exH/d/iJ2H44zoapJclPqb2eI8E1grR4ibgcGx2QufmK8pc7TAjKvULSbpjoIf//xqE9dLHy7k1QgvxQy1mLPJ9gTG1emg3Xx4yzuypD4gm4ciUIPIrRvxQwPzMZpsOPLWSN5wzuVDa8NYGKifPyUp7mA9LuaWnYwFB9aX8dEcEpTwc0Tn/y+T69g2YOqUSzYewqHTvVEQVm8v/pYlORwLCs0GQ5fpotU273YXL0BkVqc9ffFSYBIJv9+/TofzzfL4J35va8grv58Lm4n9+oT1NS41wJPC8xDwjv9oa3F98n+DLxHyd6doUfQyBbvt5c5OZtA4+R0pn0tgHOrdWNi5yPszSA7VJC/+29UBLbeckLiprjIELsrn3vkPPL/EoVgPU5qBc7OjB+vk5xo1lde0HgDbYNlZ4jrjR2Hkh89nF2aeQ3E9FCQE5wWdXMKt0kUHV2qucZppezHB3bzm7Sd+jk+1CIRY/+PjeY2F2IMHT0m8hR/KEUag8vFGCtGyp1mNpyFC27HPNdfcgYiS0uZ4AHJup6m7MMTqoBW/iGsGercioAiN/+0Nf324BrlopwZgmWsmjkKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(6666004)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IGuVupvENPe6iovIvPtJ5Xooh99W5H/PBzRjpCEM+1SH/z05ZO22o4LjMoCF?=
 =?us-ascii?Q?JL0l0TiIVljtub7OfalpnvudAAuoVc7mewkfNfvYqQMXp6yMa1Hjv5RG1xpf?=
 =?us-ascii?Q?WPpeS3FsMgRAUs6XULebD9w7OuR3JXQ84q0OTfFORvJlEDfkmIwBiVHmAyue?=
 =?us-ascii?Q?YQJqFZRoyf5r10r+M4ylXJ28NHFO1dukpXYeR4XEOihG5IIdgqu7AHJLbIW/?=
 =?us-ascii?Q?7ec2qRYJ2WqFKcEOFO4pXd6ocU5NoXh152UJgGK9GiTQcy6pKE6Osi2KXiwZ?=
 =?us-ascii?Q?iDcZVCovfkkYur5jfMIYF/sQFmLYayw+1eiqTo1N+Ykl+oofho1qxiUtxU1x?=
 =?us-ascii?Q?WCj6na6qkONK+YZCE6g3q3YnXkBONTAMY7yGESYm2qpHTnUuT27dsrphnR2d?=
 =?us-ascii?Q?LU/islDaAUgMfJ8sOkuEFr0VN80VxEvOafzaGwkp2kItWg5gWVJX6xaDXIkT?=
 =?us-ascii?Q?Jk3ZGoaSOaPCVXc12mCNEoL3QnbJx2jmL4sY8FFPQBQAiZosbSunA4oi3Uaf?=
 =?us-ascii?Q?TPjABM5VroPxji9Bo39Xncc8YK6AQ2V6nCx6HWIyrfQKzuuN8E+l+W315fLe?=
 =?us-ascii?Q?9l8UcIrpzwzYYBz9/F12J/cvrlB4BLlZGaq+tHJnlSmfcGO3C43AooFJqxoy?=
 =?us-ascii?Q?47lRn9uilFTwX8vPEspb8E+bo/yRehN9/eKn4smCyAKJg0HEw2Uvow8Axoz2?=
 =?us-ascii?Q?tdUromtxD8i5A7dOED4eKfWRzJgf3hVuF9X7Bt8Ihno4QJ/FJpw0QAykHumA?=
 =?us-ascii?Q?IqVYC2WLQ9u3EaQutFzV1PQnWBuoyzNrPpuEfkhFFHSZHybNIk4pT6yiZio9?=
 =?us-ascii?Q?MLdj1b5coxggFGqbMlBGH1JVLSl6MqUnd9aOizX4VRIe2zD1eVZCh5ZmH1Bo?=
 =?us-ascii?Q?aQZNZR4ZyFfJ+fEvs6ItVoku2WR7quxIYL0hN0eXa9Xv26tolF6YQ0d0Elac?=
 =?us-ascii?Q?NRNsrhlL0iUrK7qG7EDQ+0QVmS1xR8QICeckHkXZagLHWO1uWGdTuZy8B0BJ?=
 =?us-ascii?Q?v2RV0x3+RoCtCIGrvGgNg7wR97mZ1Ok42e4GqvIz2UJcNdujg86W8dYhn0N9?=
 =?us-ascii?Q?0xtbLEfovxjFRBiowJr/FOzaHAUODHrbyiX5u60LT9/ksPYxtgJS9Ui24o/z?=
 =?us-ascii?Q?ZdNuCPaXf3cU1UbNkoSticJvWAJbE3OOCDigU+flo1uH6n5SBkzjChKLcL0v?=
 =?us-ascii?Q?Qbqqa0w7LxpmKwKPV5mSIa34uB0b0AQoV4QyTq8RtraQ4bSTUHYg9vRLcfpR?=
 =?us-ascii?Q?uF5yF+nL2tEVX7ZjdR7hGafX2zEI70wjWbPz7eCKr59O686KKNYvm8Lku7qF?=
 =?us-ascii?Q?yDcLE3VGFzf4kCgNZOf441+ujCoSPBsYZIt8mDwfVfVMvzARfk2l5Oh/9iw9?=
 =?us-ascii?Q?lYrH+c6FrmiUR6nbFAFcXaOQNuL85qfKkaFLgOJsgWDAo7ozb3ED1vHsqobo?=
 =?us-ascii?Q?3iB9Q7K6i+wjv6hYUmM99rwesdblkqtDNS2jj9wKqi7NXBrHNdl878ZaQgvS?=
 =?us-ascii?Q?xEUXc76jlkfmZXh78uXAa8Yn+1SW1Y34DG2xjj5CLOOKhjLmcGZawsTTChoF?=
 =?us-ascii?Q?Zlz7qSEyol11PdXj8kkkT/74O1ZeF1GHo0bjTZ8a4Fndw5lUJYxM2PQaGiu1?=
 =?us-ascii?Q?hONmhwvCR6C4dpfDrZ7B3bg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3904b78f-7c7f-4a2b-954d-08d9dc9ddc43
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:21.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3y02ICwe4P5txuPqnb11pCKl7kd8riSppY7hWzVaso5x//R2HhJ6wCGPl9By391tpqzw8+Qvx7wJ6CvHDSEZbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: OGsgW4U5-XpkWve7F3SsVZ3tfoBt9nFh
X-Proofpoint-GUID: OGsgW4U5-XpkWve7F3SsVZ3tfoBt9nFh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to xfs_repair to allow upgrading an existing
filesystem to support per-inode large extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_admin.8 |  7 +++++++
 repair/globals.c     |  1 +
 repair/globals.h     |  1 +
 repair/phase2.c      | 24 ++++++++++++++++++++++++
 repair/xfs_repair.c  | 11 +++++++++++
 5 files changed, 44 insertions(+)

diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index ad28e0f6..d64ed45b 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -149,6 +149,13 @@ Upgrade a filesystem to support larger timestamps up to the year 2486.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be mountable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B nrext64
+Upgrade a filesystem to support large per-inode extent counters. Maximum data
+fork extent count will be 2^48 while the maximum attribute fork extent count
+will be 2^32. The filesystem cannot be downgraded after this feature is
+enabled. Once enabled, the filesystem will not be mountable by older kernels.
+This feature was added to Linux 5.18.
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
index 4c315055..979e281d 100644
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
+	if (xfs_has_nrext64(mp)) {
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
2.30.2

