Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8365325A62C;
	Tue,  4 Feb 2025 21:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704499; cv=none; b=E/sDdQfxfbqzjoHC3Ee//hdGj0NpQ6s7fMKLcm/ccuw/Zuu1gIPx+GO7oz4SOTpU0pSOu7xav+Yeh6dB4ev55DNqdWaeGTEujuWKMeRV7Qu3PPVCz8zXzNjea5k1gq8hDCn6oCGga12TUz/JMjPwBzyYY2jSZNZtDW78iM/BUAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704499; c=relaxed/simple;
	bh=MMmlONCTRNogRF25iNuA74j23F1OR3HzLe/Jio1IvXE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NLz78xdTR2ZedZu1Fpz6wv8sWC1xUzZwADf1mOrwC2SxIwv4M9yTnhmZ7YN3BwyWjbwxsoQEpKQ9r27doWPbrI+o+3ncMEQHpqmyRm6qI+y9P0x44JdUC2dgS+1rYC+ZUlGxYLAFNryI2fYUsTDBYJS/8gfmIH45O5M9mixb704=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNMALlOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNMALlOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F7DC4CEDF;
	Tue,  4 Feb 2025 21:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704499;
	bh=MMmlONCTRNogRF25iNuA74j23F1OR3HzLe/Jio1IvXE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LNMALlOlQiQv0zH0aXknaSxUyoaZiW6UHiVv4IlV/7nE2n7h6pvtScaPQvHchssYb
	 k9qTz380mDBL70SYN5KQUNq7fn2MrAEwn1z9LSKPZnGWFkCZ7FrkXKhudlOGlNLU19
	 zJIWHGoTg+efJxs5yWa+ncosTVVfRL3X3hACu5rR4IOGdP17+9ztmwGAvjFoBlyoco
	 rsMed6VBU/zXvivatMyTIDprIk79W1gRkvT96E6u/KKvKofjI4CgQyGwNCcyu2Whl/
	 7Qa09rfDa2eWr1UqyFqATDwQ3xHJ3/w6dMhxsTGQ3SoLrMdFFm6tod74/Qp6zdFaDy
	 l4Q9gCeRxteCQ==
Date: Tue, 04 Feb 2025 13:28:18 -0800
Subject: [PATCH 23/34] generic/032: fix pinned mount failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406457.546134.3852587950986772074.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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
index 56b4e7e018a8e0..46cd1ed16892e6 100644
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

