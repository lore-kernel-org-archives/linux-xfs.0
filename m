Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37747 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdICItQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 04:49:16 -0400
Date: Sun, 3 Sep 2017 01:49:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] fs/xfs: Add real-time device support to statfs
Message-ID: <20170903084914.GD32385@infradead.org>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170902224145.1291030-3-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902224145.1291030-3-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, darrick.wong@oracle.com

On Sat, Sep 02, 2017 at 03:41:44PM -0700, Richard Wareing wrote:
> - Reports real-time device free blocks in statfs calls if
> inheritance bit is set on the inode of directory.  This is a bit more
> intuitive, especially for use-cases which are using a much larger
> device for the real-time device.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>
> ---
>  fs/xfs/xfs_super.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4dbf95c..a1d6968 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1148,6 +1148,12 @@ xfs_fs_statfs(
>  	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
>  			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
>  		xfs_qm_statvfs(ip, statp);
> +	if ((ip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) &&
> +		(mp->m_rtdev_targp != NULL)) {

	if ((ip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) && mp->m_rtdev_targp) {

> +		statp->f_blocks = sbp->sb_rblocks;
> +		statp->f_bfree = sbp->sb_frextents * sbp->sb_rextsize -
> +			mp->m_alloc_set_aside;
> +	}

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
