Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27728C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Apr 2022 07:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiDMHuq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 03:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiDMHuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 03:50:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9203C9FCF
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 00:48:24 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23D6gQWJ028053;
        Wed, 13 Apr 2022 07:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=o4K50cELRe3w04FSxjJqhIv4mRl+G4m7ZQN2EpGNQdw=;
 b=HMD+4PldWQLbZJCYpueewh1tzz42ubFtV/8VpofHq7TJIAC+sQuQgLcKGn+qgbzFc8pB
 BS1DBcz5CqPvD+UPWXlTVtHcG9do1h4c6hQnj7cPz1cdMTKBy1fDLKI55N6OODsNjm3g
 2c82EYGDZBcbKv0Ng+LI50PyzhHz3A4Eg4pPTXZBO1iGI204QRCJ7NltrNRrRVk4bkq9
 bTaya8tGDJgOsyJxD2cCc1K/OLm+bcp5GvzQ0IW4CtZoMsUeuBtbeOw8BT7FBukA105o
 LpCZzNJou79XORXbFyQ6CX0676mvedaa2M/CVAemtWEqlhZeGMf7NCDqjxnT+4uYXVh+ Iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb21a0rxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 07:48:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23D7lKgS035560;
        Wed, 13 Apr 2022 07:48:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k3fc2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 07:48:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSZ6f1MQzUk7NOMu9uhDtpMMqY69Q+0UOLuWXqv+MSpEzuYHVadggiCxpvbBYiBdtVeA39Ct3ASZExUW4//oYA/welief68ec8HY7m0m940sQmn22AeDTaEterOnZYnOC0ooJ21nWqsg4yTetbdYLoTltcl5bm6RWb5ST0e3TX6e1KInegEbup2MpUuQlTNI+ljaXeSAa2KeFb1b4IoNvc0jj218tdnLlMqy+z/C2a8vZ42njuYdqlp8hjC62RwHqpsOXVlZcTD6+X356SIfunBGzSG/y1jvmaFeEeivsjLsKMZiVb9CLpfbC9IIobfBgL1KBECuKOqdybtFMczsQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4K50cELRe3w04FSxjJqhIv4mRl+G4m7ZQN2EpGNQdw=;
 b=kIEZukLoEkdmXFpoZaEkUX6snZp/90Ci/w2x7v4bKUhsyblpSeba/YeFAD6TvHYWlNO303R1OMcxw1CpC1lGO+J7IioOoGjhaF3vgqs5bIkltzKsUhulHeru4RhxxIDDbzfrpSenxWVQ+mnNc5Kj5EjA7ewoqYlHnjCt1kRwe7YVtZH7Fvzj7iiXxtoTf74acBZun5j84xrbnMzUdxnJLTtnNn1WZwIZgkLRl8c+W4DuNkjDJniykme+YXdbTaYiJlZskXezBSPDlyxW/oRh6r/NjV7tpGIVs2+Ceoauu119Ytjnvr5UhwM0zBN0NKjbVPwML4SeMitgTOqJnqTtXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4K50cELRe3w04FSxjJqhIv4mRl+G4m7ZQN2EpGNQdw=;
 b=HPTyvYhUdjPFhAZVzuf1fUwu7nPygbjCwEpooRIobA2IN/VsdcyroV5jNhv4SHjKKJJvS/TEIeS+uzhX1Choicb0FOaiuLoKTCqjL44grIDdYj6TjNYAgnB6Jb9wU24z5yp7EGzfyj7Hc3eoBh91u53ZjHklhde+Ct7THy2EdPU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CY4PR1001MB2168.namprd10.prod.outlook.com (2603:10b6:910:48::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.28; Wed, 13 Apr
 2022 07:48:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 07:48:10 +0000
References: <20220406061904.595597-19-chandan.babu@oracle.com>
 <20220409135709.495356-1-chandan.babu@oracle.com>
 <20220413025720.GL16799@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V9.1] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20220413025720.GL16799@magnolia>
Message-ID: <875ynd4e6n.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 13 Apr 2022 13:18:00 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0209.jpnprd01.prod.outlook.com
 (2603:1096:404:29::29) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1149d2fc-9995-44be-b708-08da1d21f468
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2168:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB216848A48BDFDE6760E9A355F6EC9@CY4PR1001MB2168.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0oNnv4EwwsC4+CphEF0HTxFobcLb3zxZVP4GsC7dO2DZwUA97P54n3Loyl9I4rS1Xut1p1eMe277kKVAM01QLkZ6jZsUEI6SSaeo0xdV5rl4FisLmsdRfENqOYfPXTXmPGasxv/NRlVXdJNzIVMU5/LpEppIAY/66kPKkkiKi38wy0OSuJy60DpQkS+AIeRkvLqbLToG3QzzMJhBOz/2vsi3GbZVIEk4nMWo4V+Up5FztrMeTGVAu5GOgzdJRRxotla7TlQui2a1wvibJkZJpUYAK1csh3faYOrl/cLg69KU4x1BV0UU9AxB6nLrN2lHUbMv5zfyZHGvUp9C8uJCO49JRgLiQCuy+0YOe0oEg73VZ0hBhathhNawggIo48Yp85E9HPwBwIKUdLhU9iGHlsNM/K41/rzzRx04uLDuhURDUk6wC15nI5GJTRgb+P6NBp/I2lAS968oh/akpQSm+eXF0FAdSf7ELdT5fDWSozgF8gymEYy1rIth14dbjZtxTrG6z3TX/+CqhlQdXzOAJUMke+n46rf0iVR5Ia5sst8iUJntUR3v4wgHljhuf5Ggp/wzo3e/UmWobcHUjWpgTjhbPH9s2ZJFKdj2uUCld7wR4n/CUx+CSesfw+SyIl5vpoSxSCWWHuK7QfRtzPVK23b9In1Ulm0Lj35S4qUcoGNGA8OjvJK0Rl7f7mphn1X1VZYLZ469dYXUAkj0OZTw4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(6486002)(6512007)(6506007)(33716001)(508600001)(6666004)(186003)(8936002)(26005)(9686003)(52116002)(53546011)(83380400001)(38100700002)(316002)(5660300002)(86362001)(66476007)(6916009)(38350700002)(66556008)(4326008)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qglHlpOggf0RMd1WoVzWIooeRFbtOpgxmpu47ctINCn2ETekW5DKArhDaFkD?=
 =?us-ascii?Q?lVaphxhx5dvrRniax6LYovLgWB+bb16jGi21xNlv8ITRUXAuuHtsE8iBtkv6?=
 =?us-ascii?Q?5nI9bX30DvbgCX3i5GkQCXCZq/KtvBjZW/YDCQ9FNZjJcaaYI9WK5smRCU3/?=
 =?us-ascii?Q?dka9N/v94n72YvlSrGANqaGsu21ATiQVjtvcchEu9UOLVdLlYBWN6YYESCeW?=
 =?us-ascii?Q?tiupQO8AXKhsQ/WCe79g+KQ4iGCDK7SMWXNC38ouAnAFJp5P0m0Mjas6M0NN?=
 =?us-ascii?Q?yjmD50P5vgit27J96l4Ntg5SlfSxfc7dzkF953P2ZMU1pcFoG+PY1TgPbzF/?=
 =?us-ascii?Q?DSX43u1KklVYBd8Fu8mcnt0ISNbd9jB7f/WqCexRXe/QbcX5xgbb6pVWzONj?=
 =?us-ascii?Q?WTtOAcY12x13z8LRt/mSHgZZqI95YphUrpi3MceJSa4jnz6jLl8PxRbzipy5?=
 =?us-ascii?Q?3SuwMg9SQz9fA12K4Np7L+XA1xsM7BYeDd1MQ+kBfjvUAbVv+M3lTYMvoTYD?=
 =?us-ascii?Q?UmU+jygbchU5yd6+awv9FFaAueHlf1rSIJSN99pl8NwFn4m2k4XS+zrtpMCp?=
 =?us-ascii?Q?vnodOtgaRO7r4zLF2sYp2XGOWtCbWqHEgpuJCxJ890MqFEF+JD/gIIF9anV7?=
 =?us-ascii?Q?oqYq7vTWiEyJMTTN0/4OKbnYi0HoTh+4ylq9Q7poBQzfVcaixIVbdV2vT2/d?=
 =?us-ascii?Q?k/RLuMsKXvBXp2LCTf3NtCCkMFqC06TQBoMRopQArMJlWfMccDFSCNy7hEeb?=
 =?us-ascii?Q?sboTPpp5YqFUJM96yUGBWsd2DuOG7KzbIb6klvocD6fi35bw72EL/Jsk3tKn?=
 =?us-ascii?Q?x8PnUwtSFpT3RcdAreSJTgeJLiI3HH6cci7Zx18mYcEJTGmM41FP2bCZQNTs?=
 =?us-ascii?Q?vKqe+LG6dhGEBZoWkwzCg/9U6gW62Bpn+NILjS5AGfas0hWgx8OpGBnVSGSb?=
 =?us-ascii?Q?oGL80NDWKD1te8fqXhhgpoBTIQb+NAbvYYGnrDYJt3F6+ISh62gig0mScmYI?=
 =?us-ascii?Q?rOscDdvpVys7LRj7ZjasSp8mD8gxo2uk3Rvbss7/qQS9h04tmQdLqFMO5e13?=
 =?us-ascii?Q?KdBaDGjjPRy3Ksi7bIM3rYtGXzzuZwK6DTatjPcLes9A56cXTHfDO1wVE1d9?=
 =?us-ascii?Q?gyg0ItmM2zMPZdD/dAUaWpQhhBruHTHJEvAUcI/qOMrEixiddrUVSIAF45KF?=
 =?us-ascii?Q?glgU96JqCRotxjVbTyLZjK6T7uYaN888+ZzbkYkbJc774RVzLdYqe/x8UIiB?=
 =?us-ascii?Q?xl04KYB2d3780y/8y+3afMDbQhNPUnGNkXbUuPSL48oP6xsDdHkbQzqMR2GC?=
 =?us-ascii?Q?8D6loB6t9ByP75iK4LubWbnmYhMeLy2y8f8NZdIsqfpoE8PTYVuQBsl4ThNI?=
 =?us-ascii?Q?hNUAumWuHjaEu3UqN5hwBHtsNo627Pxf3zkz43dkNk37rgQdXwjke/MafGQI?=
 =?us-ascii?Q?FAPP8fW01VYbt0qKZBIVjQIZhHY8GklqicWvvFUjCzrPP1srZnTpsOc6EOqc?=
 =?us-ascii?Q?kX2HzaTjuCruVR75FyBmGVHTSEIUj95RFNnyqRRLiVfvhUdKUpjpHoHcb2dp?=
 =?us-ascii?Q?XPAgZzS4zCSpAvvvitWYkGX68tTpsCpSM6NrU2KExTNcXJhdMec+NnwNx4sj?=
 =?us-ascii?Q?KfLfPhwhJoWbGXHuH1sXkSwNVjkX8fyvYT/XObiOsjo/mY5SRmWKB5YgvfMs?=
 =?us-ascii?Q?pYr4umDzN3lMOfwncG1DM5pp5zLfRE2l7hqDcGSFxaDeYpivvi3c3dFEkjFK?=
 =?us-ascii?Q?uegFIjForLQR5rwc/R1rcZyEk/I2K0o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1149d2fc-9995-44be-b708-08da1d21f468
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 07:48:10.1100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSTzvQkdjgMPdRO2l4jlPIwcv8wDJH5rVydzSuRFlRQbd0cwRpQLjjgmJXcAW/+SDsJg3h/UL4nj/uGicmQugg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2168
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-12_08:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204130043
X-Proofpoint-GUID: cs2XOSwNSr6x7U3VXlgAvU1uteOF-LlO
X-Proofpoint-ORIG-GUID: cs2XOSwNSr6x7U3VXlgAvU1uteOF-LlO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13 Apr 2022 at 08:27, Darrick J. Wong wrote:
> On Sat, Apr 09, 2022 at 07:27:09PM +0530, Chandan Babu R wrote:
>> The following changes are made to enable userspace to obtain 64-bit extent
>> counters,
>> 1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>>    xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
>> 2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>>    it is capable of receiving 64-bit extent counters.
>> 
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
>>  fs/xfs/xfs_ioctl.c     |  3 +++
>>  fs/xfs/xfs_itable.c    |  9 ++++++++-
>>  fs/xfs/xfs_itable.h    |  3 +++
>>  4 files changed, 30 insertions(+), 5 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 1f7238db35cc..2a42bfb85c3b 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -378,7 +378,7 @@ struct xfs_bulkstat {
>>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>>  
>>  	uint32_t	bs_nlink;	/* number of links		*/
>> -	uint32_t	bs_extents;	/* number of extents		*/
>> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>>  	uint16_t	bs_version;	/* structure version		*/
>>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
>> @@ -387,8 +387,9 @@ struct xfs_bulkstat {
>>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>>  	uint16_t	bs_mode;	/* type and mode		*/
>>  	uint16_t	bs_pad2;	/* zeroed			*/
>> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>>  
>> -	uint64_t	bs_pad[7];	/* zeroed			*/
>> +	uint64_t	bs_pad[6];	/* zeroed			*/
>>  };
>>  
>>  #define XFS_BULKSTAT_VERSION_V1	(1)
>> @@ -469,8 +470,19 @@ struct xfs_bulk_ireq {
>>   */
>>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>>  
>> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>> -				 XFS_BULK_IREQ_SPECIAL)
>> +/*
>> + * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
>> + * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
>> + * xfs_bulkstat->bs_extents for returning data fork extent count and set
>> + * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
>> + * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
>> + * XFS_MAX_EXTCNT_DATA_FORK_OLD.
>> + */
>> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)
>
> This /probably/ ought to be (1U << 2) but ... fmeh, I don't have gcc 5
> and don't care to install it, so because the logic looks ok to me:
>

I have changed XFS_BULK_IREQ_* flags to have unsigned values.

So with this patchset, XFS_IWALK_*, XFS_BULK_IREQ_* and XFS_IBULK_* flags will
have unsigned values.

I will execute fstests before sending a pull request.

>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks to Dave and you for taking time to review various versions of this
patchset.

-- 
chandan
