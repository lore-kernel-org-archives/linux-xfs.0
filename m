Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF72E7F37
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 00:30:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A54C38F8033
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 22:30:56 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	YR13hsAChCmANwsA for <xfs@oss.sgi.com>;
	Mon, 09 Nov 2015 22:30:51 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Zw2RJ-0007Js-MZ
	for xfs@oss.sgi.com; Tue, 10 Nov 2015 17:29:57 +1100
Date: Tue, 10 Nov 2015 17:29:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsdump: v3.1.6 released
Message-ID: <20151110062957.GE14311@dastard>
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

Hi folks,

The xfsdump repositories have just been updated and tagged with the
v3.1.6 release tag. This is an update to fix the building of the
xfsdump package on systems that have xfsprogs 4.2.0 or later
installed on them.

The source code can be found in these git repositories:

git://oss.sgi.com/xfs/cmds/xfsdump v3.1.6
git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git v3.1.6

A signed gzipped-tar archive of the source code is available
here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.6.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.6.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

-Dave.

The new head of the master branch is commit:

f2a518a xfsdump: Release v3.1.6

New Commits:

Dave Chinner (9):
      [9d8bde8] cleanup: get rid of ASSERT
      [ff46015] build: don't rely on xfs/xfs.h to include necessary headers
      [3518475] cleanup: kill intgen_t
      [508ae35] cleanup: kill u_int*_t types
      [86252eb] cleanup: define a local xfs_ino_t
      [6fad1f8] cleanup: use system uuid.h headers
      [2f529f0] cleanup: move fold_t out of util.h
      [65c91e1] cleanup: Kill unnecessary xfs includes
      [f2a518a] xfsdump: Release v3.1.6


Code Diffstat:

 VERSION                 |   2 +-
 common/arch_xlate.c     |   8 +-
 common/arch_xlate.h     |   4 +-
 common/cldmgr.c         |  24 +-
 common/cldmgr.h         |   2 +-
 common/cleanup.c        |   7 +-
 common/content.h        |   8 +-
 common/content_common.c |  23 +-
 common/content_inode.h  |  78 +++---
 common/dlog.c           |  27 +-
 common/dlog.h           |   2 +-
 common/drive.c          |  33 +--
 common/drive.h          |  48 ++--
 common/drive_minrmt.c   | 654 +++++++++++++++++++++++------------------------
 common/drive_scsitape.c | 662 ++++++++++++++++++++++++------------------------
 common/drive_simple.c   | 246 +++++++++---------
 common/exit.h           |   2 +-
 common/fs.c             |  43 ++--
 common/fs.h             |   8 +-
 common/global.c         |  49 ++--
 common/global.h         |  10 +-
 common/hsmapi.c         |  26 +-
 common/hsmapi.h         |  16 +-
 common/inventory.c      |  42 +--
 common/inventory.h      |   6 +-
 common/lock.c           |   7 +-
 common/main.c           | 183 ++++++-------
 common/media.c          |  28 +-
 common/media.h          |  10 +-
 common/mlog.c           | 113 ++++++---
 common/mlog.h           |  22 +-
 common/openutil.c       |  39 +--
 common/openutil.h       |  14 +-
 common/path.c           |  32 ++-
 common/qlock.c          |  51 ++--
 common/rec_hdr.h        |   4 +-
 common/ring.c           |  74 +++---
 common/ring.h           |   4 +-
 common/stream.c         |  31 +--
 common/stream.h         |   6 +-
 common/types.h          |  35 ++-
 common/util.c           | 147 ++++-------
 common/util.h           |  53 ++--
 configure.ac            |   2 +-
 debian/changelog        |   6 +
 doc/CHANGES             |   5 +
 dump/content.c          | 414 +++++++++++++++---------------
 dump/inomap.c           | 216 ++++++++--------
 dump/inomap.h           |  19 +-
 dump/var.c              |  13 +-
 include/config.h.in     |  49 +++-
 inventory/inv_api.c     |  51 ++--
 inventory/inv_core.c    |  30 ++-
 inventory/inv_files.c   |  15 +-
 inventory/inv_fstab.c   |  17 +-
 inventory/inv_idx.c     |  48 ++--
 inventory/inv_mgr.c     |  25 +-
 inventory/inv_oref.c    |  83 +++---
 inventory/inv_oref.h    |  34 +--
 inventory/inv_priv.h    | 102 ++++----
 inventory/inv_stobj.c   |  95 +++----
 inventory/inventory.h   |  14 +-
 inventory/testmain.c    |  40 +--
 invutil/cmenu.c         |   4 +
 invutil/fstab.c         |   4 +
 invutil/invidx.c        |  13 +-
 invutil/invutil.c       |   5 +
 invutil/list.c          |   4 +-
 invutil/menu.c          |   4 +-
 invutil/screen.c        |   4 +
 invutil/stobj.c         |   5 +
 librmt/rmtabort.c       |   1 +
 librmt/rmtclose.c       |   1 +
 librmt/rmtcommand.c     |   2 +
 librmt/rmtfstat.c       |   2 +
 librmt/rmtioctl.c       |  11 +-
 librmt/rmtlib.h         |   3 -
 librmt/rmtlseek.c       |   2 +
 librmt/rmtmsg.c         |   5 +
 librmt/rmtopen.c        |   4 +-
 librmt/rmtread.c        |   2 +
 librmt/rmtstatus.c      |   2 +
 librmt/rmtwrite.c       |   2 +
 restore/bag.c           |  24 +-
 restore/content.c       | 466 +++++++++++++++++-----------------
 restore/dirattr.c       | 202 ++++++++-------
 restore/dirattr.h       |  12 +-
 restore/inomap.c        | 102 ++++----
 restore/inomap.h        |   8 +-
 restore/mmap.c          |   1 -
 restore/namreg.c        |  56 ++--
 restore/namreg.h        |   4 +-
 restore/node.c          |  97 +++----
 restore/node.h          |   4 +-
 restore/tree.c          | 295 ++++++++++-----------
 restore/tree.h          |   4 +-
 restore/win.c           |  76 +++---
 restore/win.h           |   4 +-
 98 files changed, 2942 insertions(+), 2654 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
