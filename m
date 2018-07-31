Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbeGaHT7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 03:19:59 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2 2/2] xfs/288: _notrun if xfs_db can't write values into dir or attr
Date: Tue, 31 Jul 2018 13:41:19 +0800
Message-Id: <20180731054119.13539-2-zlang@redhat.com>
In-Reply-To: <20180731054119.13539-1-zlang@redhat.com>
References: <20180731054119.13539-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, yangx.jy@cn.fujitsu.com

Commit b3cf8b72334fd35ef961869506e5a72ab398bc82 help xfs/288 to
support v5 filesystems testing, but there're still some old
distributions don't support xfs_db write '-d' option, or can't
write values into dir/attr of v5 filesystems.

For compatible with older versions, skip this test on v5 xfs
if xfs_db write can't write v5 XFS dir/attr.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

Xiao found v1 can't work well on xfsprogs-4.9, due to 'write -d' can't
write vaules into dir/attr of v5 filesystems before xfsprogs-4.13.

Only check "if write command has -d option" is not enough. So I write
a function _require_xfs_db_write_da() to make sure current xfs_db
can write dir/attr (not only on v5, but especially for v5).

Thanks,
Zorro

 common/xfs    | 28 ++++++++++++++++++++++++++++
 tests/xfs/288 |  1 +
 2 files changed, 29 insertions(+)

diff --git a/common/xfs b/common/xfs
index d971b4a8..95dcfd59 100644
--- a/common/xfs
+++ b/common/xfs
@@ -720,6 +720,34 @@ _require_xfs_db_write_array()
 	[ $supported -eq 0 ] && _notrun "xfs_db write can't support array"
 }
 
+# Before xfsprogs commit 89baf918(xfs_db: write values into dir/attr blocks and
+# recalculate CRCs), xfs_db write command can't write invalid data into dir/attr
+# field of v5 filesystems. For some cases need to write dir/attr (especially crc
+# enabled), use this _require at first.
+_require_xfs_db_write_da()
+{
+	local inum
+	local count
+
+	_require_scratch
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+	mkdir $SCRATCH_MNT/$seq.dir
+	inum=$(stat -c '%i' $SCRATCH_MNT/$seq.dir)
+	$SETFATTR_PROG -n "user.testda" \
+		       -v "$(perl -e "print 'v' x 65536;")" \
+		       $SCRATCH_MNT/$seq.dir
+	_scratch_unmount
+	_scratch_xfs_set_metadata_field "hdr.count" "0" \
+					"inode $inum" "ablock 0" >/dev/null 2>&1
+	count=$(_scratch_xfs_get_metadata_field "hdr.count" \
+						"inode $inum" "ablock 0")
+	if [ "$count" != "0" ]; then
+		_notrun "xfs_db write can't write values into dir/attr blocks"
+	fi
+}
+
 _require_xfs_spaceman_command()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/xfs/288 b/tests/xfs/288
index f4165b6c..e9589fd5 100755
--- a/tests/xfs/288
+++ b/tests/xfs/288
@@ -35,6 +35,7 @@ _supported_fs xfs
 _supported_os Linux
 _require_scratch
 _require_attrs
+_require_xfs_db_write_da
 
 # get block size ($dbsize) from the mkfs output
 _scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
-- 
2.14.4

