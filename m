Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02E8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhLNIuP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:15 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64750 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:14 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7mv79005512;
        Tue, 14 Dec 2021 08:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rvqtq/BubM4UAb0UrR8rZlHQwyO3mv/t9GjfEvJwWIg=;
 b=x2isCS+9IxGGRz/Vs5+R3dtxKx1JnqC8NJkg9h/xSLZYv/1dyEWQb3isdBvyhZFBedJk
 SNqBdUiAVjsg6WGnPqZVyoO8Zf6GHxLUzmcjx8BiMG9TyH/Oqk7yfyyofNpOARgIrPAS
 NcAuHvAhlRskYKdopsWNQSu1amoWgvZn3aNnnVl2oPJMBuV57x1qMNDEls50o0RXK62r
 UnOzS5ZN0mQTbDSunuVVLcuEv7OHfyDMxlZLq/JPEYVl7O+/6anm1l63DQtMPs9diKYm
 +BxoUnUQQea46va3Etkwyb+9+3AVH9ok0/yz5uVwGLxVEKGvqnPfgqxUCBMru1EB629+ tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2sxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8foqG104549;
        Tue, 14 Dec 2021 08:50:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 3cvj1djtdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EY6AOuN4ECWkbPl9mYW9qGaWMPEZncvDkcVrODbYm3ehl/WQkQC4kxfB91iO2bXkM+JTlmWigHhFZXq1Hy16cssxfMXgXO+tHJUIf0cL0SEJQDbE5eADFW9oqlvvVQmlnjT4r3DthUUFaGJgP6s+oN8M3xjjZBtndoSIbTGsULlNCr9/U2ArORLzK2CJGpIqtQfHFW0DpOjhDcH7WK04Vef7IXPY+esenbcgChAOmnpyhIgjTr/YrNB+9BrMWJ0ECwWZFI6d8C5UXjkOllsRdSKmdlLb2zaHfIkR8rRSbewn2z7CXiLvs62ihDFz7I2lSkRNHUeAVzRfFCS2rt2kqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvqtq/BubM4UAb0UrR8rZlHQwyO3mv/t9GjfEvJwWIg=;
 b=IJi6wlenuNWN23Cz2zWZ2EHtq0YPlIIB7xXZbTDB3NcHVznH9FDFaatlkutsaMkA4glf3MD3jxaEja1an3+ndDjDyNaXvn5I5KEXGeK1ukfTE/HY9KBhK/TLCccrOqz3tIu1n3sVTahwNAN2Z4lCCs2Q1IK0cUAkC3z4DadOzPgzbl0NxRoZKb+AlZEmdDSdtXuYhjmt3yBlmDMo6yyZ3VnR2kCXB2fYpoCBi4NyFRYG5jKHc9Bo6X8UdEGzLRXxkrsQkWN0X/mxohULf4d7tt3faO8qFTJkgkkMTNyOMnu2+Ac/X0XQbbbGmD3Pn7Mudks3xKY48KR0/p4J0Pi1WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvqtq/BubM4UAb0UrR8rZlHQwyO3mv/t9GjfEvJwWIg=;
 b=ha6H6J0XYnrkRWkJE/pLqn7U9nOggepub8G6NnsFEduLl5mmBzHe9vIP1htWopRyVi8PkWBBMh+jgo4zAHF7HPgeafzEBNxhFSxdj5lwEQbeTikguR/bPUYHg3DQyNjV2sQsk+CQFMyKiztvjY7d6kNap8PHa39joDyysThBKKQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:50:09 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 15/20] xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
Date:   Tue, 14 Dec 2021 14:18:06 +0530
Message-Id: <20211214084811.764481-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f1d15d5-26c7-450e-2418-08d9bedebbad
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB26564B4B4FD3150BB94DF683F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:250;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCs8BDW435Nn4whJuxrZE7y/OMgAxYuOe29nb6hpF3g4v3kOanyM2WUkxjsG7sQsfyhyZK7XCKfpltSugy6GBxqVzlPSVggjFoLVYW15eVRk5uzP5AXSfIJ+oXK20rb1+OVFpYkCdPhV0xYiZmPadRYuzyiyPUF5DqjNnGvS1VIwSxPEbSyh3TJEArQ5xbI1ix+pqguWUoNPWTStwqOl1wKYX7BLvxtjtYGnjdySvrF/GtZKO826sgM/q/m4OOOkkDkp5f48055xPukhHsmBe3Cbq4lH8TFFFKlVSaXNtiELXGHaTF8Me7Ms9wW9kaW4VsHV6wlXyGE+KEjItEmPm/ikMGGvlnzhoUNSENgN2XKkrwhZpuwUuC6c/WX4mozmEp9Vy5gJx/xjFR3TAOqeqr8UfRwQbL8I8pqsr4o7ZrLavkSAYs5aZBESv/+OOXm0B54Ltgp5uTJfQ39f9yJFiX84uH19UNE7UtKRF8KzHWU4Tj/F8+8YFMULIoZtIPBjzBBk6i+EnQvSR5DHAHPTcfHSkUj9bj4e4s+RevZMAunpixpHzLncKGeiECATPszPjvfnomm5BwdigsmL2VPFn+/Mluoi+4WD40c8VhOo4/Nrg4deu/9MvVpI1uiQeQcJH+v9pZPCOgn/x4n4YBGdadUMuelqXTXi24rh6cLCbbfOYzSYAvBULaLbunli+jjD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YKL1Fo2EKK3ommbiko0R7qXTXn8KbBCs6+7i3bfzk/HvlShuygQC6qAjXA1s?=
 =?us-ascii?Q?P4Nuhm5RG53vHhe6Mz6gUGfLlyRQjTrJyUHseeKw5hAvWTdBtUUcTqAi/kTg?=
 =?us-ascii?Q?a/ugfxBsmJyt6lUN7L91VFz9mjjaRo3jiIQ0KtjpY5tlU3oQY08UYtULIFtd?=
 =?us-ascii?Q?qBFaC1uzrYil38CQFQsHH5DnjwPIi8Bvu/oc3oDcwutJC1ETTXOeCif2WHwC?=
 =?us-ascii?Q?kQSutgHvMWWJeitFl4bGjytXHKJQwp/IJg/ah7bXGe5zYrLSCO3OG6E1QlUp?=
 =?us-ascii?Q?uAV1D/LDw8HT56SaSNboDNhSo0Q9AMh4GlWQoccypmbkXaWZZ5PYkAPKrGcX?=
 =?us-ascii?Q?MUrFXHv5xSKaGFqVHR49ms9hJmRmIhMmX6Q09PwRcz7lQD4lkhW2MNd5z6bP?=
 =?us-ascii?Q?3cqPSxRs4aawSr3BFWw8HwuW+OYjHJZTFpn3TvFzgEhvjzfeKMMeOIBr+cVz?=
 =?us-ascii?Q?N1HLlQ0cX1f771ZC8XCRQVr/Z14YMY7MxUNX5dP638Y+4Ywypp65mhvBKg1v?=
 =?us-ascii?Q?8gHyWF2HelJkKfWh5Q60/GT/KvI8sALnXESR1uKHhoDDmZyVzmBdXPX2+fyv?=
 =?us-ascii?Q?FUn56ldjAJrDYmToxWSY/vXietyMoFErZl4tVX+zUFMNxwNcbXeYbtNsE92p?=
 =?us-ascii?Q?pH8rnbmPJMp92PNRppswc/hcWioLMyh3qF/58e3noDlBJ2joHAxszP1rckpX?=
 =?us-ascii?Q?yLPJKlNCEto7Kx+0BmN21I5fPsORdHplq9FRY1W+3gAXyw7Kj5LQTifjMedQ?=
 =?us-ascii?Q?Z6UDa7FyIR2juhkLuM07F+wXh1ybiyW1ns9waCld8ySZUM+mrXul/nuC0H96?=
 =?us-ascii?Q?6lizclY0tHrHfREXSvk+cD4SMtrG+wshJAjPxkvZO/GdDQaSARv56mYKuXBc?=
 =?us-ascii?Q?A2iEnUT5yxyJUwu/kZT1VKFe+bZYErI56YRWMu8OyYArbus1Vj/i7V1cRg3f?=
 =?us-ascii?Q?VLsqURB0WYWXxhB/cBjM2JRloAam625+mmhNc9xex/Wtx0eNmJDj/OEiWfIz?=
 =?us-ascii?Q?BgQlsLIqvZ3qJReVlMFTW6BqApaeW39L5oX1An4Xg6Ad/dllIO6DNNZ9gfKk?=
 =?us-ascii?Q?zMjfQzeQYoHpjUOrIHDeYzBOsd5Hgp+Sq7EzoEd33oA0YbDVC2xv9nY99+ol?=
 =?us-ascii?Q?RVZ1jvIeQj6B0x72QrdLswGhGJjqJxvEtTV4U8OtnEkHkXiSrboXqkkZogje?=
 =?us-ascii?Q?Syp2hhMOXMZKDsfcYx1FSWK4kQKTclHSXEjivAI1TvJ9nuBT0u1yYgqBm2NO?=
 =?us-ascii?Q?95QU50bNSVrevWAZzhqeSJMSeA9zk5ihLWENU60X8qLCJOeKgMfaKnjKLWvs?=
 =?us-ascii?Q?xCAw2TwOWGrIJ0JTD6HVy2cnQlYl6EEh5tTuTShTnCS+xTxylPkwHnEB+RJF?=
 =?us-ascii?Q?JqzQCkNgTFFqRb3XY5tfyZNMK6VM7uo506X+0QbyzGtTYOsDtv5QNWSn66Au?=
 =?us-ascii?Q?VC0WpOLuG0BgFxvwc1UyOPDmd6mbFPIQ+Bd8KOUJx6u2PC5hGGzrivq6gaiS?=
 =?us-ascii?Q?F2uXKikuMzqjrIEFSm0IebBKyLAY2i+EtiHmtqKyGAWmK9C33Kd4bTqslB3V?=
 =?us-ascii?Q?2dXSX1Kh8pFKOceMdFUcKY9JpSlLWIkKzjbCQpQLqEFUe3MY6EFfXLNCE2Wn?=
 =?us-ascii?Q?xHuLb7afOxmEOhFqYRsbecE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1d15d5-26c7-450e-2418-08d9bedebbad
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:09.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8JqPkZdiEYuAotF79gZMCJdGVvW7IxV5EL6IA2DnWX/tT04/CnPeDSh07NaZKS/dqBY2D8uWZc0fE2A1cMQsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: -e-sKBRCpUsfTIVscZtM0zJcsFWNV5t0
X-Proofpoint-GUID: -e-sKBRCpUsfTIVscZtM0zJcsFWNV5t0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to enable reporting 64-bit extent counters
to its users. In order to do so, bulkstat ioctl is now invoked with the newly
introduced XFS_BULK_IREQ_NREXT64 flag if the underlying filesystem's geometry
supports 64-bit extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fsr/xfs_fsr.c      |  4 ++--
 io/bulkstat.c      |  1 +
 libfrog/bulkstat.c | 29 +++++++++++++++++++++++++++--
 libxfs/xfs_fs.h    | 12 ++++++++----
 4 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 6cf8bfb7..ba02506d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -590,7 +590,7 @@ cmp(const void *s1, const void *s2)
 		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
 		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
 
-	return (bs2->bs_extents - bs1->bs_extents);
+	return (bs2->bs_extents64 - bs1->bs_extents64);
 }
 
 /*
@@ -655,7 +655,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
 			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
-			     (p->bs_extents < 2))
+			     (p->bs_extents64 < 2))
 				continue;
 
 			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 201470b2..0c9a2b02 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -57,6 +57,7 @@ dump_bulkstat(
 	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
 	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
 	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
+	printf("\tbs_extents64 = %"PRIu64"\n", bstat->bs_extents64);
 };
 
 static void
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea0..0a90947f 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -56,6 +56,9 @@ xfrog_bulkstat_single5(
 	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
 		return -EINVAL;
 
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		flags |= XFS_BULK_IREQ_NREXT64;
+
 	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
 	if (ret)
 		return ret;
@@ -73,6 +76,12 @@ xfrog_bulkstat_single5(
 	}
 
 	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		bulkstat->bs_extents64 = bulkstat->bs_extents;
+		bulkstat->bs_extents = 0;
+	}
+
 free:
 	free(req);
 	return ret;
@@ -129,6 +138,7 @@ xfrog_bulkstat_single(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -259,10 +269,23 @@ xfrog_bulkstat5(
 	struct xfs_bulkstat_req	*req)
 {
 	int			ret;
+	int			i;
+
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		req->hdr.flags |= XFS_BULK_IREQ_NREXT64;
 
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret)
 		return -errno;
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		for (i = 0; i < req->hdr.ocount; i++) {
+			req->bulkstat[i].bs_extents64 =
+				req->bulkstat[i].bs_extents;
+			req->bulkstat[i].bs_extents = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -316,6 +339,7 @@ xfrog_bulkstat(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -342,6 +366,7 @@ xfrog_bulkstat_v5_to_v1(
 	const struct xfs_bulkstat	*bs5)
 {
 	if (bs5->bs_aextents > UINT16_MAX ||
+	    bs5->bs_extents64 > INT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
 	    time_too_big(bs5->bs_atime) ||
@@ -366,7 +391,7 @@ xfrog_bulkstat_v5_to_v1(
 	bs1->bs_blocks = bs5->bs_blocks;
 	bs1->bs_xflags = bs5->bs_xflags;
 	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
-	bs1->bs_extents = bs5->bs_extents;
+	bs1->bs_extents = bs5->bs_extents64;
 	bs1->bs_gen = bs5->bs_gen;
 	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bs5->bs_forkoff;
@@ -407,7 +432,6 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_blocks = bs1->bs_blocks;
 	bs5->bs_xflags = bs1->bs_xflags;
 	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
-	bs5->bs_extents = bs1->bs_extents;
 	bs5->bs_gen = bs1->bs_gen;
 	bs5->bs_projectid = bstat_get_projid(bs1);
 	bs5->bs_forkoff = bs1->bs_forkoff;
@@ -415,6 +439,7 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_checked = bs1->bs_checked;
 	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
 	bs5->bs_aextents = bs1->bs_aextents;
+	bs5->bs_extents64 = bs1->bs_extents;
 }
 
 /* Allocate a bulkstat request.  Returns zero or a negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 7260b140..6a9e51ac 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -391,7 +391,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -400,8 +400,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -482,8 +483,11 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+#define XFS_BULK_IREQ_NREXT64	(1 << 3)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
-- 
2.30.2

