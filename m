Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3143FBE40
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302973; cv=none; b=Bb0EAl7gN61b0A6u1AOgqP7QstYjP9PVkFxPgvPQLCDN4n8IaYnxpZQcpC+aocRPYQp96rVI9NlYT3Hx/WxYNYPYsRIhRo+XXSXU30QQDz2+Trav7xGzvwNU+lG14dQmbOBSqLiY1/7fkSJJ7iOh8mJbx30erMy6/uqcKrZL0Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302973; c=relaxed/simple;
	bh=0R3haMfbtxnBf29mzJrhOkXDzw5+C05pSLH4Zdav8eo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2l8ggnf6gRWEMfJxhmtLJnW4Db+L4Xjd+uTOG2p+OXXLviUWXFSCFC7LPfDEoW53S9IZ8oD35vH93Fb00glf0PnMpkk5oIjMSLTYcC6Wra131Pjomw4P/lGFdD1eO55vf3XWJ/2uaxeYAwATXy8YEgyihePFob9B+PSOGKTMJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K70NN5L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K70NN5L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9AAC4AF07;
	Tue, 30 Jul 2024 01:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302973;
	bh=0R3haMfbtxnBf29mzJrhOkXDzw5+C05pSLH4Zdav8eo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K70NN5L/g6GFO+ZtvWV0KmzaGXZpG9Ms85u3jDZ5NdWkoBSauD0ILzk+0E69uF7R2
	 VCxi8FiM0u4ZotU5lECxxw5i8qx62FjilGCntjZkImcO4VpexpAxv2pZqzilmWR4IZ
	 blAtI1096Nuu/BguzJ2VDdoF2LaN7mP/N0rgD6HM/wihAqvnm82uCqP6EOHl1d6eQG
	 u3gdzURamdSlG+kysllLXx/kXMbamWIlTujD/xlotGUZU3XwZ7aEycIEea0GiPTEX7
	 M+7U+QQZt37wZKjzgEcg3bePFlM2x4lzeNflqViNjbif5XbTUW3ZeCLwS8S/lLJJjm
	 tJSQ7V1ZP0olw==
Date: Mon, 29 Jul 2024 18:29:32 -0700
Subject: [PATCH 3/5] xfs_scrub: fix erroring out of check_inode_names
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852007.1353015.15131762846492694866.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
References: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
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

The early exit logic in this function is a bit suboptimal -- we don't
need to close the @fd if we haven't even opened it, and since all errors
are fatal, we don't need to bump the progress counter.  The logic in
this function is about to get more involved due to the addition of the
directory tree structure checker, so clean up these warts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase5.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 0df8c46e9..b37196277 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -279,7 +279,7 @@ check_inode_names(
 	if (bstat->bs_xflags & FS_XFLAG_HASATTR) {
 		error = check_xattr_names(ctx, &dsc, handle, bstat);
 		if (error)
-			goto out;
+			goto err;
 	}
 
 	/*
@@ -295,16 +295,16 @@ check_inode_names(
 			if (error == ESTALE)
 				return ESTALE;
 			str_errno(ctx, descr_render(&dsc));
-			goto out;
+			goto err;
 		}
 
 		error = check_dirent_names(ctx, &dsc, &fd, bstat);
 		if (error)
-			goto out;
+			goto err_fd;
 	}
 
-out:
 	progress_add(1);
+err_fd:
 	if (fd >= 0) {
 		err2 = close(fd);
 		if (err2)
@@ -312,7 +312,7 @@ check_inode_names(
 		if (!error && err2)
 			error = err2;
 	}
-
+err:
 	if (error)
 		*aborted = true;
 	if (!error && *aborted)

