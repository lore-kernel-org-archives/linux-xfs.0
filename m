Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3536A7F47
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 10:31:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C158DAC002
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 08:31:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eEteO6i7pD3q3HMj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 08:31:12 -0700 (PDT)
Date: Tue, 5 May 2015 11:31:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: extent size hints can round up extents past
	MAXEXTLEN
Message-ID: <20150505153110.GD43235@bfoster.bfoster>
References: <1430780408-12539-1-git-send-email-david@fromorbit.com>
	<1430780408-12539-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430780408-12539-2-git-send-email-david@fromorbit.com>
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

On Tue, May 05, 2015 at 09:00:07AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
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
> We don't see this problem with extent size hints through the IO path
> because we can't do single IOs large enough to trigger MAXEXTLEN
> allocation. fallocate(), OTOH, is not limited in it's allocation
> sizes and so needs help here.
> 
> The issue is that the extent size hint alignment is rounding up the
> extent size past MAXEXTLEN, because xfs_bmapi_write() is not taking
> into account extent size hints when calculating the maximum extent
> length to allocate. xfs_bmapi_reserve_delalloc() is already doing
> this, but direct extent allocation is not.
> 
> Unfortunately, the calculation in xfs_bmapi_reserve_delalloc() is
> wrong, and it works only because delayed allocation extents are not
> limited in size to MAXEXTLEN in the in-core extent tree. hence this
> calculation does not work for direct allocation, and the delalloc
> code needs fixing. This may, in fact be the underlying bug that
> occassionally causes transaction overruns in delayed allocation
> extent conversion, so now we know it's wrong we should fix it, too.
> Many thanks to Brian Foster for finding this problem during review
> of this patch.
> 
> Hence the fix, after much code reading, is to allow
> xfs_bmap_extsize_align() to align partial extents when full
> alignment would extend the alignment past MAXEXTLEN. We can safely
> do this because all callers have higher layer allocation loops that
> already handle short allocations, and so will simply run another
> allocation to cover the remainder of the requested allocation range
> that we ignored during alignment. The advantage of this approach is
> that it also removes the need for callers to do anything other than
> limit their requests to MAXEXTLEN - they don't really need to be
> aware of extent size hints at all.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index aeffeaa..79f7433 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3224,12 +3224,25 @@ xfs_bmap_extsize_align(
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
> +	 * For large extent hint sizes, the aligned extent might be larger than
> +	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
> +	 * the length back under MAXEXTLEN. The outer allocation loops handle
> +	 * short allocation just fine, so it is safe to do this. We only want to
> +	 * do it when we are forced to, though, because it means more allocation
> +	 * operations are required.
>  	 */
> -	if ((temp = (align_alen % extsz))) {
> -		align_alen += extsz - temp;
> +	if (align_alen > MAXEXTLEN) {
> +		align_alen -= extsz;
> +		ASSERT(align_alen <= MAXEXTLEN);
>  	}
> +

# mkfs.xfs -f -bsize=1k /dev/test/scratch 
...
# mount /dev/test/scratch /mnt/
# xfs_io -f -c "extsize 1g" /mnt/file
# xfs_io -c "falloc 1023m 2g" /mnt/file
fallocate: No space left on device
#
...

XFS: Assertion failed: align_alen <= MAXEXTLEN, file: fs/xfs/libxfs/xfs_bmap.c, line: 3244

Perhaps we need a while (align_alen > MAXEXTLEN) here..?

Brian

>  	/*
>  	 * If the previous block overlaps with this proposed allocation
>  	 * then move the start forward without adjusting the length.
> @@ -3318,7 +3331,9 @@ xfs_bmap_extsize_align(
>  			return -EINVAL;
>  	} else {
>  		ASSERT(orig_off >= align_off);
> -		ASSERT(orig_end <= align_off + align_alen);
> +		/* see MAXEXTLEN handling above */
> +		ASSERT(orig_end <= align_off + align_alen ||
> +		       align_alen + extsz > MAXEXTLEN);
>  	}
>  
>  #ifdef DEBUG
> @@ -4099,13 +4114,6 @@ xfs_bmapi_reserve_delalloc(
>  	/* Figure out the extent size, adjust alen */
>  	extsz = xfs_get_extsz_hint(ip);
>  	if (extsz) {
> -		/*
> -		 * Make sure we don't exceed a single extent length when we
> -		 * align the extent by reducing length we are going to
> -		 * allocate by the maximum amount extent size aligment may
> -		 * require.
> -		 */
> -		alen = XFS_FILBLKS_MIN(len, MAXEXTLEN - (2 * extsz - 1));
>  		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
>  					       1, 0, &aoff, &alen);
>  		ASSERT(!error);
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
