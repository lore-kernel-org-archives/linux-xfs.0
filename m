Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48920 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbeJ0Dky (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Oct 2018 23:40:54 -0400
Subject: Re: [PATCH] libxfs: check all defer ops types
References: <20181026161905.GH28243@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0dc53e1c-2ad6-b04f-2747-451b6760e1d5@sandeen.net>
Date: Fri, 26 Oct 2018 14:02:41 -0500
MIME-Version: 1.0
In-Reply-To: <20181026161905.GH28243@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 10/26/18 11:19 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we have all the defer ops types loaded before proceeding.

So, the only reason we have this problem is that userspace doesn't
exactly share the code which handles all the defer ops.

I think this really needs to be a BUILD_BUG_ON if anything, by the
time we get to runtime it's really too late, and a weird thing to
run at every invocation.

The only thing I can think of is to make an array containing each
of the xfs_defer_op_types, and iterate over it in some sort of
xfs_defer_ops_init(), then we can compare the size of that array to
XFS_DEFER_OPS_TYPE_MAX with a BUILD_BUG_ON.  Worth it?

-Eric


> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/init.c      |    5 +++++
>  libxfs/xfs_defer.c |   12 ++++++++++++
>  libxfs/xfs_defer.h |    1 +
>  3 files changed, 18 insertions(+)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 750b8f20..d1fdc3a8 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -253,6 +253,11 @@ libxfs_init(libxfs_init_t *a)
>  	xfs_rmap_update_init_defer_op();
>  	xfs_refcount_update_init_defer_op();
>  	xfs_bmap_update_init_defer_op();
> +	if (!xfs_defer_check_all_present()) {
> +		fprintf(stderr, _("%s: defer ops not all there\n"),
> +			progname);
> +		goto done;
> +	}
>  
>  	radix_tree_init();
>  
> diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
> index 5a6da0f3..cd3a8ef3 100644
> --- a/libxfs/xfs_defer.c
> +++ b/libxfs/xfs_defer.c
> @@ -545,3 +545,15 @@ xfs_defer_move(
>  
>  	xfs_defer_reset(stp);
>  }
> +
> +/* Make sure we filled out all the defer_ops types. */
> +bool
> +xfs_defer_check_all_present(void)
> +{
> +	int		x;
> +
> +	for(x = 0; x < XFS_DEFER_OPS_TYPE_MAX; x++)
> +		if (defer_op_types[x] == NULL)
> +			return false;
> +	return true;
> +}
> diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
> index 2584a5b9..bc7ae7ff 100644
> --- a/libxfs/xfs_defer.h
> +++ b/libxfs/xfs_defer.h
> @@ -57,5 +57,6 @@ struct xfs_defer_op_type {
>  };
>  
>  void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
> +bool xfs_defer_check_all_present(void);
>  
>  #endif /* __XFS_DEFER_H__ */
> 
