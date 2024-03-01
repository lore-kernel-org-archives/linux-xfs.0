Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384FB16FF5F;
	Fri,  1 Mar 2024 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315486; cv=none; b=XYYBVgQaxrzDmLUCBElL1MnMRJxTPcy/qAc1fPYIjwc+nECnlHFz6E7pB5fSYiw89vILtSjJ9hDIrVXPPI1EdlIYCgVQJEszl2RaOrdY3huFaeMBxqRstz7joalNrzZWlOJQ1gfVbZrQAN26VSE6jlmaPzsHuznJfNbffFv0lG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315486; c=relaxed/simple;
	bh=uDC9DTPQu25YaL2xvWyuK1LaSXBe06tjeJbS4V9h1tQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZGdF9vJSZtOdNbpN6zEVkjxHYmu2Xz2gXm75Pzx5pMq7wpL6fgxYlKgoGRgwzQUb7V+QaqomgeNDnFFO+NIDX+eaWlDMlWMSWC2eDKJRIDQ2R8JRL6sKwEd33uf0Pac8crREsebYGVk+OyGYCUNNXlg06EHJSjyEtBbU5M7+LrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAeeScMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAeeScMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B94C433C7;
	Fri,  1 Mar 2024 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709315484;
	bh=uDC9DTPQu25YaL2xvWyuK1LaSXBe06tjeJbS4V9h1tQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IAeeScMiEwUYOgz5FHiX34kdhOVeBIG7AFGI4zJkN3+LyR8Zkdm8Bz0N7KZpd0Gik
	 fN4qfqCQOBuhsyJ2WGK1gH60jH3g4pL5GWOa1oeiQ9/fYTTU6D31DxSDCYL2mf7pTU
	 Z1C3gpL2HKPW52SQrNErHQnLGh3Uru/DLcXSNIjdV6UQ5DGFckLTtxGiebGVx/AkLK
	 IZRl3C1lrANW5YNGSjfDY2LnuOv8DbRUxjiUvQVuRZ3pzH/U8I4QV5550MSb2k/t1V
	 QLOnMR00v1uRmrfXII2hmDbg0KAGywyrTIAzl0lafLiTu/V4G+Fho9VWCsRZF4VsOV
	 y+S+ejSBsKKWQ==
Date: Fri, 1 Mar 2024 09:51:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Subject: [PATCH v1.1 7/8] xfs/43[4-6]: make module reloading optional
Message-ID: <20240301175124.GJ1927156@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915319.896550.14222768162023866668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915319.896550.14222768162023866668.stgit@frogsfrogsfrogs>

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
v1.1: address some review comments from maintainer
---
 common/module |   33 ++++++++++++++++++++++++++++-----
 tests/xfs/434 |    3 +--
 tests/xfs/435 |    3 +--
 tests/xfs/436 |    3 +--
 4 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/common/module b/common/module
index 6efab71d34..a8d5f492d3 100644
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
@@ -68,8 +71,28 @@ _require_loadable_fs_module()
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
