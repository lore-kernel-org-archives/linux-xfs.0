Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D1E77F54
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 10:14:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C158FAC004
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 08:14:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BruiHSiRD0nTfCyh for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 08:14:12 -0700 (PDT)
Message-ID: <523871C2.5010704@sandeen.net>
Date: Tue, 17 Sep 2013 10:14:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 10/55] libxfs: sync dir2 kernel differences
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-11-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/4/13 5:05 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/xfs_dir2.c      | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/xfs_dir2_data.c | 20 ++++++++++----------
>  libxfs/xfs_dir2_leaf.c |  4 ++--
>  libxfs/xfs_dir2_node.c | 26 ++++++++++++--------------
>  4 files changed, 69 insertions(+), 26 deletions(-)
> 
> diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
> index 6a4027f..830fe3e 100644
> --- a/libxfs/xfs_dir2.c
> +++ b/libxfs/xfs_dir2.c
> @@ -392,6 +392,51 @@ xfs_dir_replace(
>  }
>  
>  /*
> + * See if this entry can be added to the directory without allocating space.
> + * First checks that the caller couldn't reserve enough space (resblks = 0).
> + */
> +int
> +xfs_dir_canenter(

Retroactive, post-merge question.  :)  This function isn't used in userspace,
AFAICT.  What's the intended libxfs philosophy - keep files as identical to
kernelspace as possible, used code or not, or remove things which aren't used
in userspace?

Thanks,
-Eric

> +	xfs_trans_t	*tp,
> +	xfs_inode_t	*dp,
> +	struct xfs_name	*name,		/* name of entry to add */
> +	uint		resblks)
> +{
> +	xfs_da_args_t	args;
> +	int		rval;
> +	int		v;		/* type-checking value */
> +
> +	if (resblks)
> +		return 0;
> +
> +	ASSERT(S_ISDIR(dp->i_d.di_mode));
> +
> +	memset(&args, 0, sizeof(xfs_da_args_t));
> +	args.name = name->name;
> +	args.namelen = name->len;
> +	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args.dp = dp;
> +	args.whichfork = XFS_DATA_FORK;
> +	args.trans = tp;
> +	args.op_flags = XFS_DA_OP_JUSTCHECK | XFS_DA_OP_ADDNAME |
> +							XFS_DA_OP_OKNOENT;
> +
> +	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
> +		rval = xfs_dir2_sf_addname(&args);
> +	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> +		return rval;
> +	else if (v)
> +		rval = xfs_dir2_block_addname(&args);
> +	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> +		return rval;
> +	else if (v)
> +		rval = xfs_dir2_leaf_addname(&args);
> +	else
> +		rval = xfs_dir2_node_addname(&args);
> +	return rval;
> +}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
