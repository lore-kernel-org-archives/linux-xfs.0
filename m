Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LJ6rYZ025435 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 14:06:53 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 09/14] repair: track logical to physical block mapping
	moreeffeciently
Date: Wed, 21 Oct 2009 14:06:19 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADEE@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090902175841.284697389@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Currently we track the logical to physical block mapping by a structure which
> contains an array of physicial blocks.  This is extremly efficient and is

Should this be "extremely inefficient?"

> replaced with the normal starblock storage we use in the kernel and on disk
> in this patch.

While you're at fixing the above comment, maybe just re-word this
sentence because I don't really grok it very well...

. . .

> [hch: added a small fix in blkmap_set_ext to not call memmove unless needed]
> 
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A few minor nits mentioned above and below.  But
overall this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfsprogs-dev/repair/bmap.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/bmap.c	2009-08-20 02:32:34.000000000 +0000
> +++ xfsprogs-dev/repair/bmap.c	2009-08-20 02:32:45.000000000 +0000

> @@ -21,106 +21,46 @@
>  #include "bmap.h"
> 

. . .

> +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> +
>  	if (nex < 1)
>  		nex = 1;
> -	if ((blkmap = malloc(BLKMAP_SIZE(nex))) == NULL) {
> -		do_warn(_("malloc failed in blkmap_alloc (%u bytes)\n"),
> -			BLKMAP_SIZE(nex));
> -		return blkmap;
> +
> +	key = whichfork ? ablkmap_key : dblkmap_key;
> +	blkmap = pthread_getspecific(key);
> +	if (!blkmap || blkmap->naexts < nex) {
> +		blkmap = realloc(blkmap, BLKMAP_SIZE(nex));

Does the above really have to be a realloc() call, or can
it simply be a free()/malloc() instead?  Also, could the
existing ts_alloc() function be adjusted to accomodate the
usage here?

> +		if (!blkmap) {
> +			do_warn(_("malloc failed in blkmap_alloc (%u bytes)\n"),
> +				BLKMAP_SIZE(nex));

. . .

> @@ -131,14 +71,7 @@ void
>  blkmap_free(
>  	blkmap_t	*blkmap)
>  {
> -	blkent_t	**entp;
> -	xfs_extnum_t	i;
> -
> -	if (blkmap == NULL)
> -		return;
> -	for (i = 0, entp = blkmap->ents; i < blkmap->nents; i++, entp++)
> -		free(*entp);
> -	free(blkmap);
> +	/* nothing to do! - keep the memory around for the next inode */

Nobody ever frees it though, either.  I guess it gets done at
exit but I like things tidy (could arrange for a destructor
function to be called, at pthread_key_create() time).

>  }
> 
>  /*

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
