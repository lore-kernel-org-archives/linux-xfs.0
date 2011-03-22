Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2MMS4AB052855 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 17:28:09 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED922AC00F
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 15:30:58 -0700 (PDT)
Subject: Re: [PATCH 1/6] xfs: optimize AGFL refills
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110322200137.280301318@bombadil.infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.280301318@bombadil.infradead.org>
Date: Tue, 22 Mar 2011 17:30:51 -0500
Message-ID: <1300833051.2875.275.camel@doink>
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

On Tue, 2011-03-22 at 15:55 -0400, Christoph Hellwig wrote:
> Avoid forcing out busy extent when moving blocks from/to the AGFL.  We

Without thinking a bit about it, it wasn't clear why doing
this was OK to do.  It would be nice to record a one-sentence
justification of why we don't need to force busy extents out
in this case.

> archive this my moving the busy search out of xfs_alloc_get_freelist into

 achieve this

> the callers that need it, and by moving the busy list insert from
> xfs_free_ag_extent extent which is used both by AGFL refills and real
                     ^^^^^ drop this word

> allocation to xfs_free_extent, which is only used by the latter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Otherwise the change itself looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
