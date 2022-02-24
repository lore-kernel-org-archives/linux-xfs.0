Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136C9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiBXNDn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiBXNDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8911A20DB22
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:11 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYR9i023280;
        Thu, 24 Feb 2022 13:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=U8ZLjaQmimby8uxWpQ0aVP4VUptsOuTsgbmxmOMYCls=;
 b=nJ58Se+iyQhhtjIDvCxNv+aC923k2x8QDqgfF6RxtfmEs95DmIJowyzbJrZf+Cfndveg
 eF2V+3Qd4TtGaFDBxVAr85u/G+Man94M/ejXuFJRWEu+KbWrWM2kJiRsh/oxzweGIpL3
 r9GdfXs99/8Ju7S9sc8B2RetVNV4865UE7TadN5eD7aTbn/c2veZL9JgfkBiTkWyxRlB
 iwgddm/aFCDoXz64B0FdjrrI11NjUl5GNUbYFD4/u+dZCI1LRPAe9CUdoYK+8JWa3XnX
 PXugNRalps2yertBzQ7D+7n5Pl8yVwcFUbARo5RLsDBVImVfKjN6LV0Wk+1jg64JRLLR Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0wvL002423;
        Thu, 24 Feb 2022 13:03:07 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 3eapkk420j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mzqu/onpYERaoixHw9/KQTNCQ1xMbTyu5G4WxG88JkHNvLRosHbbwRFmxW1cw66X2EXhd3UvHV3+RmadfnPAL3IPwegDmk0/xoExFgxjxnjt2GHxD2hZSuR8flmU9neMmIOcv86hw+VnszuvPsd/4BFxiWSoo9ERomBUJBLqLGGx6sBoZnUV/jaGjxHz7AYFCB8hqT625iw+P/MS8RKIazVttLGFXJr3HXKKFNTBSkL4L2vGCU88mU9s1mH9tz6ji6kBJqWCasnHqzhQGG3FOToqwPtAarYaOnsgEKH59Y5hzZY3apTH2BDFLd48J2bdwskWThDsI+fSgy6b6LO0uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8ZLjaQmimby8uxWpQ0aVP4VUptsOuTsgbmxmOMYCls=;
 b=aYnVyWRVgArwnCw8lzOIbUs1I+9+s+lxdT+iUs3VXjDLRW+QKnryCduc+V03IwqxerR8lycHC1VHh80BeMUdNTmVsIAmXkpGwQl0F7VUZD4LSWSb0jygUsxjUEuGgC6pMVFl2fDRLfnIPM/EcTLStcMhs9j0dk27Ppj2J5PmjDWu5IGtqmQQCLfhO+tP3um1bl1hEhfk3oHzmxAr+Z7Oei0zY/suKS4Qx4bpjHrYXowtIuU9gIhZv87x4Vb4mFuX+I7zm3oTRrTXK7SuK+3gQfLqQUB9heXVCBUb/iVPPJcTOMM///hcc+XHS85xXuzUvZjG4GMN6x4GNZ+sSjXFKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8ZLjaQmimby8uxWpQ0aVP4VUptsOuTsgbmxmOMYCls=;
 b=MNe88RleUbPJpI6dzFFfj3mgrocY1BVjV8O8On890euG7GXlKpv3Ir4iUqelJxGejbPcwfw9hY8MOHJZYvIaQaKhBtH8xyOLRb4D30L8R18cZ0zj7vvvlF6+xMsJ7NcrfWsObR59fBT0aJzZ5U9uMcr8LWFq9VAJXK2gG57KD1c=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:03:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 13/17] xfs: xfs_growfs_rt_alloc: Unlock inode explicitly rather than through iop_committing()
Date:   Thu, 24 Feb 2022 18:32:07 +0530
Message-Id: <20220224130211.1346088-14-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9759f216-db18-45b1-c494-08d9f795ff1e
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB217255EF2D89C1658A35DE83F63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: epNPKFoRjV9FlFNWvnZrPidPQ78KItoHqHkIuhVuMAC441Q6317LhFG/+EkGZAkibayR3ivjVT06eC96MfCfP5W9woOuLLi/emvk5SwB6OCQJPGaKLkAVlLCWBLxLDFM0oJ6HRZV8Ja0m1u4kA0NIUDc6kXeA7Uoyubj+JkVUgkADz6rXPqmDVxUWbFQHRlkB00naBm62nJ0/QZZnvb2APH72bbRe6AwbbOT7Fby0vppsgMtV5++HPWjxTaRVKxjiXwCTkp9nCaZph9lKM22jN6eUX3cCqQnS+IBiDlh58KZE5zPygX89++hvAAGIS62imhPq//719w6N0sY2utK9EaujTosgfJfE+97deTGAO60j7FKZ8Eg/6XckMacBcRQ1ItrqGw1dttpXA5iGWiJEa37ehx3llaUXnmcKgHnp1dVx1330ooHKLzGDSeXUhQcXuaw0m88FzyOCVgaUv3lyIkyv9zfqhqzbIMKE78ev78Op1aBgkiapDL+xOMO17Mduqc5JUEjSsZGMRCgs3H94hVDh1Adz1xHg5zi6yXM3BlbqtlwWKaG5JGj0+2p1Ld8PQUq4AILsP4eOIVYtYq1kWxq40jjqxfk6L4eMashkZoEPSoyhefndQUWBSPbCkSUAcGaozUdAJlA5I04d9dHe1QOrCANqAHA2L/tp4JBZ9m1TkGZFy4PF+R+TFWI/X8H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wpWyFpwrWv+fZzQdJ2qq9jnvejzi0DJh1tSxXbg4ceyhYx905wU9ghasiwBr?=
 =?us-ascii?Q?8EyMgaMFGXZQmppHAiyQebxP9urhNlYKrP7iURJqXul+aXnNNUQS8UUb/pv4?=
 =?us-ascii?Q?I2Bu+i6oP9SXeJMWpx0DEKEAgtA/hM+XRKXvit166D+r1cZGawhBYBy+jV36?=
 =?us-ascii?Q?ccj5i6rUAcx5K0X2hQC6U10JHZp7vo2dTAYr9cKGgjcP3SZUCb46jrMEzBty?=
 =?us-ascii?Q?4iOBrWmKOLfABeXPCXZNZ51CWey9hExT6nstg5u8CkCROFcFQSwiqt2rh6Zh?=
 =?us-ascii?Q?17jDexG7nOX/LkwbyOhwZg+HHCKCENEq1qqTSz0iY7XTxURDJYROB5iRqHR+?=
 =?us-ascii?Q?X/CGAo807F1HappSwWpZmyuXaN4daFPFF4hsRYFA/xNKxb9XlTOg+QouG8WJ?=
 =?us-ascii?Q?cw2g1bUhqIoEd3iRWZaXVkkjwCJnZ+066luEkDm6f3RqLvSvFJNWEq3zC7Y9?=
 =?us-ascii?Q?pq3jtIRsT3A3utuJMnq407TYbKNvCytf81S00yIkoDaXl9jNIVMGF17d8vFU?=
 =?us-ascii?Q?5AlsTQ5b1q4E84975pp4rZh9HIqWKWgIGIaL7PG+3JypWv2a1ho/+7ht7o2Y?=
 =?us-ascii?Q?DW4ZmPrdhwtp/AJSR6wOA22P02O7XS9ZT3PoY12bIFBomUQx9QpnqTqRRXd/?=
 =?us-ascii?Q?96d9NOB7m+5CFT8lkPSAlYBlwmWVcbGYgnSPHKJ3JWKXo568tTf5gnlcToPp?=
 =?us-ascii?Q?cjvaXTH4h2tXvvb+SatmLcfIZMuycrOlL7M0iXxEAUzWBLudfSTW0N37ttMY?=
 =?us-ascii?Q?1vOSt6LaUbY2DaxFn1F6NK5udbkZ0+EoaRtymfd3hzyjNvNImEbzx0axM0Wo?=
 =?us-ascii?Q?HMslCzgvlhQ8/niBTVbKibPi+BqOBLS365MJA+tQVBy43noppRUQuSG/byBJ?=
 =?us-ascii?Q?5hTjq4tDKaN+8AwYksoNqRxJ82nmiyAGFmzOVK4c7luAYuI+Nx28/nacQgcp?=
 =?us-ascii?Q?qSWRk71nPLguEF4FL3gGb/eO+i9Dtf31kvxCB2trS4JDF+QHnU1K6VBDB6Vb?=
 =?us-ascii?Q?0RkZllFlBxorsLyKRTphudkSZ10zDHKExh0WQtKxB1qar2bDkUpDz87XKD0b?=
 =?us-ascii?Q?72ueJsQmv8f41KlhhCYX0RkHvGcZwLyGpylmqZlekq0dxQfVToIccP3HTOxa?=
 =?us-ascii?Q?O8fNvm5Ed7WuG/Mre1Im/ILWd0P9oHkqCuGp91EBO+Rh0q67r8TLGoaU2bZZ?=
 =?us-ascii?Q?A+a0q2+yKts0YD2eIVaPnnqLLSu0hPsGNfbvDlcO0zocKS2z+/e/MYfMD0AJ?=
 =?us-ascii?Q?Xq9b1BpVlHYdS7l6WLs+PpaJZwdSmgeg2mcV+y4+XXKU7YQGkMHXhHKvsR/z?=
 =?us-ascii?Q?ba5uRgWVdB1vkdBikAgajaQhFm5wnDW6dUjc0wugEorvpDZLvif8zphxI1YI?=
 =?us-ascii?Q?IvsWN1OOO9o7cd/8AoKXv1foHiGNxP32QguZMQCC8Vgtqa4QrQ0dOKoKm6Kg?=
 =?us-ascii?Q?s7mRkizgQvC0apysYmUPf9TYHd+0Q9BA6kY64ACMPzmQGJbEjnzazPBH1f83?=
 =?us-ascii?Q?p4vbvHgeM82BWEcCp9u9+0T1BousR6KgZCgL0Yxk9K8CDuHW5v2gOOC95aIl?=
 =?us-ascii?Q?i1qWITgjbdTUnEREJrud2QMtOMsgPJlAh/MuRej8ICN4bpCJwEwDjApLgegj?=
 =?us-ascii?Q?lk8ZNylQA5BPmvOKgd+4HyU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9759f216-db18-45b1-c494-08d9f795ff1e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:05.4685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WNxKSB4WAzsHwd4GRofJsbIw6cJtVkDgS5/yFMBdTrflxri0cFLjET59AcPGo3is42/TKhPmPdBbcHP7TxqgyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: Ehy7gJ9T0maMMoUis0y1HU_WwHjIhDuv
X-Proofpoint-ORIG-GUID: Ehy7gJ9T0maMMoUis0y1HU_WwHjIhDuv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to be able to upgrade inodes to XFS_DIFLAG2_NREXT64, a future commit
will perform such an upgrade in a transaction context. This requires the
transaction to be rolled once. Hence inodes which have been added to the
tranasction (via xfs_trans_ijoin()) with non-zero value for lock_flags
argument would cause the inode to be unlocked when the transaction is rolled.

To prevent this from happening in the case of realtime bitmap/summary inodes,
this commit now unlocks the inode explictly rather than through
iop_committing() call back.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b8c79ee791af..379ef99722c5 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -780,6 +780,7 @@ xfs_growfs_rt_alloc(
 	int			resblks;	/* space reservation */
 	enum xfs_blft		buf_type;
 	struct xfs_trans	*tp;
+	bool			unlock_inode;
 
 	if (ip == mp->m_rsumip)
 		buf_type = XFS_BLFT_RTSUMMARY_BUF;
@@ -802,7 +803,8 @@ xfs_growfs_rt_alloc(
 		 * Lock the inode.
 		 */
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, 0);
+		unlock_inode = true;
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
@@ -824,7 +826,11 @@ xfs_growfs_rt_alloc(
 		 */
 		error = xfs_trans_commit(tp);
 		if (error)
-			return error;
+			goto out_trans_cancel;
+
+		unlock_inode = false;
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
 		/*
 		 * Now we need to clear the allocated blocks.
 		 * Do this one block per transaction, to keep it simple.
@@ -874,6 +880,8 @@ xfs_growfs_rt_alloc(
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	if (unlock_inode)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.30.2

