Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8AMhsdk246577 for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 17:43:54 -0500
Received: from manchester.citi.umich.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE884441314
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 15:45:02 -0700 (PDT)
Received: from manchester.citi.umich.edu (manchester.citi.umich.edu
	[141.212.112.29]) by cuda.sgi.com with ESMTP id
	fbhri9KbN3Y8L6pa for <xfs@oss.sgi.com>;
	Thu, 10 Sep 2009 15:45:02 -0700 (PDT)
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [PATCH] xfs_df: a df(1)-like command to list per-ag block and inode
	usage
Date: Thu, 10 Sep 2009 18:46:26 -0400
Message-Id: <1252622786-7653-1-git-send-email-jeffpc@josefsipek.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
---
 db/Makefile  |    3 +-
 db/xfs_df.sh |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 146 insertions(+), 1 deletions(-)
 create mode 100755 db/xfs_df.sh

diff --git a/db/Makefile b/db/Makefile
index 93ab040..96f220e 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
 	text.h type.h write.h attrset.h
 CFILES = $(HFILES:.h=.c)
-LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
+LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh xfs_df.sh
 LSRCFILES += xfs_check64.sh xfs_ncheck64.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
@@ -42,4 +42,5 @@ install: default
 	$(INSTALL) -m 755 xfs_check.sh $(PKG_BIN_DIR)/xfs_check
 	$(INSTALL) -m 755 xfs_ncheck.sh $(PKG_BIN_DIR)/xfs_ncheck
 	$(INSTALL) -m 755 xfs_metadump.sh $(PKG_BIN_DIR)/xfs_metadump
+	$(INSTALL) -m 755 xfs_df.sh $(PKG_BIN_DIR)/xfs_df
 install-dev:
diff --git a/db/xfs_df.sh b/db/xfs_df.sh
new file mode 100755
index 0000000..27840ac
--- /dev/null
+++ b/db/xfs_df.sh
@@ -0,0 +1,144 @@
+#!/bin/sh
+#
+# Copyright (c) 2007-2009 Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License version 2 as published
+# by the Free Software Foundation.
+#
+
+status=0
+DB_OPTS="-p xfs_df -r"
+USAGE="Usage: xfs_df [-i] <device>|<mount>"
+
+while test $# -gt 1; do
+	case "$1" in
+		-i)
+			print_inodes=t
+			;;
+		*)
+			break
+			;;
+	esac
+	shift
+done
+
+dev="$1"
+
+if [ -z "$dev" -o $# -ne 1 ]; then
+	echo $USAGE 2>&1
+	exit 1
+fi
+
+if [ -d "$dev" ]; then
+	# it's a dir => assume mountpoint
+
+	mnt=`echo "$dev" | sed -e 's,/$,,'`
+	[ "$dev" = "/" ] && mnt="/"
+
+	fdev=`awk -v "mnt=$mnt" '
+	($2 == mnt && $3 == "xfs") { print $1; exit }
+	' < /proc/mounts`
+
+	if [ -z "$fdev"  ]; then
+		echo "\"$dev\" looks like a mountpoint, but is not mounted as xfs"
+		exit 2
+	fi
+
+	dev="$fdev"
+elif [ -b "$dev" -o -f "$dev" ] ; then
+	# just use the path specified
+	true
+else
+	# ???
+	echo "\"$dev\" is not a device or mountpoint"
+	exit 3
+fi
+
+abort()
+{
+	echo "Error executing xfs_db" >&2
+	exit 4
+}
+
+db_wrapper()
+{
+	tmp=`xfs_db $DB_OPTS "$@" "$dev"`
+	status=$?
+	[ $status -ne 0 ] && abort
+	echo "$tmp" | awk '{print $3}'
+}
+
+agcount=`db_wrapper -c 'sb 0' -c 'p agcount'`
+blocksize=`db_wrapper -c 'sb 0' -c 'p blocksize'`
+
+maxagno=`expr $agcount - 1`
+
+echo "$dev:"
+
+case "$print_inodes" in
+	t)
+		echo "AG     Inodes    IUsed    IFree    Use%"
+
+		tot_ino=0
+		tot_use=0
+		tot_fre=0
+
+		for ag in `seq 0 $maxagno`; do
+			count=`db_wrapper -c "agi $ag" -c "p count"`
+			freecount=`db_wrapper -c "agi $ag" -c "p freecount"`
+
+			used=`expr $count - $freecount`
+
+			if [ $count -gt 0 ]; then
+				pused=`expr $used \* 100`
+				pused=`expr $pused / $count`
+			else
+				pused=0
+			fi
+
+			tot_ino=`expr $tot_ino + $count`
+			tot_use=`expr $tot_use + $used`
+			tot_fre=`expr $tot_fre + $freecount`
+
+			printf "%3d  %8d %8d %8d    %3d%%\n" $ag $count $used $freecount $pused
+		done
+
+		pused=`expr $tot_use \* 100`
+		pused=`expr $pused / $tot_ino`
+		printf "ALL  %8d %8d %8d    %3d%%\n" $tot_ino $tot_use $tot_fre $pused
+		;;
+	*)
+		echo "AG     1K-blocks         Used    Available    Use%"
+
+		tot_blo=0
+		tot_use=0
+		tot_ava=0
+
+		for ag in `seq 0 $maxagno`; do
+			length=`db_wrapper -c "agf $ag" -c "p length"`
+			freeblks=`db_wrapper -c "agf $ag" -c "p freeblks"`
+
+			displen=`expr $length \* $blocksize`
+			displen=`expr $displen / 1024`
+
+			dispfree=`expr $freeblks \* $blocksize`
+			dispfree=`expr $dispfree / 1024`
+
+			dispused=`expr $displen - $dispfree`
+
+			pused=`expr $dispused \* 100`
+			pused=`expr $pused / $displen`
+
+			tot_blo=`expr $tot_blo + $displen`
+			tot_use=`expr $tot_use + $dispused`
+			tot_ava=`expr $tot_ava + $dispfree`
+
+			printf "%3d   %10d   %10d   %10d    %3d%%\n" $ag $displen $dispused $dispfree $pused
+		done
+
+		pused=`expr $tot_use \* 100`
+		pused=`expr $pused / $tot_blo`
+		printf "ALL   %10d   %10d   %10d    %3d%%\n" $tot_blo $tot_use $tot_ava $pused
+		;;
+esac
-- 
1.6.0.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
