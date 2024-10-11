Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29009EAF1;
	Fri, 11 Oct 2024 01:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611172; cv=none; b=oyCHnMGr7enkxnLmzMh0od0a8JJu4CvvmGKuglc+PG34hmFzajzGBm35em4jA1/Xe98lWwMgmDfmYtI9XFAWGW7xG/nxKlE5v2I+CKikC4yxAmNNwUWc/QkJWVDzkqaTAo1Xt9gvFGMuStmf/23pn5LXaE0ixKuru/+RybDUv0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611172; c=relaxed/simple;
	bh=xO4UGfWRua/1rNgdX2yvT093waZdeNDjatoEaDxaD2A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LuxYYdAk4PUlsisxucjiDyNDvRkPj8jHTJKjxdspJNoGOVY11xb6IvhegFjh9SJIffsHnR1H9twAw2gl5AyWtHNcbcTk0Qz9VR3BTizuRXwBLF6JUlB+SbddS6jsAgrFr1+18NTm3NkZhEiv33kpDtjGTRLZs7cppgzqShDQoVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EXKmwmtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EXKmwmtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF95FC4CEC5;
	Fri, 11 Oct 2024 01:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611171;
	bh=xO4UGfWRua/1rNgdX2yvT093waZdeNDjatoEaDxaD2A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EXKmwmtreqMDypkZgX65d4/yRHX/6DXHFrMEDtehigI2QV+xUkM7phr6t/pjhpNII
	 dv0LMIVRRxKCAds8OvErepoS/Cisc7JnHWDGLlm26AtZgv8rDGCEpI2D/8w/cdlocO
	 tYAsXyhTy9vJv/LnBzqFDJMwGAAnQ9SzhIiglLTEcYE6sX943+RIX3EtiJqqaurQTQ
	 hWBxFqQ0X3s2+Rb1bn8zC0UOFJbeqJcyE41HycyoRDrBuortzb+R27Toj0TBEVVLKP
	 3L+YDN4t0wt8aDHabWWHHXZpeg9wf/qHQ/kDUz/3Cxryvb/FdkzQ6mHG+RMrOUx6i6
	 LTCh3tM+b14KA==
Date: Thu, 10 Oct 2024 18:46:11 -0700
Subject: [PATCH 4/4] xfs: fix tests for persistent qflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860659156.4189705.3400574246546592573.stgit@frogsfrogsfrogs>
In-Reply-To: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
References: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
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

Fix the tests that now break with persistent quota flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
 tests/xfs/1856            |   13 +++++++++++++
 tests/xfs/263             |    1 +
 tests/xfs/263.out         |    2 +-
 15 files changed, 41 insertions(+), 6 deletions(-)
 create mode 100644 tests/xfs/116.cfg
 rename tests/xfs/{116.out => 116.out.default} (100%)
 create mode 100644 tests/xfs/116.out.metadir


diff --git a/common/quota b/common/quota
index 3bf7d552eecc07..c16634d8d2fbf4 100644
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
index 3171058496c732..1018f0b6afc8e4 100644
--- a/common/rc
+++ b/common/rc
@@ -3531,6 +3531,7 @@ _get_os_name()
 _link_out_file_named()
 {
 	test -n "$seqfull" || _fail "need to set seqfull"
+	test -r "$seqfull.cfg" || _fail "need $seqfull.cfg"
 
 	local features=$2
 	local suffix=$(FEATURES="$features" perl -e '
diff --git a/common/xfs b/common/xfs
index 7198a5579d4cfa..c43b824d28f792 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1689,6 +1689,9 @@ _xfs_filter_mkfs()
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
 
diff --git a/tests/xfs/1856 b/tests/xfs/1856
index 74f982af65070f..9f43aa32f6f42f 100755
--- a/tests/xfs/1856
+++ b/tests/xfs/1856
@@ -158,6 +158,19 @@ post_exercise()
 	return 0
 }
 
+qerase_mkfs_options() {
+	echo "$MKFS_OPTIONS" | sed \
+		-e 's/uquota//g' \
+		-e 's/gquota//g' \
+		-e 's/pquota//g' \
+		-e 's/uqnoenforce//g' \
+		-e 's/gqnoenforce//g' \
+		-e 's/pqnoenforce//g' \
+		-e 's/,,*/,/g'
+}
+
+MKFS_OPTIONS="$(qerase_mkfs_options)"
+
 # Create a list of fs features in the order that support for them was added
 # to the kernel driver.  For each feature upgrade test, we enable all the
 # features that came before it and none of the ones after, which means we're
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

