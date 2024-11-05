Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F84149C53
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850713; cv=none; b=ZdZhZOi8NnffzDZYUFbAWux11r3kyfTAl5CyVIHsG/v1lpJd6/2UOJawf9GVQtMR9nPeUBLMz0cUPbJtm1cP9ATTc+/nGD0q7KCzwZWUiNgeiijBHNl4Bho9Et+vfrcqH0h1e/dveVjWVLW6NXx7U1D6GTaGCkLJfgT/kANE3Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850713; c=relaxed/simple;
	bh=j1P5+9Bh2lzE4pMBAPAaCslwq7yI9YBNA/Z/QOmUfj4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=ZybThGK9wsGVri/96C+aW6ohW3ZvPI+UB256gfEZgHPyJsKKLmTWoVdavwMMgwq5bzxqP/MgG7qtMWYecl7q8Sp9nxlZ1C178xheBT7qThZOOejLEL5Vml6JtkNZrJlJefTsThmQW1K8vdZ27jgg/CmXN7MxuRw3RAH9+vZaO2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocuYkaZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocuYkaZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADAFC4CECF;
	Tue,  5 Nov 2024 23:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850713;
	bh=j1P5+9Bh2lzE4pMBAPAaCslwq7yI9YBNA/Z/QOmUfj4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ocuYkaZqBPVzmlxSXXnDHfx5jIzsrG0rPYjm3CpSIIsQuEkNb13+0ilWx2sptp9XK
	 r+lU9RU2WoTQtMSmbclnfvFcDbuXJadzZyKNNPqgaIDZTudMMcqTIx/mD0BOwX5OgO
	 3Bw2ykl0Bc9N0MNRoizqf+ZHv+LILAt5WQPRoQvTBbS4+bmjha7cvaTqhfM8LFJF2W
	 e3+Kfq+7FEgoIMJJ0664Q9RJxSCjeQ4I3nFWvpowu5As0WSzB3TFySRBPzsMJB02w1
	 SqiGUe93JD0WImyju5zP0cC9Tz22JpG2df0SaL630ZabN2SyQ4hf60PL9Bjj9M4kJO
	 NvMFKDd+TrH/A==
Date: Tue, 05 Nov 2024 15:51:52 -0800
Subject: [GIT PULL 07/10] xfs: persist quota options with metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173085054493.1980968.6373683620938526057.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105234839.GL2386201@frogsfrogsfrogs>
References: <20241105234839.GL2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit a3315d11305f5c2d82fcb00e3df34775adff4084:

xfs: use rtgroup busy extent list for FITRIM (2024-11-05 13:38:44 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/metadir-quotas-6.13_2024-11-05

for you to fetch changes up to d5d9dd5b3026a8bf58f21228b47df9e9942a9c42:

xfs: persist quota flags with metadir (2024-11-05 13:38:45 -0800)

----------------------------------------------------------------
xfs: persist quota options with metadir [v5.5 07/10]

Store the quota files in the metadata directory tree instead of the
superblock.  Since we're introducing a new incompat feature flag, let's
also make the mount process bring up quotas in whatever state they were
when the filesystem was last unmounted, instead of requiring sysadmins
to remember that themselves.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: refactor xfs_qm_destroy_quotainos
xfs: use metadir for quota inodes
xfs: scrub quota file metapaths
xfs: persist quota flags with metadir

fs/xfs/libxfs/xfs_dquot_buf.c  | 190 +++++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_fs.h         |   6 +-
fs/xfs/libxfs/xfs_quota_defs.h |  43 +++++++
fs/xfs/libxfs/xfs_sb.c         |   1 +
fs/xfs/scrub/metapath.c        |  76 +++++++++++++
fs/xfs/xfs_mount.c             |  15 +++
fs/xfs/xfs_mount.h             |  21 +++-
fs/xfs/xfs_qm.c                | 250 +++++++++++++++++++++++++++++++----------
fs/xfs/xfs_qm_bhv.c            |  18 +++
fs/xfs/xfs_quota.h             |   2 +
fs/xfs/xfs_super.c             |  25 ++++-
11 files changed, 586 insertions(+), 61 deletions(-)

