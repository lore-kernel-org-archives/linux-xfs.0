Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2115D1E9063
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565665; cv=none; b=MMCgG1mX1simG6bU3YYr6f1M6cXLZbgDjsfbzzjq6uyyEkmZf+ewdPelxDKkacH8fnqVtXAsSrOn7BFFuLHmotAyUVCn+SRNqt2ytCB5NT3DB0I1N3Y6qaxgeLgcUjsneCnLkwttqh/I6G2Y6Zw6VNok6rzwC1v7P6VgVWCZpXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565665; c=relaxed/simple;
	bh=Eu25UvfzNBN92J0rS+sQgmq3NXmzYEUSX1d0Vhfyiq8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Y8sCKDNPFLMQrIgbOhHY52c5dbrxEyT12D1j5BnoSejpPCoTnRMYEfR8BojtaMzhinkSDZ6T20yk0PENZCCscO/LVMFYqVwl3qrsygNyidwKBC9wXGOS49dE/rxr9TTmJPJRUcvAmQFVvrY3VPR60RTE9ADDiQtJsNZlsozKsCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqVq5gC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqVq5gC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D34C4CECF;
	Thu, 14 Nov 2024 06:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565664;
	bh=Eu25UvfzNBN92J0rS+sQgmq3NXmzYEUSX1d0Vhfyiq8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PqVq5gC6ul06HDBnHPCiEh9+uawlz1ie6kOvllc5ksE/2rSi4LbvprI9n8mstgZo8
	 imGKjZ3a4AzRtrSey28Q+9/F30R5XIZvx6rGp5uh9TqyKm95jkfZY7h1K7w05cmXaf
	 2MkSsPGNLXRMUZvteAIG3Gtw7HNmfmRXCo9fRc1BVJHa+ByRbj53Cs4hrUpD1ofhDm
	 1NtSr0dF9qvKbWNm+wt1FycUUaivTZUxXplMgYGD14mlnDSBKMD44a7omT+T9aTdNQ
	 azIj1mEEJ94+8p2cF+tlr97JaDOb5jHdjVKkcbQTHq2ntAaPRAFq/KTxnS6po2NwTH
	 pwlt9S+xklmpg==
Date: Wed, 13 Nov 2024 22:27:44 -0800
Subject: [GIT PULL 07/10] xfs: persist quota options with metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173156551674.1445256.14338186257234741221.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114062447.GO9438@frogsfrogsfrogs>
References: <20241114062447.GO9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 782d6a2f53677f2647513fa6b9e8584130960908:

xfs: use rtgroup busy extent list for FITRIM (2024-11-13 22:17:11 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/metadir-quotas-6.13_2024-11-13

for you to fetch changes up to a68492e312d9033055b0012a08f2e23ea7311654:

xfs: persist quota flags with metadir (2024-11-13 22:17:12 -0800)

----------------------------------------------------------------
xfs: persist quota options with metadir [v5.7 07/10]

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

