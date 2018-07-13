Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732923AbeGMCzu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jul 2018 22:55:50 -0400
MIME-Version: 1.0
From: "Luis R. Chamberlain" <mcgrof@kernel.org>
Date: Thu, 12 Jul 2018 19:43:08 -0700
Message-ID: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
Subject: [ANN] oscheck: wrapper for fstests check.sh - tracking and working
 with baselines
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>, "Luis R. Chamberlain" <mcgrof@kernel.org>

I had volunteered at the last LSF/MM to help with the stable work for
XFS. To help with this, as part of this year's SUSE Hackweek, I've
first generalized my own set of scripts to help track a baseline of
results from fstests [0], and extended it to be able to easily ramp up
with fstests on different distributions, and I've also created a
respective baseline of results against these distributions as a
further example of how these scripts and wrapper framework can be used
[1]. The distributions currently supported are:

  * Debian testing
  * OpenSUSE Leap 15.0
  * Fedora 28

The stable work starts with creating a baseline for v4.17.3. The
results are visible as a result of expunge files which categorize the
failures for the different sections tested. Other than careful manual
inspection of each stable candidate patch, one of the goals will also
be to ensure such stable patches do not regress the baseline. Work is
currently underway to review the first set of stable candidate patches
for v4.17.3, if they both pass review and do not regress the
established baseline, I'll proceed to post the patches for further
evaluation from the community.

Note that while I used this for XFS, it should be easy to add support
for other filesystems, should folks wish to do something similar for
their filesystems. The current XFS sections being tested are as
follows, please let me know if we should consider extending this
further:

# Matches what we expect to be default on the latests xfsprogs
[xfs]
MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0'
USE_EXTERNAL=no
FSTYP=xfs

[xfs_reflink]
MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1,'
USE_EXTERNAL=no
FSTYP=xfs

[xfs_reflink_1024]
MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=1024,'
USE_EXTERNAL=no
FSTYP=xfs

# For older kernels when we didn't have crc
[xfs_nocrc]
MKFS_OPTIONS='-f -m crc=0,reflink=0,rmapbt=0, -i sparse=0,'
USE_EXTERNAL=no
FSTYP=xfs

[xfs_nocrc_512]
MKFS_OPTIONS='-f -m crc=0,reflink=0,rmapbt=0, -i sparse=0, -b size=512,'
USE_EXTERNAL=no
FSTYP=xfs

# Latest defaults with an external log
[xfs_logdev]
MKFS_OPTIONS="-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0 -lsize=1g"
SCRATCH_LOGDEV=/dev/loop15
USE_EXTERNAL=yes
FSTYP=xfs

# Requires CONFIG_XFS_RT which most distros disable now
[xfs_realtimedev]
MKFS_OPTIONS="-f -lsize=1g"
SCRATCH_LOGDEV=/dev/loop15
SCRATCH_RTDEV=/dev/loop14
USE_EXTERNAL=yes
FSTYP=xfs

There are notes about possible issue with tests and diffs when using
an external log on the respective expunge files for the section, so
section xfs_logdev, and xfs_realtimedev likely have a slew of failures
due to unexpected test results.

Also worth noting is that out of the distributions tested only Debian
currently still enables CONFIG_XFS_RT, so it may be worth for Debian
to consider disabling it as well. Its really unclear exactly who cares
about this still and who's really testing CONFIG_XFS_RT anymore.

To be clear the results are not in yet for the v4.17.3 work, this is
just the framework which I'll use to next address that. Expect more
updates on that later once the results and final review is in.

I'm also pushing tests now also to track the baseline for vanilla
linux and linux-net.

If there are any questions please let me know.

[0] git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
[1] https://gitlab.com/mcgrof/oscheck

  Luis
