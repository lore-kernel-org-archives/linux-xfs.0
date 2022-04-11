Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2FAC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 12:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiDKMz7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 08:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346241AbiDKMz6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 08:55:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398BE39146
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 05:53:44 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BB9PUs003034;
        Mon, 11 Apr 2022 12:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=y7YuuaCLKDrGsYwb10pNKoZ98zZi9YQSJNLPC6CC6tw=;
 b=x4RVGgTPQlk6gBpKInU0xyUrmO38/X6YNsI6PLsaQ3iN9adYDFyoi5Ky2enn1aG1CKhN
 rpI9GdUiD22nszNRVtMc7wWNC8zffseZYk+UCltAWQfi4fyUi5EzrlWEfPiwgeUK6gx1
 BJLgcmbWt1td50mn4y5ipiztrDr2uyf8+ce6hbDpXBj6yFNRyA5KTeFzJxQUEE5XcbkT
 HxlmTkE8x5Q4ygk4kWDl8wtSk4EQ6AQkHzMmNrJk1t4X2oeigtGYWDTPHmTtFOsWod5x
 V7ZOR4JQX54lq5zxDaoLa3pL74n3YlAvzjNj/P04f9Q70AScJE7wu9MqX++P4++5Afzd MQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2bj61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 12:53:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BCp8ME018759;
        Mon, 11 Apr 2022 12:53:42 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k1dser-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 12:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cC+LbgQ1OO0UkwduvHf3MH/SnYoNOQc6bNitm5d7hzWzvENBmRvQiZ7s35lAhOoYU3E/BObLziTsyF4Yaagen/lcpElhwkdxsoXnMUobBi/sCNHGXMrmtzKhf//NXjpLVDwBhalQjxt5ibaLkwgR2HhpIZ/rQGquDaS6LaIyC4xSm8qwcQp4vhz1B/qcxfxpZfL8cajnPsOim7GJAuawKnliU96bLIKU98xmr+DvHFZzZrhL3pu5pCTmlstwAvGgYeUBowFN8k6Z7r3tpcT93QG5Pdnsr0Q7P45MPRL+snNLwgjZFUOyGpIX1NjHifhjlgc12bURWFKrwrZ+zb9Kwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7YuuaCLKDrGsYwb10pNKoZ98zZi9YQSJNLPC6CC6tw=;
 b=CCBvWUIOhVr2rhOn4vkNyeUGtY+o8F+esKuBLd0g1C/ZFX9SQcb8g211aSA2cIzLpEHvvf+QGZ6R6VK77ljCFTh5nTfC3aw0cO8x4/6ToF3I/O3ssiRiUUyF50InGVKOfWZsyClvr4QCwMtt6vRVY7HWCdNJsRESXcXqQs+Tpc+b+iZPa5QPfE6YL2M9BO+1a6M6AD7cIinLe9HEphj8JHUNU09fFM5ToMGD1hH8oQng1ae7E7SonySHiN+qpT83QAg/va0A21UT2tR3o2x/1nP/L0JFoQUJMEDvlZQ2oS0OkN+50SJ+FtmMtTHlrqyNFSru3kAis0BK2xukoL/3eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7YuuaCLKDrGsYwb10pNKoZ98zZi9YQSJNLPC6CC6tw=;
 b=cvCxjCpx0UVGiEi4d3CP6W4ypyWifWI2LEO8+aNU2zFDhru5EOzo1DWYxWwkwWW7athBLyo1jUECTb9bKdJCyMTIi/DX/91eVAq4Xbq1MV01DLzBi9Gnxz/2tQkTPlgUWe2apD9llhRxzgXmj2NuATWNTAah8Llod+tLo1OTGQU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CY4PR1001MB2360.namprd10.prod.outlook.com (2603:10b6:910:48::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 12:53:40 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 12:53:40 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-6-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/17] xfs: convert bmapi flags to unsigned.
In-reply-to: <20220411003147.2104423-6-david@fromorbit.com>
Message-ID: <87h76zvl10.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 18:23:31 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0180.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::24) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92dfbc22-67a5-4151-515c-08da1bba4d2d
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2360:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB23606CCB5F89CC66ABCD99D0F6EA9@CY4PR1001MB2360.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JdY4ARY1TWJZSbYRfcuJYpa3H4v4IbxkJ4Ikqi+udMZkBvFykdLqG1twsSSgudY2Yu2svLAQX/7+coc9XvrQEoRYUmnlBxBvzuTSu0F2jWe/eykWx/CyeRL3pKsDM7MWCGh/Ycen/zrmty4Kikb2FbmuT1Usbhux4v+p+sip62IfcSsSEZGTa/EThdM1CgG5LvsV5GZ7YgfArlqEetOjeo6MmhfW6oDYfZxsOPvQ4wFGU6qBy8wi3xKWeZ7yFJS4VeGDtqJYpcIreK34NXsW8dGgHkyD1ATFXz6TVgO9/JWp6kEY+QkOVgcLSfJ/v7LNxEJUrcaQtoQT1+vf2uY3qvWkRfA6BY7P9XjVMwNdeb9gaH6yB8cUx1d/yfaWCI8aMVAEomBALV88LB9cosUNrJmEVAdKqDD+mTZ5tZ64vyqod9gGRjPPtVDJHaLjLm/hKkYggXovcpbUbgaAMD/hAvjigrJxZirXJZv5MoPts75SJGUEVGQkgG49S7QnNVdlIhE+2Xr+iK6XxfdtMjLlSdo6kkmc7XMdU+Zf3Ji3AoUBNjXiNu8Pu+mXiWQbYsxl1mK5JJa2CPac63JXBtmfzoZteRcfaAQjSAVpQ943vM+YFhGvkS4NGKk9uOJiPoDJHBcbZoys+TIKATZhatCe1fyyeFHfm1vViHYho8ft4SsCR5ttvNc9PUsZ3bsKARNECPNBC9o9Fi7RRHSIZ56Ckw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(26005)(83380400001)(66556008)(4326008)(316002)(8676002)(66946007)(66476007)(8936002)(5660300002)(6666004)(2906002)(6506007)(508600001)(9686003)(6512007)(52116002)(53546011)(6486002)(6916009)(38350700002)(38100700002)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/jWEDE2a9i4UzLIj/BDBszuXVrpm5za61m7miF+Vw2gwAskpEYQMGMTEcSsi?=
 =?us-ascii?Q?/Lh6lx02JGP495ynQL2Ic5J2kDPeZZOzKRSDNsLHzs3NQFuj51ozDI/Hi3/c?=
 =?us-ascii?Q?oZ6IhMayqRAb6rlVNjrmJDh0OidA8+L5uhPs5V0zWdz9aYfwNkw3ur7fCkb9?=
 =?us-ascii?Q?j4DZGkAPxOzoQxUNGxgmjYmGXhlMbs41pJBScalJ0MTPWoC+v0dYFB7qGyWv?=
 =?us-ascii?Q?fM4jEyUdjWSSc9VPCLYL2gjbz8JsOfriAihInplU98zPB+j3UoLMj1bfOxt/?=
 =?us-ascii?Q?/dd01oBHK3iXYMSUsC7Uz/oPwMkLuOrm2qNHa3eflVl+RgrSb5ZhYHI7Dj0E?=
 =?us-ascii?Q?r6k9OKems8qzlihCfVpQO3e91FJ5DFbsayc1siv0lmmI2PCjKC49bgdFezuA?=
 =?us-ascii?Q?iELrdEhaATI6UtV0PqVJVbxCsaUlj4SH8qMggPQ+T+cFx+ioPHIXoCS/25z3?=
 =?us-ascii?Q?qItuaqnJp4+/2+9I6MCVwO5c0s8KTkDdN1Tfz6ECtmj1/ls63G2xSnIn/v3N?=
 =?us-ascii?Q?5SO2riA4E/Aq8M2+m+5w83KZPl5WpK4tBE1gzyLMn1MG5oVyu2gJiwqv0aVG?=
 =?us-ascii?Q?zOBmtrnYxMa8CxPRl/8ahaNPvr5hjAj2OTEMzSFiqFA8kw7jHhwIikaYNj+w?=
 =?us-ascii?Q?xXD+mL442Jgseyr6Y6EAU8p4qp1+zSxC7QO5mJ8Reiesd4+GzJzZy0+TtZ36?=
 =?us-ascii?Q?KPytWh93XlJw0g2wSwM2xT8v5A7IRifYdF0mZSS948pFeLzzylbWSEsNFGBg?=
 =?us-ascii?Q?MZ1b8JfvQAqoe6XIN4lIJ+Lc+PPTMYL6CookfPbzpaecmlQxPyvZUSiiNSIR?=
 =?us-ascii?Q?Z5qXFg2G3z2BWZa9axfvGiTA8OHJ7z7aN4QVNkjFZyYtgxVsXUV5nK1Mc/9N?=
 =?us-ascii?Q?pIrBPM7jrUv4n8jpOUnZv9hYiaQVKc0oM8DJ0VjrB53ShdHRikIbsyfC8+1p?=
 =?us-ascii?Q?lPwthq1smB4WykynLQkPcT9hw2+CwbY8/izFVZrQ5zMrVSLXV4Jq9BRP9TOZ?=
 =?us-ascii?Q?0sg8blSa60803EKMUbQm8PyJXBYbI11CRTHoFcI+IAfdt8e3VqbVqCj92VX8?=
 =?us-ascii?Q?BVtMRhN5J0LBu0or0mka1oJeCoJFgB2Oo7txFnY5G63QGJMeI2+CEZcX1oJp?=
 =?us-ascii?Q?IKWV76LBC0IyrGZW0oib3mOgAo6DYy358ivFU4eS/NBH823SK1w8d1WVLnAo?=
 =?us-ascii?Q?XhHq29+b/ocpdigD6iIQyqu0eZ3vbS0jQhHEahBCRktzmnOH7xVIAAZLqEaN?=
 =?us-ascii?Q?IinLdVOmv0YvhK3Z6u8q5nWmGk3hl/YnFWQnAbY7VmsL7sS9biPr9jNUYO9H?=
 =?us-ascii?Q?gr26HqsioZAHZgTYIW8KpF5zmm6Oa99HfpwK+cDh5UwKu5Sbr8XXKdpvqdiW?=
 =?us-ascii?Q?5os7mvPaCMiXVXHNy2x7kD3DUoC+ZtUNWo0ONUWH0hAXbsFyWqZiCPxew2Se?=
 =?us-ascii?Q?61kukOUfhFhahRrzm/MZnBoYDbbjk36bzQ6+Uvuu8O3P574/io9Bf/9IoAFo?=
 =?us-ascii?Q?VMhlDG013NXocxPwCg/v4OCqHURaKXaDksefk1t2uGn5VhRimeMtwikZ+FRq?=
 =?us-ascii?Q?KQUst07vPQ2EGffvNh3yGY/3UeXm+XZ9M/O6WB7xCEC99qUPZ+yX6wa6vPwU?=
 =?us-ascii?Q?hnjaCgga8+aik1G6d0mqfL4+z6rdLtOBt4HfLJt1ce96rbGWIV0SnWlK/zU4?=
 =?us-ascii?Q?oCuLoA0YIAfPJTScdLNF3tU1dM9bBE0BTPQxh9JRWkUa9VF+gGapGnd9stPc?=
 =?us-ascii?Q?0YEaHvdvs8TvumDrrI9V5ABHdFWp6C8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92dfbc22-67a5-4151-515c-08da1bba4d2d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 12:53:40.1372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXxWHjnYo48LIX0ydE4kmj0Vt2ydzdfFWoWXihYVAgBgrj0zYMlZya8CqwHHPySV/DDNMyj8ASqcH3+YQzq+Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2360
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_04:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110071
X-Proofpoint-ORIG-GUID: BoXR5fiPi96ZBXrv3Fn61uc9ruHlyq-i
X-Proofpoint-GUID: BoXR5fiPi96ZBXrv3Fn61uc9ruHlyq-i
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

The fourth argument of xfs_itruncate_extents_flags() and the return type of
xfs_bmapi_aflag() must be unsigned int.

Also, the data type of bmapi_flags variable in xfs_iomap_write_direct() and
xfs_fs_map_blocks() should be unsigned int.

The remaining changes look good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 22 +++++++++++-----------
>  fs/xfs/libxfs/xfs_bmap.h | 36 ++++++++++++++++++------------------
>  2 files changed, 29 insertions(+), 29 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d53dfe8db8f2..ad938e6e23aa 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -485,7 +485,7 @@ STATIC void
>  xfs_bmap_validate_ret(
>  	xfs_fileoff_t		bno,
>  	xfs_filblks_t		len,
> -	int			flags,
> +	uint32_t		flags,
>  	xfs_bmbt_irec_t		*mval,
>  	int			nmap,
>  	int			ret_nmap)
> @@ -2616,7 +2616,7 @@ xfs_bmap_add_extent_hole_real(
>  	struct xfs_btree_cur	**curp,
>  	struct xfs_bmbt_irec	*new,
>  	int			*logflagsp,
> -	int			flags)
> +	uint32_t		flags)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -3766,7 +3766,7 @@ xfs_bmapi_trim_map(
>  	xfs_fileoff_t		obno,
>  	xfs_fileoff_t		end,
>  	int			n,
> -	int			flags)
> +	uint32_t		flags)
>  {
>  	if ((flags & XFS_BMAPI_ENTIRE) ||
>  	    got->br_startoff + got->br_blockcount <= obno) {
> @@ -3811,7 +3811,7 @@ xfs_bmapi_update_map(
>  	xfs_fileoff_t		obno,
>  	xfs_fileoff_t		end,
>  	int			*n,
> -	int			flags)
> +	uint32_t		flags)
>  {
>  	xfs_bmbt_irec_t	*mval = *map;
>  
> @@ -3864,7 +3864,7 @@ xfs_bmapi_read(
>  	xfs_filblks_t		len,
>  	struct xfs_bmbt_irec	*mval,
>  	int			*nmap,
> -	int			flags)
> +	uint32_t		flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			whichfork = xfs_bmapi_whichfork(flags);
> @@ -4184,7 +4184,7 @@ xfs_bmapi_convert_unwritten(
>  	struct xfs_bmalloca	*bma,
>  	struct xfs_bmbt_irec	*mval,
>  	xfs_filblks_t		len,
> -	int			flags)
> +	uint32_t		flags)
>  {
>  	int			whichfork = xfs_bmapi_whichfork(flags);
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
> @@ -4312,7 +4312,7 @@ xfs_bmapi_write(
>  	struct xfs_inode	*ip,		/* incore inode */
>  	xfs_fileoff_t		bno,		/* starting file offs. mapped */
>  	xfs_filblks_t		len,		/* length to map in file */
> -	int			flags,		/* XFS_BMAPI_... */
> +	uint32_t		flags,		/* XFS_BMAPI_... */
>  	xfs_extlen_t		total,		/* total blocks needed */
>  	struct xfs_bmbt_irec	*mval,		/* output: map values */
>  	int			*nmap)		/* i/o: mval size/count */
> @@ -4629,7 +4629,7 @@ xfs_bmapi_remap(
>  	xfs_fileoff_t		bno,
>  	xfs_filblks_t		len,
>  	xfs_fsblock_t		startblock,
> -	int			flags)
> +	uint32_t		flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp;
> @@ -4999,7 +4999,7 @@ xfs_bmap_del_extent_real(
>  	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
>  	int			*logflagsp, /* inode logging flags */
>  	int			whichfork, /* data or attr fork */
> -	int			bflags)	/* bmapi flags */
> +	uint32_t		bflags)	/* bmapi flags */
>  {
>  	xfs_fsblock_t		del_endblock=0;	/* first block past del */
>  	xfs_fileoff_t		del_endoff;	/* first offset past del */
> @@ -5281,7 +5281,7 @@ __xfs_bunmapi(
>  	struct xfs_inode	*ip,		/* incore inode */
>  	xfs_fileoff_t		start,		/* first file offset deleted */
>  	xfs_filblks_t		*rlen,		/* i/o: amount remaining */
> -	int			flags,		/* misc flags */
> +	uint32_t		flags,		/* misc flags */
>  	xfs_extnum_t		nexts)		/* number of extents max */
>  {
>  	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
> @@ -5609,7 +5609,7 @@ xfs_bunmapi(
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		bno,
>  	xfs_filblks_t		len,
> -	int			flags,
> +	uint32_t		flags,
>  	xfs_extnum_t		nexts,
>  	int			*done)
>  {
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 29d38c3c2607..16db95b11589 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -39,7 +39,7 @@ struct xfs_bmalloca {
>  	bool			aeof;	/* allocated space at eof */
>  	bool			conv;	/* overwriting unwritten extents */
>  	int			datatype;/* data type being allocated */
> -	int			flags;
> +	uint32_t		flags;
>  };
>  
>  #define	XFS_BMAP_MAX_NMAP	4
> @@ -47,17 +47,17 @@ struct xfs_bmalloca {
>  /*
>   * Flags for xfs_bmapi_*
>   */
> -#define XFS_BMAPI_ENTIRE	0x001	/* return entire extent, not trimmed */
> -#define XFS_BMAPI_METADATA	0x002	/* mapping metadata not user data */
> -#define XFS_BMAPI_ATTRFORK	0x004	/* use attribute fork not data */
> -#define XFS_BMAPI_PREALLOC	0x008	/* preallocation op: unwritten space */
> -#define XFS_BMAPI_CONTIG	0x020	/* must allocate only one extent */
> +#define XFS_BMAPI_ENTIRE	(1u << 0) /* return entire extent untrimmed */
> +#define XFS_BMAPI_METADATA	(1u << 1) /* mapping metadata not user data */
> +#define XFS_BMAPI_ATTRFORK	(1u << 2) /* use attribute fork not data */
> +#define XFS_BMAPI_PREALLOC	(1u << 3) /* preallocating unwritten space */
> +#define XFS_BMAPI_CONTIG	(1u << 4) /* must allocate only one extent */
>  /*
>   * unwritten extent conversion - this needs write cache flushing and no additional
>   * allocation alignments. When specified with XFS_BMAPI_PREALLOC it converts
>   * from written to unwritten, otherwise convert from unwritten to written.
>   */
> -#define XFS_BMAPI_CONVERT	0x040
> +#define XFS_BMAPI_CONVERT	(1u << 5)
>  
>  /*
>   * allocate zeroed extents - this requires all newly allocated user data extents
> @@ -65,7 +65,7 @@ struct xfs_bmalloca {
>   * Use in conjunction with XFS_BMAPI_CONVERT to convert unwritten extents found
>   * during the allocation range to zeroed written extents.
>   */
> -#define XFS_BMAPI_ZERO		0x080
> +#define XFS_BMAPI_ZERO		(1u << 6)
>  
>  /*
>   * Map the inode offset to the block given in ap->firstblock.  Primarily
> @@ -75,16 +75,16 @@ struct xfs_bmalloca {
>   * For bunmapi, this flag unmaps the range without adjusting quota, reducing
>   * refcount, or freeing the blocks.
>   */
> -#define XFS_BMAPI_REMAP		0x100
> +#define XFS_BMAPI_REMAP		(1u << 7)
>  
>  /* Map something in the CoW fork. */
> -#define XFS_BMAPI_COWFORK	0x200
> +#define XFS_BMAPI_COWFORK	(1u << 8)
>  
>  /* Skip online discard of freed extents */
> -#define XFS_BMAPI_NODISCARD	0x1000
> +#define XFS_BMAPI_NODISCARD	(1u << 9)
>  
>  /* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
> -#define XFS_BMAPI_NORMAP	0x2000
> +#define XFS_BMAPI_NORMAP	(1u << 10)
>  
>  #define XFS_BMAPI_FLAGS \
>  	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
> @@ -106,7 +106,7 @@ static inline int xfs_bmapi_aflag(int w)
>  	       (w == XFS_COW_FORK ? XFS_BMAPI_COWFORK : 0));
>  }
>  
> -static inline int xfs_bmapi_whichfork(int bmapi_flags)
> +static inline int xfs_bmapi_whichfork(uint32_t bmapi_flags)
>  {
>  	if (bmapi_flags & XFS_BMAPI_COWFORK)
>  		return XFS_COW_FORK;
> @@ -183,15 +183,15 @@ int	xfs_bmap_last_offset(struct xfs_inode *ip, xfs_fileoff_t *unused,
>  		int whichfork);
>  int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
>  		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
> -		int *nmap, int flags);
> +		int *nmap, uint32_t flags);
>  int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
> -		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
> +		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
>  		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
>  int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
> -		xfs_fileoff_t bno, xfs_filblks_t *rlen, int flags,
> +		xfs_fileoff_t bno, xfs_filblks_t *rlen, uint32_t flags,
>  		xfs_extnum_t nexts);
>  int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
> -		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
> +		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
>  		xfs_extnum_t nexts, int *done);
>  int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
>  		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
> @@ -260,7 +260,7 @@ xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
>  
>  int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
> -		int flags);
> +		uint32_t flags);
>  
>  extern struct kmem_cache	*xfs_bmap_intent_cache;


-- 
chandan
