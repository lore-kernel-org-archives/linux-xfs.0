Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G1hmdh218940 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 19:43:48 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JJ7RGXtKBBshd8YH for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 17:43:46 -0800 (PST)
Date: Thu, 16 Feb 2012 12:43:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Transactional XFS?
Message-ID: <20120216014338.GX14132@dastard>
References: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
	<20120216002237.GW14132@dastard> <87k43nzj5e.fsf@flamingspork.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k43nzj5e.fsf@flamingspork.com>
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
To: Stewart Smith <stewart@flamingspork.com>
Cc: Grozdan <neutrino8@gmail.com>, xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 12:01:01PM +1100, Stewart Smith wrote:
> On Thu, 16 Feb 2012 11:22:37 +1100, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Feb 15, 2012 at 08:15:46PM +0100, Grozdan wrote:
> > > Hi,
> > > 
> > > I just finished watching the excellent speech of Dave Chinner at
> > > linux.conf.au and I must say I'm impressed by the recent improvements
> > > to XFS. Towards the end of the talk, Dave talked about upcoming
> > > improvements on Metadata reliability and other features. What I'm
> > > wondering about is if there are any plans in making XFS transactional
> > > (fully atomic) like it is the case with recent NTFS versions on
> > > Windows Vista and higher?
> > 
> > What do you mean by "fully atomic"? NTFS is not fully atomic - it
> > doesn't journal data so can lose data on a crash - so I'm not sure
> > what you mean here....
> 
> There's another API in Windows that's let you do operations in a
> all-or-nothing way. Originally this was scoped to be able to just add a
> couple of API calls to the Windows file API and have it all "just work"
> (imagine adding just three syscalls: begin(), commit(),
> rollback()). This didn't really work out so well, and by the final Vista
> release, it was a wholly different API calls (more like tx_begin,
> tx_open, tx_read, tx_write... so you had to have code explicitly aware
> of transactions).

Oh, so making some set of random user changes to random user data
have ACID properties? That's what databases are for, isn't it?  :P

I dont see us implementing anything like this in XFS anytime soon.
We are looking to add transaction grouping so that we can make
things that currently require multiple transactions (e.g. create a
file, add a default ACL) atomic, but I don't have any plans to
open the can of worms that is userspace controlled transactions any
time soon.

> AFAIK the current big user is Windows Update. That is, windows update
> will either apply all its changes to the system or none. Think of being
> able to hit the reset button halfway through a windows update and have
> everything "just work" and come back to a sane state. I've had a linux
> box crash during a dist-upgrade before... not pretty.
> 
> It's a neat idea, but as you can imagine, fraught with difficulties.

We already have this upgrade rollback functionality in development
with none of that complexity - it uses filesystem snapshots so is
effectively filesystem independent and already works with yum and
btrfs. You don't need any special application support for this -
rollback from a failed upgrade is as simple as a reboot.

> I think it'd be possible to do.. you know, if you lock a number of FS
> and VFS devs in a room with database people for a month or so we may
> theoritically solve nearly all the problems....

Sure, Microsoft have been trying to make their filesystem a database
for years. It's theoretically possible, but in practice they've
fallen short in every attempt in the past 15 years.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
