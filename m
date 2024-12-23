Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BA186E20
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994381; cv=none; b=dnV3d9Dx3/+aBps+c1XdxD9GxRj+BoEuzUsQpQ728fFzxM1X7Y82E3TixVAw5a68JgFofeKXtkhn8ypSQTHYxL7cjkVLefhPaw6uJcD0IcaEfdkOVY9J+4n9VZ7oRdvdpidjI5HR6gyhCUnS53bPt6A8J66IChUkea3lWW1D8uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994381; c=relaxed/simple;
	bh=Z9c/euzo2J2tCiy1P1Ku79dD8zSrcFc/Rm4cHAQE+24=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SGg966D934zMYopBIWhtPQaIZDyI7EjzL+FNgBiIInJIUCOYtqvk9f6ik9g9fM7HM2naqpvM+buRoC73DbmFtzDCWXEgUTipww7Fe7q+lVb/LxMGqbUEn0fudzs98W6yglTyfARIgAbBlQN0Pn3aEMQXEeNM7wVZs10qe16l38g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmPhB8m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmPhB8m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAF2C4CED3;
	Mon, 23 Dec 2024 22:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994380;
	bh=Z9c/euzo2J2tCiy1P1Ku79dD8zSrcFc/Rm4cHAQE+24=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RmPhB8m86JqlAndz3hntZghvi40HJz5ohZgWpdej4/DjhcRbMGHfb4YqnlAwh9m7Z
	 HM8XANIUfdmRXxQinzdN7KArxlV/JcHoYbhVTPS70yQP2iWluLaMhWfA17ZjVW1ESq
	 awzJ2Hlzdxaj5PBh7knPxfSm21r/2vfJHSNkZkDT4zNSXBEQeBvNU7VEIWkk2T7ch1
	 EmDaDEGWkQ5ubMFx9y1NrLCsMA01oHGAU50ACgXp0b0wg3w4ClZBHQGjdL/Grr60yY
	 gvWBYWkbw+Vn8jasGVlxA43u8JHcgALw+E1q1QkQQXMxNLY8fc80Ni0shBoXO0XzdV
	 9KQz6TAJsgCKg==
Date: Mon, 23 Dec 2024 14:53:00 -0800
Subject: [PATCHSET v6.2 3/5] xfs: enable in-core block reservation for rt
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499418111.2380002.9571458057931114338.stgit@frogsfrogsfrogs>
In-Reply-To: <20241223224906.GS6174@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

In preparation for adding reverse mapping and refcounting to the
realtime device, enhance the metadir code to reserve free space for
btree shape changes as delayed allocation blocks.

This enables us to pre-allocate space for the rmap and refcount btrees
in the same manner as we do for the data device counterparts, which is
how we avoid ENOSPC failures when space is low but we've already
committed to a COW operation.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-rt-metadata-space

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=reserve-rt-metadata-space
---
Commits in this patchset:
 * xfs: prepare to reuse the dquot pointer space in struct xfs_inode
 * xfs: allow inode-based btrees to reserve space in the data device
---
 fs/xfs/libxfs/xfs_ag_resv.c  |    3 +
 fs/xfs/libxfs/xfs_attr.c     |    4 -
 fs/xfs/libxfs/xfs_bmap.c     |    4 -
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_metadir.c  |    4 +
 fs/xfs/libxfs/xfs_metafile.c |  205 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_metafile.h |   11 ++
 fs/xfs/libxfs/xfs_types.h    |    7 +
 fs/xfs/scrub/tempfile.c      |    1 
 fs/xfs/xfs_dquot.h           |    3 +
 fs/xfs/xfs_error.c           |    3 +
 fs/xfs/xfs_exchrange.c       |    3 +
 fs/xfs/xfs_fsops.c           |   17 +++
 fs/xfs/xfs_inode.h           |   16 +++
 fs/xfs/xfs_mount.c           |   10 ++
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_qm.c              |    2 
 fs/xfs/xfs_quota.h           |    5 -
 fs/xfs/xfs_rtalloc.c         |   21 ++++
 fs/xfs/xfs_rtalloc.h         |    5 +
 fs/xfs/xfs_trace.h           |   45 +++++++++
 fs/xfs/xfs_trans.c           |    4 +
 fs/xfs/xfs_trans_dquot.c     |    8 +-
 23 files changed, 367 insertions(+), 19 deletions(-)

