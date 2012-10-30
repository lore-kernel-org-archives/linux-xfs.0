Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UMENDb077037 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 17:14:23 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PNmm8sTLmdx2DuzG for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 15:16:12 -0700 (PDT)
Date: Wed, 31 Oct 2012 09:16:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/25] xfs: factor dir2 block read operations
Message-ID: <20121030221611.GC29378@dastard>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-14-git-send-email-david@fromorbit.com>
	<20121030032309.GP30227@caliban.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030032309.GP30227@caliban.engr.sgi.com>
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
To: Phil White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 29, 2012 at 08:23:09PM -0700, Phil White wrote:
> On Thu, Oct 25, 2012 at 05:34:02PM +1100, Dave Chinner wrote:
> > +static void
> > +xfs_dir2_block_need_space(
> > ...
> > +	/*
> > +	 * If there are stale entries we'll use one for the leaf.
> > +	 */
> > +	if (btp->stale) {
> > +		if (be16_to_cpu(bf[0].length) >= len) {
> > +			/*
> > +			 * The biggest entry enough to avoid compaction.
> > +			 */
> > +			dup = (xfs_dir2_data_unused_t *)
> > +			      ((char *)hdr + be16_to_cpu(bf[0].offset));
> > +			goto out;
> > +		}
> > +
> > +		/*
> > +		 * Will need to compact to make this work.
> > +		 * Tag just before the first leaf entry.
> > +		 */
> > +		*compact = 1;
> > +		tagp = (__be16 *)blp - 1;
> > +
> > +		/* Data object just before the first leaf entry.  */
> > +		dup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
> > +
> > +		/*
> > +		 * If it's not free then the data will go where the
> > +		 * leaf data starts now, if it works at all.
> > +		 */
> > +		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> > +			if (be16_to_cpu(dup->length) + (be32_to_cpu(btp->stale) - 1) *
> > +			    (uint)sizeof(*blp) < len)
> > +				dup = NULL;
> > +		} else if ((be32_to_cpu(btp->stale) - 1) * (uint)sizeof(*blp) < len)
> > +			dup = NULL;
> > +		else
> > +			dup = (xfs_dir2_data_unused_t *)blp;
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * no stale entries, so just use free space.
> > +	 * Tag just before the first leaf entry.
> > +	 */
> > +	tagp = (__be16 *)blp - 1;
> 
> Shouldn't tagp just be set before this if statement rather than inside of it
> and outside of it?

No, because there is a case where it isn't set.

In general, when factoring code it's not a good idea to change logic
because that's where bugs most commonly creep in. At some point in
the future this could probably do with a more robust cleanup (rather
than just factoring), but right now that's out-of-scope for what I'm
doing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
