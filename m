Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LE65uk147580 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 09:06:06 -0500
Date: Wed, 21 Sep 2011 10:06:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 23/27] rearrange bmapi and bmalloca structures for best
	packing
Message-ID: <20110921140603.GA31188@infradead.org>
References: <20110918204040.266805129@bombadil.infradead.org>
	<20110918204147.015140236@bombadil.infradead.org>
	<1316447547.2941.7.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316447547.2941.7.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Mon, Sep 19, 2011 at 10:52:27AM -0500, Alex Elder wrote:
> On Sun, 2011-09-18 at 16:41 -0400, Christoph Hellwig wrote:
> > plain text document attachment (xfs-bmalloca-shrink)
> > Minimise the stack overhead of the remaining stack variables and
> > structures placed on the stack by packing them without holes. pahole
> > is used to optimise allocation args structures, stack variables are
> > done manually.
> > 
> > [hch: various updates while forward porting the changes]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I don't object to it, but I do comment on something
> below that I think is not an improvement.  I'll
> take this as-is anyway, unless you care to re-submit
> it.

This one actually breaks test 170, so I'd suggest skipping it for now.
All the later patches will apply just fine without it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
