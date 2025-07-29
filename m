Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018521E51F6;
	Tue, 29 Jul 2025 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819727; cv=none; b=LFz44MADtAthyosDflwAanpGk2+F1W4iSCHt48BqD5iceCienfKWkkBHa2lEoxbDmd6X0m6njr7yGbunDgzpoTUf0jzclhSPgmK+28c7RpttIIByvpQw5n26iWiM6crh8TCaw0YRabisYt+65j/iqTZqE+JKPL1dwZ9ubvA8Ptc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819727; c=relaxed/simple;
	bh=4j9iKrCfCYDTYQnW7UGtDFlQMuPs6L5J+634ra8rYr0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fO79OnP5V4MUhtW770tiuPicJnrhE9gbUhPHpIxzKxmFeNLYNqd+k3X6kcroFE8v/YBIxoDMR0a1cRA+YmoTkNjvZag/mZwsl/OhxnxijT0pjyjX7KiqS3Y0fosy/ZqgKY1k8W9ppB4fmBk4THDwyP2log64je/CEEgJ3PuJphs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnSAipB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnSAipB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7537DC4CEF6;
	Tue, 29 Jul 2025 20:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819726;
	bh=4j9iKrCfCYDTYQnW7UGtDFlQMuPs6L5J+634ra8rYr0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CnSAipB9gaDHz9jQzBKkhdE1IES5BKHO7ThdygHqzQVBOwvCsoSstEFWVDVRsUDWs
	 jQszNdaA2xq3tzB89Lq2aUDpsSdbzYJW/su8LELD/llTC4qoW6ZjmkXaCoXU/ZB3nZ
	 2JVQxoLiz6oexjm9TDLuuRLA9JlGyW7wDLMj+cTHPXQKveQDZ2o/WGdg/4+9OoFb+S
	 TfSsYjJaV3jYnNTYesS7sj9Lqmmx8yEbsjnJGX/BZHdppdpA8MS8jX6R+IoBPc2MbV
	 IagNK5mXNnMv3+HLz06VaErvAOdmP1sOPoRKtEQZCb6NxI68GUSpYZZ0HSkfaT6uvN
	 OahsO2wqLsE9g==
Date: Tue, 29 Jul 2025 13:08:46 -0700
Subject: [PATCH 2/7] generic/427: try to ensure there's some free space before
 we do the aio test
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
In-Reply-To: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On a filesystem configured like this:
MKFS_OPTIONS="-m metadir=1,autofsck=1,uquota,gquota,pquota -d rtinherit=1 -r zoned=1"

This test fails like this:

--- a/tests/generic/427.out      2025-04-30 16:20:44.584246582 -0700
+++ b/tests/generic/427.out.bad        2025-07-14 10:47:07.605377287 -0700
@@ -1,2 +1,2 @@
 QA output created by 427
-Success, all done.
+pwrite: No space left on device

The pwrite failure comes from the aio-dio-eof-race.c program because the
filesystem ran out of space.  There are no speculative posteof
preallocations on a zoned filesystem, so let's skip this test on those
setups.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/427 |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/generic/427 b/tests/generic/427
index bddfdb8714e9a7..a6b2571f563167 100755
--- a/tests/generic/427
+++ b/tests/generic/427
@@ -28,6 +28,11 @@ _require_no_compress
 _scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
+# Zoned filesystems don't support speculative preallocations
+if [ "$FSTYP" = "xfs" ]; then
+	_require_xfs_scratch_non_zoned
+fi
+
 # try to write more bytes than filesystem size to fill the filesystem,
 # then remove all these data. If we still can find these stale data in
 # a file' eofblock, then it's a bug

