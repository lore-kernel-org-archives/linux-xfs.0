Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U6tU4u187713 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:55:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3127F1E57226
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 23:55:29 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tMSfENt6opLQtJNY for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 23:55:29 -0700 (PDT)
Date: Thu, 30 Jun 2011 02:55:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/27] xfs: remove the unused ilock_nowait codepath in
	writepage
Message-ID: <20110630065529.GA10893@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.717434334@bombadil.infradead.org>
	<20110630001525.GU561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630001525.GU561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jun 30, 2011 at 10:15:25AM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2011 at 10:01:11AM -0400, Christoph Hellwig wrote:
> > wbc->nonblocking is never set, so this whole code has been unreachable
> > for a long time.  I'm also not sure it would make a lot of sense -
> > we'd rather finish our writeout after a short wait for the ilock
> > instead of cancelling the whole ioend.
> 
> I'd suggest that the only thing that should be dropped is the
> wbc->nonblocking check. Numbers would be good to validate that this
> is still relevant, but I don't have a storage subsystem with enough
> bandwidth to drive a flusher thread to being CPU bound...

I don't mind re-introducing this if we actuall have a testcase for it.
Note that simply keeping the code won't work for the writepages
implementation as we'd cancel the whole ioend if one lock fails,
discarding potentially a lot of I/O.  It's already bad enough with
the simpler clustering we have in the current code.  Back in SLES10 /
2.6.16 when the code could still be reached we only did it for the
bmap calls directly from writepage, but not from the writeout
clustering.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
