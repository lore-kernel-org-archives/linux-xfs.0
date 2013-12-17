Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F23187F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:18:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C98C0304053
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:54 -0800 (PST)
Received: from mail-yh0-f74.google.com (mail-yh0-f74.google.com
	[209.85.213.74]) by cuda.sgi.com with ESMTP id L2tswDfP8ipffoRD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:53 -0800 (PST)
Received: by mail-yh0-f74.google.com with SMTP id a41so667378yho.3
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:53 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v2 02/12] xfstests: _scratch_mkfs_sized() for tmpfs
Date: Tue, 17 Dec 2013 14:18:32 -0800
Message-Id: <1387318722-3050-2-git-send-email-jayr@google.com>
In-Reply-To: <1387318722-3050-1-git-send-email-jayr@google.com>
References: <1387318722-3050-1-git-send-email-jayr@google.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

From: Hugh Dickins <hughd@google.com>

_scratch_mkfs_sized() avoid blockdev and update MOUNT_OPTIONS with
required size on tmpfs, so those tests using it can now run.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Junho Ryu <jayr@google.com>
---

v2: same as v1

 common/rc | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index a2005c9..c78356e 100644
--- a/common/rc
+++ b/common/rc
@@ -590,7 +590,7 @@ _scratch_mkfs_sized()
 
     blocks=`expr $fssize / $blocksize`
 
-    if [ "$HOSTOS" == "Linux" ]; then
+    if [ "$HOSTOS" == "Linux" -a -d "$SCRATCH_DEV" ]; then
 	devsize=`blockdev --getsize64 $SCRATCH_DEV`
 	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
     fi
@@ -611,6 +611,9 @@ _scratch_mkfs_sized()
     btrfs)
 	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
 	;;
+    tmpfs)
+	export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
+	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
 	;;
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
