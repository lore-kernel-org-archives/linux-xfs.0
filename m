Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C0C317FCD
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 08:07:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 699B7AC00E
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 06:07:20 -0700 (PDT)
Received: from mail-lb0-f169.google.com (mail-lb0-f169.google.com
	[209.85.217.169]) by cuda.sgi.com with ESMTP id
	f9nx9KQzZnPMWQet (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Apr 2014 06:07:18 -0700 (PDT)
Received: by mail-lb0-f169.google.com with SMTP id q8so2488313lbi.0
	for <xfs@oss.sgi.com>; Fri, 04 Apr 2014 06:07:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140404090357.GW17603@dastard>
References: <20140404090357.GW17603@dastard>
Date: Fri, 4 Apr 2014 14:07:16 +0100
Message-ID: <CAL3q7H6q7M-hrvniaVkAm_L6aSHANmnfdTKGEHHLFqXUhWfY5w@mail.gmail.com>
Subject: Re: [ANNOUNCE] xfstests: updated to cf1ed54
From: Filipe David Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 4, 2014 at 10:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> Hi folks,
>
> The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
> just been updated. Patches often get missed, so please check if your
> outstanding patches were in this update. If they have not been in
> this update, please resubmit them to xfs@oss.sgi.com so they can be
> picked up in the next update.
>
> The new head of the master branch is commit:
>
> cf1ed54 check: fix RESULT_BASE typo in check script
>
> The major new functionality worth mentioning in this update is the
> new config file format from Lukas. The existing format config files
> should continue to work without change, but the new format is much
> richer and allows specification of multiple different configurations
> to run test under. Hence testing multiple mount an dmkfs
> configurations becomes as simple as iterating the configurations
> in the config file.

Hi,

I might be missing something, but after checking out these changes, I
am no longer able to run btrfs tests. Example:

$ ./check btrfs/041
common/config: Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
Passed all 0 tests

$ cat local.config
export TEST_DEV=/dev/sdb
export TEST_DIR=/home/fdmanana/btrfs-tests/dev
export SCRATCH_MNT="/home/fdmanana/btrfs-tests/scratch_1"
export SCRATCH_DEV_POOL="/dev/sdc /dev/sdd"

I did check too that my shell environment didn't define/export SCRATCH_DEV.
Going back to revision 3948694eb12e9699f558fab5e8169a8b090780d1, using
the same exact config, it works.

Do I need to adjust something in my config or is it a regression?

thanks


>
> New Commits:
>
> Christoph Hellwig (2):
>       [feb7da1] common: add flink support to _require_xfs_io_command
>       [3bbbc25] generic: add a basic O_TMPFILE test
>
> Eric Sandeen (1):
>       [cf1ed54] check: fix RESULT_BASE typo in check script
>
> Eryu Guan (1):
>       [dadfd3c] shared: new test to use up free inodes
>
> Filipe David Borba Manana (3):
>       [bb2499e] btrfs: add test for btrfs send issuing premature rmdir operations
>       [c99c847] btrfs: add test for btrfs incremental send
>       [e0ff31a] btrfs: add test for btrfs incremental send data corruption
>
> Filipe Manana (1):
>       [1a87439] btrfs: add test for btrfs send directory moves/renames
>
> Hannes Frederic Sowa (1):
>       [947ee8b] fs: add directories hash collision test
>
> Lukas Czerner (10):
>       [4d18f5a] generic: add generic test for fallocate zero range
>       [bf44459] check: Prepare for config section
>       [667308d] check: Add support for sections in config file
>       [f8e4f53] check: Allow to recreate TEST_DEV
>       [b1ffb05] check: Remount file system if MOUNT_OPTIONS changed
>       [7baa3e2] check: unmount TEST_DEV and SCRATCH_DEV after test run
>       [21723cd] generic: Make some shared tests generic
>       [259d680] ext4: Make shared/243 ext4 specific
>       [5f8c711] fsx: Add fallocate collapse range operation
>       [f98d930] fsstress: Add fallocate collapse range operation
>
>
> Code Diffstat:
>
>  .gitignore                                |   1 +
>  README.config-sections                    |  87 +++++++
>  check                                     | 404 ++++++++++++++++++------------
>  common/config                             | 155 +++++++++++-
>  common/rc                                 |  30 ++-
>  ltp/fsstress.c                            |  20 ++
>  ltp/fsx.c                                 | 107 +++++++-
>  src/Makefile                              |   2 +-
>  src/dirhash_collide.c                     | 223 +++++++++++++++++
>  tests/btrfs/043                           | 149 +++++++++++
>  tests/btrfs/043.out                       |   1 +
>  tests/btrfs/044                           | 129 ++++++++++
>  tests/btrfs/044.out                       |   1 +
>  tests/btrfs/045                           | 376 +++++++++++++++++++++++++++
>  tests/btrfs/045.out                       |   1 +
>  tests/btrfs/046                           | 304 ++++++++++++++++++++++
>  tests/btrfs/046.out                       | 213 ++++++++++++++++
>  tests/btrfs/group                         |   4 +
>  tests/{shared/243 => ext4/002}            |   4 +-
>  tests/{shared/243.out => ext4/002.out}    |   2 +-
>  tests/ext4/group                          |   1 +
>  tests/generic/004                         |  65 +++++
>  tests/generic/004.out                     |   6 +
>  tests/generic/009                         |  78 ++++++
>  tests/generic/009.out                     | 333 ++++++++++++++++++++++++
>  tests/{shared/003 => generic/012}         |   6 +-
>  tests/{shared/003.out => generic/012.out} |   2 +-
>  tests/{shared/004 => generic/016}         |   6 +-
>  tests/{shared/004.out => generic/016.out} |   2 +-
>  tests/{shared/005 => generic/017}         |   4 +-
>  tests/generic/017.out                     |   4 +
>  tests/{shared/218 => generic/018}         |   4 +-
>  tests/{shared/218.out => generic/018.out} |   2 +-
>  tests/{shared/305 => generic/019}         |   4 +-
>  tests/{shared/305.out => generic/019.out} |   2 +-
>  tests/{shared/001 => generic/021}         |   6 +-
>  tests/{shared/001.out => generic/021.out} |   2 +-
>  tests/{shared/002 => generic/022}         |   6 +-
>  tests/{shared/002.out => generic/022.out} |   2 +-
>  tests/generic/group                       |   9 +
>  tests/shared/005.out                      |   4 -
>  tests/shared/006                          |  97 +++++++
>  tests/shared/006.out                      |   2 +
>  tests/shared/group                        |  10 +-
>  tests/xfs/006                             |  63 +++++
>  tests/xfs/006.out                         |  28 +++
>  tests/xfs/group                           |   1 +
>  47 files changed, 2746 insertions(+), 216 deletions(-)
>  create mode 100644 README.config-sections
>  create mode 100644 src/dirhash_collide.c
>  create mode 100644 tests/btrfs/043
>  create mode 100644 tests/btrfs/043.out
>  create mode 100644 tests/btrfs/044
>  create mode 100644 tests/btrfs/044.out
>  create mode 100755 tests/btrfs/045
>  create mode 100644 tests/btrfs/045.out
>  create mode 100644 tests/btrfs/046
>  create mode 100644 tests/btrfs/046.out
>  rename tests/{shared/243 => ext4/002} (99%)
>  rename tests/{shared/243.out => ext4/002.out} (95%)
>  create mode 100755 tests/generic/004
>  create mode 100644 tests/generic/004.out
>  create mode 100644 tests/generic/009
>  create mode 100644 tests/generic/009.out
>  rename tests/{shared/003 => generic/012} (93%)
>  mode change 100644 => 100755
>  rename tests/{shared/003.out => generic/012.out} (97%)
>  rename tests/{shared/004 => generic/016} (93%)
>  mode change 100644 => 100755
>  rename tests/{shared/004.out => generic/016.out} (97%)
>  rename tests/{shared/005 => generic/017} (97%)
>  mode change 100644 => 100755
>  create mode 100644 tests/generic/017.out
>  rename tests/{shared/218 => generic/018} (98%)
>  rename tests/{shared/218.out => generic/018.out} (93%)
>  rename tests/{shared/305 => generic/019} (98%)
>  rename tests/{shared/305.out => generic/019.out} (88%)
>  rename tests/{shared/001 => generic/021} (93%)
>  rename tests/{shared/001.out => generic/021.out} (97%)
>  rename tests/{shared/002 => generic/022} (93%)
>  mode change 100644 => 100755
>  rename tests/{shared/002.out => generic/022.out} (97%)
>  delete mode 100644 tests/shared/005.out
>  create mode 100755 tests/shared/006
>  create mode 100644 tests/shared/006.out
>  create mode 100755 tests/xfs/006
>  create mode 100644 tests/xfs/006.out
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
