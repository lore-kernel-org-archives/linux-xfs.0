Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0C22727EB;
	Sun,  1 Mar 2026 01:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328208; cv=none; b=Rkhhzkr2XNgmxhBdt9OuLo+I2c4hXBqshnpVGPdisAifP1Row5pwu8vjuYO0EnyLQQBgmh5KVZCAD0DrV+ZnMy+UAmRuBzWh7x6ORBfhea/7Sj3eQbDxK7mFCzjSStRxejr3ZYVRjFunQDzvuIiqzs+VCZk7PpQiJYwoY9jzC28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328208; c=relaxed/simple;
	bh=h8YsQ6PfIkYmpRG1oPkA846rc3k2v2gUCfWlTVSEv/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ey/VcrnsysCU9VK9aSehOsNJcrrFSb472E8krYtygndInt6cGc27fzap+vdVfZvy0/sXfbdHzM6krVYHGRolPHOfo1++Z2n33jNl2VoGMBN8QNc5N08W+l6OXBl/mV40cl8eEPgGX2D17ZGElqdGPRike5ARK54KcGB14MqkmZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWSprLr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWSprLr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2FBC19421;
	Sun,  1 Mar 2026 01:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328208;
	bh=h8YsQ6PfIkYmpRG1oPkA846rc3k2v2gUCfWlTVSEv/U=;
	h=From:To:Cc:Subject:Date:From;
	b=NWSprLr7aQYVx3er5aNcjnXm0F2tJxxpg3c6bis6nDKKJ76D9sSrA8Xr56XzVLdk+
	 kFTXKJ8GBx/JpkcsjqFqatWkUrg1ds3jq8dVaQyFG+P8qIlLFEnF74EHj3qwQwTuRu
	 PEYYcIrBRQ5ZmpnPGGzPHWsHt57hus7SiU3izal++1L3zvkDOB2t9ArR9qSKcVMLCA
	 JiRZ2rEjknW/GyWiip25KyTetT7SWk8MuOCHmnKLbK8RXQivBI9mmx0ymdDOy84TL4
	 T7QZ3hK08yXhtwCc4I0XUzkoqrE4M2voIDIjBSYBkjYxKF7jTV40SoKQJ8p1dR7IzM
	 Ei2/iJwEl7FMQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: r772577952@gmail.com,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: check return value of xchk_scrub_create_subord" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:23:26 -0500
Message-ID: <20260301012326.1680145-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From ca27313fb3f23e4ac18532ede4ec1c7cc5814c4a Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:38 -0800
Subject: [PATCH] xfs: check return value of xchk_scrub_create_subord

Fix this function to return NULL instead of a mangled ENOMEM, then fix
the callers to actually check for a null pointer and return ENOMEM.
Most of the corrections here are for code merged between 6.2 and 6.10.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: 1a5f6e08d4e379 ("xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jiaming Zhang <r772577952@gmail.com>
---
 fs/xfs/scrub/common.c | 3 +++
 fs/xfs/scrub/repair.c | 3 +++
 fs/xfs/scrub/scrub.c  | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index affed35a8c96f..20e63069088b3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1399,6 +1399,9 @@ xchk_metadata_inode_subtype(
 	int			error;
 
 	sub = xchk_scrub_create_subord(sc, scrub_type);
+	if (!sub)
+		return -ENOMEM;
+
 	error = sub->sc.ops->scrub(&sub->sc);
 	xchk_scrub_free_subord(sub);
 	return error;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3ebe27524ce39..ac8c592579bd5 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1136,6 +1136,9 @@ xrep_metadata_inode_subtype(
 	 * setup/teardown routines.
 	 */
 	sub = xchk_scrub_create_subord(sc, scrub_type);
+	if (!sub)
+		return -ENOMEM;
+
 	error = sub->sc.ops->scrub(&sub->sc);
 	if (error)
 		goto out;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 670ac2baae0c7..c1c6415f50550 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -634,7 +634,7 @@ xchk_scrub_create_subord(
 
 	sub = kzalloc(sizeof(*sub), XCHK_GFP_FLAGS);
 	if (!sub)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	sub->old_smtype = sc->sm->sm_type;
 	sub->old_smflags = sc->sm->sm_flags;
-- 
2.51.0




