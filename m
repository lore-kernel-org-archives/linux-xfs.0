Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C24C22259D;
	Wed, 15 Oct 2025 16:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546235; cv=none; b=TAq2PJOvyPmNU7afiXJj3/44WuJrjE3/+73eeHcYKlzP9LE2Kc4MsMy50AOX6k0n2VWwX1Uvgu8Nq5lgwqDRiFxAQQwALXMWpuseRzi0s7TNgxoYSuLCA9kuAAGj7GTFiRNv+2ZnV0CLMJY3DVT91o0d/x9tZPgk5yyFtq5ly2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546235; c=relaxed/simple;
	bh=E3lULbK8CyAQQvMWepphSW/iDDf+BBzkiHuGlOqVn9A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DeelbDnDi8SoPTVLszUORNnXX6n6rIEkmaNbWlmJg/7JYH+qXCbwh7R8hM79KBbSCTERxG3jATkL7Ux/ionlRU/SFhlCEHq8Sb9BU8mlNlFb88081ILYgWvXBNrLmnVDaw5T7Pzfs5BH5A/WIkSjZ2Fz7w0Em7Y8iDPJ+YiVkyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/E/ZV1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/E/ZV1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F445C4CEF8;
	Wed, 15 Oct 2025 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546234;
	bh=E3lULbK8CyAQQvMWepphSW/iDDf+BBzkiHuGlOqVn9A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D/E/ZV1uOxot1c4t3qZd7tKvfMwR2Q8Cw56pRoj+q0T5diUNJwoAfBAbUIARy7IZL
	 5sd/c+N3a2TPCaZRo8rZPoOAXwuE6MIpNKxKMmps3BzxwMbNcm6m6b/eQeKlf3piyZ
	 gbkuBpn5QhiUjcORwLT8VFl+iJ8aKXHH9Vj/wh/okkXUB4yFrlbEEIpBRhbef3X6Jb
	 dsiZEEl9DpWuVpq2r7dKH659uk1te5sc0CGjvfnrquLi6kL4zsOjcoMG6OrauHhFbM
	 dBQ1IWFXNP+YRgV07bVXredLRVMev5raaVbNQ1g58imebXVFMYCbNb6bdmF6uEsP4m
	 4+pzG9rFlSBcA==
Date: Wed, 15 Oct 2025 09:37:13 -0700
Subject: [PATCH 2/8] common/rc: fix _require_xfs_io_shutdown
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176054617932.2391029.3304833304093152893.stgit@frogsfrogsfrogs>
In-Reply-To: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Capturing the output of _scratch_shutdown_handle requires one to enclose
the callsite with $(), otherwise you're comparing the literal string
"_scratch_shutdown_handle" to $SCRATCH_MNT, which always fails.

Also fix _require_xfs_io_command to handle testing the shutdown command
correctly.

Cc: <fstests@vger.kernel.org> # v2025.06.22
Fixes: 4b1cf3df009b22 ("fstests: add helper _require_xfs_io_shutdown")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index 1ec84263c917c0..1b78cd0c358bb9 100644
--- a/common/rc
+++ b/common/rc
@@ -619,7 +619,7 @@ _scratch_shutdown_and_syncfs()
 # requirement down to _require_scratch_shutdown.
 _require_xfs_io_shutdown()
 {
-	if [ _scratch_shutdown_handle != $SCRATCH_MNT ]; then
+	if [ $(_scratch_shutdown_handle) != $SCRATCH_MNT ]; then
 		# Most likely overlayfs
 		_notrun "xfs_io -c shutdown not supported on $FSTYP"
 	fi
@@ -3073,6 +3073,11 @@ _require_xfs_io_command()
 		rm -f $testfile.1
 		param_checked="$param"
 		;;
+	"shutdown")
+		testio=$($XFS_IO_PROG -f -x -c "$command $param" $testfile 2>&1)
+		param_checked="$param"
+		_test_cycle_mount
+		;;
 	"utimes" )
 		testio=`$XFS_IO_PROG -f -c "utimes 0 0 0 0" $testfile 2>&1`
 		;;

