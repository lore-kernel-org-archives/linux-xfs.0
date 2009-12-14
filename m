Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBEMlgNk183215 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 16:47:42 -0600
Date: Mon, 14 Dec 2009 17:48:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: cleanup bmap extent state macros
Message-ID: <20091214224819.GA27432@infradead.org>
References: <20091125000019.GA25432@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A6847@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6847@cf--amer001e--3.americas.sgi.com>
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

On Mon, Dec 14, 2009 at 03:29:45PM -0600, Alex Elder wrote:
> Christoph Hellwig wrote:
> > Cleanup the extent state macros in the bmap code to use one common set of
> > flags that we can pass to the tracing code later and remove a lot of the
> > macro obsfucation.
> 
> This looks good.  Although this was motivated by making this code fit into
> the tracing model better, I prefer the way the result looks anyway.
> 
> Your changes are nice, straightforward mapping from the old to the
> new.  In a couple of spots it might be slightly clearer to assign
> a mask temporary, e.g. replace something like:
> 	   if ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
> 		       BMAP_RIGHT_FILLING)) !=
> 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
> 		       BMAP_RIGHT_FILLING))
> with
> 	   mask = BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING;
> 	   if (state & mask != mask)
> Nevertheless, I'm glad you didn't make changes like that because
> it was easier to review this way.  Something to consider for later.

Yeah, pondered it, but it didn't look totally clean with the mask
either.  It's a all bit borderline.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
