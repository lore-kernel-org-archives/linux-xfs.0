Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F6A57F37
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 10:49:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C28030404E
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 08:49:33 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id OeLHiQeTcS2cH9oB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 08:49:31 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 63D939A0320
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 09:49:31 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: check if the scratch dev pool is mounted in
	_require_scratch
Date: Wed, 26 Jun 2013 11:49:28 -0400
Message-ID: <1372261768-1795-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

If you use the SCRATCH_DEV_POOL for btrfs you will end up with the command line
like this

mkfs.btrfs $SCRATCH_DEV_POOL $SCRATCH_DEV

and btrfs does this thing where it makes the lowest valued device id show up in
/proc/mounts no matter which device you specify at the mount command.  So in
this case mount will show the first device in $SCRATCH_DEV_POOL instead of
$SCRATCH_DEV, so anybody who wants to just use the scratch mnt with the scratch
dev will fail to work because we never unmount the scratch mount.  Fix this by
checking to see if the scratch dev pool is mounted at scratch mnt and unmount it
so we can run our test.  This fixes the issue I was seeing by running

./check btrfs/307 generic/015

Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 common/rc |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/common/rc b/common/rc
index ad7cbc9..7e03400 100644
--- a/common/rc
+++ b/common/rc
@@ -938,6 +938,8 @@ _supported_os()
 #
 _require_scratch()
 {
+    local i
+
     case "$FSTYP" in
 	nfs*)
 		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
@@ -978,6 +980,17 @@ _require_scratch()
             exit 1
         fi
     fi
+
+    # we may have a scratch dev pool specified, so make sure it's been unmounted
+    # from the scratch mount
+    for i in $SCRATCH_DEV_POOL; do
+        if _mount | grep $i | grep -q $SCRATCH_MNT; then
+            if ! $UMOUNT_PROG $i; then
+                echo "failed to umount $i - aborting"
+                exit 1
+            fi
+        fi
+    done
 }
 
 # this test needs a logdev
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
