Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9C6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 13:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiDKN34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 09:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiDKN34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 09:29:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5183A18F
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 06:27:41 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BB9Phv003034;
        Mon, 11 Apr 2022 13:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=J5ugfSO+adCBisg9qU6KlHF1KvY0czYRgblD2WnjyOU=;
 b=gn3IYJErjK0/Q9zFE2hQKovepjCh5zFoO0nE+kbTQYUtFJVaZ96UnmRtX2o9ctMhGVOG
 jgcCqfCD1m2Mc/Ffh58+i7DFxi3Iei1yA7jqwPp/2JQfOtfFeLYQILcBhmiPvBlMqzY0
 Yr/XW/0DenjRVeZJG4A4JM6KDkVwA120Pc0+g/N9PNBqREAJY8uMY1bRsEZVtC8gLcMW
 ZikMPIiMJq1cUgP/2h5gFGEcko6+LIKKM0Fogzp3zQ0SWnjuQDw3e186Bzy1mnzxZI4M
 mlW323NfzZoVz5+RLvNuysGlXik7frPszbDGs0TnfnSydSX1JM5HqVxnBCqvmdsg7qLw Fg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2bnb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:27:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BDCLc4019306;
        Mon, 11 Apr 2022 13:27:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck11kw8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:27:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/AWJeC2kwp/TW50nXSLGXeT1dRSQCMCUrAbU7IkR6gHOcikbuRSrItA7hWyVQs6iwl24ozjQkUmnROkAvYPBuTc6FQiiGKmvhvl8TD4CCA4gVCTzf+DZDPnZgCeCIRhDN6wetAg3BzrEtIUuLuHPN3X4QmgDU99YaE/5Dbh2ZItuAz0FOTzBB9KcN5LYSORwT3aS9c5tbYDPFnCocNeSAeptpL2uw+vaGLFQwMpU2gU1H1E1tNzLexqyAunJNsrBcEAi1HTeji6hcgyecEa4juuF3A2lBFroMRrk9IQLaEeX30HNmGeQz5xWdQCh+ECw8X45haUK5VUHx3tA+EO7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5ugfSO+adCBisg9qU6KlHF1KvY0czYRgblD2WnjyOU=;
 b=Nhh1MdFDQcpkiqu18FlahXzzq8vNvsZEFInG+AiGYr5jt0xALootapI6JT+QN0AOqWBdf50EDm4TYm4MK6Hk7MgpyhTJy/DEQ9cpoTTneaEUEKv7Izk0A7NU7PogwRaCPI4FDALH+G2bVKw+vq1J2nohTXsqyRUysUUFz8NpBfQDaIfk6eBY+Ofl24HEFk7Nc1k6HllNtwFVjrMm6uhTp5v68ICGwD0LfRwYYpvQNofdz1CCescjTYzbtt9+zlZy2snuetqKhVhuhUH45nA/TkynMbXejohjtvDidHv2LLBN79OmSChmiZeC17Cly26p0yB5VMAKR0elepk5F7IEpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5ugfSO+adCBisg9qU6KlHF1KvY0czYRgblD2WnjyOU=;
 b=KnB6pB76wpE3MB84MEE+6tnQ32pK5r9LGE0vEi80xU6WFWWbO85UfGmYF7t/Quc3cWGNMRWhcaBfgiGatGr3RXmSlq/dJ6yOhQGBL8/do/CIAemzWhLlq8W4Oim7CLjKz4/6+6GvNavmnj/NMx32TUdk2i5V/Haya/lUuGL2X0c=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2300.namprd10.prod.outlook.com (2603:10b6:4:2f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 13:27:37 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 13:27:37 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-7-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/17] xfs: convert AGF log flags to unsigned.
In-reply-to: <20220411003147.2104423-7-david@fromorbit.com>
Message-ID: <87ee23vjge.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 18:57:29 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0135.jpnprd01.prod.outlook.com
 (2603:1096:402:1::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddc1c70e-62ee-4a93-a5f9-08da1bbf0b82
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2300:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB23008098C9BD95797EB1D715F6EA9@DM5PR1001MB2300.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +5VvKbL1bJoG4nc7KTPZ4OQh/N0C+WScEOS16rLfj0jI4ZJ4KB6zT0MlC2+JD6NJXn8DLIloW2TlwGgMPcv5bTYAzQXHYPgHoriFIKGj6v6e1yqVak3IGLZr6ScbEGtNQGpOR5er3N1lbUultmyJ+imSuUcnwp51TF9OpTFPahU6IMnk2Qfuo/hOeQ0BwkVVXHMj6XNtBSk5rZtJStyL/NKSZCveWp/BEFUZAZDz85Wh1GyZkNwtGg92/nmLNBPvB7/RiQKn2UlvlxAOUfYUTJ6H7RQtgZqnC0OJp+c5i0N88lJhEBsXhYuwfJNRyjdiAcaOe0z7wAscmN21A23fGvbK60MeR6xh8SMMLIKN8hhsWw+ohMZ03ZuxSL8hTfJlmlSvFOVcsPKYAt97fKA+BDE1t3CKnP1iZeOJVopjcijIJA9L5VgNA11mqy3rzhEqsjVmhn23SE9IzjftULuBOUJyl+nunKK/ZXShEi2v3u5HU/8VJDzBlbwQKNGHwP5i5j/vAmDsR/rsfso8tsBtaX5uEtf3gRJWcY0Ql6WEAX8bo81nSsaCUkRkbDiO9vxBlcAYIkYT0Ct9NnqpNstYpGfTBPYZksupLB+2IUo7j2Pe8L2KTltiS/xHenx1L+cROoknpxDM7iNMO/pZzHZ9wk7Vylk4VRtBXUmkrVg49Lk4oPv5rjPZ7+kvCDpebIPytzFiSgsAMIdTKIEw7qREQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(26005)(186003)(53546011)(52116002)(66946007)(4326008)(316002)(66556008)(66476007)(8676002)(83380400001)(8936002)(508600001)(6916009)(5660300002)(6666004)(6486002)(38100700002)(38350700002)(9686003)(6512007)(6506007)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YkqM9ZXEPTLq9ag6NsC6/8x4/sopGHXG/3o/GcgGhhu5mt1dpol01aWXpXk5?=
 =?us-ascii?Q?Zr0sshQoPWqQUpQc6ChD1NOkPCD5MaW5LoAYYI8Y+F4Eoq/IJHKQMXeZkZ5t?=
 =?us-ascii?Q?v7GjVzxEHd21NnepTpjqTG/+NtELv/kvyNc0vKYW+XfPJjit2BSd/Tmd9QaJ?=
 =?us-ascii?Q?/ZQmoC9YYGlfBAipc/bB08CLwF++jaH6bXmLeDWwgBsiKpVF6bM8AAzOLBmC?=
 =?us-ascii?Q?ftcx1s3rGHnb0h/Zg3I+8wZpDDgm4ouUEsKkh6PtQnkRQPOA7L/+IWzIelkp?=
 =?us-ascii?Q?ylfo2jrwTceYq+898JPBIMuVFxpbI63dHcPrmx/cyEw4xnIRD+J8PqRNYjRw?=
 =?us-ascii?Q?KZp4M8cn0S7Rsp4X8GGhR+UfWKS/PwLt5j+Mjj47SKmRmlyJAIV9yjEkuMde?=
 =?us-ascii?Q?YYR+skvxjVlJt8Z88cBZlfnSJQS2NvknXBmoQSq1PihYJ0U0MwZMVOlYnQ0a?=
 =?us-ascii?Q?15V6mM0vTf+L/OejVnAADrpqbCllK6F8tngTTtrEaSW3ECU52XPwkVzcEGdW?=
 =?us-ascii?Q?4YOSAcuEUlEozyNuqbTBBpoL2fUvF6vH7I5baC2d8sYIeA3uPbj4qZHo4vzl?=
 =?us-ascii?Q?ZHlX0QtpjXqrUlKjCc6D3ksKjkKA1N7MdAC7R3LBmRB6rd//FlFMAMAgpkA0?=
 =?us-ascii?Q?uA8vuR9xpGCzO1CGTRsYhOMTpSjYehaHE9z4Mdd4XpqhYFN345Z1E4lwGMSP?=
 =?us-ascii?Q?JZzkVBD7bX2NhnlepyLrFhOWbOp/PMHumHRdwTKwnOCDe6WL686BeQsXygRp?=
 =?us-ascii?Q?oMtMg7oAg4ycvxWAyfREHKbHmW+2bma2hzzei1HelBd8U6qUZSeyxCWuUbR3?=
 =?us-ascii?Q?196HlA8cSOtkbntv2sMRxHipvCXVTJEBtVNhcMHHh7viYPYrKuzSPKyyrzO/?=
 =?us-ascii?Q?EptB3uJBeY5CCoVAbjLMqR5uYshFcVhJdIpVnToOc3IyTM8OVISyB4ZBTR+7?=
 =?us-ascii?Q?MWwsIhBKwmProi2VPGlBxRUISwfzRCQCPH5NiaePAZUSvHYURHUM7usLFxtD?=
 =?us-ascii?Q?scLP4to3/iX+Won0zx2BWRTo+tCNvnWXWUDhZIBgYRN+nKzWmSq4QgWOjyUe?=
 =?us-ascii?Q?EyN9jPSJVaSf10i5wCpCliQqlUnpDHRG5NMM8ypxhuywbHdJqa8828VautCz?=
 =?us-ascii?Q?9zeX2mtdgayC+M7cOdWIe3zZp5M8D0y/ofepKp0qgjRj/yEZOmkqYqwNqrD2?=
 =?us-ascii?Q?6B1+eb+CnNI6LONUrLbuNlO0+z7gm6lZthLizKoMTYhExr58UTrcJGcFDolk?=
 =?us-ascii?Q?q3288v3s+7sDfApJVBqr5Ndz2ipG3AS2Pm8j7IHoUwEgooW6PDZeaszM7S1p?=
 =?us-ascii?Q?qu/7kmwS24cJJb7NZ3OBY5yRnvpbi+lXQ66EjmqKQ6ljHixvvpVYBWv5tISi?=
 =?us-ascii?Q?kmkFo0HjvTbIYxaPnDEljZBX6HHfaTUraxEhmt7F+yYxUtwumkWWSLol2rNe?=
 =?us-ascii?Q?x7OT7Qh9qOnewIUImAYuQiJpJV4R0N/X/KxX+rx36nL4Cy23GGAlyJDlNU/I?=
 =?us-ascii?Q?KBqYJRp2RNokobCweK8PgxqrZNha5qfR7wF8++vpFklGfc2Yv26PnzwnLbrZ?=
 =?us-ascii?Q?AhEH5TDjPvm5+KkLjuPHV80WRiPZSpZeQmlLPTsQwvz74s7Z2AWQjy9pdR1w?=
 =?us-ascii?Q?BQzXFe+2+EmNdzSmw0hyrEGpQtKfvfdXiyr4G6yymGAFseE9q/2fI6xsv4c7?=
 =?us-ascii?Q?+0egu+gnqSnnWBcS7i79XsGcjbrtTgDuv/xo3L1HAxB8THydMHSs8aw4iixO?=
 =?us-ascii?Q?whvBjjWECwLzuRms311TnLqv2Eik7Dc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddc1c70e-62ee-4a93-a5f9-08da1bbf0b82
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 13:27:37.7018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2i7kzInQ02GRqVfyI3m0f3DQEpwSn0GNMLccdye6J+2BxeuRVxO61BPv2KSwSBco5APcvHEoVQOlVT0XaB1dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2300
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_04:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110073
X-Proofpoint-ORIG-GUID: D0o4T21qALBQtuolvVk6af1kYZLHEClr
X-Proofpoint-GUID: D0o4T21qALBQtuolvVk6af1kYZLHEClr
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
>  fs/xfs/libxfs/xfs_alloc.c  | 10 +++++-----
>  fs/xfs/libxfs/xfs_alloc.h  |  2 +-
>  fs/xfs/libxfs/xfs_format.h | 38 +++++++++++++++++++-------------------
>  3 files changed, 25 insertions(+), 25 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b52ed339727f..1ff3fa67d4c9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2777,7 +2777,7 @@ xfs_alloc_get_freelist(
>  	xfs_agblock_t		bno;
>  	__be32			*agfl_bno;
>  	int			error;
> -	int			logflags;
> +	uint32_t		logflags;
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_perag	*pag;
>  
> @@ -2830,9 +2830,9 @@ xfs_alloc_get_freelist(
>   */
>  void
>  xfs_alloc_log_agf(
> -	xfs_trans_t	*tp,	/* transaction pointer */
> -	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
> -	int		fields)	/* mask of fields to be logged (XFS_AGF_...) */
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp,
> +	uint32_t		fields)
>  {
>  	int	first;		/* first byte offset */
>  	int	last;		/* last byte offset */
> @@ -2902,7 +2902,7 @@ xfs_alloc_put_freelist(
>  	struct xfs_perag	*pag;
>  	__be32			*blockp;
>  	int			error;
> -	int			logflags;
> +	uint32_t		logflags;
>  	__be32			*agfl_bno;
>  	int			startoff;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index d4c057b764f9..84ca09b2223f 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -121,7 +121,7 @@ void
>  xfs_alloc_log_agf(
>  	struct xfs_trans *tp,	/* transaction pointer */
>  	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
> -	int		fields);/* mask of fields to be logged (XFS_AGF_...) */
> +	uint32_t	fields);/* mask of fields to be logged (XFS_AGF_...) */
>  
>  /*
>   * Interface for inode allocation to force the pag data to be initialized.
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d665c04e69dd..65e24847841e 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -525,26 +525,26 @@ typedef struct xfs_agf {
>  
>  #define XFS_AGF_CRC_OFF		offsetof(struct xfs_agf, agf_crc)
>  
> -#define	XFS_AGF_MAGICNUM	0x00000001
> -#define	XFS_AGF_VERSIONNUM	0x00000002
> -#define	XFS_AGF_SEQNO		0x00000004
> -#define	XFS_AGF_LENGTH		0x00000008
> -#define	XFS_AGF_ROOTS		0x00000010
> -#define	XFS_AGF_LEVELS		0x00000020
> -#define	XFS_AGF_FLFIRST		0x00000040
> -#define	XFS_AGF_FLLAST		0x00000080
> -#define	XFS_AGF_FLCOUNT		0x00000100
> -#define	XFS_AGF_FREEBLKS	0x00000200
> -#define	XFS_AGF_LONGEST		0x00000400
> -#define	XFS_AGF_BTREEBLKS	0x00000800
> -#define	XFS_AGF_UUID		0x00001000
> -#define	XFS_AGF_RMAP_BLOCKS	0x00002000
> -#define	XFS_AGF_REFCOUNT_BLOCKS	0x00004000
> -#define	XFS_AGF_REFCOUNT_ROOT	0x00008000
> -#define	XFS_AGF_REFCOUNT_LEVEL	0x00010000
> -#define	XFS_AGF_SPARE64		0x00020000
> +#define	XFS_AGF_MAGICNUM	(1u << 0)
> +#define	XFS_AGF_VERSIONNUM	(1u << 1)
> +#define	XFS_AGF_SEQNO		(1u << 2)
> +#define	XFS_AGF_LENGTH		(1u << 3)
> +#define	XFS_AGF_ROOTS		(1u << 4)
> +#define	XFS_AGF_LEVELS		(1u << 5)
> +#define	XFS_AGF_FLFIRST		(1u << 6)
> +#define	XFS_AGF_FLLAST		(1u << 7)
> +#define	XFS_AGF_FLCOUNT		(1u << 8)
> +#define	XFS_AGF_FREEBLKS	(1u << 9)
> +#define	XFS_AGF_LONGEST		(1u << 10)
> +#define	XFS_AGF_BTREEBLKS	(1u << 11)
> +#define	XFS_AGF_UUID		(1u << 12)
> +#define	XFS_AGF_RMAP_BLOCKS	(1u << 13)
> +#define	XFS_AGF_REFCOUNT_BLOCKS	(1u << 14)
> +#define	XFS_AGF_REFCOUNT_ROOT	(1u << 15)
> +#define	XFS_AGF_REFCOUNT_LEVEL	(1u << 16)
> +#define	XFS_AGF_SPARE64		(1u << 17)
>  #define	XFS_AGF_NUM_BITS	18
> -#define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
> +#define	XFS_AGF_ALL_BITS	((1u << XFS_AGF_NUM_BITS) - 1)
>  
>  #define XFS_AGF_FLAGS \
>  	{ XFS_AGF_MAGICNUM,	"MAGICNUM" }, \


-- 
chandan
