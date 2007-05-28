Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 May 2007 19:17:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4S2HNWt016282
	for <xfs@oss.sgi.com>; Sun, 27 May 2007 19:17:26 -0700
Date: Mon, 28 May 2007 12:17:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Message-ID: <20070528021718.GZ85884050@sgi.com>
References: <200705241318.30711.dap@mail.index.hu> <200705251635.36533.dap@mail.index.hu> <20070528003010.GS85884050@sgi.com> <200705280350.18384.dap@mail.index.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705280350.18384.dap@mail.index.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pallai Roland <dap@mail.index.hu>
Cc: David Chinner <dgc@sgi.com>, Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Mon, May 28, 2007 at 03:50:17AM +0200, Pallai Roland wrote:
> On Monday 28 May 2007 02:30:11 David Chinner wrote:
> > On Fri, May 25, 2007 at 04:35:36PM +0200, Pallai Roland wrote:
> > > .and I've spammed such messages. This "internal error" isn't a good
> > > reason to shut down the file system?
> >
> > Actaully, that error does shut the filesystem down in most cases. When you
> > see that output, the function is returning -EFSCORRUPTED. You've got a
> > corrupted freespace btree.
> >
> > The reason why you get spammed is that this is happening during background
> > writeback, and there is no one to return the -EFSCORRUPTED error to. The
> > background writeback path doesn't specifically detect shut down filesystems
> > or trigger shutdowns on errors because that happens in different layers so
> > you just end up with failed data writes. These errors will occur on the
> > next foreground data or metadata allocation and that will shut the
> > filesystem down at that point.
> >
> > I'm not sure that we should be ignoring EFSCORRUPTED errors here; maybe in
> > this case we should be shutting down the filesystem.  That would certainly
> > cut down on the spamming and would not appear to change anything other
> > behaviour....
>  If I remember correctly, my file system wasn't shutted down at all, it 
> was "writeable" for whole night, the yafc slowly "written" files to it. Maybe 
> all write operations had failed, but yafc doesn't warn.

So you never created new files or directories, unlinked files or
directories, did synchronous writes, etc? Just had slowly growing files?

>  Spamming is just annoying when we need to find out what went wrong (My 
> kernel.log is 300Mb), but for data security it's important to react to 
> EFSCORRUPTED error in any case, I think so. Please consider this.

The filesystem has responded correctly to the corruption in terms of
data security (i.e. failed the data write and warned noisily about
it), but it probably hasn't done everything it should....

Hmmmm. A quick look at the linux code makes me thikn that background
writeback on linux has never been able to cause a shutdown in this
case. However, the same error on Irix will definitely cause a
shutdown, though....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
