Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF84B5672;
	Tue, 18 Jun 2024 00:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671856; cv=none; b=pxqugIPxJLYnAhI0jE0U2i7YITXfAWyGqYRvDx27Ton40SgMRiY7WfMiyueiHOzWOVB8BNnq+mFzcnyMpxnri+qdO+h198xf1h7g1+g9LS28h+3y9PppGPvE7g25ACkGpAqhUppgeDx8gkAlTzyQphK+AG+AHJgFzWcRqB6l3R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671856; c=relaxed/simple;
	bh=z1QElQGHCow+D62LL9WKBk6V15KPCcoMmJF3pT55sXs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W3Yh/b6R5rFIOjvUHk/9pD6LWO/LhBkrMa9IETIhYtEWB3kyoHI9EC9r2UjVF8Lp0Xh1cJExRTEfWZK+w6pG0yQT0ZiepuAu4ebVXX7gvU40/0CM8Ua0XnmyeqDMy28GNT6CDPwHmxXELBfQpzNreqlwI/UdTOEhE06KUlVk0UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQwCbo61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQwCbo61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388DEC4AF1A;
	Tue, 18 Jun 2024 00:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671856;
	bh=z1QElQGHCow+D62LL9WKBk6V15KPCcoMmJF3pT55sXs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cQwCbo61aV2d/1aQhOqmPfxh5Q8C52wzUhq1M9aqz2DRfEN+Fmhlh+qnL9tZoT0GI
	 6e7hupx+E9BGdHAO0jC2px+gBHdSb/34A3iJcKDZv2LQLeVP2zyQkxUv0KByBnWhjb
	 W1miOtwtLgYANwT9iWvOAdUQy9B2CQy0Sx3xlkz26Qoi1FW3vTcRQM0sQekQmBg30h
	 83LRaNFBkipld5DnlXvRWM+auVrPBFT85PjaaEubTqiGg1q1rHnbrpeklq0vIUa6Vl
	 2XyaFufvaCJrPfwLZpUCQH6ZUaTk5RQQFA9mVWDIpMBfmA1H50tcCXT7LngnsbtabX
	 C3FTbBBaKJL2A==
Date: Mon, 17 Jun 2024 17:50:55 -0700
Subject: [PATCH 06/11] xfs/{018,191,288}: disable parent pointers for this
 test
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <171867145899.793846.9319639235704732288.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
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

These tests depend heavily on the xattr formats created for new files.
Parent pointers break those assumptions, so force parent pointers off.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   15 +++++++++++++++
 tests/xfs/018 |    4 ++++
 tests/xfs/191 |    3 +++
 tests/xfs/288 |    4 ++++
 4 files changed, 26 insertions(+)


diff --git a/common/xfs b/common/xfs
index 0b0863f1dc..6fc7d83251 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1847,3 +1847,18 @@ _require_xfs_nocrc()
 		_notrun "v4 file systems not supported"
 	_scratch_unmount
 }
+
+# Adjust MKFS_OPTIONS as necessary to avoid having parent pointers formatted
+# onto the filesystem
+_xfs_force_no_pptrs()
+{
+	# Nothing to do if parent pointers aren't supported by mkfs
+	$MKFS_XFS_PROG 2>&1 | grep -q parent=0 || return
+
+	if echo "$MKFS_OPTIONS" | grep -q 'parent='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/parent=[01]/parent=0/g')"
+		return
+	fi
+
+	MKFS_OPTIONS="$MKFS_OPTIONS -n parent=0"
+}
diff --git a/tests/xfs/018 b/tests/xfs/018
index 73040edc92..7d1b861d1c 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -111,6 +111,10 @@ attr32l="X$attr32k"
 attr64k="$attr32k$attr32k"
 
 echo "*** mkfs"
+
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+_xfs_force_no_pptrs
 _scratch_mkfs >/dev/null
 
 blk_sz=$(_scratch_xfs_get_sb_field blocksize)
diff --git a/tests/xfs/191 b/tests/xfs/191
index 7a02f1be21..e2150bf797 100755
--- a/tests/xfs/191
+++ b/tests/xfs/191
@@ -33,6 +33,9 @@ _fixed_by_kernel_commit 7be3bd8856fb "xfs: empty xattr leaf header blocks are no
 _fixed_by_kernel_commit e87021a2bc10 "xfs: use larger in-core attr firstused field and detect overflow"
 _fixed_by_git_commit xfsprogs f50d3462c654 "xfs_repair: ignore empty xattr leaf blocks"
 
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+_xfs_force_no_pptrs
 _scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
 cat $tmp.mkfs >> $seqres.full
 source $tmp.mkfs
diff --git a/tests/xfs/288 b/tests/xfs/288
index aa664a266e..60fb9360f4 100755
--- a/tests/xfs/288
+++ b/tests/xfs/288
@@ -19,6 +19,10 @@ _supported_fs xfs
 _require_scratch
 _require_attrs
 
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+_xfs_force_no_pptrs
+
 # get block size ($dbsize) from the mkfs output
 _scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs

