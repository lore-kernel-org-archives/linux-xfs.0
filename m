Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4720C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Oct 2022 13:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJ2N61 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 09:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJ2N6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 09:58:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E692152DED
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 06:58:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29TCaNOd024788;
        Sat, 29 Oct 2022 13:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=++CfO4iVHvtXnkaKNWUi4pMzmzeADhdJAsGsEbpxC28=;
 b=IeFhbuNXwAtQUFb9dugqgtjyNqH/vtkwva+bPzpxLK5X36ATixA7TwT+IjzAut6/NguM
 DWFnF+j9WcJZfo4Kp7cp+nuVWzxe9+iJKrIMrJxc146+Q33blPBb7Z34Nx3i6Cu4Ko5+
 jVn8Ws2v5UskR4O4NPZEOg6a814B/psghYqIdwJGxgsX/HLAuSdhheu3oxlu5xZ6Awi4
 raSsyQ0aW5IdmWOdsl0TADxdgrG29Lw2HBtZ5pl8j0FU6epy7xckQFpBKl2FB5OINpQE
 aWUW4Lb2ZLcmYFtJ7owDyZDdxwR8pBZfOFWtOlWWsbUIHZ0FypCzPHgP99nDARbVVA2E tA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgtkd0ptc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Oct 2022 13:58:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29T8q7oF010797;
        Sat, 29 Oct 2022 13:58:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm7v026-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Oct 2022 13:58:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhQTcZJxwLOqfjj1uF59yvmTzogkPrZHLRuuITQ+SsIUkXEYVW5IrWwngFHk+ownqtdmYfI10UNcjpXEXZuuh9UDnxQxd5ApT7R7Dhjh5FZJkENDVGjoqxYnkQ7I9svPRFUGtCrjYHCpJANDGmA5fE3mrnRHv35rTz13l3z4BX+4ziBqFHrzcmYjKRQMYq2fRkOpnemFWaxNyzVRMuP8aztqbMHQWYWVNAlIbv+sataTk0wixAd9FY/a3U8hjY+jRuOxSriTIQ8gZHUJva59FE0iVeX4m4GLbgPvtUrSz/xeqgeyKZ5iTxMewjnnFGEYbMu2PtMHqtML2t0hep1Abw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++CfO4iVHvtXnkaKNWUi4pMzmzeADhdJAsGsEbpxC28=;
 b=cTUixxSoxtHXQbtqnHI/b4x9l6Vse683KfEbku1VbG+fodk43NGZZv7Rnvcs3c/CeZk4TJYivKBaR60CDclR6BxX771j4Mukb0UNR0bNg5OiIIGRHvGQ5sSz8UMx1xecJJiywLMFvsuA6TtTgxsD77OQ5elbODynwICudskK4UMVLeserzN45n4ZwCuenLO0LLIgHQzVRbe7bLWBFDr2X+5qlSTlswvvZzoNPa14jzuQNKmMacMk/QYlgqmgHtdR/1uIeeVWGiVEJ3/j2REuRm7nxvv9RBq83j5lv0dwchQ3vT3M4A+zDbc8/ijJEnCkrXN/XoziJvKwCkw0ZeLsxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++CfO4iVHvtXnkaKNWUi4pMzmzeADhdJAsGsEbpxC28=;
 b=uONUTLEjW1rDHgFJLhd8Ge3y9aTYJnK4E6C2kN6h06RS1yMvBsafaAyokfDT3XC5ndyjhVhRV7R4NVtleCn8eOZQTm2E/dTm3NFr3/BBjrGgloZhftS5EHtSZa/ssVq5Nn3kJgGTyqp6Vr2EFc40sGYYPkVKGTGSDscXDoyBIww=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5843.namprd10.prod.outlook.com (2603:10b6:806:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Sat, 29 Oct
 2022 13:58:13 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.015; Sat, 29 Oct 2022
 13:58:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 3/3] xfs: force the log after remapping a synchronous-writes file
Date:   Sat, 29 Oct 2022 19:27:32 +0530
Message-Id: <20221029135732.574729-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221029135732.574729-1-chandan.babu@oracle.com>
References: <20221029135732.574729-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0036.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29d::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b7b7afb-4c2c-40c9-0faa-08dab9b59ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTRrTDcS7NhP/6rWKxbWtGwjiPcW2f+Hxc8rV0WRrPD6SuHxD1GL53ShvDOLOVU7vfA1g7G7tfKYbcKeSUGyVHPHKDP0jpi+1d5C31VKcVCc3R3UYYa1C4CSwuAjL4HsMQmxlc1p2pGh+7WVuYEROeLAGnzYuItSJEkj4dQR3wgDGmBE8kFWfdpPkfICU05/mXXxD5wm3DlUVzYLrHOthi8NuBFmkEh9+6tX0sZEhfbnMbtT/cllQYvjv6mRun4Wp7P2eM6FsHh4D6KQwJhgg55GK25a3B6UMub8EAZBdsGjkRxFx0LAFfZYUS3MoFubxcG5ShOdtaSa5igTlLWVnWN+DQBby5xG4vWVF/SEG9Yh1gv+jqY2jZq7rttHv4IClh29WqLHhBBV4001rrh7p+1uKAjrN0qb25XRwBUFh5hfzvJOxVVHKslVS8kuz8m3FndsoQX/NAquLgFq1BVWpZMZ/4wvWEWgzn+eSZky9Tlj336SSmUUEH9rJemFkInSdOYc4Okmyis9I43eM7GS2T8y00e4wyZrXWIloBW4tisfdFM1Tp2SlqINO7a7W3hVfLqV4DAzJ2ByVqs36k8s3M1qoXK2C/xhcJaqMt4ZruMeRlY913fJRWgr5lZSuv13Qq7V8f6vepCT4r4VIu9V/6WhtrYxdfGBxBdPeiTaom9E7sSd2A59kkpGdhFIiPEbt+RrmigXEeF2AjtlSfLNwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(1076003)(83380400001)(66946007)(66476007)(2616005)(86362001)(6486002)(38100700002)(316002)(6916009)(186003)(6506007)(66556008)(41300700001)(478600001)(6666004)(5660300002)(6512007)(2906002)(8676002)(26005)(8936002)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?46qt+JdF0/BP+FTd28MB75HIBSIJHTbG+Ho0RfZ4dLlRwMLc9qZuwGh64N85?=
 =?us-ascii?Q?fOt1mmTTyqNkbBAP/4IefnAMFbzoNl1utG4rbyCRoGYLJpTaYu0I8EXgum99?=
 =?us-ascii?Q?rpCgDDHfXap/Q5Zw4QPoSBrYRoM7Gsiaq/Kvm/JsieIyCKr8W3ehyVkZM0W6?=
 =?us-ascii?Q?f8pK6tDIrTqNK5orplV7x9lqrSVrR0jqLz3+F9bzKdvv/h3atxS3eKTPH8A0?=
 =?us-ascii?Q?4VERBUcuBI+VDlE/CXNuuFN+czXNx8ZiejxShiUPcjoHKoWMAouHVIY45RjX?=
 =?us-ascii?Q?LQFHfz+H8dkvvyu8kRu8dAXed0ZZM6cQNGUxywdrCbQVFdWZE7kb5/1+rryc?=
 =?us-ascii?Q?W6wChS5+bAG0xQky9ylrgJQzCGVBGH2zZoOyx4/Q9MBxPLsm1WDAeh5+63VZ?=
 =?us-ascii?Q?0p+huvt2sc+vtuUQNODIOFi1CrFB5oisP+KcOJ767RiC49quoaFjDd7uzq+i?=
 =?us-ascii?Q?/GCw+VNF4AP8jRY9uz6Wt44I5Ywm3fSFkbBXxmlq8J8PO2+8Eb9uLIOrzMFS?=
 =?us-ascii?Q?Mmzp/yUC0p/wcq6CbE1iU+gVF1j7gUJbpnjJ3dq8DzK0kcmYAAfUZ4D8psW2?=
 =?us-ascii?Q?AYkUzVXsdwRBWNTyray6esnfPi5pL8rE3XTlxwW+xmVqHoyREgd8UWSz828R?=
 =?us-ascii?Q?B97+d2Du2i/tLWuvfg6YjS+CXrC4tg9FRg0Tz1nZhF1jh9SY4++4thp71rjb?=
 =?us-ascii?Q?rJx3d8CYLQ0jN8EoejbBW2YvHW9Z59tL/tK2kHqJl8H4ZLg2S2uzoqXXc5MR?=
 =?us-ascii?Q?Uhn9519xs1fN4lUHh45CnlQkndacl1/UEJeEW25fQhYKLoTujtATFgw1lsn1?=
 =?us-ascii?Q?kzYoF6Ws0Df6cNnhDLHDsYLqjXEWVDi6QMXtk9Yt4ufPZYJwR0o/zsY51ZJ0?=
 =?us-ascii?Q?5seuCSkM4aDXckftVudBVcEi54o4Mx+d8ghGzTJQkixSfeOChNPKxICf3HUU?=
 =?us-ascii?Q?eVJSGLRpcSgK0nH9PCxL4EGVScJs3nxftYhInTz0Ywg4iYQNxHPg4zlgI/oE?=
 =?us-ascii?Q?qoMCHG2MLRyKO6Yt84WtTGFUON9Gp2U/yqjfXB2CivjKR/v5LP5iYrYlEVZk?=
 =?us-ascii?Q?L1bvGJj0Xyw6yoO2KWuDu1SIJbesF3jiLkogteK6x+5yuvhkKDUX8c8RWcSZ?=
 =?us-ascii?Q?cINHShkEVgBV4CGcgmXBW6xUyBFe/H8JoORXCr0lI+5HwJr05rMLkCYHyvb5?=
 =?us-ascii?Q?xQzioPxdMFQNTgZ8pxvLibVZlvSjXOIrzUTp8wh5bQyx78L3s6l41H9cFZ+Q?=
 =?us-ascii?Q?01S9r/NpgfAtj3vGoTBhe0SIYNzTOYo9KI4jZxZ5tUUVlMBMuYht//qMQqND?=
 =?us-ascii?Q?BsMgE2eVbUtZx9F/vIRCQu3Gb4d6HCN1B0AaWunxkeoTKfNEoYNcwDtrDqzx?=
 =?us-ascii?Q?KW6tBwgSrolfQmEUJZJN62HAr1v2HDjjGuRTDk8kgpPjpF1QU3uQFKRJMRCB?=
 =?us-ascii?Q?brUzobUnB7o8sIedFqdV/6NdmqGrqlZn1Xv0aMR7IW0j65irzS3yBFwsIwxP?=
 =?us-ascii?Q?0GCBr9lKCetLSA76ry0ar2QEAJ5LifelkcxODueC075JIAOpw/Hi0SS/fIG1?=
 =?us-ascii?Q?OXqyjIef9E/9jUQwMW7RhOpPI4dE5efv4chW3aq0oJEkhufL7xXJug5Wnplp?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7b7afb-4c2c-40c9-0faa-08dab9b59ead
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2022 13:58:13.0738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gTO+gX46jiaQy00qD7sUaicrD49MM4JOBLrPJ3V1mg45sSGSh+MOjvLZmZmEGAfIhFagdsSlCdyaqDz/mXn/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-29_08,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210290098
X-Proofpoint-ORIG-GUID: eacuiIi05pIAtNomVkJddq3KFXtvsoNV
X-Proofpoint-GUID: eacuiIi05pIAtNomVkJddq3KFXtvsoNV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 5ffce3cc22a0e89813ed0c7162a68b639aef9ab6 upstream.

Commit 5833112df7e9 tried to make it so that a remap operation would
force the log out to disk if the filesystem is mounted with mandatory
synchronous writes.  Unfortunately, that commit failed to handle the
case where the inode or the file descriptor require mandatory
synchronous writes.

Refactor the check into into a helper that will look for all three
conditions, and now we can treat reflink just like any other synchronous
write.

Fixes: 5833112df7e9 ("xfs: reflink should force the log out if mounted with wsync")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_file.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cbca91b4b5b8..c67fab2c37c5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -990,6 +990,21 @@ xfs_file_fadvise(
 	return ret;
 }
 
+/* Does this file, inode, or mount want synchronous writes? */
+static inline bool xfs_file_sync_writes(struct file *filp)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+
+	if (ip->i_mount->m_flags & XFS_MOUNT_WSYNC)
+		return true;
+	if (filp->f_flags & (__O_SYNC | O_DSYNC))
+		return true;
+	if (IS_SYNC(file_inode(filp)))
+		return true;
+
+	return false;
+}
+
 STATIC loff_t
 xfs_file_remap_range(
 	struct file		*file_in,
@@ -1047,7 +1062,7 @@ xfs_file_remap_range(
 	if (ret)
 		goto out_unlock;
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
-- 
2.35.1

