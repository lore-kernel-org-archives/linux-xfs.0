Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8FA9229DFD
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 07:21:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2ADAFAC007
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 05:21:10 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id XcjtDJa2CD5GZ2Ak (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 05:21:07 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/6] Add cross-compilation support for android
Date: Sun, 26 Jul 2015 08:20:49 -0400
Message-Id: <1437913255-7524-1-git-send-email-tytso@mit.edu>
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
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org

As part of my efforts to port xfstests so it can be used in an Android
runtime environment (where running fsstress by hand seems to be the
state-of-the-art in file system QA), I needed to make the following
changes to xfsprogs so it can be built using cross compilation using
Android's bionic C library.  Fortunately given XFS's Irix roots, the
number of glibc'isms that have kept in was relatively small.


Theodore Ts'o (6):
  xfsprogs: define NBBY if not defined by the system header files
  xfsprogs: pull in libgen.h to get prototype for basename()
  xfsprogs: define and use BUILD_CC in configure.ac for cross
    compilation
  xfsprogs: avoid use of si_tid in struct xlog_split_item
  xfsprogs: use "unsigned short" instead of ushort
  xfsprogs: add missing include of <stat.h>

 configure.ac               | 8 ++++++++
 include/builddefs.in       | 1 +
 include/platform_defs.h.in | 5 +++++
 include/xfs_inode_buf.h    | 4 ++--
 include/xfs_log_format.h   | 4 ++--
 include/xfs_log_recover.h  | 2 +-
 libdisk/evms.c             | 1 +
 libxfs/Makefile            | 4 ++--
 libxfs/logitem.c           | 2 +-
 libxfs/xfs_ialloc.c        | 4 ++--
 logprint/log_misc.c        | 8 ++++----
 11 files changed, 29 insertions(+), 14 deletions(-)

-- 
2.3.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
