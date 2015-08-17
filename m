Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB4357F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 11:23:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E01930406B
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 09:23:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id npQ5js5SOYRRVfuB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 09:23:35 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 00/11] xfsprogs: Partial OS X support
Date: Mon, 17 Aug 2015 18:23:15 +0200
Message-Id: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
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

This is a third iteration of OS X support patches. Notes with information about
changes in every patch since the last bulk submittation (or at least the last
iteration of that patch) follows.

BTW: for the patches which already got "Reviewed-by", I added the line
to these patches. If this is not a good thing and I should let the reviewer
to submit his reviewed-by email again, tell me. :-)

undefined variable fix
- better explanation in commit

Add ifdef dirent checks where it was missing
- added approximation of d_reclen
- text width fix

Change OS X-specific CFLAGS/LDFLAGS
- Nothing, already reviewed

Add includes required for OS X builds
- updated for libdisk gone

missing and dummy calls for OS X support
- new patch (no review yet)

Add mntent.h check into autoconf
- new patch
- autoconf change

Add fls check into autoconf
- new patch
- autoconf change

replace obsolete memalign with posix_memalign
- new patch
- remove strange code formatted

prevent LIST_ macros conflicts
- already reviewed
- new patch

Update doc for OS X
- new patch (no review yet)

Add a way to compile without blkid
- new patch
- changed default behaviour if BLKID is disabled such that mkfs -f is required


Jan Tulak (11):
  xfsprogs: undefined variable fix
  xfsprogs: Add ifdef dirent checks where it was missing
  xfsprogs: Change OS X-specific CFLAGS/LDFLAGS
  xfsprogs: Add includes required for OS X builds
  xfsprogs: missing and dummy calls for OS X support
  xfsprogs: Add mntent.h check into autoconf
  xfsprogs: Add fls check into autoconf
  xfsprogs: replace obsolete memalign with posix_memalign
  xfsprogs: prevent LIST_ macros conflicts
  xfsprogs: Update doc for OS X
  xfsprogs: Add a way to compile without blkid

 configure.ac          |  12 +++-
 copy/xfs_copy.c       |   2 +-
 db/attrset.c          |   2 +-
 doc/INSTALL           |  11 +++-
 fsr/xfs_fsr.c         |  17 ++++--
 include/bitops.h      |   2 +
 include/builddefs.in  |  11 +++-
 include/darwin.h      | 162 ++++++++++++++++++++++++++++++++++++++++++++------
 include/freebsd.h     |   1 -
 include/gnukfreebsd.h |   1 -
 include/linux.h       |   1 -
 include/list.h        |  14 +++++
 io/pread.c            |   4 +-
 io/readdir.c          |  12 ++++
 libhandle/Makefile    |   4 ++
 libxcmd/paths.c       |   2 +-
 libxfs/rdwr.c         |  12 ++--
 m4/package_libcdev.m4 |  20 +++++++
 mkfs/xfs_mkfs.c       |  25 +++++++-
 repair/incore.c       |   2 +-
 repair/incore_ino.c   |   7 ++-
 repair/phase1.c       |   2 +-
 repair/prefetch.c     |   7 +--
 repair/sb.c           |  10 ++--
 rtcp/xfs_rtcp.c       |   7 ++-
 25 files changed, 295 insertions(+), 55 deletions(-)

-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
