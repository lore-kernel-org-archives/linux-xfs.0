Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7EB6D7F51
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 08:58:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0CDF730406A
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 06:58:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vX26HNepcueeJjmG for
	<xfs@oss.sgi.com>; Wed, 26 Feb 2014 06:58:42 -0800 (PST)
Date: Wed, 26 Feb 2014 15:58:36 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
	range
In-Reply-To: <20140225215011.GF13647@dastard>
Message-ID: <alpine.LFD.2.00.1402261537040.2243@localhost.localdomain>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-6-git-send-email-lczerner@redhat.com>
	<20140225205349.GD13647@dastard>
	<alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
	<20140225215011.GF13647@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1831270982-1393426718=:2243"
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

--8323328-1831270982-1393426718=:2243
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 26 Feb 2014, Dave Chinner wrote:

> Date: Wed, 26 Feb 2014 08:50:11 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
>     range
> 
> On Tue, Feb 25, 2014 at 10:01:06PM +0100, Lukáš Czerner wrote:
> > On Wed, 26 Feb 2014, Dave Chinner wrote:
> > 
> > > Date: Wed, 26 Feb 2014 07:53:49 +1100
> > > From: Dave Chinner <david@fromorbit.com>
> > > To: Lukas Czerner <lczerner@redhat.com>
> > > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> > > Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
> > >     range
> > > 
> > > On Tue, Feb 25, 2014 at 08:15:28PM +0100, Lukas Czerner wrote:
> > > > This is copy of xfs/242. However it's better to make it file system
> > > > specific because the range can be zeroes either directly by writing
> > > > zeroes, or converting to unwritten extent, so the actual result might
> > > > differ from file system to file system.
> > > 
> > > You could say the same thing about preallocation using unwritten
> > > extents. Yet, funnily enough, we have generic tests for them because
> > > all filesystems currently use unwritten extents for preallocation
> > > and behave identically....
> > > 
> > > This test is no different - all filesystems currently use unwritten
> > > extents, and so this test should be generic because all existing
> > > filesystems *should* behave the same.
> > > 
> > > When we get a filesystem that zeros rather uses unwritten extents,
> > > we can add a new *generic* test that tests for zeroed data extents
> > > rather than unwritten extents. All that we will need is a method of
> > > checking what behaviour the filesystem has and adding that to a
> > > _requires directive to ensure the correct generic fallocate tests
> > > are run...
> > 
> > Currently xfs/242 fails on xfs for me
> 
> Really? Where's the bug report? I haven't seen a failure on xfs/242
> on any of my test machines for at least a year, even on 1k block
> size filesystems...
> 
> $ sudo ./check xfs/242
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test2 3.14.0-rc3-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> 
> xfs/242 1s ... 0s
> Ran: xfs/242
> Passed all 1 tests
> $

Ok so once again. Yesterday was rally too late and I've
misinterpreted the diff. It's not that xfs behaves differently, but
rather ext4 behaves differently because we in fact have a code that
will zero out entire unwritten extent if it's small enough rather
than split it into unwritten and written.

What we currently do not have is the zeroout of part of initialized
extent on zero_range when the range to zero out is small enough. And
ext4 behaves the same on the edges of the range as you describe
below.

Also xfs/242 fails for me on ppc64 but I've already sent that
report.

> 
> 
> > and it does behave differently than ext4.
> 
> In what way? Does FALLOC_FL_ZERO_RANGE on XFS behave identically to
> XFS_IOC_ZERO_RANGE, or is that different too? Or you haven't tested
> it because you wrote this test as an ext4 specific test and so
> haven't run this specific test exercising the FALLOC_FL_ZERO_RANGE
> path in XFS?

It does behave differently, but not because of zero_range code, but
rather when writing into uninitialized extent which is small enough.
The extent will not be split but rather converted to initialized and
respective parts will be zeroed out.

Btw that's actually the reason why we use

_filter_hole_fiemap

filtes instead of

_filter_fiemap

I've used in ext4/242.

That said I think that both tests fs specific and fs independent
have it's value so I'll create generic/242 as well by using
_filter_hole_fiemap.

And yes, I tested xfs with fzero and it does behave the same as
XFS_IOC_ZERO_RANGE.

> 
> IOWs, how do you know that what you are seeing is not a bug in the
> ext4 (or XFS for that matter) implementation?
> 
> > Also I had to change to 242.out a bit because ext4 was
> > a little different. It seems to me that it was expected that when
> > the extent is small enough it would be overwritten by zeroes rather
> > than converted to unwritten, but I have not looked into
> > implementation.
> 
> The test assumes that sub-block head and tail ranges will be zeroed,
> and everything else will be converted to unwritten extents. i.e. a
> single block aligned range will get converted to unwritten, but a
> single unaligned block range will result in the two overlapping
> blocks being zeroed (because they still contain valid data).

As I said above the difference in ext4 is that we're trying to avoid
extent split when the extent is too small. But that's no different
in punch hole testing, that's why we're using _filter_hole_fiemap
filter in generic/255.

> 
> This is the same sub-block zeroing behaviour as is done for
> hole punching - the only difference between a hole punch and a zero
> range on filesystems that use unwritten extents should be that the
> range being operated on has unwritten extents rather a hole.....
> 
> > Btw this kind of optimization is actually something I've been
> > thinking of as well for ext4. Rather than going though the hassle of
> > changing extents around it might be worth in some situation to zero
> > out. But that's an optimization I have not implemented yet.
> 
> Exactly my point - until such optimisations are implemented, all the
> filesystems should be behaving the same way using unwritten extents,
> just like for hole punching. Hence the tests should be checking that
> the behaviour is the same across filesystems, just like we do for
> hole punching.

Using _filter_hole_fiemap filter in such test we would not make a
difference between unwritten and written extent. However in the case
of zero_range this somewhat make the test much less effective so
it'll be worth having fs specific test as well as generic test I
said above.

Or we could actually directly inspect the data as we do in xfs/290, or
generic/290 respectively.

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 
--8323328-1831270982-1393426718=:2243
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1831270982-1393426718=:2243--
