Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CA5C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiKJVbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiKJVbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:31:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A991D6
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:31:44 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AALLIKg017428
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=z5L/Y9PZaoFrNemQYBeLF1b/E6XB+H0NtkuKE7sugzc=;
 b=oErFXtNVYH7piAIs53s8iCFTzdaBoVNlZgJZjYqt0itAU/Tk3+J2KWB6tsmlg96nrtBU
 c9rX9FQE33Gz6b0cG1t8BjiKcRvRGQjfcfxW5bKD7gU7oVBbgK64v90YqKFrRhVSgjaN
 KX1o+4XvcVs30rTzUHhNvX+dsPA6QIgBXJcko6Q8+5EZ3pnXU54qolm8jBLQ1DDUUq9Z
 CNR6jDG+wUNjzdbxtNDDtYEda0dgf2K281VpRyi4FSpCftzg1oV90nDBfRSeJyGlZCtv
 zCP5UgPOPiUoZTFYEZBNHLzaX6aoZ/hMR2KPR1NerxU56MRpu66vgFlY2XtLyhBBsNPd tA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r3mb-64
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:31:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKjfPj009709
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5hauy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0vm0zqHlRQWWUehw2zSMXlLxPKSUY4QZ3ydmqYBwZo3A0M/2FSVtuKukDdHJ+MRs+E1/F4kUAHkNfkQMwwE1nrW3MoJGQPZg51NK3pUL+Vnh6jMBuF5BtgVQaZdw758Mu/HPYKP3v6hkegedoJ5vWHUke7/DFXO5F2ARu2YJo5SZSwUuya6Nwn0TtiHHGbR8PlZClqVoE1v4q52ZhxDgnsykNT6ysJNg9R6+4S/ts0SKu7L1R1/TWNs8uFcdL/cJcKZVuC+PNF382tFDEj4TMveFkQ/9pAtLJq5h6uysHY2RdmKDhxDBeYOte3SUEleGTDA/C+29ZFUQAbw0i66Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5L/Y9PZaoFrNemQYBeLF1b/E6XB+H0NtkuKE7sugzc=;
 b=fep460OG0/QJn8j0P1v7AT1x8JePV1IVsw/OMu6rTW3GpP9W5N53hAmbsStLDpYvJbhVK7s4MdW/+V6sUYMTocMve+fmfj33D8bviesoXz5EO1ZweZ6S3Ay5um4gXIMIGl1dJkyo7yaSMN7o7jwwWOe8UfQ8g+kFNMaUiiYPcgSRQtGmfIUgsGkWwfd8/yPSJZ1IOsSvd1ZCC0Gogcw8/vuhiGkmiT3ohgucQSd+3KmgJVTO9fPstYUXXRNJV4HN8x1VtaFffPv9mfvjTAfRETeJyutgyDStPPmgMUSN0nM5HbZNSTObEhEGj3NPisarCS55UueXSdGk7AZwxLKgmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5L/Y9PZaoFrNemQYBeLF1b/E6XB+H0NtkuKE7sugzc=;
 b=vEYUkWEQmIt/WVbzB7Yaptfz8soFs1V8ifcWvqUHCohuLXmsBGcbsYupddkD1N8Pas4vMJw/yZdylwxXt1Imzn8PhL8HcMC2WX9bO9BRzu8rt0lFSZUYYcuK3BWrNPUuv5oEKCjGGPxm9W96xxx3/c1ZJZBDc/Q/YxIoWDU0s6w=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:38 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 06/25] xfsprogs: get directory offset when replacing a directory name
Date:   Thu, 10 Nov 2022 14:05:08 -0700
Message-Id: <20221110210527.56628-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0012.namprd21.prod.outlook.com
 (2603:10b6:a03:114::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eccf1d9-1382-4a77-ab48-08dac35f5192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFQwO0DjO1hJiaQCd40k9q8YivaonPmqcMZjfQmrkeHh4hDelmPtolMZKaNlLZGIO+2ZRb8dWMVTLsXq2lsY126jOI0MctybkQU01/TcMSQ4R/7Migj8QL8ZbvDrk5UnMZdBemYLYkjzt4EDqNtIZyn07WShKrtylv5OkzIHCccM0EowOcn/DnbIC7n3DT4eBUvMWWPQMtfg3xu33VF3qa8Vn9SX3B9/EYMJmOqUW9QXjPG60WgbuIE0G6XT0a+BOv+j+arTzkRhrEqHQEBS0/6wcr9n0PSYl2Cc0KCyHtz+Zv+c94KwpiQhjoFAnLmycLhuToqhmhORY0dekz9oHX1d/B1CDv/NPRX5AneAzRN6pkYNZeQr2saYXJpOc0gB5sa8vw8jpIiX1STZm0p2Mv/zk7nNw1/hWL1KWcs0kBL3ZQMbu4rRPeLY/qq36QFsjDXJDBUWvfCGInjxq4X/prIeTfAmxOOkDsR1Co0PPKCbsi3+nMVGFVf4/uUixcn0Q8wLttSjE9oGYmzxaRKQ7/L38mgFW5BV7scZT4rs6YRzhfnzJRtLJaQOEVRg0WaR9GoRSfP614qb7/5zmqo1SsI3ZYc7IyqFNkTfRHIOcaiyF20qk2JyaJXPyqkGxKCnKEhG1hKSv2oRFIn9KWe3vy1OBshtl6sMQfL30sB4E2XUgqyyez44Kq0qkWc5HylhtpyU8T51JBys4fPUBer0uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OV1oHgMOC47OR22uUYV1yur+9K/r5JMFeyHQNeP7ask57MMTkihpV3RJFS2u?=
 =?us-ascii?Q?X1PdhSHGoWJfCrUsf6xb6kI2NXgtekx5FLEu2r1XWbZj58I3wIv8ciG+tje/?=
 =?us-ascii?Q?ePnGj0mG5nEl8WlPJUAwukeuLY/X7uWHA8wDgG5c+VbIKQPaQCnRdbKT5EbQ?=
 =?us-ascii?Q?Ohzw3HOBDIxXLBbDC2XeuQ0PyWLTaCgafWivwuZA7uz1b0I2/oGe25v9Tke1?=
 =?us-ascii?Q?g9fJCWVwtWe31muizR2tHN7SXfczc+fTJ4u4ma9s7tV0/TR1hjl57Y+U4ntO?=
 =?us-ascii?Q?m+nRvU6aTZ637pol7k5fmoprimStMSmQnL4F2WdGVdfq7EKio++QYjGEbdHE?=
 =?us-ascii?Q?ZSFQV4/czr47pkgUrlCD2Ke7Angx06jROho6tKBsp31kN+8v7aIFJH5iN4+T?=
 =?us-ascii?Q?9ms4w1yYIKsIO4spun3BJQ85NbQNU1zrbmr6twgCNBjYixhM8wqP+6Ri51nR?=
 =?us-ascii?Q?9Rx2O5Ay+YFNqTvf5KkFz9YmhgEAFcJKkkGgvPoBIFDNUI0hIAgvihtIFyo5?=
 =?us-ascii?Q?Rs/m0idplrPz9VIlkbOOfFlANJBg7IgffVZ9SQbgyBcIlWSKSvzFKmiFOsR0?=
 =?us-ascii?Q?Eer/jbwK9vioXgN69S2QDxkpn7Eh/H2bCGA9TvJw4wZfQZ6EpwogsrdZxTAE?=
 =?us-ascii?Q?et9VXYDT9pQj0FKxjIIFTp/U6NqlVt+H/xj3qs2s8AaVEurJEbjodXTAHT0D?=
 =?us-ascii?Q?8RGIEEGv07cmLSDor34y0LYsDcH2HCuIIC+2fQcmEXyyXzMEGah2TYZsfKAh?=
 =?us-ascii?Q?G8RfJdLpuA+3AC+vQFFRco1tI8L7utku5zYVu6bfUfgIbVxAuK8jJ3d14LHZ?=
 =?us-ascii?Q?oXmLZcqwFs8YIvU4qCvqJrVWpfCfWOb0BhXlzdfDjADW+do6bkOtfk/kjoFM?=
 =?us-ascii?Q?pcdnddB4PqT1Q5O9Pj94m/RoU1WbuY8uRrLGckQupGidBWUDRCVRFB6jSZVE?=
 =?us-ascii?Q?oXelIVHJblzncl72iNa6gV+Sp+NQ/OqnChLacW4Dyj0ppd6MGl0wRUPaPS1V?=
 =?us-ascii?Q?maYT+6GWgFLYKwTYzbQj8FO2P8+wbZwO8jGYMNnlVDD6POHTgsDLNskRDnSR?=
 =?us-ascii?Q?c6gRQoWZgXMYYK0sNx/N/tu0SZPTyX8dAbzZFM6e9P0vGzvV6lTQRdVcQFW1?=
 =?us-ascii?Q?ejV3Td1Gy+hc/lYl1t95A6sw37p7fem53kNhBsB+hO/Ur57WpRoW4xYPSWHJ?=
 =?us-ascii?Q?VP1wau25qUFTtwuK7VDxrOtQfRIkZnn1Y1cDQSCIZ7Un3H3Xtqg47P+xo1JW?=
 =?us-ascii?Q?IKNE1t6iVAazB/aJ1Mj//7YaC7FUSFTVKLUAii3p7AjOjSha2dfH2M72vt+Y?=
 =?us-ascii?Q?/wq5x4yqSKch9EirctKbgWh4wBI016EVa4oayzObSHDkyyMB9V6Delx2UR+1?=
 =?us-ascii?Q?NlYXQ1F/A5l3VpWwNB8T6zSbOzbclIZB+a8QouneKSgAi4inPShxLIhlE9yu?=
 =?us-ascii?Q?UZntXPH6CnzSrKJofEArUmBmtORxK2YzztTZB95FAP1tJq+thFnsW9LAN5S1?=
 =?us-ascii?Q?onJRdoOZFdcxrcpaxv4laHW0v81RQWXCJGtGAtSlaBQ41p78UXSPjvKh9SJl?=
 =?us-ascii?Q?V8r5qiDvVq093K7FgtIC77oT4nrQBYe+F/gVt9zrh7x+BvOrtykLBLYtXvQN?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eccf1d9-1382-4a77-ab48-08dac35f5192
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:38.5316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I9nmWx6GG+vODnDe3usjnloSOBLAl6eUiAZyEY3ZaIn0UVGDzzEzrce2qDcWDSE8YMVr9oz01T0cZQKgD8EoxZOLMkQw3xTmiMKPqwlrVJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: nhiS4b8i4EqoSkoq3BTi2flkVs2ePnVG
X-Proofpoint-GUID: nhiS4b8i4EqoSkoq3BTi2flkVs2ePnVG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c       | 8 ++++++--
 libxfs/xfs_dir2.h       | 2 +-
 libxfs/xfs_dir2_block.c | 4 ++--
 libxfs/xfs_dir2_leaf.c  | 1 +
 libxfs/xfs_dir2_node.c  | 1 +
 libxfs/xfs_dir2_sf.c    | 2 ++
 repair/phase6.c         | 2 +-
 7 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 01cc157e33b7..cba47701e3bd 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -481,7 +481,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -497,7 +497,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -545,6 +546,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index c581d3b19bc6..fd943c0c00a0 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 43b9c18ff6be..c743fa67dbaa 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -882,9 +882,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 3a7e09756dde..136830ec4e3c 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1516,6 +1516,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index ac6a70896adb..621e8bf53ad8 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2239,6 +2239,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index b2b37821492f..5858821c9311 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -1109,6 +1109,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/repair/phase6.c b/repair/phase6.c
index f5f4fcea4bd6..93da70dd4f30 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1122,7 +1122,7 @@ mv_orphanage(
 			if (entry_ino_num != orphanage_ino)  {
 				err = -libxfs_dir_replace(tp, ino_p,
 						&xfs_name_dotdot, orphanage_ino,
-						nres);
+						nres, NULL);
 				if (err)
 					do_error(
 	_("name replace op failed (%d)\n"), err);
-- 
2.25.1

