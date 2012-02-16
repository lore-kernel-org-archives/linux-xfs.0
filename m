Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G114xJ216767 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 19:01:04 -0600
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id LyC40CZm3RfU6CBw
	for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 17:01:03 -0800 (PST)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: Transactional XFS?
In-Reply-To: <20120216002237.GW14132@dastard>
References: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
	<20120216002237.GW14132@dastard>
Date: Thu, 16 Feb 2012 12:01:01 +1100
Message-ID: <87k43nzj5e.fsf@flamingspork.com>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, Grozdan <neutrino8@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, 16 Feb 2012 11:22:37 +1100, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Feb 15, 2012 at 08:15:46PM +0100, Grozdan wrote:
> > Hi,
> > 
> > I just finished watching the excellent speech of Dave Chinner at
> > linux.conf.au and I must say I'm impressed by the recent improvements
> > to XFS. Towards the end of the talk, Dave talked about upcoming
> > improvements on Metadata reliability and other features. What I'm
> > wondering about is if there are any plans in making XFS transactional
> > (fully atomic) like it is the case with recent NTFS versions on
> > Windows Vista and higher?
> 
> What do you mean by "fully atomic"? NTFS is not fully atomic - it
> doesn't journal data so can lose data on a crash - so I'm not sure
> what you mean here....

There's another API in Windows that's let you do operations in a
all-or-nothing way. Originally this was scoped to be able to just add a
couple of API calls to the Windows file API and have it all "just work"
(imagine adding just three syscalls: begin(), commit(),
rollback()). This didn't really work out so well, and by the final Vista
release, it was a wholly different API calls (more like tx_begin,
tx_open, tx_read, tx_write... so you had to have code explicitly aware
of transactions).

AFAIK the current big user is Windows Update. That is, windows update
will either apply all its changes to the system or none. Think of being
able to hit the reset button halfway through a windows update and have
everything "just work" and come back to a sane state. I've had a linux
box crash during a dist-upgrade before... not pretty.

It's a neat idea, but as you can imagine, fraught with difficulties.

I think it'd be possible to do.. you know, if you lock a number of FS
and VFS devs in a room with database people for a month or so we may
theoritically solve nearly all the problems....

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
