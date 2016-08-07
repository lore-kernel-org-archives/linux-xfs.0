Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B47ED7CEC
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1777FAC007
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:47 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id iu7nGCslB61gwFrV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:44 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 4B0742045A
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:43 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQQ5zcBzysK
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:42 +0200 (CEST)
Message-Id: <cover.1470552214.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sun, 7 Aug 2016 08:43:34 +0200
Subject: [PATCH xfsprogs 00/14] Convert from off64_t to off_t
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

The off64_t type and structs/functions dependent on it were envisaged
as a stepping stone for the LFS (large file support) transition [1].
On most systems today, transparent LFS is enabled, i.e. off_t is 64bit
and all interfaces are 64bit clean -- on many of these systems the type
off64_t is even not defined. For a long time, we have used
-D_FILE_OFFSET_BITS=64 on linux, which is the only supported system
without transparent LFS by default.

This patch series does several related things:
- Enable transparent LFS support via an autoconf macro instead of using
  -D_FILE_OFFSET_BITS=64
- Replace all types/function involving off64_t by their equivalent
  involving off_t
- Ensure that the xfs headers can only be used when transparent LFS is
  enabled.

[1]: http://users.suse.com/~aj/linux_lfs.html

Felix Janda (14):
  configure: use AC_SYS_LARGEFILE
  remove unecessary definitions of _FILE_OFFSET_BITS
  replace fstat64 by equivalent fstat
  replace lstat64 by equivalent lstat
  replace stat64 by equivalent stat
  replace ftruncate64 by equivalent ftruncate
  replace lseek64 by equivalent lseek
  replace pread64 by equivalent pread
  replace pwrite64 by equivalent pwrite
  replace sendfile64 by equivalent sendfile
  replace statvfs64 by equivalent statvfs
  replace off64_t by off_t outside of public headers
  xfs.h: require transparent LFS
  platform: remove use of off64_t

 configure.ac              |  2 ++
 copy/xfs_copy.c           | 24 +++++++++---------
 fsr/xfs_fsr.c             | 64 +++++++++++++++++++++--------------------------
 include/builddefs.in      |  2 +-
 include/darwin.h          | 12 ++-------
 include/freebsd.h         |  7 ------
 include/irix.h            |  2 +-
 include/linux.h           |  2 +-
 include/xfs.h             |  2 ++
 io/bmap.c                 | 10 ++++----
 io/copy_file_range.c      | 12 ++++-----
 io/fadvise.c              |  2 +-
 io/io.h                   | 10 ++++----
 io/madvise.c              |  2 +-
 io/mincore.c              |  2 +-
 io/mmap.c                 | 12 ++++-----
 io/open.c                 | 20 +++++++--------
 io/pread.c                | 38 ++++++++++++++--------------
 io/pwrite.c               | 28 ++++++++++-----------
 io/reflink.c              |  4 +--
 io/seek.c                 | 12 ++++-----
 io/sendfile.c             | 16 ++++++------
 io/sync_file_range.c      |  2 +-
 io/truncate.c             |  4 +--
 libxcmd/paths.c           |  4 +--
 libxfs/darwin.c           |  8 +++---
 libxfs/freebsd.c          |  8 +++---
 libxfs/init.c             | 12 ++++-----
 libxfs/init.h             |  6 ++---
 libxfs/irix.c             |  8 +++---
 libxfs/linux.c            | 20 +++++++--------
 libxfs/rdwr.c             | 18 ++++++-------
 logprint/log_misc.c       |  4 +--
 logprint/logprint.c       |  2 +-
 m4/package_libcdev.m4     |  9 -------
 mdrestore/xfs_mdrestore.c | 14 +++++------
 mkfs/proto.c              |  4 +--
 mkfs/xfs_mkfs.c           |  8 +++---
 po/de.po                  | 28 ++++++++++-----------
 po/pl.po                  | 32 ++++++++++++------------
 repair/prefetch.c         |  4 +--
 repair/sb.c               |  6 ++---
 repair/xfs_repair.c       |  4 +--
 rtcp/xfs_rtcp.c           | 18 ++++++-------
 44 files changed, 240 insertions(+), 268 deletions(-)

-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
