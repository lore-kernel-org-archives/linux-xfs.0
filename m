Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF7ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 792FD21D71
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WZ3Kk6CX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392963AbfJYFd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:33:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732032AbfJYFd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:33:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5StPn119548;
        Fri, 25 Oct 2019 05:33:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9eSIjGzv2AVGuQiFgQwsVMFWsxbQmve4+wltKlJQzC0=;
 b=WZ3Kk6CXd3z0oKXXw5b9ZC4/LzeLFZUESm8/16G9GwNT4ASycvQS9073RqLjiSG5ASFm
 z/xNNrwm3L7to6en4v6TFdUavn0zZc02wxmQx+WdokN7wBa80Y2wBeJqT/gwTmftochp
 +d3jyB4c+OjqO2PkxkXANFHBhMO2W9Jtf1icuTuu0/qrYg+WJv5/BVhgcbnR+IEmEpxi
 6dalqEWWW1I4skzfHcCFm8zmUbf+/i1XnnaSp1h1VqAQkBNOubTm7DSrEVK1UjoOdYx3
 M0l3luo0J5Er72R4ZtoEoxxMLiV//e+ohSoqlwXt+bWI7a6DO5HzshKQVivuikw6POm3 mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqteq880a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 05:33:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5RfZK189716;
        Fri, 25 Oct 2019 05:31:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vug0d9vt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 05:31:51 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9P5Voxr014141;
        Fri, 25 Oct 2019 05:31:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:31:49 -0700
Date:   Thu, 24 Oct 2019 22:31:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a xfs_inode_buftarg helper
Message-ID: <20191025053149.GD913374@magnolia>
References: <20191025021852.20172-1-hch@lst.de>
 <20191025021852.20172-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025021852.20172-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250053
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 11:18:50AM +0900, Christoph Hellwig wrote:
> Add a new xfs_inode_buftarg helper that gets the data I/O buftarg for a
> given inode.  Replace the existing xfs_find_bdev_for_inode and
> xfs_find_daxdev_for_inode helpers with this new general one and cleanup
> some of the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c      | 34 +++++-----------------------------
>  fs/xfs/xfs_aops.h      |  3 ---
>  fs/xfs/xfs_bmap_util.c | 15 ++++++++-------
>  fs/xfs/xfs_file.c      | 14 +++++++-------
>  fs/xfs/xfs_inode.h     |  7 +++++++
>  fs/xfs/xfs_ioctl.c     |  7 +++----
>  fs/xfs/xfs_iomap.c     | 11 +++++++----
>  fs/xfs/xfs_iops.c      |  2 +-
>  8 files changed, 38 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 5d3503f6412a..3a688eb5c5ae 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -30,32 +30,6 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
>  	return container_of(ctx, struct xfs_writepage_ctx, ctx);
>  }
>  
> -struct block_device *
> -xfs_find_bdev_for_inode(
> -	struct inode		*inode)
> -{
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_mount	*mp = ip->i_mount;
> -
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		return mp->m_rtdev_targp->bt_bdev;
> -	else
> -		return mp->m_ddev_targp->bt_bdev;
> -}
> -
> -struct dax_device *
> -xfs_find_daxdev_for_inode(
> -	struct inode		*inode)
> -{
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_mount	*mp = ip->i_mount;
> -
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		return mp->m_rtdev_targp->bt_daxdev;
> -	else
> -		return mp->m_ddev_targp->bt_daxdev;
> -}
> -
>  /*
>   * Fast and loose check if this write could update the on-disk inode size.
>   */
> @@ -609,9 +583,11 @@ xfs_dax_writepages(
>  	struct address_space	*mapping,
>  	struct writeback_control *wbc)
>  {
> -	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> +	struct xfs_inode	*ip = XFS_I(mapping->host);
> +
> +	xfs_iflags_clear(ip, XFS_ITRUNCATED);
>  	return dax_writeback_mapping_range(mapping,
> -			xfs_find_bdev_for_inode(mapping->host), wbc);
> +			xfs_inode_buftarg(ip)->bt_bdev, wbc);
>  }
>  
>  STATIC sector_t
> @@ -661,7 +637,7 @@ xfs_iomap_swapfile_activate(
>  	struct file			*swap_file,
>  	sector_t			*span)
>  {
> -	sis->bdev = xfs_find_bdev_for_inode(file_inode(swap_file));
> +	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
>  	return iomap_swapfile_activate(sis, swap_file, span,
>  			&xfs_read_iomap_ops);
>  }
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 687b11f34fa2..e0bd68419764 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -11,7 +11,4 @@ extern const struct address_space_operations xfs_dax_aops;
>  
>  int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
>  
> -extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
> -extern struct dax_device *xfs_find_daxdev_for_inode(struct inode *);
> -
>  #endif /* __XFS_AOPS_H__ */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 5d8632b7f549..9b0572a7b03a 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -53,15 +53,16 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
>   */
>  int
>  xfs_zero_extent(
> -	struct xfs_inode *ip,
> -	xfs_fsblock_t	start_fsb,
> -	xfs_off_t	count_fsb)
> +	struct xfs_inode	*ip,
> +	xfs_fsblock_t		start_fsb,
> +	xfs_off_t		count_fsb)
>  {
> -	struct xfs_mount *mp = ip->i_mount;
> -	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
> -	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +	xfs_daddr_t		sector = xfs_fsb_to_db(ip, start_fsb);
> +	sector_t		block = XFS_BB_TO_FSBT(mp, sector);
>  
> -	return blkdev_issue_zeroout(xfs_find_bdev_for_inode(VFS_I(ip)),
> +	return blkdev_issue_zeroout(target->bt_bdev,
>  		block << (mp->m_super->s_blocksize_bits - 9),
>  		count_fsb << (mp->m_super->s_blocksize_bits - 9),
>  		GFP_NOFS, 0);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 24659667d5cb..ee4ebb7904f6 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1229,22 +1229,22 @@ static const struct vm_operations_struct xfs_file_vm_ops = {
>  
>  STATIC int
>  xfs_file_mmap(
> -	struct file	*filp,
> -	struct vm_area_struct *vma)
> +	struct file		*file,
> +	struct vm_area_struct	*vma)
>  {
> -	struct dax_device 	*dax_dev;
> +	struct inode		*inode = file_inode(file);
> +	struct xfs_buftarg	*target = xfs_inode_buftarg(XFS_I(inode));
>  
> -	dax_dev = xfs_find_daxdev_for_inode(file_inode(filp));
>  	/*
>  	 * We don't support synchronous mappings for non-DAX files and
>  	 * for DAX files if underneath dax_device is not synchronous.
>  	 */
> -	if (!daxdev_mapping_supported(vma, dax_dev))
> +	if (!daxdev_mapping_supported(vma, target->bt_daxdev))
>  		return -EOPNOTSUPP;
>  
> -	file_accessed(filp);
> +	file_accessed(file);
>  	vma->vm_ops = &xfs_file_vm_ops;
> -	if (IS_DAX(file_inode(filp)))
> +	if (IS_DAX(inode))
>  		vma->vm_flags |= VM_HUGEPAGE;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 558173f95a03..bcfb35a9c5ca 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -219,6 +219,13 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
>  	return ip->i_cowfp && ip->i_cowfp->if_bytes;
>  }
>  
> +/*
> + * Return the buftarg used for data allocations on a given inode.
> + */
> +#define xfs_inode_buftarg(ip) \
> +	(XFS_IS_REALTIME_INODE(ip) ? \
> +		(ip)->i_mount->m_rtdev_targp : (ip)->i_mount->m_ddev_targp)
> +
>  /*
>   * In-core inode flags.
>   */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d58f0d6a699e..b7b5c17131cd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1311,10 +1311,9 @@ xfs_ioctl_setattr_dax_invalidate(
>  	 * have to check the device for dax support or flush pagecache.
>  	 */
>  	if (fa->fsx_xflags & FS_XFLAG_DAX) {
> -		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
> -			return -EINVAL;

Um... why are we're removing this mode check?

--D

> -		if (!bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
> -				sb->s_blocksize))
> +		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +
> +		if (!bdev_dax_supported(target->bt_bdev, sb->s_blocksize))
>  			return -EINVAL;
>  	}
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index bf0c7756ac90..c1063507e5fd 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -57,6 +57,7 @@ xfs_bmbt_to_iomap(
>  	u16			flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
>  
>  	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
>  		return xfs_alert_fsblock_zero(ip, imap);
> @@ -77,8 +78,8 @@ xfs_bmbt_to_iomap(
>  	}
>  	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
>  	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
> -	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
> -	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
> +	iomap->bdev = target->bt_bdev;
> +	iomap->dax_dev = target->bt_daxdev;
>  	iomap->flags = flags;
>  
>  	if (xfs_ipincount(ip) &&
> @@ -94,12 +95,14 @@ xfs_hole_to_iomap(
>  	xfs_fileoff_t		offset_fsb,
>  	xfs_fileoff_t		end_fsb)
>  {
> +	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +
>  	iomap->addr = IOMAP_NULL_ADDR;
>  	iomap->type = IOMAP_HOLE;
>  	iomap->offset = XFS_FSB_TO_B(ip->i_mount, offset_fsb);
>  	iomap->length = XFS_FSB_TO_B(ip->i_mount, end_fsb - offset_fsb);
> -	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
> -	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
> +	iomap->bdev = target->bt_bdev;
> +	iomap->dax_dev = target->bt_daxdev;
>  }
>  
>  static inline xfs_fileoff_t
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 329a34af8e79..404f2dd58698 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1227,7 +1227,7 @@ xfs_inode_supports_dax(
>  		return false;
>  
>  	/* Device has to support DAX too. */
> -	return xfs_find_daxdev_for_inode(VFS_I(ip)) != NULL;
> +	return xfs_inode_buftarg(ip)->bt_daxdev != NULL;
>  }
>  
>  STATIC void
> -- 
> 2.20.1
> 
