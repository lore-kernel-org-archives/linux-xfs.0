Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PKxt10246414 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:59:55 -0500
Subject: Re: [PATCH 1/6] xfs: optimize AGFL refills
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110323121613.GA468@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.280301318@bombadil.infradead.org>
	<1300833051.2875.275.camel@doink> <20110323121613.GA468@infradead.org>
Date: Fri, 25 Mar 2011 16:03:01 -0500
Message-ID: <1301086981.2537.687.camel@doink>
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

On Wed, 2011-03-23 at 08:16 -0400, Christoph Hellwig wrote: 
> On Tue, Mar 22, 2011 at 05:30:51PM -0500, Alex Elder wrote:
> > On Tue, 2011-03-22 at 15:55 -0400, Christoph Hellwig wrote:
> > > Avoid forcing out busy extent when moving blocks from/to the AGFL.  We
> > 
> > Without thinking a bit about it, it wasn't clear why doing
> > this was OK to do.  It would be nice to record a one-sentence
> > justification of why we don't need to force busy extents out
> > in this case.
> 
> I've added a sentence, but it seems rather pointless.

The reason it was not obvious is because the case you're
treating is specifically when moving extents (blocks,
really) between the free list and the free btrees, in
xfs_alloc_fix_freelist().  You still need to force it
out when allocating and freeing "actually used" blocks,
which could also be considered "moving blocks from/to
the AGFL."

					-Alex


> >  achieve this
> 
> fixed.
> 
> > > the callers that need it, and by moving the busy list insert from
> > > xfs_free_ag_extent extent which is used both by AGFL refills and real
> >                      ^^^^^ drop this word
> 
> fixed.
> 




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
