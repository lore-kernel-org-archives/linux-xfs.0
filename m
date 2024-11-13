Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2C4224F0;
	Wed, 13 Nov 2024 01:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461851; cv=none; b=Svsqkvz/wQrqYczyqTWIu5rLzkMJCZrzB8sjEx7szNQN8e7SbnqkiH7BelYpntT5evdR9TljvPxWJBf4C7/U7uAPazwP7z6vdNeRPvK869Mk7IBAhbEq/boB5TW5fU4n+54IFb30oKRW5c0eTT5spsULP8Imv6kpAA5D7jlA12E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461851; c=relaxed/simple;
	bh=5AluQWXplWzSgkw6kfSowGtQLFOSor0Pq+rIWf2jnM0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KoJZ4Cms45NKV/xJkKwodkkS3aXIQv6SWQhAQkCCWRz6dqUlGnr42osiG5gDPGVIe2RAfW6EVx7QnZHnoBQ309Insxon1KkL3RWiwab39Qx8BzKnADW376CeEPbCvHXwuZFGChxL3VIzb+hbImujxLjZg6tMWh4mMWldAH/KwlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2g4tnPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2g4tnPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67656C4CECD;
	Wed, 13 Nov 2024 01:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731461850;
	bh=5AluQWXplWzSgkw6kfSowGtQLFOSor0Pq+rIWf2jnM0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U2g4tnPDL9teZF2Pf0xo2eqJXvq9YtSBV2I7ComXOD6MkaVlskio5EIWJy9XgM5eB
	 0HkJHKevpsZZ7vy/wiGKEsga1xJ4apRZaXXAp7XATcmleZnXicpxzi/4HoBFl+Q46F
	 4pv1JQmLJ35x3lM+m7JZJkMUCrTDYPCsdgLlZzL4wp2mVqNuFNy45pZ+5XumDVlWD9
	 2zVki/lzh8CeWpfvsT8f1B0bVsruiYMqRUjypiG8Lv/c+lOw51zGl/u5zIa8Vk6D8p
	 xymtpqYx+tlOgNqOBzXzYHAhKWVNMeUndPrUrEsQYdg4F99LUOyUOnt3Tyf0x2FhRp
	 WjXy/ZOXYYT+A==
Date: Tue, 12 Nov 2024 17:37:29 -0800
Subject: [PATCH 3/3] generic/757: fix various bugs in this test
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173146178859.156441.16666438727834100554.stgit@frogsfrogsfrogs>
In-Reply-To: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/757 |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/generic/757 b/tests/generic/757
index 0ff5a8ac00182b..9d41975bde07bb 100755
--- a/tests/generic/757
+++ b/tests/generic/757
@@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
 cur=$(_log_writes_find_next_fua $prev)
 [ -z "$cur" ] && _fail "failed to locate next FUA write"
 
-while [ ! -z "$cur" ]; do
+for ((i = 0; i < 100; i++)); do
 	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
 
+	# xfs_repair won't run if the log is dirty
+	if [ $FSTYP = "xfs" ]; then
+		_scratch_mount
+		_scratch_unmount
+	fi
 	_check_scratch_fs
 
 	prev=$cur

