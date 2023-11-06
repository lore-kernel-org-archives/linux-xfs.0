Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8D3C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjKFNNL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjKFNNH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F119D6A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:13:01 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1xAQ009953;
        Mon, 6 Nov 2023 13:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=SHA0WP4y2SFIigj9AwIKk5ZQqDqymD8v0vetE8VhBLh0410krayxRO1d1XClUAihXoyT
 lxNhu4E88qg9Vyqyj7v6zKlBcHZKQ4mQUwpm13cmMHQWn1QvjYnoEmfPFYEI+9RZbBvc
 xpwTklfS7RDA07ECKunz+r01WmWsSbSwp3gh+CxBrULnP1OY5WGvse4fS5dXIn9qEAqz
 Bq5w4ump5Yl6ws3VmlZ8k2jMHYQugtXd72/iaAduhbO2hvrA0zP0O0tz3AFUysP3pMEi
 u7HLNgUJRgkqp69uNMoSqHMeTOwxLhRib2wWRASw9R8D8MaE9FuG6s0bg74UVU6dH8yF kQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5egvax22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D8Rjl023535;
        Mon, 6 Nov 2023 13:12:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4tcfa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hy7x143aDJ52bKKAqGWcZEpRPRqYp4azBfmTSQIUchwLWlwCDebS+YtnHlJWGtlFpWN0AtW/pWyvDw+j8cZANL9MA1tXW2Q0KE8s+QDoNZBhpqx4Ar1HE97pTd6aBd6hKxqVZsgmgFoyPz7xOe56MmB5Y8Nu9mhHtVMR12O5SneM6GjC1z1/KtvdT1KEVaLjpoEYuxbyzd8e451lUDBgLke9nrKs+3M3DkeMEoO6bw42Jp9UrsmySweC46Wsq5Q+ZJhWdXVOHViPAyPz4KwyLLpX67vRGteDjsqu/gil3SPEOsB2qFSnKdErDXW0C/DD0wuoIL0DEbZdh9TSZMi+Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=hlHzAZXdujDX9FpUXdu2YahoJtS3BUG/0M8pq5JSX/+8pU1gaboXuC17B9X7TZ+P1z50zmzMPPADDeqCVPZ/eBX+vGDabGpWYCGBTsmeaHVY5em6P0pZCNyh+vgOH+FXU4gOVY9f3OzQr9cokMhlNzc43haUAb9VqthFN4YuIuKVYWUGSny6KBs6WJ5EenWgiug5hzpWHJzj6lmtqBVy3KFavClBiCJXaVTaxih4qjUb+fBWKw4Y13ep1/70oAQiXbXWyEc0+FDbX63hWxjfUXY3ARO6T20gDsKzhDFaq7MMkr9MDhWbux7oaTyKcx2GGxb4qoDKNEMmM5ZJtARvMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7f3ZKtXUhRBswEzHa2tsOZ52uFUEV4YsW3z6LXL8GU=;
 b=sSnOxX74GGJLIy0i1dnppCci9aqkPYvmpAwvN9WJLw3lUbu5+y1nJU3w8DQfjD6uA3RXMvB5cOG7pfjcG0ioB0+WElXi86kqQVP6T6gh6obfoGr53PaXJZQr+yxq1IJvL5KeoqANFWURghcveKGbjwepjf+HghtG+5nt66KrD8g=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4513.namprd10.prod.outlook.com (2603:10b6:303:93::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 14/21] mdrestore: Define and use struct mdrestore
Date:   Mon,  6 Nov 2023 18:40:47 +0530
Message-Id: <20231106131054.143419-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0100.apcprd02.prod.outlook.com
 (2603:1096:4:92::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4513:EE_
X-MS-Office365-Filtering-Correlation-Id: 75d7a1da-4730-40c8-6844-08dbdeca06f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P61r4wjyQDW8W2L8SlkYJLuM7HlMpKjmeuVUgM3Vc/N23stJA30qR3SH9tYVgIs27ISPB27BstHqBy48qt4M5G3k0QsFSKW21SHTwaAAF/o60wYMuy6U7258EzHqiUmr01Z5I4BrWOwzkUTqzAjR0yFQfy1yB45cHc/VwdAA2CasFHypUKTaIxGsI3emm+cVZws7795ycyrnsv2Pyd7G5rSACQSmr6EGbuTzAixizo33xwKs+Gqa2P2sZAAeV6Dy8CdU0wKCZUetr6+mDYtiULh3x1P4iEsrS6PnlCLH4sNs48CRE8Lls79cdQw2nfwqrYYjyMbuSjJh0osAbdYH+yZZ8rKuh+8kHoAATzvRW3VZOz17GuBh2KmHsUq7S92BlqLabgDR8OaRP4je3zgP3hA/re7cIR5XqxvgitD5YEfB4vENY20GtACwDSxHt6/hUV98pxpmR285SUGFu/xCts68xUwrV1LTRArJW814nheCI4q8dftnZOwvAepdq55rwGQYhSas6a1b7E9BViMr1Sev1QDvLmQsVeG0qwpgBexGUalTPLzucbbNpDgaYQRaBxog+lYIfnKxN27I6SeY0OJplY4jg4w4uomz5Ikgxui1H46pfSeZfL3N/7OjxcZi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(186009)(1800799009)(64100799003)(451199024)(6512007)(41300700001)(6486002)(66476007)(66946007)(66556008)(6666004)(478600001)(5660300002)(6506007)(1076003)(4326008)(8676002)(6916009)(8936002)(316002)(2616005)(26005)(2906002)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i9l3ZSMU5vtoCy+C7ggkXjzxpdXF4uhXW+sR1Nt68fqvyxdrCVCnaf2q9zxH?=
 =?us-ascii?Q?XGi1Z1ffjHMpTM28UN546hX8gmlXGvYgNHf+qfuZufgHkWy6TOLO7CycwqxU?=
 =?us-ascii?Q?eJXQy7BZ4JPX/+0wgy5knmJVASE7q9ztKGUQFWc1teQ6sxIpm0ofFaXNzjrc?=
 =?us-ascii?Q?yNz7L/wMSxvAnqY+At5iENuyFMExhWlFdzK5atIuwqjwR3+XrePN+c891AwI?=
 =?us-ascii?Q?WkrvhH9YjRIpfzHYQmlEDmP7ddmadSPFPM0c6eNp/vc1J2Cyk0ukmKkhSfG6?=
 =?us-ascii?Q?bIS005MsADFQZkHbgPQR3d1eAEFkAfetXnaIM2ckvDZl9WmK9MmNQTn62Zzq?=
 =?us-ascii?Q?WxBHDKrAVKsiZbHG7blmI+yPCD2IM4HoqOVYu+yfbG0jLcCImuXeABfBS20X?=
 =?us-ascii?Q?R8gIcHdTl35UBB6UKyAKBidBIAiksr0aAdpad8Rdp4tjtm036DRMioykEs62?=
 =?us-ascii?Q?IDU8ywNtk/TvnlkfAcmfS3f1OPisUiDJiwdhbxkgVzT1QOHZoqkKgxzbE7kI?=
 =?us-ascii?Q?wrRcZtZL7alKY8LNoDEOxNEHm+gyHB9ktf/tN5KN2I2D+Dr9My+Pk6vBGWIl?=
 =?us-ascii?Q?RTCijbz5X5q/SCXkvpP+38QlzZYZOjM8iBhLza7BfhhncOH2f3oWnWuu9hQN?=
 =?us-ascii?Q?AuAbIo1k4Pn7czL4MZUZwPRAud6L9rCK0+sT+/FOcZsQuP/Vn8p1OnauE7i9?=
 =?us-ascii?Q?n4q8FrpgFdAjBEP5yxYnE4nTGknLUBrY76WfN0lAzv822wzrtuO+h3kZ3Yuf?=
 =?us-ascii?Q?S4l1SVoVwQkTC9StFKTP7A6gqDGD/hZjYXFgaGwockFCmztC8f5tSnYAq+ZN?=
 =?us-ascii?Q?zjO4OvHgnP+8/qzsJhpqrzcgt4l8FTOC6iioyifHEeTIjdrfO2Gh81jwrSVC?=
 =?us-ascii?Q?AZTc2WofQOy3yAryD3hO6PuBYt9wP0DiJAL8zkO+IRs2t/JCnp2F5EU/ETKh?=
 =?us-ascii?Q?EemkWPY44uQkN+gpS01QRE8huEehCtMU0kjfSA7FkM7dOKKyrmMKplJ6tXaS?=
 =?us-ascii?Q?TOmVjZxrhr5Xu/Vbw0gxfuzbTEHjxBMSs15FaDaFDS2mFkUGtNP24FhWRZgW?=
 =?us-ascii?Q?Le3Z72DiR+ZflEYBCVirVS++yejHTZZE+sEEZYgHU4xt1tms7HbXUsOf4YC2?=
 =?us-ascii?Q?VaF1v5xaVCNP/vJ7ehyB0a2wnSxgfXibjUDb8dRKOhHHbvg377ZrbjIgDMaF?=
 =?us-ascii?Q?XGRPqdliUZL0OLIk1aCOwlJewkJBN4U3eRMoazzySwyM+Xw3S0Ocmvq/CWA/?=
 =?us-ascii?Q?3VKHdF1FR1dN4mUnsU0KSSzD8YLwu6Tl5I6xE2wSUADwoxb5KjyccANmr2wl?=
 =?us-ascii?Q?rnnNN13m+31DcGBgGFjFEiMXsMwJnHNseuYF7ylCHjUFMDBxxw6f0HSCuWnt?=
 =?us-ascii?Q?hSqczI4sl7rDKVUDxuFhayKGCbbF6zZZtE+fnLSj1iLAd7BUHfM/gBlD6Lrc?=
 =?us-ascii?Q?0ZV6ipMFsn0LAPPosCGzSiQJpOV2OrHsUdX/1w/hO9o7a3aN2Zc1jKPukKVp?=
 =?us-ascii?Q?T8kqz/wpZWZLNLU8dcCSyLmbMIrtf4fTphLBOA7JJqeXOE9Gz87pHxBVY6kF?=
 =?us-ascii?Q?Ri+/J3XwF2B87REoz/oKUXyA2bh+573x4TxxfKu1MBcwOuAy/H1h4yudH9pg?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: K4N8PSDTnAgEtoMaX98sCbEfVZvu5zE2cWqojHJhRttSnFj2Fe6oI5Nz0iC7spxMBrUJ9+xD2eb417DjhAwIO3/hI1NZCxlL0b1LIujYzSOoc3U9/GLWGkg36uo1pqW7YrOg3Xgj+gIJ6bhb4umLqZzaqOkpL8tEdn0qxCS0KcfkD2FNwN7ZRJvqGLQOGeVp/O5kcxmZP424HRVaHYUHq3ToCk293MSyQZizM/7fZziFAerzza5IIVFGt2ovP5jJBWUlG0xuTzHiMgu9j/bHShJVdWa7jYMosItaO2fiDEr9lv8bWtxYqMMnqEOuyI7IPZelJ0kK86rCl9ocrs/yKoWTycmbKqvz3K+xqXHwrnknUd38rlggkvAZwV/DwhOVpaizeFRCPaP9Waih8XcnCr5F5nu5o8+O0Voilu8zGUJSCqfTYfy5cmYBPjlPqK3m7GWgEvcovg57KgJsEl+ROFWiyvjaEirJYKaS5Evb2pgBRHOLh8Bj4TPXbGoihFTCNpTNBdH+E/NRMMmGp0NMSlwITwoYk+mnU/S1hFzF5FkwdmYBzaA4mAWKSO07LUEAlDhwsaaMuEtCPvPi/Tlx+7U3PxOnittAIn5XamlfrnXE6sXm2PyXaE0c/lZzAh12DolUyoC2gkOw5LBmvPlgkmmYJ5j5rWpAhZQnz56GuaTjBa8Ee5LaZINInFB97HJwtKzsHQoJlSUU+4dAKWZkionizH5QCaZ4GcUa27uuJ5CiWND+oJaPIlkmJqll4Cl2Gg1u9oQjppWZ8DiBam6C+kxG9ddJeyaiRe0zyQ/x4sw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d7a1da-4730-40c8-6844-08dbdeca06f8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:28.6100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4h02wlzZDVZzJP6olNlPiYRgndZX3bij64bb214NV/XRNe2pVRKE8v36WlhOJPiV/X1zjzyrUdo4oLNiNi8SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-GUID: T2H2RPeVPWtPXb20ud7-aVbjhcX8z4Ds
X-Proofpoint-ORIG-GUID: T2H2RPeVPWtPXb20ud7-aVbjhcX8z4Ds
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit collects all state tracking variables in a new "struct mdrestore"
structure. This is done to collect all the global variables in one place
rather than having them spread across the file. A new structure member of type
"struct mdrestore_ops *" will be added by a future commit to support the two
versions of metadump.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index ca28c48e..97cb4e35 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -7,9 +7,11 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 
-static bool	show_progress = false;
-static bool	show_info = false;
-static bool	progress_since_warning = false;
+static struct mdrestore {
+	bool	show_progress;
+	bool	show_info;
+	bool	progress_since_warning;
+} mdrestore;
 
 static void
 fatal(const char *msg, ...)
@@ -35,7 +37,7 @@ print_progress(const char *fmt, ...)
 
 	printf("\r%-59s", buf);
 	fflush(stdout);
-	progress_since_warning = true;
+	mdrestore.progress_since_warning = true;
 }
 
 /*
@@ -127,7 +129,8 @@ perform_restore(
 	bytes_read = 0;
 
 	for (;;) {
-		if (show_progress && (bytes_read & ((1 << 20) - 1)) == 0)
+		if (mdrestore.show_progress &&
+		    (bytes_read & ((1 << 20) - 1)) == 0)
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
@@ -158,7 +161,7 @@ perform_restore(
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
 	}
 
-	if (progress_since_warning)
+	if (mdrestore.progress_since_warning)
 		putchar('\n');
 
 	memset(block_buffer, 0, sb.sb_sectsize);
@@ -197,15 +200,19 @@ main(
 	int		is_target_file;
 	struct xfs_metablock	mb;
 
+	mdrestore.show_progress = false;
+	mdrestore.show_info = false;
+	mdrestore.progress_since_warning = false;
+
 	progname = basename(argv[0]);
 
 	while ((c = getopt(argc, argv, "giV")) != EOF) {
 		switch (c) {
 			case 'g':
-				show_progress = true;
+				mdrestore.show_progress = true;
 				break;
 			case 'i':
-				show_info = true;
+				mdrestore.show_info = true;
 				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
@@ -219,7 +226,7 @@ main(
 		usage();
 
 	/* show_info without a target is ok */
-	if (!show_info && argc - optind != 2)
+	if (!mdrestore.show_info && argc - optind != 2)
 		usage();
 
 	/*
@@ -243,7 +250,7 @@ main(
 	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
 		fatal("specified file is not a metadata dump\n");
 
-	if (show_info) {
+	if (mdrestore.show_info) {
 		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
 			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			argv[optind],
-- 
2.39.1

