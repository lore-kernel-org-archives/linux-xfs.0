Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A56777F5A
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 00:52:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21EC0AC003
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 22:52:10 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	efINkhrQL7WoWSDX for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 22:52:07 -0800 (PST)
Date: Thu, 3 Dec 2015 17:51:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest failure with xfs, dax and v4.4-rc3
Message-ID: <20151203065127.GB26718@dastard>
References: <20151201224346.GA15684@linux.intel.com>
	<20151201235158.GF19199@dastard>
	<x49k2owq3z6.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49k2owq3z6.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 10:12:29AM -0500, Jeff Moyer wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Tue, Dec 01, 2015 at 03:43:46PM -0700, Ross Zwisler wrote:
> >> I'm seeing a new intermittent xfstests failure with v4.4-rc3 using XFS and
> >> DAX.  The test that is failing is generic/083, and it fails about 50% of the
> >> time in my setup.  Here's the output:
> >> 
> >> FSTYP         -- xfs (debug)
> >> PLATFORM      -- Linux/x86_64 lorwyn 4.4.0-rc3
> >> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
> >> MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2
> >> /mnt/xfstests_scratch
> >> 
> >> generic/083 2s ... 2s
>    ^^^^^^^
> >> _check_xfs_filesystem: filesystem on /dev/pmem0p2 is inconsistent (r) (see
> >> /root/xfstests/results//generic/083.full)
> >> Ran: generic/083
> >> Failures: generic/083
> >> Failed 1 of 1 tests
> >
> > $ grep 083  tests/xfs/group
> > 083 dangerous_fuzzers
> > $
> 
> That's great, but Ross reported an issues with *generic*/083.  ;-)
> 
> /me hands Dave more coffee.

Ah, some days I need more coffee than others :/

As it is, that test does not fail on my DAX testing on RAM disks.
ISTR it failing up until recently, though. Yeah:

Last login: Tue Nov 17 08:45:55 2015 from 192.168.1.103
$ cd ~/src/xfstests-dev; sudo mkfs.xfs -f /dev/ram0 ; sudo xfs_admin -U generate /dev/ram0 ; sudo MOUNT_OPTIONS="-o dax" ./check -g auto
SECTION       -- xfs
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test4 4.3.0-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/ram1
MOUNT_OPTIONS -- -o dax /dev/ram1 /mnt/scratch
....
generic/083 2s ... 1s
_check_xfs_filesystem: filesystem on /dev/ram1 is inconsistent (c) (see /home/dave/src/xfstests-dev/results//xfs/generic/083.full)
_check_xfs_filesystem: filesystem on /dev/ram1 is inconsistent (r) (see /home/dave/src/xfstests-dev/results//xfs/generic/083.full)
....

But as I ran earlier today when testing the ENOSPC fix:

PLATFORM      -- Linux/x86_64 test4 4.4.0-rc2-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/ram1
MOUNT_OPTIONS -- -o dax /dev/ram1 /mnt/scratch
....
generic/083 1s ... 2s
....

So I'm seeing that the current 4.4-rc2 + my local dev tree patches
appear to have fixed whatever was causing generic/083 to fail
here...

What version of xfsprogs are you using, Ross?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
