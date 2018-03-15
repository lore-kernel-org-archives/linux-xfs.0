Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750720AbeCOGQC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 02:16:02 -0400
Date: Thu, 15 Mar 2018 07:15:57 +0100
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: XFS crash consistency bug : Loss of fsynced metadata operation
Message-ID: <20180315061557.5jajfodpkjdmcrld@rh_laptop>
References: <CA+EzBbCtp9wKC=KeN+N1iZDa2+TsWxVho3aUkeXJXguVswkChA@mail.gmail.com>
 <20180313042126.GB18129@dastard>
 <CA+EzBbC9yQyxqiPOTCymrbL=cW-KZq2b8hunf7KEpiNZ9f3s4Q@mail.gmail.com>
 <20180313224522.GZ7000@dastard>
 <20180314131659.wnmt5zxfhrfsld7n@rh_laptop>
 <20180314133258.GB7000@dastard>
 <20180314135752.5a2vmjr7cuavusiw@rh_laptop>
 <20180314212441.GC7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180314212441.GC7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>, linux-xfs@vger.kernel.org, Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Thu, Mar 15, 2018 at 08:24:41AM +1100, Dave Chinner wrote:
> On Wed, Mar 14, 2018 at 02:57:52PM +0100, Lukas Czerner wrote:
> > On Thu, Mar 15, 2018 at 12:32:58AM +1100, Dave Chinner wrote:
> > > On Wed, Mar 14, 2018 at 02:16:59PM +0100, Lukas Czerner wrote:
> > > > just FYI the 042 xfstest does fail on xfs with what I think is stale
> > > > data exposure. It might not be related at all to what crashmonkey is
> > > > reporting but there is something wrong nevertheless.
> > > 
> > > generic/042 is unreliable and certain operations result in a
> > > non-zero length file because of metadata commits/writeback that
> > > occur as a result of the fallocate operations. It got removed from
> > > the auto group because it isn't a reliable test about 3 years ago:
> > 
> > Sure, I just that it clearly exposes stale data on xfs. That is, the
> > resulting file contains data that was previously written to the
> > underlying image file to catch the exposure. I am aware of the non-zero
> > length file problem, that's not what I am pointing out though.
> 
> What setup are you testing on? I haven't seen it fail in some time.
> Here, on emulated pmem:

Virtual machine with Virtio devices backed by a linear lvs consisting of
SCSI drives, all local.

> 
> SECTION       -- xfs
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test4 4.16.0-rc5-dgc
> MKFS_OPTIONS  -- -f -m rmapbt=1,reflink=1 -i sparse=1 /dev/pmem1
> MOUNT_OPTIONS -- /dev/pmem1 /mnt/scratch
> 
> xfs/042 10s ... 14s

We are talking about generic/042. xfs/042 is very much a different
test.

SECTION       -- xfs
RECREATING    -- xfs on /dev/vdc1
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 rhel7 4.16.0-rc5+
MKFS_OPTIONS  -- -f -f /dev/vdb1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vdb1 /mnt/test1

generic/042	 - output mismatch (see /root/Projects/xfstests-dev/results//ext4/generic/042.out.bad)
    --- tests/generic/042.out	2018-03-14 05:56:38.619124060 -0400
    +++ /root/Projects/xfstests-dev/results//ext4/generic/042.out.bad	2018-03-15 02:15:02.872113819 -0400
    @@ -5,6 +5,16 @@
     fpunch
     wrote 65536/65536 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    +0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
    +*
    +000f000 0000 0000 0000 0000 0000 0000 0000 0000
    +*
    ...
    (Run 'diff -u tests/generic/042.out /root/Projects/xfstests-dev/results//ext4/generic/042.out.bad'  to see the entire diff)
xfs/042 15s ... 15s
Ran: generic/042 xfs/042
Failures: generic/042
Failed 1 of 2 tests


-Lukas

> Passed all 1 tests
> 
> SECTION       -- xfs
> =========================
> Passed all 1 tests
> 
> And on a different machine, with iSCSI devices and a slightly older
> kernel:
> 
> SECTION       -- xfs
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test2 4.16.0-rc2-dgc
> MKFS_OPTIONS  -- -f -m rmapbt=1,reflink=1 -i sparse=1 /dev/sdg
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdg /mnt/scratch
> 
> xfs/042 14s ... 14s
> Passed all 1 tests
> 
> SECTION       -- xfs
> =========================
> Passed all 1 tests
> 
> It passes just fine.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
