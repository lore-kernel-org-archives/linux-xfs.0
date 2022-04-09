Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FA0C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Apr 2022 13:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiDIN7l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Apr 2022 09:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242276AbiDIN7k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Apr 2022 09:59:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CF513D1F
        for <linux-xfs@vger.kernel.org>; Sat,  9 Apr 2022 06:57:32 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2393BdEs028018;
        Sat, 9 Apr 2022 13:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dfQWyFT9/CIjFG+/8OdaB2eZK+6ZGxHsKkhFV1Mwghk=;
 b=W0mr1DdHcjvqBLPqWovtqRzXKaQ9aJBYy0LioYTbTf4CbjLjveCrLWRc3GDw5ron6sbA
 aSw4gob67kxMdF9h8s5SLbiInlznoXx2DEbsklQUY3+F6gsul7/2caijxid62rIa3ZpR
 deQe2VpdgxGai/+AhiCmo4Hbf23l6aMYnKWFLX5P8joAvad6F/QfLLsnB/bKgujCDl35
 ogXziCILiHXFoQKnDRbTWNiuj1/ib0a3M/GbkjXohLy/1nV7RmCms8iMWQWSBul3mJax
 66hzKlmcyg2IdqEGWZqcx7kih6QvxYAJWhfQhnnORZT3WsnMo0SMCTMLXpOKN7vRMe/6 WQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219rgr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Apr 2022 13:57:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 239Dp1Li005579;
        Sat, 9 Apr 2022 13:57:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0jyugty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Apr 2022 13:57:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aua67UU5zNtMIZ0oz8e5jNHUm72/zQ+2+dPzTtTNNpgFJZMTut4G9x5mls+ei1WugsSF4Y4J+u2KC/4U6mNeYUN/8LumrTYgrrpziwNs9RsRhSTXsGFBuvraSzL8UWiWqCVD8HNVFleQlV3+GwhcrySssqWHU7qlRe1iboiWXhob9FVbJE8jhqwgTAadUDi/UL/7oyQ5uZK8vtDQjLIIT7Zy1+UXKl8GEMtxALs0Pw9AVjPHCQ2s495LbbFNwpwxE4sZZ/3PGCX36wUyx43dYwyXR3BSKYJ1y2dpnqtTTWYpVUG9aO/wbwJ5sV5rsm81fWK7MXnRvKz3OB71F7LT+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfQWyFT9/CIjFG+/8OdaB2eZK+6ZGxHsKkhFV1Mwghk=;
 b=HIzL7Q+JfRG+zVLbWiUWr+Z+pj3yVz2v9WDrH37Cli0GJrV+El3OGC4S0kohqil0bzYqGlrq6iAX6+H2W9r7W0u1Wxj78w4MYipHB13XOGVb1SCmyLxhB82lk3lWsvVCoNX+D+zpUKQcBHYk35WmFw5aJXSwTq4qAuRYUhec1NUpwqGpF29O7RszK9IpRGo4HKUgHoauZFauuHqcp14x5ycRwOKv41tRoxHvRF1D4OElTribpT5G8BaVL56uJfeBkqZk6iSLRv6p+aSWuFGPEf0HijraagkS/J9OTiRPGvu2/bwOQNxC4n+oTaAcOZIwCDKehA418y5PRyD8hZXLbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfQWyFT9/CIjFG+/8OdaB2eZK+6ZGxHsKkhFV1Mwghk=;
 b=OwwiCumukM3jnTg2L7BHqqCQzmZkNvVoUL6ry+4RWzlKLjBT/xUdmDSjU/y9UEsunn+e6zlXMsZgDHW96bFps1o0MrBsLjVSBjrVbzTWGLzOTmFoLxITSF6FJxdOAlJRhqt+OD5zsxlANbhxmba7s96WpkSj3rqKC2OlV0gETk8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BY5PR10MB4194.namprd10.prod.outlook.com (2603:10b6:a03:20f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Sat, 9 Apr
 2022 13:57:24 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.027; Sat, 9 Apr 2022
 13:57:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, chandan.babu@oracle.com
Subject: [PATCH V9.1] xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
Date:   Sat,  9 Apr 2022 19:27:09 +0530
Message-Id: <20220409135709.495356-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-19-chandan.babu@oracle.com>
References: <20220406061904.595597-19-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0014.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2635e237-6606-40ca-8184-08da1a30e01d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4194:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB41949C9E5DCFE6C0F3A9407EF6E89@BY5PR10MB4194.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ul7q5y5YwQF22mYza/K3hlFT/hnGpAe+mVaR2Ol3ilDjvlVLGiZeEb4oXa8JLg2hG+pm+P55Ayn6eR+ovJKQEPud+nJgSnaDGk8unb4nd8+rjaGm0i1r6FdC7SQQOXobcF2DoKspnUBBXTXei2dlZfKMFG+eN1EqOuZ1v+HLffI7cb/4i/t4xNZ0fsysVSJpeEd7jWKYuln5i6cCNgifJzDQTPNnP2B8MLIwMhJDCL3cr08poNdMeYaUPPSBHTvlvvrXKXIF0Xe8014Zw3WFhL6VHrW98dQDFQ7kdxyCb6GMihY5gyX065a41ym+4AIIVEPJzYsKZaOtI/l/fXOXbDxO7NDYZ88e/ClKqW2FuiWYyKgUExuvCvwcGaXQ4QzQC7i9Ln0x2kGHDotf7e525SuRRCpWz1PGnTrTDHwwK1NXFrdemIXLhfx25Cy57nFg4gvsuG3z8P7nN54VphpgJ6HpS8EHqrUXHtL2YpVMMDpkPGddy7Zfs4XKIw/nVVlqDmanU3CcHyXXuWUR7xrJD1yvKdCT3gu6oXRgixwhmTT3mntBUwsrrR7lhZ6+MpB+m5mvw+tV3AZRH6uNyXpGTKRdsLVtN/mbJzbohVeVc+kxiYnqE93hN98clF7vyA1mygZhrGrxSkwhlxFQeRLPmbVPy3sFSlyBnCx6kaj5/GRgt66RnEbDwiHGp9yqEDpSiqgXu6O2os5ilQItXVSN7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(52116002)(5660300002)(6666004)(2906002)(6512007)(36756003)(83380400001)(508600001)(6916009)(8936002)(86362001)(316002)(26005)(186003)(66556008)(38100700002)(66476007)(6486002)(107886003)(4326008)(66946007)(38350700002)(8676002)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xP6i//JltVlySgRQTsPl/riVaFeQtluwYsul5J9ch4IZ8lL4l3XZVd4a10Yv?=
 =?us-ascii?Q?NGKeWl4bNSK1MeZ7TauhYpEuLtfB8jZs7EHBd1q06bC8SGhlrdzR0zWiVYMA?=
 =?us-ascii?Q?mRu54WfF8NwuPZ+BaaLTS7BZwlRXwCrz/z6o7gG42Vlryq5zu97ldSM/s6ET?=
 =?us-ascii?Q?1C4neiixguR+FKkK7cYJ4QVhxzgQ3B7/kHJMO/GZ2BN4mPVJNIQ47bCjbj9E?=
 =?us-ascii?Q?1U9Ld4NDFS23mGEsI5yOv2ZTAb3JAbVQF2FnjL49voKrGzpqS9AQwCH9hNNC?=
 =?us-ascii?Q?YHjDPWbMrH3l2gTWxyZCJixd3Uae9D6wfRS5+ycJhmUbuTo3O0WQqOWzmzxf?=
 =?us-ascii?Q?gxH2HGWRlVKMhjSkeazhFh/FQ0prNtTvX7p6YAwTkqRnREc74mAvupAU58bs?=
 =?us-ascii?Q?NDYBvcgZRBswlgC0eY28RYEqIfCf2S0KQDRwN9YdEcOTC2WiyKk1a6n/ZiZf?=
 =?us-ascii?Q?HnY+WeLgumFlJ8VnVzTVzL6QThcuCQxqWQK+F+0B+tKA/cHHcLsaK4kr6tZ1?=
 =?us-ascii?Q?UKUSWnWq7tbVxAEKbxDoCwbsnKlhzkIeRP0GCfLSN2GOwzih+w/u+7GFFszF?=
 =?us-ascii?Q?yu+keXAqDijIyJMd5H/XHA1uCDFsoANGXHjIcVwL+fczg+jbVakufwE62DOo?=
 =?us-ascii?Q?3Wwa2XZFIvTHDTa6xNCXYQ5a9qnViFnIF8Beb4iBYmlqtYhlsHlS9n/ddHPL?=
 =?us-ascii?Q?O5iR+acNcf22VfBC9a/iHh2vup8INQubS6khI+ULBUddiXaMa7ZKoNyLB7Tx?=
 =?us-ascii?Q?lOphrI/B3JLchIZZxsETJTzlFwfNY5eoV+knMZpJRvpMrPPZPqFsS8JjbWNO?=
 =?us-ascii?Q?jyRNO7ZSonuFgR5byj2Sac1PRA+JNrUOegBW/Q1Dnnc+cDZqX+Qo7AqduZoA?=
 =?us-ascii?Q?dzMGVEPOoWPeaMM+GvZuoDbzRmC00BB4aQWZbhM8EdIMYqxJNk+slbf6VvG5?=
 =?us-ascii?Q?3wOK34XYhWFAB2h0zE24gUvw6/PTh3DJ5JA13FEsJ4VI8ZaZYsZMDC3SwKUJ?=
 =?us-ascii?Q?5hbzzuD9krjVrWRTMd6c4FLJP5sCt3B4c/pJxfAGxfKHwAskzCJICh5UGG/T?=
 =?us-ascii?Q?K4MAGTA0xLjlFEnE0D3LvTjvhfHVKir3z3FHXNVkMY7bN5JvzHSByZm8snLs?=
 =?us-ascii?Q?CUp/Yv49dyPf4KTqan0sjofMXnqNV5HK/iaM4rox8+zmj6joBmPwFWr2Jcmu?=
 =?us-ascii?Q?e2ltnyhlFjhK3YyNy7PMYGk+uAMtqfRYIUSYhpusvgiX/3BA0mlwJ9fjGVZ9?=
 =?us-ascii?Q?e3UiNnhLHasKmcOaO8dcYc0qrhUf31CKrk6cbU3eVx8/8ZeWMBa+e8iy95Hx?=
 =?us-ascii?Q?AjePzfFR30Py9PiiwuwkvTMxTunZ2ReuuEcaRctk+IRYHifTNCXYqV2OI6DV?=
 =?us-ascii?Q?d5AUkHs3ZkXrWSm5gzHHQf5CJcqu3mWFjm58EGx9qZdy3l1Jjh4ooLjhCmIg?=
 =?us-ascii?Q?Dkom03QuBZ74mr3ImlmDGvThu+k25kH5ZzfNvl1H+2w22QQtVMRJHPcl8smg?=
 =?us-ascii?Q?9ANEKo6H3swXH/cb94UYVet4aKFawXcXeuRwrYbtG+vxRDVI84NFTGwHfVJ7?=
 =?us-ascii?Q?IsjSmQcWLsgRUAlbZYaGObeZ5GFUwdUvk3USmpO8pbk3ORehTA7kahZpuke9?=
 =?us-ascii?Q?mCun59FHgTQKtcTAaPgh6C9GYr7n6iwYA/V7m2mWkP90GWwHjuwFLjFLFxi7?=
 =?us-ascii?Q?frlk66QPAk+1l8gN/5JBkZEqr3EsIlOngLkC0NBV7mIt3YB0h2Rkc+/hg7ru?=
 =?us-ascii?Q?+SlKpUjgQ6DRtSN7Tgt5yOSv4fvsJPo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2635e237-6606-40ca-8184-08da1a30e01d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 13:57:24.8053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mbAQNcRh+KXwR+rZvPpFp8795FK/h0Ef+azH0jRKCoeKynpfdQfjTPzq5Hf4HcimouLJ9vqtmOGLdg1vS+oqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4194
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_09:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204090093
X-Proofpoint-GUID: qJMUEPExSkROxXy9Cmcd7X4qc3PaQ_f2
X-Proofpoint-ORIG-GUID: qJMUEPExSkROxXy9Cmcd7X4qc3PaQ_f2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes are made to enable userspace to obtain 64-bit extent
counters,
1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
   xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
   it is capable of receiving 64-bit extent counters.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
 fs/xfs/xfs_ioctl.c     |  3 +++
 fs/xfs/xfs_itable.c    |  9 ++++++++-
 fs/xfs/xfs_itable.h    |  3 +++
 4 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1f7238db35cc..2a42bfb85c3b 100644
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
index 83481005317a..e9eadc7337ce 100644
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
index 71ed4905f206..f74c9fff72bb 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -64,6 +64,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
+	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
 
 	if (xfs_internal_inum(mp, ino))
@@ -102,7 +103,13 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
+
+	nextents = xfs_ifork_nextents(&ip->i_df);
+	if (!(bc->breq->flags & XFS_IBULK_NREXT64))
+		buf->bs_extents = min(nextents, XFS_MAX_EXTCNT_DATA_FORK_SMALL);
+	else
+		buf->bs_extents64 = nextents;
+
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 5ee1d3f44ce9..e2d0eba43f35 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -19,6 +19,9 @@ struct xfs_ibulk {
 /* Only iterate within the same AG as startino */
 #define XFS_IBULK_SAME_AG	(1U << 0)
 
+/* Fill out the bs_extents64 field if set. */
+#define XFS_IBULK_NREXT64	(1U << 1)
+
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
  * buffer is now full, return the appropriate error code.
-- 
2.30.2

