Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2NCDDrY091073 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:13:23 -0500
Date: Wed, 23 Mar 2011 08:16:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: optimize AGFL refills
Message-ID: <20110323121613.GA468@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.280301318@bombadil.infradead.org>
	<1300833051.2875.275.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1300833051.2875.275.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Mar 22, 2011 at 05:30:51PM -0500, Alex Elder wrote:
> On Tue, 2011-03-22 at 15:55 -0400, Christoph Hellwig wrote:
> > Avoid forcing out busy extent when moving blocks from/to the AGFL.  We
> 
> Without thinking a bit about it, it wasn't clear why doing
> this was OK to do.  It would be nice to record a one-sentence
> justification of why we don't need to force busy extents out
> in this case.

I've added a sentence, but it seems rather pointless.

>  achieve this

fixed.

> > the callers that need it, and by moving the busy list insert from
> > xfs_free_ag_extent extent which is used both by AGFL refills and real
>                      ^^^^^ drop this word

fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
