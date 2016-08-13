Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E41187CA0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:24:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5133304051
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:24:32 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id cORfdHBu2T6d0gYK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:24:24 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 8A9F8209F3
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:24:22 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTBs5FbKz104L
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:24:21 +0200 (CEST)
Resent-Message-ID: <20160813172324.GA3830@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 13 Aug 2016 19:04:18 +0200
Subject: [PATCHv2 xfsprogs 00/14] Convert from off64_t to off_t
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

This patch series does several things related to large file support.

Patches 1-3 enable transparent LFS in the build system and make it
mandatory.

Patches 4-9 and 12 replace *64 function and structure aliases.

Patches 10 and 11 disable fsr on Mac OS X and do cleanup to enable
Patch 12. Further cleanup of the portability code is possible later.

Patch 13 makes tranparent LFS also mandatory for all users of libxfs.

Patch 14 finally replaces off64_t by off_t.


In comparison to v1:

Patches 1, 3 and 14 are identical to previous patches. Patches 4-8 are
identical to previous patches, except that some of them are merged.
Patch 9 was previously send separately from the patch series. Patch
13 is identical to a previous patch except for the commit message. The
other patches are new, grown out of review by Christoph Hellwig.

Felix Janda (14):
  configure: use AC_SYS_LARGEFILE
  configure: error out when LFS does not work
  remove unecessary definitions of _FILE_OFFSET_BITS
  replace [fl]stat64 by equivalent [fl]stat
  replace ftruncate64 by equivalent ftruncate
  replace lseek64 by equivalent lseek
  replace pread64/pwrite64 by equivalent pread/pwrite
  replace sendfile64 by equivalent sendfile
  fadvise.c: replace posix_fadvise64 by equivalent posix_fadvise
  Makefile: disable fsr for Mac OS X
  fsr: remove workaround for statvfs on Mac OS X
  replace statvfs64 by equivalent statvfs
  xfs.h: require transparent LFS for all users
  platform: remove use of off64_t

 Makefile                  |  6 ++++-
 configure.ac              |  3 +++
 copy/xfs_copy.c           | 22 ++++++++---------
 fsr/xfs_fsr.c             | 62 +++++++++++++++++++++--------------------------
 include/builddefs.in      |  2 +-
 include/darwin.h          |  9 -------
 include/freebsd.h         |  7 ------
 include/irix.h            |  2 +-
 include/linux.h           |  2 +-
 include/xfs.h             |  5 ++++
 io/copy_file_range.c      | 10 ++++----
 io/fadvise.c              |  2 +-
 io/open.c                 | 18 +++++++-------
 io/pread.c                | 16 ++++++------
 io/pwrite.c               | 10 ++++----
 io/seek.c                 |  6 ++---
 io/sendfile.c             | 10 ++++----
 io/truncate.c             |  2 +-
 libxcmd/paths.c           |  4 +--
 libxfs/darwin.c           |  8 +++---
 libxfs/freebsd.c          |  8 +++---
 libxfs/init.c             | 12 ++++-----
 libxfs/init.h             |  6 ++---
 libxfs/irix.c             |  8 +++---
 libxfs/linux.c            | 20 +++++++--------
 libxfs/rdwr.c             | 10 ++++----
 logprint/log_misc.c       |  4 +--
 logprint/logprint.c       |  2 +-
 m4/package_libcdev.m4     | 25 ++++++++++++-------
 mdrestore/xfs_mdrestore.c | 12 ++++-----
 mkfs/proto.c              |  4 +--
 mkfs/xfs_mkfs.c           |  8 +++---
 po/de.po                  | 28 ++++++++++-----------
 po/pl.po                  | 32 ++++++++++++------------
 repair/prefetch.c         |  2 +-
 repair/sb.c               |  6 ++---
 repair/xfs_repair.c       |  4 +--
 rtcp/xfs_rtcp.c           | 18 +++++++-------
 38 files changed, 205 insertions(+), 210 deletions(-)

-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
