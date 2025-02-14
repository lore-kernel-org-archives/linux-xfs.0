Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C494275401
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 08:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739522641; cv=none; b=snnUvv3p0z/ns8RJPzArCFztH+0mQE9aLIbCkxI3asuJu3vjeeQkp2wAy4ip7KsDn51uTYTbCC9s+uaOUyIBmvN570Hh9uA6uHztZGMLLHVq35kTosCGO3k3p19BjKMuigtr8w0sewNIcT1nW0s+DOIuxRyLBu6zd539n6CiF3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739522641; c=relaxed/simple;
	bh=f9iXJxbNqMhFk13UbpLbRmO4zc6JznRDc82AcCdtqV4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dofRrd1Y4h70pre5z6U3iy6Zls/iKY6NXBah/agbq2IuX1aUu2I0KT/bfW53f3ui4z5w68Vrm792a3JcViB8f64o3+9ZO3+RFtMTTQk5GVM7N1Kv8a4YnWaHkHUQUobSbnNe3Wcb0ieIL+yU8CADWhDH447OUuN3M+1edVYQIZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3Q6E7oL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3Q6E7oL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BEBC4CED1
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 08:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739522641;
	bh=f9iXJxbNqMhFk13UbpLbRmO4zc6JznRDc82AcCdtqV4=;
	h=Date:From:To:Subject:From;
	b=g3Q6E7oLY/olQiZmVAtpneJomszfddYr/64sE2qwSfC7kYrptC8zDbofTvotI/bkM
	 WqkYZk0kmnHOFnvZiXFGxSBNbHsEmWnR4iqdjkawn23R+8byzvFnS1RlbDvT6M525u
	 217mXvc3hFhEde/3+5SYscKIIXyTPo9n9CVx1E08KmGdQG2VEU4bG8p2z7vnsF4gpE
	 0jMxrwpBZJlrMxMg5xuEgk61L9qF0eamvWJDphg9DTCpc7lLZY54MFMHspO+cYhYzJ
	 Ti16vpvgloxeQtUoxc2XkTOgfuGWLJFrblpZq1XSmE3qqFHLItIm79B6otm4PWM9db
	 cVLPwiI4cQBjw==
Date: Fri, 14 Feb 2025 09:43:56 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 2d873efd174b
Message-ID: <avxz3qh3j3bm4nrhjcrgwrmhkbbkv57vwplhivsnuot7uq6hqn@tv3oc6vpkxg4>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

This has no patch changes from the previous state, the rebase was needed to fix
a tag in one of the patches. No code changes.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

2d873efd174b xfs: flush inodegc before swapon

6 new commits:

Carlos Maiolino (1):
      [9f0902091c33] xfs: Do not allow norecovery mount with quotacheck

Christoph Hellwig (2):
      [3cd6a8056f5a] xfs: rename xfs_iomap_swapfile_activate to xfs_vm_swap_activate
      [2d873efd174b] xfs: flush inodegc before swapon

Darrick J. Wong (2):
      [66314e9a57a0] xfs: fix online repair probing when CONFIG_XFS_ONLINE_REPAIR=n
      [6e33017c3276] xfs: fix data fork format filtering during inode repair

Lukas Herbolt (1):
      [9e00163c3167] xfs: do not check NEEDSREPAIR if ro,norecovery mount.

Code Diffstat:

 fs/xfs/scrub/common.h       |  5 -----
 fs/xfs/scrub/inode_repair.c | 12 ++++++++--
 fs/xfs/scrub/repair.h       | 11 ++++++++-
 fs/xfs/scrub/scrub.c        | 12 ++++++++++
 fs/xfs/xfs_aops.c           | 41 +++++++++++++++++++++++++++++----
 fs/xfs/xfs_qm_bhv.c         | 55 ++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_super.c          |  8 +++++--
 7 files changed, 114 insertions(+), 30 deletions(-)
