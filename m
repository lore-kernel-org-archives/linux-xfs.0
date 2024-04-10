Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA5737C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709895; cv=none; b=JeggqjoVS6ZDQCRiDbr2rMncbbcqLAUPnht0vQhdvanhIZhGcN8DZPZQOAfGcUeKFPCxtkxegsNlD6Umgj8vBchkQ0csc9YiKf4YKnuFAemooyURhDjDdWMt6K6uvBfHpp5kQJqdkfg4y4bWxkq4DZrPZRqKiK1gRWqh5LVoRQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709895; c=relaxed/simple;
	bh=lqTmnnr/qNW4xWt6SU/ZNSlKmEhWv86Mv2bf0JMoK28=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGKjc9bL867pf8x3d9Z4qE+NfEQbt4QQ4rKW6iF9pEmEtO5otV3oGJcHgRqouhKz364SfiwQ5VRRTp7fGNaWJMpYau3sJittAuy/mV3xPPYjq2xfb4vOm6tBgZz/QbTCXRfdYCT1iQeVoC3af3V2jPekCldysKIpxSi3Cbi5AdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InjGPiuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InjGPiuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9DCC433F1;
	Wed, 10 Apr 2024 00:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709894;
	bh=lqTmnnr/qNW4xWt6SU/ZNSlKmEhWv86Mv2bf0JMoK28=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=InjGPiukbN0HygCNnE8GEUx1DnLsvEk+MswN72LeMVR4XQNZMWgSZaOhLhyBq0gTZ
	 B+FYoIvV+fBlmMLOOyerW2M+O5HhiAf5PGNmUhDPtfwcNoRWaPUfJ2rHczBiLEiwYG
	 GAlyfF8sH7TNhhU/ZhbqFUblSL6zF/tQUeG462bQ+zGwQXCUQwEUQgP5ck1Ma5jjp4
	 brZf8/fRDS1uRVTkQTQUa20jnz7ZkjgCbpjMSXH3qZqNWODjJnG6a4bCGWTq9GuEFz
	 7/70X0pseW1aM459tO035FmVtQap3e7yYoQeEtk/7l9WG7zTRei7cUMdnEy6SQn7Qv
	 C1iCYUA7ZRs1A==
Date: Tue, 09 Apr 2024 17:44:54 -0700
Subject: [PATCHSET v13.1 3/9] xfs: shrink struct xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
In-Reply-To: <20240410003646.GS6390@frogsfrogsfrogs>
References: <20240410003646.GS6390@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Let's clean out some unused flags and fields from struct xfs_da_args.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=shrink-dirattr-args

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=shrink-dirattr-args
---
Commits in this patchset:
 * xfs: remove XFS_DA_OP_REMOVE
 * xfs: remove XFS_DA_OP_NOTIME
 * xfs: rename xfs_da_args.attr_flags
 * xfs: rearrange xfs_da_args a bit to use less space
---
 fs/xfs/libxfs/xfs_attr.c     |    9 ++++-----
 fs/xfs/libxfs/xfs_attr.h     |    1 -
 fs/xfs/libxfs/xfs_da_btree.h |   30 ++++++++++++++----------------
 fs/xfs/scrub/attr.c          |    1 -
 fs/xfs/scrub/attr_repair.c   |    2 +-
 fs/xfs/xfs_ioctl.c           |    6 +++---
 fs/xfs/xfs_trace.h           |    6 +++---
 fs/xfs/xfs_xattr.c           |    2 +-
 8 files changed, 26 insertions(+), 31 deletions(-)

