Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 May 2007 16:36:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4SNaOWt017600
	for <xfs@oss.sgi.com>; Mon, 28 May 2007 16:36:26 -0700
Date: Tue, 29 May 2007 09:36:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Message-ID: <20070528233617.GI85884050@sgi.com>
References: <200705241318.30711.dap@mail.index.hu> <20070525000547.GH85884050@sgi.com> <200705281453.55618.dap@mail.index.hu> <200705281730.53343.dap@mail.index.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705281730.53343.dap@mail.index.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pallai Roland <dap@mail.index.hu>
Cc: David Chinner <dgc@sgi.com>, Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Mon, May 28, 2007 at 05:30:52PM +0200, Pallai Roland wrote:
> 
> On Monday 28 May 2007 14:53:55 Pallai Roland wrote:
> > On Friday 25 May 2007 02:05:47 David Chinner wrote:
> > > "-o ro,norecovery" will allow you to mount the filesystem and get any
> > > uncorrupted data off it.
> > >
> > > You still may get shutdowns if you trip across corrupted metadata in
> > > the filesystem, though.
> >
> > This filesystem is completely dead.
> > [...]
> 
>  I tried to make a md patch to stop writes if a raid5 array got 2+ failed 
> drives, but I found it's already done, oops. :) handle_stripe5() ignores 
> writes in this case quietly, I tried and works.

Hmmm - it clears the uptodate bit on the bio, which is supposed to
make the bio return EIO. That looks to be doing the right thing...

>  There's an another layer I used on this box between md and xfs: loop-aes. I 

Oh, that's a kind of important thing to forget to mention....

> used it since years and rock stable, but now it's my first suspect, cause I 
> found a bug in it today:
>  I assembled my array from n-1 disks, and I failed a second disk for a test 
> and I found /dev/loop1 still provides *random* data where /dev/md1 serves 
> nothing, it's definitely a loop-aes bug:

.....

>  It's not an explanation to my screwed up file system, but for me it's enough 
> to drop loop-aes. Eh.

If you can get random data back instead of an error from the block device,
then I'm not surprised your filesystem is toast. If it's one sector in a
larger block that is corrupted, then the only thing that will protect you from
this sort of corruption causing problems is metadata checksums (yet another
thin on my list of stuff to do).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
