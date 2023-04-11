Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE240C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjDKDhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDKDhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:37:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA641726
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:37:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJdxKf003211;
        Tue, 11 Apr 2023 03:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=kT9jFpBDgx79C+XR2tBh5CA2fEYRrG5oiKmnSY4V0wg=;
 b=n9xSxeGuMhkAqHf+XB5jlNJ3/EKNYk91AD0JBI+CVHiR+jnAtNAvIKIQRkMMtcbEY52t
 RMlGrff5CgLW7r9jxhLVDaJcAHOMN5bN2L4KFcVCyiDbUWMa9sRTonQQgdGn0A6NXI0r
 qft4f3Skv6hYFg++7PYe+TDNxwWnfc6Leu5uaE/1kD62KdSKshfEWxdHlo9ZQ0Q1FRDy
 xS67cx/5aC8ZHAJbKXrLsdF/iEv+HFST5AQp24N/JgyZK0dFsm0SvmyV+aZ+YjEwRteu
 s2CykxVqDIRXGXxSlCOWKB/np2QkcEXYxvP1swLN1Gnb79hw1vQ8jpVqI/CWBSt5DJPx MQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc4a91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:37:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B38SxL001834;
        Tue, 11 Apr 2023 03:36:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe69akb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZkDFgUn86zST95iuAKn5gmJRaYQyVLTsg9bYKoRVQ1vp6IuDmowhbOTrMC79o6iREQWmDu0hjzYMwVNvTbmL1W9Um+fospSD5i11SOAzS0em6NQDY+eAYt6T+/88pGn6Zg5HuPVdhpiYq4p1QdzBTO3PeDP+Kl3cE1OvMyGeFS2THV6YwYto8P5DgX4zO4gV6419k0qGF8+18idmQaJ2206JsKj29Ul6dFpLz+7zhiDuN+n4e1kAYzEEdNONZon59CZi10BT2TYKEiah4ZuVKNOC0iPR0WQIELOv8jFD0n+46sLC89xq+PWXu/8CUm5U9lzNPPaQBaJBxTwsuZ6Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kT9jFpBDgx79C+XR2tBh5CA2fEYRrG5oiKmnSY4V0wg=;
 b=mPkTpLy1uq6qw5vyUd4oITW2v2dPrJpmLa7172nMg6imuLBG/mi5swAAgOSF4viubi7htIqLdNVuNbe3DbDVcRma/OH5DddsGz7m6N2ZVlI6ugvDOwAmz6Mdd6cIKF9AQLVnj4yYrMbzooCpySCBBUUhE1kz5/xMbYGPgd96NzZaDlLCJ22K5PA//5xQf0yuK4YIvTH0KdorRnpwAtPNgSf1o/wMbQpWDaRrLu2W/ytg49YoALSmjI2IhyX5MTVe8nEN+p2Xe1ndtwKZh4ksgv1g8fIHbjI7S18gnj4kuzUFSmw3iIU/IWFm9afMopJs4PqpM/95HeFJ81P4ydM1QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kT9jFpBDgx79C+XR2tBh5CA2fEYRrG5oiKmnSY4V0wg=;
 b=HndYK/Ov11LaYq7A+lRhkhrLqgFNDEzUFJ2VjscIOaCX1ihlrhIsnzaqENMzvdko9K5aAtWnUn0oF7AmUzs6dJ8sKjzsoAKaciUEL4Nij9aoBYKLrycwHwPRbYcfh4jSmyavUDl/By/9J+gBRyo/RtHCXG/MJpagtS3+7Lnza4M=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:36:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:36:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 12/17] xfs: set inode size after creating symlink
Date:   Tue, 11 Apr 2023 09:05:09 +0530
Message-Id: <20230411033514.58024-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ebf8c3d-a93e-41bd-815b-08db3a3e00cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHyNbd4no2HvTQQ923p7q0S8SjBtFSTikVD5DmKGLfUQMPyvLc8PJf1ZhIO8wA7l2K+9lShbJAX0uKkZqrHE5p/zKMMUGH3pxgqT+TZQDEK4fnQBAPmeWnZcUb4qXMWgZWmXrnpt58chzQipjrEEvN73N1xGejGZmCQftJz2nzGUn8POuikvE1IYCMEqo92iuFkefXViaT525smoJDPmcPZc/PUb8lHCAM3wI3UB/R6jObCFEhvoXet3ZkSsBntkwRBecXkTmTxfJFYm5L73VPlkLgu8r+n7m6z8b3e8rlf+jrKjCNlodyAVC3vdJNU0ZLBdezlCb7IuBxElW0ZpdYfHN9mBuPR6ThCk8i3jrq2Pqi22YZ1WlUZFh3PY8BoqLv5MfnOHP2VRQbJACPtLEPyFq1cj2duKAdy8cuW7RFSfFola1FqdEhcC/26EY7FvfcGKC93v8ZOS56HV7rucKJhkM2sjWv+3Suig8OfBvD0TMqgbyMLlfX+ta/CC4tSkXpxCQwETkMH/6gPyfwQinu0IBHWLVLVHzlSzyGwOyViNPSwC8q4VQTSYsXXe3zqi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+r6dtj3RtWauu0LGu5ppCkuxuUlEy/tUDrVh1Ze4BLwPz9P/TQcpgFFr5T9f?=
 =?us-ascii?Q?cjpCon56wa31RDT+xTmaLMBTNBiXspaDgSBDISUyWYXYrKa4F56zbxoS62Qu?=
 =?us-ascii?Q?Lw+vecv6WGOvtpiX1IV/CIXVuMBnYpPa8IUgAWxzWXX0Zx5EUdfqxSyjA0fM?=
 =?us-ascii?Q?zohQnMVlVpirLBI62m/v5P7RYANw0jzr8O6Z0FWvDd4XhIoUDjAtqyaTc8W+?=
 =?us-ascii?Q?6dJYKmF7hjxUSFeBzuIBJX3VRX9H/ysXssHD0qDjrX0CID4R/NsNG0/DBCWI?=
 =?us-ascii?Q?3yDXd67k5VltuXYgI8hV6DCl8rKoDCrqmnDwLOOYWy9t2LdwXh8scTgWnK4f?=
 =?us-ascii?Q?0f5aeQMYWtO9Hj0il8EW3rc1nLfTq2REKXjb2Tl+y7Zws7tXlnhh2Jj62lKA?=
 =?us-ascii?Q?/uD6UwuVH1DsZiXjXdDDDAgPuABVn4H2sCCCdFp0WBayB4+rJsGmNeNoS2ZA?=
 =?us-ascii?Q?Szh8TvzIF+LYvMiT2VVO6y4zrljqIOd2G2FGpM7+5wPFMdBjGALPvYl290aa?=
 =?us-ascii?Q?SZAc1vSOd7ZTDLJexI2rTjAUKfUwT4AmHHazlpOlZkBxqEKTOmz/rSBTqzCk?=
 =?us-ascii?Q?0t5gg+e/kWN4AdUNeiowtlnoxOkBPhVqL45TI1i5H9rTEeNvjIPKmFwu0h4K?=
 =?us-ascii?Q?Si5lk+ISYVMHshiDf2cB/ePpiBgTkhW1b2iVtL84yIDeg9CVjUhsUau7UMW6?=
 =?us-ascii?Q?l8XMP+PrlV9xAbIwRiB9j7f1GPUOvG3jpyjVkeBz0v5QtB9A5XzS0B+iK6Ua?=
 =?us-ascii?Q?xzyiuEppRnr0AoKdJGZPAIdUbzDmiq4d7OhoEBfyAXwF+fIqa6OfhgcYGrz1?=
 =?us-ascii?Q?ltK9NLCcv4abN6xo4j9ghnfmikrnVk0D9RO6Im7gjkrjJclTpiF7qxFAOEv2?=
 =?us-ascii?Q?mwvDFfejMlQ4PbaKj4eJgPybd/uEl1owRhCrxuANDpJfE4vuBBi/jZIjMBeD?=
 =?us-ascii?Q?ZuF2XVhftvpmdN+F7QE9xwgsrQghf6zUUqteH7fksLZkXiEKeoCZFaWkCj1o?=
 =?us-ascii?Q?d3W3OIyPgsmzx/MAH9DaOdW9ZvMqjmFxtVJ4a0jJRj6T2p24D4BemZPBJDHl?=
 =?us-ascii?Q?bygk8q2d4wNowwAB5gHg5NwZeVb06BGfvqRacJJLcYk9jxT5h489aaC0m9ml?=
 =?us-ascii?Q?yQaPcSwQMl2wj4MljRoJc5D+acwQdswYb0LvELe528Vdxqofv08Zzog1Vp6I?=
 =?us-ascii?Q?4+I2eQ7qgb5vKCqEOXWguXSODsJ3WXdvYUAI+axzJ7VLBmJGzCb9gxMKXxwe?=
 =?us-ascii?Q?cFMwMIMNscwH3B9svL3TIp7cW9iVVFOtz3Sd0VaxWrmyAPl8GFrwGCthT0xs?=
 =?us-ascii?Q?Z1JM96vBefQ6mRtBRe14/KU9Ud3fKe15nJMmQtcbICM7+avHvDAEC94Diof5?=
 =?us-ascii?Q?nFWz/eziBLvJvyYe4yuBV0liGKCtbcgKsN5nR4FQpsGJQTByUOPYB3ZJB0dQ?=
 =?us-ascii?Q?S1OnM398r9fPjjaqXK5OBc+kemce3Bkt5TsTjK1+ZQK/V4spqzzYOnVBqY1V?=
 =?us-ascii?Q?M/LDmNuT6nRwU7+ULvTkxRRdN24uaxqc9ElNEqwMohMoMEPLlGsOvvn17PYs?=
 =?us-ascii?Q?vUuUyF6dO3g+ISJlM4YcgNOb1c2IibPAvHSJuAHWecRAi2AYIXAsuijMy/He?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7SH01BJ9eXUDa8oBzZ/Q2Fo+S0WeAkyPC64qvq80CxUX7IuGCts0AGFaaqS/mXilX4LsaLrLD42lNEDxrANYDpAa/xx3yljchpVLYfLOYqVuDiU0z+uB9kGTXbchvT5a2dIAHQ/MDVrLj+65k4GghUR+oNiQaMI1cRIe7LrZKE+T2GqGGb9e2ZkbGlufESdsY5wr38L/D7/OTyGhMKz9h/neG/kHU5PCxJNhLgCW+3hM9SrWByNi+wqLvUEwEGRjqFFNk+3cw0Of4s1yE92evosbefcLCRqiN3dZKGP92T2N7/R3jPrtMQVDrQ45SZX99vAoJROnhgpjXnvtRzKdnWk6gNsgIfJiPbVJumCNDFRffYYN2ocMMRk/OZRl+UVUqe8z7CMT/IFuOGfpXalu5PuXg0q+Uh0X0PHyLqE0Ke8UZD7U+ljrrFtlhvhOlD7I5HMMJsTBBPA3a8uh1hVvmK4Vst+F+B3rUHKtK1aLmmpFOJ5eWeZw476u95YzHJFuv0iFU9x0w7Crx81yBiwRx087KdabUlHeLqKPg6NuCHbhaW/alRepfZnQT6alRXIwIdVfWnebSFh2Z21dLiQLSJjuwyz4GkPJz11SPXzaulHVepzJ9VK20k5Su4YmMpNmTndXkmvQSdr9SWH0XCmSRJjEXG1m6MH0o0n9GdqvFS5O+RkhudnuzjoZfBtJ4ag2azklJ3ax1arDA1t++OFhZ4wFPDLv0OpuLxaBdwl97ARftAVpKxDHVZfZFMOIvbcxn/wShpDRTzzQGmqDi5k2JV7wBxr6G8CRCYL4Usp4aNT8duff4BiQh+dSC6CbjAuv
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ebf8c3d-a93e-41bd-815b-08db3a3e00cf
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:36:58.1708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHTrVVQArm118p11CWi9y8clIZJXXz+tTkbID6Sr4S7HXqMnC77l6boYUoRyOdXSWwsY+r/gnB7TcTK3etRnEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: wtpMWNo_R0iKkznS5yPEdtXyR3R6Huns
X-Proofpoint-ORIG-GUID: wtpMWNo_R0iKkznS5yPEdtXyR3R6Huns
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

commit 8aa921a95335d0a8c8e2be35a44467e7c91ec3e4 upstream.

When XFS creates a new symlink, it writes its size to disk but not to the
VFS inode. This causes i_size_read() to return 0 for that symlink until
it is re-read from disk, for example when the system is rebooted.

I found this inconsistency while protecting directories with eCryptFS.
The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
the symlink was created after the last reboot on an XFS root.

Call i_size_write() in xfs_symlink()

Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_symlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3312820700f3..a2037e22ebda 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,6 +314,7 @@ xfs_symlink(
 		}
 		ASSERT(pathlen == 0);
 	}
+	i_size_write(VFS_I(ip), ip->i_d.di_size);
 
 	/*
 	 * Create the directory entry for the symlink.
-- 
2.39.1

