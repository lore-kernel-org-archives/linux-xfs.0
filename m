Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20341 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754914AbdGUWEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 18:04:40 -0400
Subject: [PATCH 1/5] xfs: only run scrub in dry run mode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jul 2017 15:04:27 -0700
Message-ID: <150067466769.30639.11493790203008890158.stgit@magnolia>
In-Reply-To: <150067465981.30639.14801416171688538711.stgit@magnolia>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When checking a filesystem, explicitly run xfs_scrub in dry run mode
so that it will not ever try to preen, fix, or optimize anything.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/xfs b/common/xfs
index cfdbfff..9224499 100644
--- a/common/xfs
+++ b/common/xfs
@@ -331,7 +331,7 @@ _check_xfs_filesystem()
 
 	if [ "$type" = "xfs" ]; then
 		if [ -n "$TEST_XFS_SCRUB" ] && [ -x "$XFS_SCRUB_PROG" ]; then
-			"$XFS_SCRUB_PROG" $scrubflag -vd $device >>$seqres.full
+			"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device >>$seqres.full
 			if [ $? -ne 0 ]; then
 				_log_err "filesystem on $device failed scrub"
 				ok=0

