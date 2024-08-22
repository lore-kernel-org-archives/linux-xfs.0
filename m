Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A28117E006
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371127; cv=none; b=TGcjX4Mgj4n0JkgBEWfBjcFs8eZA9UNLK6B85nC6dRFWZcqEOgS82zWGf6mUE7Mf+xm1X8vs1POoGwvbpOfp1bB/IcfYbMqjh5UU9Pt0EDPEixmeAeXAPJ1N3seL1m95MOcbHfqyKp/PrglDbYiiuI/IY6quyqBfB+0InGvswBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371127; c=relaxed/simple;
	bh=4MjxV7sLZjrShxl2uTE5mXEZhjILujqsK6BDH3lqUN4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seQe3wMl+SPXfRDUjoFa8xhNE/uuYt5QlmLziOjjExVQCPQDXBGFF8tJYKv6ng+7VHTjSPkT7wiUJy7Vs+po/o7hmy8J6ka2HXcuYwV6S3t4bDc8jpg5RwPNd5D+PAAWcNCZGTB8LCOVmG3dobK7Nb3Y4i8EbPgACnWZiEm/IhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtJ7XpuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtJ7XpuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD02AC32782;
	Thu, 22 Aug 2024 23:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371126;
	bh=4MjxV7sLZjrShxl2uTE5mXEZhjILujqsK6BDH3lqUN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BtJ7XpuPmyRD6yM+J9g8+TAmwePaNQ8ImEKKe9LDbkDo9Nny/Pm4wJXVB8477k9CE
	 KBh5xxz0yUY3Rx55MUATgX0gLDNmvzn/QSJt3sizD1Intb+n8y6ZY7/qGobXSYaD6B
	 NkbmquYI2npMqip4iVpoOhGBu90QeHO3OdrEkvC0TIlz00wjIOH73DARAyI4fIBJB6
	 LsgzcF4kKa5Wj4EUxJBs58gPn1VfUOMpC/W/0aq2fd/PR2d1iQyXKxMcsXUESfijyR
	 zeUbP5U9XsAOKu1zW3F0WOXLELvxFeaElqbzpdXtLDlsti8AMsntSCQJDjGdMeuTrU
	 SyJV05js9w/UQ==
Date: Thu, 22 Aug 2024 16:58:46 -0700
Subject: [PATCHSET v4.0 10/10] xfs: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
In-Reply-To: <20240822235230.GJ6043@frogsfrogsfrogs>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
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

Store the quota files in the metadata directory tree instead of the superblock.
Since we're introducing a new incompat feature flag, let's also make the mount
process bring up quotas in whatever state they were when the filesystem was
last unmounted, instead of requiring sysadmins to remember that themselves.

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
 * xfs: refactor xfs_qm_destroy_quotainos
 * xfs: use metadir for quota inodes
 * xfs: scrub quota file metapaths
 * xfs: persist quota flags with metadir
 * xfs: update sb field checks when metadir is turned on
 * xfs: enable metadata directory feature
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  190 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_format.h     |    3 
 fs/xfs/libxfs/xfs_fs.h         |    6 +
 fs/xfs/libxfs/xfs_quota_defs.h |   43 +++++++
 fs/xfs/libxfs/xfs_sb.c         |    1 
 fs/xfs/scrub/agheader.c        |   36 ++++--
 fs/xfs/scrub/metapath.c        |   76 ++++++++++++
 fs/xfs/xfs_mount.c             |   15 ++
 fs/xfs/xfs_mount.h             |    6 +
 fs/xfs/xfs_qm.c                |  250 +++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_qm_bhv.c            |   18 +++
 fs/xfs/xfs_quota.h             |    2 
 fs/xfs/xfs_super.c             |   22 ++++
 13 files changed, 597 insertions(+), 71 deletions(-)

