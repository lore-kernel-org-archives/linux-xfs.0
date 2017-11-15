Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46155 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757642AbdKOMLo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Nov 2017 07:11:44 -0500
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 2/3] common: Implement fiemap's range query check
Date: Wed, 15 Nov 2017 14:11:39 +0200
Message-Id: <1510747900-13440-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1510747900-13440-1-git-send-email-nborisov@suse.com>
References: <1510747821-13270-1-git-send-email-nborisov@suse.com>
 <1510747900-13440-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, david@fromorbit.com, darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

Allow for users of xfstest to assert the presence of fiemap's
range query capabilities by requesting the "ranged" parameter.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 common/rc | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/common/rc b/common/rc
index e2a8229..c98c224 100644
--- a/common/rc
+++ b/common/rc
@@ -2053,6 +2053,12 @@ _require_xfs_io_command()
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
 	"fiemap")
+		if echo "$param" | grep -q "ranged"; then
+			param=$(echo "$param" | sed "s/ranged//")
+			$XFS_IO_PROG -F -f -c "pwrite 0 5k" -c "fsync" $testfile > /dev/null 2>&1
+			lines=$($XFS_IO_PROG -c "fiemap 6k" $testfile 2>&1 | wc -l)
+			[ $lines -eq 1 ] || _notrun "xfs_io $command ranged support is missing"
+		fi
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "fiemap -v $param" $testfile 2>&1`
 		param_checked=1
-- 
2.7.4

