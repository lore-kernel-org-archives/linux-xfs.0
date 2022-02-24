Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862BFC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiBXNDq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiBXNDp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE41C37B591
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:15 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYIqC000642;
        Thu, 24 Feb 2022 13:03:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=A8GEGA87qRlINVLmPtIGKYgqRY+qeLPATNMIoDHmpWU=;
 b=znzfnhg/8Hg+lkk1+EpVEZoHeywp69OxE5800/sBDzPByzNET8/QZyc0N7lAqFxOpWsz
 t+pV8oFc2CJJaCRmMOu6qUNvEOW8Qk1L33lxxeOGK9TtLt0Ud9KqyHI0IxEFpoTRu14L
 M9Gu//a72sxAAa50dJYASyS/quJIsaym/sxXXUvmEvmCA+LH3yhfZrJKOY7cr3DSg/8T
 4UWJpI+lPwXv4v01DWMJCb8NqDD8rVg90KyehUUyZTle6FFrmkQrKGr4pFJNNMhlAaLU
 05IR3XXlZsyh/KlLD3R2QLgen7m/hhA+1LUqJIxB13P79uwiK/tUzqTOCIH0Gtobetv2 DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6ey5rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0XPh120476;
        Thu, 24 Feb 2022 13:03:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3020.oracle.com with ESMTP id 3eb483k7ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNIMD9ytxlMpl9oeg14EG2NE1Z0QSRjKoMm7oV1ie1iGEjGoHqR2eX68a9yXWO87zKDTXlHO2HkrCHr85yViZP4CrwKbMih9m81pki9OaLPBeL53t2BFDPaNu2RVCVdPX89Q3/0WImV8m39LOlDuIoPtGid8HpZ+tEBBCCvUzAL0kdJm1Dj/dhop7TuXXBAD2o0ieLH52HTWbBrortyFsT0FJlVGGgbVt32V8GMdaIj+xgHRn85loeJGUYoP+gOlp1BQ9rr9fxTY0H4JCpwuUIlZo7mPv05vK7g3FCK03rpL0fmMZSD//tBR/RkZFNrlIECzjGCgZ7l99J6yLKHm5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8GEGA87qRlINVLmPtIGKYgqRY+qeLPATNMIoDHmpWU=;
 b=CqhDlcGi6Yw5MZnNroGPuOwC5uslYeKglBfIKTZmoa44VcobD+3HasokMRUUHjMfF8vaSA+myiAUIeq1mLD52ct966fUzVbA+jNoeYSIlwi1lNM5NLy2SN3l2rA1MZmbQinOhhL2MMJww6qiayPWehtt6iAAFAWmkZgFJOci9m1yd9zqVmvyv+Tj21WWMhB0Hvgq88FXAO6mLTjfdW6vIhz0SI2+pu52s7cvkASUaiIjQnfVyMDq05Xr8P0Kf2VVBGNO7MXsjhszPpwiBx+yMuoCMPyI0WuQTNr+y8XM8EGCs3eSJpocQS6A0dVY9ursPOPWJj5qIQEPSaPWeYzTxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8GEGA87qRlINVLmPtIGKYgqRY+qeLPATNMIoDHmpWU=;
 b=CwHHiwhaGJX4W8azNYIQAXKGsprITqBCCnhb1kYcwm9sbC6Fc86XKUo+QoFsHKSF2Klg57vum0vv3mFze7aMpw0C4K9ct3KfGJ3F5E0drUgpgyzUMkBU27CdQR8KmECDBiSfuX4hEMIoxSqy0BxIew6rZDUFjzdmmjyOaA2o2Ns=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:03:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 15/17] xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
Date:   Thu, 24 Feb 2022 18:32:09 +0530
Message-Id: <20220224130211.1346088-16-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: f801a41a-1c76-487f-2c3a-08d9f79601de
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4634A6C34B7C838192AA7E1EF63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHHcMmkpjQbUMGTbAxUFj60lRYvTfoxcwxEcnx0P+T5cPQ/oWdaW0QZxxi5DuLD3Ef5wCV0gudS2VZ4X+1aQBDt1NG3jrdlxUxGk2xAjEEg0LeNppJc6wPXCzQeEol83AVju7MR1kw30oMhnAcZFLa/MHE9ywbKb6dq2puxYLSj/dd3V8vj7ADIShKNI4rACMHumR1ybSr8ulyrSMWjbm4DTDXnDEgO/EsjteZWQLkLDYQeViZj1YJae+nAZREtwRZtAKdsdE3ZxFuYAeQ1Mkts5zmXPwblyK3XsB58kqOvcn13IbSfh7+mHCXkEc5pkLthdL7U4YJmaTrPR6i4sSYMZwTNrGN+P0mhrs7cbPbR8AuBVrUkOq3kXhP5id9tQSXeRsMTsee4DnL6iRkxkvXYwXdnDCaBqIEqXSMkkqqTME6EViLFVMdHWsPowb/eF0PFnMEQQMDDBsO/QfIiGfJiyhmbgVhD0ZijJB/4Qnk6QbYkFWMcwq3DXuf5KIu/UKazKT5yH4C+6lbzgWPbcd/1Sl6wE4dK6Qmbk40A+73v8nG5BN/VsVP/k3GAKPNV2fbweWTG6UWvMHEOUQ92WP6ZfG3wp8O75yETHpfvevSnnnSrI4I2njhURV0uizyDQ1heXsnBNL8tBaXf+Mb758MiixB3C9zwlxRLCXr3Pt1m6kWLFPpPzcaDd0JWyVMRMyCXtTMWZz3EmMlKhyVA83w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FSlN3Ddij1I5ODV7IRSZQpxL8eNYN53MbO/RAOArtbnSuQZHbaYeGkCJjGEf?=
 =?us-ascii?Q?9Z8pOoWYGaUoEKtpAymQsg94Vx/EP72dAQTqfKtMoPoajve5VIo+00MVg2T8?=
 =?us-ascii?Q?m5qyq9DDd5DlH4cw+yzC1aWdQzn5Zr2VDTfs5fxUxnVpKV/aZnfIgf2n2Vlb?=
 =?us-ascii?Q?ryjO0PSm7luPqeRwF6uS2RAMsYQzpNE9Lf6tJn7gVZpjV74ImY7VQj/JDbvf?=
 =?us-ascii?Q?/ZC4AH4ZvBEQ6fUCqIfflJ+rDVL4amXDRh5XQfyqww+od09JbcSbpO1GAhli?=
 =?us-ascii?Q?EMNlqXEeySXUWC1yDE6pazDF/jBLXKFgtUNIpnAxw0PK8csIESaSllDwIG/1?=
 =?us-ascii?Q?NURXbNosrt92vaH5gCv8v0ceW8ky9PefB2LImuuq8PyXctRT3TIkAOJb5ChB?=
 =?us-ascii?Q?BIj7rSXklkxoq30yJsdbEkgNo8tkCHxBNigQJQRjeSZwh31nRJot2M3H0nFj?=
 =?us-ascii?Q?O+qR7VIefhEMlboev/ZCadAT/rEZOfe5UpqUKMYgmDa3YG4VHlzdB1Fgyhtv?=
 =?us-ascii?Q?uuG5SvDq3DQ3EY6HClBY6akQyiAh7kgswkjpx/AkHqNZWyRlNhctSPp0lAEi?=
 =?us-ascii?Q?OSn5EJHls0UsWmYwpZj/b4v7s1+mwTlnvKY4JXazwRwFCw0K/q0VKjAwBDdg?=
 =?us-ascii?Q?6oTt/d5hGQGf2w6EVPOPYKtVK5Ce6uHqT0qs4LfbroQ9/z+J0B0r6GWJ47V3?=
 =?us-ascii?Q?jvtoJDdJH78iEqat0xslbU13ClrHxGR8Bt8JfsHL9JQ8vKEyjnWOMXdTnaUm?=
 =?us-ascii?Q?4h2HcXY2KdWlAoTtgT1In8yLibo5eJXDPOoKasMESxaBKb4Voo8NJAk1Mc1Q?=
 =?us-ascii?Q?idJdrA3kbVESjZbgAA/u85FBA1oP9lmzVFDJ7hUE13YyLg/2F+uEfbC/jgKB?=
 =?us-ascii?Q?4OlUfagOqtTa8nbm1YkaoQryxAYHHQEl89TCSAhNo8G2KgvQ8mXGAzMlYD5S?=
 =?us-ascii?Q?BvravGLO2GoyNRSqoBnBbyWS74Z2qeZV9fvOp2J+QMDXTc6IkY3Qjj9K4mTc?=
 =?us-ascii?Q?PD7u9KHDKY36DPdoTWAZbKIzRphLEJl0N39sve42ncoAwqgrRlcpwihFqFF1?=
 =?us-ascii?Q?Y/6yJ/v8lW5eRqErMm8oPWnr+OxI82DLg44WgClY1ZI4bY0V3sHF5SZ1YZOR?=
 =?us-ascii?Q?zdjhi1d+4nvvAlJJsy+laYMJuQcCXNbbOcAHR85sc/InIH+TRaeAiYVgSDCe?=
 =?us-ascii?Q?balYhpanfzyhD/DnXBEtszkyQDzSHH1O3rrFcVRayZOPd3z0uCg/dkBfw7v9?=
 =?us-ascii?Q?vUG1uHm27t8IOvqpOfTdZ7qFt14NUHX/8vYBYcYCpuwB20WnZWNOik8t8jfA?=
 =?us-ascii?Q?23ncXoTp4YTtxvrDdcbyfzlAcvjwssKLyccmMI2JFrJNA6XFl1/YsIwovHJm?=
 =?us-ascii?Q?6EhyjNKiPqXAVxgwaDHAlcfea7O11/0HwQaGEtDwTHyhfGJwbU3/2g1ogvR9?=
 =?us-ascii?Q?yNNmGUhgYHbTwKkLJSVKhM9nFL9wBXiNhvMYbDN7IP2ZNVcdxMBLQ5V/TDHn?=
 =?us-ascii?Q?fE2l6o6X7aIkrQaACEXq4/1PP8EPZfhhJu+0atRvQRdvqLp6mUms0RRi2fIU?=
 =?us-ascii?Q?drVeVXJ+ifeW/Z9vhR/+OKFNPSqANYduyyvmLHvpwnNjn0GJZDfg2+RqbiWq?=
 =?us-ascii?Q?taLbDJCOZiFCedFAc+IrnQQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f801a41a-1c76-487f-2c3a-08d9f79601de
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:10.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xPiF94KDQ/hljrr13y8BlZ0yk4MmLa9MTlZTrdC7dnzartcbYKS1+fc9gtOTzPyKXZ27zXqzYtQsXADs2Uluw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-GUID: ZBKLYPupUsnrVUUO8lltxF_A-puVRuBs
X-Proofpoint-ORIG-GUID: ZBKLYPupUsnrVUUO8lltxF_A-puVRuBs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes are made to enable userspace to obtain 64-bit extent
counters,
1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
   xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
   it is capable of receiving 64-bit extent counters.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
 fs/xfs/xfs_ioctl.c     |  3 +++
 fs/xfs/xfs_itable.c    | 30 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_itable.h    |  6 ++++--
 fs/xfs/xfs_iwalk.h     |  2 +-
 5 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2204d49d0c3a..31ccbff2f16c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -378,7 +378,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -387,8 +387,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -469,8 +470,19 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+/*
+ * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
+ * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
+ * xfs_bulkstat->bs_extents for returning data fork extent count and set
+ * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
+ * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
+ * XFS_MAX_EXTCNT_DATA_FORK_OLD.
+ */
+#define XFS_BULK_IREQ_NREXT64	(1 << 2)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2515fe8299e1..22947c5ffd34 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -813,6 +813,9 @@ xfs_bulk_ireq_setup(
 	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
 		return -ECANCELED;
 
+	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
+		breq->flags |= XFS_IBULK_NREXT64;
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c08c79d9e311..11e5245756f7 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -20,6 +20,7 @@
 #include "xfs_icache.h"
 #include "xfs_health.h"
 #include "xfs_trans.h"
+#include "xfs_errortag.h"
 
 /*
  * Bulk Stat
@@ -64,6 +65,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
+	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
 
 	if (xfs_internal_inum(mp, ino))
@@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
+
+	nextents = xfs_ifork_nextents(&ip->i_df);
+	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
+		xfs_extnum_t max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
+			max_nextents = 10;
+
+		if (nextents > max_nextents) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			error = -EOVERFLOW;
+			goto out;
+		}
+
+		buf->bs_extents = nextents;
+	} else {
+		buf->bs_extents64 = nextents;
+	}
+
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
@@ -256,6 +278,7 @@ xfs_bulkstat(
 		.breq		= breq,
 	};
 	struct xfs_trans	*tp;
+	unsigned int		iwalk_flags = 0;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -279,7 +302,10 @@ xfs_bulkstat(
 	if (error)
 		goto out;
 
-	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
+	if (breq->flags & XFS_IBULK_SAME_AG)
+		iwalk_flags |= XFS_IWALK_SAME_AG;
+
+	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
 	xfs_trans_cancel(tp);
 out:
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 7078d10c9b12..2cb5611c873e 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -13,11 +13,13 @@ struct xfs_ibulk {
 	xfs_ino_t		startino; /* start with this inode */
 	unsigned int		icount;   /* number of elements in ubuffer */
 	unsigned int		ocount;   /* number of records returned */
-	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
+	unsigned long long	flags;    /* see XFS_IBULK_FLAG_* */
 };
 
 /* Only iterate within the same AG as startino */
-#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
+#define XFS_IBULK_SAME_AG	(1ULL << 0)
+
+#define XFS_IBULK_NREXT64	(1ULL << 32)
 
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 37a795f03267..3a68766fd909 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -26,7 +26,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 		unsigned int inode_records, bool poll, void *data);
 
 /* Only iterate inodes within the same AG as @startino. */
-#define XFS_IWALK_SAME_AG	(0x1)
+#define XFS_IWALK_SAME_AG	(1 << 0)
 
 #define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
 
-- 
2.30.2

