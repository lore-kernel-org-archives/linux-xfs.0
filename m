Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 37A167F55
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 08:35:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E2F68F8037
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 06:35:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2UKDS3DNhwDlFng7 for
	<xfs@oss.sgi.com>; Wed, 04 Jun 2014 06:35:53 -0700 (PDT)
Date: Wed, 4 Jun 2014 09:35:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix rounding in xfs_alloc_fix_len()
Message-ID: <20140604133551.GA55624@bfoster.bfoster>
References: <1401875293-16227-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401875293-16227-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, Jun 04, 2014 at 11:48:13AM +0200, Jan Kara wrote:
> Rounding in xfs_alloc_fix_len() is wrong. As the comment states, the
> result should be a number of a form (k*prod+mod) however due to sign
> mistake the result is different. As a result allocations on raid arrays
> could be misaligned in some cases.
> 
> This also seems to fix occasional assertion failure:
> 	XFS_WANT_CORRUPTED_GOTO(rlen <= flen, error0)
> in xfs_alloc_ag_vextent_size().
> 

Do you happen to have a reproducer for this?

The meaning of args->prod (the structure definition comment calls it the
prod value) is not clear to me. I see that we set it to an extent
size hint if one exists (in xfs_bmap_btalloc()), so I'll go with that.
args->mod then becomes the modulo of the file offset against that
alignment hint.

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_alloc.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index c1cf6a336a72..6a0281b16451 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -257,14 +257,12 @@ xfs_alloc_fix_len(

We get here and take the extent length, mod against the alignment and
compare to the mod of the offset. 

>  	k = rlen % args->prod;
>  	if (k == args->mod)
>  		return;
> -	if (k > args->mod) {
> -		if ((int)(rlen = rlen - k - args->mod) < (int)args->minlen)
> -			return;
> -	} else {
> -		if ((int)(rlen = rlen - args->prod - (args->mod - k)) <
> -		    (int)args->minlen)
> -			return;
> -	}
> +	if (k > args->mod)
> +		rlen = rlen - (k - args->mod);

If the length mod is greater than the offset mod, reduce the length by
the delta of the mods.

> +	else
> +		rlen = rlen - args->prod + (args->mod - k);

Otherwise (length mod is less than offset mod), reduce by a full
alignment size and add back the difference to match the offset mod.

This seems correct to me.

> +	if ((int)rlen < (int)args->minlen)
> +		return;
>  	ASSERT(rlen >= args->minlen);
>  	ASSERT(rlen <= args->maxlen);

The rlen >= minlen assert seems kind of pointless here, but what about
changing both instances of these two asserts to the following:

	ASSERT(rlen >= args->minlen && rlen <= args->maxlen);

... and add a new one after the length adjustment along the lines of:

	ASSERT((rlen % args->prod) == args->mod);

Thoughts? Would this have caught the problem you've found earlier?

Brian

>  	args->len = rlen;
> -- 
> 1.8.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
