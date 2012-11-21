Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAL9qDcE028774 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 03:52:14 -0600
Date: Wed, 21 Nov 2012 04:54:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix the buffer log format for contiguous buffers
Message-ID: <20121121095422.GB23339@infradead.org>
References: <20121120224120.224166649@sgi.com>
	<20121120224146.479983109@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120224146.479983109@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Do we have proper test coverage for the xfs_buf_item_format_segment
changes?  Given that they change what gets written into the log I'd
prefer them separate from a big cleanup patch, and including test
coverage verifying everything works fine when hitting these corner
cases.

>  		chunk_num = byte >> XFS_BLF_SHIFT;
>  		word_num = chunk_num >> BIT_TO_WORD_SHIFT;
>  		bit_num = chunk_num & (NBWORD - 1);
> -		wordp = &(bip->bli_format.blf_data_map[word_num]);
> +		wordp = &(bip->bli_formats[0].blf_data_map[word_num]);

This change doesn't seem to be mentioned in the changelog?

> @@ -644,8 +652,14 @@ xfs_buf_item_unlock(
>  	 * If the buf item isn't tracking any data, free it, otherwise drop the
>  	 * reference we hold to it.
>  	 */
> -	if (xfs_bitmap_empty(bip->bli_format.blf_data_map,
> -			     bip->bli_format.blf_map_size))
> +	empty = 1;
> +	for (i = 0; i < bip->bli_format_count; i++)
> +		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
> +			     bip->bli_formats[i].blf_map_size)) {
> +			empty = 0;
> +			break;
> +		}
> +	if (empty)
>  		xfs_buf_item_relse(bp);

This looks like a bug fix, not just a cleanup.  Again I'd prefer this to
be a patch on its own, with a good description.

Also as in the last patch should we rename bli_format to __bli_format
to catch accidental references to it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
