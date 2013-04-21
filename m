Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A3DC329E03
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 16:55:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67F1D8F8059
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 14:55:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EZrvuR9EWMZ4LAgj for <xfs@oss.sgi.com>;
	Sun, 21 Apr 2013 14:55:07 -0700 (PDT)
Message-ID: <5174603A.8030208@sandeen.net>
Date: Sun, 21 Apr 2013 16:55:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: shutdown filesystem if xfs_perag_get fails
References: <20130419204102.736961610@sgi.com>
	<20130421174107.007313126@sgi.com>
In-Reply-To: <20130421174107.007313126@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 4/21/13 12:41 PM, Mark Tinguely wrote:

> This problem happened locally with a bad inode number from xfs
> recovery. xfs_perag_get() can return NULL if given a bad agno.
> Most callers of xfs_perag_get() do not check for a NULL before
> using the pointer. This patch forces a shutdown of the filesystem
> for those callers that do not check the return value rather than
> crashing on a dereferenced NULL pointer.

Hi Mark -

I'm curious, what was the callchain when this happened?  Was it
during recovery?  If so, would aborting recovery be more prudent?

I might be missing something, but I'm not sure how shutting
down avoids a subsequent null ptr deref & crash.

i.e. if a caller does something like:

        pag = xfs_perag_get(mp, agno);
        spin_lock(&pag->pagb_lock);

shutting down in xfs_perag_get doesn't save us from a
null pag pointer, would it?
 
Thanks,
-Eric

> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_icache.c |    2 +-
>  fs/xfs/xfs_mount.c  |    4 ++--
>  fs/xfs/xfs_mount.h  |   17 ++++++++++++++++-
>  3 files changed, 19 insertions(+), 4 deletions(-)
> 
> Index: b/fs/xfs/xfs_icache.c
> ===================================================================
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -656,7 +656,7 @@ xfs_inode_ag_iterator(
>  	xfs_agnumber_t		ag;
>  
>  	ag = 0;
> -	while ((pag = xfs_perag_get(mp, ag))) {
> +	while ((pag = __xfs_perag_get(mp, ag))) {
>  		ag = pag->pag_agno + 1;
>  		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, -1);
>  		xfs_perag_put(pag);
> Index: b/fs/xfs/xfs_mount.c
> ===================================================================
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -193,7 +193,7 @@ xfs_uuid_unmount(
>   * have to protect against changes is the tree structure itself.
>   */
>  struct xfs_perag *
> -xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
> +__xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
>  {
>  	struct xfs_perag	*pag;
>  	int			ref = 0;
> @@ -442,7 +442,7 @@ xfs_initialize_perag(
>  	 * AGs we don't find ready for initialisation.
>  	 */
>  	for (index = 0; index < agcount; index++) {
> -		pag = xfs_perag_get(mp, index);
> +		pag = __xfs_perag_get(mp, index);
>  		if (pag) {
>  			xfs_perag_put(pag);
>  			continue;
> Index: b/fs/xfs/xfs_mount.h
> ===================================================================
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -336,12 +336,27 @@ xfs_daddr_to_agbno(struct xfs_mount *mp,
>  /*
>   * perag get/put wrappers for ref counting
>   */
> -struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
> +struct xfs_perag *__xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
>  struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
>  					int tag);
>  void	xfs_perag_put(struct xfs_perag *pag);
>  
>  /*
> + * Ensure the per AG entry was found. Shutting down the filesystem
> + * is better than crashing the OS.
> + */
> +static inline struct xfs_perag *
> +xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
> +{
> +	struct xfs_perag	*pag;
> +
> +	pag = __xfs_perag_get(mp, agno);
> +	if (!pag)
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +	return pag;
> +}
> +
> +/*
>   * Per-cpu superblock locking functions
>   */
>  #ifdef HAVE_PERCPU_SB
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
