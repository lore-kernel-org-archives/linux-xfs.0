Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753083AbdJaOMb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 10:12:31 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 1/4] common: Check for fiemap range argument support
Date: Tue, 31 Oct 2017 16:11:33 +0200
Message-Id: <1509459096-7585-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1509459011-7398-1-git-send-email-nborisov@suse.com>
References: <1509459011-7398-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, darrick.wong@oracle.com, eguan@redhat.com, Nikolay Borisov <nborisov@suse.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 common/rc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/rc b/common/rc
index e2a8229..673f9ef 100644
--- a/common/rc
+++ b/common/rc
@@ -2053,8 +2053,15 @@ _require_xfs_io_command()
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
 	"fiemap")
+		if [ ! -z "$param" ]
+		then
+			$XFS_IO_PROG -c "help fiemap" | head -n 1 | grep -q "[offset [len]]" || \
+				_notrun "xfs_io $command range param support is missing"
+		fi
+
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "fiemap -v $param" $testfile 2>&1`
+
 		param_checked=1
 		;;
 	"flink" )
-- 
2.7.4

