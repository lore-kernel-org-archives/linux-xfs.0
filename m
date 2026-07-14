Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37881372696;
	Tue, 14 Jul 2026 06:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009221; cv=none; b=gCHjb9xDOrP4DnVkCNd0FxHgnaHWbW8hT0zhBZzrbIVgj3snInnmuF9MPYcAfu7LpXbygy3RgIextD75XxdVaICs1r4LTjnfpi4fDyjcmeIbnl0tqHAWmIXJnUt0HY78YPwF4HQZwyMVJ33ewLxMnoe7albW6LRBH4SkipbHWzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009221; c=relaxed/simple;
	bh=MNJEK6iAMKhjjLLz9IjsdEsRkaCmVYzN6i81t0mMUPM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=neP1Jx15dvCP5Fc7S5Eu6PtGIA2b3sbcoHTV6OoK4VU+6U6w+1/z3MHHA2BzeG6K9yHPAEUuNYJekZKLI6uZABqH1TJR0IX3ettonAyxFl5CyvXqLbLEuzoHgkc0g2o1Ct3C/VdunhuYijurNPxG6Ly7zJthDB1f3XEa5QB8IlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIl9oRw7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIl9oRw7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C76AC1F000E9;
	Tue, 14 Jul 2026 06:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009219;
	bh=aDP/FCrHwZZb4b3kM2TGu/nXPwWx6EwS7LkKkIOJqmo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XIl9oRw7CCZBQrH0bJ3ukTaUO8FWyzPNR2AfMw/0vMXkDxKUkBVVdxcwlL83XkNvY
	 bIAWWQ1i0rotysArq5r2bx0PgU671J9wc1MhSGASJWcq9cM3cbc71QD1zEGe05JP/x
	 7yAV1+fkpe4NmPL9lOo/RLs4UJ+kB61ud2Z3hGvX975V3myW6LHUQ5c1uFGr1ODrDN
	 qoplv9Fm1QohbILLqjSXlELRsRRu1Yfl1YSV720IpBkAfalq4upLDH6u9rdgAW2//J
	 sh0gWCBdpdvyZvJKTRRLjuCXv6EF+QHJ4uEaOblyGBXovXe0jzU+SBGAs/WiqGIQ+v
	 Itrt5tr0DSfhQ==
Date: Mon, 13 Jul 2026 23:06:59 -0700
Subject: [PATCH 4/6] xfs: fully check the parent handle when it points to the
 rootdir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716902.268162.497307588168425150.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the directory tree path checking declares the path to
be ok if the inumber in the parent pointer reaches the root directory.
Unfortunately, it neglects to check that the generation is correct.  Fix
that by moving the generation check up.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index c6a210f7508fc2..b2cf6e5439d915 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -383,6 +383,14 @@ xchk_dirpath_step_up(
 		goto out_scanlock;
 	}
 
+	/* The handle encoded in the parent pointer must match. */
+	if (VFS_I(dp)->i_generation != be32_to_cpu(dl->pptr_rec.p_gen)) {
+		trace_xchk_dirpath_badgen(dl->sc, dp, path->path_nr,
+				path->nr_steps, &dl->xname, &dl->pptr_rec);
+		error = -EFSCORRUPTED;
+		goto out_scanlock;
+	}
+
 	/* We've reached the root directory; the path is ok. */
 	if (parent_ino == dl->root_ino) {
 		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_OK);
@@ -411,14 +419,6 @@ xchk_dirpath_step_up(
 		goto out_scanlock;
 	}
 
-	/* The handle encoded in the parent pointer must match. */
-	if (VFS_I(dp)->i_generation != be32_to_cpu(dl->pptr_rec.p_gen)) {
-		trace_xchk_dirpath_badgen(dl->sc, dp, path->path_nr,
-				path->nr_steps, &dl->xname, &dl->pptr_rec);
-		error = -EFSCORRUPTED;
-		goto out_scanlock;
-	}
-
 	/* Parent pointer must point up to a directory. */
 	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
 		trace_xchk_dirpath_nondir_parent(dl->sc, dp, path->path_nr,

