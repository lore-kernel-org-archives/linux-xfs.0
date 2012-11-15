Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFGMDYU015338 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 10:22:13 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YvloG2e0vvw3JLNe (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 08:24:18 -0800 (PST)
Date: Thu, 15 Nov 2012 11:24:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/32] xfs: remove xfs_flush_pages
Message-ID: <20121115162417.GD4019@infradead.org>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352721264-3700-5-git-send-email-david@fromorbit.com>
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

On Mon, Nov 12, 2012 at 10:53:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is a complex wrapper around VFS functions, but there are VFS
> functions that provide exactly the same functionality. Call the VFS
> functions directly and remove the unnecessary indirection and
> complexity.
> 
> We don't need to care about clearing the XFS_ITRUNCATED flag, as
> that is done during .writepages. Hence is cleared by the VFS
> writeback path if there is anything to write back during the flush.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
