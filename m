Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCCEE7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:59:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB19F30404E
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7ZRDwwlaAQdCIR9K (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:39 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id C3A6E8EA21
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 09:59:38 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 00/14 v5]  xfsprogs: Partial OSX support
Date: Tue, 15 Sep 2015 11:59:10 +0200
Message-Id: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

Hi all,

An updated version. This set is intended to put together the current
versions of the individual patches with the exception of a new patch 14,
and rebase it against the current master branch.

Patch 4 contains renaming required by Dave, however I'm not sure
if it is still needed with the changes in patches 2 and 3.

Patch 10 (adding timer) was mentioned that it "doesn't look to work",
but I didn't get a reasoning. The added code, when tested,
really run. For testing it in xfs_repair, I don't have how to
create a large enough FS where the timer would be noticable on OSX.
(Not enough of empty space.)

Cheers,
Jan

CHANGELOG:
v5:
- patch 2 was split into 3 patches, numbered 2, 3 and 4
- in patches 2-4, instead of just prefixing it all, a mixed
  approach was used.
- patch 9 renames the function directly instead of using #define
- patch 11 now adds a simple rename
- patch 12 uses mntinfo instead of dummy code
- in patch 13, make mremap build optional instead of dummy code
- new patch 14 with lstat64


v4:
- added #warning message (patch 1)
- use dummy blkid_get_topology instead of #ifdefs (patch 1)
- fix autoconf (wasn't passing -DENABLE_BLKID flag, lost during
  patch cleaning.) (patch 1)
- remove dependency on linux XATTR_ constants (patch 2)
- add autoconf detection for fsetxattr (patch 4)
- use uuid_t instead of unsigned char (patch 5)
- add a basic timer functionality (patch 8)
- mremap replacement now returns MAP_FAILED (patch 11)



Version 3:
- better commit messages (patch 1)
- formatting fixes (patch 2, 8)
- autoconf updates (patch 6, 7)
- changed default behaviour if BLKID is disabled such that mkfs -f
  is required (patch 11)

Jan Tulak (14):
  xfsprogs: Add a way to compile without blkid
  xfsprogs: Add XATTR_LIST_MAX to OS X headers
  xfsprogs: avoid dependency on Linux XATTR_SIZE_MAX
  xfsprogs: prefix XATTR_LIST_MAX with XFS_
  xfsprogs: Add includes required for OS X builds (delta)
  xfsprogs: Add autoconf check for fsetxattr call
  xfsprogs: uuid changes for OS X
  xfsprogs: Remove conflicting define for OS X
  xfsprogs: change nftw64 to nftw
  xfsprogs: Add a timer implementation for OS X
  xfsprogs: Add statvfs64 for osx
  xfsprogs: make fsr use mntinfo when there is no mntent
  xfsprogs: Make mremap conditional
  xfsprogs: rename lstat64 to lstat for OS X

 configure.ac             |  12 +++++-
 estimate/xfs_estimate.c  |   6 +--
 fsr/Makefile             |   8 ++++
 fsr/xfs_fsr.c            |  85 ++++++++++++++++++++++++++++++++-----
 include/builddefs.in     |  12 +++++-
 include/darwin.h         | 106 ++++++++++++++++++++++++++++++++++++++++-------
 include/xfs.h            |   2 +
 io/mmap.c                |   8 ++++
 libhandle/handle.c       |   4 +-
 libhandle/jdm.c          |   4 +-
 libxfs/xfs_attr_remote.c |   2 +-
 libxfs/xfs_format.h      |  10 ++++-
 m4/package_libcdev.m4    |  26 ++++++++++++
 mkfs/xfs_mkfs.c          |  37 ++++++++++++++++-
 repair/progress.c        |  16 ++++++-
 15 files changed, 298 insertions(+), 40 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
