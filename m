Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 16:38:13 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ0bumH005493
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 16:37:59 -0800
Date: Wed, 19 Dec 2007 11:37:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs mknod regression
Message-ID: <20071219003745.GR4396912@sgi.com>
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com> <20071218173642.GA7338@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218173642.GA7338@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, rjw@sisk.pl

On Tue, Dec 18, 2007 at 05:36:42PM +0000, Christoph Hellwig wrote:
> 
> This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
> which assigned the re-shuffled ondisk dev_t back to the rdev variable in
> xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
> of the linux dev_t later down the function.
> 
> Fortunately the fix for it is trivial:  we can just remove the
> assignment because xfs_revalidate_inode has done the proper job before
> unlocking the inode.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:32.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:43.000000000 +0100
> @@ -345,9 +345,7 @@ xfs_vn_mknod(
>  		ASSERT(vp);
>  		ip = vn_to_inode(vp);
>  
> -		if (S_ISCHR(mode) || S_ISBLK(mode))
> -			ip->i_rdev = rdev;
> -		else if (S_ISDIR(mode))
> +		if (S_ISDIR(mode))
>  			xfs_validate_fields(ip);
>  		d_instantiate(dentry, ip);
>  		xfs_validate_fields(dir);

Thanks for this, Christoph - I'll run some tests on it and check it in.

Rafael - this is a regression introduced in 2.6.24-rc1 if you want to
track it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
