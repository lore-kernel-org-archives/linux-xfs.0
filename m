Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIN18iW258007 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 17:01:08 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zrtssgLkYwVGoLqG for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 15:01:07 -0800 (PST)
Date: Mon, 19 Dec 2011 10:01:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/12] xfs: compound buffers for directory blocks
Message-ID: <20111218230103.GI23662@dastard>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
	<20111214183314.GA18724@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111214183314.GA18724@infradead.org>
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

On Wed, Dec 14, 2011 at 01:33:14PM -0500, Christoph Hellwig wrote:
> I've been really busy the last days and only managed to look over this
> a bit while waiting for compiles and benchmarks.
> 
> The only really major comment I have is that I start to really dislike
> the way struct xfs_bmbt_irec is used in the compound buffers.  The
> XFS_EXT_DADDR flag basically gives the data types in there a totally
> different meaning and is really confusing for anyone reading the code:
> either we're using a "normal" one passes in from the directory code,
> or an artificial one used internally, which uses different units.
> 
> I suspect we'd really be much better off introducing a new, smaller type
> here, especially as it's only seen inside the buffer code:
> 
> struct xfs_buf_map {
> 	sector_t	bm_bno;
> 	size_t		bm_len;
> };
> 
> any use it consistently, that is also use it to replace
> b_file_offset/b_buffer_length and b_bn.    This will also make my number
> two suggestion a lot cleaner, that is make sure the new abstraction can
> be implemented for reading/writing log buffers that wrap around, and
> allow to kill off xfs_buf_associate_memory entirely.

Yeah, I was a bit unsure of the best way to do this. I started with
the bmbt_irec code because it already existed and was easy to pass
in from the directory code. It wasn't until I realised the sector
addressing issue later on that the XFS_EXT_DADDR came about. That
was a simple way of making it work, rather than rewriting the
patches again...

Ok, I'll go back and rewrite them to use a xfs_buf_map/vec and try
to address all your other points as well. Stay tuned.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
