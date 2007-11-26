Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Nov 2007 14:21:17 -0800 (PST)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAQMLAlS011839
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2007 14:21:13 -0800
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: XFS related Oops (suspend/resume related)
Date: Mon, 26 Nov 2007 23:07:56 +0100
References: <20071112064706.GA23595@dose.home.local> <20071126131210.GA4430@eazy.amigager.de> <20071126210844.GB119954183@sgi.com>
In-Reply-To: <20071126210844.GB119954183@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711262307.56742.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Monday, 26 of November 2007, David Chinner wrote:
> On Mon, Nov 26, 2007 at 02:12:10PM +0100, Tino Keitel wrote:
> > On Wed, Nov 14, 2007 at 10:04:45 +1100, David Chinner wrote:
> > > On Tue, Nov 13, 2007 at 11:51:19AM +0100, Tino Keitel wrote:
> > > > On Tue, Nov 13, 2007 at 09:27:20 +1100, David Chinner wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > No. I'd say something got screwed up during suspend/resume. Is it
> > > > > reproducable?
> > > > 
> > > > No. I often use suspend to RAM, and usually it works without such
> > > > failures. I restart squid during the resume prosecure, and the above
> > > > Oops lead to a squid in D state.
> > > 
> > > Ok. Sounds like there's not much we can debug at this point. Thanks
> > > for the report, though.
> > 
> > I got a similar Oops again:
> > 
> > xfs_iget_core: ambiguous vns: vp/0xc00700c0, invp/0xcb5a1680
> 
> Now there's a message that I haven't seen in about 3 years.
> 
> It indicates that the linux inode connected to the xfs_inode is not
> the correct one. i.e. that the linux inode cache is out of step with
> the XFS inode cache.
> 
> Basically, that is not supposed to happen. I suspect that the way
> threads are frozen is resulting in an inode lookup racing with
> a reclaim. The reclaim thread gets stopped after any use threads,
> and so we could have the situation that a process blocked in lookup
> has the XFS inode reclaimed and reused before it gets unblocked.
> 
> The question is why is it happening now when none of that code in
> XFS has changed?
> 
> Rafael, when are threads frozen? Only when they schedule or call
> try_to_freeze()?

Kernel threads freeze only when they call try_to_freeze().  User space tasks
freeze while executing the signals handling code.

> Did the freezer mechanism change in 2.6.23 (this is on 2.6.23.1)?

Yes.  Kernel threads are not sent fake signals by the freezer any more.

> Is there some way of getting a stack trace of all the 
> processes in the system once the machine is frozen and about to
> suspend so we can see if we blocked in a lookup?

Yes.  Please add show_state() before the last "return" in freeze_processes().

On 2.6.23.1 you can test the freezer alone by doing

# echo testproc > /sys/power/disk
# echo disk > /sys/power/state

Greetings,
Rafael
