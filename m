Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7NDRux9131167 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 08:27:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B4B3182CE
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 06:28:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8MgZK3uM08kUhnq3 for
	<xfs@oss.sgi.com>; Mon, 23 Aug 2010 06:28:29 -0700 (PDT)
Date: Mon, 23 Aug 2010 09:28:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: handle negative wbc->nr_to_write during sync
	writeback
Message-ID: <20100823132829.GB15918@infradead.org>
References: <1282565437-13880-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282565437-13880-1-git-send-email-david@fromorbit.com>
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

On Mon, Aug 23, 2010 at 10:10:37PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> During data integrity (WB_SYNC_ALL) writeback, wbc->nr_to_write will
> go negative on inodes with more than 1024 dirty pages due to
> implementation details of write_cache_pages(). Currently XFS will
> abort page clustering in writeback once nr_to_write drops below
> zero, and so for data integrity writeback we will do very
> inefficient page at a time allocation and IO submission for inodes
> with large numbers of dirty pages.
> 
> Fix this by only aborting the page clustering code when
> wbc->nr_to_write is negative and the sync mode is WB_SYNC_NONE.

Looks okay, but I wonder why if we should remove the check entirely.
We're clustering inside the same extent, and we already have a cap
for the extent size.  That means the additional I/O basically is for
free and we really shouldn't let the writeback code restrict us here.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
