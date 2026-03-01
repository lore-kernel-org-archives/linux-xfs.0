Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A41813B7AE;
	Sun,  1 Mar 2026 01:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328215; cv=none; b=LYX+9xOUlfMLYTL6DFSf89KyvF0NkqpumBK2ltnDESqcLyEeEaBJZ88nRZOjVPD6rmnCwUJ2wmKtI96ikgD9unBLFgKsjxKuXqA6X2652T8iPSslUJFC+aztdOqlcSPUmxmf5b9EgZMbXp4kgtvad9+1NYVI3WaD3wgY/4oKTUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328215; c=relaxed/simple;
	bh=jBuTwyyIBoAEnO1C0Wb38UpieyYQEPDKry2Svk5ihZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mYEByyeGwthHRMV3K+i8OCvu8+gT3cAr422DZwUL/f50MxyE6hAfsz/XDMMIPk2a0It27Y95yxIG4dk1W3qRMWGK0PNQ171nj/NiUXuY60uEw4WadRCMZRXXzISXM8JQgn6sfGLNL5ONItjWTdm9q0aFsPjOfSXD9WaguFHdkwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4v96Lnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4v96Lnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BFBC19421;
	Sun,  1 Mar 2026 01:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328215;
	bh=jBuTwyyIBoAEnO1C0Wb38UpieyYQEPDKry2Svk5ihZ4=;
	h=From:To:Cc:Subject:Date:From;
	b=G4v96LnbqnEsBW6tfG2Ic2thmOD2+J0lawhlFbhHdfWk21ThAXI6k5BS6no3+Sx1e
	 SscznM+GlOUPw4vUcXPiXpFmWjkOxE6maobJ9zcIMsnDorPs9keWPnHZMhJ2lgMJ8D
	 dESPjWPJxpPtqo43i7C8e1TaFebbu7CdeDjcUFCza42vFUePsANiYgFexkeJcW5HxJ
	 HhLtaIYr9XkpMG4fF0ybB06rdOrZAnqYydA+bnk6EKvu7hEAImFCoHLQT9/K2rzUVH
	 QEI0Eh2xyPdRwH8uzznNb5i9QD1WUogS1ssW2VWtX1MsMrfGLYJQhvHUg7ijT1rs5L
	 OIeThPuvntS/g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: fix remote xattr valuelblk check" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:23:33 -0500
Message-ID: <20260301012333.1680300-1-sashal@kernel.org>
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

From bd3138e8912c9db182eac5fed1337645a98b7a4f Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:33 -0800
Subject: [PATCH] xfs: fix remote xattr valuelblk check

In debugging other problems with generic/753, it turns out that it's
possible for the system go to down in the middle of a remote xattr set
operation such that the leaf block entry is marked incomplete and
valueblk is set to zero.  Make this no longer a failure.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index a397c50b77943..c3c122ea2d322 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -338,7 +338,10 @@ xchk_xattr_entry(
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
-		if (rentry->namelen == 0 || rentry->valueblk == 0)
+		if (rentry->namelen == 0)
+			xchk_da_set_corrupt(ds, level);
+		if (rentry->valueblk == 0 &&
+		    !(ent->flags & XFS_ATTR_INCOMPLETE))
 			xchk_da_set_corrupt(ds, level);
 	}
 	if (name_end > buf_end)
-- 
2.51.0




