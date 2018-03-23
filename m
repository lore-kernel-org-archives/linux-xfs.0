Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60451 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751595AbeCWBaj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 21:30:39 -0400
Date: Fri, 23 Mar 2018 01:30:37 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180323013037.GA9190@wotan.suse.de>
References: <20171123060137.GL2135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171123060137.GL2135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 22, 2017 at 10:01:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_ifree, we reset the data/attr forks to extents format without
> bothering to free any inline data buffer that might still be around
> after all the blocks have been truncated off the file.  Prior to commit
> 43518812d2 ("xfs: remove support for inlining data/extents into the
> inode fork") nobody noticed because the leftover inline data after
> truncation was small enough to fit inside the inline buffer inside the
> fork itself.
> 
> However, now that we've removed the inline buffer, we /always/ have to
> free the inline data buffer or else we leak them like crazy.  This test
> was found by turning on kmemleak for generic/001 or generic/388.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 61d1cb7..8012741 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2401,6 +2401,24 @@ xfs_ifree_cluster(
>  }
>  
>  /*
> + * Free any local-format buffers sitting around before we reset to
> + * extents format.
> + */
> +static inline void
> +xfs_ifree_local_data(
> +	struct xfs_inode	*ip,
> +	int			whichfork)
> +{
> +	struct xfs_ifork	*ifp;
> +
> +	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> +		return;

I'm new to all this so this was a bit hard to follow. I'm confused with how
commit 43518812d2 ("xfs: remove support for inlining data/extents into the
inode fork") exacerbated the leak, isn't that commit about
XFS_DINODE_FMT_EXTENTS?

Did we have cases where the format was XFS_DINODE_FMT_LOCAL and yet
ifp->if_u1.if_data == ifp->if_u2.if_inline_data ?

  Luis
