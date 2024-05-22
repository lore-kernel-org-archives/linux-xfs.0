Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B314C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347332; cv=none; b=qV8WOELMWWp351yDbaEkKZRU+e3+3qrFGP+ItRmH98JGITkNjornl2mqy7HSx3iTqf6AA1T7B7NzpztIiDqKYLs8nZK10NKyNLWDTp2IndL0djAYXnQh2bWLo5QH1cmY0NgJHQEatbbFzfU4TcKnqRsdc4xoyrQXx+5mZdGIp6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347332; c=relaxed/simple;
	bh=MaDx0JLUbFnoIk4EpXAuF6RorDIeqW9tM7S29Dm5LZs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrnX1La/I0CcuiInoF7h/UXHViwZnTs717XZEMoB24wahl+DzpBLaNJxl8x+4h7gE6nclQ0Sl1ztNlOahJd+er9HiBS2+8S2/4LyqiE+L1Uu9faqyBSP3F9dXbhwdPcZ+LxDXIILAgfbkbUdu72mxJw+dYy+eIpfPVv4+nH2MXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i47/853z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i47/853z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17D5C32786;
	Wed, 22 May 2024 03:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347331;
	bh=MaDx0JLUbFnoIk4EpXAuF6RorDIeqW9tM7S29Dm5LZs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i47/853zFfdzgnVHDjC09HzaTBwU5lJFI71yMkZnFmRqmVLq9bKzmx8NgW6IY/dYK
	 xpjhzYad1Sk4jljLjvCenYZS+TDCD/DHpj3wb4w3YCsWNmcs3TZH4Z/wk8dBXKBxCQ
	 Il+fjo/T0gEZ4D5TLmahvkqPJ9cC/ybqtFDA1dNlPJjf3GhW3i+NJT8ON3IVTZs2IT
	 fCA1Pt5sIvn178AO6MF81KuGewaz0Er85URHlKnrB8BcBY0W8j7LRJWqI8/cA9CHGt
	 kDelFO1wNTUwoMRM0NVBKf6AXjqD0ZbiD09swP1SsI1Y+0pC9oUWQ9rtTeKOYuShRO
	 T1jphs0Bzj52w==
Date: Tue, 21 May 2024 20:08:51 -0700
Subject: [PATCH 077/111] xfs: open code xfs_btree_check_lptr in
 xfs_bmap_btree_to_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532853.2478931.8680392296631395483.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: fb0793f206701a68f8588a09bf32f7cf44878ea3

xfs_bmap_btree_to_extents always passes a level of 1 to
xfs_btree_check_lptr, thus making the level check redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 2d332989b..86643f4c3 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -562,7 +562,7 @@ xfs_bmap_btree_to_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
-	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
+	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_verify_fsbno(mp, cbno))) {
 		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}

