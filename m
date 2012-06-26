Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5QAEigf086024 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 05:14:44 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zS0v35seVKs35Jjb (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Jun 2012 03:14:43 -0700 (PDT)
Date: Tue, 26 Jun 2012 06:14:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: separate buffer indexing from block map
Message-ID: <20120626101442.GB26241@infradead.org>
References: <1340355015-26250-1-git-send-email-david@fromorbit.com>
	<1340355015-26250-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1340355015-26250-3-git-send-email-david@fromorbit.com>
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

On Fri, Jun 22, 2012 at 06:50:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To support discontiguous buffers in the buffer cache, we need to
> separate the cache index variables from the I/O map. While this is
> currently a 1:1 mapping, discontiguous buffer support will break
> this relationship.
> 
> However, for caching purposes, we can still treat them the same as a
> contiguous buffer - the block number of the first block and the
> length of the buffer - as that is still a unique representation.
> Also, the only way we will ever access the discontiguous regions of
> buffers is via bulding the complete buffer in the first place, so
> using the initial block number and entire buffer length is a sane
> way to index the buffers.
> 
> Add a block mapping vector construct to the xfs_buf and use it in
> the places where we are doing IO instead of the current
> b_bn/b_length variables.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
