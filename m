Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BDBC64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCHWix (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjCHWiv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5685ADF9
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:49 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwgsP007266
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=/8yCf80a3UVJE56blLxnuFxp/oVL5re5hI1WSsPMdDY=;
 b=UuZ5wnbuTWPBV+G47/k32pw21z5/+8wCwXezqHWTw4PEW2EcHLtWXTtAXKLy4ARys4N8
 HfLy+8GI1BJLOJnpf5OWtbGMN2hJGPCvVPwyd6NAuE1l4cONxuHY78IoUnEu/yns+i39
 mtimxJGsw/22o4GZcaQILGrdTk4tWS9Q6MB8Pz04OCOhM3D8eJXy/JHOybtqDfSOTkCl
 p2S2dghtg+z+DnKqCvdpWHIVOHebyRoWl6NpABJI0PUrpjFO/KueSXE2h6URYVMCKdD9
 FlkO3B+DaevFlla1eGANkylnIG+hGI6mRmzzyRw7wNkoUl+OnhkOT+c+LAMsuQZ9L/AH zg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415j1fc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MNwmL026505
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:46 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9uc28k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yb65lNEj2QGWQvvoa6grZ07r2WrXRXD6nqZxYOfxPzjy+lncpz/ypBhAoXNwLbnErcPkY4MmU8d73nUZqQCxwwhEMmtG7RqtjRgIC7z4uDo1wm6V5zfGNVWnwWIJWnfwKVh6bFHkfHLtW94X5nXnmetBmqq3sOSEcKjASUp4iDLnuQ2WFvKKGfJzdJsSSfUvSuPv4LnU9yS2iG2ttCgIQN5BK4LZpE4hWw27FpiwmGlYf5eKFoalonzM6Og+y1w/PlKhSiEZNdKQTTxuomJgXBBUPZm9jCH7i4l16vpwvMVs3kxXc9sObGqz3WrrvZn0MCxGos7o6dockiuxJmZNBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8yCf80a3UVJE56blLxnuFxp/oVL5re5hI1WSsPMdDY=;
 b=AcDdBohE1oW4hI01pX1rKykEdqLm4n+FeT9mLI5H9IB1zX3VKsh7lZq41e+srXXRr6fAEfVrFdkAqNvqk5Bot0yKDX6FIurqJZHsz4zD9oWNSznW5cwUarw8FQ4D+JO0gyAvPLSFdumCPjB735vcha+zQv4JhpJozZBbw87cytLQs/eT8Dvs/JReHfYM+Tyel8GU09pkYKDD6S3x/OEzFLJLL2tq9hiEhwAtQobsHEvvNPaWjGlV2i6bz0HAtqJy3c9uv+KCWUJMLR99jKUGV+8hMSwACWnfmERbAw6jNAxJV0E0ZpfW4EufLLQO0mLJMmmzmX/bbWa9CFf8Ves9OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8yCf80a3UVJE56blLxnuFxp/oVL5re5hI1WSsPMdDY=;
 b=Azwt1e4xMEaNQfsLX8EWHO83ikpwq5sCZk0VyDjccmKgr17aYtY4zPcmuDblF0E1qtpUg5uYtv5NPVgwHsjyr4wlp61QfHh5sxJBu844y4WXaw0g+HzmIgwgQzn/INb/fRTL2SPM7Unf+94MnnegeEvx47AQY9mgl0eow+uGyhY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:44 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 26/32] xfs: Add parent pointer ioctl
Date:   Wed,  8 Mar 2023 15:37:48 -0700
Message-Id: <20230308223754.1455051-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0103.namprd07.prod.outlook.com
 (2603:10b6:510:4::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f2d5e3-3981-4ffb-21e3-08db2025dfb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UhsdVT+AiSjswGmXjgSokGMgo8oeE+1JabhgT5kBf0RCgsMFRgeH9tEtsBPb8HRqAK5tuCDmH33HygoCTpWj9dnH7HtEBc7K8HXGW2XnDFyQxxutUfZHh/Dr1m7J6jbE23cfXopRxWSyk9qxYYjI+ve8EeGLEZeMDLrTdgZlyUo+IwvOsuNtqxdqOk2om3QHJVesiw7FU55GgMt/lxG4OOJvk2IMAUzF9pYvGxG3iDlGs7LlOdvGvfOUBTiWKefmnrHbu7PQYopMB6+ZEY6Z6PudpvKeodj/AeTcy9HJkavDQcHlzSpH7LW5aXVM5Yati3BIy580TRRK/XV/2W6Hk1fAawiZ2sqckKisTa11LaljecK2mntmjVCqDL6iwSV0+qvbrg9OZs55HvLgVjkHxK4Ek6MvB9QcRf3BTh0AHqnitGw3HMgOX/QOMUvG8+KCeUcGrymePsHrJjvAqbEyahnvXDzAh0dmq2y4Q1WrUifoCNPQisrGTOdqEGL68/3yuQOg31YhRGbRjvE1n3CpcItrPT7iVujggp+cL9k3NtZqDaGI54ki7urN0mXjsdoYqhBhPVGb4ZoyIMfdi8LumAzSfxLyAUkn0O1IRkItNtrBHiGGf7sY29DKaAL76v+PwwREwV9EtM1VMcMQigh64A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(83380400001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XVttGJLVRcdEXdajyjppM/WzNTLIUcNrbn+s7XQz66ELag86vVI+Y96y9ldQ?=
 =?us-ascii?Q?cav1HFuuo5n1THYCuHmr6hEp+1nAz9U2URSms2ZMAiPKctJ5r5zDQOKsQsvp?=
 =?us-ascii?Q?C9hE3BJJes2M6tdOl+HbHBHLrHOe5MYYXIXjraE6KCeYdFs8no64z3/u/GPF?=
 =?us-ascii?Q?jp/zW9+TkE1om8HZecUO9hnE2tIcw7RloM0guG8+q2TUy9nWx/h16LtJi7vJ?=
 =?us-ascii?Q?EbJzlFH33jGJs/8s+9iiOBnhQaGG1U50Iw7AKvo3bSw+WuNI+5t1gtcj5/48?=
 =?us-ascii?Q?u3GMhMlD6jjzy/yrGS3rdJqMct0ynh2qYpcZr44g8+IU7AZK7J//n5OgsBgX?=
 =?us-ascii?Q?Zh014mmPCggGuGucBo29SfbMTG2pIpl7DtXqMkEFj/W2NCymc/IWaFapMzbh?=
 =?us-ascii?Q?3Vj5iChtbHY+ceJROEm8CiM0b+B2phWV384PlwDWl05mFs9ZvweqD0i410Iv?=
 =?us-ascii?Q?zzWNPV0MvL8jALyY1BON7F+keL6t1V6canmEn5lRjOK4Ht1fU3Ki4iJ+uO8/?=
 =?us-ascii?Q?eht2JFXhNxU69baaI5NrvuQHqYxxa2w51lS75LlciO1BYA0kqvEdIHjpjF9l?=
 =?us-ascii?Q?/NIMmcbqDmFPvrcWkLPEJpraDMBQf1W37lw+WgArZHPqy1GcNvoLFhU//jdW?=
 =?us-ascii?Q?38RBScSpWnNi+hLE1LEBmOp7yIXrC9oop9MNP7pVj0Su72703pJe03J72msw?=
 =?us-ascii?Q?N7gbmo1ZlajO/oeEpvsgZzvjqXsZISly5Nf6nyEvXaENetMfW1IToVdMoi0n?=
 =?us-ascii?Q?KPkvq/Smbh2eDW+qdTMWJ+53gy+85wG3C8lLSmA/kwAWJxIW59VjBsvUiwb7?=
 =?us-ascii?Q?u7nepUx3cVrAXLDbKHRSW5226MYJ6l4HuNW2i7KH6aK2eOQu+tYwacmRTZtD?=
 =?us-ascii?Q?gs45PX7+m5HzLfXcboZFRS+OnQrMNcG5ycM61xRUpUp8Lh/ft4WYhblR8I7M?=
 =?us-ascii?Q?wJEV1XDdd6WTPR9A8kgXQ6T5k3Bmx4o6pzsgMspHA9I3PEqhmpNVrfNWlL4f?=
 =?us-ascii?Q?ViIfHOtv61tAGmkppoqNgZAaH6qMym8xFK6A5vj9l8LA8ZtLIEQgo+AZ7XuT?=
 =?us-ascii?Q?IdrCi04ABK3jaVDyoOdDM50J7zhMbwM3LvTq177eYZKPD76u3Kpu5qnE8RIG?=
 =?us-ascii?Q?i3aOuinaiKHS25Ot5yQwlAfxHhk4x0NMEUUgtm/JBr2Rm7Rz8KtNK1jHiUeb?=
 =?us-ascii?Q?bi3eFvYbBC9tF+mKM5GzAfdmS4e9CKA/uGSBE9iMQC6u9w2gIj/AhXlFLLf1?=
 =?us-ascii?Q?NW5P3CzSeuRRYKFcwrB7MO5uLkmHgvfSxOB3r2Bdb7nxEbT+SXqYV2gK7DpP?=
 =?us-ascii?Q?W7f6N6EUPkXDNA4NhhCLZRVQ+6IMycwhvT+IbGvkbn5P/PPW4DINLWsa+VV9?=
 =?us-ascii?Q?M5BgkNDHTpU/aNllKecgdz8j3RXL4/6VICADScQH4AFGEr3EXl5MYZSkYDiN?=
 =?us-ascii?Q?qBG11Wwbqozi6C5/Xqovc8KNfVSbB2HG5B+8Y4TdHqXoCbvZP1FPQy6ML8H8?=
 =?us-ascii?Q?agvgpZbAKtq+ctcAHJh50fqh4qHlvTxiJS/r3WWsMfk4MhUHwrs0xUo1w+/3?=
 =?us-ascii?Q?HMJ+u570tLAtKMrOwPeSS5MjwPdJA9w05OE+yqpiV/5bbB0mewpLgtKXZ+65?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8+87P4IZ8QMVD8WZCJIvtsUQhvtz3Jncj1Nts6ukmAOrL8vavd5dFa14Jbtc63yfVKBwifY9lrRzNTsIBIuCppl5CxzHDn8Pk8arJs98eE1heZkS5jxcheiDGWn5BtNWPjk9t7iNKNzav2CDMkWZMNnl/T3w7beFenaum4624x1uXxcpiFIVhlIVVjwgU3bMYXANvr1s9Y5C/n/pa8w0t8cach4np8mDz1KLxDWOVHwyMpZFZdZ/filhGlMP8JNb1dvyv2DF3VajHVVf+Llk6GrODBn7w7wZLXNm+UURhvEvWPUujrPFP6jMWhJ+H5tMiyrUFTtAtRAEKr7EmE9Ft0q8N3c06a/7np0d3K+FVksHJEymW4Z+xkk+VYULcBZb43kSDapwDVgS2snJhB/BWc02j40UNbaYEpgMk3q/xsdQcdZW9X/kRTZCpqLnxc+tbvtU/vldAwS537hvODlPu+o+R5muHcsIUweSwORW23KJkTKclhSOSci9//gaDT/uxvXNG2RpBZOSNK0osfCkghLDAqVUVqPNExLGZ/chatMB0IOSxNNplwzYZIUIw91Sc53FOc8Di5VeiW3bktm01LeSyrtSLttDrQiuXsmF3eGL62I4G2UDAKTp3BzR0mrNIHu0i2QQzhvSn8ldg0FgFeFmDDP8BTp6gYiPxGrbFOskauGeBGKsGiWpJ3/OoqCq4vybPIf4EdZ4Yye6OOmtdyzEVjvqYwu5A0w37Ku9X3oQw6i9I7+V9Ugidq3m950hXrGUBK4u2W+EUCcAZQ8wMw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f2d5e3-3981-4ffb-21e3-08db2025dfb9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:44.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5XM7JES4eOXKz431kQsylNZ5lLDiS4pg8tHiH8U7zhVonk/J459FfySFAhUqkXv5h3Uhsz/vU7vK89rTqhtVkX2iLrrMxGZ+RhRB+J1P2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080190
X-Proofpoint-GUID: qPh_u6Mqi5kG_i37-TVRYjEj5UnX4DXZ
X-Proofpoint-ORIG-GUID: qPh_u6Mqi5kG_i37-TVRYjEj5UnX4DXZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  70 +++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  30 ++++++++
 fs/xfs/libxfs/xfs_parent.h |  19 +++++
 fs/xfs/xfs_ioctl.c         | 135 +++++++++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 +
 fs/xfs/xfs_parent_utils.c  | 154 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  20 +++++
 8 files changed, 432 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e2b2cf50ffcf..42d0496fdad7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_pwork.o \
+				   xfs_parent_utils.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b0b4d7a3aa15..0db0c8fc5359 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -752,6 +752,75 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+
+ #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
+				XFS_PPTR_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u64		xpp_rsvd;			/* Reserved */
+	__u8		xpp_name[];			/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
+	struct xfs_handle		pi_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* Operational flags: XFS_PPTR_*FLAG* */
+	__u32				pi_flags;
+
+	/* Must be set to zero */
+	__u32				pi_reserved;
+
+	/* size of the trailing buffer in bytes */
+	__u32				pi_ptrs_size;
+
+	/* # of entries filled in (output) */
+	__u32				pi_count;
+
+	/* Must be set to zero */
+	__u64				pi_reserved2[5];
+
+	/* Byte offset of each record within the buffer */
+	__u32				pi_offsets[];
+};
+
+static inline size_t
+xfs_pptr_info_sizeof(int nr_ptrs)
+{
+	return sizeof(struct xfs_pptr_info) +
+	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+}
+
+static inline struct xfs_parent_ptr*
+xfs_ppinfo_to_pp(
+	struct xfs_pptr_info	*info,
+	int			idx)
+{
+	return (struct xfs_parent_ptr *)((char *)info + info->pi_offsets[idx]);
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +866,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 629762701952..cc3640be15d9 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -61,6 +61,36 @@ xfs_init_parent_name_rec(
 	rec->p_diroffset = cpu_to_be32(p_diroffset);
 }
 
+/*
+ * Convert an ondisk parent_name xattr to its incore format.  If @value is
+ * NULL, set @irec->p_namelen to zero and leave @irec->p_name untouched.
+ */
+void
+xfs_parent_irec_from_disk(
+	struct xfs_parent_name_irec	*irec,
+	const struct xfs_parent_name_rec *rec,
+	const void			*value,
+	int				valuelen)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!value) {
+		irec->p_namelen = 0;
+		return;
+	}
+
+	ASSERT(valuelen > 0);
+	ASSERT(valuelen < MAXNAMELEN);
+
+	valuelen = min(valuelen, MAXNAMELEN);
+
+	irec->p_namelen = valuelen;
+	memcpy(irec->p_name, value, valuelen);
+	memset(&irec->p_name[valuelen], 0, sizeof(irec->p_name) - valuelen);
+}
+
 int
 __xfs_parent_init(
 	struct xfs_mount		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 039005883bb6..c14da6418e58 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -8,6 +8,25 @@
 
 extern struct kmem_cache	*xfs_parent_intent_cache;
 
+/*
+ * Incore version of a parent pointer, also contains dirent name so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	/* Key fields for looking up a particular parent pointer. */
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+
+	/* Attributes of a parent pointer. */
+	uint8_t			p_namelen;
+	unsigned char		p_name[MAXNAMELEN];
+};
+
+void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
+		const struct xfs_parent_name_rec *rec,
+		const void *value, int valuelen);
+
 /*
  * Dynamically allocd structure used to wrap the needed data to pass around
  * the defer ops machinery
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9abf47efd076..f34396fb2e88 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -1676,6 +1677,137 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+/*
+ * IOCTL routine to get the parent pointers of an inode and return it to user
+ * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
+ * followed by a region large enough to contain an array of struct
+ * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
+ * more parent pointers than can fit in the buffer space, caller may re-call
+ * the function using the returned pi_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in pi_ptrs_count.
+ *
+ * Returns 0 on success or non-zero on failure
+ */
+STATIC int
+xfs_ioc_get_parent_pointer(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_pptr_info		*ppi = NULL;
+	int				error = 0;
+	struct xfs_inode		*file_ip = XFS_I(file_inode(filp));
+	struct xfs_inode		*call_ip = file_ip;
+	struct xfs_mount		*mp = file_ip->i_mount;
+	void				__user *o_pptr;
+	struct xfs_parent_ptr		*i_pptr;
+	unsigned int			bytes;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Allocate an xfs_pptr_info to put the user data */
+	ppi = kvmalloc(sizeof(struct xfs_pptr_info), GFP_KERNEL);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	/* Check size of buffer requested by user */
+	if (ppi->pi_ptrs_size > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+	if (ppi->pi_ptrs_size < sizeof(struct xfs_pptr_info)) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL) {
+		error = -EINVAL;
+		goto out;
+	}
+	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = kvrealloc(ppi, sizeof(struct xfs_pptr_info),
+			xfs_pptr_info_sizeof(ppi->pi_ptrs_size),
+			GFP_KERNEL | __GFP_ZERO);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
+		struct xfs_handle	*hanp = &ppi->pi_handle;
+
+		if (memcmp(&hanp->ha_fsid, mp->m_fixedfsid,
+							sizeof(xfs_fsid_t))) {
+			error = -EINVAL;
+			goto out;
+		}
+
+		if (hanp->ha_fid.fid_ino != file_ip->i_ino) {
+			error = xfs_iget(mp, NULL, hanp->ha_fid.fid_ino,
+					XFS_IGET_UNTRUSTED, 0, &call_ip);
+			if (error)
+				goto out;
+		}
+
+		if (VFS_I(call_ip)->i_generation != hanp->ha_fid.fid_gen) {
+			error = -EINVAL;
+			goto out;
+		}
+	}
+
+	/* Get the parent pointers */
+	error = xfs_getparent_pointers(call_ip, ppi);
+	if (error)
+		goto out;
+
+	/*
+	 * If we ran out of buffer space before copying any parent pointers at
+	 * all, the caller's buffer was too short.  Tell userspace that, erm,
+	 * the message is too long.
+	 */
+	if (ppi->pi_count == 0 && !(ppi->pi_flags & XFS_PPTR_OFLAG_DONE)) {
+		error = -EMSGSIZE;
+		goto out;
+	}
+
+	/* Copy the parent pointer head back to the user */
+	bytes = xfs_getparents_arraytop(ppi, ppi->pi_count);
+	error = copy_to_user(arg, ppi, bytes);
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	if (ppi->pi_count == 0)
+		goto out;
+
+	/* Copy the parent pointer records back to the user. */
+	o_pptr = (__user char*)arg + ppi->pi_offsets[ppi->pi_count - 1];
+	i_pptr = xfs_ppinfo_to_pp(ppi, ppi->pi_count - 1);
+	bytes = ((char *)ppi + ppi->pi_ptrs_size) - (char *)i_pptr;
+	error = copy_to_user(o_pptr, i_pptr, bytes);
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+out:
+	if (call_ip != file_ip)
+		xfs_irele(call_ip);
+	kvfree(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1965,7 +2097,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPARENTS:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 9737b5a9f405..829bee58fc63 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -150,6 +150,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             96);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 000000000000..9c1c866346eb
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_parent.h"
+#include "xfs_da_btree.h"
+#include "xfs_parent_utils.h"
+
+struct xfs_getparent_ctx {
+	struct xfs_attr_list_context	context;
+	struct xfs_parent_name_irec	pptr_irec;
+	struct xfs_pptr_info		*ppi;
+};
+
+static inline unsigned int
+xfs_getparents_rec_sizeof(
+	const struct xfs_parent_name_irec	*irec)
+{
+	return round_up(sizeof(struct xfs_parent_ptr) + irec->p_namelen + 1,
+			sizeof(uint32_t));
+}
+
+static void
+xfs_getparent_listent(
+	struct xfs_attr_list_context	*context,
+	int				flags,
+	unsigned char			*name,
+	int				namelen,
+	void				*value,
+	int				valuelen)
+{
+	struct xfs_getparent_ctx	*gp;
+	struct xfs_pptr_info		*ppi;
+	struct xfs_parent_ptr		*pptr;
+	struct xfs_parent_name_irec	*irec;
+	struct xfs_mount		*mp = context->dp->i_mount;
+	int				arraytop;
+
+	gp = container_of(context, struct xfs_getparent_ctx, context);
+	ppi = gp->ppi;
+	irec = &gp->pptr_irec;
+
+	/* Ignore non-parent xattrs */
+	if (!(flags & XFS_ATTR_PARENT))
+		return;
+
+	/*
+	 * Report corruption for xattrs with any other flag set, or for a
+	 * parent pointer that has a remote value.  The attr list functions
+	 * filtered any INCOMPLETE attrs for us.
+	 */
+	if (XFS_IS_CORRUPT(mp,
+			   hweight32(flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) ||
+	    XFS_IS_CORRUPT(mp, value == NULL)) {
+		context->seen_enough = -EFSCORRUPTED;
+		return;
+	}
+
+	xfs_parent_irec_from_disk(&gp->pptr_irec, (void *)name, value,
+			valuelen);
+
+	/*
+	 * We found a parent pointer, but we've filled up the buffer.  Signal
+	 * to the caller that we did /not/ reach the end of the parent pointer
+	 * recordset.
+	 */
+	arraytop = xfs_getparents_arraytop(ppi, ppi->pi_count + 1);
+	context->firstu -= xfs_getparents_rec_sizeof(irec);
+	if (context->firstu < arraytop) {
+		context->seen_enough = 1;
+		return;
+	}
+
+	/* Format the parent pointer directly into the caller buffer. */
+	ppi->pi_offsets[ppi->pi_count] = context->firstu;
+	pptr = xfs_ppinfo_to_pp(ppi, ppi->pi_count);
+	pptr->xpp_ino = irec->p_ino;
+	pptr->xpp_gen = irec->p_gen;
+	pptr->xpp_diroffset = irec->p_diroffset;
+	pptr->xpp_rsvd = 0;
+
+	memcpy(pptr->xpp_name, irec->p_name, irec->p_namelen);
+	pptr->xpp_name[irec->p_namelen] = 0;
+	ppi->pi_count++;
+}
+
+/* Retrieve the parent pointers for a given inode. */
+int
+xfs_getparent_pointers(
+	struct xfs_inode		*ip,
+	struct xfs_pptr_info		*ppi)
+{
+	struct xfs_getparent_ctx	*gp;
+	int				error;
+
+	gp = kzalloc(sizeof(struct xfs_getparent_ctx), GFP_KERNEL);
+	if (!gp)
+		return -ENOMEM;
+	gp->ppi = ppi;
+	gp->context.dp = ip;
+	gp->context.resynch = 1;
+	gp->context.put_listent = xfs_getparent_listent;
+	gp->context.bufsize = round_down(ppi->pi_ptrs_size, sizeof(uint32_t));
+	gp->context.firstu = gp->context.bufsize;
+
+	/* Copy the cursor provided by caller */
+	memcpy(&gp->context.cursor, &ppi->pi_cursor,
+			sizeof(struct xfs_attrlist_cursor));
+	ppi->pi_count = 0;
+
+	error = xfs_attr_list(&gp->context);
+	if (error)
+		goto out_free;
+	if (gp->context.seen_enough < 0) {
+		error = gp->context.seen_enough;
+		goto out_free;
+	}
+
+	/* Is this the root directory? */
+	if (ip->i_ino == ip->i_mount->m_sb.sb_rootino)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+
+	/*
+	 * If we did not run out of buffer space, then we reached the end of
+	 * the pptr recordset, so set the DONE flag.
+	 */
+	if (gp->context.seen_enough == 0)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->pi_cursor, &gp->context.cursor,
+			sizeof(struct xfs_attrlist_cursor));
+out_free:
+	kfree(gp);
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 000000000000..d79197f23c40
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+static inline unsigned int
+xfs_getparents_arraytop(
+	const struct xfs_pptr_info	*ppi,
+	unsigned int			nr)
+{
+	return sizeof(struct xfs_pptr_info) +
+			(nr * sizeof(ppi->pi_offsets[0]));
+}
+
+int xfs_getparent_pointers(struct xfs_inode *ip, struct xfs_pptr_info *ppi);
+
+#endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.25.1

