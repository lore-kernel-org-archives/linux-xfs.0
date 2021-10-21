Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1E4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 05:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0835060C51
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 05:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhJUF2g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 01:28:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22240 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhJUF2f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Oct 2021 01:28:35 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L5OYXD029728;
        Thu, 21 Oct 2021 05:26:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3+4i3t8CkhbhRPnalXEXin+yNghYbGfeeMbvcans9dU=;
 b=Ik2Gat9VNf5VHkQVep6KF+SvXI14YFg1UzvNyhL7D9fHVkbBrVaeITLuET06wlV54Gu7
 yWjGqbaHrTkjlMohiq0UuJZ/jKDtlojPlDnHQgC51UcSboTQg4hmQtsepn/4Cub9JFqx
 d8rrSh7WgkOESdbhl33+yg4tzUYIIuZRn/1i5wQtv46iDaNOGi8DoahDCzCS+9WjmV4O
 cwXpchjMMbc7vbIAGMM66IimU13NaGB7UTe8qA6QL9dqznLzDtnF63V89P2zjvWncfxP
 FGaAYjb/auYewLqL9Ywoossx6WfD8Rxpi4YMpAv61ZIUGo5/d5CvlyznkqCJgc8w2Fko eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj479k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 05:26:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L5GtrC151828;
        Thu, 21 Oct 2021 05:26:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 3bqmshhcx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 05:26:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OD9GgCaZGxAOMieJ8GNvkQaDU7LnjN0hIyX7+OmdKkuYCjm6aBjNchvc3PVybVPtd+wew1w5r1nSXH/Mas3v5aCeFlp27GXG8c1PErFkNxSfV2MiFpasYmvOnDKk4RGet69cNADldaLCYoSp6T0CqK9nLwOM/CuK0SyJfbrEUICzlTMZD3t3SaSTntga81csM4YDJP+GVb8vTLC/2mfPnOf/hWHFklkyZZXzz7pci/Mt2+5dJlf0H0jQyrfW+J6ftlPDkXw9HAQ/8njQH/exE4UrbyKldr3sq4y0a8RlYH/Q/vQCisZ6shB/p0+rtQXX24/fv0iI8kzncoOQlX/lWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+4i3t8CkhbhRPnalXEXin+yNghYbGfeeMbvcans9dU=;
 b=Bid62kr9828KrfGMuY7xJ7373IxVfotjDfNZis9Nst0SKEjLx0z7Ta2uRgycWt521lLMAc5Kc88/bdsXNYbZN3n9wJJEpXZDdffDqyuu97PIKZYuO77ObeUycxq3PQwmiO7qyL8/4UzvVOEcMId0/CF9qela1qx1az6g5nJJU+Cc5eQe8Skj1LCIIR+8BCYDhmMhpq4iFnQMV4e63zWlymk3MAEA5pvB1G3LquEWJ5ERGNDZFhro+H5xPSjAcmgfiKrbJsE3Klm11dwcNFgtJJTO2ASjre7OJN8m0kEV3ux3Cj9Bq9XF1xomxcVkkEv1AqEYbZtROSzYg5FzbNDygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+4i3t8CkhbhRPnalXEXin+yNghYbGfeeMbvcans9dU=;
 b=Cy63Ij0Z/KU1R2tHPcq+A2jS42bZcLwclESp/ccWYCwzb63H4If+2OxFEPvVrgZh0U+rdogz/KmHCQBWDiBExyJtYK0fRst5vJRM6QHD1zKT7aaJqa6hSEE8IYR5bHcSC+dsHgkKe5aIs+J+GtjtiG31gnxqenY0xP/v0k1xG60=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN4PR10MB5560.namprd10.prod.outlook.com (2603:10b6:806:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 05:26:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%7]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 05:26:14 +0000
References: <163466951226.2234337.10978241003370731405.stgit@magnolia>
 <163466951789.2234337.5921537082518635597.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove kmem_zone typedef
In-reply-to: <163466951789.2234337.5921537082518635597.stgit@magnolia>
Message-ID: <87fssvvthy.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 21 Oct 2021 10:56:01 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:196::15) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.1) by SI2PR02CA0046.apcprd02.prod.outlook.com (2603:1096:4:196::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 05:26:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd36703f-905a-445d-c82d-08d994534c8b
X-MS-TrafficTypeDiagnostic: SN4PR10MB5560:
X-Microsoft-Antispam-PRVS: <SN4PR10MB5560D312E22EE7F824C30B42F6BF9@SN4PR10MB5560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQJbr7lc/qlOTlvrAe+gJVt1n+Zp4PxO6gYB67sNs2rRs7FxaDoPShmabobV3f5RbTgxNtyMwuDpDjDKx99d0rHlexyd8LseNsHPlNa6laoIiCtsm4cqhd+Qw+/DFVaxsUFzNwDEIcBDyqGYP5LGg5pqvR7JoU87g7pcfNyk/xjrHzGwNW6xTVlfScnwKYG0Wtp1S+uiyqrT07diekQI6eJpnBBDuMGGRq6qwl5ysTs4dmZlkLhenvD4Q5rZsskvPO9DEm1HKFV1CNXg0o0yrpO2lgLpE4Z1/iwvcXhGdaLm4FSnr05XyypIlZsYqHjOgEegQfz2uFUv5px5pbXbndsyRVhknecQ0JNUiRddiw/syjJLhB3iYHDlF76lv2M4D8gfM9GAG+e6nJU1zfxN+ociEmIJXcmk44ziiSVkkxVo8yNcksUkP2httnzKrPMRpGhW4XFPt21ZskYf/hrMRpokfJsLRh/VZcjwfWamlpVO9ZXK054A5QvaiVzquqvZwuOyzle9b1cHirOCtjHR14WU2RUY1CIvZIe3ZhXBjKHMwUOkCrffTU03CpmTc+IzU0FjpusAPZbJxA87C0RFOI35MjohFyI8GpM72VyohQoYVXTUV09wysXwweRIy1PBjEGTeDLJSCmU/uwRBomE6MverPMbsx9WttwcbiTdmPmN90hyU5GufGWx9JAnAg/7NYJs9sU7Ri4OCmHOR8zeXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(53546011)(316002)(2906002)(83380400001)(26005)(52116002)(6486002)(508600001)(33716001)(4326008)(9686003)(38100700002)(86362001)(30864003)(66476007)(66556008)(6666004)(956004)(5660300002)(6496006)(6916009)(8936002)(66946007)(186003)(38350700002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K3w9ssiDa6VtUYffPSeRLK0RyHHtbadhYqwJ/AYB711T0Xhur1UdvqW0i7jB?=
 =?us-ascii?Q?bx+Amrx+qAMRzvQBP335E5G/hSH2Er5rnK/vHPFnjUhWBh4M6O7ls8FCVzRu?=
 =?us-ascii?Q?5bJX0ydGGL1WAZkQA8YF+Nkcg34dLWCxpf4dqAI8M3pkRcBG9sFklJ/6Vetr?=
 =?us-ascii?Q?W8fXdLOTGR5y+Xxaxeg0jiHzSZSXqvg5F/rwu2VquyUuFCy270ne0ehWpzDJ?=
 =?us-ascii?Q?T1xMR8b4oDYgoCIvty1LKJ3VYLezBAjzpVHioHJonJ6oy4wJ5s9nghoCmeax?=
 =?us-ascii?Q?8LAYn7AviP4HjZc/Pdhx16F4DRwqbXIq4nyDxaO55MGOYFe8FZkOwj228xnB?=
 =?us-ascii?Q?k2UwKLN+M/UK0NwJ7NfJhlhcKv2OrLi8gyLECOU98YpvvyYpC/rqbr2pwE2b?=
 =?us-ascii?Q?tVB9pEF7uCjx3gCVczKm2275cDEYyGBUta7O5kU/auqRFJChib84bBAnDVqZ?=
 =?us-ascii?Q?TpFBhB6rXxvabkGRxJ/z5b+417GPKhfEhZxkDvBeeWObFlVvD1UazlXrch+T?=
 =?us-ascii?Q?kG/UdgzsdHgzFxS7z124edUcZUFEcAN6bGXA1v3RfVxXE+NQaaUTp4YlyvfG?=
 =?us-ascii?Q?FHpn/9GVj2/gVmGNKMF5P5TDjkaqG8BEe1bFj5JFsQXDNsgcKEkFvv8oNQct?=
 =?us-ascii?Q?symyVyPdYQ2CfFRhL24BafqYzKLvYUZ9s/7oo7LT1OEw8YgmgT0ROitTDVzv?=
 =?us-ascii?Q?zf5t+shWqOotrJA9HXEWPm6fnnNICGq/OLfooGaes3baiSzXopDBPO2TXRPH?=
 =?us-ascii?Q?D9jsxeBobZjQLsQH3nHnlPgQBbjIUlg0p4kGl9rvah0AVHjM+XjjGPSJYfdd?=
 =?us-ascii?Q?tXMeaGh3RCggbnNZ7Lov37OPVIUdKLU99xdfRtJul3vNV3qfvjM6IhVso+L0?=
 =?us-ascii?Q?NBg3J2qHVlRkfVJxsolj0x1W5ziHqLv8J/AFCu6rTKssmqy47ZwLcDrKQgaP?=
 =?us-ascii?Q?d9LmEkRFekUS41jgoMswotP0DSb80+BMBGfGZKpuWXW3FasjiU9ETBUk/1iF?=
 =?us-ascii?Q?QSqu/VkZLi4QPrzYmzVCNbIe6G446LGCL2smwdW0R707CPeFeXGyBAbLlT3Q?=
 =?us-ascii?Q?lVYwMqiS/VkY2WrWRI9R/j8mouRhM3ab4kNW7IQcNY1q6UPJrLgOZGxlKw+E?=
 =?us-ascii?Q?Hkcf1dhZgeHJDJaN0T55nkE97Z/qrlRaVg7U33nrcNlNu6UCkpxIXX9q6m6C?=
 =?us-ascii?Q?V5FQhjV5X72H5qqjfBjMOqGvgzybsusgiKJ/9l1/Ohx6lw8pGm8QBCcF8Mk9?=
 =?us-ascii?Q?QVaN7jIPTsdEQFVD6Ro+i1iLqDEX1q/GVL+ot6/ZOObcSxvpZquCQScm4L8j?=
 =?us-ascii?Q?dr4AKlzMGCT3f9Ydy5Jngd7x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd36703f-905a-445d-c82d-08d994534c8b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 05:26:14.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chandan.babu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5560
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210024
X-Proofpoint-ORIG-GUID: 25KoxgMWzYIL8pXUtz0hxibgAkSCA4K-
X-Proofpoint-GUID: 25KoxgMWzYIL8pXUtz0hxibgAkSCA4K-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20 Oct 2021 at 00:21, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Remove these typedefs by referencing kmem_cache directly.

The changes made are quite straight forward.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/kmem.h                      |    4 ----
>  fs/xfs/libxfs/xfs_alloc.c          |    2 +-
>  fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +-
>  fs/xfs/libxfs/xfs_bmap.c           |    2 +-
>  fs/xfs/libxfs/xfs_bmap.h           |    2 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +-
>  fs/xfs/libxfs/xfs_btree.h          |    4 ++--
>  fs/xfs/libxfs/xfs_da_btree.c       |    2 +-
>  fs/xfs/libxfs/xfs_da_btree.h       |    2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c     |    2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h     |    2 +-
>  fs/xfs/libxfs/xfs_refcount_btree.c |    2 +-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |    2 +-
>  fs/xfs/xfs_bmap_item.c             |    4 ++--
>  fs/xfs/xfs_bmap_item.h             |    6 +++---
>  fs/xfs/xfs_buf.c                   |    2 +-
>  fs/xfs/xfs_buf_item.c              |    2 +-
>  fs/xfs/xfs_buf_item.h              |    2 +-
>  fs/xfs/xfs_dquot.c                 |    4 ++--
>  fs/xfs/xfs_extfree_item.c          |    4 ++--
>  fs/xfs/xfs_extfree_item.h          |    6 +++---
>  fs/xfs/xfs_icreate_item.c          |    2 +-
>  fs/xfs/xfs_icreate_item.h          |    2 +-
>  fs/xfs/xfs_inode.c                 |    2 +-
>  fs/xfs/xfs_inode.h                 |    2 +-
>  fs/xfs/xfs_inode_item.c            |    2 +-
>  fs/xfs/xfs_inode_item.h            |    2 +-
>  fs/xfs/xfs_log.c                   |    2 +-
>  fs/xfs/xfs_log_priv.h              |    2 +-
>  fs/xfs/xfs_qm.h                    |    2 +-
>  fs/xfs/xfs_refcount_item.c         |    4 ++--
>  fs/xfs/xfs_refcount_item.h         |    6 +++---
>  fs/xfs/xfs_rmap_item.c             |    4 ++--
>  fs/xfs/xfs_rmap_item.h             |    6 +++---
>  fs/xfs/xfs_trans.c                 |    2 +-
>  fs/xfs/xfs_trans.h                 |    2 +-
>  37 files changed, 50 insertions(+), 54 deletions(-)
>
>
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 54da6d717a06..b987dc2c6851 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -72,10 +72,6 @@ kmem_zalloc(size_t size, xfs_km_flags_t flags)
>  /*
>   * Zone interfaces
>   */
> -
> -#define kmem_zone	kmem_cache
> -#define kmem_zone_t	struct kmem_cache
> -
>  static inline struct page *
>  kmem_to_page(void *addr)
>  {
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 1a5684af8430..9bce5b258cd0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -27,7 +27,7 @@
>  #include "xfs_ag_resv.h"
>  #include "xfs_bmap.h"
>  
> -extern kmem_zone_t	*xfs_bmap_free_item_zone;
> +extern struct kmem_cache	*xfs_bmap_free_item_zone;
>  
>  struct workqueue_struct *xfs_alloc_wq;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 609d349e7bd4..8c9f73cc0bee 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -20,7 +20,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_ag.h"
>  
> -static kmem_zone_t	*xfs_allocbt_cur_cache;
> +static struct kmem_cache	*xfs_allocbt_cur_cache;
>  
>  STATIC struct xfs_btree_cur *
>  xfs_allocbt_dup_cursor(
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 321617e837ef..de106afb1bd7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -38,7 +38,7 @@
>  #include "xfs_iomap.h"
>  
>  
> -kmem_zone_t		*xfs_bmap_free_item_zone;
> +struct kmem_cache		*xfs_bmap_free_item_zone;
>  
>  /*
>   * Miscellaneous helper functions
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 67641f669918..171a72ee9f31 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -13,7 +13,7 @@ struct xfs_inode;
>  struct xfs_mount;
>  struct xfs_trans;
>  
> -extern kmem_zone_t	*xfs_bmap_free_item_zone;
> +extern struct kmem_cache	*xfs_bmap_free_item_zone;
>  
>  /*
>   * Argument structure for xfs_bmap_alloc.
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 107ac1d127bf..3c9a45233e60 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -22,7 +22,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_rmap.h"
>  
> -static kmem_zone_t	*xfs_bmbt_cur_cache;
> +static struct kmem_cache	*xfs_bmbt_cur_cache;
>  
>  /*
>   * Convert on-disk form of btree root to in-memory form.
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 7bc5a3796052..22d9f411fde6 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -230,7 +230,7 @@ struct xfs_btree_cur
>  	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
>  	struct xfs_mount	*bc_mp;	/* file system mount struct */
>  	const struct xfs_btree_ops *bc_ops;
> -	kmem_zone_t		*bc_cache; /* cursor cache */
> +	struct kmem_cache	*bc_cache; /* cursor cache */
>  	unsigned int		bc_flags; /* btree features - below */
>  	xfs_btnum_t		bc_btnum; /* identifies which btree type */
>  	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
> @@ -586,7 +586,7 @@ xfs_btree_alloc_cursor(
>  	struct xfs_trans	*tp,
>  	xfs_btnum_t		btnum,
>  	uint8_t			maxlevels,
> -	kmem_zone_t		*cache)
> +	struct kmem_cache	*cache)
>  {
>  	struct xfs_btree_cur	*cur;
>  
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index c062e2c85178..106776927b04 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -72,7 +72,7 @@ STATIC int	xfs_da3_blk_unlink(xfs_da_state_t *state,
>  				  xfs_da_state_blk_t *save_blk);
>  
>  
> -kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
> +struct kmem_cache *xfs_da_state_zone;	/* anchor for state struct zone */
>  
>  /*
>   * Allocate a dir-state structure.
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index ad5dd324631a..da845e32a678 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -227,6 +227,6 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
>  void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
>  		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
>  
> -extern struct kmem_zone *xfs_da_state_zone;
> +extern struct kmem_cache *xfs_da_state_zone;
>  
>  #endif	/* __XFS_DA_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 4a11024408e0..b2ad2fdc40f5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -22,7 +22,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  
> -static kmem_zone_t	*xfs_inobt_cur_cache;
> +static struct kmem_cache	*xfs_inobt_cur_cache;
>  
>  STATIC int
>  xfs_inobt_get_minrecs(
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 08a390a25949..c60ed01a4cad 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -26,7 +26,7 @@
>  #include "xfs_types.h"
>  #include "xfs_errortag.h"
>  
> -kmem_zone_t *xfs_ifork_zone;
> +struct kmem_cache *xfs_ifork_zone;
>  
>  void
>  xfs_init_local_fork(
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index a6f7897b6887..cb296bd5baae 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -221,7 +221,7 @@ static inline bool xfs_iext_peek_prev_extent(struct xfs_ifork *ifp,
>  	     xfs_iext_get_extent((ifp), (ext), (got));	\
>  	     xfs_iext_next((ifp), (ext)))
>  
> -extern struct kmem_zone	*xfs_ifork_zone;
> +extern struct kmem_cache	*xfs_ifork_zone;
>  
>  extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 6c4deb436c07..d14c1720b0fb 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -21,7 +21,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  
> -static kmem_zone_t	*xfs_refcountbt_cur_cache;
> +static struct kmem_cache	*xfs_refcountbt_cur_cache;
>  
>  static struct xfs_btree_cur *
>  xfs_refcountbt_dup_cursor(
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 3d4134eab8cf..69e104d0277f 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -22,7 +22,7 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
> -static kmem_zone_t	*xfs_rmapbt_cur_cache;
> +static struct kmem_cache	*xfs_rmapbt_cur_cache;
>  
>  /*
>   * Reverse map btree.
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e66c85a75104..3d2725178eeb 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -25,8 +25,8 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
> -kmem_zone_t	*xfs_bui_zone;
> -kmem_zone_t	*xfs_bud_zone;
> +struct kmem_cache	*xfs_bui_zone;
> +struct kmem_cache	*xfs_bud_zone;
>  
>  static const struct xfs_item_ops xfs_bui_item_ops;
>  
> diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> index b9be62f8bd52..6af6b02d4b66 100644
> --- a/fs/xfs/xfs_bmap_item.h
> +++ b/fs/xfs/xfs_bmap_item.h
> @@ -25,7 +25,7 @@
>  /* kernel only BUI/BUD definitions */
>  
>  struct xfs_mount;
> -struct kmem_zone;
> +struct kmem_cache;
>  
>  /*
>   * Max number of extents in fast allocation path.
> @@ -65,7 +65,7 @@ struct xfs_bud_log_item {
>  	struct xfs_bud_log_format	bud_format;
>  };
>  
> -extern struct kmem_zone	*xfs_bui_zone;
> -extern struct kmem_zone	*xfs_bud_zone;
> +extern struct kmem_cache	*xfs_bui_zone;
> +extern struct kmem_cache	*xfs_bud_zone;
>  
>  #endif	/* __XFS_BMAP_ITEM_H__ */
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 5fa6cd947dd4..1f4a1d63cb4a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -20,7 +20,7 @@
>  #include "xfs_error.h"
>  #include "xfs_ag.h"
>  
> -static kmem_zone_t *xfs_buf_zone;
> +static struct kmem_cache *xfs_buf_zone;
>  
>  /*
>   * Locking orders
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index b1ab100c09e1..19f571b1a442 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -23,7 +23,7 @@
>  #include "xfs_log.h"
>  
>  
> -kmem_zone_t	*xfs_buf_item_zone;
> +struct kmem_cache	*xfs_buf_item_zone;
>  
>  static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
>  {
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 50aa0f5ef959..e70400dd7d16 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -71,6 +71,6 @@ static inline void xfs_buf_dquot_io_fail(struct xfs_buf *bp)
>  void	xfs_buf_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
> -extern kmem_zone_t	*xfs_buf_item_zone;
> +extern struct kmem_cache	*xfs_buf_item_zone;
>  
>  #endif	/* __XFS_BUF_ITEM_H__ */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c9e1f2c94bd4..283b6740afea 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -38,8 +38,8 @@
>   * otherwise by the lowest id first, see xfs_dqlock2.
>   */
>  
> -struct kmem_zone		*xfs_qm_dqtrxzone;
> -static struct kmem_zone		*xfs_qm_dqzone;
> +struct kmem_cache		*xfs_qm_dqtrxzone;
> +static struct kmem_cache		*xfs_qm_dqzone;
>  
>  static struct lock_class_key xfs_dquot_group_class;
>  static struct lock_class_key xfs_dquot_project_class;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index ac67fc531315..a5bef52cc6b3 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -25,8 +25,8 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
> -kmem_zone_t	*xfs_efi_zone;
> -kmem_zone_t	*xfs_efd_zone;
> +struct kmem_cache	*xfs_efi_zone;
> +struct kmem_cache	*xfs_efd_zone;
>  
>  static const struct xfs_item_ops xfs_efi_item_ops;
>  
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index cd2860c875bf..e8644945290e 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -9,7 +9,7 @@
>  /* kernel only EFI/EFD definitions */
>  
>  struct xfs_mount;
> -struct kmem_zone;
> +struct kmem_cache;
>  
>  /*
>   * Max number of extents in fast allocation path.
> @@ -69,7 +69,7 @@ struct xfs_efd_log_item {
>   */
>  #define	XFS_EFD_MAX_FAST_EXTENTS	16
>  
> -extern struct kmem_zone	*xfs_efi_zone;
> -extern struct kmem_zone	*xfs_efd_zone;
> +extern struct kmem_cache	*xfs_efi_zone;
> +extern struct kmem_cache	*xfs_efd_zone;
>  
>  #endif	/* __XFS_EXTFREE_ITEM_H__ */
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 017904a34c02..7905518c4356 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -20,7 +20,7 @@
>  #include "xfs_ialloc.h"
>  #include "xfs_trace.h"
>  
> -kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
> +struct kmem_cache	*xfs_icreate_zone;		/* inode create item zone */
>  
>  static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
>  {
> diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
> index a50d0b01e15a..944427b33645 100644
> --- a/fs/xfs/xfs_icreate_item.h
> +++ b/fs/xfs/xfs_icreate_item.h
> @@ -12,7 +12,7 @@ struct xfs_icreate_item {
>  	struct xfs_icreate_log	ic_format;
>  };
>  
> -extern kmem_zone_t *xfs_icreate_zone;	/* inode create item zone */
> +extern struct kmem_cache *xfs_icreate_zone;	/* inode create item zone */
>  
>  void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
>  			xfs_agblock_t agbno, unsigned int count,
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a4f6f034fb81..91cc52b906cb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -36,7 +36,7 @@
>  #include "xfs_reflink.h"
>  #include "xfs_ag.h"
>  
> -kmem_zone_t *xfs_inode_zone;
> +struct kmem_cache *xfs_inode_zone;
>  
>  /*
>   * Used in xfs_itruncate_extents().  This is the maximum number of extents
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index b21b177832d1..5cb495a16c34 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -504,7 +504,7 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
>  
>  void xfs_irele(struct xfs_inode *ip);
>  
> -extern struct kmem_zone	*xfs_inode_zone;
> +extern struct kmem_cache	*xfs_inode_zone;
>  
>  /* The default CoW extent size hint. */
>  #define XFS_DEFAULT_COWEXTSZ_HINT 32
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 0659d19c211e..e2af36e93966 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -21,7 +21,7 @@
>  
>  #include <linux/iversion.h>
>  
> -kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
> +struct kmem_cache	*xfs_ili_zone;		/* inode log item zone */
>  
>  static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
>  {
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 403b45ab9aa2..f9de34d3954a 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -47,6 +47,6 @@ extern void xfs_iflush_abort(struct xfs_inode *);
>  extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
>  					 struct xfs_inode_log_format *);
>  
> -extern struct kmem_zone	*xfs_ili_zone;
> +extern struct kmem_cache	*xfs_ili_zone;
>  
>  #endif	/* __XFS_INODE_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6cd2d4aa770..011055375709 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -21,7 +21,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_health.h"
>  
> -kmem_zone_t	*xfs_log_ticket_zone;
> +struct kmem_cache	*xfs_log_ticket_zone;
>  
>  /* Local miscellaneous function prototypes */
>  STATIC struct xlog *
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 844fbeec3545..1b03277029c1 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -497,7 +497,7 @@ xlog_recover_cancel(struct xlog *);
>  extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
>  			    char *dp, int size);
>  
> -extern kmem_zone_t *xfs_log_ticket_zone;
> +extern struct kmem_cache *xfs_log_ticket_zone;
>  struct xlog_ticket *
>  xlog_ticket_alloc(
>  	struct xlog	*log,
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 442a0f97a9d4..5e8b70526538 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -11,7 +11,7 @@
>  
>  struct xfs_inode;
>  
> -extern struct kmem_zone	*xfs_qm_dqtrxzone;
> +extern struct kmem_cache	*xfs_qm_dqtrxzone;
>  
>  /*
>   * Number of bmaps that we ask from bmapi when doing a quotacheck.
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 61bbbe816b5e..0ca8da55053d 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -21,8 +21,8 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
> -kmem_zone_t	*xfs_cui_zone;
> -kmem_zone_t	*xfs_cud_zone;
> +struct kmem_cache	*xfs_cui_zone;
> +struct kmem_cache	*xfs_cud_zone;
>  
>  static const struct xfs_item_ops xfs_cui_item_ops;
>  
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index f4f2e836540b..22c69c5a8394 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -25,7 +25,7 @@
>  /* kernel only CUI/CUD definitions */
>  
>  struct xfs_mount;
> -struct kmem_zone;
> +struct kmem_cache;
>  
>  /*
>   * Max number of extents in fast allocation path.
> @@ -68,7 +68,7 @@ struct xfs_cud_log_item {
>  	struct xfs_cud_log_format	cud_format;
>  };
>  
> -extern struct kmem_zone	*xfs_cui_zone;
> -extern struct kmem_zone	*xfs_cud_zone;
> +extern struct kmem_cache	*xfs_cui_zone;
> +extern struct kmem_cache	*xfs_cud_zone;
>  
>  #endif	/* __XFS_REFCOUNT_ITEM_H__ */
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 181cd24d2ba9..b65987f97b89 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -21,8 +21,8 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
> -kmem_zone_t	*xfs_rui_zone;
> -kmem_zone_t	*xfs_rud_zone;
> +struct kmem_cache	*xfs_rui_zone;
> +struct kmem_cache	*xfs_rud_zone;
>  
>  static const struct xfs_item_ops xfs_rui_item_ops;
>  
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> index 31e6cdfff71f..b062b983a82f 100644
> --- a/fs/xfs/xfs_rmap_item.h
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -28,7 +28,7 @@
>  /* kernel only RUI/RUD definitions */
>  
>  struct xfs_mount;
> -struct kmem_zone;
> +struct kmem_cache;
>  
>  /*
>   * Max number of extents in fast allocation path.
> @@ -68,7 +68,7 @@ struct xfs_rud_log_item {
>  	struct xfs_rud_log_format	rud_format;
>  };
>  
> -extern struct kmem_zone	*xfs_rui_zone;
> -extern struct kmem_zone	*xfs_rud_zone;
> +extern struct kmem_cache	*xfs_rui_zone;
> +extern struct kmem_cache	*xfs_rud_zone;
>  
>  #endif	/* __XFS_RMAP_ITEM_H__ */
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index fcc797b5c113..3faa1baa5a89 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -25,7 +25,7 @@
>  #include "xfs_dquot.h"
>  #include "xfs_icache.h"
>  
> -kmem_zone_t	*xfs_trans_zone;
> +struct kmem_cache	*xfs_trans_zone;
>  
>  #if defined(CONFIG_TRACEPOINTS)
>  static void
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 3d2e89c4d446..88750576dd89 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -237,7 +237,7 @@ void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
>  void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
>  					struct xfs_buf *src_bp);
>  
> -extern kmem_zone_t	*xfs_trans_zone;
> +extern struct kmem_cache	*xfs_trans_zone;
>  
>  static inline struct xfs_log_item *
>  xfs_trans_item_relog(


-- 
chandan
