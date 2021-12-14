Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6CEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhLNIuU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:20 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5610 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:19 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7MkIZ004563;
        Tue, 14 Dec 2021 08:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qndi7dXMJWJqCgoqZtNdon9FGoavpbBEWDxE3I/qSo0=;
 b=1J+aNwW82BSQBipxl0K3FIA4nWLyz+d2kb2T80M5cimXSOkMweczw70BrC4oEV7qMcYb
 /2N54rbMsGNyzIpAGYR0YPzNzjL7bedvEOfZ29KDQDvY7R91XlOLCAsB+EsUPDGgSxDI
 qoSvuePJ2N7ThDb5Zx3r8NOaxvbSheoeoUrTQFe0xW4H4H4miB18A9cVU2sctnfAq4Xj
 Bxj7DQWpev9oigqSkPBmBU2O3bPdwNPgzAaH4KbZVQMZ+oRkLCm5xoiXG9pG3oUHRLm9
 y61uk0a+ffyLz7SLYqnIZd/EYY5lE6N1Q88bk70g1O/pD5brRV/cj6ezg6XodPHbXlZl zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mru63d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fYIe156506;
        Tue, 14 Dec 2021 08:50:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3cvh3wy879-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXfJiA4iTgIc7ItkcxyX1KdYfGkoIgze6LqpgrQF2nvcFul42ZVIYEQ7OTX9gpinLYr+vqGirnUf1pgUEwcKG9xc3at54l8vIL93Ih35ExYc8yiyc/T/C54sNVmz8IHHSwU4iDg2p/ts67eooMAndbnxHAFf34rw2N/mAPzt8jlN6/ezqj8jTaTtfs5WDtBkqSEiuuwiTPC0R+PMBRvM97RYw7aevFgRWL71ArwppbqlCnT2rGBCWR4YxUwosCG+oxqRNnwkIMmz6wX3SM/TOMdGpqYaaJMz4F6Jxkna9EpZUpnn8+YkEClbPEFOPtEFMInkP3BGv42XMQNH+BgANA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qndi7dXMJWJqCgoqZtNdon9FGoavpbBEWDxE3I/qSo0=;
 b=ZqL/evwoqXStytt1s1qM1D/Bwl8hkanEKtzMDBJX4j6fwJfUgcvlPMc0WBlzaFFpvUMzT1e/DXeIe9WxszxOnQo/DznYulTzg9xLF1zeYk2tNOpKkgdsDPKLeqTX+LUGIjaea4lxmO3UdWOvD/C7RHXKZ7XbGzON+u8CEFdhS1lK5ko2dlgqJ+0cAkGHyqjfyIlISQ7aBgMtbgN21REvw731kB9xgcwPWBce16fGRaW4q4zVYhOYjWM7Fo/9ThOIcDYZBm/ga0qk+p5jv5bu5c6EBum7H6SEs61utTnY31cGbIicuGgswtXfbySQ2qXoeIsR0EbHd6oWBgKVNQb+lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qndi7dXMJWJqCgoqZtNdon9FGoavpbBEWDxE3I/qSo0=;
 b=PN+wKDnXbAaeme8YLTLDn0Ra6iUQ2Xg6CM2D0D1lH6h9yUdaj1Ze5+ygxhpB+70G0PNH0bEbyEVw8ZaoHnByMrswu2ksfea2ZbGXrEt6cdu2xn0bevakvw9nJpasXadF02X4FYhg5/GiP0iWVkorkxwHWBo0FYEXdkiQVqQiA9o=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:50:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 17/20] xfsprogs: xfs_info: Report NREXT64 feature status
Date:   Tue, 14 Dec 2021 14:18:08 +0530
Message-Id: <20211214084811.764481-18-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d43a11f3-ccc5-4a4b-7c59-08d9bedebe88
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656030D7387946FC65112F3F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YORbi3LWduslgfPAgCD2fusirCtf0YmggLnxOhdYC02dFqu7yn/tI+odaHbNmxCHX2O00JwnNB0z/ArpZB2VXd6SS36VrU63m+gjh5KYF8gWftqULs1Zgyl96VfwHNMVYaTCoxr0e6Ie99GaNAohTeTN4u/aNjFvB1CLw2nDUBosq0hJp0RpwZRL3BXWKsYz7ArS3gSzms5A4U64pAvjklldxQAi0qNlhvDu7e255rwXXZFTwjg7GJq+xSfw0LNVVNjwtZRHHjq8JggjmnLCCFrqtl7rClMg3a8HjcOS5MqerUDPqUDVjeY4UQhq+IK9AdMZr2AGx29ZjSQ/I1ROEl7pduQ0hGMzqY4EKaOHoBSve7sYmCItU/VVh+nAEhrb7mEh4daFQDwqemmnbBT/Vt3X4/WLEL8gqUQu6nsnkgW+Ee/M1B5HjPz6rGgii/uJxyPYA0KbZklfhhmCgroJnogHfEauSoC/4sPgdWbVftLjoF01Sb+GTNitdUN73aEGolcGjtQz8oakfmCXA6Q7CPw/dtB6m7Mz2UHIfWXygpspTB5mU1WN70SlNBzg6j0aJbQKrFwlH/2/KX8IgW0D/WVA8QA2fOgsLYKQO1RjuaU0BLnj1IiIWnwoosFm6laeXtr9wIElG/tssiju59ML3S8ZWBASDsIn5ytp68f+HlV1eOgfwk2bO8CdB1HAgfpd3kpTOd07D3LyGgYTgmx4Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ou4l7PEmp9q9pxokwuh4VAc5KuLnRfqIksNg83hX8xhY1A82+r8y8bVsDq18?=
 =?us-ascii?Q?F8nhvq/3unKKWQuy6aaI8IswHpg7AqF33JwHYGRB437ecEudnQJX8AZI1VDb?=
 =?us-ascii?Q?VV0GQZdIhb1+WtwXp7T8EIYg/6zQ1nISBCaQ5o1TVN6C1VXF0W3gCqz+SNKY?=
 =?us-ascii?Q?4M1WAz7e5Vl7l7GvTKO0ti66J+1RTS/omhbqRkNZ+nCy+jOULFIowE71VoHO?=
 =?us-ascii?Q?6oKogTppRyvUMpJcg9i03LhqKs8fGx8aBTGbXlSF5oRTWWfBY4pu0bkS5O7j?=
 =?us-ascii?Q?Abk4yLXNsOM/C6G9fdcyNT0jn1KO8ZdJTGBZO9bYDegdz/rty87dYGh7e+Dg?=
 =?us-ascii?Q?5QavCQTvQKWiOceVbfYzlxxNeXgKEg+7VSEPAAkkNBXBgc/SmOBrdk6/Pc0j?=
 =?us-ascii?Q?gAJZYwIP7lvptyi9ObNUbOhBW4FrbOH+S+j3YOp1iWIpf/fNerQIugImUnWj?=
 =?us-ascii?Q?3KDVeV5WtuhZ/KdZEDvrJoupiEWk4akBeRgm4Pk2rGwK/V7ELtEOoR/msqXT?=
 =?us-ascii?Q?uJBaNi8/E05EA4oPU7QlQY12BIoo8rlU2SlPGLZDrkYcytAxcFBaQgq54+V0?=
 =?us-ascii?Q?86TCXvxx/JfUJLCwFKBnpDu2RSwkfxOmyxhMwlOcxgy5FZxnW5OrOPBSD854?=
 =?us-ascii?Q?p9stWMAOLQjPgrGH/06gJ4hze31ENN239iPRTMUtKoqHcBbXFxKkiR9f1K8m?=
 =?us-ascii?Q?BxiTU5mdujQ8XjE+4cqqZNqY4+4SUxsMULyPF5HwA+zkIv6+2R2I2SBhabYy?=
 =?us-ascii?Q?uZFEGcaQJ/bJscaFCWOQVeZEnDjC3YcZg9MWtbcTWFTrECiCxRh3ugEXUY71?=
 =?us-ascii?Q?86KU3hxxwn62IGDhksOmr0BAet+I+6Vs/0X801uY3Wr4graGazmCVKev/X0J?=
 =?us-ascii?Q?CpkGBkTOCMtYU29QtkMKPfpLdTAEGSG8dhRJ0xDQKJAVGeR1zV0HPjQPTe/m?=
 =?us-ascii?Q?Kg87E63lT66WM3Eb3ll1S8YnJldDhzLhRrjW0n+8fpV7z0tatvxGXpeitd6D?=
 =?us-ascii?Q?dKyjGg3i4V72+chdWNrwpKhejaPaDQf/OfoOkPjv/lcTDdujfZNR1ZPOlWTo?=
 =?us-ascii?Q?UzI+3tAT3WWSDYd4orVHv7qZaPcz8PkufhYiMHifexJxB2OLs8ad6X2jP44U?=
 =?us-ascii?Q?H0yBcZpOwXQx7pqUsdGi0pRuH5aKUyjyCwcDG4URcAtgY3Ap7+tURMMgiMcG?=
 =?us-ascii?Q?wrJQo/RhtjoBSwxqrhneoH2vZ/o4jXkzXOMFQXq+MCo51SFAFhqbCTOcT5n2?=
 =?us-ascii?Q?GV+lQoOPUG0rrtGEXIbEbLZTZwAeSbUhkUu6tpzSqDiQXEoCOsNhtD1dnYqm?=
 =?us-ascii?Q?w73GXXMYwo0aktrBZqQzY85IEvVYy5i/mByGijvVufh1vC4WHIfdEfjG/mL0?=
 =?us-ascii?Q?ZPJ4cwX/08gXYGI0KUO6rtAuvb0gRJcM76fRu2TyLs6LYXOXD9vRJn4GL2J7?=
 =?us-ascii?Q?mxy0l3JCv2+481aHWrcK99SMOWRLriOoSnydrKCscXGmwEjKbLrHlYpA+0Zj?=
 =?us-ascii?Q?voq+bJkX0ZpKq2oxxfw1GQ0N4tSt1lWu7y6lLv2tNzyM68WRLtX/3NIrOLJQ?=
 =?us-ascii?Q?sEmH3elPlM1GAGmRab62bm2t83OqN6+bBhN9PKHHM7EeTkVyn+7k7GgQXkXn?=
 =?us-ascii?Q?GEiaz3XVpc0L+HRRKNtp/NY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43a11f3-ccc5-4a4b-7c59-08d9bedebe88
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:14.1862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMkxcCVKsUQyDrJuLECb7QGDRy+AHAd3SLKn/Bu5poXWUazcGo0pAniMdh8IG1CN5w2cygQj5lWc4GibrG+Weg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: BnIbrPNA267tjwVQ2327oo3cLkbTXBl0
X-Proofpoint-GUID: BnIbrPNA267tjwVQ2327oo3cLkbTXBl0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to obtain information about the
availability of NREXT64 feature in the underlying filesystem.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libfrog/fsgeom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 4f1a1842..3e7f0797 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -30,6 +30,7 @@ xfs_report_geom(
 	int			reflink_enabled;
 	int			bigtime_enabled;
 	int			inobtcount;
+	int			nrext64;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -47,12 +48,13 @@ xfs_report_geom(
 	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
+	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -62,7 +64,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled, bigtime_enabled, inobtcount,
+		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
-- 
2.30.2

