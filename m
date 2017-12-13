Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdLMGNq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:13:46 -0500
Subject: [PATCH 2/8] common/xfs: fix scrub support probing again
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Dec 2017 22:03:26 -0800
Message-ID: <151314500649.18893.5124611130669609633.stgit@magnolia>
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the final version of the xfs_io scrub command we don't allow the
probe function to have any parameters, so fix the helper to abide
that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/xfs b/common/xfs
index 76f94fb..f3e3764 100644
--- a/common/xfs
+++ b/common/xfs
@@ -314,7 +314,7 @@ _supports_xfs_scrub()
 
 	# Probe for kernel support...
 	$XFS_IO_PROG -c 'help scrub' 2>&1 | grep -q 'types are:.*probe' || return 1
-	$XFS_IO_PROG -c "scrub probe 0" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
+	$XFS_IO_PROG -c "scrub probe" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
 
 	# Scrub can't run on norecovery mounts
 	_fs_options "$device" | grep -q "norecovery" && return 1

