Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5QAEGSb085896 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 05:14:16 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wk6WokHn238smf9Z (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Jun 2012 03:14:12 -0700 (PDT)
Date: Tue, 26 Jun 2012 06:14:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] xfs: struct xfs_buf_log_format isn't variable sized.
Message-ID: <20120626101411.GA26241@infradead.org>
References: <1340355015-26250-1-git-send-email-david@fromorbit.com>
	<1340355015-26250-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1340355015-26250-2-git-send-email-david@fromorbit.com>
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

On Fri, Jun 22, 2012 at 06:50:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The struct xfs_buf_log_format wants to think the dirty bitmap is
> variable sized.  In fact, it is variable size on disk simply due to
> the way we map it from the in-memory structure, but we still just
> use a fixed size memory allocation for the in-memory structure.
> 
> Hence it makes no sense to set the function up as a variable sized
> structure when we already know it's maximum size, and we always
> allocate it as such. Simplify the structure by making the dirty
> bitmap a fixed sized array and just using the size of the structure
> for the allocation size.
> 
> This will make it much simpler to allocate and manipulate an array
> of format structures for discontiguous buffer support.
> 
> The previous struct xfs_buf_log_item size according to
> /proc/slabinfo was 224 bytes. pahole doesn't give the same size
> because of the variable size definition. With this modification,
> pahole reports the same as /proc/slabinfo:
> 
> 	/* size: 224, cachelines: 4, members: 6 */
> 
> Because the xfs_buf_log_item size is now determined by the maximum
> supported block size we introduce a dependency on xfs_alloc_btree.h.
> Avoid this dependency by moving the idefines for the maximum block
> sizes supported to xfs_types.h with all the other max/min type
> defines to avoid any new dependencies.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
