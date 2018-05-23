Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:45154 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932312AbeEWKuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 06:50:51 -0400
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2] xfs: remove meta mkfs options correctly in _scratch_mkfs_xfs
Date: Wed, 23 May 2018 18:50:35 +0800
Message-Id: <20180523105035.8157-1-guaneryu@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>

Prior to commit 596a068bf130 ("fstests: teach _scratch_mkfs to handle
mkfs option conflicts"), one of _scratch_mkfs_xfs_opts()'s job is to
remove any metadata related mkfs options if mkfs.xfs binary doesn't
support them, so that tests that pass metadada mkfs options to
_scratch_mkfs, e.g. "_scratch_mkfs -m crc=0" won't break with old
mkfs.xfs.

But commit 596a068bf130 broke this, because it didn't pass any mkfs
options to _scratch_mkfs_xfs_opts(). Fix it by introducing a new helper
_xfs_mkfs_remove_meta_opts() to remove any meta related mkfs options if
necessary, and moving that function out of _scratch_mkfs_xfs_opts().

Reported-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
v2:
- treat "extra options" as extra options, so move remove-meta-opts function
  out of _scratch_mkfs_xfs_opts() to a new helper _xfs_mkfs_remove_meta_opts

 common/xfs | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/common/xfs b/common/xfs
index 92223513d561..1385c8c7e57b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -44,18 +44,20 @@ _setup_large_xfs_fs()
 	return 0
 }
 
-_scratch_mkfs_xfs_opts()
+# remove metadata related mkfs options if mkfs.xfs doesn't support them
+_xfs_mkfs_remove_meta_opts()
 {
-	mkfs_opts=$*
-
-	# remove metadata related mkfs options if mkfs.xfs doesn't them
+	local mkfs_opts="$*"
 	if [ -n "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
-		mkfs_opts=`echo $mkfs_opts | sed "s/-m\s\+\S\+//g"`
+		mkfs_opts=`echo $* | sed "s/-m\s\+\S\+//g"`
 	fi
+	echo "$mkfs_opts"
+}
 
+_scratch_mkfs_xfs_opts()
+{
 	_scratch_options mkfs
-
-	echo "$MKFS_XFS_PROG $SCRATCH_OPTIONS $mkfs_opts"
+	echo "$MKFS_XFS_PROG $SCRATCH_OPTIONS"
 }
 
 
@@ -83,10 +85,12 @@ _scratch_mkfs_xfs()
 	local mkfs_filter="sed -e '/less than device physical sector/d' \
 			       -e '/switching to logical sector/d' \
 			       -e '/Default configuration/d'"
+	local extra_mkfs_opts="`_xfs_mkfs_remove_meta_opts $*`"
 	local tmp=`mktemp -u`
 	local mkfs_status
 
-	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
+	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" "$extra_mkfs_opts" \
+		2>$tmp.mkfserr 1>$tmp.mkfsstd
 	mkfs_status=$?
 
 
-- 
2.17.0

