Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9237B1D517E;
	Wed, 12 Feb 2025 03:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331401; cv=none; b=lNJs/Oyb+/CtT6rC/VoKTDppZbiFCsNobKoPbXHkudVrQmlrznrKbeACTk/SYmdf7AEPKjiRqhkDj8Jo4RyNLLgJbEoa+ZYASd7L+UlxWZm0GivJgeekHAdReMfz/J9t5u4RzCEYuPBOpFYhV6jtfPkEou8LNhQkdZ5lIc9QPz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331401; c=relaxed/simple;
	bh=IzQUuj4zbHV5ShG+a7BRIxwQyel6Oi31iDSEDqT0RhQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hErp5URrx28r8MFcdzNpPg5rkG6jaYaq5m+U7sd/n0r9HPMNgOzeOD/4bHNHeO8OmKfeS3Avs/d2Tksi1bZ8+IvdGX5ghESuffQ8WWM5WwI6Cx3ZeUbQsnUkOHSDI5zItmV4Z9PJ5FLapa4wjM+/xrLRpTOrNqfFbWwks8u1BHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKKOC1uI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKKOC1uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09534C4CEDF;
	Wed, 12 Feb 2025 03:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331401;
	bh=IzQUuj4zbHV5ShG+a7BRIxwQyel6Oi31iDSEDqT0RhQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kKKOC1uIgHhcY9tfI9/EW+hIZfvIiA/FsJ/3814nyKb/h2Jpw51JMkepa4CRigx0B
	 6tPqyZ6GArrw056ETPmeFdDOOpAn7p7LDIfp2P4a4ZoTq//WSBJzbT0kwDrCIimYxW
	 iL0rByPkt92JJgAXXo52OdO9grLaJQbe3nq2kpYpNPYXUPcugrm32ddqT/q5UuH4pF
	 Id7GrdhlUXj+xNklwxCK1u2qaebMky+CHscw2d9XnjalF7gxPmxTArQwgbR8lCMTcf
	 k54Nnowt0FERz9cDdeTDwknc+8Sm+N/GCpv2m/29lyYQoBM4pCIY2pr//cvzK8V6Vm
	 J8imVTj5+8bJw==
Date: Tue, 11 Feb 2025 19:36:40 -0800
Subject: [PATCH 23/34] generic/032: fix pinned mount failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094708.1758477.9942723311400032702.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/rc         |   10 ++++++++++
 tests/generic/032 |    9 +++++++++
 2 files changed, 19 insertions(+)


diff --git a/common/rc b/common/rc
index 12041995e9ce75..26b6b3029a25f7 100644
--- a/common/rc
+++ b/common/rc
@@ -40,6 +40,16 @@ _pkill()
 	fi
 }
 
+# Find only the test processes started by this test
+_pgrep()
+{
+	if [ "$FSTESTS_ISOL" = "setsid" ]; then
+		pgrep --session 0 "$@"
+	else
+		pgrep "$@"
+	fi
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

