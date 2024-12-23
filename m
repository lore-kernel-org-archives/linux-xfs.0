Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE161BEF82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989765; cv=none; b=YOyK/Hg3/+1He/E267xVS+ay9OGe+TFMUiAu62V3a0gP6tRzPSr+X2juoeR/1U6b/L4EdZDxx0ovTHPp3JScdDq3KM2nddE/rNEa28xHLktowe9SxUPq4IB4g09L1iYhs1cVVVarhTOdde+8knF49T88dpzgDU2yzWENCHDHQYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989765; c=relaxed/simple;
	bh=TslFEGNdVTvtwlzIGCkK5cdZAUlEp8d1iOBrwoEvbP4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgCir1JpuNheBTeK/EUbNcX+94p39zfHtjiX5KLdTboPqnJxhBZGiUB7X9RI7+aeXpDxKq0Y2tR12goFuc3Ouws0DapPH5LpmWR/N+VcR45Iu+nWLgUEoMXzm9qOFRaaOW1GDT3h5HYQuqNjflibkRFF+2n+e0zegD2v651Dwhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDsmquym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDsmquym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62651C4CED3;
	Mon, 23 Dec 2024 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989765;
	bh=TslFEGNdVTvtwlzIGCkK5cdZAUlEp8d1iOBrwoEvbP4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EDsmquymPUVqrMPvumhJQOWLim9Crkbb45PY5StJ3ZLAwLmO8jO+4FENld4wNm2mn
	 nAj5Bwn5fg5xw9c1ePMiQVJ3lOqPb/JWaQk/gX3pHjaQ0aURT7ioVK3bBBTmzAgUZL
	 gkQl2mRDntHh+yUypBt+W0x4DvlVKvO+EmsrlbR5LwTEPnN2qUifH7cAJ5iiw7VctG
	 5OyseZUWtfSqucczvWcp7Qw6N7CxscOKmJnne66TzMBTEWVq8ZQQu+QeDXsy2jg5Nj
	 MTql9Wvn7MfW8Lq7fXJ6vaxQ9I/DFl+uYyYBYoPbZSUVpUjzPaSax7/0LYh0PrnHkY
	 irQCchCauWCpw==
Date: Mon, 23 Dec 2024 13:36:04 -0800
Subject: [PATCHSET v6.2 7/8] xfsprogs: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
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

