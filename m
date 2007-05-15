Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 17:15:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4F0F3fB023732
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 17:15:05 -0700
Date: Tue, 15 May 2007 10:14:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070515001450.GS86004887@sgi.com>
References: <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <Pine.LNX.4.61.0705121323030.9570@yvahk01.tjqt.qr> <20070512135143.GG85884050@sgi.com> <4645D594.4070801@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4645D594.4070801@goop.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>, Chuck Ebbert <cebbert@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

On Sat, May 12, 2007 at 07:56:20AM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > What I don't understand is that on unmount dirty xfs inodes get
> > written out. Clearly this is not happening - either there's a hole
> > in the writeback logic (unlikely - it was unchanged) or we've missed
> > some case where we need to update the filesize and mark the inode
> > dirty.
> >
> > Hmmmm - if the write was just a short append to the file, then the
> > block that was written to should already be mapped. Then we'll just
> > look up the extent by doing a BMAPI_READ lookup, set the type to
> > IOMAP_READ and add the block to ioend we are building.
> >   
> 
> Well, that result I mailed you showed that the difference was just over
> 16k, and that there was a 32 block difference in the final extent
> length.  Does that fit with this theory?

Yes - because when we do specualtive allocation of 64k beyond EOF
by default on appends....

> > The type IOMAP_READ determines the I/O completion behaviour - in this case
> > it is xfs_end_bio_read(), which fails to update the file size....
> >
> > Bingo.
> >
> > A patch for you to try, Jeremy. I've just started a test run on it...
> >   
> 
> Thanks, I'll give it a spin.  Have you reproduced the bug yourself?

No, not yet. I haven't had chance because I'm travelling at the moment....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
