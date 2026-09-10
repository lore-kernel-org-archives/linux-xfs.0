Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067073BB682;
	Thu, 10 Sep 2026 05:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019996; cv=none; b=Z22pJIpn1ggTxQAjuLorzrz/PuXCW8ds5wiKx809Kr2tnKFCiqRcWHUZjIc9DzkVP+JXKXPnjDoclbNmCcZbvkgYvwevh63MD7WecY+yAJSLOIxILanRTGpG45IojWccasEVVBBb7JKT8iDj9bUFOTuYxd3bo5llsPv3facFn9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019996; c=relaxed/simple;
	bh=nKWTHXnmzbrhgAp+mBXhTa/nKG2B6zV5EbyW0WlBl9k=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=WJWiRughIjBgb9lafcU5TuuD5KMxS74NCHub5yU+XmZSR7ouDzEely3HvHt/yuURniQUID5SCxx04S+PQ9WTEXvqCzVWxYhgoSjoE6mYyfPElhum52dP2M1S7riI+RqiO0i4ADwUWO0zAKbifKIU3SyDtwu+2+j/nauXaVmUgaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A64x/9uL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A64x/9uL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7EF381F000FF;
	Thu, 10 Sep 2026 05:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789019994;
	bh=me6XSP3JSc5l9TVggrV80e7rv9AauDTa5TErVrpbhes=;
	h=Date:Subject:From:To:Cc;
	b=A64x/9uLi1nSpwrkc65l41CriIzAHsibrCcSGX1Au/aHZtxgZTfikUGLhP6XXEyzR
	 UfysWRLmkkst4u+I46cP7pSaK5QRY1Cpp74uJwgwN1LqEI5tGXDxPvDCsbDgiSou91
	 itgPJisjZjZHokRRnz0Bv8L/WdgYcZ/EC1dy4uKUWtETgS8vGXSGwcCP6cm8b1EP/z
	 Hp6wJrOa97pxGhGDdKLUj3RIojzGftnXNXt2qdAlijq7tXTQ/p31Ii4Nci/rQch2Go
	 6Aq+KGrsRnSazhAd4Zo6N44MFqzrTtOfMwkOEJRscFbcvBZrT7Ay8u6VyTdAz0DPT9
	 h447kf0mnVKxw==
Date: Wed, 09 Sep 2026 22:59:53 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a thirteenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-13
---
Commits in this patchset:
 * xfs: guard against igrab failure in xrep_findparent_from_dcache
 * xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY scans return corruption
 * xfs: fix attr fork block count checks in xrep_inode_blockcounts
 * xfs: release orphanage dir inode if chown fails
 * xfs: release AGFL after walking it during rmapbt repair
 * xfs: use correct jiffies comparison function in xchk_maybe_relax
---
 fs/xfs/scrub/scrub.h        |    2 +-
 fs/xfs/scrub/findparent.c   |    3 +++
 fs/xfs/scrub/health.c       |    6 +++---
 fs/xfs/scrub/inode_repair.c |    2 +-
 fs/xfs/scrub/orphanage.c    |    6 +++++-
 fs/xfs/scrub/rmap_repair.c  |    1 +
 6 files changed, 14 insertions(+), 6 deletions(-)

