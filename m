Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A431F2D0C63;
	Sun,  1 Mar 2026 01:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329920; cv=none; b=enhUOfXQG9fO/BAKbRUPQrVl8YRJO3/dOGuklo72TLfAx8FsDyGV3HqRC0c4AE0OviV8ZnERn5jqau/af9hAHCtMFV7nve/qaXrMhDGvxRQoEU8VmeqfAwhiWQEGZ23g/uhItgo0KcSXENwrz/H27cPDGw0XhIg8FDKRSrPvgaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329920; c=relaxed/simple;
	bh=Obvp3N105qtvD+0LiXG2EqtQecuK3Dvjk48WhtzHaNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sqJ+BL/vy/Cl+mbicSusBVkDAnZFMa5tbrnjpKYRfA6oR3MgYK8j4uHwIn4mCglBOqTaBrSgHyPH7zrqRTFs8NhKDZN1ALExMvTmXysuV6iDofd8kbpxiVJUd9tz4qaELX2ElHZCPAdHbT9lGPbeXWOeGPyfzo0V03aOPCpbyec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Em5r34kQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Em5r34kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8410C19421;
	Sun,  1 Mar 2026 01:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329920;
	bh=Obvp3N105qtvD+0LiXG2EqtQecuK3Dvjk48WhtzHaNg=;
	h=From:To:Cc:Subject:Date:From;
	b=Em5r34kQ9NWUSR4j/FGpJsd2Nwx4vAg6MuRfE/Pj4xxSEZSn+18AOUxtqMAQkrwo8
	 TkQUGzL4Ev9K6aThlYDfSBUhcrhoFxJPNwCaKSkuRpgLwPwwkEC+Myg6BrOWT0sPM5
	 Tihtl2ko4w9N4ZW8n6mRz0FED8rwnGK955VXllaVsfDxcC+cJXmWQkMdWOFCy6KGpl
	 PNk8R0ledairzdpYlsPGUpUbddMZ4fe94Z4/yY6G7/2kFOMJGFKP+/76E/Orwjv8DC
	 X522CLP/Y187KffflXNZrDqQM8qgNUQGfWlZuEWLBvk6e7HsCR55J4hCQb57inxOAQ
	 hp1D3ZeMgETNA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: fix remote xattr valuelblk check" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:51:58 -0500
Message-ID: <20260301015158.1718383-1-sashal@kernel.org>
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

The patch below does not apply to the 5.15-stable tree.
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




