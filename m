Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5589C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 11:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241778AbiEPLCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 07:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241000AbiEPLCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 07:02:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E575F55
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 04:02:01 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G8kS6i020757;
        Mon, 16 May 2022 11:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=L1K5fMgx3UryA2zbO+hljMxPi7sIaIM6VsylMytABFs=;
 b=n3TrfDFm0kpQ39F65iezkgdFEjt2Zoa1Vd4UhvNwZ6nPsAJvWBfG43qRW/v5W7iqDam9
 qOhv+aiy3ALgdUKPGiz2jqWugGwHYuchnL5/n5ThV0Am1o04mYosxyVUX+7syi0fBjQy
 U7EGkkFBlx3CXZAChPM9s354tIGR6HJkNjfaAHCY42XVk/XeMLY6rpHFgy6nRqgsxWhx
 f7aC7Oh33q6742LKyYytvp5gkBP5sdhXq+Ha6xQ8YUPt3gwP/chYa+Ed3C2rBJg82eZ4
 ibbsKpdOL1Ce8PoOBKGCzpsd1a1DdxX7/RfpDiZ0OuVuvkZ9HgpMl+mqnjCf+utPjQSE kg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310jxw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 11:01:56 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GB1sT6009942;
        Mon, 16 May 2022 11:01:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v78vbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 11:01:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmmU8NzkQf+KlETRPybRYuYNXs77eSvjClapAS7O55OqX8ow/fdJ8BI02rPCi+Ll+/xHj9Ke9A6QGY37Vg09+dcNpT0M6TSO3PjooaIBiZPgikdwGgLCq4n/f9NAzfj3T86DrSqxphx1qbS3hp96tLik2DqIhOJWF4W2UhLCyRehu3V6PGOi/DLHsZO9on5+bNZRpg63Kro2IINA1770laRA9Bah2e5P0nVN9CQ2Gpjc5J3F59zIQJ3OhSgRgLqoYk6HuL/4/lyvq1Ajao+fz+2lFsTb43h0oIUxS+uQY+FTcyQOJ0oes+RhyeLVSztLU2r1kcJ/goaXUg94dD7TJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1K5fMgx3UryA2zbO+hljMxPi7sIaIM6VsylMytABFs=;
 b=S5hxDlcseBDfPEOZAvGAEGxNiWd5Hdj9//cy+G0UYy874Z13PCY22MudS/BtJZi5kzvrfNnLP2fJOCK9rqVau7aj1UnyXUtk8zYdyfRjs75KbhLj5GjlUhto75MofZI58VuU8NJ/bVN49+lcxDoYF6wuqOcZyKw5Tkz3DDMD/eU/nC5RWeXQtGDcSxlAMkJ1M/kurdj+I+mEujsNApG71UMcnYYWn+fb30RwjYoMapIte2Wmj1boUe+WNWyYO5PDZLm/RJRQI/KjvY/7B1HooulhkXBg5p1LmxMh7TC4cJ6BqXb6XfDw9fFfzk3XPATUcp+D6XDv7JA+rTwqcBK4Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1K5fMgx3UryA2zbO+hljMxPi7sIaIM6VsylMytABFs=;
 b=VMpLbgykxluMSJmKQ9PH52yTmvI5pD5u1ZTcX+Rv7m//+HU3YcjdsQp83vE765oysJpgxdxodSOrKhYMRELAMXTaNBlkIcFAZb5H1l27X5Vmk6gHmmsocMUM85u4EGu/qQxooxXCkKNufAyLcJ+wBPBmdbXC2SHbGFN6GjlCRAc=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BL0PR10MB3444.namprd10.prod.outlook.com (2603:10b6:208:73::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 11:01:47 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 11:01:47 +0000
References: <165247403337.275439.13973873324817048674.stgit@magnolia>
 <165247405608.275439.17901954488914628121.stgit@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: check the rt summary against observations
Date:   Mon, 16 May 2022 16:30:27 +0530
In-reply-to: <165247405608.275439.17901954488914628121.stgit@magnolia>
Message-ID: <87sfp9rbak.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0013.jpnprd01.prod.outlook.com (2603:1096:404::25)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4930f7f3-8b11-4481-0388-08da372b78ae
X-MS-TrafficTypeDiagnostic: BL0PR10MB3444:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB3444DDCCB79C54D6FF6AA8DEF6CF9@BL0PR10MB3444.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+gXkC5Hf1u1JzJ87yjiAyNIsU6Yp9D87ALF3C17Saal0j0YH1Wln8vw8Sp/chcRBQgSb60FcJSGpu55BPfMRROHM76x0mHX7h5Guk/OuEM1OZwieOF7FwYx1SMxV8feEce/9+Q6pjFdgf6OOGKnO8SeRPZ9pV7yh9DlZFQ+mxCeuva8voh8p8axjWE/EXtCaF61apMml7kywWV4l7lOJD3CyVjPSOeLUHKrGH9sDdnPhRnysTIoPn6mYUALWEbsp+OkAPN3hY0lqJ86YL8v0zG0ICMQJWzAQg5BPTmSHiTuFyWLULzYi4kcGSoJaKOsp3p+56mfom947AnzkPRL4y6FIlKOMAR8o5sjb3wJEMnm53euSufLUr7tCSrC8t1OY3DSXDtv06KAXZj/g197NYl7qo527BR69okxAgTdXRpS//KHyCHRwTcDkIS2BXYJynoe9aZ+oW6rglFUt7eSfoR0g+XDpA3IQ9LoxGqsPmcfBHTI8FPJF7teiwSFBFgwXmMJj9MUfszzCHVei6atpGvA4j8O4qu+BrR2x8irjKqIGLYY7j0Q8yM7bXsHpK3ZbgnmkZiTXDqJf+HQ0fU1hm0yahjQTti32UWFYCEgK2A7SkGkY+/apTNoA+Agf49lH6jG69XtmBE/toiWtcUyw7Qw97M+hOTvolAgZ0868YczUaQ3vO8OEpulW3w16T8yZ3V7X7qS15xTCWPsWu42yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66476007)(5660300002)(66556008)(508600001)(86362001)(38100700002)(2906002)(6506007)(6666004)(6512007)(83380400001)(66946007)(4326008)(6486002)(38350700002)(316002)(6916009)(8936002)(33716001)(186003)(52116002)(8676002)(53546011)(26005)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kyVvpGWvq/UIbfq3SB4sGd8dbni5V2/X7TkfSKx4wQOmE7K23+ww9LgeO/vM?=
 =?us-ascii?Q?w7Wt/4UIlYNTwnlUhDKFeQdUtSat0hCjimINH4NJV92Qj9Kjp7ZXEHsezq/v?=
 =?us-ascii?Q?yPbLrsCj93Q1kUeYbBqX9QbXTTuXKm5c4MFJa3CJAOCV0ny/Oj+OHRSFSqkh?=
 =?us-ascii?Q?5FD3XjsGYrVElUyjzihri3ZB/j64wWu6fF+9ROoDPUV8hKBWhl3dg4okZ3Rg?=
 =?us-ascii?Q?pH12Mnnx5wRPW3Oxs9fsuxGCcPlOQ7DZhoC8xkDNxDptJ8pEUS8AF06z7RGQ?=
 =?us-ascii?Q?JWwizGGBwi/U3z+EaKGP/YTnt/LIn04yMVvoX861RH3gV1a1ZVgctVU9KZcm?=
 =?us-ascii?Q?88Uu1as4ayOKKVUtOsWqhcKLYfWnWOsNQt4GRJld2OHtrHBYnQmJA4KchE+f?=
 =?us-ascii?Q?beLl4uAbRIL1F2aoPpjNdEw/duNniVoo/ZxwdWH5ypinGElDTQenAehk2Hq/?=
 =?us-ascii?Q?WLPhZtENNVn+78cO/4oPQIuhexyizpWlq+7xUEMdXcx5XrDISmCJ+Vsf+t5b?=
 =?us-ascii?Q?DUsEEX1G0eo8byeL+FDBYWMUJIb80XnxyIrO4fk9yj4n/2rjrf9h0n5dLn3s?=
 =?us-ascii?Q?G+WC+OETiwVXFmAocbGrqNWPAXehfdxQjRjfpZ9+A/7VpatwFOABfVVL+dPo?=
 =?us-ascii?Q?BpKOaekChcknE21rTzh9qNQIyHxTtOcway7MK6x7Oz5YjlGT1Q51G0DaJRug?=
 =?us-ascii?Q?H4zocM/zLvqc9u35fEIMfhFO6/I2VQpgjJOPxizb2q5mSzkhLe1jGE1WwLrt?=
 =?us-ascii?Q?JV3oL2UeJrzZXc6N5BGD67LrkRKs060k4nYix1DRHDvC5DI2HlB5DRWb60RO?=
 =?us-ascii?Q?1+58ClmYyYj0WtpusJ9LvOGHXf+1why0wjs2I33ke1BGwJIt2TvelT1tHDJF?=
 =?us-ascii?Q?AAuaCsYpOa1rgOAsU0Y8xnasyKQV1AbqIrO983ahkxcOOjCRR8bK+pWu8nr9?=
 =?us-ascii?Q?U15585LmHrg3xXP5GVseB2ciz93rxqI/mRzeGRxV5naKNpqtDt8JWKQ+3IV3?=
 =?us-ascii?Q?qrFX6su+uxxEZnINUNjuvuLKGmlnZbWwif3cHIiypUqWie587GbOEGQSJi4A?=
 =?us-ascii?Q?tx6OKh7OXymwFXEVg+HZcKeGioJ8s7tImqZnOdzV9Msq9mctNZvltX6yY7nN?=
 =?us-ascii?Q?b/EVBeVK+cZyglZt5xAwExDEflNgS1r181T4+iP7EGEdWGdEEM7e9BYs5ILd?=
 =?us-ascii?Q?GJvxna+nfXW7aF71ZGL2mG5dnji3N5RHT5OVuXgfFrIrLvJtGqqtlApueALj?=
 =?us-ascii?Q?Y0sx/m+btKAEKH7PjTGnNNcq1vgi5Q9gs5v/Iif/Z5FuPp63ZdkKQt3Jr1JO?=
 =?us-ascii?Q?L8XEtRtSq52GFl54KyhgqGaaYgq/4X35AHnAvnvmSSatXbAZYw8dolOnYiZ7?=
 =?us-ascii?Q?BwuzxxZif1Rtic8Rq9juYaqMfKtIjcJmdoZEDt64nYWOCva4pPhCoYAOLe8c?=
 =?us-ascii?Q?5CDD4+F6LNK08a9RFKfoAtbJfBPr49Bxy8vVhN4CWMhIeeCtu3yAunxQM7E/?=
 =?us-ascii?Q?1Zs9UZ92jvH/ksjkhDpIEG5ZbOadSu4NLy8RXpsUgm+Kd7/W1UVhpeKkjsDZ?=
 =?us-ascii?Q?A6jm6c/inIc0kGS/jLqw4DjRuP5cXLfPJjrZuX6AYUp8zk0hxburQhk0uWQ0?=
 =?us-ascii?Q?Ksohe6NRQp2XyRvJviiFqDMydyf6/3eZv5ycRsvkG1VBaQmvrbSVHEvUZLbF?=
 =?us-ascii?Q?yW8AXnm5expgfiQd7IZG+us/y55eRoN9sHjkMY4lsZPzEr5jgIszLndGbQxC?=
 =?us-ascii?Q?ahLiZ2pThg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4930f7f3-8b11-4481-0388-08da372b78ae
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 11:01:47.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tuhIQgT7u1DEuEVwQxpEYzYP7rbfolE8b2zdQcH83D8sBNELHDqzZ624OzKD6+WBBwwkcz/+EW88NgANQYBU0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3444
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_06:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160065
X-Proofpoint-ORIG-GUID: L-b01Ip1pGvEnRXnGn0t9YomCazfGouZ
X-Proofpoint-GUID: L-b01Ip1pGvEnRXnGn0t9YomCazfGouZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 13, 2022 at 01:34:16 PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Teach xfs_repair to check the ondisk realtime summary file against its
> own observations.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/phase5.c |    1 +
>  repair/rt.c     |   71 +++++--------------------------------------------------
>  repair/rt.h     |   11 +--------
>  3 files changed, 8 insertions(+), 75 deletions(-)
>
>
> diff --git a/repair/phase5.c b/repair/phase5.c
> index d1ddd224..b04912d8 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -609,6 +609,7 @@ check_rtmetadata(
>  	rtinit(mp);
>  	generate_rtinfo(mp, btmcompute, sumcompute);
>  	check_rtbitmap(mp);
> +	check_rtsummary(mp);
>  }
>  
>  void
> diff --git a/repair/rt.c b/repair/rt.c
> index b964d168..a4cca7aa 100644
> --- a/repair/rt.c
> +++ b/repair/rt.c
> @@ -198,72 +198,13 @@ check_rtbitmap(
>  			mp->m_sb.sb_rbmblocks);
>  }
>  
> -#if 0
> -/*
> - * returns 1 if bad, 0 if good
> - */
> -int
> -check_summary(xfs_mount_t *mp)
> -{
> -	xfs_rfsblock_t	bno;
> -	xfs_suminfo_t	*csp;
> -	xfs_suminfo_t	*fsp;
> -	int		log;
> -	int		error = 0;
> -
> -	error = 0;
> -	csp = sumcompute;
> -	fsp = sumfile;
> -	for (log = 0; log < mp->m_rsumlevels; log++) {
> -		for (bno = 0;
> -		     bno < mp->m_sb.sb_rbmblocks;
> -		     bno++, csp++, fsp++) {
> -			if (*csp != *fsp) {
> -				do_warn(
> -	_("rt summary mismatch, size %d block %llu, file: %d, computed: %d\n"),
> -						log, bno, *fsp, *csp);
> -				error = 1;
> -			}
> -		}
> -	}
> -
> -	return(error);
> -}
> -
> -/*
> - * copy the real-time summary file data into memory
> - */
>  void
> -process_rtsummary(
> -	xfs_mount_t		*mp,
> -	struct xfs_dinode	*dino,
> -	blkmap_t		*blkmap)
> +check_rtsummary(
> +	struct xfs_mount	*mp)
>  {
> -	xfs_fsblock_t		bno;
> -	struct xfs_buf		*bp;
> -	char			*bytes;
> -	int			sumbno;
> +	if (need_rsumino)
> +		return;
>  
> -	for (sumbno = 0; sumbno < blkmap->count; sumbno++) {
> -		bno = blkmap_get(blkmap, sumbno);
> -		if (bno == NULLFSBLOCK) {
> -			do_warn(_("block %d for rtsummary inode is missing\n"),
> -					sumbno);
> -			error++;
> -			continue;
> -		}
> -		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> -				XFS_FSB_TO_BB(mp, 1), 0, NULL, &bp);
> -		if (error) {
> -			do_warn(_("can't read block %d for rtsummary inode\n"),
> -					sumbno);
> -			error++;
> -			continue;
> -		}
> -		bytes = bp->b_un.b_addr;
> -		memmove((char *)sumfile + sumbno * mp->m_sb.sb_blocksize, bytes,
> -			mp->m_sb.sb_blocksize);
> -		libxfs_buf_relse(bp);
> -	}
> +	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
> +			XFS_B_TO_FSB(mp, mp->m_rsumsize));
>  }
> -#endif
> diff --git a/repair/rt.h b/repair/rt.h
> index 2023153f..be24e91c 100644
> --- a/repair/rt.h
> +++ b/repair/rt.h
> @@ -17,15 +17,6 @@ generate_rtinfo(xfs_mount_t	*mp,
>  		xfs_suminfo_t	*sumcompute);
>  
>  void check_rtbitmap(struct xfs_mount *mp);
> -
> -#if 0
> -
> -int
> -check_summary(xfs_mount_t	*mp);
> -
> -void
> -process_rtsummary(xfs_mount_t	*mp,
> -		struct blkmap	*blkmap);
> -#endif
> +void check_rtsummary(struct xfs_mount *mp);
>  
>  #endif /* _XFS_REPAIR_RT_H_ */


-- 
chandan
