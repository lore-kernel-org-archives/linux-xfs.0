Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0N5BxvY054865 for <xfs@oss.sgi.com>; Sun, 22 Jan 2012 23:11:59 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	D5ygXCw4jANKwvKF for <xfs@oss.sgi.com>;
	Sun, 22 Jan 2012 21:11:57 -0800 (PST)
Date: Mon, 23 Jan 2012 16:11:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: concurrent direct IO write in xfs
Message-ID: <20120123051155.GI15102@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
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
To: Zheng Da <zhengda1936@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 17, 2012 at 02:19:52PM -0500, Zheng Da wrote:
> Hello,
> 
> On Mon, Jan 16, 2012 at 6:25 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > >  0xffffffff81288b6a : xfs_aio_write_newsize_update+0x3a/0x90 [kernel]
> >
> > Only ever taken when doing appending writes. Are you -sure- you are
> > not doing appending writes?
> >
> This is weird. Yes, I'm sure. I use pwrite() to write data to a 4G file,
> and I check the offset of each write and they are always smaller than 4G.
> I instrument the code with systemtap and it shows me that ip->i_new_size
> and new_size in xfs_aio_write_newsize_update are both 0.
> Since in my case there is only overwrite, ip->i_new_size will always be 0
> (the only place that updates ip->i_new_size is xfs_file_aio_write_checks).
> Because of the same reason, new_size returned by xfs_file_aio_write_checks
> is always 0.
> Is it what you expected?

No idea. I don't know what the problem you are seeing is yet, or if
indeed there even is a problem as I don't really understand what you
are trying to do or what results you are expecting to see...

Indeed, have you run the test on something other than a RAM disk and
confirmed that the problem exists on a block device that has real IO
latency? If your IO takes close to zero time, then there isn't any
IO level concurrency you can extract from single file direct IO; it
will all just serialise on the extent tree lookups.

> > >  0xffffffff812829f4 : __xfs_get_blocks+0x94/0x4a0 [kernel]
> >
> > And for direct IO writes, this will be the block mapping lookup so
> > always hit.
> >
> >
> > What this says to me is that you are probably doing is lots of very
> > small concurrent write IOs, but I'm only guessing.  Can you provide
> > your test case and a description of your test hardware so we can try
> > to reproduce the problem?
> >
> I build XFS on the top of ramdisk. So yes, there is a lot of small
> concurrent writes in a second.
> I create a file of 4GB in XFS (the ramdisk has 5GB of space). My test
> program overwrites 4G of data to the file and each time writes a page of
> data randomly to the file. It's always overwriting, and no appending. The
> offset of each write is always aligned to the page size. There is no
> overlapping between writes.

Why are you using XFS for this? tmpfs was designed to do this sort
of stuff as efficiently as possible....

> So the test case is pretty simple and I think it's easy to reproduce it.
> It'll be great if you can try the test case.

Can you post your test code so I know what I test is exactly what
you are running?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
