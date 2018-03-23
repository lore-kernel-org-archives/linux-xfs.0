Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44884 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeCWQyk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 12:54:40 -0400
Subject: [PATCH 2/4] common/xfs: fix various problems with
 _supports_xfs_scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 23 Mar 2018 09:54:35 -0700
Message-ID: <152182407507.14523.13692488779696151853.stgit@magnolia>
In-Reply-To: <152182406249.14523.2186010254497227366.stgit@magnolia>
References: <152182406249.14523.2186010254497227366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@linux.alibaba.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The _supports_xfs_scrub helper is called with a mountpoint (a working
mountpoint is required for scrub) and a block device (used to detect
norecovery mounts).  If either of these conditions aren't satisfied we
should return failure status to the caller, not unilaterally decide to
bail out of the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/common/xfs b/common/xfs
index 1d98ba1..3b71e02 100644
--- a/common/xfs
+++ b/common/xfs
@@ -305,9 +305,13 @@ _supports_xfs_scrub()
 	local mountpoint="$1"
 	local device="$2"
 
-	if [ ! -b "$device" ] || [ ! -e "$mountpoint" ]; then
+	if [ -z "$device" ] || [ -z "$mountpoint" ]; then
 		echo "Usage: _supports_xfs_scrub mountpoint device"
-		exit 1
+		return 1
+	fi
+
+	if [ ! -b "$device" ] || [ ! -e "$mountpoint" ]; then
+		return 1
 	fi
 
 	test "$FSTYP" = "xfs" || return 1

