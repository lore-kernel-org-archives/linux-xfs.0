Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04KqvaI167801 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 14:52:58 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gSvdO9MmmubxAfAv for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 12:52:56 -0800 (PST)
Date: Wed, 4 Jan 2012 15:52:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V4
Message-ID: <20120104205255.GA1012@infradead.org>
References: <4EFB1B23.7050008@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EFB1B23.7050008@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hi Jeff,

thanks a lot for the patch, it looks good to except for some more
nitpicks around the unwritten extent probing.

The other issue is the patch description format - the version changelog
should go below the  --- line.

> +	do {
> +		unsigned int	i;
> +		unsigned	nr_pages;
> +		int		want = min_t(pgoff_t, end - index,
> +					     (pgoff_t)PAGEVEC_SIZE - 1) + 1;
> +		nr_pages = pagevec_lookup_tag(&pvec, inode->i_mapping,
> +					      &index, tag, want);
> +		if (nr_pages == 0) {
> +			/*
> +			 * Try to lookup pages in writeback mode from the
> +			 * beginning if no more dirty page can be probed.
> +			 */
> +probe_done:
> +			if (tag == PAGECACHE_TAG_DIRTY) {
> +				tag = PAGECACHE_TAG_WRITEBACK;
> +				goto again;
> +			}
> +			break;

The code flow here looks very confusing.  Why not pass the tag as an
argument to the function, then calling it twice and use the minimum?
(that probably also wants a helper instead of duplication)


> +				 * dirty data in the page cache it can be
> +				 * identified by having BH_Unwritten set in
> +				 * each buffer. Also, the buffer head state
> +				 * might be in BH_Uptodate if the buffer
> +				 * writeback procedure was fired, we need to
> +				 * examine it too.
> +				 */
> +				if (buffer_unwritten(bh) ||
> +				    buffer_uptodate(bh)) {
> +					found = true;
> +					if (get_offset)
> +						*offset = XFS_FSB_TO_B(
> +								mp, last);

Currently seek hole doesn't set get_offset we skip the whole extent.
This seems a bit inconsistent - shouldn't we also return that offset
for the hole case? if the dirty data only starts past the start block
of the map the first blocks of it still are a hole.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
