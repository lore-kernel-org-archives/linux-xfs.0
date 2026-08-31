Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B783D6CD5;
	Mon, 31 Aug 2026 23:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219272; cv=none; b=SHTFTbjHOIeoX8H/gVzb5KaAM4G15+Ue2A9jKnvqRekH2SKJjk5vxfu7jJTrQz95Klp68dz7YZXNlyT1ZmysuUM8Y138LIHQIQeQnV6/js6UQGnc3Cb6eJHKVaKzos0slvZNiU/rVmqlJ1JWo3/6OBSwD6tWIkWqvZHaWOAayy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219272; c=relaxed/simple;
	bh=LFNCkO0yQVQXdjZlD2AvYuRjqhqIOvbynw7F0+zienw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gqKTfY3GG9qex2LJA+lPAFQJTKXufn9rwvOTVibA1MAUjQCrjZrhD3Yfbt2mXcnqFI5ATbGEDVudpZRuAUhA4LLhy46MfdieNh3UaWPZsUWlyyy/G2eiZF46Up+Zi1rLiKj8Ecz6rJkehOy7sqsDnWOypV25ZjqrTRKR50lWdKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnxMEvfU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnxMEvfU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 087D51F00A3D;
	Mon, 31 Aug 2026 23:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788219271;
	bh=qKaQxhFMJhOsVZB9s5jAwlOuIIekPr77MSR1JhiJ584=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gnxMEvfUit8S8mZW7mxswmmVR7hT2UzXwRo/WFbs204i2dAozMpyktNbmjZIGZHSq
	 o/Y86vbUq2KWygsffOwWs2OlXFXyP+ubJvl4nn6/8uIiMyPQxTcL9nOnuZtwdkUNGs
	 wOIFo61whT93iIg4FVAFT0kzpxn6pN18XmS5TGVtGFe+G5b0hNnc2SWe0OMHbbgoDd
	 wet316a3FlUz1eJrVorQK3gYm/g2bFAGdsGuSZDSJ6uuwv8ws+rdIlMiVTjzzjQi2z
	 oQueTXyDl4MZfwxGcrPQ/eUXdYlHqC5EIREdo8vhHCxTGKuM2BzSN8qievMZXmQCFr
	 Zp+gqu2Hxe4zQ==
Date: Mon, 31 Aug 2026 16:34:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, fstests <fstests@vger.kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH RFC] xfs: test mkfs.xfs config file generation
Message-ID: <20260831233430.GK1933798@frogsfrogsfrogs>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Test configuration file generation via mkfs, xfs_db, and xfs_spaceman.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1909     |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1909.out |    2 +
 2 files changed, 125 insertions(+)
 create mode 100755 tests/xfs/1909
 create mode 100644 tests/xfs/1909.out

diff --git a/tests/xfs/1909 b/tests/xfs/1909
new file mode 100755
index 00000000000000..d405064c3e3d1d
--- /dev/null
+++ b/tests/xfs/1909
@@ -0,0 +1,123 @@
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
+# strip out deprecation warnings (e.g. v4 filesystems)
+_scratch_mkfs -c makecfg=$tmp.mkfs1
+_scratch_xfs_db -c "makecfg $tmp.db1"
+_scratch_xfs_admin -C $tmp.offadmin1
+
+cmp -s $tmp.mkfs1 $tmp.spaceman1 || echo "mkfs config1 does not match spaceman?"
+cmp -s $tmp.db1 $tmp.spaceman1 || echo "db config1 does not match spaceman?"
+cmp -s $tmp.db1 $tmp.mkfs1 || echo "db config1 does not match mkfs?"
+cmp -s $tmp.onadmin1 $tmp.mkfs1 || echo "online admin config1 does not match mkfs?"
+cmp -s $tmp.offadmin1 $tmp.mkfs1 || echo "offline admin config1 does not match mkfs?"
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
+cmp -s $tmp.db2 $tmp.spaceman2 || echo "db config2 does not match spaceman?"
+cmp -s $tmp.db1 $tmp.db2 && echo "db config1 should be different from db config2"
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
+cmp -s $tmp.db3 $tmp.spaceman3 || echo "db config3 does not match spaceman?"
+cmp -s $tmp.db3 $tmp.db1 && echo "db config3 should be different from db config1"
+cmp -s $tmp.db3 $tmp.db2 || echo "db config3 does not match db config2?"
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
+	cmp -s $tmp.db4 $tmp.spaceman4 || echo "db config4 does not match spaceman?"
+	cmp -s $tmp.db4 $tmp.db3 && echo "db config4 should be different from db config3"
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
+	cmp -s $tmp.db4a $tmp.spaceman4a || echo "db config4a does not match spaceman?"
+	cmp -s $tmp.db4a $tmp.db3 && echo "db config4a should be different from db config3"
+	cmp -s $tmp.db4a $tmp.db4 || echo "db config4a does not match db config4?"
+
+	echo "*** spaceman config4a" >> $seqres.full
+	cat $tmp.spaceman4a >> $seqres.full
+	echo "*** db config4a" >> $seqres.full
+	cat $tmp.db4a >> $seqres.full
+
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
