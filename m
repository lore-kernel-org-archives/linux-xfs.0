Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4231129DF9
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 16:22:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3090A304039
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 14:22:35 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ysgJqIVX8KKFVN78 for <xfs@oss.sgi.com>;
	Wed, 03 Feb 2016 14:22:30 -0800 (PST)
Date: Thu, 4 Feb 2016 09:22:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160203222216.GG459@dastard>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160129141232.GA43184@bfoster.bfoster>
	<20160202112046.GB28777@lst.de>
	<20160202153117.GB1853@bfoster.bfoster>
	<20160202164237.GA25436@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160202164237.GA25436@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, darrick.wong@oracle.com

On Tue, Feb 02, 2016 at 05:42:37PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 02, 2016 at 10:31:18AM -0500, Brian Foster wrote:
> > FWIW, I don't see any such review comments against the three versions of
> > the "DIO needs an ioend for writes" patch I have in my mailbox, but I
> > easily could have missed something..? But if there wasn't time, then
> > fair enough.
> 
> I'll have to look at the mailboxes, but I remember Dave sending this
> out and complaining.

I don't recall the exact discussion that was had, but at the time it
was an evil that I couldn't see a way of avoiding, and with no other
solution being presented.

ISTR a tie-in with the DAX code, too, but that's gone away now with
the block zeroing during allocation rather than using unwritten
extents and completions for this.

> > If COW is the primary motivator, perhaps we can bundle it with that
> > work?
> 
> The prime motivator is to:
> 
>  (1) avoid a pointless memory allocation
>  (2) avoid a pointless context switch
>  (3) avoid pointless code complexity
> 
> COW is just another case where these show up.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
