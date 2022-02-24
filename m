Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F566C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiBXNFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiBXNFN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87897230E67
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:43 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYSTI023288;
        Thu, 24 Feb 2022 13:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=T9T87tdvFZJcuEfouQcR08/24olASokUUX8wvDh3E8vvfTm8yUiMyLeoQ4wNGSo4jhU7
 /vH/zAdITnWXdRhQz8F1lMVfOvKEor3I6Xoi2cNKqyPe88CCDuQ9noZf5CxhbAEHNpXa
 9K3XSFx3dJn6f13O4ieV0k9hw+cEYxq3sEkMXDBiki+3LDqs+z8y3psa0JOVhsQUXb7z
 bvhopiqTOeKkcqJCIQaSwaysfMjv05AELH+qbgyvfeq2BaXRbgHep5AK3ZYjry6tP6Nj
 rt7vCZFYi+MiLci/eLZXhDfpWHCBB4cNxQHZyTLPRexOL3fC+5Ib0uUkOYh4AR7VtnFY LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0XpF120490;
        Thu, 24 Feb 2022 13:04:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 3eb483k8pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9x6HJb2FxOYzkDCjW6NhkKvi0L1VDl9rIGmev3HRgGdUEGZoqLF+OJRAOiMKXrj1E2oMYjm+bVmm1NyDrI0wOn18VkDPD90hdbRjLVDneCQtGEk/7lpzi/JHY8ADgvqGFnzrs/tAJ/BVys7pyoR98C7RjeWyjsO0VvGCIXIv/PZHr70oMsJUc582zR5+psZRxJ+yTLs+szfibeH4fN/Z85hIk9JDS0CHQ66DpDA0fpOmHVk4JjvUtLu28uHMwdWzGOZ72qOAKjvXsKZrn7TFtuGcix3RfPeVy7skqZSe29QIjveToFBthqi1PiScSefYFnm08XPScdUdanGtCwPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=YTYxNa7GxA//fP87MJlDGP7Q4hnoQl5pqE8REkM9JQheJ3bHFirenLt0vQRM1TwbcO3mTGpEjaP2t9Vp0q1vUlzi0YRDAC+qOJZ7yy1PDstaS/XpBEHofYGRQfm2JTdMCw7wvgq8Rxf8KQqxvwXSOrNEQPaV1ZLyfymNoOVJMJijK1T/5z7dRrnOm1m5UYM+vVTRpvMjneahtVOrKC7jjiYfo6CSD6H/mDpw6/i8n7PcJCkTuZhTdRKEs5gImIMozcb+7qnS1AiyhdGUDTa6TgtEO1naerMlPd+cQSTIrxpqG1RbPJcXLmLq6qw753rvKYYvC0/C8KyqOtjlstLlKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brLYlywMMMOyz4uvfVABc1jXyU+lhPjj4ttrhqkfKng=;
 b=E+v7Svhoy3Up/tZop5bIfytYTXVNBhX4whUrO7z8H2Q0cBm9PKNIrfWsggClM70sliPMlY9pNABNIn5p7mWP5xq7aGBv5+gSlaDO4yOI84siVkrakzjKvAsEHeAbW/cbh0Qe3vdKt65ryJodyirYRE/XchzgLdmN6DvcAuhH/XQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5405.namprd10.prod.outlook.com (2603:10b6:a03:3bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:04:36 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 16/19] xfsprogs: xfs_info: Report NREXT64 feature status
Date:   Thu, 24 Feb 2022 18:33:37 +0530
Message-Id: <20220224130340.1349556-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a63e310-63b6-4f6e-c46a-08d9f7963551
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5405:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB540580F1C49C7C78B0C424D0F63D9@SJ0PR10MB5405.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3VZ1kprBpvnQCnRWIp7ZbKOsHvAHv7jtIGhSmmAs5PkotJXUHF9W2EEUJ/Cl7oab3wiyLkqTInVXu8OoTprAdKwtIzD8Dxn8avAebJ6xa0FY3gaFXlTPEP9ArJFXUEMfUhLsXtj+ynpWFqTugXqNn6LI3frebew31rxxITDCacwn5xVXZIkjjr4j3WnmLk6Yr2I8AhNdchUXKmebxK7LtQ+/A/pinJKUtsRlLWMeumuDxs564at8Wd1iR5xL/cdoIQgWArlVit849JnznY+Ssa1jNdMbk+q7jBkUI5OWX89VDoN+R1mrIob1vf8GT2/M/5U1SvXY/+ruvGPMMTVJ5gwtmGPmdUNq8rGXJDFXulM1a0o+6VeSgN1PgQE6Ob9CJ3+qt1bBlx2t8TsxYA7BaEntx/kDI8AvltgN9V8LvYzM+842laNbiRVkTNR6RTDq2Qob9Ol7MFPpqycDL0Vr4CdkwhSG5wTCfYKgD/7c8P7+t4pLpPsE/7gevY18TFfnqhLk5fwSr8AO2GQn+OY4Iyq2ZOrPuM/0a4NxKJbcSjR6vb+oPlvFoUnUzrpPlH7AzXyCKX1nn9yFTubWFNF0Fg8NVezh9OCzemOcZ/GNfce5U0A31dYFgHE/Zvhq9pxvJSV8HJLn8dZtH0WOm6/TNyJjwitfdWOhzEYf1PMueeJxoAHOHI09YcLsh59xbnU2JjoB8ZlHfLTI5P6uLQq88w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(36756003)(6916009)(38350700002)(2906002)(86362001)(508600001)(6486002)(316002)(52116002)(186003)(26005)(4326008)(66946007)(6506007)(8676002)(66556008)(66476007)(6512007)(5660300002)(8936002)(1076003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?65yzzlQZeuJXVaazdtO1ZtNS6DrUKh5dLECNAuAql9hqVSe38fTTFQo7D1Ga?=
 =?us-ascii?Q?GojEHbTE/GbGQeAzmMMuclXou9WuCqSEksidp9J+kg6gRYX5JsJwIzyuGRiw?=
 =?us-ascii?Q?wGkW38GwlB1MPbIYkBxfO0kzD4Vk/wKMtspg/ldjbOuHjSIWLlIP7NrBeUH8?=
 =?us-ascii?Q?6yqFb/J0KWSUjMY1fGfxHftX1hpY3HHCA3q9VGTlk9YxSuJwV+uhz25uKWwH?=
 =?us-ascii?Q?Xr8HSA2oIUIy63HDlc0mGHlboBCMP8br9x6VBbdV9mWlqRyyE5QqcDabN4NJ?=
 =?us-ascii?Q?BZKVWwWfB0LwPP8o3SdY+sjICGW8uKZIGYN60c2kqybJ6OTMK+Rb/7gWcypR?=
 =?us-ascii?Q?snJPoA0Jbj8zL9nsNaPLg2uD3K6TnqDe+lQfwx/uareIO4M3wlrD64l7QSGd?=
 =?us-ascii?Q?I9yjSwzSS7uimWH8aqmxQAiRZ4NSwyfX34nEUCZyUcrTPMv/DWrh2c3g0Nxb?=
 =?us-ascii?Q?gRvS7ZtJ5L0rB8Wtv+ys6LNMzNqQAszbXqgEBWrbbiJebHZR8ITPpZG5scnL?=
 =?us-ascii?Q?y6xvlkP0heGGwcXruKtr1rOncuXtdZuPbDIm5wPM52IBTIDs8LCJem5TZg9z?=
 =?us-ascii?Q?VTHKfiRinQ/skerrDbV4Nf0HENeIyqg9KsAmpERt8wSgelRY62jIvhSliMhQ?=
 =?us-ascii?Q?vev9LjDkvloY48Xvfnha738IKN+XXjzPTD27yEls91dkDx0AwOQ2qTJJfiRO?=
 =?us-ascii?Q?FPMGM5/C5wNL9s6tTZ66agJjaxVdXVPdNJeCUhDLl7BjJyupikngEPmjTvf0?=
 =?us-ascii?Q?yA7R+wvGcBjJaFmPy/240Qf277lZF1jdN0xE0QrjQHuPabzcZMyA905xuChL?=
 =?us-ascii?Q?jr4XfYahtolDzsvlyE04oidI6D3yljEyYiIUOsZxc8pN18x14XZ8hs1VA8g6?=
 =?us-ascii?Q?06FlVNYMCCLH8X7IvurDmwav2wT0X7s85AjQOX+GB6Hlg80TX7QCadEhfN5Q?=
 =?us-ascii?Q?YiiyR4jpgOykU2W6+TbW+ClDCNWZgo70JeWUSYZeWBOVTp8bz5Re4pNbxLB9?=
 =?us-ascii?Q?MrRWPl7cPuV0t4lPwZEkWG8NeyfD6ufG5yF/eZuGqdXjOi2tM8kjt3k6Diny?=
 =?us-ascii?Q?69s6IlXDMfNKrO33vlRilNfN4nNleA8u44hzC0DruG9TXsC/1hp2Yb9h6gH1?=
 =?us-ascii?Q?CkWRrDLo1/xr2bHW49ngkCtTKA1X1ai7AzgPq4A8NPgo4v8g+lJG56psUbEg?=
 =?us-ascii?Q?29JHCjxeIVNVexU2a+EJI+HboMLJ1zdsSNnyHX5WsRx3CiJb1BzvYlJaEz6s?=
 =?us-ascii?Q?+4QiExkNJAaH1nvmktJGeHynWijN/p8YSmfFL2g/ajZ6TEcvGav7Tlw9q3/P?=
 =?us-ascii?Q?R+gaMiIoZeqIWO/hu6D/+PYbxMrup4lYe9P5hyxL5VHLAP/lfO97VJO/qiwt?=
 =?us-ascii?Q?axknXvVik8h07GwDxeZO0N4SGJgZy1j1AiE1dWa156lxJWNoPtkwGbenvITh?=
 =?us-ascii?Q?VMx0Iq53WFIC/lsiLUiyPY2H2jSLutugTB0mIzUbn0OEfir6b3BcjlDLE6Bb?=
 =?us-ascii?Q?LZcBtCGHJ2/ot8VcuCyE0m+I6ILVBqYehJ5Nk+JonV8Az7BMWi7z935VOV8G?=
 =?us-ascii?Q?ROqoNw19IknMDWEGBJ7HyT1zNPKDHtTHxAZDQmNb9byfsmUcZ2gssv2Uc/Jk?=
 =?us-ascii?Q?L40LErtsR8BjypZwkBCAk4I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a63e310-63b6-4f6e-c46a-08d9f7963551
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:36.2123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/ya9/1MzdU+8hi2ERGcSFUAkZXhtW3kCrBqnmPzuRUYOFtMx2HdXMy5bKVczkLx5aFk4+rMMYP+gHO+XJ9e0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5405
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-GUID: Wz6Z2ypd56BzlmpOkHZXJnabJV_E_mtZ
X-Proofpoint-ORIG-GUID: Wz6Z2ypd56BzlmpOkHZXJnabJV_E_mtZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to obtain information about the
availability of NREXT64 feature in the underlying filesystem.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

