Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A006C4321E
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344374AbiDFJjv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584965AbiDFJgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFE225E8E0
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235Nw8e3004892;
        Wed, 6 Apr 2022 06:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Z7Yt3yFtrQG0i+Xe0ApYS7Wfz2lWrJEMLwKwrrUHkLY=;
 b=DJRcj3yhz+MR2ri0aHSsJQAggN778wRYPQcAU97aKk6cQu1oBzJXA6b+BcYLmpCyeAqP
 9ntO2ciEFLcpr2hH7Y6hNJg+WkKeabGNA/ID5p3dNISbbVgbyMkTcIE6WzrHzXCmHodH
 PFZ8dlIUXfSs2I4AgN7np2+r07fvol4xPrma8TIvp5tycbHR759ggpzKp/kmeQBIg7GD
 /rZ2SGSajiQ7r9D17410H5kPtx2T5RxDZTc3ibWmzqNWfAdeQCOqnB8kMkjF9XJZGQwJ
 DnGT5oHUknQKBkolzRHEoBll1Hwpuvp8WijA8zfr0NF+sRZ8i5uy2pxCLW/+uNHtig1U bg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d92yx80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366ArdZ022845;
        Wed, 6 Apr 2022 06:20:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48hdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaTewOmrutV0avDNQgFLCDhnziG5y1GuLVmcSrBJeWAmHzOAxwBmZDCm0XoSIJVkYyf/DUFttaCcQByDuofo6MPqc/F0kbGTARE+cnYIyT7AFLVg1Npu2nMSnLm4zmvluXBgZtYig4KN06s9m8SnhJIE/HFM2FeADC7DJy4aljvTYuJudtJ1OY3aNpII9q31xg7O1coZIhEry1ipTqo82LgQf/tftTsStuL/k8zxDBLkCfHg2mSIa5gdLh+T/zvR5hJdii73WofalzX73xXmXFlcn9GJQ/MsGvw5jDq1+2fVSUHT5s7Rnr9H4a7HtobAlwSyaiHRhhJ1Q1ZB5fq46w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7Yt3yFtrQG0i+Xe0ApYS7Wfz2lWrJEMLwKwrrUHkLY=;
 b=TBLE0ddbZ7RG6BBaytT+2c1e2c2s02CmZxFrkzyTj131nw7bElZ30eDFJ/1Dl+UV7KSobB8ZOx1IEECQdxnJBtPrLPuDszV2eArS8/KixnKMAkQW2nQSCZ8Bj+bBlnOt4Dbt3E819T79EaCiSYtv3Sk6UMRSIR1Ol9QLKOrihhXeygr2/nRz2CARBFqtvK5NWxoYMbsfYaHPZbGr6QPqMhF/TgtdVh0mxgJg8TKZBd+PgxN+UCku0gHl7OhPfWoQGFT0uPtZ9Ep4F84lDavc2dvcKgujBzKubJLkR8z/oh78Pix9GK0jOqnIcCJVoGQD2j1wmgcCEsDuJf7YxbiSFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7Yt3yFtrQG0i+Xe0ApYS7Wfz2lWrJEMLwKwrrUHkLY=;
 b=JOe4FuvVUq1rEDaeS8RRwdTXTjRI7bfPGWWmvygXnEQ4+WkSzIMTIh2KLK6Hwx7qcIg2wz9DI/pLSimDSNHuyLAHINEUNyGCS4QeJLB2Q87oTZN9GtV3wK2PSS9+tgnp+/HeAQ0fNT80y8mj86TnH6hkaIVK81cBWMQcPxcPs/Y=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 01/19] xfs: Move extent count limits to xfs_format.h
Date:   Wed,  6 Apr 2022 11:48:45 +0530
Message-Id: <20220406061904.595597-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c52f5c92-69e3-4610-a881-08da17957dd4
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB556470EE98E7EC548C34876DF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6nVkb5pjSXg3SRd/oe6QGYyIA+o/Ra31zqoXp5duLiMFMk/ViNL35685gySH9DT8XNNa3k0L3BbQWA0Z9udW/Ei1jNP4qE1v1CJkIyzq7AjZIug0u9/Bb2kEXoPNx94CRowt6//e3X4E3KhNITqL6KoyghVYWobtjvlkkj6JHXqh8M8t3FRE8/BuOdgABhY97kZZGnOi3W5xh5HxiBTs5Hz52DDneFQ389kWzR1asqXYpBMj+65FB9fRdhfly2PqMTsIBIjVONoE78poqbNEHETgUJEM+TBPTZB/7smPQFUvI0uK4NQI4TYRn0TO8Wp2lZh/wQn+1gCZM/Kj3Lcld7Szuhw9hWET47i6iaM2dsigYMvM6wHm7Cn2E6BV24/Fk21+yzR2KmJsVpuYRu/S/dz9/6fGfVMvUkGk3FWfPz2Y+m84yW8LqmpTfhnL6UK+20J7KVjIbM93jflc8Uv5nCg6ZPsE953dda4L3ByitNLYn/YnuzdAh2EaNvoSCE/z7C+0l3i8/wqpJ25BfhW44q+cJgPNzyrhONkeF4BN8lNcGm4OZigjmGVSb5PzSxcF+8sTaMlClU5BiHkeGPbtKCqsCk4dY7n8FslqqnYwqwoZcthLvXzrD09LUXUnsFnP9LP2MLqwmVpMgJwdQ9JcsPLdze9x0npaFhmI/VlBHMXfSdykVAFGX81pHPhldKkSxkN1qhi72BixqAilJ4F7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OV24t0CUSQtIXmbM6JMuZoy3kiTkBc62N7QseFtBFy5mFtMuJ2Rqt2UAdnya?=
 =?us-ascii?Q?GO4Ktzbe45Q01hhXNr0EIFtQVV/yuW6bjN8hmba3ZVq1+iuFbI6BlGM8N1Ds?=
 =?us-ascii?Q?nYWC/8ys0RQBM1H0E4ybAr/MKFyehhEl5kjXEnX63jHi15Dqt5Vic4TSiJto?=
 =?us-ascii?Q?53I5oI3L3UF4f5YUEDgGsmb/p1ToHfQIhOb9txTfUdhO/OuZ1lHgbYwLvkTY?=
 =?us-ascii?Q?ohvdE2EzZ+W18yQzTQuKw+CJwGT13w7TfrH2RPTBfPHZGHvda8AXWIw9E4pW?=
 =?us-ascii?Q?lYlNApVuBqKdLdv3sPbv4bESBLepGguf+KN6aa9ARLTnMS+X879DEwiX5Afu?=
 =?us-ascii?Q?T3d58UTov0rxW+kPnDln1CgR9PKSemXL5bBFoc0LDwihuOy2ircglpFeB9Y1?=
 =?us-ascii?Q?qOcHwLnAtwszsVGxeFrSuWEzTe8OEYRw9BZwtOwACXXr1dxoypeFLHwWbeHr?=
 =?us-ascii?Q?6v2+kNlAgZlCnF36/mTY1NQ8LqE+PjB7veJJ0mFleBU/DUNJRfER9ZKD188W?=
 =?us-ascii?Q?Ig+54IlmlT3nVe/pHqiMOC/z5vUThlzVuyuPBfiXzK8udx62y2Dlo3CUA6fm?=
 =?us-ascii?Q?YHUea/4MyXNiBXv5JzwmmIcsV88eTRtjaqAZHmo/4LeJNzURyjXpZ3pSd2Q0?=
 =?us-ascii?Q?eBam0JXoS46V6Iz8pUvbUr4GGhFo098/EJG9dIr8NsPYHhEBu0920RnpesYY?=
 =?us-ascii?Q?uPtHPQUvwtC5Vr4oqLXIasqelBhkzm2NhiIOpz9gCLQhMBSdvzrkS13NkP5M?=
 =?us-ascii?Q?nlPjc4Dmoy9c/8kgFVqt+Mil/xwEh9xjkr8OWFoWl/9KcgEDR3mvBdfSvpPX?=
 =?us-ascii?Q?ATTGqJ8CiAFjOoecBqelELKa0H+WbHK2M04DaYLphX5XUBXEcZeVkYhO3RpK?=
 =?us-ascii?Q?aF37O8wpof0113b8tdHwSBD/HICcMiylw0zTwq87/kJZe7n1/k5y+rUQW2zT?=
 =?us-ascii?Q?M/2esliBmjwrTylRPd+/gYXR3VRBwgC9ktvjX5UdGDObi3W/n/7h6dpjli8S?=
 =?us-ascii?Q?nybaBndDUHx78zyaj3OUKfutDzITK5PvRd9TbEVzdK548XH/MFEBp7aeIAH9?=
 =?us-ascii?Q?V4pCICxx3JE4paxSXQb48CCcUnH9ao9t0vmSiSXD6bQ84s/oG+Mo6l4v0eOs?=
 =?us-ascii?Q?ltZOOhDe9JuGlTBV5sgBTj3U20oT7tjnxTLFwg/YCjulMV1mpi8KU9mxNAcd?=
 =?us-ascii?Q?WppGVaGnTgxd/mE71kisXNq4d3icKMfr9ICDXVT8ihPD1CYeZIFMY+U5k/FC?=
 =?us-ascii?Q?Ilt3j56TSt3eKv+J3WqlmU2MdUh0LuvNIZgIuQ2FQgW6/9J9qSua3MOJvYsX?=
 =?us-ascii?Q?Vr4T7P9slZColuYejXLXOdvyLRpPGyXOo5fAkLY0y8aou+/H5ZfM2jovJZH9?=
 =?us-ascii?Q?IgYFv6irpA7+rCS9xJAYqrWPXRIHCOAaZqkbeMs8NzizkAAQYEXhjCZIoFZK?=
 =?us-ascii?Q?3AQuC6GQYNauPS2XPx7x/gJ4jNVx/sb9lpl+i31/0ppM3g0ZKvvj5dABROlC?=
 =?us-ascii?Q?MBeDkWQslnO8QCW0Q18GNqTSDy0cpSzPqqcJb25gSjl18S34t6WnhRbrVet7?=
 =?us-ascii?Q?ksCCXBOTVKBqwknETfkSx0+afrrLguD1o4yUMQrmwxbskftreUXj8dC+ix8j?=
 =?us-ascii?Q?rfnkfK7IidGpTdGY57FDE6bNfGdF4JumisBBcITR7bQbE8LXmqOtx5PmX4AZ?=
 =?us-ascii?Q?BH6gQSftv8KNm0NYnKcge3c6IolJ6KxV5ONumNn6aupYCMYbpJUfnhG5d+e8?=
 =?us-ascii?Q?jC8hNtrsnnGcqUG4wauL0nSyhgHv3zo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c52f5c92-69e3-4610-a881-08da17957dd4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:05.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Ci7jLhMGHYvspnLzEEUTeL0VeyX5XTh6flf1ZylRPZeUzjBaYiLfSbQBcIKo42KFmq1hW2qQfASpgUw8cVxWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-ORIG-GUID: ibYXLTaTgkie9NZ_QYgjdHonwFES1PBm
X-Proofpoint-GUID: ibYXLTaTgkie9NZ_QYgjdHonwFES1PBm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..d75e5b16da7e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -869,6 +869,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b6da06b40989..794a54cbd0de 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

