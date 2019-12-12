Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464C7C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 23:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DB9922527
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 23:01:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ah72Vvw5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbfLLXBg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 18:01:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730900AbfLLXBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 18:01:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCMnOuA083756;
        Thu, 12 Dec 2019 23:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1330yGH6eJxfXxm8wO+7145Ldrae4VZQm5/OLanU3C4=;
 b=ah72Vvw5Jj6iE3nW37yXfDZBAnTNnX3b2/r5O25GXV+/TooW86OpvyhuW7v5s17qKNYw
 owrvJrivNP7U00XCQgbw2Tug8++Pa+ul1P2F6B+pmJHbYmXVpDr7XFFseU75e4lWanZV
 CJ41IafQhyLjy22y/okp9AYZlDrvGZooXBXEPQgZrgoczUkxsEJFn4nJqKOGtDOEzsKM
 MrY4LZBqDYJNThk/4UAeNsTEBXAVjUOWEJJbv/d4G3oHf02OKtLpI0F4EIsZK7jMY7/D
 P1f/iBqxkUxHJrjkUG2sS6a4r8CiUu5N9VTZHEx0a+DKYxAW0V/p+aUkLP/SPVSNcCrV eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wrw4njvem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 23:01:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCMnBnv031101;
        Thu, 12 Dec 2019 23:01:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wumw2272p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 23:01:30 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBCN1TDM010268;
        Thu, 12 Dec 2019 23:01:29 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 15:01:29 -0800
Date:   Thu, 12 Dec 2019 15:01:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Omar Sandoval <osandov@osandov.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix log reservation overflows when allocating large
 rt extents
Message-ID: <20191212230126.GF99875@magnolia>
References: <20191204163809.GP7335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204163809.GP7335@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ping?  Omar confirms it fixes xfs for him, so all this needs now is a
formal review...

--D

On Wed, Dec 04, 2019 at 08:38:09AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Omar Sandoval reported that a 4G fallocate on the realtime device causes
> filesystem shutdowns due to a log reservation overflow that happens when
> we log the rtbitmap updates.  Factor rtbitmap/rtsummary updates into the
> the tr_write and tr_itruncate log reservation calculation.
> 
> "The following reproducer results in a transaction log overrun warning
> for me:
> 
>     mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
>     mount -o rtdev=/dev/vdc /dev/vdb /mnt
>     fallocate -l 4G /mnt/foo
> 
> Reported-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |   96 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 77 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index c55cd9a3dec9..824073a839ac 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -196,6 +196,24 @@ xfs_calc_inode_chunk_res(
>  	return res;
>  }
>  
> +/*
> + * Per-extent log reservation for the btree changes involved in freeing or
> + * allocating a realtime extent.  We have to be able to log as many rtbitmap
> + * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
> + * as well as the realtime summary block.
> + */
> +unsigned int
> +xfs_rtalloc_log_count(
> +	struct xfs_mount	*mp,
> +	unsigned int		num_ops)
> +{
> +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> +	unsigned int		rtbmp_bytes;
> +
> +	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
> +	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
> +}
> +
>  /*
>   * Various log reservation values.
>   *
> @@ -218,13 +236,21 @@ xfs_calc_inode_chunk_res(
>  
>  /*
>   * In a write transaction we can allocate a maximum of 2
> - * extents.  This gives:
> + * extents.  This gives (t1):
>   *    the inode getting the new extents: inode size
>   *    the inode's bmap btree: max depth * block size
>   *    the agfs of the ags from which the extents are allocated: 2 * sector
>   *    the superblock free block counter: sector size
>   *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> - * And the bmap_finish transaction can free bmap blocks in a join:
> + * Or, if we're writing to a realtime file (t2):
> + *    the inode getting the new extents: inode size
> + *    the inode's bmap btree: max depth * block size
> + *    the agfs of the ags from which the extents are allocated: 2 * sector
> + *    the superblock free block counter: sector size
> + *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
> + *    the realtime summary: 1 block
> + *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
> + * And the bmap_finish transaction can free bmap blocks in a join (t3):
>   *    the agfs of the ags containing the blocks: 2 * sector size
>   *    the agfls of the ags containing the blocks: 2 * sector size
>   *    the super block free block counter: sector size
> @@ -234,40 +260,72 @@ STATIC uint
>  xfs_calc_write_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> -		max((xfs_calc_inode_res(mp, 1) +
> +	unsigned int		t1, t2, t3;
> +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> +
> +	t1 = xfs_calc_inode_res(mp, 1) +
> +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
> +	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> +
> +	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> +		t2 = xfs_calc_inode_res(mp, 1) +
>  		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
> -				      XFS_FSB_TO_B(mp, 1)) +
> +				      blksz) +
>  		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> -				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> -				      XFS_FSB_TO_B(mp, 1))));
> +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
> +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
> +	} else {
> +		t2 = 0;
> +	}
> +
> +	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> +
> +	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
>  }
>  
>  /*
> - * In truncating a file we free up to two extents at once.  We can modify:
> + * In truncating a file we free up to two extents at once.  We can modify (t1):
>   *    the inode being truncated: inode size
>   *    the inode's bmap btree: (max depth + 1) * block size
> - * And the bmap_finish transaction can free the blocks and bmap blocks:
> + * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
>   *    the agf for each of the ags: 4 * sector size
>   *    the agfl for each of the ags: 4 * sector size
>   *    the super block to reflect the freed blocks: sector size
>   *    worst case split in allocation btrees per extent assuming 4 extents:
>   *		4 exts * 2 trees * (2 * max depth - 1) * block size
> + * Or, if it's a realtime file (t3):
> + *    the agf for each of the ags: 2 * sector size
> + *    the agfl for each of the ags: 2 * sector size
> + *    the super block to reflect the freed blocks: sector size
> + *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
> + *    the realtime summary: 2 exts * 1 block
> + *    worst case split in allocation btrees per extent assuming 2 extents:
> + *		2 exts * 2 trees * (2 * max depth - 1) * block size
>   */
>  STATIC uint
>  xfs_calc_itruncate_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> -		max((xfs_calc_inode_res(mp, 1) +
> -		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
> -				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
> -				      XFS_FSB_TO_B(mp, 1))));
> +	unsigned int		t1, t2, t3;
> +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> +
> +	t1 = xfs_calc_inode_res(mp, 1) +
> +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
> +
> +	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> +
> +	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> +		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
> +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> +	} else {
> +		t3 = 0;
> +	}
> +
> +	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
>  }
>  
>  /*
