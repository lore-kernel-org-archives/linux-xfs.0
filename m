Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19B041E6A6
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 06:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503210; cv=none; b=i3NG1UnHNS5OJf7HTHbHbgLYriHCx7ZBRankDWmIWEMhTrqBc/sHo6UoxvU/pTcriWVJUME/1g4hNjIbQ0KU983wN5myHtN7GmnNX8YsKKxWIlg9gVRGgJAbZf8kExkDyCRuf/Goo3VY1zP27Y9aIBDalt4ERexAS6YBnWi8rf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503210; c=relaxed/simple;
	bh=GvUJfAN4fyacmvDNHuKAudHpmfjPeDf8KpuIulVNYgk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gzCLlHe/72dNXzw+f+BIsFbiDqDG8fDVB5KntcCQZkInWFN8bfwiiVEWwogR6XeLI22PRyTufpHq0hQhhwVLacnOkO7RWvvZZcilz3MJd1mUCakEJvvHu78MLwDR7oiNz68bB3xWN/gLRipV2qHztXAWYsVk9opXgvHx1XigFZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKB9WmTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKB9WmTZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 326E31F00A3E;
	Fri,  4 Sep 2026 06:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503209;
	bh=8v8/iGRamaQpnPwIZGbEWnplX7B0DnYOtXX/HFrCa1o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=GKB9WmTZ8K4QBhSKgVx13SOvT/pyMzx8Fe29E47nSl8g96Q7BsagREYLMcCyyrHnu
	 z07YSSCdJbz6eozsmSSioBFXMIHAj2btvttFqEI2uBUrMLETwsIL9uRo11tooPGTl3
	 UBpeE16ccssEF3AwRkk5/NtJK+ZaSNYd/8elQijJwuMmt03dHuHEFMZx31TlXveKPE
	 8R0wx8HijU0TU3ezoUlMMSQ4DeFL/xBSncq6i1Y26uB8N5fFupQ/+S9UVk2M87Fqsz
	 MRxCs7tbgKYfSQ7iOb7m13ghM4nbMrYObFGx63SyObU0xP66A7c7YFPkaea30FjCIG
	 v146x9x6uIo9w==
Date: Thu, 03 Sep 2026 23:26:48 -0700
Subject: [PATCH 4/6] xfs: remove redundant function declaration
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178850312582.1198660.18019501735306969631.stgit@frogsfrogsfrogs>
In-Reply-To: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove this useless code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/dabtree.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index de291e3b77dd8e..d654c125feb4d8 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -37,8 +37,6 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
-void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
-
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		xchk_da_btree_rec_fn scrub_fn, void *private);

