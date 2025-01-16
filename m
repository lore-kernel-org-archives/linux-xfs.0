Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EDF1DD0DC;
	Thu, 16 Jan 2025 23:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070786; cv=none; b=uXPLPWFA4rxa7MMgAyUC45jN2PbVBUzmajT84kP1GRkRbcOMACud5Phr6rBP/NF4IiU8d++7Lo6js4F4AAHlJti91hU3ZfHufbu8YtCUnoZY+WzI5ucRXkaFQ2RQ1lfn4Dethq0S1lOVtUfIXeNe942b42xZ4nFD2KhE1tOqj4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070786; c=relaxed/simple;
	bh=w6dIgeKRjwm3Vghr7v4q+97adtTn5YBPv0s5fU0jEf0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brN3ysAVqEhgOh63HfQOzpZOQdlarXKO4rbSKZps/2KmwtqbftI6F7zRGHzvpwXSZn5K9vhT+huhLoc4LM6GaLvGLYHBPRzTL0McMpVS6peXoRMIrPgbsY9wLj4nrgjResypEH6p9n/OmOMGmcSwvIuS6Z72NhfVbdLnl9YGWTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRlHFQTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRlHFQTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6869FC4CED6;
	Thu, 16 Jan 2025 23:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070786;
	bh=w6dIgeKRjwm3Vghr7v4q+97adtTn5YBPv0s5fU0jEf0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GRlHFQTnc5wwtviepwk4SkpH7/pth25C5jQ1jyO+pKnCPYN41rU89cycUc/pcuMoI
	 H/gL7Cv5dSb0hFJ63nxHwqAqs3U1nSnX76meqw/gTJSEzd8x3lfktPxykvkSnErUGy
	 Dk0adMZTvS4UbwCDXROWMLQWNVyL1gnisoYLUfqOwxlx2zRISP9TYz5utu3wFA9EDe
	 yOhaZWU9EgH+b4MXPbbVAXiiJppoAQMM2KV40gZ7xNUd7ojn5n7R5EuAmOHmbgluKM
	 GnBTHzIius6LcdbVQ2kaZwWV4dilE3cIM7aF+q3xNcWFztN4nhyXbOXwSoXQFjgl9B
	 neE68l2RFaxTQ==
Date: Thu, 16 Jan 2025 15:39:46 -0800
Subject: [PATCH 4/4] xfs: fix tests for persistent qflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976698.1929311.10218997705149048736.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976640.1929311.7118885570179440699.stgit@frogsfrogsfrogs>
References: <173706976640.1929311.7118885570179440699.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix the tests that now break with persistent quota flags.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/quota              |    1 +
 common/rc                 |    1 +
 common/xfs                |    3 +++
 tests/xfs/007             |    2 +-
 tests/xfs/096             |    1 +
 tests/xfs/096.out         |    2 +-
 tests/xfs/106             |    2 +-
 tests/xfs/116             |   13 ++++++++++++-
 tests/xfs/116.cfg         |    1 +
 tests/xfs/116.out.default |    0 
 tests/xfs/116.out.metadir |    3 +++
 tests/xfs/152             |    2 +-
 tests/xfs/263             |    1 +
 tests/xfs/263.out         |    2 +-
 14 files changed, 28 insertions(+), 6 deletions(-)
 create mode 100644 tests/xfs/116.cfg
 rename tests/xfs/{116.out => 116.out.default} (100%)
 create mode 100644 tests/xfs/116.out.metadir


diff --git a/common/quota b/common/quota
index 4dad9b79a27a7f..4ef0d4775067ee 100644
--- a/common/quota
+++ b/common/quota
@@ -312,6 +312,7 @@ _qmount_option()
 		-e 's/grpjquota=[^, ]*/QUOTA/g' \
 		-e 's/\bpquota/QUOTA/g'    \
 		-e 's/prjquota/QUOTA/g'    \
+		-e 's/noquota/QUOTA/g'     \
 		-e 's/quota/QUOTA/g'       \
 		-e 's/uqnoenforce/QUOTA/g' \
 		-e 's/gqnoenforce/QUOTA/g' \
diff --git a/common/rc b/common/rc
index 25eb13ab2c5a48..824fc061e84a99 100644
--- a/common/rc
+++ b/common/rc
@@ -3721,6 +3721,7 @@ _get_os_name()
 _link_out_file_named()
 {
 	test -n "$seqfull" || _fail "need to set seqfull"
+	test -r "$seqfull.cfg" || _fail "need $seqfull.cfg"
 
 	local features=$2
 	local suffix=$(FEATURES="$features" perl -e '
diff --git a/common/xfs b/common/xfs
index 0f29d5c5a6b963..32a048b15efc04 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1710,6 +1710,9 @@ _xfs_filter_mkfs()
 		print STDERR "ldev=\"$1\"\nlbsize=$2\nlblocks=$3\nlversion=$4\n";
 		print STDOUT "log      =LDEV bsize=XXX blocks=XXX\n";
 	}
+	if (/^\s+=\s+exchange=(\d+)\s+metadir=(\d+)/) {
+		print STDERR "exchange=$1\nmetadir=$2\n\n";
+	}
 	if (/^\s+=\s+sectsz=(\d+)\s+sunit=(\d+) blks/) {
 		print STDERR "logsectsz=$1\nlogsunit=$2\n\n";
 	}
diff --git a/tests/xfs/007 b/tests/xfs/007
index e35a069f9bd5c5..4721bc832b3fe4 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -47,7 +47,7 @@ do_test()
 	# This takes care of newer kernels where quotaoff clears the superblock
 	# quota enforcement flags but doesn't shut down accounting.
 	_scratch_unmount
-	_qmount_option ""
+	_qmount_option "noquota"
 	_scratch_mount
 
 	rm_commands=(-x -c "remove -$off_opts")
diff --git a/tests/xfs/096 b/tests/xfs/096
index 57a05a8ffefbd1..f1f5d562d4fa18 100755
--- a/tests/xfs/096
+++ b/tests/xfs/096
@@ -28,6 +28,7 @@ function option_string()
 	if [ "$((VAL & 4))" -ne "0" ]; then OPT=prjquota,${OPT}; fi;
 	if [ "$((VAL & 2))" -ne "0" ]; then OPT=grpquota,${OPT}; fi;
 	if [ "$((VAL & 1))" -ne "0" ]; then OPT=usrquota,${OPT}; fi;
+	if [ "$VAL" = "0" ]; then OPT=noquota; fi;
 	echo $OPT
 }
 
diff --git a/tests/xfs/096.out b/tests/xfs/096.out
index 1deb7a8c302374..20f68d3870c4a0 100644
--- a/tests/xfs/096.out
+++ b/tests/xfs/096.out
@@ -1,5 +1,5 @@
 QA output created by 096
-== Options: rw ==
+== Options: noquota ==
 == Options: usrquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON
diff --git a/tests/xfs/106 b/tests/xfs/106
index 066efef1181b8a..10cbd1052bbc89 100755
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -155,7 +155,7 @@ test_off()
 {
 	echo "turning quota off by remounting"
 	_scratch_unmount
-	_qmount_option ""
+	_qmount_option "noquota"
 	_qmount
 }
 
diff --git a/tests/xfs/116 b/tests/xfs/116
index c5e7508f8862ed..3ef6f5ddfdb2d6 100755
--- a/tests/xfs/116
+++ b/tests/xfs/116
@@ -23,7 +23,18 @@ _require_xfs_quota
 # Only mount with the quota options we specify below
 _qmount_option "defaults"
 
-_scratch_mkfs >/dev/null 2>&1
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+. $tmp.mkfs
+cat $tmp.mkfs >> $seqres.full
+
+# link correct .out file, see $seqfull.cfg
+seqfull=$0
+if [ "$metadir" = 1 ]; then
+	_link_out_file_named $seqfull.out "metadir"
+else
+	_link_out_file_named $seqfull.out
+fi
+
 _scratch_mount "-o uquota"
 _scratch_unmount
 _scratch_xfs_db -r -c sb -c print  | grep qflags
diff --git a/tests/xfs/116.cfg b/tests/xfs/116.cfg
new file mode 100644
index 00000000000000..571f542faef97d
--- /dev/null
+++ b/tests/xfs/116.cfg
@@ -0,0 +1 @@
+metadir: metadir
diff --git a/tests/xfs/116.out b/tests/xfs/116.out.default
similarity index 100%
rename from tests/xfs/116.out
rename to tests/xfs/116.out.default
diff --git a/tests/xfs/116.out.metadir b/tests/xfs/116.out.metadir
new file mode 100644
index 00000000000000..3a58fb919b1e39
--- /dev/null
+++ b/tests/xfs/116.out.metadir
@@ -0,0 +1,3 @@
+QA output created by 116
+qflags = 0x7
+qflags = 0x7
diff --git a/tests/xfs/152 b/tests/xfs/152
index 6c052cbc9b31f5..94428b35d22a87 100755
--- a/tests/xfs/152
+++ b/tests/xfs/152
@@ -194,7 +194,7 @@ test_off()
 {
 	echo "checking off command (type=$type)"
 	_scratch_unmount
-	_qmount_option ""
+	_qmount_option "noquota"
 	_qmount
 }
 
diff --git a/tests/xfs/263 b/tests/xfs/263
index aedbc4795296d3..83ec8b959fa9de 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -27,6 +27,7 @@ function option_string()
 	if [ "$((VAL & 4))" -ne "0" ]; then OPT=prjquota,${OPT}; fi;
 	if [ "$((VAL & 2))" -ne "0" ]; then OPT=grpquota,${OPT}; fi;
 	if [ "$((VAL & 1))" -ne "0" ]; then OPT=usrquota,${OPT}; fi;
+	if [ "$VAL" = "0" ]; then OPT=noquota; fi;
 	echo $OPT
 }
 
diff --git a/tests/xfs/263.out b/tests/xfs/263.out
index 64c1a5876cfa24..8682eee2680728 100644
--- a/tests/xfs/263.out
+++ b/tests/xfs/263.out
@@ -1,5 +1,5 @@
 QA output created by 263
-== Options: rw ==
+== Options: noquota ==
 == Options: usrquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
   Accounting: ON

