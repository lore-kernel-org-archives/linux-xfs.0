Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD5FF9C3;
	Wed,  7 Feb 2024 02:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272349; cv=none; b=li12hQXxGt5MJUJf57paU+AuL6EKZE2nzKHm6/i7mORLMvP6w/X8VuavI5ImI/LcB0V/94CmNknXKK+8oH3fIo1K9ZBkV15twiCK53SI/EYOqE2QLT4r/m39M90kXbiwDWUAWyPT0BF0zOkyTxyo2vdXec7D3h5e8Zvc2FBne7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272349; c=relaxed/simple;
	bh=lyqMSNXvolgxaaMKuPV1joOmxLSzc6JKNIqxchBCgM4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iSkZ5S5lpip0Xi99nrZ2o0B4HhfihA7Ki5GOazlt8+YBfr/qzMx0NxVegPDo6D+XFr2VIMriSVgjeUcHFz4ngL8YhgRjYSi+sfmZXN4VglNWjL3Kehd6pOa84kTMlFSShLi7Qbf8oWhagm3XlKnlRcx3GJo1lEsZQBs3FG98TGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ujx7QAFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ujx7QAFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6ECC433F1;
	Wed,  7 Feb 2024 02:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272348;
	bh=lyqMSNXvolgxaaMKuPV1joOmxLSzc6JKNIqxchBCgM4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=ujx7QAFk+QuNlHamNhGZFwE/WzPWWIVWpKz54QRi3s85poMIzRPR3fIb9sM8xe+fV
	 XyALonYhhGKCKrLzt3d/mM7XXu2JgBe+Rjv3Fp8aID0x5IRs/flEjwC82TTZ/n7U8C
	 ryMYF4Df2R63mHKUC8RsZ4dC+7rznlSDaKhthucZXri4l5+rC58XFl1AAQCY/KApY8
	 jk9AEzeOaREujgPtrdoiKIjnz6OIcMSt/Cc4CXtDw4CmXiPVaBW0/NN/H1HlSY0bI2
	 orfVCghSlSHVcRuiVTH0ColKPZZYnOPqhhp27yktzPapYEKA5lxyP1KpkPYH+a0IxA
	 aIdUWdM9i2xFg==
Subject: [PATCH 06/10] xfs/{129,234,253,605}: disable metadump v1 testing with
 external devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:19:08 -0800
Message-ID: <170727234812.3726171.2841992060887445453.stgit@frogsfrogsfrogs>
In-Reply-To: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
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

The metadump v1 format does not support capturing content from log
devices or realtime devices.  Hence it does not make sense to test these
scenarios.  Create predicates to decide if we want to test a particular
metadump format, then convert existing tests to check formats
explicitly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/metadump |   25 ++++++++++++++++++++-----
 tests/xfs/605   |    9 ---------
 2 files changed, 20 insertions(+), 14 deletions(-)


diff --git a/common/metadump b/common/metadump
index 4b576f045e..3373edfe92 100644
--- a/common/metadump
+++ b/common/metadump
@@ -37,6 +37,24 @@ _xfs_cleanup_verify_metadump()
 	fi
 }
 
+# Can xfs_metadump snapshot the fs metadata to a v1 metadump file?
+_scratch_xfs_can_metadump_v1()
+{
+	# metadump v1 does not support log devices
+	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_LOGDEV" ] && return 1
+
+	# metadump v1 does not support realtime devices
+	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && return 1
+
+	return 0
+}
+
+# Can xfs_metadump snapshot the fs metadata to a v2 metadump file?
+_scratch_xfs_can_metadump_v2()
+{
+	test "$MAX_XFS_METADUMP_VERSION" -ge 2
+}
+
 # Create a metadump in v1 format, restore it to fs image files, then mount the
 # images and fsck them.
 _xfs_verify_metadump_v1()
@@ -129,9 +147,6 @@ _xfs_verify_metadump_v2()
 # Verify both metadump formats if possible
 _xfs_verify_metadumps()
 {
-	_xfs_verify_metadump_v1 "$@"
-
-	if [[ $MAX_XFS_METADUMP_FORMAT == 2 ]]; then
-		_xfs_verify_metadump_v2 "$@"
-	fi
+	_scratch_xfs_can_metadump_v1 && _xfs_verify_metadump_v1 "$@"
+	_scratch_xfs_can_metadump_v2 && _xfs_verify_metadump_v2 "$@"
 }
diff --git a/tests/xfs/605 b/tests/xfs/605
index 13cf065495..78458c7665 100755
--- a/tests/xfs/605
+++ b/tests/xfs/605
@@ -40,15 +40,6 @@ testfile=${SCRATCH_MNT}/testfile
 echo "Format filesystem on scratch device"
 _scratch_mkfs >> $seqres.full 2>&1
 
-external_log=0
-if [[ $USE_EXTERNAL = yes && -n "$SCRATCH_LOGDEV" ]]; then
-	external_log=1
-fi
-
-if [[ $MAX_XFS_METADUMP_FORMAT == 1 && $external_log == 1 ]]; then
-	_notrun "metadump v1 does not support external log device"
-fi
-
 echo "Initialize and mount filesystem on flakey device"
 _init_flakey
 _load_flakey_table $FLAKEY_ALLOW_WRITES

