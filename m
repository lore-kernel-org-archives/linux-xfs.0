Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF6AF7CA0
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 03:33:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67ACFAC003
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 01:32:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UWiWFOHuBMQWkhv3 for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 01:32:54 -0700 (PDT)
Date: Tue, 31 May 2016 18:32:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix broken multi-fsb buffer logging
Message-ID: <20160531083252.GR26977@dastard>
References: <1464204667-10199-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464204667-10199-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, May 25, 2016 at 03:31:07PM -0400, Brian Foster wrote:
> Multi-block buffers are logged based on buffer offset in
> xfs_trans_log_buf(). xfs_buf_item_log() ultimately walks each mapping in
> the buffer and marks the associated range to be logged in the
> xfs_buf_log_format bitmap for that mapping. This code is broken,
> however, [....]

[snip description I've not read, and go look at the code changes]

> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 3425799..2e95ad0 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -359,7 +359,7 @@ xfs_buf_item_format(
>  	for (i = 0; i < bip->bli_format_count; i++) {
>  		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
>  					    &bip->bli_formats[i]);
> -		offset += bp->b_maps[i].bm_len;
> +		offset += BBTOB(bp->b_maps[i].bm_len);
>  	}

Ok, that means the offset into the multi-fsb buffer is wrong for the
second and subsequent chunks, resulting in copying the wrong range
into the log vector. Offset should be in bytes, so this is a valid
fix all by itself.


>  
>  	/*
> @@ -915,20 +915,28 @@ xfs_buf_item_log(
>  	for (i = 0; i < bip->bli_format_count; i++) {
>  		if (start > last)
>  			break;
> -		end = start + BBTOB(bp->b_maps[i].bm_len);
> +		end = start + BBTOB(bp->b_maps[i].bm_len) - 1;

Ok, buffer starts at offset 0, last byte in buffer is length - 1.
Yup, there's an off-by-one there - end points to the offset of the
first byte of the next buffer. This will screw up the range trimming
done below. I think this is probably harmless as it doesn't impact
the next iteration of the loop, but still good to get it right.

> +
> +		/* skip to the map that includes the first byte to log */
>  		if (first > end) {
>  			start += BBTOB(bp->b_maps[i].bm_len);
>  			continue;
>  		}
> +
> +		/*
> +		 * Trim the range to this segment and mark it in the bitmap.
> +		 * Note that we must convert buffer offsets to segment relative
> +		 * offsets (e.g., the first byte of each segment is byte 0 of
> +		 * that segment).
> +		 */
>  		if (first < start)
>  			first = start;
>  		if (end > last)
>  			end = last;
> -
> -		xfs_buf_item_log_segment(first, end,
> +		xfs_buf_item_log_segment(first - start, end - start,
>  					 &bip->bli_formats[i].blf_data_map[0]);

Ok so we pass offsets first and end as the range that needs to be
logged in the segment, and start is the byte offset of the first
byte of data in the current buffer segment.

/me looks at xfs_buf_item_log_segment()

It sets bits in the format item based on offsets passed in.
That means if the start is non-zero (i.e. we're in the second
buffer range) we'll set bits in the dirty mask that map to first/end
rather than 0/buffer len.

/me looks at xfs_buf_item_size, follows blf_map_size to it's
initialisation, sees that first/end bits will be beyond blf_map_size
for second+ buffer range and so never seen by xfs_buf_item_size().

Hence subtracting start normalises the range being logged to 
offsets within the buffer range, and so now xfs_buf_item_size (and
hence xfs_buf_item_format) will see them correctly as dirty.

Yes, that change looks correct.

>  
> -		start += bp->b_maps[i].bm_len;
> +		start += BBTOB(bp->b_maps[i].bm_len);

Yup, same as the first hunk in the patch.

So from the code perspective the change looks correct. I've looked
over all the other users of bp->b_maps[i].bm_len and loops over
bli_format_count and I can't see any other obvious problems. I'm
going to leave this under test overnight and see if anything pops
up...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
