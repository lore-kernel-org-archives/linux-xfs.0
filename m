Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60194 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751587AbdKBINq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 04:13:46 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3] common: Check for fiemap range argument support
Date: Thu,  2 Nov 2017 10:13:41 +0200
Message-Id: <1509610421-16716-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20171102031622.GV17339@eguan.usersys.redhat.com>
References: <20171102031622.GV17339@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Nikolay Borsiov <nborisov@suse.com>

From: Nikolay Borsiov <nborisov@suse.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
v3:
 * Changed the way we detect ranged args. Now use a regexp which checks 
 explicitly for the ranged args
 common/rc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/rc b/common/rc
index e2a8229..f7a5fe9 100644
--- a/common/rc
+++ b/common/rc
@@ -2053,8 +2053,15 @@ _require_xfs_io_command()
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
 	"fiemap")
+		if echo "$param" | egrep -q "[[:digit:]]+[bskmgtpe]? [[:digit:]]+[bskmgtpe]?$"
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

