Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A14657F4E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 19:49:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 882EB304032
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 17:49:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	b9tO0J02grIZ9pa5 for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 17:49:43 -0700 (PDT)
Date: Mon, 14 Apr 2014 10:49:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to 249cc51
Message-ID: <20140414004938.GE27694@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

This update includes tests for the new renameat2 syscall, and a
bunch of fixes for the new config file format infrastructure.

The new head of the master branch is commit:

249cc51 generic: add renameat2 system call number for i386

New Commits:

Alexander Tsvetkov (1):
      [7e07c4b] generic/204: correct log size for XFS

Eric Whitney (2):
      [2e9061f] generic/300: add fallocate() checks
      [f729616] generic/311: add fallocate() check

Eryu Guan (1):
      [9f1a8e7] ext4/306: disable 64bit feature too

Lukas Czerner (6):
      [f00a444] config: Fix SCRATCH_DEV_POOL handling
      [7407717] config: Unset SCRATCH_DEV when deduced from SCRATCH_DEV_POOL
      [e0f5daf] config: Fix setting FSTYP automatically
      [5138e74] config: fix specifying configuration value with equality sign
      [ed6d096] generic/022: Fix output file
      [a0e2d8e] config: Add -s option to run only specified sections

Miklos Szeredi (4):
      [413f501] common: add infrastructure for renameat2 syscall tests
      [bdf2150] generic: check plain renameat2 syscall
      [1f98dd0] generic: check noreplace renameat2 syscall
      [3c9cd13] generic: check cross renameat2 syscall

Theodore Ts'o (2):
      [dd8556c] generic/004: fix filtering of expected error message
      [249cc51] generic: add renameat2 system call number for i386

Wanlong Gao (1):
      [610e44c] check: fix wallclock wrapping problem


Code Diffstat:

 .gitignore             |   1 +
 README.config-sections |  30 ++++++++++++
 check                  |  26 ++++++----
 common/config          |  35 +++++++++++---
 common/renameat2       | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac           |   2 +
 src/Makefile           |   3 +-
 src/renameat2.c        | 106 ++++++++++++++++++++++++++++++++++++++++
 tests/ext4/306         |   2 +-
 tests/generic/004      |   2 +-
 tests/generic/004.out  |   2 +-
 tests/generic/022.out  |   2 +-
 tests/generic/023      |  57 ++++++++++++++++++++++
 tests/generic/023.out  |  51 +++++++++++++++++++
 tests/generic/024      |  64 ++++++++++++++++++++++++
 tests/generic/024.out  |  51 +++++++++++++++++++
 tests/generic/025      |  64 ++++++++++++++++++++++++
 tests/generic/025.out  |  51 +++++++++++++++++++
 tests/generic/204      |   4 +-
 tests/generic/300      |   7 +++
 tests/generic/311      |   6 ++-
 tests/generic/group    |   3 ++
 22 files changed, 672 insertions(+), 26 deletions(-)
 create mode 100644 common/renameat2
 create mode 100644 src/renameat2.c
 create mode 100755 tests/generic/023
 create mode 100644 tests/generic/023.out
 create mode 100755 tests/generic/024
 create mode 100644 tests/generic/024.out
 create mode 100755 tests/generic/025
 create mode 100644 tests/generic/025.out
 mode change 100644 => 100755 tests/generic/311
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
