Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36074 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeEKDIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 23:08:05 -0400
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] xfs: pass extra params to _scratch_mkfs_xfs_opts in _scratch_mkfs_xfs
Date: Fri, 11 May 2018 11:05:59 +0800
Message-Id: <20180511030559.26502-1-guaneryu@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>

One of _scratch_mkfs_xfs_opts()'s job is to remove any metadata
related mkfs options if mkfs.xfs binary doesn't support them, so
that tests that pass metadata mkfs options to _scratch_mkfs, e.g.
"_scratch_mkfs -m crc=0" won't break with old mkfs.xfs.

But commit 596a068bf130 ("fstests: teach _scratch_mkfs to handle
mkfs option conflicts") broke this, because it didn't pass any mkfs
options to _scratch_mkfs_xfs_opts(). So fix it.

Also declare a variable as 'local' and fix a typo.

Reported-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 common/xfs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/common/xfs b/common/xfs
index e0bc3f43d3c5..498f45e64b6d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -46,9 +46,9 @@ _setup_large_xfs_fs()
 
 _scratch_mkfs_xfs_opts()
 {
-	mkfs_opts=$*
+	local mkfs_opts=$*
 
-	# remove metadata related mkfs options if mkfs.xfs doesn't them
+	# remove metadata related mkfs options if mkfs.xfs doesn't support them
 	if [ -n "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
 		mkfs_opts=`echo $mkfs_opts | sed "s/-m\s\+\S\+//g"`
 	fi
@@ -79,14 +79,14 @@ _scratch_mkfs_xfs_supported()
 
 _scratch_mkfs_xfs()
 {
-	local mkfs_cmd="`_scratch_mkfs_xfs_opts`"
+	local mkfs_cmd="`_scratch_mkfs_xfs_opts $*`"
 	local mkfs_filter="sed -e '/less than device physical sector/d' \
 			       -e '/switching to logical sector/d' \
 			       -e '/Default configuration/d'"
 	local tmp=`mktemp -u`
 	local mkfs_status
 
-	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
+	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" 2>$tmp.mkfserr 1>$tmp.mkfsstd
 	mkfs_status=$?
 
 
-- 
2.17.0

