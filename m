Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B5AF7CD4
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 18:11:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECECB8F8035
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 16:10:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PBAKujCHFb73HUzE for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2016 16:10:52 -0700 (PDT)
Date: Thu, 24 Mar 2016 10:05:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: set up inode operation vectors later
Message-ID: <20160323230500.GZ30721@dastard>
References: <1458740935-31260-1-git-send-email-hch@lst.de>
	<1458740935-31260-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458740935-31260-3-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Mar 23, 2016 at 02:48:53PM +0100, Christoph Hellwig wrote:
> In the next patch we'll set up different inode operations for inline vs
> out of line symlinks, for that we need to make sure the flags are already
> set up properly.
....
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index fb7dc61..f08d91c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -181,6 +181,8 @@ xfs_generic_create(
>  	}
>  #endif
>  
> +	xfs_setup_iops(ip);
> +
>  	if (tmpfile)
>  		d_tmpfile(dentry, inode);
>  	else
> @@ -368,6 +370,8 @@ xfs_vn_symlink(
>  	if (unlikely(error))
>  		goto out_cleanup_inode;
>  
> +	xfs_setup_iops(cip);
> +
>  	d_instantiate(dentry, inode);
>  	xfs_finish_inode_setup(cip);

I think there are more places than this that need xfs_setup_iops()
calls - a quick look around makes me think they need to be paired
with every path that calls xfs_finish_inode_setup().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
