Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Sep 2006 18:04:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8M145aG003281
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 18:04:07 -0700
Date: Fri, 22 Sep 2006 11:03:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH -mm] rescue large xfs preferred iosize from the inode diet patch
Message-ID: <20060922010316.GY3034@melbourne.sgi.com>
References: <45131334.6050803@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45131334.6050803@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Thu, Sep 21, 2006 at 05:33:24PM -0500, Eric Sandeen wrote:
> The inode diet patch in -mm unhooked xfs_preferred_iosize from the stat call:
....
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> XFS guys, does this look ok?
>
> Index: linux-2.6.18/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6.18.orig/fs/xfs/linux-2.6/xfs_iops.c
> +++ linux-2.6.18/fs/xfs/linux-2.6/xfs_iops.c
> @@ -623,12 +623,16 @@ xfs_vn_getattr(
>  {
>  	struct inode	*inode = dentry->d_inode;
>  	bhv_vnode_t	*vp = vn_from_inode(inode);
> +	xfs_inode_t	*ip;
>  	int		error = 0;
>  
>  	if (unlikely(vp->v_flag & VMODIFIED))
>  		error = vn_revalidate(vp);
> -	if (!error)
> +	if (!error) {
>  		generic_fillattr(inode, stat);
> +		ip = xfs_vtoi(vp);
> +		stat->blksize = xfs_preferred_iosize(ip->i_mount);
> +	}
>  	return -error;
>  }

ACK. Looks good, Eric. Good catch.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
