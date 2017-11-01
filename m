Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43287 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934228AbdKAVrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:13 -0400
Subject: [PATCH 06/14] generic/459: fix test running errors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:05 -0700
Message-ID: <150957282558.18388.6902634185939837201.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the DISCARD of the thin device somehow fails with this message:

device-mapper: thin: Data device (dm-1) discard unsupported: Disabling discard passdown.

Then we can end up with arbitrary gunk in the thin device.  This causes
mkfs to fail because it's afraid to format the device.  Don't be afraid,
just zap it.  FWIW mkfs.xfs thinks that the thinp device has an xfs
external log because sometimes the thinp device just happen to be backed
by the log of the previous test's scratch fs.

Fix this by making the _mkfs_dev helper always format the device, per
Eryu Guan's suggestion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index 7e453e0..c441199 100644
--- a/common/rc
+++ b/common/rc
@@ -642,7 +642,10 @@ _mkfs_dev()
 	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* \
 		2>$tmp.mkfserr 1>$tmp.mkfsstd
 	;;
-
+    xfs)
+	yes | $MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* \
+		2>$tmp.mkfserr 1>$tmp.mkfsstd
+	;;
     *)
 	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* \
 		2>$tmp.mkfserr 1>$tmp.mkfsstd

