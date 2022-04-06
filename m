Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AB0C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243260AbiDFJkV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586126AbiDFJg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27BA254954
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:43 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2366H14T006378;
        Wed, 6 Apr 2022 06:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fRiTnEBM65hBM1Y5k/4wPJsCjZyYaAUZutTyEPpSWus=;
 b=lymAyWbA5AR1wJHcpHUlqkZQtZ+LAEMOvfjpeLdvDPg1m9EN5qMp5a5unzSS2P6APzM2
 xAYXHqu8z12NXdZP9sGKAm6uhHDVUQq+rFFkwltH5GLQHuyWMwDn7itcJPA5ANN+52Kf
 1nqI9ReML5KgyAO+Sf9W6ijDTv1P5balZhdTUaU7vuXCt5/QkVUAvaa/wzU0r0iW2eeb
 NJP7QuyvupAExwQQq2Bls/0svvO/otj/w3reeH4Vst749xXy+wxbMFw8FMCJ1kfdXslT
 hpO1uugYE/SwqKlIYiXLGatxUErlbbChvhIjuGawFgo/JL24ewpU562mYfwYnvxZA08z gQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31fyfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366AoxP024361;
        Wed, 6 Apr 2022 06:20:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48pmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9UccTSHIovLiWco641XJkWJNgKrp+77UtLfMI5GF+CREWCFhlXghjuoEynPg9J+FrE20g++mubTnwj48nojqPGiiMIU+/ZFyiB516nJY9FTDBwKyOCcu6/2vjD+axjixESKuskP8g+5QJWq0LH7sdtU+qildq1WHMEc+6RnLxXJLZCF/JiFq9T2GVHbIcJwr/97iNY8wgNoPb7RMIGpRQ0NcvwUGX1uYA1hmMtuMIiNU1r2RcbZtBR6T90LOuq0GD3bF5DHF2TKRNadUQo/JsBIUSBerZjJCBO25Y0HuqyrkCVYfEAyB1fyrTvck6bPqAaa38j6I16TjFABKlHymw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRiTnEBM65hBM1Y5k/4wPJsCjZyYaAUZutTyEPpSWus=;
 b=ZeqTS0e8h2YSTxMDgWD8clflzNN/JuQUdOO8b+CfqTrtDbISY+1TiRzFnQ27pLfz0x1YOuHasvcNWWfGVkGk86EBNLz261k/e1ZQzpStHOK0H3CmaFKFtj9dApoTI3LjferiTjwB7B96fPtRboJiJLdHyh7vVnjVviujN9ChPz8Jrp4QxdV54D1qzMSVh06M47BfEEURBrE2H8HE8v7Pu5zJfllMZv+v1IVK6DMCEHUXQKVuLym6ffsn5EQQKpKo8Dyfm10sx91bMIZyRI5WRlSHS85wFaEMGmYsvBoxXIOvA6jIBHPA6JnYWDZGlMyEeODSEYUabJWIolOfkumGvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRiTnEBM65hBM1Y5k/4wPJsCjZyYaAUZutTyEPpSWus=;
 b=NlR9/HalCEMkxzy1qjRsAoqWeuFSwP/AfGMWVfq9425YKQ1GsxLZnfKXBR0vJfyYvZgRh7TiJ3YFukb4BGyw2n2yTg9Mc7HmmMOcqNQBvaw/Lc7kVFLWiqeGhovjDBXD7jSZhnboqKM19cPmfSn65dLsUS7auNwQ+X8LLlfldtc=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:34 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 14/19] xfs: Introduce per-inode 64-bit extent counters
Date:   Wed,  6 Apr 2022 11:48:58 +0530
Message-Id: <20220406061904.595597-15-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0bee70af-7d3b-433a-da64-08da17958f2a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5564773234D9ACD0FB6D75A7F6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xSCKd+Ej58R8rkYT2OkW++K19ndfHqrmkygeZoHC56U3ePMPlVIEtf3w0V/5mk4E5wnyZ4/MbST/bgBldq5tZJrFbAGLi3FRRvlDK2tNrt5lFc2i9vqACUi4f0sycxhUSqenIQnBUKTlvh5SH9xhTXSwjiIMH6Kzk9R9V/b3pe9kYAg7ofSEQ08sEsBGwZSH8C8E7oWzmO8xOSiuAKf0cc8A/ATQJYdHDo/f99JBAai4GP+bByxKud3byWft8RaqaM1bKQxmKrZvfDqP/oIdbc4RG77JQVMCn2FrdTMarmj5O29AttYTIWa9PXBHy57Q9F7gFQIuGTq4bsy37WCzI6WiWxQOS2aPRj1vWTJthfw9qaYmqcXIA5DEJFXp14N5Bifw3jS8B9kPrCNhcn9qTtD7xa8xWQkIphunyYfDPlY3BsKvl3mfvFC+osjp8iMR7Q6XzxUl8+euzkutIf7lqQSP+da5wbkZnkbq59g4m/usz7qPpYJcP8OkeTDgGFbPb4weGhicnDuwb3swj8CD2Uu33Favh4I4XgcLWJJmXpSIs119PzyfkCzpGs2cz8W503EL+LBH28LiOFo1H4laBjNZkMdJUXTzZssu5Wea+weU49GifHQEUoRIbrXoEB0sgivTW6bU9QC1pD3b9FfmtqxygI/nsIbVdOPzQ0EpAvE6CWu1g2lu0XJ7vHHVzHufVgVyoCQIxRXjkfp6/TnIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NhZipDcTBAkKW+qTwhr/CcRgDr66DkWi7fqW3f8/FiU2feByx2EzTX6REmz6?=
 =?us-ascii?Q?FAhhUE0K3qlTLJyikHlRoGqDhMXQea0FNMhRlIrSbHzwst/t5aAVDbiwg8fa?=
 =?us-ascii?Q?XzFdMCGnj+X9Jd6aAjP/oYqlLIR2UmYHw/UTp9SS7sYS00CqF+0EZq9esuOY?=
 =?us-ascii?Q?BAsbQQhjAskaYpk9lkHLsFUw9B8Y24YqpYJEzW2GQxPHDfA+7LPn+qZh3f2i?=
 =?us-ascii?Q?3OKgSZjIK0ubu2Z/lVLaCLck20hki3Sx3q4rS+LEN6jcQRGKEyOtjMi0WtHD?=
 =?us-ascii?Q?P/oIA3BS4LLFAsXPke5gVUHY6mdK/aQxt+Trbnpll+yx3bG5XsSciXJthBLp?=
 =?us-ascii?Q?AJVOG6x1E2c+SdA4UuqMmvZtbeNDaFRNhi1CO8L9lg0pr1oLncwhqEd2NC3u?=
 =?us-ascii?Q?sjNFWVhpOaIXMNjY2+3TYlTidNThHCSVkV2rhrfteCcUYy54FuTCs37MCqIW?=
 =?us-ascii?Q?MaFl9pgCNEYyAFQGCb4f9z4lTHTEotiCBV42ePRe+AJIVP6uTlJeUGoSNF15?=
 =?us-ascii?Q?fSui1mJamPwtlISQNb3MdLLcGr8rGWL+Zx5X2SlQzAp8vi92fDwS0axeSHg7?=
 =?us-ascii?Q?n25Gd4oRkbMXNWGELzghsU7Ug9CSmhHJQ3sH/TwjwE3d51/Rh6/JbERumO2j?=
 =?us-ascii?Q?EL4kcIwhf6cty+o1F4GXxCCv8UNzNEehWxOrJvm7+142G8PTgPS0XclXogtL?=
 =?us-ascii?Q?Wg7GhyIFcryoHl+OH4aEvchIQYoWuJhdeAskhBGJz4eG4V/ffx+DWuoNzBkr?=
 =?us-ascii?Q?EvePjnIVSh/IgZ+a4nbkUzxMXGbuTQPFcdLMGVnT14/NVZ940oS0i3VTqiwR?=
 =?us-ascii?Q?nJ4Qs2IvANJ2b6do7GfZOS6jkIwLHle9Ae4URee27CgcWbD/K6vVW0rlvn9w?=
 =?us-ascii?Q?uMG2a3eVuwXyMfeRoaadpIkWCLBH9Lnn5MvH71GBAEQ28d0TRo60wpAgvCGy?=
 =?us-ascii?Q?4wo8pv++1fgx6Her9pkVSsxQaU1pHHsh9s/4HlNEYheqVJ7GsVzAXik4EvIZ?=
 =?us-ascii?Q?iIAU8xqiptY/jyBhWbm5slnN4u8Dlx6qPOF6B7/ea6HuDTccyVoAi1tVWFmw?=
 =?us-ascii?Q?APu8QGcGw1QmcIKfOBVZpW+BgDUwsjoCumIFieTAwe1kM3UlWCAsaG5uJ6Tm?=
 =?us-ascii?Q?OhpWNAC/qw0Fb7ASOot4H2jp2xUMsKjlTdFYI6+s2SfHrU4kbNRJqA82SPUj?=
 =?us-ascii?Q?IcNKfGUBlMqF71JopgD9g7e2AZ4A9FxyI6W6ojS3z8840M22lNDyy9ULGqh2?=
 =?us-ascii?Q?OQyVNc799ylyakGlLF/4JGMhVU00jbRDuCvyaB0r07SRyccgZZj9K/FTgTIG?=
 =?us-ascii?Q?cAOQ/wLHihTKgUvIcIpmYnC4mHWoW91wkl0l1XqmXlg2mP0pAyUI3OD+VCKO?=
 =?us-ascii?Q?SolV18y14F+QNWQQKkpEwbHBtGVSgt+f3e23thcrIMsQRH7QKsk1d8O8eQJ0?=
 =?us-ascii?Q?i6LR+PQu5DiE7EoCwHn6gEBbFXiQ7Gluhk0SinJlh+73qURPb3+p9+Pqk2Im?=
 =?us-ascii?Q?/psaVeO1EaIru8xwpkL8PmAOqCAC4ZerI65RlAl2GN3w4e/k0sP82h+FUXXr?=
 =?us-ascii?Q?Z1xvpk6qcks34FWzFlxXLyk0GUMaHKOi/moAZLPPSkPPO21uJVgOg1gDgLGA?=
 =?us-ascii?Q?zRy28EQb5yoqUxcJh4T4OZqCkREEUfF5+yhgsDAAYmzmGzyXKsvDiAuUSI5G?=
 =?us-ascii?Q?+V7L8dLXlFoNabO6Eq8V1DwDkLfbEMe8OFXOZcmd+6U//EYhlG5FiKIJYVEA?=
 =?us-ascii?Q?MihgOnfOK26xnEyL8zKQIe3BtJp7yr0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bee70af-7d3b-433a-da64-08da17958f2a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:34.6644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KedkktW7TiJjg7EQ6Y/M3Y7pwZ1TJZUb5DpYVp5d7kUjQS04YeCizGRqbZOpWp6XDDZ6unzAgQIX/bbKVdcN7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060027
X-Proofpoint-GUID: rXj2qvjY7HJULlssWquFW3JSYrqolYmH
X-Proofpoint-ORIG-GUID: rXj2qvjY7HJULlssWquFW3JSYrqolYmH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces new fields in the on-disk inode format to support
64-bit data fork extent counters and 32-bit attribute fork extent
counters. The new fields will be used only when an inode has
XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
data fork extent counters and 16-bit attribute fork extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h      | 33 +++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  |  6 +++
 fs/xfs/libxfs/xfs_log_format.h  | 33 +++++++++++--
 fs/xfs/xfs_inode_item.c         | 23 +++++++--
 fs/xfs/xfs_inode_item_recover.c | 88 ++++++++++++++++++++++++++++-----
 6 files changed, 203 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index eb85bc9b229b..82b404c99b80 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -792,16 +792,41 @@ struct xfs_dinode {
 	__be32		di_nlink;	/* number of links to file */
 	__be16		di_projid_lo;	/* lower part of owner's project id */
 	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
-	__be16		di_flushiter;	/* incremented on flush */
+	union {
+		/* Number of data fork extents if NREXT64 is set */
+		__be64	di_big_nextents;
+
+		/* Padding for V3 inodes without NREXT64 set. */
+		__be64	di_v3_pad;
+
+		/* Padding and inode flush counter for V2 inodes. */
+		struct {
+			__u8	di_v2_pad[6];
+			__be16	di_flushiter;
+		};
+	};
 	xfs_timestamp_t	di_atime;	/* time last accessed */
 	xfs_timestamp_t	di_mtime;	/* time last modified */
 	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	union {
+		/*
+		 * For V2 inodes and V3 inodes without NREXT64 set, this
+		 * is the number of data and attr fork extents.
+		 */
+		struct {
+			__be32	di_nextents;
+			__be16	di_anextents;
+		} __packed;
+
+		/* Number of attr fork extents if NREXT64 is set. */
+		struct {
+			__be32	di_big_anextents;
+			__be16	di_nrext64_pad;
+		} __packed;
+	} __packed;
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e0d3140c3622..ee8d4eb7d048 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -279,6 +279,25 @@ xfs_inode_to_disk_ts(
 	return ts;
 }
 
+static inline void
+xfs_inode_to_disk_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	if (xfs_inode_has_large_extent_counts(ip)) {
+		to->di_big_nextents = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		/*
+		 * We might be upgrading the inode to use larger extent counters
+		 * than was previously used. Hence zero the unused field.
+		 */
+		to->di_nrext64_pad = cpu_to_be16(0);
+	} else {
+		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	}
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -296,7 +315,6 @@ xfs_inode_to_disk(
 	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
-	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
 	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
@@ -307,8 +325,6 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -323,11 +339,14 @@ xfs_inode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
-		to->di_flushiter = 0;
+		to->di_v3_pad = 0;
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
+
+	xfs_inode_to_disk_iext_counters(ip, to);
 }
 
 static xfs_failaddr_t
@@ -398,6 +417,24 @@ xfs_dinode_verify_forkoff(
 	return NULL;
 }
 
+static xfs_failaddr_t
+xfs_dinode_verify_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	if (xfs_dinode_has_large_extent_counts(dip)) {
+		if (!xfs_has_large_extent_counts(mp))
+			return __this_address;
+		if (dip->di_nrext64_pad != 0)
+			return __this_address;
+	} else if (dip->di_version >= 3) {
+		if (dip->di_v3_pad != 0)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -442,6 +479,10 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	fa = xfs_dinode_verify_nrext64(mp, dip);
+	if (fa)
+		return fa;
+
 	nextents = xfs_dfork_data_extents(dip);
 	naextents = xfs_dfork_attr_extents(dip);
 	nblocks = be64_to_cpu(dip->di_nblocks);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 967837a88860..fd5c3c2d77e0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -158,6 +158,9 @@ static inline xfs_extnum_t
 xfs_dfork_data_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_large_extent_counts(dip))
+		return be64_to_cpu(dip->di_big_nextents);
+
 	return be32_to_cpu(dip->di_nextents);
 }
 
@@ -165,6 +168,9 @@ static inline xfs_extnum_t
 xfs_dfork_attr_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_large_extent_counts(dip))
+		return be32_to_cpu(dip->di_big_anextents);
+
 	return be16_to_cpu(dip->di_anextents);
 }
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index fd66e70248f7..12234a880e94 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -388,16 +388,41 @@ struct xfs_log_dinode {
 	uint32_t	di_nlink;	/* number of links to file */
 	uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	uint8_t		di_pad[6];	/* unused, zeroed space */
-	uint16_t	di_flushiter;	/* incremented on flush */
+	union {
+		/* Number of data fork extents if NREXT64 is set */
+		uint64_t	di_big_nextents;
+
+		/* Padding for V3 inodes without NREXT64 set. */
+		uint64_t	di_v3_pad;
+
+		/* Padding and inode flush counter for V2 inodes. */
+		struct {
+			uint8_t	di_v2_pad[6];	/* V2 inode zeroed space */
+			uint16_t di_flushiter;	/* V2 inode incremented on flush */
+		};
+	};
 	xfs_log_timestamp_t di_atime;	/* time last accessed */
 	xfs_log_timestamp_t di_mtime;	/* time last modified */
 	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	uint32_t	di_nextents;	/* number of extents in data fork */
-	uint16_t	di_anextents;	/* number of extents in attribute fork*/
+	union {
+		/*
+		 * For V2 inodes and V3 inodes without NREXT64 set, this
+		 * is the number of data and attr fork extents.
+		 */
+		struct {
+			uint32_t  di_nextents;
+			uint16_t  di_anextents;
+		} __packed;
+
+		/* Number of attr fork extents if NREXT64 is set. */
+		struct {
+			uint32_t  di_big_anextents;
+			uint16_t  di_nrext64_pad;
+		} __packed;
+	} __packed;
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9e6ef55cf29e..00733a18ccdc 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -359,6 +359,21 @@ xfs_copy_dm_fields_to_log_dinode(
 	}
 }
 
+static inline void
+xfs_inode_to_log_dinode_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_log_dinode	*to)
+{
+	if (xfs_inode_has_large_extent_counts(ip)) {
+		to->di_big_nextents = xfs_ifork_nextents(&ip->i_df);
+		to->di_big_anextents = xfs_ifork_nextents(ip->i_afp);
+		to->di_nrext64_pad = 0;
+	} else {
+		to->di_nextents = xfs_ifork_nextents(&ip->i_df);
+		to->di_anextents = xfs_ifork_nextents(ip->i_afp);
+	}
+}
+
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
@@ -374,7 +389,6 @@ xfs_inode_to_log_dinode(
 	to->di_projid_lo = ip->i_projid & 0xffff;
 	to->di_projid_hi = ip->i_projid >> 16;
 
-	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
 	to->di_atime = xfs_inode_to_log_dinode_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_log_dinode_ts(ip, inode->i_mtime);
@@ -386,8 +400,6 @@ xfs_inode_to_log_dinode(
 	to->di_size = ip->i_disk_size;
 	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = ip->i_extsize;
-	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
-	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = ip->i_diflags;
@@ -407,11 +419,14 @@ xfs_inode_to_log_dinode(
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
-		to->di_flushiter = 0;
+		to->di_v3_pad = 0;
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = ip->i_flushiter;
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
+
+	xfs_inode_to_log_dinode_iext_counters(ip, to);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 96b222e18b0f..2d8f9cfa7116 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -149,6 +149,22 @@ static inline bool xfs_log_dinode_has_large_extent_counts(
 	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
 }
 
+static inline void
+xfs_log_dinode_to_disk_iext_counters(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to)
+{
+	if (xfs_log_dinode_has_large_extent_counts(from)) {
+		to->di_big_nextents = cpu_to_be64(from->di_big_nextents);
+		to->di_big_anextents = cpu_to_be32(from->di_big_anextents);
+		to->di_nrext64_pad = cpu_to_be16(from->di_nrext64_pad);
+	} else {
+		to->di_nextents = cpu_to_be32(from->di_nextents);
+		to->di_anextents = cpu_to_be16(from->di_anextents);
+	}
+
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
@@ -165,7 +181,6 @@ xfs_log_dinode_to_disk(
 	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
 	to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
 	to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
@@ -174,8 +189,6 @@ xfs_log_dinode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -193,10 +206,64 @@ xfs_log_dinode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
-		to->di_flushiter = 0;
+		to->di_v3_pad = from->di_v3_pad;
 	} else {
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+		memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));
+	}
+
+	xfs_log_dinode_to_disk_iext_counters(from, to);
+}
+
+STATIC int
+xlog_dinode_verify_extent_counts(
+	struct xfs_mount	*mp,
+	struct xfs_log_dinode	*ldip)
+{
+	xfs_extnum_t		nextents;
+	xfs_aextnum_t		anextents;
+
+	if (xfs_log_dinode_has_large_extent_counts(ldip)) {
+		if (!xfs_has_large_extent_counts(mp) ||
+		    (ldip->di_nrext64_pad != 0)) {
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode large extent count format",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+			xfs_alert(mp,
+				"Bad inode 0x%llx, large extent counts %d, padding 0x%x",
+				ldip->di_ino, xfs_has_large_extent_counts(mp),
+				ldip->di_nrext64_pad);
+			return -EFSCORRUPTED;
+		}
+
+		nextents = ldip->di_big_nextents;
+		anextents = ldip->di_big_anextents;
+	} else {
+		if (ldip->di_version == 3 && ldip->di_v3_pad != 0) {
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode di_v3_pad",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+			xfs_alert(mp,
+				"Bad inode 0x%llx, di_v3_pad 0x%llx",
+				ldip->di_ino, ldip->di_v3_pad);
+			return -EFSCORRUPTED;
+		}
+
+		nextents = ldip->di_nextents;
+		anextents = ldip->di_anextents;
+	}
+
+	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
+		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+		xfs_alert(mp,
+			"Bad inode 0x%llx, large extent counts %d, nextents 0x%llx, anextents 0x%x, nblocks 0x%llx",
+			ldip->di_ino, xfs_has_large_extent_counts(mp), nextents,
+			anextents, ldip->di_nblocks);
+		return -EFSCORRUPTED;
 	}
+
+	return 0;
 }
 
 STATIC int
@@ -347,16 +414,11 @@ xlog_recover_inode_commit_pass2(
 			goto out_release;
 		}
 	}
-	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
-		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-		xfs_alert(mp,
-			"Bad inode 0x%llx, nextents 0x%x, anextents 0x%x, nblocks 0x%llx",
-			in_f->ilf_ino, ldip->di_nextents, ldip->di_anextents,
-			ldip->di_nblocks);
-		error = -EFSCORRUPTED;
+
+	error = xlog_dinode_verify_extent_counts(mp, ldip);
+	if (error)
 		goto out_release;
-	}
+
 	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
 		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
 				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-- 
2.30.2

