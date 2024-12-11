Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB802594B3;
	Wed, 11 Dec 2024 20:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947758; cv=none; b=O3KBYkgPDiEcRcjpl5GkZLcPBXLdphMSU5TDESw+kBp/6FE/PdV/4u4ysD8Yeug6i2wL6poAyb9tce/VyqgoLITPg4awrlXGk+OaI4t3beEDFeSBKXb3lcpWK7lAkqPxe86ywx1M+PHxki5TfiAFoDqZewhSx4BZyL6E/v9aEFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947758; c=relaxed/simple;
	bh=jp/wvfnyN2P3AQj2IZ+GRyBM8BCjE6wHvxTJYJV+a04=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=IMlfDsIRJWZ4hmalKRp+HyIpAiUdN/WvNxWXvJvWuJDd5PXIfSpQJ+qiW5r0mGso89HXDOuPMijBIVYd8YRR1qT7Zd7a6GF+SWe1CkrBKyg3n7fYFafb5O0fyshhE7qGuBNX1kU6i9VEv7oJRZKKn/uWXUsC8JhUmU3E8a39dmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTbe+HBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTbe+HBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70620C4CED2;
	Wed, 11 Dec 2024 20:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733947757;
	bh=jp/wvfnyN2P3AQj2IZ+GRyBM8BCjE6wHvxTJYJV+a04=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eTbe+HBCDQZBpigAdpU/Z7dHaN+stvw6DkdarP5hPlgLn7SWp5mNpNjbgsk98R7ZP
	 aZkw2p20bmKK3oI4dmsr9EPdAbKrvdoEMPEXUTIcnRqAufeEB6KYr8qsfWPfIlvKwd
	 u7zDT/l2KOgvCD5X8zQNYbufQNa44ExzW5B/obGT27+dDrE3MunOwz2Nm7rmPgOko3
	 HFC200FrxaHKL5BU6phE34h968Itc5Y/Y9YY6zdPGdBuDvWzAD/AeFeAs2B9RHFuGh
	 LyirgY/fyqBa+ddgjrhLxLCwPb7ehtAweiKKbuuxYPKDmUcYpCmlmbVeW0HbENW1Sx
	 aYzTkkAorVoOA==
Date: Wed, 11 Dec 2024 12:09:16 -0800
Subject: [GIT PULL] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, jlayton@kernel.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Message-ID: <173394762861.173777.4307006088235333862.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241211200559.GI6678@frogsfrogsfrogs>
References: <20241211200559.GI6678@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 13f3376dd82be60001200cddecea0b317add0c28:

xfs: fix !quota build (2024-12-11 10:55:08 +0100)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fixes-6.13_2024-12-11

for you to fetch changes up to bb77ec78c1ae78e414863032b71d62356a113942:

xfs: port xfs_ioc_start_commit to multigrain timestamps (2024-12-11 11:56:05 -0800)

----------------------------------------------------------------
xfs: bug fixes for 6.13 [v4]

This is hopefully the last set of bugfixes that I'll have for 6.13.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: don't move nondir/nonreg temporary repair files to the metadir namespace
xfs: don't crash on corrupt /quotas dirent
xfs: check pre-metadir fields correctly
xfs: fix zero byte checking in the superblock scrubber
xfs: return from xfs_symlink_verify early on V4 filesystems
xfs: port xfs_ioc_start_commit to multigrain timestamps

fs/xfs/libxfs/xfs_symlink_remote.c |  4 ++-
fs/xfs/scrub/agheader.c            | 71 ++++++++++++++++++++++++++++++--------
fs/xfs/scrub/tempfile.c            | 12 ++++++-
fs/xfs/xfs_exchrange.c             | 14 ++++----
fs/xfs/xfs_qm.c                    |  7 ++++
5 files changed, 84 insertions(+), 24 deletions(-)

