Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0D6399352
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589852; cv=none; b=FRTKNCo7ZBzI/o8jWTi02AnCE3CGxAYK2uZgaCLlsTDRpqJTb9QMcjNM7X56v0Jn5KGF5gz2dz165b++/qi+Ajufkb6RjaYnBvl/ghdl3qA0yuSmtW8yWao147NjIXc5L+V6pv0oqYO6wo0TnLMURl29wEgheEyjSNRAgBuQU+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589852; c=relaxed/simple;
	bh=oJn9SplNb2q9A9sOCIjI5lTZ0dt4VOZB3E7HF4+BViI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T4e+ZQqssqIM1aisA8UeHFlce1cvr2d99dQco7OBLyn2e/W7AEFXuVFrG2mRqqoZeoBZZ/cuYdmR0ofHVHkW7HshgK6CrxBZmF5Okgx9hXM97khMU+adsyyylkk/9HLrxdxIblrE7wpW3AHmFqgk/LVURHLJ9K3dzgnUNUE66E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFlpIp03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFlpIp03"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D73311F00898;
	Fri,  9 Oct 2026 23:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589850;
	bh=3/TTBg580Kg+svvi4PZW7JOok1683eChtiItlIpUrsk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jFlpIp03WarlPK+BwNmIWBfR7qo+3X6xA7A0lycJ0lyXOwcK1OIuBgm+mopZMnOou
	 SLTPZdI2zUrE1up2FBNjds/C0Tb2HLHYakEqlJK9OQOu0ulaxsrIpf32rRvQWAr8EI
	 Gon0VpR69Z/n1zH3OsSZUSgl48A0Dsn2g1J4TNXFUKYFReeOv/gdgHtJ2r0zyFpO1T
	 vy3bEsfV1a8YYH3pt9Z1/vuDW1ipA6Nqz55IxLTGdRCgw2qp0ZxJNeN3PeKgCifM7z
	 t7xnv6Nvp8wOK+1sxtdXgeJD8QfG67CQl9QYzxvYhGVvnMG0SVieNqs+rI6C+uS1xQ
	 /IOrhxj47fwww==
Date: Fri, 09 Oct 2026 16:50:50 -0700
Subject: [PATCH 20/26] xfs: preserve owner on in-memory btree creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947734.3719791.6717761844075377448.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 5287e56cba3be4a64bff9f73bce5964fda2590dc

LOLLM points out a minor bug where a higher level function creating an
in-memory btree is required to pass in an owner number, but the creation
function erases that.  In-memory btrees are ephemeral so this really
doesn't matter except for debugging.  But let's fix this papercut.

Fixes: a095686a238352 ("xfs: support in-memory btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree_mem.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index c2fa836a2ae2b0..4d59dda0a1b038 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -116,6 +116,7 @@ xfbtree_init(
 	struct xfs_buftarg		*btp,
 	const struct xfs_btree_ops	*ops)
 {
+	unsigned long long		owner = xfbt->owner;
 	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
 	unsigned int			keyptr_len;
 	int				error;
@@ -132,6 +133,7 @@ xfbtree_init(
 
 	memset(xfbt, 0, sizeof(*xfbt));
 	xfbt->target = btp;
+	xfbt->owner = owner;
 
 	/* Set up min/maxrecs for this btree. */
 	keyptr_len = ops->key_len + sizeof(__be64);

