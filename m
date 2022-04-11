Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F888C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 13:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346714AbiDKNvn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 09:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346716AbiDKNvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 09:51:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFEC240A0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 06:49:19 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BDVxVX028178;
        Mon, 11 Apr 2022 13:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tSp1BOgIBDpm9KfdoFTiVHBg3r5PgclUdycMLjVBQts=;
 b=TwNWDameJAcuyIxP5mPuBc6IqU3sAsF1Z+8IDUw+vXwizy8NkooylW/Bi432R7xgQ9KK
 nN+kmL341bAke8o2AQptdr/RwhLoBD5dRSwk9u94Yjd7e81gTAfewDBSFyVnQshmIVpD
 bQ7uHsXxk2g2qsErNZTrLRRQhF0epdeGZSPv1YuyJ/hiBFYNIULd5OAt6oQl/t7YU1dI
 8ZB3CsfPlLInq+W5dB0VXkKjDVoO51GW0nSyw8BZRC4Yrxet/3DtrjGTvebXT35NYga4
 BO11scYvlfPLTo/eZWBTJZ/DqqQz54h7cjVnP0ypuX2r/flVXTun49pfo6BTTe/YkrDn XA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219ukkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:49:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BDlKVr017680;
        Mon, 11 Apr 2022 13:49:16 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k1qp9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:49:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6QkbAnKqGOcWQ1pJHjVG2mw0Xkq+DVM/aXteLIf+fFa35YZJA7shscyeTLK/aiYZedt/40c62/j9uUibP42tS+SE+3B0yptVksZcw93C+eEM6kS3REl8U4x8mf/Zkf5eLLyunKGT2gEL+gRQxVljVZhPyw6njk/Hcp4wB5WwL2Wjm7nX4yleUhbHXsCJikBjkbGDe7GWotLEVpSAqzB7IacDXG1JC2HjVTCO5dLTtANm5NNPg7SD/b2zvVoQoBeTvoEL+W/xRTb4ym2MA2edlinjaa8vH67TFVsQ51yxHpR3mb7HYsClEKeTWtuLetH9e4b8BtQlOWjsRSCtqyhFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSp1BOgIBDpm9KfdoFTiVHBg3r5PgclUdycMLjVBQts=;
 b=OzAmdrXSjgtmag0dOiuhfHt4sK1nm4F38cF0tDMuGTZEHpv58up6kUdm6qEd1RyogKRwHKl7e7iyOpHnIaoNzRyGz3eBstvWJt+l1SEnhrp2cPXDC7rt4i5CpIsu5i+sAZ7to3GabhKzyN8YmhHjo0MbmbGQvMmZ6K60HizLAgkgO4R7FYpuVWkdWXR5cBUm3MKgLq/SZiVRAEnqDmcLtezZVdxIS9fBUKgTwUoG7VoqdDIgeu9Kmfc+4AoYf4Q181jBoW0Yj9C8R+aD5HCzk/MxQHUpaUoxQIkcHVOTiIypjGv8yYl4CSmc/FdpS3C5z124WrmK7p+mT4sk2dJU7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSp1BOgIBDpm9KfdoFTiVHBg3r5PgclUdycMLjVBQts=;
 b=JVg6Ig7zJQ2QHSx+9nR30GWr+EW8PFVd7Bi+9I0ea1WZkb+RlXuI2vTAuMmBXhCFUdjX1rSdpl58MWyecfaVTDiNz4GV9Ep5gfSX52dXxjhjOwIuSwGK1UeAa20u5LJAq7cdB9SCtCpN48QGn4r7dYqnpUzQzgYuxLZsWJAC5CY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB3164.namprd10.prod.outlook.com (2603:10b6:5:1ac::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 13:49:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 13:49:14 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-8-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/17] xfs: convert AGI log flags to unsigned.
In-reply-to: <20220411003147.2104423-8-david@fromorbit.com>
Message-ID: <878rsbvige.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 19:19:05 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:196::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a245fabb-f711-4ea9-152e-08da1bc21085
X-MS-TrafficTypeDiagnostic: DM6PR10MB3164:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB31644858C22D4BEA49977C83F6EA9@DM6PR10MB3164.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/SdUKzrrGs73i0QTsFl7oBmD5bRh86V/7a8IWeyHuOspEBi1+6UDVbf/FWsDh6wK7TCe3+mchIXiINVMMITpYypt7qAtJgQKBbxrZbATDAke+LHTU326M1SX3ItqDCDUtLaC7O0dNTc/IUlDzEldZ6AwRsLeICPgpuc59whaq9jeS1e3no5bulo6bxrEg0kgQMNdRbUJw3G+ukFSb7eIBwsp4F/GHQ/Tt1ePda+MQPgRRq9KfU7bSH6cP/Yw71vvieBzA43RSss0qHxLDZGWsILaYNF+oHksaJokaoDl8g50L/z9XZOJL0+FnGdpIDvazOVY7zf4++68XpxfGqSzaXGvImmUSGUl5XW8cCPpg7pKqifUdW06P9IFyItMgOENspKIcCdZmfVSjy9HcCcXJYIeLmUvLfKtcUzfdp9glnSoFrcpgWJsv1lbNKN+cY3y0iGUGBIUh5JT3x4fIDX2J0k6c9GNiLK0YZZV+sk051CtAQmWrWRbhMDMKluSBe3GAKGLNNn3pWjuY2Qb0f2y5AUEeGxv60GQqBVXyCNHdZcoGDQwrrEX8pQtRGmpOHxB6uBaGbI0A449oK/K5UJaUsrr8kBNq3GHjB0Oi1MkoaNbiTPh4RGHMZUxRjsxIpAebWr5/9VIV40itantlzVPJV7A4y/if9T6SYaD79S6o2YvMzRPZTbYRbaJSEF8dn4VcpD0CqM3yh4svRLGlGyjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(83380400001)(38100700002)(8936002)(5660300002)(26005)(508600001)(186003)(2906002)(33716001)(4326008)(8676002)(86362001)(66946007)(6916009)(316002)(66556008)(66476007)(53546011)(6506007)(9686003)(6512007)(52116002)(6666004)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jtjUOhpfGVjljeqd4bC26GrOjqoCnRUx+ns0uXaVtmyWsbzJ6Fy3GBQxLnnU?=
 =?us-ascii?Q?sOV3NZ9Ro88QLieb9T45QiugP88FgcAFsyTvKcBgRvE0OySYZV40tx437anv?=
 =?us-ascii?Q?1OLWh28mDaeLybVGYl8lXFS67iV7mTredPlT25QXBRKJqPDMP9hTwV0iUcjQ?=
 =?us-ascii?Q?86klj3TnL6hzxGasBBp/gaHQKhA080bvAzQaO5H8bXP5H5t545UqBQmX4II0?=
 =?us-ascii?Q?5//Uc67KT8w8TJ1exXFRkRsxva0bJFMA/K/rnhgPXPGRmpwQIFoeoI403+X+?=
 =?us-ascii?Q?D1YVTu7N/4p/ajY5kVnij0vug199nFGaxyAoWMf46md4AT8I2qc96hJTsWmj?=
 =?us-ascii?Q?H1Jkg4UOrlAyGlYpZ0yR9wVvsKR9Fia6Vt+n2TvjyfEGl8cZSpu9yRXm/oZh?=
 =?us-ascii?Q?NfV1F+VcdRdRp6oagwiesOs6IDp2xuQzXZWh0M+40TQ2sWUxfv5TFo55DB2p?=
 =?us-ascii?Q?gtB+7Va6zUhBvMwbB58QF0twbgN2DiaT7sIY4KqCtmjiK279/PsjlwcJw129?=
 =?us-ascii?Q?5rchvkGXfMIDfN74Jr/SYP+MPJh+KhB+cOOzddeOYu1a9W3EqLvNwTiDSlQj?=
 =?us-ascii?Q?VH9AjkWTJS9Oyy9i6lab9LGS40fTIGMTSgBVmnv7neT5mgXQfUcXkLJCimRA?=
 =?us-ascii?Q?U6mMLZunhLpjqHh0WPqlEGC/V2p08R2TqL40klFoO3sCzStTDhzeFuIUrLg+?=
 =?us-ascii?Q?KIxIIz2CH+JVRJD6mTjwxrCtyB4++jqaa1/DEFvPNqC6RCHnbhrWUfu+oc/Y?=
 =?us-ascii?Q?MKH3agGBDlaPzp0d9eIjELboLpeEW4XhrwJREeIumoQymEHltlMj7mASKza4?=
 =?us-ascii?Q?WuaE+UfSIh4edbjR/EMA81nDUdeiIgN12177MuK0Buj5rUroedxf4ZeRuKwQ?=
 =?us-ascii?Q?lsHVh7Gmwk3c36A8j+ied2vNc7mEsFnZVq0ljKmiw5nqyxuki8KpoOgG7b5s?=
 =?us-ascii?Q?brNFEfo2odCqO6n/uVc708DJog+kowo8MKGR0dySA2muoMIey8rwF3DP3EW5?=
 =?us-ascii?Q?AYZI837kL5tivWTg2bBqXzkoA0awy/dqKWV/sBpwBy5Z1+4uX1DO83B95Jbv?=
 =?us-ascii?Q?U/+0egkJ0zniKzkhyxzG34X61VTefa1so3TPPLdYQU9nEmV7DoRl/otKrdrm?=
 =?us-ascii?Q?uaMNDFF0YTv5cV2NY0jG2GiZt1wcxOu08BNzwrv0BRpxfwgRiKZJDt5o0vYH?=
 =?us-ascii?Q?i5hyWwAvGG1/T7QV2jg5O0FpZ/+i9LAQ2liHT2W4uaOS5w2xQjh9kzUX1miA?=
 =?us-ascii?Q?Lh3Dm2WMIOcQOuGMFKVqr7wk/ibrl2ad1N4gK6tPQCBCotQEbNGwpU2tZR14?=
 =?us-ascii?Q?zIGnFJjU1ZNkUu3SYFoaHpRymeJ57ITVRzjrqfumI9/lSFv+ya5kXMwkCkFl?=
 =?us-ascii?Q?SNNk19NTV7elpyoen2w7hdPhNT2MfhrEF2f2M8+XUVu+B0B1/seI2x6Pqsmm?=
 =?us-ascii?Q?/gmdjYbZK68sa66DZy2Uu5qLIRJOC5eyxscL4UeY3NcYxKOIaUhvXuEsT1yh?=
 =?us-ascii?Q?PSxAbwZgQE85vbJe0lfXkw9zpbeM4Y8WRP4sSHIN01utPwQZvrzorBm4M8ls?=
 =?us-ascii?Q?EtR8Tl8qGEQAQB8gYONrM3BjxWuVMg9EH7K52M45jCbf7fxr7KJib3aJsIi6?=
 =?us-ascii?Q?YFYC+QduluHfecbpiOIxOSBxdInR1IWN5wQKuLRoQGpth4VShOunk7GyTudm?=
 =?us-ascii?Q?7ihRZKR7oAmQyZNyZeJXzsoi1fCvNmpXnzWQI1SI3NSsrHnol+6zlYq9kvfs?=
 =?us-ascii?Q?87MN5HPKjR2i2W+eVfqjfssOFp6D8WU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a245fabb-f711-4ea9-152e-08da1bc21085
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 13:49:14.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QS8lN3RHORv/52/XfUxoxcsANZAe21PmRy9peGypK4MTusGldHvAt7+NtS3Ig/18wLOsT38gTgeqwgj7rhPd5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3164
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_05:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110076
X-Proofpoint-GUID: FhM7FS_rsrojDo0ZZlR33rIsKDKtiXkG
X-Proofpoint-ORIG-GUID: FhM7FS_rsrojDo0ZZlR33rIsKDKtiXkG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks correct.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 30 +++++++++++++++---------------
>  fs/xfs/libxfs/xfs_ialloc.c |  6 +++---
>  fs/xfs/libxfs/xfs_ialloc.h |  2 +-
>  3 files changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 65e24847841e..0d6fa199a896 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -619,22 +619,22 @@ typedef struct xfs_agi {
>  
>  #define XFS_AGI_CRC_OFF		offsetof(struct xfs_agi, agi_crc)
>  
> -#define	XFS_AGI_MAGICNUM	(1 << 0)
> -#define	XFS_AGI_VERSIONNUM	(1 << 1)
> -#define	XFS_AGI_SEQNO		(1 << 2)
> -#define	XFS_AGI_LENGTH		(1 << 3)
> -#define	XFS_AGI_COUNT		(1 << 4)
> -#define	XFS_AGI_ROOT		(1 << 5)
> -#define	XFS_AGI_LEVEL		(1 << 6)
> -#define	XFS_AGI_FREECOUNT	(1 << 7)
> -#define	XFS_AGI_NEWINO		(1 << 8)
> -#define	XFS_AGI_DIRINO		(1 << 9)
> -#define	XFS_AGI_UNLINKED	(1 << 10)
> +#define	XFS_AGI_MAGICNUM	(1u << 0)
> +#define	XFS_AGI_VERSIONNUM	(1u << 1)
> +#define	XFS_AGI_SEQNO		(1u << 2)
> +#define	XFS_AGI_LENGTH		(1u << 3)
> +#define	XFS_AGI_COUNT		(1u << 4)
> +#define	XFS_AGI_ROOT		(1u << 5)
> +#define	XFS_AGI_LEVEL		(1u << 6)
> +#define	XFS_AGI_FREECOUNT	(1u << 7)
> +#define	XFS_AGI_NEWINO		(1u << 8)
> +#define	XFS_AGI_DIRINO		(1u << 9)
> +#define	XFS_AGI_UNLINKED	(1u << 10)
>  #define	XFS_AGI_NUM_BITS_R1	11	/* end of the 1st agi logging region */
> -#define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
> -#define	XFS_AGI_FREE_ROOT	(1 << 11)
> -#define	XFS_AGI_FREE_LEVEL	(1 << 12)
> -#define	XFS_AGI_IBLOCKS		(1 << 13) /* both inobt/finobt block counters */
> +#define	XFS_AGI_ALL_BITS_R1	((1u << XFS_AGI_NUM_BITS_R1) - 1)
> +#define	XFS_AGI_FREE_ROOT	(1u << 11)
> +#define	XFS_AGI_FREE_LEVEL	(1u << 12)
> +#define	XFS_AGI_IBLOCKS		(1u << 13) /* both inobt/finobt block counters */
>  #define	XFS_AGI_NUM_BITS_R2	14
>  
>  /* disk block (xfs_daddr_t) in the AG */
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index b418fe0c0679..54c2be6a2972 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2414,9 +2414,9 @@ xfs_imap(
>   */
>  void
>  xfs_ialloc_log_agi(
> -	xfs_trans_t	*tp,		/* transaction pointer */
> -	struct xfs_buf	*bp,		/* allocation group header buffer */
> -	int		fields)		/* bitmask of fields to log */
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp,
> +	uint32_t		fields)
>  {
>  	int			first;		/* first byte number */
>  	int			last;		/* last byte number */
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 8b5c2b709022..a7705b6a1fd3 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -60,7 +60,7 @@ void
>  xfs_ialloc_log_agi(
>  	struct xfs_trans *tp,		/* transaction pointer */
>  	struct xfs_buf	*bp,		/* allocation group header buffer */
> -	int		fields);	/* bitmask of fields to log */
> +	uint32_t	fields);	/* bitmask of fields to log */
>  
>  /*
>   * Read in the allocation group header (inode allocation section)


-- 
chandan
