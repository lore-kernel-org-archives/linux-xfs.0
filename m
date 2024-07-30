Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A84A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299027; cv=none; b=l92zQ5DowFZ1pMZy4Y4ncpiMeMR/NfliP8q1dblVNVAYNFlHnur3uaYnO8SdN+gUn8xX7hypp1/l4UAVKkXw2PIcOmuAuMOFeWX3aFKQmkv0pPbS5qBE81Wpprlz1GuiM4KJYI/C+UN+ciZkJ4t/YB+MJZU+O/oorK4rCue9ukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299027; c=relaxed/simple;
	bh=ui+gvFert0CE6X27N3hTlaMQLXHl9lQEtl+p/DCV88c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iyUL1rTlaCR4oK54jTLDTu4o+lBY0HZQBmqFtYncWcKheFEMF4S32v0qblHlorOrE2RCQ1Zj6SHp1873iC4KmGvObQ02QdpXncQd9om4kG8ebYxt9Pe5WyY35/RUXcHU0LlxHeBneJMs4F3ROz9z7cOwVIYegvyKfsKZ6W7Ce+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSOmVNQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSOmVNQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8B5C32786;
	Tue, 30 Jul 2024 00:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299026;
	bh=ui+gvFert0CE6X27N3hTlaMQLXHl9lQEtl+p/DCV88c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OSOmVNQzwWtnRJTAYB6XzFQ2pxCdJskRXwDBmjjJV0IFl9mf4rKtb9UJydYUbZGku
	 5rJkbLpyUVGzzEmDjMkxSe6sqACLjE7eqonYb0hiiKoLXQKFWJOa+t6QJqErC8zDVz
	 a9WEe8SdeCVWK9hQUPlfhkZfHEBzQDAQZ/hpDDlmm/H15Il7XynD+h/IVqHudFfHhn
	 lLxrsd/Uhjj43++SWROg7lCRNaYI1Ar5nxGTuSLMIcVeOGCK2OLxNizu4s2L2enXpb
	 SmT5XGJL6m5thxAH5zid6Q7ZD3J1SwpbfTGihSUJHiRe8qItM1AuFqjVW1onQWRMzk
	 ix5X/OEiwQfkQ==
Date: Mon, 29 Jul 2024 17:23:46 -0700
Subject: [PATCH 5/5] xfs_repair: don't crash on -vv
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Santiago Kraus <santiago_kraus@yahoo.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229841949.1338302.9980286721411923996.stgit@frogsfrogsfrogs>
In-Reply-To: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
References: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
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

A user reported a crash in xfs_repair when they run it with -vv
specified on the command line.  Ultimately this harks back to xfs_m in
main() containing uninitialized stack contents, and inadequate null
checks.  Fix both problems in one go.

Reported-by: Santiago Kraus <santiago_kraus@yahoo.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/progress.c   |    2 +-
 repair/xfs_repair.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/progress.c b/repair/progress.c
index 07cf4e4f2..74e7a6719 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -394,7 +394,7 @@ timestamp(
 	time_t			now;
 	struct tm		*tmp;
 
-	if (verbose > 1 && mp && mp->m_ddev_targp)
+	if (verbose > 1 && mp && mp->m_ddev_targp && mp->m_ddev_targp->bcache)
 		cache_report(stderr, "libxfs_bcache", mp->m_ddev_targp->bcache);
 
 	now = time(NULL);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index cf7749643..88aa75542 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1018,7 +1018,7 @@ main(int argc, char **argv)
 	xfs_mount_t	*temp_mp;
 	xfs_mount_t	*mp;
 	struct xfs_buf	*sbp;
-	xfs_mount_t	xfs_m;
+	struct xfs_mount xfs_m = { };
 	struct xlog	log = {0};
 	char		*msgbuf;
 	struct xfs_sb	psb;

