Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2TJ3bm5243925 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:03:37 -0500
Subject: Re: [PATCH 0/5] improved busy extent handling
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110328210614.832613417@bombadil.infradead.org>
References: <20110328210614.832613417@bombadil.infradead.org>
Date: Tue, 29 Mar 2011 14:04:35 -0500
Message-ID: <1301425475.3026.251.camel@doink>
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

On Mon, 2011-03-28 at 17:06 -0400, Christoph Hellwig wrote:
> This series optimizes how XFS deals with busy extents.  It starts to
> track them exactly, and allows reuses where possible (metadata to metadata)
> or else tries to avoid busy extents during allocations.  This means
> we don't have a single log force due to busy extents during either
> xfstests, compilebench or postmark on my testsystem, which can easily
> be tracked using the new tracepoints added in the last patch.
> 
> This is a repost of the previous series and should address all review
> comments.  The discard support, which relies on the exact busy extent
> tracking has been dropped temporarily until I can fix up some issues
> that I found during testing.

I've reviewed the series and it looks good to me.
Unless someone else has comments that deserve some
action I can take these in as-is.  I'll wait for
a bit though, to let the 2.6.39 merge window settle.

I'm still curious what this (clipping busy blocks
from consideration when allocating) will do to
allocation patterns.  Probably not much except in
somewhat extreme conditions (when they already
won't likely be that good).  The "goodness" of
allocation patterns are a bit hard to characterize
anyway.


					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
