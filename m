Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026257082F;
	Fri, 22 Nov 2024 16:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294244; cv=none; b=hojR9yCf2NmaHtI18dBoNchhRRMqtFqJVACnz3b5aeHv0PF5P4pBbfJl7vLXKvJelc53xPEcngFIEHwkzz/xGqAbTgfcOkE4N7joWvFCS29+RRk9Bfs5myS/7aZPeKiUOBMf9n2q+KfQvAgif5XFZzerQIFda2yTnjbb+NNtZrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294244; c=relaxed/simple;
	bh=118F3cLeQLECfTPe2n1rCyAfJUReJzNfz7TOatchghk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmQyQ+3a4SHj3biQ994Zapo2Z9JQxzv4CfBn2QKiCNX6zc2c6u1W2fDRefLMe+yLyVRJSxwVxJu4YBV6Gr2Sw3+10fL4SnTYg2QSoLBoJPFXNdDK+T8pDFQVeuwSa/WMTswGVlVwpVMEdVGD5/lO3ZQ674lrZqTJKuXPLwyxkNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHlfgO7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHlfgO7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5BFC4CED0;
	Fri, 22 Nov 2024 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294243;
	bh=118F3cLeQLECfTPe2n1rCyAfJUReJzNfz7TOatchghk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UHlfgO7HOVDGo7P4spHb0h7hLQtNmSxbpkt4l8J+ciSA0L+Zu4qbVozhR/g+x4aIj
	 OdMJNJTErAzWNlmuwGLBtNJrasKu6wNl7x7v1rdyPyCTy+EVpfhurVmXmgNXiWMHds
	 YkQHNtjlQ38WAKzIV8W7p/hy0kgWwm6yJqdZkxI1ok7/NTrx5Mf1MlxSbXXHjJNahx
	 kSf/xINsyM3F+einNTrDQ9MBknAucr9dyugfyc9dtc8KLyLv82rbUWkXZccHeWyny3
	 ZO1RI18Hq/xMYTuPiwicc7f+bmb58RQoGJXvbocNrgL+RGOUsjyvr5of7VHqHIjzlq
	 MAWVxNYl20UYw==
Date: Fri, 22 Nov 2024 08:50:43 -0800
Subject: [PATCH 01/17] generic/757: fix various bugs in this test
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420029.358248.9101250955454761474.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this test so the check doesn't fail on XFS, and restrict runtime to
100 loops because otherwise this test takes many hours.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/757 |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/generic/757 b/tests/generic/757
index 0ff5a8ac00182b..37cf49e6bc7fd9 100755
--- a/tests/generic/757
+++ b/tests/generic/757
@@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
 cur=$(_log_writes_find_next_fua $prev)
 [ -z "$cur" ] && _fail "failed to locate next FUA write"
 
-while [ ! -z "$cur" ]; do
+while _soak_loop_running $((100 * TIME_FACTOR)); do
 	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
 
+	# xfs_repair won't run if the log is dirty
+	if [ $FSTYP = "xfs" ]; then
+		_scratch_mount
+		_scratch_unmount
+	fi
 	_check_scratch_fs
 
 	prev=$cur

