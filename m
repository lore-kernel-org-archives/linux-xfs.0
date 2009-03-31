Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2VLr9nd029553 for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 16:53:19 -0500
Received: from ten.citi.umich.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 389A613E2FFF
	for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 14:53:34 -0700 (PDT)
Received: from ten.citi.umich.edu (ten.citi.umich.edu [141.211.133.138]) by
	cuda.sgi.com with ESMTP id WYGmNdv7fFeYbcey for
	<xfs@oss.sgi.com>; Tue, 31 Mar 2009 14:53:34 -0700 (PDT)
From: "Josef 'Jeff' Sipek" <jsipek@eecs.umich.edu>
Subject: [PATCH 2/2] xfstests: Add an ignore file
Date: Tue, 31 Mar 2009 17:50:34 -0400
Message-Id: <1238536234-26969-3-git-send-email-jsipek@eecs.umich.edu>
In-Reply-To: <1238536234-26969-1-git-send-email-jsipek@eecs.umich.edu>
References: <1238536234-26969-1-git-send-email-jsipek@eecs.umich.edu>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, Josef 'Jeff' Sipek <jsipek@eecs.umich.edu>

From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Ignore generated files.

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@eecs.umich.edu>
---
 .gitignore |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 90 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..2cd722b
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,90 @@
+*.lo
+*.o
+*.la
+
+autom4te.cache
+configure
+include/builddefs
+include/config.h
+include/config.h.in
+lib/.libs
+
+dmapi/Makefile
+dmapi/config.log
+dmapi/config.status
+dmapi/libtool
+dmapi/src/Makefile
+dmapi/src/common/Makefile
+dmapi/src/common/cmd/.deps
+dmapi/src/common/cmd/Makefile
+dmapi/src/common/lib/.deps
+dmapi/src/common/lib/Makefile
+dmapi/src/sample_hsm/.deps
+dmapi/src/sample_hsm/Makefile
+dmapi/src/simple/.deps
+dmapi/src/simple/Makefile
+dmapi/src/suite1/Makefile
+dmapi/src/suite1/cmd/.deps
+dmapi/src/suite1/cmd/Makefile
+dmapi/src/suite2/Makefile
+dmapi/src/suite2/src/.deps
+dmapi/src/suite2/src/Makefile
+
+ltp/aio-stress
+ltp/doio
+ltp/fsstress
+ltp/fsx
+ltp/growfiles
+ltp/iogen
+
+src/alloc
+src/append_reader
+src/append_writer
+src/bstat
+src/bulkstat_unlink_test
+src/bulkstat_unlink_test_modified
+src/devzero
+src/dirperf
+src/dirstress
+src/dmiperf
+src/fault
+src/feature
+src/fill
+src/fill2
+src/fs_perms
+src/fstest
+src/ftrunc
+src/genhashnames
+src/getdevicesize
+src/getpagesize
+src/godown
+src/holes
+src/itrash
+src/locktest
+src/loggen
+src/looptest
+src/lstat64
+src/makeextents
+src/metaperf
+src/mmapcat
+src/multi_open_unlink
+src/nametest
+src/permname
+src/preallo_rw_pattern_reader
+src/preallo_rw_pattern_writer
+src/randholes
+src/rename
+src/resvtest
+src/runas
+src/t_access_root
+src/t_dir_offset
+src/t_immutable
+src/t_mtab
+src/testx
+src/trunc
+src/truncfile
+src/unwritten_mmap
+src/unwritten_sync
+src/usemem
+src/writemod
+src/xfsctl
-- 
1.6.0.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
