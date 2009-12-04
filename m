Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB4AFN9p204124 for <xfs@oss.sgi.com>; Fri, 4 Dec 2009 04:15:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 302261B3D79B
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2009 02:15:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lYHYrk7ZrzbF7g5a for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2009 02:15:55 -0800 (PST)
Date: Fri, 4 Dec 2009 05:15:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [XFS] Free buffer pages array unconditionally
Message-ID: <20091204101553.GA2519@infradead.org>
References: <1259734333-20581-1-git-send-email-david@fromorbit.com>
	<20091202151742.GA1263@infradead.org>
	<20091202222228.GN30608@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091202222228.GN30608@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Dec 03, 2009 at 09:22:28AM +1100, Dave Chinner wrote:
> > kmem_free happily takes a NULL pointer, so this is unessecary.
> 
> Yes, it does, but I wanted to make sure that b_pages had been
> assigned before doing the comparison because this is now
> called unconditionally. I?ll remove the check and retest.
> 
> Hmmm - I suspect that this function needs to NULL b_pages
> in case it _xfs_buf_free_pages() is called prior to calling
> xfs_buf_free()...

Yes, at least for now.  Long term we should stop messing with the page array
on a live buffer.  The only place where we currently do that is
xfs_buf_associate_memory, which has two callers, one for the log wrap
reserver buffer, and the other in various places in log recovery for
aligned v2 logs.

For the first one we know the max number of pages we might have to deal
with so we can pass it when allocating the buffer, and for the second
one the number of pages can't be bigger than the original number of
pages for the buffer every so there's no need to do the reallocation
game at all.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
