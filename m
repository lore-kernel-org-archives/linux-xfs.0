Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC661155C87;
	Wed, 18 Dec 2024 19:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734551416; cv=none; b=ra9s8x34SKh3OrqUceq3HF1JnlC1Z6UyxnZZ2cBjl17aFkCq4Hz0+dcwS71onjk6tY1u6m3EM+aeXBEmXfYjH2/CYE4QXqHbz/k4EANC0rG/x3Y8oQ1X+UvUGhVfQNbtNkdUOoRsjFXMkys2qE8xrEzLtaYFg3qkCQoMJgcerC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734551416; c=relaxed/simple;
	bh=sXb67nN4BuInFX9nPDrFHc6ZGj8mLPK0Gdmi6j8h9k0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=irklqPExHH8Bt54kFdnki2SRImceDYQALtTUcQrMJrh25PkxQ1fm3nVPm8om7T3F8rBYEN4E/Kx38D3hX9mUsfngy47g6dwXxPK45DqRDzBn2RQWfBylbtpPrMd+ox7TulQL/gCx4mT/2G/G9WqyTePP8PGoO1kuYPjl9woE1XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORa5p2Ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORa5p2Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AEFC4CECD;
	Wed, 18 Dec 2024 19:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734551415;
	bh=sXb67nN4BuInFX9nPDrFHc6ZGj8mLPK0Gdmi6j8h9k0=;
	h=Date:Subject:From:To:Cc:From;
	b=ORa5p2GeWccz4lgjzdEMR2x+JYrchmAaejEEzw0NgaN96T9l+rl0vaij5ppbQEcJI
	 jYgLyvmrmxSG6Goqq/5eEdnSapJBfYxqCuQC0eEtvII3S8sS8AT/n7j9t0sTeOJeRA
	 vlTAc8Y0WcfR/juCK9LmOymUI8oAlEeXfMp3w6I5HMs1wD0eGjhmuJYeAc1+3HhJJe
	 iFCL77bk4E2yVGhLxOVmk8w4MprF8FJs6V/M0knEApvIrM2aBduOKwHl7I64BVY6j9
	 QFjQPtSVLhzt/GOnFlz1LdKYPk4H9KfD58XjyFt1gAi7peH354OIYb9FNBDy7uIaj5
	 cYJz8ZDklr0sw==
Date: Wed, 18 Dec 2024 11:50:14 -0800
Subject: [PATCHSET 6.12] xfs: bug fixes for 6.12.y LTS
From: "Darrick J. Wong" <djwong@kernel.org>
To: stable@vger.kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, hch@lst.de, cem@kernel.org, wozizhi@huawei.com,
 linux-xfs@vger.kernel.org
Message-ID: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a bunch of bespoke hand-ported bug fixes for 6.12 LTS.  These
fixes are the ones that weren't automatically picked up by Greg, either
because they didn't apply or because they weren't cc'd to stable.  If
there are any problems please let me know; this is the first time I've
ever sent patches to stable.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D
---
Commits in this patchset:
 * xfs: sb_spino_align is not verified
 * xfs: fix sparse inode limits on runt AG
 * xfs: fix off-by-one error in fsmap's end_daddr usage
 * xfs: fix sb_spino_align checks for large fsblock sizes
 * xfs: fix zero byte checking in the superblock scrubber
---
 fs/xfs/libxfs/xfs_ialloc.c |   16 +++++++++-------
 fs/xfs/libxfs/xfs_sb.c     |   15 +++++++++++++++
 fs/xfs/scrub/agheader.c    |   29 +++++++++++++++++++++++++++--
 fs/xfs/xfs_fsmap.c         |   29 ++++++++++++++++++-----------
 4 files changed, 69 insertions(+), 20 deletions(-)

