Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6B607F56
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 08:24:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FF58304081
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 06:24:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 63HlfgHY08wdSasn for
	<xfs@oss.sgi.com>; Wed, 26 Feb 2014 06:24:30 -0800 (PST)
Date: Wed, 26 Feb 2014 15:24:18 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
	range
In-Reply-To: <20140225215011.GF13647@dastard>
Message-ID: <alpine.LFD.2.00.1402261520070.2243@localhost.localdomain>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-6-git-send-email-lczerner@redhat.com>
	<20140225205349.GD13647@dastard>
	<alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
	<20140225215011.GF13647@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1156906821-1393424660=:2243"
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

--8323328-1156906821-1393424660=:2243
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

Here it is.

xfs/242 fails on ppc64 with latest linus tree

# uname -a
Linux ibm-p740-01-lp4.rhts.eng.bos.redhat.com 3.14.0-rc4+ #1 SMP Wed
Feb 26 08:59:48 EST 2014 ppc64 ppc64 ppc64 GNU/Linux

# ./check xfs/242
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/ppc64 ibm-p740-01-lp4 3.14.0-rc4+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/test2

xfs/242  - output mismatch (see /root/xfstests/results//xfs/242.out.bad)
    --- tests/xfs/242.out       2014-02-26 05:51:16.602579462 -0500
    +++ /root/xfstests/results//xfs/242.out.bad 2014-02-26 09:20:55.585396040 -0500
    @@ -1,76 +1,71 @@
     QA output created by 242
        1. into a hole
     0: [0..7]: hole
    -1: [8..23]: unwritten
    +1: [8..23]: data
     2: [24..39]: hole
     daa100df6e6711906b61c9ab5aa16032
    ...
    (Run 'diff -u tests/xfs/242.out /root/xfstests/results//xfs/242.out.bad'  to see the entire diff)
Ran: xfs/242
Failures: xfs/242
Failed 1 of 1 tests


Here is 242.out.bad

QA output created by 242
	1. into a hole
0: [0..7]: hole
1: [8..23]: data
2: [24..39]: hole
daa100df6e6711906b61c9ab5aa16032
	2. into allocated space
0: [0..39]: data
cc58a7417c2d7763adc45b6fcd3fa024
	3. into unwritten space
0: [0..39]: unwritten
daa100df6e6711906b61c9ab5aa16032
	4. hole -> data
0: [0..7]: hole
1: [8..31]: data
2: [32..39]: hole
cc63069677939f69a6e8f68cae6a6dac
	5. hole -> unwritten
0: [0..7]: hole
1: [8..23]: data
2: [24..31]: unwritten
3: [32..39]: hole
daa100df6e6711906b61c9ab5aa16032
	6. data -> hole
0: [0..23]: data
1: [24..39]: hole
1b3779878366498b28c702ef88c4a773
	7. data -> unwritten
0: [0..15]: data
1: [16..31]: unwritten
2: [32..39]: hole
1b3779878366498b28c702ef88c4a773
	8. unwritten -> hole
0: [0..7]: unwritten
1: [8..23]: data
2: [24..39]: hole
daa100df6e6711906b61c9ab5aa16032
	9. unwritten -> data
0: [0..15]: unwritten
1: [16..31]: data
2: [32..39]: hole
cc63069677939f69a6e8f68cae6a6dac
	10. hole -> data -> hole
0: [0..7]: hole
1: [8..31]: data
2: [32..39]: hole
daa100df6e6711906b61c9ab5aa16032
	11. data -> hole -> data
0: [0..39]: data
f6aeca13ec49e5b266cd1c913cd726e3
	12. unwritten -> data -> unwritten
0: [0..15]: unwritten
1: [16..23]: data
2: [24..39]: unwritten
daa100df6e6711906b61c9ab5aa16032
	13. data -> unwritten -> data
0: [0..7]: data
1: [8..23]: unwritten
2: [24..39]: data
f6aeca13ec49e5b266cd1c913cd726e3
	14. data -> hole @ EOF
0: [0..39]: data
e1f024eedd27ea6b1c3e9b841c850404
	15. data -> hole @ 0
0: [0..39]: data
eecb7aa303d121835de05028751d301c
	16. data -> cache cold ->hole
0: [0..39]: data
eecb7aa303d121835de05028751d301c
	17. data -> hole in single block file
0: [0..7]: data
0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0000200 0000 0000 0000 0000 0000 0000 0000 0000
*
0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
--8323328-1156906821-1393424660=:2243
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1156906821-1393424660=:2243--
