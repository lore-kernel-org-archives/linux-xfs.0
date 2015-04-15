Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 576817F50
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 00:08:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F5238F8054
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 22:07:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	eWcJOJVdGWYQS4kK for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 22:07:54 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YiFYF-00035o-Sp
	for xfs@oss.sgi.com; Wed, 15 Apr 2015 15:07:51 +1000
Date: Wed, 15 Apr 2015 15:07:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfs: extent size hints can round up extents past
	MAXEXTLEN
Message-ID: <20150415050751.GY15810@dastard>
References: <1429073512-20035-1-git-send-email-david@fromorbit.com>
	<1429073512-20035-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429073512-20035-10-git-send-email-david@fromorbit.com>
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

Ooops, one commit too many on the command line when. This patch
isn't part of the series....

On Wed, Apr 15, 2015 at 02:51:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This results in BMBT corruption, as seen by this test:
> 
> # mkfs.xfs -f -d size=40051712b,agcount=4 /dev/vdc
> ....
> # mount /dev/vdc /mnt/scratch
> # xfs_io -ft -c "extsize 16m" -c "falloc 0 30g" -c "bmap -vp" /mnt/scratch/foo
> 
> which results in this failure on a debug kernel:
> 
> XFS: Assertion failed: (blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0, file: fs/xfs/libxfs/xfs_bmap_btree.c, line: 211
> ....
> Call Trace:
>  [<ffffffff814cf0ff>] xfs_bmbt_set_allf+0x8f/0x100
>  [<ffffffff814cf18d>] xfs_bmbt_set_all+0x1d/0x20
>  [<ffffffff814f2efe>] xfs_iext_insert+0x9e/0x120
>  [<ffffffff814c7956>] ? xfs_bmap_add_extent_hole_real+0x1c6/0xc70
>  [<ffffffff814c7956>] xfs_bmap_add_extent_hole_real+0x1c6/0xc70
>  [<ffffffff814caaab>] xfs_bmapi_write+0x72b/0xed0
>  [<ffffffff811c72ac>] ? kmem_cache_alloc+0x15c/0x170
>  [<ffffffff814fe070>] xfs_alloc_file_space+0x160/0x400
>  [<ffffffff81ddcc29>] ? down_write+0x29/0x60
>  [<ffffffff815063eb>] xfs_file_fallocate+0x29b/0x310
>  [<ffffffff811d2bc8>] ? __sb_start_write+0x58/0x120
>  [<ffffffff811e3e18>] ? do_vfs_ioctl+0x318/0x570
>  [<ffffffff811cd680>] vfs_fallocate+0x140/0x260
>  [<ffffffff811ce6f8>] SyS_fallocate+0x48/0x80
>  [<ffffffff81ddec09>] system_call_fastpath+0x12/0x17
> 
> The tracepoint that indicates the extent that triggered the assert
> failure is:
> 
> xfs_iext_insert:   idx 0 offset 0 block 16777224 count 2097152 flag 1
> 
> Clearly indicating that the extent length is greater than MAXEXTLEN,
> which is 2097151. A prior trace point shows the allocation was an
> exact size match and that a length greater than MAXEXTLEN was asked
> for:
> 
> xfs_alloc_size_done:  agno 1 agbno 8 minlen 2097152 maxlen 2097152
> 					    ^^^^^^^        ^^^^^^^
> 
> The issue is that the extent size hint alignment is rounding up the
> extent size past MAXEXTLEN, because xfs_bmapi_write() is not taking
> into account extent size hints when calculating the maximum extent
> length to allocate. xfs_bmapi_reserve_delalloc() is already doing
> this, but direct extent allocation is not.
> 
> We don't see this problem with extent size hints through the IO path
> because we can't do single IOs large enough to trigger MAXEXTLEN
> allocation. fallocate(), OTOH, is not limited in it's allocation
> sizes and so needs help here. The fix is simply to copy the logic
> from xfs_bmapi_reserve_delalloc() and apply it apropriately to
> xfs_bmapi_write().
> 
> I also add an ASSERT() to xfs_bmap_extsize_align() so we'll catch
> cases of alignment exceeding MAXEXTLEN on debug kernel machines in
> future.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index aeffeaa..e5aa8a6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3224,12 +3224,21 @@ xfs_bmap_extsize_align(
>  		align_alen += temp;
>  		align_off -= temp;
>  	}
> +
> +	/* Same adjustment for the end of the requested area. */
> +	temp = (align_alen % extsz);
> +	if (temp)
> +		align_alen += extsz - temp;
> +
>  	/*
> -	 * Same adjustment for the end of the requested area.
> +	 * we are in trouble if the caller requested an extent that will align
> +	 * to something larger than the supported on disk extent size.  Assert
> +	 * fail here to catch callers that make this mistake; they should always
> +	 * be setting the maximum allocation length to be (MAXEXTLEN - extsz) so
> +	 * we can round outwards here for alignment.
>  	 */
> -	if ((temp = (align_alen % extsz))) {
> -		align_alen += extsz - temp;
> -	}
> +	ASSERT(align_alen <= MAXEXTLEN);
> +
>  	/*
>  	 * If the previous block overlaps with this proposed allocation
>  	 * then move the start forward without adjusting the length.
> @@ -4287,7 +4296,19 @@ xfs_bmapi_allocate(
>  					 &bma->prev);
>  		}
>  	} else {
> -		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
> +		/* Figure out the extent size, adjust alen */
> +		xfs_extlen_t	maxlen = MAXEXTLEN;
> +		xfs_extlen_t	extsz = xfs_get_extsz_hint(bma->ip);
> +
> +		/*
> +		 * Make sure we don't exceed a single extent length when we
> +		 * align the extent by reducing length we are going to allocate
> +		 * by the maximum amount extent size aligment may require.
> +		 */
> +		if (extsz)
> +			maxlen -= (2 * extsz - 1);
> +
> +		bma->length = XFS_FILBLKS_MIN(bma->length, maxlen);
>  		if (!bma->eof)
>  			bma->length = XFS_FILBLKS_MIN(bma->length,
>  					bma->got.br_startoff - bma->offset);
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
