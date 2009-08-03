Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73JBUbj106319 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 14:11:30 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] SGI-PV: Read buffer overflow
Date: Mon, 3 Aug 2009 14:11:48 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AB26@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <4A7575EF.8070404@gmail.com>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com

> Check whether index is within bounds before grabbing the element.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
> index 9ff6e57..ef1d275 100644
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -1414,8 +1414,9 @@ xfs_da_path_shift(xfs_da_state_t 
> *state, xfs_da_state_path_t *path,
>  	ASSERT(args != NULL);
>  	ASSERT(path != NULL);
>  	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> -	level = (path->active-1) - 1;	/* skip bottom layer in path */
> -	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
> +	/* skip bottom layer in path */
> +	for (level = (path->active-1) - 1; level >= 0; blk--, level--) {

No need to decrement "blk" above.  You are reassigning it anyway
in the next statement.

> +		blk = &path->blk[level];
>  		ASSERT(blk->bp != NULL);
>  		node = blk->bp->data;
>  		ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);

Note that if level were < 0 upon entry to the loop in its previous
form, then the computed value of blk would never have been used.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
