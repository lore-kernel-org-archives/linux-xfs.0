Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 489727F53
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:08:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 213AC8F8064
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 06:08:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Bmpic1waPCjbRb9E for
	<xfs@oss.sgi.com>; Fri, 27 Sep 2013 06:08:31 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8RD8U6Z021757
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 09:08:30 -0400
Received: from orion.maiolino.org (ovpn-113-161.phx2.redhat.com [10.3.113.161])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r8RD8RkN006935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 09:08:30 -0400
Date: Fri, 27 Sep 2013 10:08:26 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: fix memory leak in xfs_dir2_node_removename
Message-ID: <20130927130826.GA10694@orion.maiolino.org>
References: <20130927130140.640252809@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130927130140.640252809@sgi.com>
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
To: xfs@oss.sgi.com

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Fri, Sep 27, 2013 at 08:01:31AM -0500, Mark Tinguely wrote:
> Free the memory pointed to by state before returning on error from 
> xfs_dir2_node_removename.c
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> Found by Coverity (134681) in userspace, same patch applies there
> also.
> 
>  fs/xfs/xfs_dir2_node.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Index: b/fs/xfs/xfs_dir2_node.c
> ===================================================================
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -2131,10 +2131,9 @@ xfs_dir2_node_removename(
>  	/*
>  	 * Didn't find it, upper layer screwed up.
>  	 */
> -	if (rval != EEXIST) {
> -		xfs_da_state_free(state);
> -		return rval;
> -	}
> +	if (rval != EEXIST)
> +		goto done;
> +
>  	blk = &state->path.blk[state->path.active - 1];
>  	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
>  	ASSERT(state->extravalid);
> @@ -2145,7 +2144,7 @@ xfs_dir2_node_removename(
>  	error = xfs_dir2_leafn_remove(args, blk->bp, blk->index,
>  		&state->extrablk, &rval);
>  	if (error)
> -		return error;
> +		goto done;
>  	/*
>  	 * Fix the hash values up the btree.
>  	 */
> @@ -2160,6 +2159,7 @@ xfs_dir2_node_removename(
>  	 */
>  	if (!error)
>  		error = xfs_dir2_node_to_leaf(state);
> +done:
>  	xfs_da_state_free(state);
>  	return error;
>  }
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
