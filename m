Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC2D27F52
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 14:23:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 59742AC004
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 12:23:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	j9bHxjV0Hr5nERVo for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 12:23:33 -0700 (PDT)
Date: Wed, 20 Mar 2013 06:23:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix assertion failure in xfs_vm_write_failed()
Message-ID: <20130319192322.GB6369@dastard>
References: <51469C90.1000001@oracle.com> <20130318233026.GS6369@dastard>
	<514800DB.5070306@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <514800DB.5070306@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Mar 19, 2013 at 02:08:27PM +0800, Jeff Liu wrote:
> On 03/19/2013 07:30 AM, Dave Chinner wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> In xfs_vm_write_failed(), we evaluate the block_offset of pos with PAGE_MASK
> which is 0xfffff000 as an unsigned long,

That's the 32 bit value. if it's a 64 bit value, it's
0xfffffffffffff000.

> that is fine on 64-bit platforms no
> matter the request pos is 32-bit or 64-bit.  However, on 32-bit platforms,
> the high 32-bit in it will be masked off with (pos & PAGE_MASK) for 64-bit pos
> request.  As a result, the evaluated block_offset is incorrect which will cause
> the ASSERT() failed: ASSERT(block_offset + from == pos);

So I'd just rearrange this slightly:

> In xfs_vm_write_failed(), we evaluate the block_offset of pos with PAGE_MASK
> which is an unsigned long. That is fine on 64-bit platforms
> regardless of whether the request pos is 32-bit or 64-bit.
> However, on 32-bit platforms, the value is 0xfffff000 and so
> the high 32 bits in it will be masked off with (pos & PAGE_MASK)
> for a 64-bit pos As a result, the evaluated block_offset is
> incorrect which will cause this failure ASSERT(block_offset + from
> == pos); and potentially pass the wrong block to
> xfs_vm_kill_delalloc_range().

...
> This patch fix the block_offset evaluation to clear the lower 12 bits as:
> block_offset = pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT
> Hence, the ASSERTION should be correct because the from offset in a page is
> evaluated to have the lower 12 bits only.

Saying we are clearing the lower 12 bits is not technically correct,
as there are platforms with different page sizes. What we are
actually calculating is the offset at the start of the page....

> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 5f707e5..f26a341 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1494,13 +1494,25 @@ xfs_vm_write_failed(
>  	loff_t			pos,
>  	unsigned		len)
>  {
> -	loff_t			block_offset = pos & PAGE_MASK;
> +	loff_t			block_offset;
>  	loff_t			block_start;
>  	loff_t			block_end;
>  	loff_t			from = pos & (PAGE_CACHE_SIZE - 1);
>  	loff_t			to = from + len;
>  	struct buffer_head	*bh, *head;
>  
> +	/*
> +	 * The request pos offset might be 32 or 64 bit, this is all fine
> +	 * on 64-bit platform.  However, for 64-bit pos request on 32-bit
> +	 * platform, the high 32-bit will be masked off if we evaluate the
> +	 * block_offset via (pos & PAGE_MASK) because the PAGE_MASK is
> +	 * 0xfffff000 as an unsigned long, hence the result is incorrect
> +	 * which could cause the following ASSERT failed in most cases.
> +	 * In order to avoid this, we can evaluate the block_offset with
> +	 * the lower 12-bit masked out and the ASSERT should be correct.

Same here:

	* In order to avoid this, we can evaluate the block_offset
	* of the start of the page by using shifts rather than masks
	* the mismatch problem.
> +	 */
> +	block_offset = (pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
> +
>  	ASSERT(block_offset + from == pos);
>  
>  	head = page_buffers(page);

As for the code, it looks fine. Hence with the comments/commit
fixups, you can add:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
