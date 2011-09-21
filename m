Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LJ728q168501 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 14:07:03 -0500
Subject: Re: [PATCH 23/27] rearrange bmapi and bmalloca structures for best
	packing
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110921140603.GA31188@infradead.org>
References: <20110918204040.266805129@bombadil.infradead.org>
	<20110918204147.015140236@bombadil.infradead.org>
	<1316447547.2941.7.camel@doink> <20110921140603.GA31188@infradead.org>
Date: Wed, 21 Sep 2011 14:05:34 -0500
Message-ID: <1316631934.5872.19.camel@doink>
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Wed, 2011-09-21 at 10:06 -0400, Christoph Hellwig wrote:
> On Mon, Sep 19, 2011 at 10:52:27AM -0500, Alex Elder wrote:
> > On Sun, 2011-09-18 at 16:41 -0400, Christoph Hellwig wrote:
> > > plain text document attachment (xfs-bmalloca-shrink)
> > > Minimise the stack overhead of the remaining stack variables and
> > > structures placed on the stack by packing them without holes. pahole
> > > is used to optimise allocation args structures, stack variables are
> > > done manually.
> > > 
> > > [hch: various updates while forward porting the changes]
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > I don't object to it, but I do comment on something
> > below that I think is not an improvement.  I'll
> > take this as-is anyway, unless you care to re-submit
> > it.
> 
> This one actually breaks test 170, so I'd suggest skipping it for now.
> All the later patches will apply just fine without it.
> 

I am testing now using this entire series *without*
this one patch.  I have not seen anything unexpected
so far.  Dave indicated he was OK with this series
being committed, though he had not done a thorough
review.  At this point--unless I encounter some strange
new error as I continue to test this stuff--I am
just waiting for your go-ahead to commit Christoph.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
