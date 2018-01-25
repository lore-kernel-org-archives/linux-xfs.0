Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbeAYRbX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 12:31:23 -0500
Date: Thu, 25 Jan 2018 12:31:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/11] xfs: always zero di_flags2 when we free the inode
Message-ID: <20180125173120.GB44175@bfoster.bfoster>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676032170.12349.11816443603352405608.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676032170.12349.11816443603352405608.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 06:18:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Always zero the di_flags2 field when we free the inode so that we never
> write reflinked non-file inode records to disk.
> 

By "non-file," do you mean "invalid" or "unallocated?"

Otherwise looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a208825..fc118dd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2465,6 +2465,7 @@ xfs_ifree(
>  
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_d.di_flags = 0;
> +	ip->i_d.di_flags2 = 0;
>  	ip->i_d.di_dmevmask = 0;
>  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
