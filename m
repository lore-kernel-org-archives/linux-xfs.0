Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89KNljS058381 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 15:23:47 -0500
Subject: Re: [PATCH 13/25] xfs: introduce xfs_bmap_last_extent
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060643.154462765@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060643.154462765@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 15:23:46 -0500
Message-ID: <1315599826.1999.58.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-simplify-xfs_bmap_isaeof)
> Add a common helper for finding the last extent in a file.
> 
> Largely based on a patch from Dave Chinner.


The new version of xfs_bmap_isaeof() no longer asserts
that the data fork is the one being operated on.  Why?

I have a couple of suggested comment clarifications,
and a suggested logic simplification below.

Reviewed-by: Alex Elder <aelder@sgi.com>

(Still reviewing the rest, but thought I'd fire off
a batch of the ones that I'm done with.)


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap.c

. . .

> +
> +/*
> + * Check the last inode extent to determine whether this allocation will result
> + * in blocks being allocated at the end of the file. When we allocate new data
> + * blocks at the end of the file which do not start at the previous data block,
> + * we will try to align the new blocks at stripe unit boundaries.

It is not obvious what value will be returned when the
fork is empty, so mention that case in the comment header:
 
    Returns 0 in *aeof if the file (fork) is empty.

(Maybe you could explain why this is true at a more
abstract level though.)

> + */
> +STATIC int
> +xfs_bmap_isaeof(
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		off,
> +	int			whichfork,
> +	char			*aeof)
> +{
> +	struct xfs_bmbt_irec	rec;
> +	int			is_empty;
> +	int			error;
> +
> +	*aeof = 0;
> +	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
> +	if (error || is_empty)
> +		return error;
> +
> +	/*
> +	 * Check we are allocating in the last extent (for delayed allocations)
> +	 * or past the last extent for non-delayed allocations.
> +	 */
> +	*aeof = (off >= rec.br_startoff &&
> +		 off < rec.br_startoff + rec.br_blockcount &&
> +		 isnullstartblock(rec.br_startblock)) ||
> +		off >= rec.br_startoff + rec.br_blockcount;

This logic could be shortened:

		*aeof = off >= rec.br_startoff + rec.br_blockcount ||
			(off >= rec.br_startoff &&
				 isnullstartblock(rec.br_startblock);

> +	return 0;
> +}
> +
> +/*
> + * Check if the endoff is outside the last extent. If so the caller will grow
> + * the allocation to a stripe unit boundary.

    All offsets are considered outside the end of file for an
    empty file (fork), so 1 is returned in *eof in that case.

> + */
> +int
> +xfs_bmap_eof(
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		endoff,
> +	int			whichfork,
> +	int			*eof)
> +{
> +	struct xfs_bmbt_irec	rec;
> +	int			error;
> +
> +	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, eof);
> +	if (error || *eof)
> +		return error;
> +
> +	*eof = endoff >= rec.br_startoff + rec.br_blockcount;
> +	return 0;
> +}
> +
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
