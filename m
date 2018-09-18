Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbeIRKuZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 06:50:25 -0400
Date: Tue, 18 Sep 2018 13:20:27 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH V3 00/19] Fix tests to work on non-4k block sized fs
 instances
Message-ID: <20180918052027.GN8382@dhcp-12-152.nay.redhat.com>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Wed, Sep 12, 2018 at 11:56:07AM +0530, Chandan Rajendra wrote:
> This patchset fixes tests (mostly XFS specific ones) to work on
> variable block size. These patches now use the output of "od" utility
> to verify the contents of the test files instead of the md5sum
> utility.
> 
> Also, The patchset modifies _filter_fiemap() filter function to
> optionally print the file offset range in block size units.
> 
> Changelog:
> V2->V3:
> Added fixes for getting generic/018, generic/108 and generic/459 tests
> to work in 64k block size scenario.
> 
> V1->V2:
> Eryu Guan pointed out that some of the tests were obtaining the
> filesystem's block size value from $TEST_DIR even though the test was
> executed on the $SCRATCH_DEV's filesystem. This version of the
> patchset fixes the following tests to obtain the block size from
> $SCRATCH_MNT. The relevant changes was made to the following tests:
> xfs/009, xfs/050, xfs/074, xfs/139, xfs/140, xfs/190, xfs/299,
> generic/177 and generic/230.
> 
> Chandan Rajendra (19):
>   Fix xfs/009 to work with 64k block size
>   xfs/050: Fix "Push past soft inode limit" case
>   Fix xfs/050 to work with 64k block size
>   Fix xfs/074 to work with 64k block size
>   Fix xfs/127 to work with 64k block size
>   Fix xfs/139 to work with 64k block size
>   Fix xfs/140 to work with 64k block size
>   Fix xfs/190 to work with 64k block size
>   Fix xfs/299 to work with 64k block size
>   xfs/325: Inject free_extent error after CoW operation
>   Fix generic/102 to work with 64k block size
>   Fix generic/172 to work with 64k block size
>   Filter fiemap output by FS block size
>   Fix generic/177 to work with 64k block size
>   Fix generic/230 to work with 64k block size
>   Fix generic/235 to work with 64k block size
>   Fix generic/459 to work with 64k block size
>   Fix generic/018 to work with 64k block size
>   Fix generic/108 to work with 64k block size
> 
>  common/punch          | 19 ++++++++---
>  tests/generic/018     |  2 +-
>  tests/generic/102     |  4 +--
>  tests/generic/102.out | 20 +++++------
>  tests/generic/108     |  4 +--
>  tests/generic/172     |  4 +--
>  tests/generic/177     | 20 ++++++-----
>  tests/generic/177.out | 23 ++++++++-----
>  tests/generic/230     | 23 +++++++------
>  tests/generic/230.out | 16 ++++-----
>  tests/generic/235     |  2 +-
>  tests/generic/235.out |  4 +--
>  tests/generic/459     | 14 ++++----
>  tests/xfs/009         | 92 ++++++++++++++++++++++++++++++++++++++++++---------
>  tests/xfs/009.out     | 66 ++++++++++++++++++------------------
>  tests/xfs/050         | 26 ++++++++++-----
>  tests/xfs/050.out     | 60 ++++++++++++++++-----------------
>  tests/xfs/074         | 23 ++++++++++---
>  tests/xfs/127         |  2 +-
>  tests/xfs/139         | 15 +++++----
>  tests/xfs/139.out     |  8 +++--
>  tests/xfs/140         | 12 ++++---
>  tests/xfs/190         | 26 ++++++++++-----
>  tests/xfs/299         | 29 ++++++++++------
>  tests/xfs/299.out     | 60 ++++++++++++++++-----------------
>  tests/xfs/325         |  5 +--
>  tests/xfs/325.out     |  2 +-
>  27 files changed, 358 insertions(+), 223 deletions(-)
> 
> -- 

Hi,

For help, I've tested this patchset on ppc64le machine with 4.18 released kernel.
But only tested thoses cases which changed, 64k xfs/ext4 and 4k xfs/ext4 all
test passed, refer to [1], [2], [3], [4].

But I tested 512 block size (crc=0) XFS passingly, then hit a new failure:

# ./check xfs/050
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-16-lp5 4.18.0-xfs-debug                                            
MKFS_OPTIONS  -- -f -b size=512 -m crc=0 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda5 /mnt/xfstests/mnt2                      

xfs/050 18s ... - output mismatch (see /root/xfstests-patched/results//xfs/050.out.bad)
    --- tests/xfs/050.out       2018-09-17 05:56:47.738590176 -0400
    +++ /root/xfstests-patched/results//xfs/050.out.bad 2018-09-18 01:12:55.538747111 -0400
    @@ -12,23 +12,24 @@
     
     *** report initial settings
     [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
    -[NAME] 0 25 125 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
    +[NAME] 0 24 124 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
     
     *** push past the soft inode limit
    ...
    (Run 'diff -u tests/xfs/050.out /root/xfstests-patched/results//xfs/050.out.bad'  to see the entire diff)
Ran: xfs/050
Failures: xfs/050
Failed 1 of 1 tests

It test passed on xfstests which doesn't merged above patches:

# ./check xfs/050
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-16-lp5 4.18.0-xfs-debug
MKFS_OPTIONS  -- -f -b size=512 -m crc=0 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda5 /mnt/xfstests/mnt2

xfs/050 16s ...  16s
Ran: xfs/050
Passed all 1 tests

Thanks,
Zorro

[1] Ext4 test passed on 64k block size:
# ./check generic/018 generic/102 generic/108 generic/172 generic/177 generic/230 generic/235 generic/459
FSTYP         -- ext4
PLATFORM      -- Linux/ppc64le ibm-p9z-16-lp5 4.18.0-xfs-debug
MKFS_OPTIONS  -- -b 65536 /dev/sda5
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 /dev/sda5 /mnt/xfstests/mnt2

generic/018 7s ...  7s
generic/102 5s ...  44s
generic/108 9s ...  6s
generic/172 16s ... [not run] Reflink not supported by scratch filesystem type: ext4
generic/177 5s ...  5s
generic/230 19s ...  18s
generic/235 4s ...  5s
generic/459 26s ...  19s
Ran: generic/018 generic/102 generic/108 generic/172 generic/177 generic/230 generic/235 generic/459
Not run: generic/172
Passed all 8 tests

[2] XFS test passed on 64k block size:
# ./check generic/018 generic/102 generic/108 generic/172 generic/177  generic/230 generic/235 generic/459 xfs/009 xfs/050 xfs/074 xfs/127 xfs/139 xfs/140 xfs/190 xfs/299 xfs/325
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-16-lp5 4.18.0-xfs-debug
MKFS_OPTIONS  -- -f -b size=65536 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda5 /mnt/xfstests/mnt2

generic/018 5s ...  7s
generic/102 6s ...  5s
generic/108 16s ...  9s
generic/172 12s ...  16s
generic/177 14s ...  5s
generic/230 29s ...  19s
generic/235 5s ...  4s
generic/459 24s ...  26s
xfs/009 6s ...  6s
xfs/050 68s ...  34s
xfs/074 14s ...  7s
xfs/127 16s ...  25s
xfs/139 266s ...  33s
xfs/140 427s ...  90s
xfs/190 27s ...  7s
xfs/299 24s ...  20s
xfs/325 10s ...  9s
Ran: generic/018 generic/102 generic/108 generic/172 generic/177 generic/230 generic/235 generic/459 xfs/009 xfs/050 xfs/074 xfs/127 xfs/139 xfs/140 xfs/190 xfs/299 xfs/325
Passed all 17 tests

[3] Ext4 test passed on default block size
# ./check generic/018 generic/102 generic/108 generic/172 generic/177 generic/230 generic/235 generic/459
FSTYP         -- ext4
PLATFORM      -- Linux/ppc64le ibm-p9z-16-lp5 4.18.0-xfs-debug
MKFS_OPTIONS  -- /dev/sda5
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 /dev/sda5 /mnt/xfstests/mnt2

generic/018 7s ...  4s
generic/102 44s ...  52s
generic/108 6s ...  7s
generic/172 16s ... [not run] Reflink not supported by scratch filesystem type: ext4
generic/177 5s ...  3s
generic/230 18s ...  16s
generic/235 5s ...  2s
generic/459 19s ...  22s
Ran: generic/018 generic/102 generic/108 generic/172 generic/177 generic/230 generic/235 generic/459
Not run: generic/172
Passed all 8 tests

[4] XFS test passed on default block size
# ./check generic/018 generic/102 generic/108 generic/172 generic/177 generic/230 generic/235 generic/459 xfs/009 xfs/050 xfs/074 xfs/127 xfs/139 xfs/140 xfs/190 xfs/299 xfs/325
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-16-lp5 4.18.0-xfs-debug                                            
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda5 /mnt/xfstests/mnt2                      

generic/018 8s ...  5s
generic/102 70s ...  6s
generic/108 7s ...  7s
generic/172 16s ...  11s
generic/177 6s ...  4s
generic/230 18s ...  15s
generic/235 5s ...  3s
generic/459 21s ...  20s
xfs/009 6s ...  3s
xfs/050 34s ...  18s
xfs/074 7s ...  9s
xfs/127 25s ...  14s
xfs/139 33s ...  243s
xfs/140 90s ...  286s
xfs/190 7s ...  10s
xfs/299 20s ...  13s
xfs/325 9s ...  4s
Ran: generic/018 generic/102 generic/108 generic/172 generic/177 generic/230 generic/235 generic/459 xfs/009 xfs/050 xfs/074 xfs/127 xfs/139 xfs/140 xfs/190 xfs/299 xfs/325
Passed all 17 tests

> 2.9.5
> 
