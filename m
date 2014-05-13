Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1354A7F50
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 22:46:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0BF2304135
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 20:46:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RkZVIBimGUDOHtn9 for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 20:46:52 -0700 (PDT)
Date: Tue, 13 May 2014 13:46:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crash?
Message-ID: <20140513034647.GA5421@dastard>
References: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
	<20140305233551.GK6851@dastard>
	<CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
	<CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
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
To: Austin Schuh <austin@peloton-tech.com>
Cc: xfs <xfs@oss.sgi.com>

On Mon, May 12, 2014 at 06:29:28PM -0700, Austin Schuh wrote:
> On Wed, Mar 5, 2014 at 4:53 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> > Hi Dave,
> >
> > On Wed, Mar 5, 2014 at 3:35 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> On Wed, Mar 05, 2014 at 03:08:16PM -0800, Austin Schuh wrote:
> >>> Howdy,
> >>>
> >>> I'm running a config_preempt_rt patched version of the 3.10.11 kernel,
> >>> and I'm seeing a couple lockups and crashes which I think are related
> >>> to XFS.
> >>
> >> I think they ar emore likely related to RT issues....
> >>
> >
> > That very well may be true.
> >
> >> Your usb device has disconnected and gone down the device
> >> removal/invalidate partition route. and it's trying to flush the
> >> device, which is stuck on IO completion which is stuck waiting for
> >> the device error handling to error them out.
> >>
> >> So, this is a block device problem error handling problem caused by
> >> device unplug getting stuck because it's decided to ask the
> >> filesystem to complete operations that can't be completed until the
> >> device error handling progress far enough to error out the IOs that
> >> the filesystem is waiting for completion on.
> >>
> >> Cheers,
> >>
> >> Dave.
> >> --
> >> Dave Chinner
> >> david@fromorbit.com
> 
> I had the issue reproduce itself today with just the main SSD
> installed.  This was on a new machine that was built this morning.
> There is a lot less going on in this trace than the previous one.

The three blocked threads:

	1. kworker running IO completion waiting on an inode lock,
	   holding locked pages.
	2. kworker running writeback flusher work waiting for a page lock
	3. direct flush work waiting for allocation, holding page
	   locks and the inode lock.

What's the kworker thread running the allocation work doing?

You might need to run `echo w > proc-sysrq-trigger` to get this
information...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
