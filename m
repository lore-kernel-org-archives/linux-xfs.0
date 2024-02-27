Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42553EADA;
	Tue, 27 Feb 2024 02:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999342; cv=none; b=QPVqWQa1OnH2bpsuKn6iVs9eZobJnbLxqNO44Nid4apSpcF7zwA0DAgbubwV4sB/iNqxLDp1kKFXjJOjO1cSnpcVTno0WNqtnrCUt3zOfDP5UPw4ERsQbYlR1TP+PD4316CrU+O5tSZd1TmaL/7tWdkgTmKiJZkFe2IZrXCi98A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999342; c=relaxed/simple;
	bh=5ub7AK73P5Ue1mzO8TMOkE4E25QR0etZcGPjTBCGYy8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2i3+otRofDksJZXlqe0skyWo5xUW9q8B81jV3Xajk4ThgiJRpL9SQT9X7nzVRbL7jHg3+n0630Ludb2mAbfdT4E2w8EsXFzYUGSgqQ78UsTi/F+rO8jL+f9wUCPA3pyOZuD/IyuCLaiXmuRjpOcZGFa9AyHhZzSrOFtxrWjykI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjQozXrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjQozXrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE33C433C7;
	Tue, 27 Feb 2024 02:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999341;
	bh=5ub7AK73P5Ue1mzO8TMOkE4E25QR0etZcGPjTBCGYy8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kjQozXrFlrpZH0olNG8yyBraP6r3yPY5L630/ieaLJuxWgEldFcyw3YxRNGuBfPDH
	 BVA9M6zL5QWykKF/M0hYtw00LDsAl7lbgDaV12r6tj+j2SnCPLD8bkhvXYY+OJOqL+
	 MqwmgsSc1lc9/YSojeAN5YdB8GIcm/Rlo+26v4RB+h3mZRX7qxc1ELLCUfL52ifL/U
	 Rg3Tu5LIZr9klj2wiV5B0yEDjx9CUUhP829hwDcpwH08WuQbX5wETnrMujDcofl51n
	 vribeHwUXk+IGCbw3r7kXrC87Lf+H1MyvpwdXu9kMY1K3YQ4UFziCGlMrKD+vipvf0
	 RQMi82SBhxc0w==
Date: Mon, 26 Feb 2024 18:02:21 -0800
Subject: [PATCH 7/8] xfs/43[4-6]: make module reloading optional
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915319.896550.14222768162023866668.stgit@frogsfrogsfrogs>
In-Reply-To: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
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

These three tests examine two things -- first, can xfs CoW staging
extent recovery handle corruptions in the refcount btree gracefully; and
second, can we avoid leaking incore inodes and dquots.

The only cheap way to check the second condition is to rmmod and
modprobe the XFS module, which triggers leak detection when rmmod tears
down the caches.  Currently, the entire test is _notrun if module
reloading doesn't work.

Unfortunately, these tests never run for the majority of XFS developers
because their testbeds either compile the xfs kernel driver into vmlinux
statically or the rootfs is xfs so the module cannot be reloaded.  The
author's testbed boots from NFS and does not have this limitation.

Because we've had repeated instances of CoW recovery regressions not
being caught by testing until for-next hits my machine, let's make the
module reloading optional in all three tests to improve coverage.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/module |   34 +++++++++++++++++++++++++++++-----
 tests/xfs/434 |    3 +--
 tests/xfs/435 |    3 +--
 tests/xfs/436 |    3 +--
 4 files changed, 32 insertions(+), 11 deletions(-)


diff --git a/common/module b/common/module
index 6efab71d34..f6814be34e 100644
--- a/common/module
+++ b/common/module
@@ -48,12 +48,15 @@ _require_loadable_module()
 	modprobe "${module}" || _notrun "${module} load failed"
 }
 
-# Check that the module for FSTYP can be loaded.
-_require_loadable_fs_module()
+# Test if the module for FSTYP can be unloaded and reloaded.
+#
+# If not, returns 1 if $FSTYP is not a loadable module; 2 if the module could
+# not be unloaded; or 3 if loading the module fails.
+_test_loadable_fs_module()
 {
 	local module="$1"
 
-	modinfo "${module}" > /dev/null 2>&1 || _notrun "${module}: must be a module."
+	modinfo "${module}" > /dev/null 2>&1 || return 1
 
 	# Unload test fs, try to reload module, remount
 	local had_testfs=""
@@ -68,8 +71,29 @@ _require_loadable_fs_module()
 	modprobe "${module}" || load_ok=0
 	test -n "${had_scratchfs}" && _scratch_mount 2> /dev/null
 	test -n "${had_testfs}" && _test_mount 2> /dev/null
-	test -z "${unload_ok}" || _notrun "Require module ${module} to be unloadable"
-	test -z "${load_ok}" || _notrun "${module} load failed"
+	test -z "${unload_ok}" || return 2
+	test -z "${load_ok}" || return 3
+	return 0
+}
+
+_require_loadable_fs_module()
+{
+	local module="$1"
+
+	_test_loadable_fs_module "${module}"
+	ret=$?
+	case "$ret" in
+	1)
+		_notrun "${module}: must be a module."
+		;;
+	2)
+		_notrun "${module}: module could not be unloaded"
+		;;
+	3)
+		_notrun "${module}: module reload failed"
+		;;
+	esac
+	return "${ret}"
 }
 
 # Print the value of a filesystem module parameter
diff --git a/tests/xfs/434 b/tests/xfs/434
index 12d1a0c9da..ca80e12753 100755
--- a/tests/xfs/434
+++ b/tests/xfs/434
@@ -30,7 +30,6 @@ _begin_fstest auto quick clone fsr
 
 # real QA test starts here
 _supported_fs xfs
-_require_loadable_fs_module "xfs"
 _require_quota
 _require_scratch_reflink
 _require_cp_reflink
@@ -77,7 +76,7 @@ _scratch_unmount 2> /dev/null
 rm -f ${RESULT_DIR}/require_scratch
 
 echo "See if we leak"
-_reload_fs_module "xfs"
+_test_loadable_fs_module "xfs"
 
 # success, all done
 status=0
diff --git a/tests/xfs/435 b/tests/xfs/435
index 44135c7653..b52e9287df 100755
--- a/tests/xfs/435
+++ b/tests/xfs/435
@@ -24,7 +24,6 @@ _begin_fstest auto quick clone
 
 # real QA test starts here
 _supported_fs xfs
-_require_loadable_fs_module "xfs"
 _require_quota
 _require_scratch_reflink
 _require_cp_reflink
@@ -55,7 +54,7 @@ _scratch_unmount 2> /dev/null
 rm -f ${RESULT_DIR}/require_scratch
 
 echo "See if we leak"
-_reload_fs_module "xfs"
+_test_loadable_fs_module "xfs"
 
 # success, all done
 status=0
diff --git a/tests/xfs/436 b/tests/xfs/436
index d010362785..02bcd66900 100755
--- a/tests/xfs/436
+++ b/tests/xfs/436
@@ -27,7 +27,6 @@ _begin_fstest auto quick clone fsr
 
 # real QA test starts here
 _supported_fs xfs
-_require_loadable_fs_module "xfs"
 _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command falloc # fsr requires support for preallocation
@@ -72,7 +71,7 @@ _scratch_unmount 2> /dev/null
 rm -f ${RESULT_DIR}/require_scratch
 
 echo "See if we leak"
-_reload_fs_module "xfs"
+_test_loadable_fs_module "xfs"
 
 # success, all done
 status=0

