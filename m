Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CDS5PY082714 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 08:28:05 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HxpXBIGYnwRiAe4p (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 06:28:04 -0700 (PDT)
Date: Mon, 12 Mar 2012 09:28:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/10] xfs: fallback to vmalloc for large buffers in
	xfs_getbmap
Message-ID: <20120312132803.GD25944@infradead.org>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1331095828-28742-5-git-send-email-david@fromorbit.com>
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

On Wed, Mar 07, 2012 at 03:50:22PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_getbmap uses for a large buffer for extents, which is kmalloc'd.
> This can fail after the system has been running for some time as it
> is a high order allocation. Add a fallback to vmalloc so that it
> doesn't require contiguous memory and so won't randomly fail on
> files with large extent lists.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
