Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB1F46B8;
	Wed, 19 Feb 2025 01:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926956; cv=none; b=rAPmUSXSEoEXNOBbHYXbcaaHrT/givrQCc0umiUpcaWxK30XKMZP1bIdzStQOlLtWS8MrVKpy8NOS+3hsh9P1RL9aJG4F9deI+YvKNYBzCtTV+fKSfrmzXv+KqW5DKlM/C6IFUXL6rZTuXRCXQbItMq5iuqR67WeLTNj9GPxmUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926956; c=relaxed/simple;
	bh=zDIC0SVn1JDisy1uR++TLFKQenuRdytfNR5PMf5oedY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gipfuVOcWf7TCJuqhiCHq5yuu+jUq83IHnFGgLVjozP2k/RoL2PthHgHLT2t24c3p3e194IRnMvE71AYqg63V/9c3rkxyOz6ySLNtrnOfjumm79q99EuqpTFCbcJnmaKuuNXpIVGO8e5w3tgQZkLJZlkkQi/pqJsXLMC5G+/XFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DEFgL0b8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DEFgL0b8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516A1C4CEE2;
	Wed, 19 Feb 2025 01:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926956;
	bh=zDIC0SVn1JDisy1uR++TLFKQenuRdytfNR5PMf5oedY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DEFgL0b8wj4gmvapA89W11AkIDtyitWd1knQ7jbvfIEPYtgQjb0XbdnAI535aaZa8
	 UytDbh1S2qjIA8ycgvG/5qJna/d94NGdBimRG5ynfBIIpz5vak+2LpvQ7G3oTQu41u
	 lpZSaLm75WxwEoTCyVaWwJncIVNTmoMpXMhF42DK+PYU9lAiczZz/3ZzHn/3ANIwIK
	 2Yj00Y+HH7jypPwd0Nl8zDR82dKNxptxExGRDcITqLUgeg58sJf/8I6UhOZnBYYjZM
	 ARmGKkicXTxK1VYVttGwSOip6aDGLsC1LbiLhHkg2AJOy2upPsArpMt7ReB2GBMOMp
	 pez/LOa3yJ2Nw==
Date: Tue, 18 Feb 2025 17:02:34 -0800
Subject: [PATCH 4/4] xfs: fix tests for persistent qflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589915.4080063.10358866862152064609.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
References: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
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
index 20d07e70401f90..96082f050de587 100644
--- a/common/rc
+++ b/common/rc
@@ -3731,6 +3731,7 @@ _get_os_name()
 _link_out_file_named()
 {
 	test -n "$seqfull" || _fail "need to set seqfull"
+	test -r "$seqfull.cfg" || _fail "need $seqfull.cfg"
 
 	local features=$2
 	local suffix=$(FEATURES="$features" perl -e '
diff --git a/common/xfs b/common/xfs
index 30d2f98c3795da..aae8b427d25fe9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1704,6 +1704,9 @@ _xfs_filter_mkfs()
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

