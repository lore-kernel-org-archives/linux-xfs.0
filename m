Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11N0BBs249484 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 17:00:11 -0600
Subject: Re: [PATCH 6/6] xfs: remove handling of duplicates the busy extent
	tree
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110121092551.629220945@bombadil.infradead.org>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092551.629220945@bombadil.infradead.org>
Date: Tue, 01 Feb 2011 17:02:39 -0600
Message-ID: <1296601359.2350.130.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, 2011-01-21 at 04:22 -0500, Christoph Hellwig wrote:
> plain text document attachment (xfs-remove-duplicate-extent-handling)
> With the recent changes we never re-used busy extents.  Remove all handling
> of them and replace them with asserts.  This also effectively reverts
> commit 955833cf2ad0aa39b336e853cad212d867199984
> 
> 	"xfs: make the log ticket ID available outside the log infrastructure"

I have a hunch that this, for you, was an itch that
needed scratching.


Anyway, I was wondering about the following when
xfs_alloc_busy_search_trim() was added.  Maybe you
could just offer a quick explanation.  If we always
skip busy extents when allocating blocks, will we
still satisfy allocation requests when we're almost
out of space?  Will a log flush cause busy extents
to become non-busy when we find nothing available,
thereby always satifying requests we would have
satisfied (perhaps with busy extents) previously?

Second, is there *anything* that could be said about
the resulting allocation patterns?  Will they be
affected in any adverse (or beneficial) way by
skipping busy extents?  (Will we get more fragmented
earlier, for a contrived example?)  I have no
feeling for it but thought the question ought
to be asked...

Outside of the above, I think this patch looks fine.
The xfs_alloc_busy_search() call becomes a debug-only
function (and might as well be surrounded by DEBUG
ifdef's, accordingly), ensuring an allocated extent
is never found in the busy list.

I'm not signing off on this for now, though, because
I want to hear back on the comments from the previous
patch, and I think you're going to be re-posting the
series anyway.

					-Alex

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_ag.h
> ==========================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
