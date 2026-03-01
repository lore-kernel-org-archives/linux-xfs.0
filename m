Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373CF259C80;
	Sun,  1 Mar 2026 02:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330518; cv=none; b=r9VBRoe3MXvrlOqPoz/4UYZXunz1X2lsuBkOhV7Ctdcla3Q57jOygYnguCajhbxXShkipDuArFqcavtXLFeYY1Ngj/x8NKr3Uen9R6KBHVVqJvlEVIg4n7Fzt8vXdaJA2omTKcH2VDaYzMCiuniNi/syzssZLqW+Vwd+tU/cpwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330518; c=relaxed/simple;
	bh=ynoUbYWukNxHyVsKqqBNM/xxFtUtBJ3C/zzqDVoKqg4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jh+6I2ULnRq6yajFV2XuwAaywub4zdE1EgCIPepUktiu2mn4JFB08VdSsSA8LC8jktMmTJMK1H7ExC2sXoMBTs1td/y7sg6qFD+aR6PgCX1Ok8/1zuL2BQFSIRBLhphfUB+jta7ZmeCQnL8kxGe5VeuGSWORRFWzuYswoGVB6Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqeCBkNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqeCBkNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954B7C19421;
	Sun,  1 Mar 2026 02:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330518;
	bh=ynoUbYWukNxHyVsKqqBNM/xxFtUtBJ3C/zzqDVoKqg4=;
	h=From:To:Cc:Subject:Date:From;
	b=LqeCBkNGhHIojUMXdBrY76zVyOQmkGemVcfMXaKIFbucvNYwmmPitHtOgixfBs3XT
	 xcVJXP/d9/Tb4yBHqqJ+VeMs7LEFntwp+Q/W/wL1Ypn3oGjC6VZxJHGkzIwTJRbZTt
	 iIaQRRMqxaeyBWE/Es63At5sMkxJOZTPAR/u2iTnqwsi9HaYB60Q6fW0LNlsJMPZj/
	 309SqBil8dk5nOekBeSfOMmSi9EsK1WAM2gDoAXk2abW2BV+fAJ4UlyGTIerh5pPna
	 +3wQVkzJWjxc62hlj6LmCm41rVZTIZhdzH2avJhuYv3E8fRNCNLO6EuGJFrgri5U7O
	 JfMfOu7bhsW9A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: fix remote xattr valuelblk check" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:01:56 -0500
Message-ID: <20260301020156.1729305-1-sashal@kernel.org>
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

The patch below does not apply to the 5.10-stable tree.
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




