Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FK5fbi093585 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 14:05:41 -0600
Date: Sun, 15 Feb 2009 15:05:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Re-dirty pages on I/O error
Message-ID: <20090215200506.GA12161@infradead.org>
References: <4990DCF6.5000900@sgi.com> <20090210100129.GN8830@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090210100129.GN8830@disturbed>
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
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 10, 2009 at 09:01:29PM +1100, Dave Chinner wrote:
> On Tue, Feb 10, 2009 at 12:48:38PM +1100, Lachlan McIlroy wrote:
> > [This patch seems to have slipped through the proverbial crack.]
> >
> > If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
> > we throw away the dirty page without converting the delayed allocation.  This
> > leaves delayed allocations that can never be removed and confuses code that
> > expects a flush of the file to clear them.  We need to re-dirty the page on
> > error so we can try again later or report that the flush failed.
> 
> As discussed previously, the fix that is needed in the page
> invalidation path. i.e.  the page invalidate path clears the
> buffer_delay() flag (via discard_buffer) before we get to
> ->releasepage and so releasepage fails to convert the delalloc
> extent before tossing the page....

And we need to get started on that fix rather sooner than later.

Any chance to get some testcase extrace from the scenarios at those
customer sites?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
