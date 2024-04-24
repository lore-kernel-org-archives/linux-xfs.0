Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219C613B5A6
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929635; cv=none; b=qIIPvt47DElOSX/eu8GQ9MhxD4j4ydDOcUntWgLz+VxCgO6hw4HYetvtn86Tfo8HOzaudQdle924IHzqQf7QLIeO+qcH/u15AvnbXoqxcjwKzNT6TGlYJvkjZaEG88DjOz+W6ezbhlkbMDMRuMQUAJ8zQFRBKcIswyI/cwqqt/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929635; c=relaxed/simple;
	bh=TLA/+unjMvUmp5HFpTqyyeXW+mCJHEnbikOxG2rfRZM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=pY0RkIHWerDe96NUeHRn7z4/jO+vUEDwuEhRTj4My+bmn3UgA6h3HiQmLzteF/woA6me2b6ftxW+cOxG1OJNeJpryQOWmtGTXGLdWumUpdcRsFLfeHp4SSQmj1+XTYqQStjlYQcfDxBz+ggs/2e3gaV++2YjSDFmZNcSBJ1mP0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvvjWvCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvvjWvCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5206C32781;
	Wed, 24 Apr 2024 03:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929634;
	bh=TLA/+unjMvUmp5HFpTqyyeXW+mCJHEnbikOxG2rfRZM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZvvjWvCTdv+AHq4NsSHgCs0Vo93ogD8HHUNKaFHAvL1+XkHSDjcYVn5pL2X0D3b7n
	 WmfuoKo/IkUUVu/1dI3l+lZex2MGL/vWCevCd7PM1iiEbmS3MCEtIwR6LX2q3sd/fS
	 jXhAkTqbpXprGRG/H172kfb9CIqNWojcSxFR12bN6pGS4YinZZcBuJ/Ot57a3bWs75
	 2FWzmSQZHP/rtWoW9r2yqh5lQ2Y6P9NRyCve57mmZq6oQgQYZ0ko2NHhPtPHNhdBw9
	 w2g3apbYZU2wTFm+pNJTOU13boJG//73/qSmU4K1gxgDJZj2z+K/nurUwuYqllgROU
	 HlkgEJHgC/62w==
Date: Tue, 23 Apr 2024 20:33:54 -0700
Subject: [GIT PULL 1/9] xfs: shrink struct xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392949873.1941278.1022229329837312067.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6a94b1acda7e7262418e23f906c12a2b08b69d12:

xfs: reinstate delalloc for RT inodes (if sb_rextsize == 1) (2024-04-22 18:00:50 +0530)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/shrink-dirattr-args-6.10_2024-04-23

for you to fetch changes up to cda60317ac57add7a0a2865aa29afbc6caad3e9a:

xfs: rearrange xfs_da_args a bit to use less space (2024-04-23 07:46:51 -0700)

----------------------------------------------------------------
xfs: shrink struct xfs_da_args [v13.4 1/9]

Let's clean out some unused flags and fields from struct xfs_da_args.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: remove XFS_DA_OP_REMOVE
xfs: remove XFS_DA_OP_NOTIME
xfs: remove xfs_da_args.attr_flags
xfs: make attr removal an explicit operation
xfs: rearrange xfs_da_args a bit to use less space

fs/xfs/libxfs/xfs_attr.c     | 31 ++++++++++++++++---------------
fs/xfs/libxfs/xfs_attr.h     | 11 +++++++++--
fs/xfs/libxfs/xfs_da_btree.h | 29 +++++++++++++----------------
fs/xfs/scrub/attr.c          |  1 -
fs/xfs/scrub/attr_repair.c   |  3 +--
fs/xfs/xfs_acl.c             | 17 +++++++++--------
fs/xfs/xfs_ioctl.c           | 19 ++++++++++---------
fs/xfs/xfs_iops.c            |  2 +-
fs/xfs/xfs_trace.h           |  7 +------
fs/xfs/xfs_xattr.c           | 22 ++++++++++++++++++----
fs/xfs/xfs_xattr.h           |  3 ++-
11 files changed, 80 insertions(+), 65 deletions(-)

