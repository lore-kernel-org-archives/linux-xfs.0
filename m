Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6C99uDK023736 for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 04:09:57 -0500
Date: Tue, 12 Jul 2011 05:09:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] xfs: factor out xfs_dir2_leaf_find_stale
Message-ID: <20110712090954.GB8364@infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.293539533@bombadil.infradead.org>
	<1310423573.7019.55.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310423573.7019.55.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 05:32:53PM -0500, Alex Elder wrote:
> > +		continue;
> > +
> > +	/*
> > +	 * Find the first stale entry at or after our index, if any.
> > +	 * Stop if the answer would be worse than lowstale.
> 
>               Stop if the result would require moving more
>               entries than using lowstale.
> 
> (I realize you didn't change this comment, you just moved
> it into this helper function.)

I'll change it.

> Actually it seems like this searching of the stale
> entries and moving things around among them could
> be broken into a few even finer-grained utility
> routines.  It just seems like what this code is
> doing is simpler than what the code complexity
> suggests (though I haven't really looked at this
> stuff much before).

Some of this code could use some refactoring, but it's going to be
more complex than this patch.  Additionally a lot of the logic is
duplicate in the block format code, but that format has the freespace
"header" at the end in struct xfs_dir2_block_tail, which for the fun
of it uses 32-bit count and stale fields instead of the 16-bit values
in struct xfs_dir2_leaf_hdr.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
