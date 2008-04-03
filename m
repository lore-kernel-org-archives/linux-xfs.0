Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 21:33:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m334X0Zt003411
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 21:33:03 -0700
Date: Thu, 3 Apr 2008 14:33:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 3/7] XFS: Refactor node format directory lookup/addname
Message-ID: <20080403043329.GQ103491721@sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.380299192@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062708.380299192@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:11PM +1000, Barry Naujok wrote:
> The next step for case-insensitive support is to avoid polution of
> the dentry cache with entries pointing to the same inode, but with
> names that only differ in case.
> 
> To perform this, we will need to pass the actual filename that
> matched backup to the XFS/VFS interface and make sure the dentry
> cache only contains entries with the actual case-sensitive name.
> 
> But, before we can do this, it was found that the directory lookup
> code with multiple leaves was shared with code adding a name to
> that directory. Most of xfs_dir2_leafn_lookup_int() could be broken
> into two functions determined by if (args->addname) { } else { }.
> 
> For the following patch, only the lookup case needs to handle the
> various xfs_nameops, with case-insensitive match handling in
> addition to returning the actual name.
> 
> So, this patch separates xfs_dir2_leafn_lookup_int() into
> xfs_dir2_leafn_lookup_for_addname() and xfs_dir2_leafn_lookup_for_entry().
> 
> xfs_dir2_leafn_lookup_for_addname() iterates through the data blocks looking
> for a suitable empty space to insert the name while
> xfs_dir2_leafn_lookup_for_entry() uses the xfs_nameops to find the entry.
> 
> xfs_dir2_leafn_lookup_for_entry() path also retains the data block where
> the first case-insensitive match occured as in the next patch which will
> return the name, the name is obtained from that block.
> 
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> 
> ---
>  fs/xfs/xfs_dir2_node.c |  373 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 225 insertions(+), 148 deletions(-)
> 
> Index: kern_ci/fs/xfs/xfs_dir2_node.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_dir2_node.c
> +++ kern_ci/fs/xfs/xfs_dir2_node.c
> @@ -387,12 +387,11 @@ xfs_dir2_leafn_lasthash(
>  }
>  
>  /*
> - * Look up a leaf entry in a node-format leaf block.
> - * If this is an addname then the extrablk in state is a freespace block,
> - * otherwise it's a data block.
> + * Look up a leaf entry for space to add a name in a node-format leaf block.
> + * The extrablk in state is a freespace block.
>   */
> -int
> -xfs_dir2_leafn_lookup_int(
> +static int

STATIC

(and for the other new function)

> +xfs_dir2_leafn_lookup_for_addname(
>  	xfs_dabuf_t		*bp,		/* leaf buffer */
>  	xfs_da_args_t		*args,		/* operation arguments */
>  	int			*indexp,	/* out: leaf entry index */
....

> @@ -1785,6 +1857,11 @@ xfs_dir2_node_lookup(
>  	if (error)
>  		rval = error;
>  	/*
> +	 * If case-insensitive match was found in a leaf, return EEXIST.
> +	 */
> +	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE)
> +		rval = EEXIST;

Can you put the comment inside the if branch?

	if (error) {
		rval = error;
	} else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE) {
		/* found a case-insensitive match in a leaf */
		rval = EEXIST;
	}

I think Josef got the others...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
