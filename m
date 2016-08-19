Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA3137CA2
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 12:51:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F857AC004
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 10:51:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uAogkGNEgfuFrEAy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Aug 2016 10:51:50 -0700 (PDT)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH 1/2] common/rc: add functions to check or write objects under
	/sys/fs/$FSTYP
Date: Sat, 20 Aug 2016 01:51:44 +0800
Message-Id: <1471629105-13359-1-git-send-email-zlang@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

XFS add more configurations in /sys/fs/xfs recently. For use
them, this patch add some common functions for:
  1. "require" a file/dir in /sys/fs/${FSTYP}.
  2. write a file in /sys/fs/${FSTYP}.

For common use, these functions can be used by other filesystems.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 common/rc | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/common/rc b/common/rc
index 51092a0..d5edfef 100644
--- a/common/rc
+++ b/common/rc
@@ -3556,6 +3556,48 @@ run_fsx()
 	fi
 }
 
+# Test for the existence of a sysfs entry at /sys/fs/$FSTYP/$DEV/$ENTRY
+_require_fs_sysfs()
+{
+	local dev=$1
+	local entry=$2
+	local tmp_mnt=`mktemp -d`
+
+	if [ ! -b "$dev" -o -z "$entry" ];then
+		_fail "Usage: _require_fs_sysfs <device> <sysfs_path>"
+        fi
+
+	local dname=$(_short_dev $dev)
+	_mount -t $FSTYP `_common_dev_mount_options` $dev $tmp_mnt
+	if [ $? -ne 0 ];then
+		rm -f $tmp_mnt
+		_fail "_require_fs_sysfs: could not mount, mkfs first in your test?"
+	elif [ ! -e /sys/fs/${FSTYP}/${dname}/${entry} ];then
+		$UMOUNT_PROG $tmp_mnt
+		rm -f $tmp_mnt
+		_notrun "/sys/fs/${FSTYP}/${dname}/${entry}: No such file or directory"
+	fi
+	$UMOUNT_PROG $tmp_mnt
+	rm -rf $tmp_mnt
+}
+
+# Write "content" into /sys/fs/$FSTYP/$DEV/$ENTRY
+_set_fs_sysfs_param()
+{
+	local dev=$1
+	shift
+	local entry=$1
+	shift
+	local content="$*"
+
+	if [ ! -b "$dev" -o -z "$entry" -o -z "$content" ];then
+		_fail "Usage: _set_sys_fs_param <mounted_device> <entry> <content>"
+	fi
+
+	local dname=$(_short_dev $dev)
+	echo "$content" > /sys/fs/${FSTYP}/${dname}/${entry}
+}
+
 init_rc
 
 ################################################################################
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
