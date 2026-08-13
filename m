Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5E6375AC6;
	Thu, 13 Aug 2026 05:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598762; cv=none; b=XHcErI0EpLdagM5l4N3V23oMHySPI696I8HHNqkDMbqj0u7Ewr2WtBenFBpba7MIG+JozlaB6hw1c6YdDLPxd3iD0vyirOyvETUksgxLPN3uFjUnUwGoE7f9exTnZxmlfOokbOWqcqAo5neqEBlxIwvFOWl9JxxBZWAkhuQBIh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598762; c=relaxed/simple;
	bh=/BqJE05Y/wtHE13hd7Qu7GBnSy/4s5yFCBGOsitMDGI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BfsROwoJ5a8rMnpq/Sgu+lCRlPSlls0zqENZFxUeyZOF0bMCylhbIvK9plLTHgzwy1JQixmkOaj1wN4b2K/NyCyqV6sSk0GbFgD1OQQwBsPU7b32Vk7QKiiuyha02a6MHuFRNz5AmDUcVCM4F5DoqMv2rk5xaP/FZB7+5zWL1Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SsaEP7tD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SsaEP7tD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BFDFA1F000E9;
	Thu, 13 Aug 2026 05:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598756;
	bh=6boJwVf/MS+W37aGydxpBeuUFPmnM580JJ3YZ4jOhgU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SsaEP7tDGZC7q4J/PDzP1ZAG03srTfk33+DfTSP7t8Vftq22I48z8dBqj30NSsWIF
	 A+HuHA4e2aeO/LCfjaK2Zl3OPxrKQ8UpUI1z64mmh+Duoj6UKOw/zdBhxP53eKwK9X
	 eLnUjsrSG1rs629fEnES/yLal/2Vqhzv0YpTkjFt5kNbBkH4iCCZD+9fKCKinQ66Dq
	 4yCcQglzAeWUClr8J3d3GKNVLlvXHAdlIdWNmF6UWFb7sU/++OTXINaXe9KDktsdI0
	 11jdyj0dhvrRCcw98SbDYtpVaMx1bRLR6Cb726rAoKWFrJqcxpXJpIOx/ZxEvI7TjC
	 e+o+lwuPQJzaQ==
Date: Wed, 12 Aug 2026 22:25:56 -0700
Subject: [PATCH 2/6] xfs: preserve owner on in-memory btree creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861918.833922.4826979543941017596.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out a minor bug where a higher level function creating an
in-memory btree is required to pass in an owner number, but the creation
function erases that.  In-memory btrees are ephemeral so this really
doesn't matter except for debugging.  But let's fix this papercut.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: a095686a238352 ("xfs: support in-memory btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/libxfs/xfs_btree_mem.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index 37136a70e56d66..1d83a4251ceeb6 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -117,6 +117,7 @@ xfbtree_init(
 	struct xfs_buftarg		*btp,
 	const struct xfs_btree_ops	*ops)
 {
+	unsigned long long		owner = xfbt->owner;
 	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
 	unsigned int			keyptr_len;
 	int				error;
@@ -133,6 +134,7 @@ xfbtree_init(
 
 	memset(xfbt, 0, sizeof(*xfbt));
 	xfbt->target = btp;
+	xfbt->owner = owner;
 
 	/* Set up min/maxrecs for this btree. */
 	keyptr_len = ops->key_len + sizeof(__be64);

