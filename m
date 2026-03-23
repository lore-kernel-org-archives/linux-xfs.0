Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD26390CA2
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 10:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262828; cv=none; b=hz4yVqKdxR8JbdlewUPKCr2tnesNaX+bUXVPGV4nk8kDZXPQY0vHl9vZfyZtw/nc4rj7O1RY0j3EGnRKHf7F7iriUjFuTeUKtc9hQuIZeBF1nLld3LP5Ibepb+ANXhcPJ2DMRSc3Oq7rDoFJcYjaTTA7S43quBqdlsxuHp6EkN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262828; c=relaxed/simple;
	bh=WfUFLGK5EQw5T6cjfB5IloW2WOpaEH0yNOsHMRUnmVs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jaBJkDsTrVt3hpeeERpbF9ULUYGkMNVhcLJZYGfHm4Kh7SZPHxXIwnOB3CeIaJdmcBFkZbER20Ks/62WPUTFtqv+mHkmmUDI2BMUd3L+Knd9RSqdDWUx08EEe+PXOvI/Cph4wrFZl3tfcO7ca5evafEnMMnsI7YhfJnJCpd8y8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hiwtdyqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hiwtdyqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8CFC2BCB4
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 10:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774262827;
	bh=WfUFLGK5EQw5T6cjfB5IloW2WOpaEH0yNOsHMRUnmVs=;
	h=Date:From:To:Subject:From;
	b=Hiwtdyqijdtu9S/gKSAa+i0ppcExYyOltPyJTJ714lvt8gHQemzqMMcBzCy5I84NM
	 4wnhz9Ewh9xqoTY4y+c/SsSjxXn4absMJKyuLMXCOUtnMkAqYL5Y8+1zacxwo+Dr5x
	 IcH8AtRUDW7HL9ZvJt8hnhg4miQpPQnR1hLIY3EQBiwvTyr+n8CUxmfoy8A9QqRnzo
	 mLd6CHXNRTlrTbB2a+E55ya5DurHL2FxhuP0uLy5z+DVIMM/W5opeANyoe9iYmqEZm
	 daq0XH19QAIMMIzLDdOxHjbLvfID83p6/vKzZhVENRjitNKvSc5+d2e8eDuldfbX9Z
	 4gY/5/SiQPm/g==
Date: Mon, 23 Mar 2026 11:47:00 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to df236c996bb4
Message-ID: <acEaBhyjR2TVXk50@nidhogg.toxiclabs.cc>
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

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

df236c996bb4 Merge branch 'xfs-7.1-merge' into for-next

17 new commits:

Brian Foster (8):
      [92e9dff9ca50] xfs: fix iomap hole map reporting for zoned zero range
      [2f46c239fce6] xfs: flush dirty pagecache over hole in zoned mode zero range
      [a35bb0dec955] iomap, xfs: lift zero range hole mapping flush into xfs
      [c35a3e273e86] xfs: flush eof folio before insert range size update
      [a8eb41376df9] xfs: look up cow fork extent earlier for buffered iomap_begin
      [c770f997a422] xfs: only flush when COW fork blocks overlap data fork holes
      [ce9d27ca8b2e] xfs: replace zero range flush with folio batch
      [388bb26b3d33] xfs: report cow mappings with dirty pagecache for iomap zero range

Carlos Maiolino (2):
      [e9b7a02e5859] Merge branch 'xfs-7.0-fixes' into for-next
      [df236c996bb4] Merge branch 'xfs-7.1-merge' into for-next

Long Li (6):
      [e942498385bf] xfs: only assert new size for datafork during truncate extents
      [ce4e789cf356] xfs: factor out xfs_attr3_node_entry_remove
      [e65bb55d7f8c] xfs: factor out xfs_attr3_leaf_init
      [b854e1c4eff3] xfs: close crash window in attr dabtree inactivation
      [d72f2084e309] xfs: fix ri_total validation in xlog_recover_attri_commit_pass2
      [c6c56ff975f0] xfs: remove redundant validation in xlog_recover_attri_commit_pass2

Lukas Herbolt (1):
      [8da6fd088472] xfs: Use xarray to track SB UUIDs instead of plain array.

Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c |  22 +++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
 fs/xfs/libxfs/xfs_da_btree.c  |  53 +++++++++++----
 fs/xfs/libxfs/xfs_da_btree.h  |   2 +
 fs/xfs/xfs_attr_inactive.c    |  95 ++++++++++++++++-----------
 fs/xfs/xfs_attr_item.c        |  50 +--------------
 fs/xfs/xfs_file.c             |  17 +++++
 fs/xfs/xfs_inode.c            |   3 +-
 fs/xfs/xfs_iomap.c            | 146 ++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_mount.c            |  75 +++++++++++-----------
 fs/xfs/xfs_mount.h            |   3 +
 11 files changed, 298 insertions(+), 171 deletions(-)
