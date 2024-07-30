Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6AF1854;
	Tue, 30 Jul 2024 03:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309803; cv=none; b=qbyYEznYuuV0L7z8NWOzW0RXMNxMEhQYsqggJzNvKY+aVZxIyiRWHd/8NtL8wEXpHmXY8Mw4OeIjF/Ajml9BKQDGsYk2vRr1WcL7d6UqvwD3I1RGn4/MtpMrT0h8WZefEAxE2iBAgopyyS7b9GhtlV/IFfTNb20b6s/VyrIdjig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309803; c=relaxed/simple;
	bh=EiUmXcegWCQ/oxouRvCrEAd1h8usyBAYcgkGMDxzcKA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g3zfEl+41MPRvIJSfIVjzY7KeiUxz9pPt872EEzv8mjQ/Zi8YS7vBbPVezg3wyJJOjs7EcBkLyMFSeJAcSC91SlZS95YwsgviAP55nXpUDlL2PZNs0u5fiE7OxnL8q+qVux7E+kQr62si/bJPK1FkL1lfF2TcC7/GuiNFoi2P+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gs8jcojq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gs8jcojq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F378C32786;
	Tue, 30 Jul 2024 03:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309803;
	bh=EiUmXcegWCQ/oxouRvCrEAd1h8usyBAYcgkGMDxzcKA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gs8jcojqg45YcdwiPe3uIv5atEzwQaFe+R7EvcGQhvBZX4xfDoojWb/1xcXZtLJRd
	 XD5Degx30qL0yU7sn6RvztO8s3FP5usnmDOu1zFHNgBAWwsoHbeuLKSa45JmZAwswv
	 HtKjnW5FTsomKXcOOisFUrVJuViYYgQ6GNOjPrqJIBVhr9FGQrOVaNrGoicYl3JdI4
	 9T2F+YVt2DeTp+lNz1ET8ZCfC2Ce1hq1pY3XF9V8rtu+UHIea8LcasL3F5IMcMiKbR
	 DXBiQc5I9LvyTdMZkeF3+vr6yYYeYST4bqLyrDlstBo8jh0/vNr+7soj8HtR3uJF/1
	 AU20qNJXMz/vQ==
Date: Mon, 29 Jul 2024 20:23:22 -0700
Subject: [PATCH 1/1] xfs: functional testing for filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172230948310.1545890.8726821368029925154.stgit@frogsfrogsfrogs>
In-Reply-To: <172230948293.1545890.16907565259543283790.stgit@frogsfrogsfrogs>
References: <172230948293.1545890.16907565259543283790.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that fs property storage and retrieval actually work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/config      |    1 
 common/xfs         |    4 +-
 tests/xfs/1886     |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1886.out |   53 ++++++++++++++++++++
 tests/xfs/1887     |  124 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1887.out |   46 ++++++++++++++++++
 tests/xfs/1888     |   66 +++++++++++++++++++++++++
 tests/xfs/1888.out |    9 +++
 tests/xfs/1889     |   67 ++++++++++++++++++++++++++
 tests/xfs/1889.out |    9 +++
 10 files changed, 512 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1886
 create mode 100644 tests/xfs/1886.out
 create mode 100755 tests/xfs/1887
 create mode 100644 tests/xfs/1887.out
 create mode 100755 tests/xfs/1888
 create mode 100644 tests/xfs/1888.out
 create mode 100755 tests/xfs/1889
 create mode 100644 tests/xfs/1889.out


diff --git a/common/config b/common/config
index 22740c0af8..07bd2cf315 100644
--- a/common/config
+++ b/common/config
@@ -234,6 +234,7 @@ export GZIP_PROG="$(type -P gzip)"
 export BTRFS_IMAGE_PROG="$(type -P btrfs-image)"
 export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
 export PARTED_PROG="$(type -P parted)"
+export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/xfs b/common/xfs
index bd40a02ed2..a642646345 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1318,8 +1318,8 @@ _require_xfs_spaceman_command()
 	testfile=$TEST_DIR/$$.xfs_spaceman
 	touch $testfile
 	case $command in
-	"health")
-		testio=`$XFS_SPACEMAN_PROG -c "health $param" $TEST_DIR 2>&1`
+	"health"|"listfsprops")
+		testio=`$XFS_SPACEMAN_PROG -c "$command $param" $TEST_DIR 2>&1`
 		param_checked=1
 		;;
 	*)
diff --git a/tests/xfs/1886 b/tests/xfs/1886
new file mode 100755
index 0000000000..eca76f51d6
--- /dev/null
+++ b/tests/xfs/1886
@@ -0,0 +1,135 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1886
+#
+# Functional testing for low level filesystem property manipulation by
+# xfs_{spaceman,db}.
+#
+. ./common/preamble
+_begin_fstest auto
+
+. ./common/filter
+. ./common/attr
+
+_require_test
+_require_user fsgqa
+_require_attrs
+_require_xfs_spaceman_command listfsprops
+_require_xfs_db_command attr_list
+
+_cleanup()
+
+{
+	cd /
+	rm -r -f $tmp.*
+	rm -f $TEST_DIR/$seq.somefile
+	rm -r -f $TEST_DIR/$seq.somedir
+}
+
+filter_inum()
+{
+	sed -e 's/inode [0-9]*/inode XXX/g'
+}
+
+propname="fakeproperty"	# must not be an actual property
+propval="1721943740"
+longpropname="$(perl -e 'print "x" x 300;')"
+longpropval="$(perl -e 'print "x" x 80000;')"
+
+echo "*** SPACEMAN TEST ***"
+
+echo empty get property
+$XFS_SPACEMAN_PROG -c "getfsprops $propname" $TEST_DIR
+
+echo pointless remove property
+$XFS_SPACEMAN_PROG -c "removefsprops $propname" $TEST_DIR
+
+echo list property
+$XFS_SPACEMAN_PROG -c "listfsprops" $TEST_DIR | grep $propname
+
+echo set property
+$XFS_SPACEMAN_PROG -c "setfsprops $propname=$propval" $TEST_DIR
+
+echo list property
+$XFS_SPACEMAN_PROG -c "listfsprops" $TEST_DIR | grep $propname
+
+echo dump xattrs
+$ATTR_PROG -R -l $TEST_DIR | | grep $propname | _filter_test_dir
+
+echo get property
+$XFS_SPACEMAN_PROG -c "getfsprops $propname" $TEST_DIR
+
+echo list property
+$XFS_SPACEMAN_PROG -c "listfsprops" $TEST_DIR | grep $propname
+
+echo child file rejected
+touch $TEST_DIR/$seq.somefile
+$XFS_SPACEMAN_PROG -c "listfsprops $propname" $TEST_DIR/$seq.somefile 2>&1 | \
+	_filter_test_dir
+
+echo child dir accepted
+mkdir -p $TEST_DIR/$seq.somedir
+$XFS_SPACEMAN_PROG -c "listfsprops $propname" $TEST_DIR/$seq.somedir | grep $propname
+
+echo remove property
+$XFS_SPACEMAN_PROG -c "removefsprops $propname" $TEST_DIR
+
+echo pointless remove property
+$XFS_SPACEMAN_PROG -c "removefsprops $propname" $TEST_DIR
+
+echo set too long name
+$XFS_SPACEMAN_PROG -c "setfsprops $longpropname=$propval" $TEST_DIR
+
+echo set too long value
+$XFS_SPACEMAN_PROG -c "setfsprops $propname=$longpropval" $TEST_DIR
+
+echo not enough permissions
+su - "$qa_user" -c "$XFS_SPACEMAN_PROG -c \"setfsprops $propname=$propval\" $TEST_DIR" 2>&1 | _filter_test_dir
+
+echo "*** DB TEST ***"
+
+propval=$((propval + 1))
+_test_unmount
+
+echo empty get property
+_test_xfs_db -x -c 'path /' -c "attr_get -Z $propname" 2>&1 | filter_inum
+
+echo pointless remove property
+_test_xfs_db -x -c 'path /' -c "attr_remove -Z $propname" 2>&1 | filter_inum
+
+echo list property
+_test_xfs_db -x -c 'path /' -c "attr_list -Z" | grep $propname
+
+echo set property
+_test_xfs_db -x -c 'path /' -c "attr_set -Z $propname $propval"
+
+echo list property
+_test_xfs_db -x -c 'path /' -c "attr_list -Z" | grep $propname
+
+echo dump xattrs
+_test_mount
+$ATTR_PROG -R -l $TEST_DIR | grep $propname | _filter_test_dir
+_test_unmount
+
+echo get property
+_test_xfs_db -x -c 'path /' -c "attr_get -Z $propname"
+
+echo list property
+_test_xfs_db -x -c 'path /' -c "attr_list -Z" | grep $propname
+
+echo remove property
+_test_xfs_db -x -c 'path /' -c "attr_remove -Z $propname"
+
+echo pointless remove property
+_test_xfs_db -x -c 'path /' -c "attr_remove -Z $propname" 2>&1 | filter_inum
+
+echo set too long name
+_test_xfs_db -x -c 'path /' -c "attr_set -Z $longpropname $propval"
+
+echo set too long value
+_test_xfs_db -x -c 'path /' -c "attr_set -Z $propname $longpropval"
+
+status=0
+exit
diff --git a/tests/xfs/1886.out b/tests/xfs/1886.out
new file mode 100644
index 0000000000..2f05c8b7c5
--- /dev/null
+++ b/tests/xfs/1886.out
@@ -0,0 +1,53 @@
+QA output created by 1886
+*** SPACEMAN TEST ***
+empty get property
+fakeproperty: No data available
+pointless remove property
+fakeproperty: No data available
+list property
+set property
+fakeproperty=1721943740
+list property
+fakeproperty
+dump xattrs
+Attribute "xfs:fakeproperty" has a 10 byte value for TEST_DIR
+get property
+fakeproperty=1721943740
+list property
+fakeproperty
+child file rejected
+TEST_DIR/1886.somefile: Not a directory
+child dir accepted
+fakeproperty
+remove property
+pointless remove property
+fakeproperty: No data available
+set too long name
+xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: Invalid argument
+set too long value
+fakeproperty: Invalid argument
+not enough permissions
+TEST_DIR: Operation not permitted
+*** DB TEST ***
+empty get property
+failed to get attr xfs:fakeproperty on inode XXX: No data available
+pointless remove property
+failed to remove attr xfs:fakeproperty from inode XXX: No data available
+list property
+set property
+fakeproperty=1721943741
+list property
+fakeproperty
+dump xattrs
+Attribute "xfs:fakeproperty" has a 10 byte value for TEST_DIR
+get property
+fakeproperty=1721943741
+list property
+fakeproperty
+remove property
+pointless remove property
+failed to remove attr xfs:fakeproperty from inode XXX: No data available
+set too long name
+name too long
+set too long value
+xfs:fakeproperty: value too long
diff --git a/tests/xfs/1887 b/tests/xfs/1887
new file mode 100755
index 0000000000..fe75abe2c5
--- /dev/null
+++ b/tests/xfs/1887
@@ -0,0 +1,124 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1887
+#
+# Functional testing for xfs_property the wrapper script.
+#
+. ./common/preamble
+_begin_fstest auto
+
+. ./common/filter
+. ./common/attr
+
+_require_test
+_require_attrs
+
+# XXX yeah
+test -z "$XFS_PROPERTY_PROG" && \
+	XFS_PROPERTY_PROG="$(type -P xfs_property.sh)"
+
+_require_command "$XFS_PROPERTY_PROG" xfs_property
+_require_xfs_spaceman_command listfsprops	# actually detect support
+
+_cleanup()
+
+{
+	cd /
+	rm -r -f $tmp.*
+}
+
+filter_inum()
+{
+	sed -e 's/inode [0-9]*/inode XXX/g'
+}
+
+propname="fakeproperty"	# must not be an actual property
+propval="1721943742"
+longpropname="$(perl -e 'print "x" x 300;')"
+longpropval="$(perl -e 'print "x" x 80000;')"
+
+echo "*** OFFLINE XFS_PROPERTY TEST ***"
+
+_test_unmount
+
+echo empty get property
+$XFS_PROPERTY_PROG $TEST_DEV get "$propname" 2>&1 | filter_inum
+
+echo pointless remove property
+$XFS_PROPERTY_PROG $TEST_DEV remove "$propname" 2>&1 | filter_inum
+
+echo list property
+$XFS_PROPERTY_PROG $TEST_DEV list | grep $propname
+
+echo set property
+$XFS_PROPERTY_PROG $TEST_DEV set "$propname=$propval"
+
+echo list property
+$XFS_PROPERTY_PROG $TEST_DEV list | grep $propname
+
+echo dump xattrs
+$ATTR_PROG -R -l $TEST_DEV | grep $propname | _filter_test_dir
+
+echo get property
+$XFS_PROPERTY_PROG $TEST_DEV get "$propname"
+
+echo list property
+$XFS_PROPERTY_PROG $TEST_DEV list | grep $propname
+
+echo remove property
+$XFS_PROPERTY_PROG $TEST_DEV remove "$propname"
+
+echo pointless remove property
+$XFS_PROPERTY_PROG $TEST_DEV remove "$propname" 2>&1 | filter_inum
+
+echo set too long name
+$XFS_PROPERTY_PROG $TEST_DEV set "$longpropname=$propval"
+
+echo set too long value
+$XFS_PROPERTY_PROG $TEST_DEV set "$propname=$longpropval"
+
+echo "*** ONLINE XFS_PROPERTY TEST ***"
+
+propval=$((propval+1))
+_test_mount
+
+echo empty get property
+$XFS_PROPERTY_PROG $TEST_DIR get "$propname"
+
+echo pointless remove property
+$XFS_PROPERTY_PROG $TEST_DIR remove "$propname"
+
+echo list property
+$XFS_PROPERTY_PROG $TEST_DIR list | grep $propname
+
+echo set property
+$XFS_PROPERTY_PROG $TEST_DIR set "$propname=$propval"
+
+echo list property
+$XFS_PROPERTY_PROG $TEST_DIR list | grep $propname
+
+echo dump xattrs
+$ATTR_PROG -R -l $TEST_DIR | grep $propname | _filter_test_dir
+
+echo get property
+$XFS_PROPERTY_PROG $TEST_DIR get "$propname"
+
+echo list property
+$XFS_PROPERTY_PROG $TEST_DIR list | grep $propname
+
+echo remove property
+$XFS_PROPERTY_PROG $TEST_DIR remove "$propname"
+
+echo pointless remove property
+$XFS_PROPERTY_PROG $TEST_DIR remove "$propname"
+
+echo set too long name
+$XFS_PROPERTY_PROG $TEST_DIR set "$longpropname=$propval"
+
+echo set too long value
+$XFS_PROPERTY_PROG $TEST_DIR set "$propname=$longpropval"
+
+status=0
+exit
diff --git a/tests/xfs/1887.out b/tests/xfs/1887.out
new file mode 100644
index 0000000000..2c27206acf
--- /dev/null
+++ b/tests/xfs/1887.out
@@ -0,0 +1,46 @@
+QA output created by 1887
+*** OFFLINE XFS_PROPERTY TEST ***
+empty get property
+failed to get attr xfs:fakeproperty on inode XXX: No data available
+pointless remove property
+failed to remove attr xfs:fakeproperty from inode XXX: No data available
+list property
+set property
+fakeproperty=1721943742
+list property
+fakeproperty
+dump xattrs
+get property
+fakeproperty=1721943742
+list property
+fakeproperty
+remove property
+pointless remove property
+failed to remove attr xfs:fakeproperty from inode XXX: No data available
+set too long name
+name too long
+set too long value
+xfs:fakeproperty: value too long
+*** ONLINE XFS_PROPERTY TEST ***
+empty get property
+fakeproperty: No data available
+pointless remove property
+fakeproperty: No data available
+list property
+set property
+fakeproperty=1721943743
+list property
+fakeproperty
+dump xattrs
+Attribute "xfs:fakeproperty" has a 10 byte value for TEST_DIR
+get property
+fakeproperty=1721943743
+list property
+fakeproperty
+remove property
+pointless remove property
+fakeproperty: No data available
+set too long name
+xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: Invalid argument
+set too long value
+fakeproperty: Invalid argument
diff --git a/tests/xfs/1888 b/tests/xfs/1888
new file mode 100755
index 0000000000..8d54343cc2
--- /dev/null
+++ b/tests/xfs/1888
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1888
+#
+# Functional testing for mkfs applying self_healing fs property.
+#
+. ./common/preamble
+_begin_fstest auto
+
+. ./common/filter
+. ./common/attr
+
+_require_test
+_require_xfs_spaceman_command listfsprops	# needed for fs props
+_require_xfs_db_command attr_get
+
+_cleanup()
+
+{
+	cd /
+	rm -r -f $tmp.*
+	rm -f $dummyfile
+	rmdir $dummymnt
+}
+
+dummyfile=$TEST_DIR/$seq.somefile
+dummymnt=$TEST_DIR/$seq.mount
+
+truncate -s 10g $dummyfile
+mkdir -p $dummymnt
+
+filter_inum()
+{
+	sed -e 's/inode [0-9]*/inode XXX/g'
+}
+
+testme() {
+	local mkfs_args=('-f')
+	local value="$1"
+	test -n "$value" && value="=$value"
+
+	if [ $# -gt 0 ]; then
+		mkfs_args+=('-m' "self_healing$value")
+	fi
+
+	echo "testing ${mkfs_args[*]}" >> $seqres.full
+
+	$MKFS_XFS_PROG $MKFS_OPTIONS "${mkfs_args[@]}" $dummyfile >> $seqres.full || \
+		_notrun "mkfs.xfs ${mkfs_args[*]} failed?"
+
+	$XFS_DB_PROG -x -c 'path /' -c "attr_get -Z self_healing" $dummyfile 2>&1 | filter_inum
+}
+
+testme ''
+testme
+testme none
+testme check
+testme optimize
+testme repair
+testme 0
+testme 1
+
+status=0
+exit
diff --git a/tests/xfs/1888.out b/tests/xfs/1888.out
new file mode 100644
index 0000000000..d386d01b8f
--- /dev/null
+++ b/tests/xfs/1888.out
@@ -0,0 +1,9 @@
+QA output created by 1888
+self_healing=repair
+failed to get attr xfs:self_healing on inode XXX: No data available
+self_healing=none
+self_healing=check
+self_healing=optimize
+self_healing=repair
+self_healing=none
+self_healing=repair
diff --git a/tests/xfs/1889 b/tests/xfs/1889
new file mode 100755
index 0000000000..623f004631
--- /dev/null
+++ b/tests/xfs/1889
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1889
+#
+# Functional testing for mkfs applying self_healing fs property and xfs_scrub
+# changing its behavior accordingly.  Or at least claiming to.
+#
+. ./common/preamble
+_begin_fstest auto
+
+. ./common/filter
+. ./common/fuzzy
+
+_require_test
+_require_xfs_spaceman_command listfsprops	# needed for fs props
+_require_xfs_db_command attr_get
+_require_scrub
+
+_cleanup()
+
+{
+	cd /
+	rm -r -f $tmp.*
+	rm -f $dummyfile
+	_umount $dummymnt &>/dev/null
+	rmdir $dummymnt
+}
+
+dummyfile=$TEST_DIR/$seq.somefile
+dummymnt=$TEST_DIR/$seq.mount
+
+truncate -s 10g $dummyfile
+mkdir -p $dummymnt
+
+testme() {
+	local mkfs_args=('-f')
+	local value="$1"
+	test -n "$value" && value="=$value"
+
+	if [ $# -gt 0 ]; then
+		mkfs_args+=('-m' "self_healing$value")
+	fi
+
+	echo "testing ${mkfs_args[*]}" >> $seqres.full
+
+	$MKFS_XFS_PROG $MKFS_OPTIONS "${mkfs_args[@]}" $dummyfile >> $seqres.full || \
+		_notrun "mkfs.xfs ${mkfs_args[*]} failed?"
+
+	_mount -o loop $dummyfile $dummymnt
+	XFS_SCRUB_PHASE=7 $XFS_SCRUB_PROG -d -o fsprops_advise $dummymnt 2>&1 | \
+		grep self_healing | _filter_test_dir | sed -e 's/\(directive.\).*$/\1/g'
+	_umount $dummymnt
+}
+
+testme ''
+testme
+testme none
+testme check
+testme optimize
+testme repair
+testme 0
+testme 1
+
+status=0
+exit
diff --git a/tests/xfs/1889.out b/tests/xfs/1889.out
new file mode 100644
index 0000000000..707c37edd0
--- /dev/null
+++ b/tests/xfs/1889.out
@@ -0,0 +1,9 @@
+QA output created by 1889
+Info: TEST_DIR/1889.mount: Checking and repairing per self_healing directive.
+Info: TEST_DIR/1889.mount: Checking per self_healing directive.
+Info: TEST_DIR/1889.mount: Disabling scrub per self_healing directive.
+Info: TEST_DIR/1889.mount: Checking per self_healing directive.
+Info: TEST_DIR/1889.mount: Optimizing per self_healing directive.
+Info: TEST_DIR/1889.mount: Checking and repairing per self_healing directive.
+Info: TEST_DIR/1889.mount: Disabling scrub per self_healing directive.
+Info: TEST_DIR/1889.mount: Checking and repairing per self_healing directive.

