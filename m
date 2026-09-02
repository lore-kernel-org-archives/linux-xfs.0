Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5A9155757;
	Wed,  2 Sep 2026 05:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327832; cv=none; b=jELrAO3fiSRzYRD2MQNIOcPB8svZve031CC2oIDoZbcunMSAqkMOtJaWRlM+WMaxSa6roNXInUeDwrLpPT6bYBGQGX9hE0rSNlsG9dt9Ta9f28pJ5f4BCOLA8nxZrRduURExc3/scEKqpdTLYGfo7EfNtAPLblDZpoqesIcIYFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327832; c=relaxed/simple;
	bh=+n2yX2g4irqb8kJBpLny2nhFi5S188NBHCf6PDYPryE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XBR7x1ecWRinXEaTLtfvFD9wPWiOv2SEf1j93sNUj5gj0zEPifbj3NCcE9MgxSRgxhXH5alg9Vh9WX4Niww2S9XHAjXr9sEARyFIMZIHkCYptv1HJslVhdygyUPlyRirw56OvliSUDc+ztKRSEViKYIH3hiMe1jYGI+njAkSkTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0ntX9KS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0ntX9KS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C2B521F000E9;
	Wed,  2 Sep 2026 05:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327830;
	bh=L7QeijKxhR1jH12vtSZqNUwUgUXn/Kb1WlijwUS824U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=j0ntX9KSX4mbJcxxRQWPKPYZ51EVYQ3MpGKufl5TKDd024MqKDjjdp3QLokIgoVuR
	 x0jnj9QS9iTAJKqm4EwhSRZdCBUpb701SSDxKuSvpNbTITGDmk+yOJCrHKQVjUYhYN
	 pnbWytTWfJpjEirs0Ke/6GjMY1ln/iZk/V6/HOJrg4K2hwcjk3A+DHgWGjFMz0a96m
	 iTmSo/BY5yYeGL6+ter3VlTndgLPFKwX364BB8CHEZqJGFwAvHVyuysB37D+EN47GF
	 tzxie2szvBju4cjWAcfR7i6Wp+TbWDDeLVdiaegNa7SiopSkxAs4l0iRK39tMnzpci
	 c9X5LQD0iqajQ==
Date: Tue, 01 Sep 2026 22:43:50 -0700
Subject: [PATCH 2/6] xfs: preserve owner on in-memory btree creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749465.3507209.1331497746659651125.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
References: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

