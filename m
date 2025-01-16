Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C29158520;
	Thu, 16 Jan 2025 23:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070130; cv=none; b=H0RKCHu0NWqfM2WUk3E2JmGLkpG5joI9Z3v4z8hFTmAwWpDlGST1dfU8LV5pgBEYr1Ks4FyudnpaKdnK1aAuU8/8nTZ9JOWPgRKDcpm1q0E6T3gX5NTkVgVvAQ5n9v0WlOF8lsfbh3sXw3F3sW27HvlHtjpAcLrG1+yOfBJIjhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070130; c=relaxed/simple;
	bh=ieWnkCipB5kPbcx22+AjHHxCnlqGHMblPx9+o2f3+e4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQPgIUd1cGhCV4+vEe9R2IYGuoXh4Tn7wbFPlZQgsXRJrqwxDEm2GeSMPQbj/+T2K56gTfEwhYOkOCFrQxIPo77vyaYMxVXpB4YXBcT9vgwB6Xy/MU2rQjTPhzOTmo5n4Cd0xejucS3Bj5R5hL0ttZc0sBdnqjrJUD/529sMJ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rofbTrzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rofbTrzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF74BC4CEE3;
	Thu, 16 Jan 2025 23:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070129;
	bh=ieWnkCipB5kPbcx22+AjHHxCnlqGHMblPx9+o2f3+e4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rofbTrzZlVpyRytyExye0iAHYIg5e4B2F0laGxJFDwjevGuUcPZV2B8VUDIyr7VJj
	 Mw0wHvkJkzgHVPEStqJ4EhrHzGFIh3DS2slzoSS/DKjymmVw+aNmyQ9n03M99hRNNT
	 ueZOpRMCmPPMqNDmVmm3vhEhuorznVgdzF8O4ctXvAjlo9DgheD6/IaJYDR9L3m9C3
	 APgQxN+QK2BEDOX3fSXLwy0nIx2a2S6uxvgaPrdT1p13iCdsp8A1U2Uaz+KEUPrlne
	 uMBD0fFu4iLlHFbo+LEKTQp4+K9qa9el46B2zL/OSGFQgXHXZcikzykJ0M47s2oxgZ
	 TTuT7Dzolkb6A==
Date: Thu, 16 Jan 2025 15:28:49 -0800
Subject: [PATCH 14/23] generic/032: fix pinned mount failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974288.1927324.17585931341351454094.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

generic/032 now periodically fails with:

 --- /tmp/fstests/tests/generic/032.out	2025-01-05 11:42:14.427388698 -0800
 +++ /var/tmp/fstests/generic/032.out.bad	2025-01-06 18:20:17.122818195 -0800
 @@ -1,5 +1,7 @@
  QA output created by 032
  100 iterations
 -000000 cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  >................<
 -*
 -100000
 +umount: /opt: target is busy.
 +mount: /opt: /dev/sda4 already mounted on /opt.
 +       dmesg(1) may have more information after failed mount system call.
 +cycle mount failed
 +(see /var/tmp/fstests/generic/032.full for details)

The root cause of this regression is the _syncloop subshell.  This
background process runs _scratch_sync, which is actually an xfs_io
process that calls syncfs on the scratch mount.

Unfortunately, while the test kills the _syncloop subshell, it doesn't
actually kill the xfs_io process.  If the xfs_io process is in D state
running the syncfs, it won't react to the signal, but it will pin the
mount.  Then the _scratch_cycle_mount fails because the mount is pinned.

Prior to commit 8973af00ec212f the _syncloop ran sync(1) which avoided
pinning the scratch filesystem.

Fix this by pgrepping for the xfs_io process and killing and waiting for
it if necessary.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         |    6 ++++++
 tests/generic/032 |    9 +++++++++
 2 files changed, 15 insertions(+)


diff --git a/common/rc b/common/rc
index 4419cfc3188374..d7f3c48eafe590 100644
--- a/common/rc
+++ b/common/rc
@@ -36,6 +36,12 @@ _pkill()
 	pkill --session 0 "$@"
 }
 
+# Find only the test processes started by this test
+_pgrep()
+{
+	pgrep --session 0 "$@"
+}
+
 # Common execution handling for fsstress invocation.
 #
 # We need per-test fsstress binaries because of the way fsstress forks and
diff --git a/tests/generic/032 b/tests/generic/032
index 30290c7225a2fa..48d594fe9315b8 100755
--- a/tests/generic/032
+++ b/tests/generic/032
@@ -81,6 +81,15 @@ echo $iters iterations
 kill $syncpid
 wait
 
+# The xfs_io instance started by _scratch_sync could be stuck in D state when
+# the subshell running _syncloop & is killed.  That xfs_io process pins the
+# mount so we must kill it and wait for it to die before cycling the mount.
+dead_syncfs_pid=$(_pgrep xfs_io)
+if [ -n "$dead_syncfs_pid" ]; then
+	_pkill xfs_io
+	wait $dead_syncfs_pid
+fi
+
 # clear page cache and dump the file
 _scratch_cycle_mount
 _hexdump $SCRATCH_MNT/file

