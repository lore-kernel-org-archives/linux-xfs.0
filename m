Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A5AB7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 05:48:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EA650AC004
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:48:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Jap3lAZxdaAUnPLC for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:48:52 -0800 (PST)
Date: Thu, 27 Feb 2014 12:48:46 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
	range
In-Reply-To: <20140226221757.GD29907@dastard>
Message-ID: <alpine.LFD.2.00.1402271244330.2247@localhost.localdomain>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-6-git-send-email-lczerner@redhat.com>
	<20140225205349.GD13647@dastard>
	<alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
	<20140225215011.GF13647@dastard>
	<alpine.LFD.2.00.1402261537040.2243@localhost.localdomain>
	<20140226221757.GD29907@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-108984919-1393501728=:2247"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-108984919-1393501728=:2247
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Feb 2014, Dave Chinner wrote:

> Date: Thu, 27 Feb 2014 09:17:57 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
>     range
> 
> On Wed, Feb 26, 2014 at 03:58:36PM +0100, Lukáš Czerner wrote:
> > On Wed, 26 Feb 2014, Dave Chinner wrote:
> > > > Currently xfs/242 fails on xfs for me
> > > 
> > > Really? Where's the bug report? I haven't seen a failure on xfs/242
> > > on any of my test machines for at least a year, even on 1k block
> > > size filesystems...
> > > 
> > > $ sudo ./check xfs/242
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 test2 3.14.0-rc3-dgc+
> > > MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> > > MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> > > 
> > > xfs/242 1s ... 0s
> > > Ran: xfs/242
> > > Passed all 1 tests
> > > $
> > 
> > Ok so once again. Yesterday was rally too late and I've
> > misinterpreted the diff. It's not that xfs behaves differently, but
> > rather ext4 behaves differently because we in fact have a code that
> > will zero out entire unwritten extent if it's small enough rather
> > than split it into unwritten and written.
> 
> Yes, we've come across this before, and there are several solutions.
> this one is used in tests/generic/285:
> 
> # Disable extent zeroing for ext4 as that change where holes ar created
> if [ "$FSTYP" = "ext4" ]; then
> 	DEV=`basename $TEST_DEV`
> 	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
> fi

When testing SEEK_DATA, SEEK_HOLE this is probably just fine. But
when it comes to actually changing the extent tree and checking the
result I would rather not disable this because it is the default and
we want to test that code as well.

> 
> > > > and it does behave differently than ext4.
> > > 
> > > In what way? Does FALLOC_FL_ZERO_RANGE on XFS behave identically to
> > > XFS_IOC_ZERO_RANGE, or is that different too? Or you haven't tested
> > > it because you wrote this test as an ext4 specific test and so
> > > haven't run this specific test exercising the FALLOC_FL_ZERO_RANGE
> > > path in XFS?
> > 
> > It does behave differently, but not because of zero_range code, but
> > rather when writing into uninitialized extent which is small enough.
> > The extent will not be split but rather converted to initialized and
> > respective parts will be zeroed out.
> > 
> > Btw that's actually the reason why we use
> > 
> > _filter_hole_fiemap
> > 
> > filtes instead of
> > 
> > _filter_fiemap
> > 
> > I've used in ext4/242.
> 
> Sure, but even so I think we might do better just to use the above
> zeroout tune and be explicit in what we expect to happen w.r.t. data
> vs holes...
> 
> > 
> > That said I think that both tests fs specific and fs independent
> > have it's value so I'll create generic/242 as well by using
> > _filter_hole_fiemap.
> 
> Just use the first unused generic test number - trying to keep test
> numbers the same across different subdirs is just going to cause
> confusion....

Ok.

Thanks!
-Lukas

> 
> > > hole punching - the only difference between a hole punch and a zero
> > > range on filesystems that use unwritten extents should be that the
> > > range being operated on has unwritten extents rather a hole.....
> > > 
> > > > Btw this kind of optimization is actually something I've been
> > > > thinking of as well for ext4. Rather than going though the hassle of
> > > > changing extents around it might be worth in some situation to zero
> > > > out. But that's an optimization I have not implemented yet.
> > > 
> > > Exactly my point - until such optimisations are implemented, all the
> > > filesystems should be behaving the same way using unwritten extents,
> > > just like for hole punching. Hence the tests should be checking that
> > > the behaviour is the same across filesystems, just like we do for
> > > hole punching.
> > 
> > Using _filter_hole_fiemap filter in such test we would not make a
> > difference between unwritten and written extent. However in the case
> > of zero_range this somewhat make the test much less effective so
> > it'll be worth having fs specific test as well as generic test I
> > said above.
> > 
> > Or we could actually directly inspect the data as we do in xfs/290, or
> > generic/290 respectively.
> 
> The md5sum does the data inspection for us. The whole point of
> hole punch and zero range and so one is that they are extent
> manipulation operations. If we don't check that extents have been
> manipulated correctly, then we aren't testing that the key behaviour
> the filesystems are supposed to display for those operations....
> 
> Cheers,
> 
> Dave.
> 
--8323328-108984919-1393501728=:2247
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-108984919-1393501728=:2247--
