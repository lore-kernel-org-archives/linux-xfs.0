Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4674F34D918;
	Tue, 21 Oct 2025 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071985; cv=none; b=cnsc/I1Nx8XkFG5VdsqpVRy8y8tQ1HHZR4Oc/PewXk6pp7iUZdMo8jOuyZc+AsNE+G1NFL2CCKFreo163hIPBOo8a2MUYPWGsdlbkP1JWHjC2GukqOi9YfuOKV2q6bTxMzEQbo1SgB9m08aU7VSHE+7DbmB4EJRAi+LHr5gPJj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071985; c=relaxed/simple;
	bh=HhJjAc6AdEOJYrvjSU4WHLRGay08P/qmzG7SWsnAMuk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucZAhLRzD8JPTRd80BqYwdkIUe4E4bTWOiJdUPW76c3eVenho3F6icIcNj6PHEcNLxmhEeK6wlsSMwAI2eAPsuErZmzHof5vQZ6e4lX+LJZAyWqTsrDMRjBDEYK/7bmVPKsY/o1fPD+9wb9vwKAq1VldZwSyq+KXeYfWX21zcjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lmu6q6X7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lmu6q6X7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC46C4CEF1;
	Tue, 21 Oct 2025 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071983;
	bh=HhJjAc6AdEOJYrvjSU4WHLRGay08P/qmzG7SWsnAMuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lmu6q6X7DUS3iyVBy3vbdxqt77/Z8pA9prUOwfSBZlBKnfDqlFK26y+XGkWO7wIjh
	 DxFRazzO+nBM7eJc6LTYbuVxozm0kPfIYSEeNxaKzv4BRslEtAwK6QqEe0Z781Nnsr
	 FHr2GnBz/z5bnSzozOhTA70i4t51ttYpJtHnqgWfpHimrxFmnSwXkcTEAMtw9Drb1V
	 bmuoKFgv1x+j8W3vGEY44P+6+qdqT5LYNNfT4en/d45m7iwAd1fxY35L7lBtBolybw
	 A5v6Gfksn4d0tusN3tcnEYrEmcxuqXzeF5Z3oQLpgnRdgbrRzia6rmCIjc3BiMCZky
	 tKiZJfGgdJ8GA==
Date: Tue, 21 Oct 2025 11:39:43 -0700
Subject: [PATCH 02/11] common/rc: fix _require_xfs_io_shutdown
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176107188706.4163693.2252199643309619828.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/rc |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index 8fd7876a9b95c5..2e06e375c2cff2 100644
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

