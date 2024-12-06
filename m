Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A854212F96
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527770; cv=none; b=B4I3UD81gpG8+jZaDgGl815vDxeH6j+VC02l3p6LpIb+Ce61nUDq+pk7DZiDDhphSVFDq1VYKxItGyF2j7eDle7dHQoQ3oy9hKAt3Vug/WIbxaGLUdf8Yji6ZzUU+XjusJMPc8OsWu7zCbDpf0nCMGHe7U8CjYKw+Uz5u/tDR1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527770; c=relaxed/simple;
	bh=TslFEGNdVTvtwlzIGCkK5cdZAUlEp8d1iOBrwoEvbP4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KRtfo3+QAbeKOlpUZJfRHbMCMF5gs/sQ7NbeBH48TPLWHqxEuZEhSN5LdJXdyd+oHVqSpZsWVvf3pOYET0l9HmzeqT4RCuIMuMjcR+xNhRVuM59Zv9F7KzNr1yA9RPCyys0i6Xt88wzkkSKTR+QfTNztqJiaxCnJIZcZdMWxStQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBb5Ik1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBb5Ik1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA949C4CEDF;
	Fri,  6 Dec 2024 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527769;
	bh=TslFEGNdVTvtwlzIGCkK5cdZAUlEp8d1iOBrwoEvbP4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TBb5Ik1wKyUGGq56HOov+ZpsTjSNOe86xtMR8GS8eoTRvgSQBf+EsPp6UZPiMDJ1X
	 B3PewrVJ8MEapEm7IYM04sFILp58qqxy+7GFtiJV2lWf1JSOojEIe+3M8srHyD1ata
	 1n0BBbquylwLJV1c0KIYAxOj7iWa941W2ih1o1PRN+w+GhYneJGukA5xOwoXcNWuiS
	 04KJwljil3sPxyC8IfSfI6dNNf0cgs7kOlDOKz5PaiRklnxeK5kpVLbMBjnFobn9ZC
	 XhvRoYK3GdotZ5pXRmQUShXX9WWkcYd7Zq+vHWSyGpv6bE4qIj6C64c9S99K1PdYQj
	 xzooZitUMcfBA==
Date: Fri, 06 Dec 2024 15:29:29 -0800
Subject: [PATCHSET v5.8 8/9] xfsprogs: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
In-Reply-To: <20241206232259.GO7837@frogsfrogsfrogs>
References: <20241206232259.GO7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Store the quota files in the metadata directory tree instead of the
superblock.  Since we're introducing a new incompat feature flag, let's
also make the mount process bring up quotas in whatever state they were
when the filesystem was last unmounted, instead of requiring sysadmins
to remember that themselves.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir-quotas
---
Commits in this patchset:
 * libfrog: scrub quota file metapaths
 * xfs_db: support metadir quotas
 * xfs_repair: refactor quota inumber handling
 * xfs_repair: hoist the secondary sb qflags handling
 * xfs_repair: support quota inodes in the metadata directory
 * xfs_repair: try not to trash qflags on metadir filesystems
 * mkfs: add quota flags when setting up filesystem
---
 db/dquot.c               |   59 +++++++++++++----
 libfrog/scrub.c          |   20 ++++++
 libxfs/libxfs_api_defs.h |    6 ++
 man/man8/mkfs.xfs.8.in   |   48 ++++++++++++++
 mkfs/xfs_mkfs.c          |  113 ++++++++++++++++++++++++++++++++
 repair/agheader.c        |  161 +++++++++++++++++++++++++---------------------
 repair/dinode.c          |   18 +++--
 repair/dir2.c            |   12 ++-
 repair/globals.c         |  111 ++++++++++++++++++++++++++++++--
 repair/globals.h         |   15 +++-
 repair/phase2.c          |    3 +
 repair/phase4.c          |  116 +++++++++++++++++----------------
 repair/phase6.c          |  128 +++++++++++++++++++++++++++++++++++--
 repair/quotacheck.c      |  118 ++++++++++++++++++++++++++++++----
 repair/quotacheck.h      |    3 +
 repair/sb.c              |    3 +
 repair/versions.c        |    9 +--
 repair/xfs_repair.c      |   13 +++-
 18 files changed, 753 insertions(+), 203 deletions(-)

