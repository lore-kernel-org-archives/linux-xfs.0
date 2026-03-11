Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7412156F45;
	Wed, 11 Mar 2026 04:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773202484; cv=none; b=Br1s195nIMrU4eGYdtXKh7izOEsRRlZeCD7V6g/ELNBwrgEN1ta+OVUbPlsLJwEXt9OvIb+riptdYUiRpMvlDhIZQy5EzA7KGhlPtw/l4i5kW76d5UX3PWlHICgc0eJ5uKs1m1u935HvKgxCmzjF/UK+ldyUuT7nhg9YYvDzY5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773202484; c=relaxed/simple;
	bh=gZJ9X2rZoyhmnbisw+42D76dMGyPoX97Y/emI/OHzQE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Xwf2XtR3JgwRpLl1MaMs8vxw7GehHVskgqdE1nZcM9xAIrQORZhYx6aJ+HBLmQSQ/Gq/4pk1MEwkcpg/jFsmKaYLTJ7jOIEDei8VELMZuJL5CBbhVjoxgexQRCLvCscZH/gcQjcWGJef0O4YkvLYFCLrWL4HmWvxgbwuNbrANHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7G8cnzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7G8cnzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529EAC4CEF7;
	Wed, 11 Mar 2026 04:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773202484;
	bh=gZJ9X2rZoyhmnbisw+42D76dMGyPoX97Y/emI/OHzQE=;
	h=Date:From:To:Cc:Subject:From;
	b=c7G8cnzCvX1wEgDsMDId6p81yylL+zHz4YxzEnM3KA/FmtTw4NxJ4buk3HvzGrz9F
	 L417ZB8AZZc/HCBuqK79bCUbdq6ozvB5v2Fy4LEIbjpYPeUiRbMYtQ5lVgYWHfRLWX
	 cRzjNfls7p7e4MgJ0QvQCzNzAsLSwIbOpnFpB19LF1E+zGlsCNMRSA3fsJQ40Mopp7
	 QDgYyuBkkskwDVO3gljrYUo/L6bmbXkxoEjwCYV0zyr7RFqnu8rWZqbkDECWMB+1h9
	 KNZIR1XSNVpzKIuhwZsgqWOlxAZyutXYyu/EGAONrLZAgVMXd6iBcQ0hBPG3lq62Ez
	 7lMa3xvRWp/eQ==
Date: Tue, 10 Mar 2026 21:14:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs/62[3-8]: require XFS_SCRUB_PROG
Message-ID: <20260311041443.GC6023@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

QA reports that xfs/62[3-8] fail because they didn't install
xfsprogs-xfs_scrub package and this test requires xfs_scrub(8).
Add the missing _require call, and update the README so that anyone
running fstests on RHEL/Fedora actually get all the necessary
components to do a full test of XFS.

Cc: <fstests@vger.kernel.org> # v2024.06.27
Fixes: 4de8fd7860a2bb ("scrub: test correction of directory tree corruptions")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 README        |    2 +-
 tests/xfs/623 |    3 +--
 tests/xfs/624 |    3 +--
 tests/xfs/625 |    3 +--
 tests/xfs/626 |    3 +--
 tests/xfs/627 |    3 +--
 tests/xfs/628 |    1 +
 7 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/README b/README
index 211e273115f08f..36684cc6572d4b 100644
--- a/README
+++ b/README
@@ -126,7 +126,7 @@ Fedora
    $ sudo yum install acl attr automake bc dbench dump e2fsprogs fio gawk gcc \
         gdbm-devel git indent kernel-devel libacl-devel libaio-devel \
         libcap-devel libtool liburing-devel libuuid-devel lvm2 make psmisc \
-        python3 quota sed sqlite udftools  xfsprogs
+        python3 quota sed sqlite udftools xfsprogs xfsprogs-xfs_scrub
 
 2. Install packages for the filesystem(s) being tested:
 
diff --git a/tests/xfs/623 b/tests/xfs/623
index aff3f903660fa7..7f79ccbcbf7f14 100755
--- a/tests/xfs/623
+++ b/tests/xfs/623
@@ -16,8 +16,7 @@ _begin_fstest auto online_repair
 . ./common/fuzzy
 . ./common/populate
 
-
-# Modify as appropriate.
+_require_scrub
 _require_xfs_db_command "link"
 _require_xfs_db_command "unlink"
 _require_scratch
diff --git a/tests/xfs/624 b/tests/xfs/624
index e63cfcc6e7ba82..09a922c8d18c8a 100755
--- a/tests/xfs/624
+++ b/tests/xfs/624
@@ -16,8 +16,7 @@ _begin_fstest auto online_repair
 . ./common/fuzzy
 . ./common/populate
 
-
-# Modify as appropriate.
+_require_scrub
 _require_xfs_db_command "link"
 _require_xfs_db_command "unlink"
 _require_scratch
diff --git a/tests/xfs/625 b/tests/xfs/625
index 23013f195c9e7f..2654216b67aa11 100755
--- a/tests/xfs/625
+++ b/tests/xfs/625
@@ -16,8 +16,7 @@ _begin_fstest auto online_repair
 . ./common/fuzzy
 . ./common/populate
 
-
-# Modify as appropriate.
+_require_scrub
 _require_xfs_db_command "link"
 _require_xfs_db_command "unlink"
 _require_scratch
diff --git a/tests/xfs/626 b/tests/xfs/626
index c424819cede6e1..3b4cdca4fe4e24 100755
--- a/tests/xfs/626
+++ b/tests/xfs/626
@@ -16,8 +16,7 @@ _begin_fstest auto online_repair
 . ./common/fuzzy
 . ./common/populate
 
-
-# Modify as appropriate.
+_require_scrub
 _require_xfs_db_command "link"
 _require_xfs_db_command "unlink"
 _require_scratch
diff --git a/tests/xfs/627 b/tests/xfs/627
index 411a7603317058..fc54199b4a95de 100755
--- a/tests/xfs/627
+++ b/tests/xfs/627
@@ -16,8 +16,7 @@ _begin_fstest auto online_repair
 . ./common/fuzzy
 . ./common/populate
 
-
-# Modify as appropriate.
+_require_scrub
 _require_xfs_db_command "link"
 _require_xfs_db_command "unlink"
 _require_scratch
diff --git a/tests/xfs/628 b/tests/xfs/628
index c77d67db358983..e003f41999f401 100755
--- a/tests/xfs/628
+++ b/tests/xfs/628
@@ -17,6 +17,7 @@ _begin_fstest scrub fsstress_scrub
 . ./common/inject
 . ./common/xfs
 
+_require_scrub
 _require_scratch
 _require_xfs_stress_scrub
 
