Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbfGEOtH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 10:49:07 -0400
Date: Fri, 5 Jul 2019 10:49:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove more ondisk directory corruption asserts
Message-ID: <20190705144904.GC37448@bfoster>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158199994.495944.4584531696054696463.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158199994.495944.4584531696054696463.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:46:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Continue our game of replacing ASSERTs for corrupt ondisk metadata with
> EFSCORRUPTED returns.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c  |   19 ++++++++++++-------
>  fs/xfs/libxfs/xfs_dir2_node.c |    3 ++-
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 16731d2d684b..f7f3fb458019 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -743,7 +743,8 @@ xfs_dir2_leafn_lookup_for_entry(
>  	ents = dp->d_ops->leaf_ents_p(leaf);
>  
>  	xfs_dir3_leaf_check(dp, bp);
> -	ASSERT(leafhdr.count > 0);
> +	if (leafhdr.count <= 0)
> +		return -EFSCORRUPTED;

This error return bubbles up to xfs_dir2_leafn_lookup_int() and
xfs_da3_node_lookup_int(). The latter has a direct return value as well
as a *result return parameter, which unconditionally carries the return
value from xfs_dir2_leafn_lookup_int(). xfs_da3_node_lookup_int() has
multiple callers, but a quick look at one (xfs_attr_node_addname())
suggests we might not handle corruption errors properly via the *result
parameter. Perhaps we also need to fix up xfs_da3_node_lookup_int() to
return particular errors directly?

Brian

>  
>  	/*
>  	 * Look up the hash value in the leaf entries.
> 
