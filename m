Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DFB47F3F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 07:37:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3542FAC008
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:37:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id yGbCiyZcGLOM9nww (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 05:37:56 -0800 (PST)
Date: Mon, 25 Nov 2013 05:37:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: let iop_format write directly into the linear
	buffer
Message-ID: <20131125133755.GB21992@infradead.org>
References: <20131123151151.716201348@bombadil.infradead.org>
	<20131123151533.726941044@bombadil.infradead.org>
	<20131125091527.GD8803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131125091527.GD8803@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 25, 2013 at 08:15:27PM +1100, Dave Chinner wrote:
> 	- xfs_buf_item_straddle() factoring

This could probably be split out.

> 	- removal of the special cases for no endian swapping around
> 	  xfs_inode_item_format_extents()

This can only be done after we have the new iop_format, or rather must
be because the old way doesn't work really well.  I'll have to see if
it can be a separate one, but it would have to be after the actual
iop_format change.

> 	- a separate patch to introduce xlog_first/next/last_iovec(),
> 	  as I had to find those first to understand how the new
> 	  code worked

What's the point of a separate patch if we don't make use of it yet?

> 	- a new xlog_copy_iovec() function instead of open coding
> 	  the same 3 lines of code in 14 different places:
> 
> static inline void
> xlog_copy_iovec(
> 	struct xfs_log_iovec	*vec,
> 	void			*src,
> 	int			len,
> 	int			type)
> {
> 	memcpy(vec->i_addr, src_ptr, len);
> 	vec->i_len = len;
> 	vec->i_type = type;
> }

I went forth and back between having this a couple of times and found
having the helper more confusing than not.  If there's enough strong
opinion to have it I can add it back.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
