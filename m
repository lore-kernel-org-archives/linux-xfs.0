Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6WI061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:15 -0500
Date: Mon, 29 Oct 2012 20:23:09 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 13/25] xfs: factor dir2 block read operations
Message-ID: <20121030032309.GP30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-14-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 25, 2012 at 05:34:02PM +1100, Dave Chinner wrote:
> +static void
> +xfs_dir2_block_need_space(
> ...
> +	/*
> +	 * If there are stale entries we'll use one for the leaf.
> +	 */
> +	if (btp->stale) {
> +		if (be16_to_cpu(bf[0].length) >= len) {
> +			/*
> +			 * The biggest entry enough to avoid compaction.
> +			 */
> +			dup = (xfs_dir2_data_unused_t *)
> +			      ((char *)hdr + be16_to_cpu(bf[0].offset));
> +			goto out;
> +		}
> +
> +		/*
> +		 * Will need to compact to make this work.
> +		 * Tag just before the first leaf entry.
> +		 */
> +		*compact = 1;
> +		tagp = (__be16 *)blp - 1;
> +
> +		/* Data object just before the first leaf entry.  */
> +		dup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
> +
> +		/*
> +		 * If it's not free then the data will go where the
> +		 * leaf data starts now, if it works at all.
> +		 */
> +		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> +			if (be16_to_cpu(dup->length) + (be32_to_cpu(btp->stale) - 1) *
> +			    (uint)sizeof(*blp) < len)
> +				dup = NULL;
> +		} else if ((be32_to_cpu(btp->stale) - 1) * (uint)sizeof(*blp) < len)
> +			dup = NULL;
> +		else
> +			dup = (xfs_dir2_data_unused_t *)blp;
> +		goto out;
> +	}
> +
> +	/*
> +	 * no stale entries, so just use free space.
> +	 * Tag just before the first leaf entry.
> +	 */
> +	tagp = (__be16 *)blp - 1;

Shouldn't tagp just be set before this if statement rather than inside of it
and outside of it?  In both cases it's equated to blp-1 and the value of blp
doesn't change to the best of my knowledge, so it's confusing to have two
assignments.

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
