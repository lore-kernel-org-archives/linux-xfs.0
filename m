Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2BOZmm069529 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 05:24:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64A281DC07AE
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 03:24:33 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qepAAQuXdtyffd70 for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 03:24:33 -0800 (PST)
Date: Fri, 2 Dec 2011 06:24:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix allocation length overflow in xfs_bmapi_write()
Message-ID: <20111202112431.GA17319@infradead.org>
References: <1322738660-31102-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1322738660-31102-1-git-send-email-david@fromorbit.com>
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

On Thu, Dec 01, 2011 at 10:24:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When testing the new xfstests --large-fs option that does very large
> file preallocations, this assert was tripped deep in
> xfs_alloc_vextent():
> 
> XFS: Assertion failed: args->minlen <= args->maxlen, file: fs/xfs/xfs_alloc.c, line: 2239
> 
> The allocation was trying to allocate a zero length extent because
> the lower 32 bits of the allocation length was zero. The remaining
> length of the allocation to be done was an exact multiple of 2^32 -
> the first case I saw was at 496TB remaining to be allocated.
> 
> This turns out to be an overflow when converting the allocation
> length (a 64 bit quantity) into the extent length to allocate (a 32
> bit quantity), and it requires the length to be allocated an exact
> multiple of 2^32 blocks to trip the assert.
> 
> Fix it by limiting the extent lenth to allocate to MAXEXTLEN.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and probably another 3.2 candidate)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
