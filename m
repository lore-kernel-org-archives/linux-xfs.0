Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 May 2007 04:18:27 -0700 (PDT)
Received: from dh.localdomain (inn.nightwish.hu [217.20.130.190])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4SBHbWt017389
	for <xfs@oss.sgi.com>; Mon, 28 May 2007 04:18:21 -0700
From: Pallai Roland <dap@mail.index.hu>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Date: Mon, 28 May 2007 13:17:31 +0200
References: <200705241318.30711.dap@mail.index.hu> <200705280350.18384.dap@mail.index.hu> <20070528021718.GZ85884050@sgi.com>
In-Reply-To: <20070528021718.GZ85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281317.32384.dap@mail.index.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com


On Monday 28 May 2007 04:17:18 David Chinner wrote:
> On Mon, May 28, 2007 at 03:50:17AM +0200, Pallai Roland wrote:
> > On Monday 28 May 2007 02:30:11 David Chinner wrote:
> > > On Fri, May 25, 2007 at 04:35:36PM +0200, Pallai Roland wrote:
> > > > .and I've spammed such messages. This "internal error" isn't a good
> > > > reason to shut down the file system?
> > >
> > > Actaully, that error does shut the filesystem down in most cases. When
> > > you see that output, the function is returning -EFSCORRUPTED. You've
> > > got a corrupted freespace btree.
> > >
> > > The reason why you get spammed is that this is happening during
> > > background writeback, and there is no one to return the -EFSCORRUPTED
> > > error to. The background writeback path doesn't specifically detect
> > > shut down filesystems or trigger shutdowns on errors because that
> > > happens in different layers so you just end up with failed data writes.
> > > These errors will occur on the next foreground data or metadata
> > > allocation and that will shut the filesystem down at that point.
> > >
> > > I'm not sure that we should be ignoring EFSCORRUPTED errors here; maybe
> > > in this case we should be shutting down the filesystem.  That would
> > > certainly cut down on the spamming and would not appear to change
> > > anything other behaviour....
> >
> >  If I remember correctly, my file system wasn't shutted down at all, it
> > was "writeable" for whole night, the yafc slowly "written" files to it.
> > Maybe all write operations had failed, but yafc doesn't warn.
>
> So you never created new files or directories, unlinked files or
> directories, did synchronous writes, etc? Just had slowly growing files?
 I just overwritten badly downloaded files.

> >  Spamming is just annoying when we need to find out what went wrong (My
> > kernel.log is 300Mb), but for data security it's important to react to
> > EFSCORRUPTED error in any case, I think so. Please consider this.
>
> The filesystem has responded correctly to the corruption in terms of
> data security (i.e. failed the data write and warned noisily about
> it), but it probably hasn't done everything it should....
>
> Hmmmm. A quick look at the linux code makes me thikn that background
> writeback on linux has never been able to cause a shutdown in this
> case. However, the same error on Irix will definitely cause a
> shutdown, though....
 I hope Linux will follow Irix, that's a consistent standpoint.


 David, have you a plan to implement your "reporting raid5 block layer" idea? 
No one else has caring about this silent data loss on temporary (cable, 
power) failed raid5 arrays as I see, I really hope you do at least!


--
 d
