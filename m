Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40280 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730441AbeGZXKn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jul 2018 19:10:43 -0400
Date: Thu, 26 Jul 2018 14:51:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: add debian initramfs hook to package
Message-ID: <20180726215154.GI30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In Debian bug 904086, the reporter complained that xfs_repair wasn't
present in the initramfs, which prevented him from using shutdown -F to
force a filesystem fsck after a reboot.  Add a hook to put the xfs
utilities in the initramfs if xfs is the root filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/local/initramfs.hook |   47 +++++++++++++++++++++++++++++++++++++++++++
 debian/rules                |    1 +
 2 files changed, 48 insertions(+)
 create mode 100644 debian/local/initramfs.hook

diff --git a/debian/local/initramfs.hook b/debian/local/initramfs.hook
new file mode 100644
index 00000000..20df5d69
--- /dev/null
+++ b/debian/local/initramfs.hook
@@ -0,0 +1,47 @@
+#!/bin/sh
+
+# Put XFS utilities in initramfs if the root fs is XFS.
+
+PREREQ=""
+
+prereqs()
+{
+	echo "$PREREQ"
+}
+
+case $1 in
+prereqs)
+	prereqs
+	exit 0
+	;;
+esac
+
+fstab_files()
+{
+	echo /etc/fstab
+	if [ -d /etc/fstab.d ]; then
+		ls -1 /etc/fstab.d | grep '\.fstab$' | sed -e 's;^;/etc/fstab.d/;'
+	fi
+}
+
+rootfs_type() {
+	fstab_files | while read file; do
+		test ! -f "$file" && continue
+
+		while read MNT_FSNAME MNT_DIR MNT_TYPE MNT_OPTS MNT_FREQ MNT_PASS MNT_JUNK; do
+			test "$MNT_DIR" != "/" && continue
+			echo "$MNT_TYPE"
+			break;
+		done < "$file"
+	done
+}
+
+. /usr/share/initramfs-tools/scripts/functions
+. /usr/share/initramfs-tools/hook-functions
+
+if [ "$(rootfs_type)" = "xfs" ]; then
+	copy_exec /sbin/xfs_repair
+	copy_exec /usr/sbin/xfs_db
+	copy_exec /usr/sbin/xfs_metadump
+fi
+exit 0
diff --git a/debian/rules b/debian/rules
index cb4fa22c..4c50654c 100755
--- a/debian/rules
+++ b/debian/rules
@@ -77,6 +77,7 @@ binary-arch: checkroot built
 	$(pkgdev) $(MAKE) -C . install-dev
 	$(pkgdi)  $(MAKE) -C debian install-d-i
 	$(pkgme)  $(MAKE) dist
+	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
 	rm -f debian/xfslibs-dev/lib/libhandle.la
 	rm -fr debian/xfslibs-dev/usr/lib
