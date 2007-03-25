Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 16:58:36 -0700 (PDT)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2PNwU6p005463
	for <xfs@oss.sgi.com>; Sun, 25 Mar 2007 16:58:31 -0700
From: Neil Brown <neilb@suse.de>
Date: Mon, 26 Mar 2007 09:58:22 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17927.3230.273341.837191@notabene.brown>
Subject: Re: XFS and write barriers.
In-Reply-To: message from David Chinner on Sunday March 25
References: <17923.11463.459927.628762@notabene.brown>
	<20070323053043.GD32602149@melbourne.sgi.com>
	<20070323095055.GA13478@infradead.org>
	<20070325035126.GI32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sunday March 25, dgc@sgi.com wrote:
> On Fri, Mar 23, 2007 at 09:50:55AM +0000, Christoph Hellwig wrote:
> > 
> > So yes, we could probably get rid of the check now, although I'd
> > prefer the block layer exporting an API to the filesystem to tell
> > it whether there is any point in trying to use barriers.
> 
> Ditto.

What would be the point of that interface?

If it only says "It might be worth testing", then you still have to
test.  And if you have to test, where is the value in asking in
advance.
The is no important difference between "the device said 'don't bother
trying'" and "We tried and the device said 'no'".

> > 
> > So you're retrying the whole I/O, this is probably better than trying
> > to handle this at the bio level.  I still don't quite like doing another
> > I/O from the I/O completion handler.
> 
> You're not the only one, Christoph. This may be better than trying
> to handle it at lower layers, and far better than having to handle
> it at every point in the higher layers where we may issue barrier
> I/Os. 

But I think that has to be where it is handled.
What other filesystems do is something like:

   if (barriers_supported) {
       submit barrier request;
       wait for completion
       if (fail with -EOPNOTSUPP)
             barriers_supported = 0;
   }
   if (!barriers_supported) {
        wait for other requests to complete;
        submit non-barrier request;
        wait for completion
   }
   handle_error

Obviously if you are going to issue barrier writes from multiple
places you would put this in a function...
I'm not sure that other filesystems call blkdev_issue_flush.... As you
said elsewhere, not a very effectively communicated interface.


> 
> But I *seriously dislike* having to reissue async I/Os in this
> manner and then having to rely on a higher layer's I/o completion
> handler to detect the fact that the I/O was retried to change the
> way the filesystem issues I/Os in the future. It's a really crappy
> way of communicating between layers....

md/dm do add extra complexity to the blockdev interface that I don't
think were fully considered when the interface wa designed.

We would really like a client to say "I'm starting to build a bio"
so that the device can either block that until a reconfiguration
completes, or can block any reconfiguration until the bio is fully
built and submitted (or aborted).
Once you have that bio-being-built handle, it would probably make
sense to test 'are barriers supported' for that bio without having to
submit an IO..

NeilBrown
