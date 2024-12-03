Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D009F1EB9EB
	for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2024 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733230170; cv=none; b=CoO7ddb2vWg6+RNcVE+3a+kPpOHJPYLbq9TiNB9GJfgTwss/y3cYrAEZyjS+xe+cTZ7J+ehqZKuvhLHt4LhJVlPZPTiuuDzVofl/HTsQRpJYTcqGcdwMtJsOnH99Fu0LK/aO+2xuehIkCb2xUEFH+YoQgUiubess2yxsVAWWvHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733230170; c=relaxed/simple;
	bh=H2vow30bkNQeiSnae6NHsZLf9maJZ/CkNwRhOBxBWBY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=l3+gdAPoI6trFPSt6d3sFWqevutk0O9ZMmzc57AIfm0fVunrzRS2vhcIMVuKMzzCKVcs3vP3PR/wq6LcfjA4Fjn30C9bCrwczS89NGR8UWcB2lVhScFmF3D1zfNCrrhcX7QNK/7UpC9E3A0IHuMuAh4jVefhTcr2n2TjWig/Q4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omapaOc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omapaOc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DB5C4CED6;
	Tue,  3 Dec 2024 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733230170;
	bh=H2vow30bkNQeiSnae6NHsZLf9maJZ/CkNwRhOBxBWBY=;
	h=Date:From:To:Cc:Subject:From;
	b=omapaOc0Rs1oMPwsyFJu2Uz+vgbSyH1GGMoizAiLPL0FN/skkdBWHH/MuGs7Yrd+d
	 SCt9Pm6lnyKE2Zl+3nFE+SsiXVMlEJg7eE/+LSY24sWQ9DGA+8pJ2V4mOCP147+hB9
	 NyJ+SaFHpCxu0GSD1fJ8vfvhf0yhlpHJx2aPraLpZyutGQwYTvsTFH4M3PIaKs83KD
	 9txbsnU5HgudshRuJAMw8E9SomSPqQqNUX03ZKr2nyxpQXsd8UhpNRpJT8BenwCrBS
	 vMK+v+emmuQe6qMmGdykBUOL3bEs/k8wjCcwVO5VpCKRQz7lFqjbiGXT+ABoFqoPer
	 3rTsWQCcPfEHA==
Date: Tue, 3 Dec 2024 13:49:25 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for 6.13-rc2
Message-ID: <ejncdz5w43y5jn57hzskpsu3hqbxfz56t6mddjtpr3tw6nimyl@ryh2fn4yd4t5>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

could you please pull the patches below? I just tried a merge against your TOT
and I didn't get any conflicts.

All patches, except the last one have been in linux-next for a while. The last
one though is an obvious fix from Christoph, , which is internal to xfs, and has
been tested within xfs-tree without any problems found. I thought it's worth to
send it now instead of leaving it waiting for yet another cycle just because
it has not been picked up by linux-next yet.


The following changes since commit 28eb75e178d389d325f1666e422bc13bbbb9804c:

  Merge tag 'drm-next-2024-11-21' of https://gitlab.freedesktop.org/drm/kernel (2024-11-21 14:56:17 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.13-rc2

for you to fetch changes up to cc2dba08cc33daf8acd6e560957ef0e0f4d034ed:

  xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay (2024-11-28 12:54:22 +0100)

----------------------------------------------------------------
Bug fixes for 6.13-rc2

* Use xchg() in xlog_cil_insert_pcp_aggregate()
* Fix ABBA deadlock on a race between mount and log shutdown
* Fix quota softlimit incoherency on delalloc
* Fix sparse inode limits on runt AG
* remove unknown compat feature checks in SB write valdation
* Eliminate a lockdep false positive

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay

Dave Chinner (3):
      xfs: fix sparse inode limits on runt AG
      xfs: delalloc and quota softlimit timers are incoherent
      xfs: prevent mount and log shutdown race

Long Li (2):
      xfs: eliminate lockdep false positives in xfs_attr_shortform_list
      xfs: remove unknown compat feature check in superblock write validation

Uros Bizjak (1):
      xfs: Use xchg() in xlog_cil_insert_pcp_aggregate()

 fs/xfs/libxfs/xfs_bmap.c   |  6 ++----
 fs/xfs/libxfs/xfs_ialloc.c | 16 +++++++++-------
 fs/xfs/libxfs/xfs_sb.c     |  7 -------
 fs/xfs/xfs_attr_list.c     |  3 ++-
 fs/xfs/xfs_log.c           | 11 +++++++++++
 fs/xfs/xfs_log_cil.c       |  5 +----
 fs/xfs/xfs_log_priv.h      |  1 +
 fs/xfs/xfs_qm_syscalls.c   | 13 -------------
 8 files changed, 26 insertions(+), 36 deletions(-)
