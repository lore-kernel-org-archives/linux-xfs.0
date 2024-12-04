Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD8022071;
	Wed,  4 Dec 2024 03:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733283967; cv=none; b=Nl1wdEy1q7SQKgAgMB5DSZgZ/E8mluet39xrkbkwSEAWpYvJG0Bopaj26oZ5gvq7idyME+CQsrd7LTb3HANi5hpx7f5jx1DqzXC7Ev74dXQynHcqOgfmyKlBCjt95wsYA7XR18NsxNwngZClXV6yujnnY7Bwj2VC3BH7YhNB8qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733283967; c=relaxed/simple;
	bh=7qqUIfLwqLb1hvkaD7Yd31n7RRI+LKvdMrxFdPUy2pk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJguTm8zjNC/91XJh5RHSzE+7sOEKRtZ30ncsKwUOsbSYMs6m84saRuXmRvWK47bOvMLxqEeN7wKSJBusXolihxspi8+BVdy0d6bpV0sztH/I+qrdoCL0lPPgYq5i+5QZiQrbfI7ExMQLXRFIk8S/X7s1zsC0CiLDn+KOxBgKZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emF9Z1tF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emF9Z1tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8152BC4CED1;
	Wed,  4 Dec 2024 03:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733283965;
	bh=7qqUIfLwqLb1hvkaD7Yd31n7RRI+LKvdMrxFdPUy2pk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=emF9Z1tFy2/hJsQqOvfTUaMirxnOYW2Ezej8AGvJ3/AmupE02hMDJDZLLKwtPeeGD
	 cj/6ZKH+lXxLDqwfw+381j908n5AgbeopzeityFwmXIOISO8sAEr2hMF4oH/2BzRjx
	 p65HRQmIo2s5a2d54PL+3fKenBfpVqCojeYm+vQxN2ubwIPBv6tX19qT/lNC32Fi8P
	 3q+f3ZlU0e+OdsLP4Pu+SDvXLzflfFJXkDChX/MNxhCaAiWOvYClSj8nvGlMRuWnar
	 7VeJqKMrXGxyu912mECnW7ulidguLJ4VcbOG1cHQ5N3QbFky1pDiCRmI1Ie/h6XTs5
	 dBgcB5W6KCePA==
Date: Tue, 03 Dec 2024 19:46:05 -0800
Subject: [PATCH 2/2] xfs/43[4-6]: implement impatient module reloading
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173328390016.1190210.6222399993436200525.stgit@frogsfrogsfrogs>
In-Reply-To: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
References: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

These three tests try to reload the xfs module as a cheap way to detect
leaked inode and dquot objects when the slabs for those object are torn
down during rmmod.  Removal might not succeed, and we don't really care
for that case because we still want to exercise the log recovery code.

However, if (say) the root filesystem is xfs, then removal will never
succeed.  There's no way that waiting 50 seconds(!) per test is going
to change that.  Add a silly helper to do it fast or go home.

Reported-by: sandeen@sandeen.net
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/module |   11 +++++++++++
 tests/xfs/434 |    2 +-
 tests/xfs/435 |    2 +-
 tests/xfs/436 |    2 +-
 4 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/common/module b/common/module
index a8d5f492d3f416..697d76ba718bbc 100644
--- a/common/module
+++ b/common/module
@@ -214,3 +214,14 @@ _patient_rmmod()
 
 	return $mod_ret
 }
+
+# Try to reload a filesystem driver.  Don't wait if we can't remove the module,
+# and don't let failures related to removing the module escape.  The caller
+# doesn't care if removal doesn't work.
+_optional_reload_fs_module()
+{
+	MODPROBE_PATIENT_RM_TIMEOUT_SECONDS=0 \
+		MODPROBE_REMOVE_PATIENT="" \
+		_test_loadable_fs_module "$@" 2>&1 | \
+		sed -e '/patient module removal/d'
+}
diff --git a/tests/xfs/434 b/tests/xfs/434
index c5122884324eb0..fe609b138d732b 100755
--- a/tests/xfs/434
+++ b/tests/xfs/434
@@ -74,7 +74,7 @@ _scratch_unmount 2> /dev/null
 rm -f ${RESULT_DIR}/require_scratch
 
 echo "See if we leak"
-_test_loadable_fs_module "xfs"
+_optional_reload_fs_module "xfs"
 
 # success, all done
 status=0
diff --git a/tests/xfs/435 b/tests/xfs/435
index 0bb5675e1dba23..22c02fbd1289bb 100755
--- a/tests/xfs/435
+++ b/tests/xfs/435
@@ -52,7 +52,7 @@ _scratch_unmount 2> /dev/null
 rm -f ${RESULT_DIR}/require_scratch
 
 echo "See if we leak"
-_test_loadable_fs_module "xfs"
+_optional_reload_fs_module "xfs"
 
 # success, all done
 status=0
diff --git a/tests/xfs/436 b/tests/xfs/436
index 1f7eb329e1394e..6a9d93d95f432f 100755
--- a/tests/xfs/436
+++ b/tests/xfs/436
@@ -69,7 +69,7 @@ _scratch_unmount 2> /dev/null
 rm -f ${RESULT_DIR}/require_scratch
 
 echo "See if we leak"
-_test_loadable_fs_module "xfs"
+_optional_reload_fs_module "xfs"
 
 # success, all done
 status=0

