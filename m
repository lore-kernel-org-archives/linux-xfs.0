Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A57B97F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:00:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 91AB78F8040
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:00:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1A6odVsVFz5B4N6M (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:00:58 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 00/11 v4] xfsprogs: Partial OSX support
Date: Wed, 26 Aug 2015 14:00:49 +0200
Message-Id: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

Fourth iteration. Most of the patches in this set are from splitting
one patch in the previous iteration.

Specifically, only patch 1 is from the previous set as it wasn't
in a good shape yet. Patch 3 is a delta for an older version which was
merged accidentaly instead of the newest one.

All the other patches in this set originate from
[PATCH 05/11] xfsprogs: missing and dummy calls for OS X support.

FSR is still compiled, even if it requires empty functions. There is
no drawback from this for other platforms. Some of the calls can be made
working. However, for example the mntent calls are not usefull anywhere
else, and as fsr can't work without a mounted system, there is no way
how to use and test the alternative implementation.

If in futre xfs can be mounted on OS X, then at least the empty functions
are clear as "TODO". If there is an untested code, they will most likely
need to be debugged and possibly even rewritten to respect future changes
in OS X. So in short, I see implementing them as a waste of time.

Stopping the FSR build is, with the current target audience of this port
between developers, unnecessary.

Cheers,
Jan

CHANGELOG:

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

Jan Tulak (11):
  xfsprogs: Add a way to compile without blkid
  xfsprogs: avoid dependency on linux XATTR_SIZE/LIST_MAX
  xfsprogs: Add includes required for OS X builds (delta)
  xfsprogs: Add autoconf check for fsetxattr call
  xfsprogs: uuid changes for OS X
  xfsprogs: Remove conflicting define for OS X
  xfsprogs: add nftw64 translation for OS X
  xfsprogs: Add a timer implementation for OS X
  xfsprogs: Add statvfs64 for osx
  xfsprogs: add dummy mntent for OS X
  xfsprogs: add dummy mremap for OS X

 configure.ac             |  11 +++-
 fsr/xfs_fsr.c            |   8 +++
 include/builddefs.in     |  11 +++-
 include/darwin.h         | 157 ++++++++++++++++++++++++++++++++++++++++++-----
 libhandle/handle.c       |   6 +-
 libhandle/jdm.c          |   6 +-
 libxfs/xfs_attr_remote.c |   2 +-
 libxfs/xfs_format.h      |  11 +++-
 m4/package_libcdev.m4    |  13 ++++
 mkfs/xfs_mkfs.c          |  37 ++++++++++-
 repair/progress.c        |  16 ++++-
 11 files changed, 251 insertions(+), 27 deletions(-)

-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
