Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C2967F3F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 03:15:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68EE38F804B
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 01:15:37 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YWhp12sadzORFhed for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 01:15:35 -0800 (PST)
Date: Mon, 25 Nov 2013 20:15:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: let iop_format write directly into the linear
	buffer
Message-ID: <20131125091527.GD8803@dastard>
References: <20131123151151.716201348@bombadil.infradead.org>
	<20131123151533.726941044@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131123151533.726941044@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Nov 23, 2013 at 07:11:52AM -0800, Christoph Hellwig wrote:
> Instead of setting up pointers to memory locations in iop_format which then
> get copied into the CIL linear buffer after return move the copy into
> the individual inode items.  This avoids the need to always have a memory
> block in the exact same layout that gets written into the log around, and
> allow the log items to be much more flexible in their in-memory layouts.

There's a lot of fair intricate manipulations in this patch that
could be separated and hence easier to understand. I think you could
break this up in several patches:

	- xfs_buf_item_straddle() factoring
	- removal of the special cases for no endian swapping around
	  xfs_inode_item_format_extents()
	- a separate patch to introduce xlog_first/next/last_iovec(),
	  as I had to find those first to understand how the new
	  code worked
	- a new xlog_copy_iovec() function instead of open coding
	  the same 3 lines of code in 14 different places:

static inline void
xlog_copy_iovec(
	struct xfs_log_iovec	*vec,
	void			*src,
	int			len,
	int			type)
{
	memcpy(vec->i_addr, src_ptr, len);
	vec->i_len = len;
	vec->i_type = type;
}

	- and finally all the conversions. The addition of an
	  xlog_copy_vec() helper will make the final patch that does
	  the switchover much smaller and easier to verify....


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
