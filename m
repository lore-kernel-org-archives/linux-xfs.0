Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32664 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752186AbdGCHgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2017 03:36:16 -0400
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH] generic/446: add __xfs_get_blocks() into _filter_xfs_dmesg
Date: Mon, 3 Jul 2017 15:35:59 +0800
Message-ID: <1499067359-23500-1-git-send-email-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: eguan@redhat.com, bfoster@redhat.com, linux-xfs@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>

On xfs filesystem, the following patch fixed system crash caused by
this race, but it introduced the __xfs_get_blocks() warning when the
race occurred:
04197b3 ("xfs: don't BUG() on mixed direct and mapped I/O")

On upstream kernel, the fix patch was cleared by:
acdda3a ("xfs: use iomap_dio_rw")

When the fix patch was applied and not cleared(e.g, on RHEL7.4), this
case triggered the __xfs_get_blocks() warning as expected.  Moreover,
generic/095 may reproduce the same warning occasionally.  So we could
add __xfs_get_blocks() into _filter_xfs_dmesg.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 common/xfs | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index 77100f7..a1ee384 100644
--- a/common/xfs
+++ b/common/xfs
@@ -595,9 +595,11 @@ _filter_xfs_dmesg()
 	local warn3="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
 	local warn4="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_aio_read.*"
 	local warn5="WARNING:.*fs/iomap\.c:.*iomap_dio_rw.*"
+	local warn6="WARNING:.*fs/xfs/xfs_aops\.c:.*__xfs_get_blocks.*"
 	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
 	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
 	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#" \
 	    -e "s#$warn4#Intentional warnings in xfs_file_aio_read#" \
-	    -e "s#$warn5#Intentional warnings in iomap_dio_rw#"
+	    -e "s#$warn5#Intentional warnings in iomap_dio_rw#" \
+	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#"
 }
-- 
1.8.3.1



