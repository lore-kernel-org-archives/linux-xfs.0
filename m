Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D78BA7FF3
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 19:15:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53E50AC012
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 17:15:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xqT7oJoGRswaoD3d for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 17:15:00 -0700 (PDT)
Date: Tue, 8 Apr 2014 10:14:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfstests: updated to cf1ed54
Message-ID: <20140408001443.GG27017@dastard>
References: <20140404090357.GW17603@dastard>
	<CAL3q7H6q7M-hrvniaVkAm_L6aSHANmnfdTKGEHHLFqXUhWfY5w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL3q7H6q7M-hrvniaVkAm_L6aSHANmnfdTKGEHHLFqXUhWfY5w@mail.gmail.com>
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
To: Filipe David Manana <fdmanana@gmail.com>
Cc: linux-ext4@vger.kernel.org, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 04, 2014 at 02:07:16PM +0100, Filipe David Manana wrote:
> On Fri, Apr 4, 2014 at 10:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> > Hi folks,
> >
> > The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
> > just been updated. Patches often get missed, so please check if your
> > outstanding patches were in this update. If they have not been in
> > this update, please resubmit them to xfs@oss.sgi.com so they can be
> > picked up in the next update.
> >
> > The new head of the master branch is commit:
> >
> > cf1ed54 check: fix RESULT_BASE typo in check script
> >
> > The major new functionality worth mentioning in this update is the
> > new config file format from Lukas. The existing format config files
> > should continue to work without change, but the new format is much
> > richer and allows specification of multiple different configurations
> > to run test under. Hence testing multiple mount an dmkfs
> > configurations becomes as simple as iterating the configurations
> > in the config file.
> 
> Hi,
> 
> I might be missing something, but after checking out these changes, I
> am no longer able to run btrfs tests. Example:
> 
> $ ./check btrfs/041
> common/config: Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
> Passed all 0 tests
> 
> $ cat local.config
> export TEST_DEV=/dev/sdb
> export TEST_DIR=/home/fdmanana/btrfs-tests/dev
> export SCRATCH_MNT="/home/fdmanana/btrfs-tests/scratch_1"
> export SCRATCH_DEV_POOL="/dev/sdc /dev/sdd"

Are you sure that's the config file that is being picked up? I can't
test btrfs at the moment because it appears to be completely screwed
in a TOT kernel right now - it doesn't even show up in
/proc/filesystems and doesn't emit anything on dmesg to indicate
that initialisation of the built in btrfs code has failed or even
been attempted. It's simply MIA....

However, using that same SCRATCH_DEV_POOL config for xfs or ext4
works just fine on my test machines with the current TOT xfstests
and kernel code.

$ cat configs/test2.config 
TEST_DIR=/mnt/test
SCRATCH_MNT=/mnt/scratch
TEST_DEV=/dev/vda
SCRATCH_DEV_POOL="/dev/vdc /dev/vdd"
$ sudo MKFS_OPTIONS="-m crc=1" ./check generic/001
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test2 3.14.0-rc1-dgc+
MKFS_OPTIONS  -- -f -m crc=1 /dev/vdc
MOUNT_OPTIONS -- /dev/vdc /mnt/scratch

generic/001 4s ... 3s
Ran: generic/001
Passed all 1 tests
$

So, as you can see I can't reproduce your problem myself right now.
Could you add a "set -x" line to the start of check and post the
output?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
