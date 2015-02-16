Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABF957F4E
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 07:41:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B97B8F804B
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 05:41:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ejbo7qVGlMoaFAnX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 05:41:28 -0800 (PST)
Date: Mon, 16 Feb 2015 08:41:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: xfs_alloc_fix_minleft can underflow near ENOSPC
Message-ID: <20150216134121.GC9234@laptop.bfoster>
References: <1423782857-11800-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423782857-11800-1-git-send-email-david@fromorbit.com>
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

On Fri, Feb 13, 2015 at 10:14:17AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Test generic/224 is failing with a corruption being detected on one
> of Michael's test boxes.  Debug that Michael added is indicating
> that the minleft trimming is resulting in an underflow:
> 
> .....
>  before fixup:              rlen          1  args->len          0
>  after xfs_alloc_fix_len  : rlen          1  args->len          1
>  before goto out_nominleft: rlen          1  args->len          0
>  before fixup:              rlen          1  args->len          0
>  after xfs_alloc_fix_len  : rlen          1  args->len          1
>  after fixup:               rlen          1  args->len          1
>  before fixup:              rlen          1  args->len          0
>  after xfs_alloc_fix_len  : rlen          1  args->len          1
>  after fixup:               rlen 4294967295  args->len 4294967295
>  XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_alloc.c, line: 1424
> 
> The "goto out_nominleft:" indicates that we are getting close to
> ENOSPC in the AG, and a couple of allocations later we underflow
> and the corruption check fires in xfs_alloc_ag_vextent_size().
> 
> The issue is that the extent length fixups comaprisons are done
> with variables of xfs_extlen_t types. These are unsigned so an
> underflow looks like a really big value and hence is not detected
> as being smaller than the minimum length allowed for the extent.
> Hence the corruption check fires as it is noticing that the returned
> length is longer than the original extent length passed in.
> 
> This can be easily fixed by ensuring we do the underflow test on
> signed values, the same way xfs_alloc_fix_len() prevents underflow.
> So we realise in future that these casts prevent underflows from
> going undetected, add comments to the code indicating this.
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Tested-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 710554c..41e3630 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -260,6 +260,7 @@ xfs_alloc_fix_len(
>  		rlen = rlen - (k - args->mod);
>  	else
>  		rlen = rlen - args->prod + (args->mod - k);
> +	/* casts to (int) catch length underflows */
>  	if ((int)rlen < (int)args->minlen)
>  		return;
>  	ASSERT(rlen >= args->minlen && rlen <= args->maxlen);
> @@ -286,7 +287,8 @@ xfs_alloc_fix_minleft(
>  	if (diff >= 0)
>  		return 1;
>  	args->len += diff;		/* shrink the allocated space */
> -	if (args->len >= args->minlen)
> +	/* casts to (int) catch length underflows */
> +	if ((int)args->len >= (int)args->minlen)
>  		return 1;
>  	args->agbno = NULLAGBLOCK;
>  	return 0;
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
