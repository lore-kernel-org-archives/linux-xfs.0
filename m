Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 17:54:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D0rsx0002981
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 17:53:58 -0700
Date: Tue, 13 May 2008 10:54:36 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa - fix 17[5-7] "unmount" typo
Message-ID: <20080513005436.GQ155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

177 fails because mkfs tries to run on a mounted filesystem.
All 17[5-7] have the same problem - "unmount" is not the command
to unmount a filesystem.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/175 |    2 +-
 xfstests/176 |    2 +-
 xfstests/177 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: xfs-cmds/xfstests/175
===================================================================
--- xfs-cmds.orig/xfstests/175	2008-05-08 09:59:28.000000000 +1000
+++ xfs-cmds/xfstests/175	2008-05-13 10:50:01.581533095 +1000
@@ -40,7 +40,7 @@ _require_scratch
 
 # test that we have DMAPI support
 _dmapi_scratch_mount
-unmount $SCRATCH_MNT > /dev/null 2>&1
+umount $SCRATCH_MNT > /dev/null 2>&1
 
 # _test_punch args: blksize extsize_hint filesize "pp1 pp2 pp3" \
 # 					"ps1 ps2 ps3" "pt1 pt2 pt3" "wp1 wp2" "ws1 ws2" \
Index: xfs-cmds/xfstests/176
===================================================================
--- xfs-cmds.orig/xfstests/176	2008-05-08 09:59:28.000000000 +1000
+++ xfs-cmds/xfstests/176	2008-05-13 10:50:05.281061350 +1000
@@ -38,7 +38,7 @@ _require_scratch
 
 # test that we have DMAPI support
 _dmapi_scratch_mount
-unmount $SCRATCH_MNT > /dev/null 2>&1
+umount $SCRATCH_MNT > /dev/null 2>&1
 
 # _test_punch args: blksize extsize_hint filesize "pp1 pp2 pp3" \
 # 					"ps1 ps2 ps3" "pt1 pt2 pt3" "wp1 wp2" "ws1 ws2" \
Index: xfs-cmds/xfstests/177
===================================================================
--- xfs-cmds.orig/xfstests/177	2008-05-08 09:59:28.000000000 +1000
+++ xfs-cmds/xfstests/177	2008-05-13 10:49:58.181966589 +1000
@@ -40,7 +40,7 @@ _require_scratch
 
 # test that we have DMAPI support
 _dmapi_scratch_mount
-unmount $SCRATCH_MNT > /dev/null 2>&1
+umount $SCRATCH_MNT > /dev/null 2>&1
 
 _scratch_mkfs_xfs >/dev/null 2>&1 \
         || _fail "mkfs failed"
