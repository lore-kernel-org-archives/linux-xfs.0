Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F9D149C53
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 23:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850729; cv=none; b=H4e6JP/wCcaqkyQeMJ17E9a/kcDwTvtiFppHQYFle2tKJRkKDtUcwzs66Fqr8+csvJk0UVvmCDyHcjm7/7mIEKXqg/zzao/SY4pKmJAqn1OXH85HlLj9Pla55EGk0d8KS/lo/sPnGP6AuKnFDG4yJS+UlEep1ybT5MEtyOM4uLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850729; c=relaxed/simple;
	bh=eK6ZqrPvZY0r/36nCzOipTu+pYj7uLtkjz9azgIHv5s=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Z37jlBi0LRfKXMh0wtRQXEKC+56OypxNJw5cccWt4FIpETIHuLpqF4LGeAousZ45eIGDeuTryaxeoyZB744hmFk2xp6QMOS0BQN/0ntwR7OgXhJIT/v55VzyzZYXs39jFLiYnHCDq9SLMAwmww03NLBiiBf7E+5ZitM2MKLvePc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwYfHbgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwYfHbgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE617C4CECF;
	Tue,  5 Nov 2024 23:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850728;
	bh=eK6ZqrPvZY0r/36nCzOipTu+pYj7uLtkjz9azgIHv5s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nwYfHbgqFQmT8MrIrwpzds0YJNP8Rabd9fEadNVGXHsrFlcIlBwimSNSAUGYXEP6y
	 rr7eFerilpZqtv4NFxASDhghk4Y1q7nzEP2iRuPKC9SfCO78JY2/xBgA1MnXyyUbys
	 0c94vG5trVGWbXo8TJLzCYWa4w+G+mlxKiVHp0uc+UBReqS4nT+vZan4GsUUKfvUfi
	 zXNOafttob9FjF3DyZdAs20YA1dnQSApdCjnvCgdcbjQKfr+vgcVT/4a22RvZR3/+Q
	 HfwkrRSHLkVxe27zj4mCLIb9hETV1BZMhv8aHejXP8eCURZXkDCehjbdpyWT7L0XV/
	 3iuJrw9csFstg==
Date: Tue, 05 Nov 2024 15:52:08 -0800
Subject: [GIT PULL 08/10] xfs: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173085054588.1980968.17737309475189632112.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit d5d9dd5b3026a8bf58f21228b47df9e9942a9c42:

xfs: persist quota flags with metadir (2024-11-05 13:38:45 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/realtime-quotas-6.13_2024-11-05

for you to fetch changes up to edc038f7f3860911d4fc2574e63cedfe56603f1b:

xfs: enable realtime quota again (2024-11-05 13:38:46 -0800)

----------------------------------------------------------------
xfs: enable quota for realtime volumes [v5.5 08/10]

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that it nearly works: the only broken
pieces are chown and delayed allocation, and reporting of project
quotas in the statvfs output for projinherit+rtinherit directories.

Fix these things and we can have realtime quotas again after 20 years.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: fix chown with rt quota
xfs: advertise realtime quota support in the xqm stat files
xfs: report realtime block quota limits on realtime directories
xfs: create quota preallocation watermarks for realtime quota
xfs: reserve quota for realtime files correctly
xfs: enable realtime quota again

fs/xfs/xfs_dquot.c       | 37 ++++++++++++++-----------
fs/xfs/xfs_dquot.h       | 18 +++++++++---
fs/xfs/xfs_iomap.c       | 37 ++++++++++++++++++++-----
fs/xfs/xfs_qm.c          | 72 +++++++++++++++++++++++++++++++-----------------
fs/xfs/xfs_qm_bhv.c      | 18 ++++++++----
fs/xfs/xfs_quota.h       | 12 ++++----
fs/xfs/xfs_rtalloc.c     |  4 ++-
fs/xfs/xfs_stats.c       |  7 +++--
fs/xfs/xfs_super.c       | 11 ++++----
fs/xfs/xfs_trans.c       | 31 +++++++++++++++++++--
fs/xfs/xfs_trans_dquot.c | 11 ++++++++
11 files changed, 182 insertions(+), 76 deletions(-)

