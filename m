Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B26645024;
	Tue, 27 Aug 2024 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784447; cv=none; b=u69IGi2QUKyvAGPwVRLS39x7avDOfLN58QHEu7xuasbtfnkck7c1TjTx/QctC7OXOkm24o5jCvgGt2ZSAHNAFTEFHvfeKpnfqQP6IM6BMY2X2fXjGZNIbSmTY9nRGJDUtJKjF1zR2lWzMwbI4gio93M6X1g87D8LtdMLZrYEdfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784447; c=relaxed/simple;
	bh=QKFzheLZlTr4ivfcALMnW7epe0JCr+612VAX502fnB8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9r0wm8acEE7ABtyfm73h74ftZdICqJLd2PBdrGYKmS5G6Yp8XEbWy4dP0p/Uwit8Fcf2Dn2phzjH4YEPMXxQvtJo4/CHrb6/1FhpVq1cSQpdPu2TsVjw31dWAoWJVKOS672rukn28ANqn9MObz7gJsN0B6teolb9dfZD8LdWQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pTwIQwas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pTwIQwas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3037C4AF18;
	Tue, 27 Aug 2024 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784446;
	bh=QKFzheLZlTr4ivfcALMnW7epe0JCr+612VAX502fnB8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pTwIQwassM0M0vMMvHtSvzkqRL33xD493KLuhXRKo/ZkoBdCQzkOvxD9TEcZ2Fmfz
	 ipw8fbWlh3iQRcJZAZy7U8a4yqiT5kepggQMq2Pt8yAZ6BvLZw3j7oXdrkzSyTO6CX
	 cjfHJnnfPB5L1A/YUed88vvGX4yaaL3IjKXF4aLM1feemLUG1eM12As/G4Vk9kr7qM
	 mw2ukK59DItD/PJgGMYFo6by/lReIJxzSzltzhwv4Nznwuoq1NqmRD36TMp7L1j3CQ
	 /YGdA1+iinjj4sepWkSrZvLNxeDAOr0PUo6Z4AIas9ww0wgomHjNTp/jIYqZp82qid
	 m+AywgLCJunHQ==
Date: Tue, 27 Aug 2024 11:47:26 -0700
Subject: [PATCH 1/1] xfs: functional testing for filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478423776.2039792.13195157691349611058.stgit@frogsfrogsfrogs>
In-Reply-To: <172478423759.2039792.1261370258750521007.stgit@frogsfrogsfrogs>
References: <172478423759.2039792.1261370258750521007.stgit@frogsfrogsfrogs>
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
 common/config       |    1 
 common/xfs          |   14 ++++-
 doc/group-names.txt |    1 
 tests/generic/062   |    4 +
 tests/xfs/1886      |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1886.out  |   53 ++++++++++++++++++++
 tests/xfs/1887      |  122 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1887.out  |   46 +++++++++++++++++
 tests/xfs/1888      |   66 +++++++++++++++++++++++++
 tests/xfs/1888.out  |    9 +++
 tests/xfs/1889      |   63 +++++++++++++++++++++++
 tests/xfs/1889.out  |    8 +++
 12 files changed, 522 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1886
 create mode 100644 tests/xfs/1886.out
 create mode 100755 tests/xfs/1887
 create mode 100644 tests/xfs/1887.out
 create mode 100755 tests/xfs/1888
 create mode 100644 tests/xfs/1888.out
 create mode 100755 tests/xfs/1889
 create mode 100644 tests/xfs/1889.out


diff --git a/common/config b/common/config
index 307f93fbce..668b185ff0 100644
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
index de557ebd90..62e3100ee1 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1323,8 +1323,8 @@ _require_xfs_spaceman_command()
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
@@ -1860,3 +1860,13 @@ _xfs_statfs_field()
 {
 	$XFS_IO_PROG -c 'statfs' "$1" | grep -E "$2" | cut -d ' ' -f 3
 }
+
+# Wipe all filesystem properties from an xfs filesystem.  The sole argument
+# must be the root directory of a filesystem.
+_wipe_xfs_properties()
+{
+	getfattr --match="^trusted.xfs:" --absolute-names --dump --encoding=hex "$1" | \
+			grep '=' | sed -e 's/=.*$//g' | while read name; do
+		setfattr --remove="$name" "$1"
+	done
+}
diff --git a/doc/group-names.txt b/doc/group-names.txt
index 6cf717969d..ed886caac0 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -56,6 +56,7 @@ fiexchange		XFS_IOC_EXCHANGE_RANGE ioctl
 freeze			filesystem freeze tests
 fsck			general fsck tests
 fsmap			FS_IOC_GETFSMAP ioctl
+fsproperties		Filesystem properties
 fsr			XFS free space reorganizer
 fuzzers			filesystem fuzz tests
 growfs			increasing the size of a filesystem
diff --git a/tests/generic/062 b/tests/generic/062
index 8f4dfcbf55..f0904992d1 100755
--- a/tests/generic/062
+++ b/tests/generic/062
@@ -75,6 +75,10 @@ fi
 
 _require_attrs $ATTR_MODES
 
+# Wipe all xfs filesystem properties (which are rootdir xattrs) before we dump
+# them all later.
+test $FSTYP = "xfs" && _wipe_xfs_properties $SCRATCH_MNT
+
 for nsp in $ATTR_MODES; do
 	for inode in reg dir lnk dev/b dev/c dev/p; do
 
diff --git a/tests/xfs/1886 b/tests/xfs/1886
new file mode 100755
index 0000000000..68abfedd15
--- /dev/null
+++ b/tests/xfs/1886
@@ -0,0 +1,137 @@
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
+_begin_fstest auto fsproperties
+
+. ./common/filter
+. ./common/attr
+
+_require_test
+_require_user fsgqa
+_require_attrs
+_require_xfs_io_command listfsprops
+_require_xfs_db_command attr_list
+
+_cleanup()
+
+{
+	cd /
+	rm -r -f $tmp.*
+	rm -f $TEST_DIR/$seq.somefile
+	rm -r -f $TEST_DIR/$seq.somedir
+	test -n "$propname" && $ATTR_PROG -R -r $propname $TEST_DEV &>/dev/null
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
+echo "*** IO TEST ***"
+
+echo empty get property
+$XFS_IO_PROG -c "getfsprops $propname" $TEST_DIR
+
+echo pointless remove property
+$XFS_IO_PROG -c "removefsprops $propname" $TEST_DIR
+
+echo list property
+$XFS_IO_PROG -c "listfsprops" $TEST_DIR | grep $propname
+
+echo set property
+$XFS_IO_PROG -c "setfsprops $propname=$propval" $TEST_DIR
+
+echo list property
+$XFS_IO_PROG -c "listfsprops" $TEST_DIR | grep $propname
+
+echo dump xattrs
+$ATTR_PROG -R -l $TEST_DIR | grep $propname | _filter_test_dir
+
+echo get property
+$XFS_IO_PROG -c "getfsprops $propname" $TEST_DIR
+
+echo list property
+$XFS_IO_PROG -c "listfsprops" $TEST_DIR | grep $propname
+
+echo child file rejected
+touch $TEST_DIR/$seq.somefile
+$XFS_IO_PROG -c "listfsprops $propname" $TEST_DIR/$seq.somefile 2>&1 | \
+	_filter_test_dir
+
+echo child dir rejected
+mkdir -p $TEST_DIR/$seq.somedir
+$XFS_IO_PROG -c "listfsprops $propname" $TEST_DIR/$seq.somedir 2>&1 | \
+	_filter_test_dir
+
+echo remove property
+$XFS_IO_PROG -c "removefsprops $propname" $TEST_DIR
+
+echo pointless remove property
+$XFS_IO_PROG -c "removefsprops $propname" $TEST_DIR
+
+echo set too long name
+$XFS_IO_PROG -c "setfsprops $longpropname=$propval" $TEST_DIR
+
+echo set too long value
+$XFS_IO_PROG -c "setfsprops $propname=$longpropval" $TEST_DIR
+
+echo not enough permissions
+su - "$qa_user" -c "$XFS_IO_PROG -c \"setfsprops $propname=$propval\" $TEST_DIR" 2>&1 | _filter_test_dir
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
index 0000000000..e02d810406
--- /dev/null
+++ b/tests/xfs/1886.out
@@ -0,0 +1,53 @@
+QA output created by 1886
+*** IO TEST ***
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
+TEST_DIR/1886.somefile: Not a XFS mount point.
+child dir rejected
+TEST_DIR/1886.somedir: Not a XFS mount point.
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
index 0000000000..cd70c42021
--- /dev/null
+++ b/tests/xfs/1887
@@ -0,0 +1,122 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1887
+#
+# Functional testing for xfs_property the wrapper script.
+#
+. ./common/preamble
+_begin_fstest auto fsproperties
+
+. ./common/filter
+. ./common/attr
+
+_require_test
+_require_attrs
+_require_command "$XFS_PROPERTY_PROG" xfs_property
+_require_xfs_io_command listfsprops	# actually detect support
+
+_cleanup()
+
+{
+	cd /
+	rm -r -f $tmp.*
+	rm -f $TEST_DIR/$seq.somefile
+	rm -r -f $TEST_DIR/$seq.somedir
+	test -n "$propname" && $ATTR_PROG -R -r $propname $TEST_DEV &>/dev/null
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
index 0000000000..f16a1c0675
--- /dev/null
+++ b/tests/xfs/1888
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1888
+#
+# Functional testing for mkfs applying autofsck fs property.
+#
+. ./common/preamble
+_begin_fstest auto fsproperties
+
+. ./common/filter
+. ./common/attr
+
+_require_test
+_require_xfs_io_command listfsprops	# needed for fs props
+_require_xfs_db_command attr_get
+
+_cleanup()
+
+{
+	cd /
+	rm -r -f $tmp.*
+	rm -f $dummyfile
+	rmdir $dummymnt &>/dev/null
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
+		mkfs_args+=('-m' "autofsck$value")
+	fi
+
+	echo "testing ${mkfs_args[*]}" >> $seqres.full
+
+	$MKFS_XFS_PROG "${mkfs_args[@]}" $dummyfile >> $seqres.full || \
+		_notrun "mkfs.xfs ${mkfs_args[*]} failed?"
+
+	$XFS_DB_PROG -x -c 'path /' -c "attr_get -Z autofsck" $dummyfile 2>&1 | filter_inum
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
index 0000000000..73857cabd4
--- /dev/null
+++ b/tests/xfs/1888.out
@@ -0,0 +1,9 @@
+QA output created by 1888
+autofsck=repair
+failed to get attr xfs:autofsck on inode XXX: No data available
+autofsck=none
+autofsck=check
+autofsck=optimize
+autofsck=repair
+autofsck=none
+autofsck=repair
diff --git a/tests/xfs/1889 b/tests/xfs/1889
new file mode 100755
index 0000000000..be1f447204
--- /dev/null
+++ b/tests/xfs/1889
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1889
+#
+# Functional testing for mkfs applying autofsck fs property and xfs_scrub
+# changing its behavior accordingly.  Or at least claiming to.
+#
+. ./common/preamble
+_begin_fstest auto fsproperties
+
+. ./common/filter
+. ./common/fuzzy
+
+_require_test
+_require_xfs_io_command listfsprops	# needed for fs props
+_require_xfs_db_command attr_get
+_require_scrub
+
+_cleanup()
+
+{
+	cd /
+	rm -r -f $tmp.*
+	umount $dummymnt &>/dev/null
+	rmdir $dummymnt &>/dev/null
+	rm -f $dummyfile
+}
+
+dummyfile=$TEST_DIR/$seq.somefile
+dummymnt=$TEST_DIR/$seq.mount
+
+truncate -s 10g $dummyfile
+mkdir -p $dummymnt
+
+testme() {
+	local mkfs_args=('-f' '-m' "$1")
+
+	echo "testing ${mkfs_args[*]}" >> $seqres.full
+
+	$MKFS_XFS_PROG "${mkfs_args[@]}" $dummyfile >> $seqres.full || \
+		echo "mkfs.xfs ${mkfs_args[*]} failed?"
+
+	_mount -o loop $dummyfile $dummymnt
+	XFS_SCRUB_PHASE=7 $XFS_SCRUB_PROG -d -o autofsck $dummymnt 2>&1 | \
+		grep autofsck | _filter_test_dir | \
+		sed -e 's/\(directive.\).*$/\1/g'
+	umount $dummymnt
+}
+
+# We don't test the absence of an autofsck directive because xfs_scrub behaves
+# differently depending on whether or not mkfs adds rmapbt/pptrs to the fs.
+testme 'autofsck'
+testme 'autofsck=none'
+testme 'autofsck=check'
+testme 'autofsck=optimize'
+testme 'autofsck=repair'
+testme 'autofsck=0'
+testme 'autofsck=1'
+
+status=0
+exit
diff --git a/tests/xfs/1889.out b/tests/xfs/1889.out
new file mode 100644
index 0000000000..fd8123b53a
--- /dev/null
+++ b/tests/xfs/1889.out
@@ -0,0 +1,8 @@
+QA output created by 1889
+Info: TEST_DIR/1889.mount: Checking and repairing per autofsck directive.
+Info: TEST_DIR/1889.mount: Disabling scrub per autofsck directive.
+Info: TEST_DIR/1889.mount: Checking per autofsck directive.
+Info: TEST_DIR/1889.mount: Optimizing per autofsck directive.
+Info: TEST_DIR/1889.mount: Checking and repairing per autofsck directive.
+Info: TEST_DIR/1889.mount: Disabling scrub per autofsck directive.
+Info: TEST_DIR/1889.mount: Checking and repairing per autofsck directive.

