Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751311AbeCEPGD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Mar 2018 10:06:03 -0500
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Date: Mon,  5 Mar 2018 16:05:46 +0100
Message-Id: <20180305150546.32191-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, Jan Tulak <jtulak@redhat.com>

The fsck.xfs script did nothing, because xfs doesn't need a fsck to be
run on every unclean shutdown. However, sometimes it may happen that the
root filesystem really requires the usage of xfs_repair and then it is a
hassle. This patch makes the situation a bit easier by detecting forced
checks (/forcefsck or fsck.mode=force), so user can require the repair,
without the repair being run all the time.

(Thanks Eric for suggesting this.)

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fsck/xfs_fsck.sh | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index e52969e4..71bfa2e1 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -4,10 +4,12 @@
 #
 
 AUTO=false
-while getopts ":aApy" c
+FORCE=false
+while getopts ":aApyf" c
 do
 	case $c in
 	a|A|p|y)	AUTO=true;;
+	f)      	FORCE=true;;
 	esac
 done
 eval DEV=\${$#}
@@ -15,10 +17,18 @@ if [ ! -e $DEV ]; then
 	echo "$0: $DEV does not exist"
 	exit 8
 fi
+
+# The flag -f is added by systemd/init scripts when /forcefsck file is present
+# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
+# this check, user has to explicitly require a forced fsck.
+if $FORCE; then
+	xfs_repair $DEV
+	exit $?
+fi
+
 if $AUTO; then
 	echo "$0: XFS file system."
 else
 	echo "If you wish to check the consistency of an XFS filesystem or"
 	echo "repair a damaged filesystem, see xfs_repair(8)."
 fi
-exit 0
-- 
2.15.0

