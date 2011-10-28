Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SErrSv158233 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 09:53:53 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfstests: add missing binaries to .gitignore
Date: Fri, 28 Oct 2011 09:53:25 -0500
Message-Id: <1319813605-29938-1-git-send-email-wkendall@sgi.com>
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

A clean checkout of xfstests followed by a build resulted in a long list
of untracked files. The current .gitignore ignores most binaries, but
the "dmapi" subdir was missed as were some binaries from the "src"
subdir.

Also ".libs" and ".ltdep" appear under a "dmapi" subdir, not just under
the top-level "libs" directory, so ignore those regardless of the
directory they are in.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 .gitignore |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 91 insertions(+), 1 deletions(-)

diff --git a/.gitignore b/.gitignore
index ef43f9a..900ff95 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,6 +2,8 @@
 *.o
 *.la
 .dep
+.libs
+.ltdep
 
 autom4te.cache
 configure
@@ -10,7 +12,6 @@ config.status
 include/builddefs
 include/config.h
 include/config.h.in
-lib/.libs
 
 ltp/aio-stress
 ltp/doio
@@ -31,10 +32,12 @@ src/dirstress
 src/dmiperf
 src/fault
 src/feature
+src/fiemap-tester
 src/fill
 src/fill2
 src/fs_perms
 src/fstest
+src/fstrim
 src/ftrunc
 src/genhashnames
 src/getdevicesize
@@ -54,14 +57,21 @@ src/nametest
 src/permname
 src/preallo_rw_pattern_reader
 src/preallo_rw_pattern_writer
+src/pwrite_mmap_blocked
 src/randholes
 src/rename
 src/resvtest
 src/runas
+src/stale_handle
 src/t_access_root
 src/t_dir_offset
+src/t_dir_offset2
+src/t_futimens
+src/t_holes
 src/t_immutable
+src/t_mmap_writev
 src/t_mtab
+src/t_stripealign
 src/testx
 src/trunc
 src/truncfile
@@ -71,8 +81,88 @@ src/usemem
 src/writemod
 src/xfsctl
 src/aio-dio-regress/aio-dio-extend-stat
+src/aio-dio-regress/aio-dio-hole-filling-race
 src/aio-dio-regress/aio-dio-invalidate-failure
 src/aio-dio-regress/aio-dio-invalidate-readahead
 src/aio-dio-regress/aio-dio-subblock-eof-read
 src/aio-dio-regress/aio-free-ring-with-bogus-nr-pages
 src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer
+src/aio-dio-regress/aiodio_sparse2
+
+dmapi/src/common/cmd/read_invis
+dmapi/src/common/cmd/set_region
+dmapi/src/common/cmd/set_return_on_destroy
+dmapi/src/common/cmd/write_invis
+dmapi/src/sample_hsm/migfind
+dmapi/src/sample_hsm/migin
+dmapi/src/sample_hsm/migout
+dmapi/src/sample_hsm/mls
+dmapi/src/sample_hsm/mrmean
+dmapi/src/sample_hsm/wbee
+dmapi/src/simple/dm_create_session
+dmapi/src/simple/dm_destroy_session
+dmapi/src/simple/dm_find_eventmsg
+dmapi/src/simple/dm_getall_sessions
+dmapi/src/simple/dm_getall_tokens
+dmapi/src/simple/dm_query_session
+dmapi/src/suite1/cmd/create_userevent
+dmapi/src/suite1/cmd/dm_handle
+dmapi/src/suite1/cmd/downgrade_right
+dmapi/src/suite1/cmd/fd_to_handle
+dmapi/src/suite1/cmd/get_allocinfo
+dmapi/src/suite1/cmd/get_config_events
+dmapi/src/suite1/cmd/get_dirattrs
+dmapi/src/suite1/cmd/get_dmattr
+dmapi/src/suite1/cmd/get_eventlist
+dmapi/src/suite1/cmd/get_events
+dmapi/src/suite1/cmd/get_fileattr
+dmapi/src/suite1/cmd/get_mountinfo
+dmapi/src/suite1/cmd/get_region
+dmapi/src/suite1/cmd/getall_disp
+dmapi/src/suite1/cmd/getall_dmattr
+dmapi/src/suite1/cmd/handle_to_fshandle
+dmapi/src/suite1/cmd/handle_to_path
+dmapi/src/suite1/cmd/init_service
+dmapi/src/suite1/cmd/link_test
+dmapi/src/suite1/cmd/make_sparse
+dmapi/src/suite1/cmd/obj_ref_hold
+dmapi/src/suite1/cmd/obj_ref_query
+dmapi/src/suite1/cmd/obj_ref_rele
+dmapi/src/suite1/cmd/path_to_fshandle
+dmapi/src/suite1/cmd/path_to_handle
+dmapi/src/suite1/cmd/pending
+dmapi/src/suite1/cmd/print_event
+dmapi/src/suite1/cmd/print_fshandle
+dmapi/src/suite1/cmd/probe_hole
+dmapi/src/suite1/cmd/probe_punch_xfsctl_hole
+dmapi/src/suite1/cmd/punch_hole
+dmapi/src/suite1/cmd/query_right
+dmapi/src/suite1/cmd/randomize_file
+dmapi/src/suite1/cmd/release_right
+dmapi/src/suite1/cmd/remove_dmattr
+dmapi/src/suite1/cmd/request_right
+dmapi/src/suite1/cmd/respond_event
+dmapi/src/suite1/cmd/rwt
+dmapi/src/suite1/cmd/set_disp
+dmapi/src/suite1/cmd/set_dmattr
+dmapi/src/suite1/cmd/set_eventlist
+dmapi/src/suite1/cmd/set_fileattr
+dmapi/src/suite1/cmd/struct_test
+dmapi/src/suite1/cmd/sync_by_handle
+dmapi/src/suite1/cmd/test_assumption
+dmapi/src/suite1/cmd/upgrade_right
+dmapi/src/suite2/src/dm_test_daemon
+dmapi/src/suite2/src/invis_test
+dmapi/src/suite2/src/mmap
+dmapi/src/suite2/src/region_test
+dmapi/src/suite2/src/send_msg
+dmapi/src/suite2/src/test_bulkall
+dmapi/src/suite2/src/test_bulkattr
+dmapi/src/suite2/src/test_dmattr
+dmapi/src/suite2/src/test_efault
+dmapi/src/suite2/src/test_eventlist
+dmapi/src/suite2/src/test_fileattr
+dmapi/src/suite2/src/test_hole
+dmapi/src/suite2/src/test_invis
+dmapi/src/suite2/src/test_region
+dmapi/src/suite2/src/test_rights
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
