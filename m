Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD7267F55
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2015 17:40:32 -0600 (CST)
Message-ID: <54DE8B6D.8010401@sgi.com>
Date: Fri, 13 Feb 2015 17:40:29 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: xfs_alloc_fix_minleft can underflow near ENOSPC
References: <1423782857-11800-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1423782857-11800-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/12/15 17:14, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Test generic/224 is failing with a corruption being detected on one
> of Michael's test boxes.  Debug that Michael added is indicating
> that the minleft trimming is resulting in an underflow:
>
> .....
>   before fixup:              rlen          1  args->len          0
>   after xfs_alloc_fix_len  : rlen          1  args->len          1
>   before goto out_nominleft: rlen          1  args->len          0
>   before fixup:              rlen          1  args->len          0
>   after xfs_alloc_fix_len  : rlen          1  args->len          1
>   after fixup:               rlen          1  args->len          1
>   before fixup:              rlen          1  args->len          0
>   after xfs_alloc_fix_len  : rlen          1  args->len          1
>   after fixup:               rlen 4294967295  args->len 4294967295
>   XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_alloc.c, line: 1424
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
> Reported-by: Michael L. Semon<mlsemon35@gmail.com>
> Tested-by: Michael L. Semon<mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_alloc.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)


int diff = be32_to_cpu(agf->agf_freeblks)
              - args->len - args->minleft;


> @@ -286,7 +287,8 @@ xfs_alloc_fix_minleft(
>   	if (diff >= 0)
>   		return 1;

If the diff math was done correctly, wouldn't it get caught here?

>   	args->len += diff;		/* shrink the allocated space */
> -	if (args->len >= args->minlen)
> +	/* casts to (int) catch length underflows */
> +	if ((int)args->len >= (int)args->minlen)
>   		return 1;
>   	args->agbno = NULLAGBLOCK;
>   	return 0;

We can and should fix the wrap in xfs_alloc_fix_minleft() but this also 
points to the fact that xfs_alloc_fix_freelist() is incorrectly choosing 
AGs that will later fail the allocation alignment, minlen, and minleft 
requirements.

You can connect the dots to see how this can lead to a deadlock with 
extent frees. We have seen them. I hacked the XFS code to lead to this 
situation.

Also bad is xfs_alloc_vextent() will temporally ignore the minleft for 
the xfs_alloc_fix_freelist() but makes the ag allocator enforce the 
minleft. I got this condition to ASSERT in xfs_alloc_ag_vextent_size(), 
but I never got a deadlock. It would require just the right sequence 
from xfs_alloc_vextent() and xfs_bmap_btalloc().

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
