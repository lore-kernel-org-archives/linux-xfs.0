Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06FD45039;
	Tue, 13 Oct 2026 00:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850178; cv=none; b=AlE3neUMwO5IhVUFYn9u85k885Fi1xkE0E5/zuYCeqnEh5btY2vXVDRFXFIzJ41UlhPea67/yGb0z+vtSl4Q7+dTpEJVFC0pfRVjKBfN6iBexxG0DcPQNGbcO4NEam4Q1FQdP8Vdisd00uqcN8Pv2fd2Hj7WGUBL1252iCGQsQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850178; c=relaxed/simple;
	bh=EsU3WRHt1wdZv+BwIFbc3y3LpZOjRjv7/PWAbPVQws4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SWN+AATpG2k096zqrazBk/de2FOQuqQOVuplxmJ/ecyW1DoxF67Bku70MPJqHWpEZNklGy4IEY6yOgC+ORz5aX4wjDPRkbNAzMgONKQJOd/3NZBZai8rkBfbUoZkSTs87wY5bIFIbEXuhXL+xekyMdgO7P5Bn8yB1PLzwkbR+Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbzVOuSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbzVOuSZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A86291F0089B;
	Tue, 13 Oct 2026 00:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850177;
	bh=CZbxZ7DWQ1Q0VwWJN3byyXMuG0CA//4TJyP4rflhgns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WbzVOuSZcV6OXbfvp0pMGs8nmCbJsZqyLnt0oINtuuWnsrh8FM48dcxVVKaShqgp+
	 +3bBzk3hB+JDY6AHa58PgOeRZJZdhNLVADBV2gOWF4SCZDxEBQm1Ijslv3y4+wJ/KR
	 peNV+k5/+UlSk+OcJIb4Z8bt1KOPhygyjgIRdooVwfMiNzO0sD+4cvqXYgUtZX8JCh
	 OmGasTebUmINZSPxe51B+lrbp60fjnNLaW2j+yWNuxzT2peJEFJ3Kn/2X1UTXCkLKM
	 QImeCUXdZk2n7lH/p5a87rBWOhc/8tZCOL9GHKB8sSQxWoQriYVWg787dzAcD5+ZPf
	 fxM6fKXV+1IMw==
Date: Mon, 12 Oct 2026 17:09:37 -0700
Subject: [PATCH 4/6] xfs: test mkfs.xfs config file generation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: aalbersh@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179185007529.1732194.17549882346733262970.stgit@frogsfrogsfrogs>
In-Reply-To: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
References: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Test configuration file generation via mkfs, xfs_db, and xfs_spaceman.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tests/xfs/1909     |  163 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1909.out |    2 +
 2 files changed, 165 insertions(+)
 create mode 100755 tests/xfs/1909
 create mode 100644 tests/xfs/1909.out


diff --git a/tests/xfs/1909 b/tests/xfs/1909
new file mode 100755
index 00000000000000..d60d552f5b4863
--- /dev/null
+++ b/tests/xfs/1909
@@ -0,0 +1,163 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1909
+#
+# Functional testing for mkfs.xfs config file generation.
+#
+. ./common/preamble
+_begin_fstest auto mkfs
+
+# . ./common/filter
+
+_require_scratch
+_require_xfs_mkfs_cfgfile
+_require_xfs_spaceman_command "makecfg"
+_require_xfs_db_command "makecfg"
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+
+# t1: Make sure all three tools generate the same config file
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+$XFS_SPACEMAN_PROG -c "makecfg $tmp.spaceman1" $SCRATCH_MNT
+$XFS_ADMIN_PROG -C $tmp.onadmin1 $SCRATCH_MNT
+_scratch_unmount
+
+_scratch_mkfs -c makecfg=$tmp.mkfs1 >> $seqres.full
+_scratch_xfs_db -c "makecfg $tmp.db1"
+_scratch_xfs_admin -C $tmp.offadmin1
+
+cmp -s $tmp.mkfs1 $tmp.spaceman1 || \
+	echo "mkfs config1 does not match spaceman?"
+cmp -s $tmp.db1 $tmp.spaceman1 || \
+	echo "db config1 does not match spaceman?"
+cmp -s $tmp.db1 $tmp.mkfs1 || \
+	echo "db config1 does not match mkfs?"
+cmp -s $tmp.onadmin1 $tmp.mkfs1 || \
+	echo "online admin config1 does not match mkfs?"
+cmp -s $tmp.offadmin1 $tmp.mkfs1 || \
+	echo "offline admin config1 does not match mkfs?"
+
+echo "*** spaceman config1" >> $seqres.full
+cat $tmp.spaceman1 >> $seqres.full
+echo "*** mkfs config1" >> $seqres.full
+cat $tmp.mkfs1 >> $seqres.full
+echo "*** db config1" >> $seqres.full
+cat $tmp.db1 >> $seqres.full
+echo "*** online admin config1" >> $seqres.full
+cat $tmp.onadmin1 >> $seqres.full
+echo "*** offline admin config1" >> $seqres.full
+cat $tmp.offadmin1 >> $seqres.full
+
+# t2: Make sure the output changes if we set a new rootdir inherit option
+_scratch_mount
+$XFS_IO_PROG -c 'chattr +P' -c 'chproj 33' $SCRATCH_MNT
+$XFS_SPACEMAN_PROG -c "makecfg $tmp.spaceman2" $SCRATCH_MNT
+_scratch_unmount
+_scratch_xfs_db -c "makecfg $tmp.db2"
+
+cmp -s $tmp.db2 $tmp.spaceman2 || \
+	echo "db config2 does not match spaceman?"
+cmp -s $tmp.db1 $tmp.db2 && \
+	echo "db config1 should be different from db config2"
+
+echo "*** spaceman config2" >> $seqres.full
+cat $tmp.spaceman2 >> $seqres.full
+echo "*** db config2" >> $seqres.full
+cat $tmp.db2 >> $seqres.full
+
+# t3: Format with t2 config file, make sure the results match t2 and not t1
+_scratch_mkfs -c options=$tmp.db2 >> $seqres.full
+_scratch_mount
+$XFS_SPACEMAN_PROG -c "makecfg $tmp.spaceman3" $SCRATCH_MNT
+_scratch_unmount
+_scratch_xfs_db -c "makecfg $tmp.db3"
+
+cmp -s $tmp.db3 $tmp.spaceman3 || \
+	echo "db config3 does not match spaceman?"
+cmp -s $tmp.db3 $tmp.db1 && \
+	echo "db config3 should be different from db config1"
+cmp -s $tmp.db3 $tmp.db2 || \
+	echo "db config3 does not match db config2?"
+
+echo "*** spaceman config3" >> $seqres.full
+cat $tmp.spaceman3 >> $seqres.full
+echo "*** db config3" >> $seqres.full
+cat $tmp.db3 >> $seqres.full
+
+# t4: Set autofsck filesystem property, make sure that gets reflected
+autofsck="$(grep 'autofsck=' $tmp.spaceman3 | sed -e 's/^.*autofsck=//g')"
+case "$autofsck" in
+"")
+	if grep -q 'crc=1' $tmp.spaceman3; then
+		new_autofsck=check
+	fi
+	;;
+repair) new_autofsck=check;;
+*)	new_autofsck=repair;;
+esac
+if [ -n "$new_autofsck" ]; then
+	$XFS_PROPERTY_PROG $SCRATCH_DEV set "autofsck=$new_autofsck" >> $seqres.full
+	_scratch_mount
+	$XFS_SPACEMAN_PROG -c "makecfg $tmp.spaceman4" $SCRATCH_MNT
+	_scratch_unmount
+	_scratch_xfs_db -c "makecfg $tmp.db4"
+
+	cmp -s $tmp.db4 $tmp.spaceman4 || \
+	echo "db config4 does not match spaceman?"
+	cmp -s $tmp.db4 $tmp.db3 && \
+		echo "db config4 should be different from db config3"
+
+	echo "*** spaceman config4" >> $seqres.full
+	cat $tmp.spaceman4 >> $seqres.full
+	echo "*** db config4" >> $seqres.full
+	cat $tmp.db4 >> $seqres.full
+
+	_scratch_mkfs -c options=$tmp.db4 >> $seqres.full
+	_scratch_mount
+	$XFS_SPACEMAN_PROG -c "makecfg $tmp.spaceman4a" $SCRATCH_MNT
+	_scratch_unmount
+	_scratch_xfs_db -c "makecfg $tmp.db4a"
+
+	cmp -s $tmp.db4a $tmp.spaceman4a || \
+	echo "db config4a does not match spaceman?"
+	cmp -s $tmp.db4a $tmp.db3 && \
+		echo "db config4a should be different from db config3"
+	cmp -s $tmp.db4a $tmp.db4 || \
+	echo "db config4a does not match db config4?"
+
+	echo "*** spaceman config4a" >> $seqres.full
+	cat $tmp.spaceman4a >> $seqres.full
+	echo "*** db config4a" >> $seqres.full
+	cat $tmp.db4a >> $seqres.full
+
+fi
+
+if grep -q 'reflink=1' "$tmp.db3"; then
+	# t5a: make sure that cli can override defaults
+	_scratch_mkfs -c defaults=$tmp.db3 -m reflink=0 >> $seqres.full
+	_scratch_xfs_db -c "makecfg $tmp.db5a"
+	grep -q 'reflink=0' "$tmp.db5a" || \
+		echo "db config5a should not have reflink"
+
+	echo "*** db config5a" >> $seqres.full
+	cat $tmp.db5a >> $seqres.full
+
+	# t5b: make sure that cli cannot override config file
+	_scratch_mkfs -c options=$tmp.db3 -m reflink=0 >> $seqres.full 2>> $tmp.fail
+	grep -q 'reflink option respecified' $tmp.fail || \
+		echo "mkfs should have failed on config5b"
+
+	# t5c: make sure that config file can override defaults
+	_scratch_mkfs -c options=$tmp.db3,defaults=$tmp.db3 >> $seqres.full
+	_scratch_xfs_db -c "makecfg $tmp.db5c"
+	grep -q 'reflink=1' "$tmp.db5c" || \
+		echo "db config5c should have reflink"
+
+	echo "*** db config5c" >> $seqres.full
+	cat $tmp.db5c >> $seqres.full
+fi
+
+echo Silence is golden
+_exit 0
diff --git a/tests/xfs/1909.out b/tests/xfs/1909.out
new file mode 100644
index 00000000000000..c17c5522d48db4
--- /dev/null
+++ b/tests/xfs/1909.out
@@ -0,0 +1,2 @@
+QA output created by 1909
+Silence is golden

