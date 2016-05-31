Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EF4C7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 13:29:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E63A3304062
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 11:29:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FrBe9itbtTxDHCbV for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 11:29:20 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id CD8FF2B18
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 13:29:19 -0500 (CDT)
Subject: Re: [PATCH] xfs: fix broken multi-fsb buffer logging
References: <1464204667-10199-1-git-send-email-bfoster@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ce9651e1-b734-9845-8c62-b16a7ff9099b@sandeen.net>
Date: Tue, 31 May 2016 13:29:19 -0500
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

On 5/25/16 2:31 PM, Brian Foster wrote:
> Multi-block buffers are logged based on buffer offset in
> xfs_trans_log_buf(). xfs_buf_item_log() ultimately walks each mapping in
> the buffer and marks the associated range to be logged in the
> xfs_buf_log_format bitmap for that mapping. This code is broken,
> however, in that it marks the actual buffer offsets of the associated
> range in each bitmap rather than shifting to the byte range for that
> particular mapping.
> 
> For example, on a 4k fsb fs, buffer offset 4096 refers to the first byte
> of the second mapping in the buffer. This means byte 0 of the second log
> format bitmap should be tagged as dirty. Instead, the current code marks
> byte offset 4096 of the second log format bitmap, which is invalid and
> potentially out of range of the mapping.
> 
> As a result of this, the log item format code invoked at transaction
> commit time is not be able to correctly identify what parts of the
> buffer to copy into log vectors. This can lead to NULL log vector
> pointer dereferences in CIL push context if the item format code was not
> able to locate any dirty ranges at all. This crash has been reproduced
> on a 4k FSB filesystem using 16k directory blocks where an unlink
> operation happened not to log anything in the first block of the
> mapping. The logged offsets were all over 4k, marked as such in the
> subsequent log format mappings, and thus left the transaction with an
> xfs_log_item that is marked DIRTY but without any logged regions.
> 
> Further, even when the logged regions are marked correctly in the buffer
> log format bitmaps, the format code doesn't copy the correct ranges of
> the buffer into the log. This means that any logged region beyond the
> first block of a multi-block buffer is subject to corruption after a
> crash and log recovery sequence. This is due to a failure to convert the
> mapping bm_len field from basic blocks to bytes in the buffer offset
> tracking code in xfs_buf_item_format().
> 
> Update xfs_buf_item_log() to convert buffer offsets to segment relative
> offsets when logging multi-block buffers. This ensures that the modified
> regions of a buffer are logged correctly and avoids the aforementioned
> crash. Also update xfs_buf_item_format() to correctly track the source
> offset into the buffer for the log vector formatting code. This ensures
> that the correct data is copied into the log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Note that this has only been tested so far in a particular filesystem
> environment that reproduces the crash/corruption discussed in the commit
> log description. Generic testing still required, posting just to get a
> jump on review...
> 
> Brian
> 
>  fs/xfs/xfs_buf_item.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
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

Yep this and the other instance in the other hunk look obviously
correct.

>  	}
>  
>  	/*
> @@ -915,20 +915,28 @@ xfs_buf_item_log(
>  	for (i = 0; i < bip->bli_format_count; i++) {
>  		if (start > last)
>  			break;
> -		end = start + BBTOB(bp->b_maps[i].bm_len);
> +		end = start + BBTOB(bp->b_maps[i].bm_len) - 1;
> +

So let's say start is 0, and len is 8, just making up nice numbers.
That means a range of 0 through 7, with the next one starting at 8.
7 is the last block, so if "first" is beyond that, we need to skip.
Makes sense.

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

I guess this is the trickiest part.

in the called function, we do:

        /*
         * Get a pointer to the first word in the bitmap
         * to set a bit in.
         */
        word_num = first_bit >> BIT_TO_WORD_SHIFT;
        wordp = &map[word_num];

where first_bit is derived from the passed-in "first" argument
(in bytes).  So we're marking bits in map[]; this skips us out into
the word_num index in map[].  But what's map?

The map[] we passed in is &bip->bli_formats[i].blf_data_map[0], where
'i' is the i'th segment.  So yes, this needs to be segment-relative
bytes, whereas start (and therefore end) are offsets in the whole
buffer.  So yes, this makes sense to me as well.


>  
> -		start += bp->b_maps[i].bm_len;
> +		start += BBTOB(bp->b_maps[i].bm_len);

Again obviously correct.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  	}
>  }
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
