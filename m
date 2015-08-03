Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F75B7F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:40:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79D3F304053
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 07:40:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xa0CDWvTvLjZvjfY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 07:40:21 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v3 00/11] xfsprogs: OS X partial support
Date: Mon,  3 Aug 2015 16:39:38 +0200
Message-Id: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
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

Hi folks.

All right, this is a third iteration of fixing the out-of-date
OS X code in xfsprogs (4 years since the last touch).

Against v2, I made these changes:

- Patch 4/4 was broken to 8 smaller patches
- Issues in that patch were addressed
- Greatly enhanced commit message about LIST_ macros renaming

The last point is still open and may change, so I moved it
into the last commit. First two commits were already reviewed,
but I include them to keep their trace in this new numbering of
the patchset.

Cheers,
Jan

Jan Tulak (11):
  xfsprogs: Don't Make .po files with gettext disabled
  xfsprogs: Use glibtoolize on osx
  xfsprogs: undefined variable fix
  xfsprogs: Add ifdef dirent checks where it was missing
  xfsprogs: Change OS X-specific CFLAGS/LDFLAGS
  xfsprogs: Add includes required for OS X builds
  xfsprogs: missing and dummy calls for OS X support
  xfsprogs: Add fls check into autoconf
  xfsprogs: Add mntent.h check into autoconf
  xfsprogs: replace obsolete memalign with posix_memalign
  xfsprogs: Prefix LIST_... macros to XFS_LIST_...

 Makefile              |  19 +++++-
 configure.ac          |   2 +
 copy/xfs_copy.c       |   2 +-
 db/attrset.c          |   2 +-
 fsr/xfs_fsr.c         |  17 ++++--
 include/bitops.h      |   2 +
 include/builddefs.in  |  10 +++-
 include/darwin.h      | 159 ++++++++++++++++++++++++++++++++++++++++++++------
 include/freebsd.h     |   1 -
 include/gnukfreebsd.h |   1 -
 include/linux.h       |   1 -
 include/list.h        |   6 +-
 io/pread.c            |   4 +-
 io/readdir.c          |   4 ++
 libdisk/fstype.c      |   1 +
 libhandle/Makefile    |   4 ++
 libxcmd/paths.c       |   2 +-
 libxfs/rdwr.c         |  19 ++++--
 m4/package_libcdev.m4 |  26 +++++++++
 mkfs/xfs_mkfs.c       |   6 +-
 repair/incore.c       |   2 +-
 repair/incore_ino.c   |  13 ++++-
 repair/phase1.c       |   2 +-
 repair/phase6.c       |   2 +-
 repair/prefetch.c     |   7 +--
 repair/sb.c           |  10 ++--
 rtcp/xfs_rtcp.c       |   7 ++-
 27 files changed, 274 insertions(+), 57 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
