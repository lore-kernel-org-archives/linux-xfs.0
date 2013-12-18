Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CBCA47F4E
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B02C230406A
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:07 -0800 (PST)
Received: from mail-ob0-f201.google.com (mail-ob0-f201.google.com
	[209.85.214.201]) by cuda.sgi.com with ESMTP id
	CgI5YKCF5USiCTo8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 10:16:06 -0800 (PST)
Received: by mail-ob0-f201.google.com with SMTP id wp4so1990obc.2
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:06 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 02/12] xfstests: _scratch_mkfs_sized() for tmpfs
Date: Wed, 18 Dec 2013 10:15:53 -0800
Message-Id: <1387390563-27064-2-git-send-email-jayr@google.com>
In-Reply-To: <1387390563-27064-1-git-send-email-jayr@google.com>
References: <1387390563-27064-1-git-send-email-jayr@google.com>
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

v3: use -b to check whether SCRATCH_DEV is a block device

v2: check whether SCRATCH_DEV is a block device instead of checking FSTYP

 common/rc | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index a2005c9..bfd29c7 100644
--- a/common/rc
+++ b/common/rc
@@ -590,7 +590,7 @@ _scratch_mkfs_sized()
 
     blocks=`expr $fssize / $blocksize`
 
-    if [ "$HOSTOS" == "Linux" ]; then
+    if [ "$HOSTOS" == "Linux" -a -b "$SCRATCH_DEV" ]; then
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
