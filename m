Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146D027147B
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 11:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751975768; cv=none; b=dbBARnkvCmAHEEOx5GHcXmvwMAqrctT6MTNvrezyboxu5GeVWgXTzETYuqTZiLTGvIgj2qebMlKopIlxbAAlWTkb/Ebxb8vAU0BKz0jegHaXrl3ft0bnLml7M3ZnAWLXAd0z2tSD8vPO7XdDL3FgQ1wPCWTbnyTMvxDiJlVbp0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751975768; c=relaxed/simple;
	bh=g/mMlGQ6OpR7pji6K44YIeHCvyggh3aVDhH2xMjjc7c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YXwVZwRjuC19vixzHYiLO9WXbYOz2vVTnOSLbx5HVt1jIyj8Z4B7I8rxM3P1uzaGVmyEXpYVbpKj/ct5zKCIt39N8jBLisRCSnfbpEcqDumi6Gn9rc04tb5kt6Hc2GPC0nn++Cqal/LqqSDiQro1knR4NjlGi7LM9Nwje51AtMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYmyffyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYmyffyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74BEC4CEF0
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 11:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751975767;
	bh=g/mMlGQ6OpR7pji6K44YIeHCvyggh3aVDhH2xMjjc7c=;
	h=Date:From:To:Subject:From;
	b=AYmyffyd3xFkskJFOil059oYaxyI4QFCPiTHrHIPLggAKiMBwxJq7k7KnXDfJPrnT
	 +CWN9/34CMh4ThgRyAOuRtCHQTwIA4VEW0x28DgQeT2kBYr1wEJYEQfPvV/XiovxCp
	 qncXKs3v8lg1FD8cWYJmiBzgEPkNwiY9dUi0J+IAmgcZC0boVPVmfcP6bjLSIjTCKG
	 QzaYGqYAZUBfZtU7ZTlHU8sPyk4MFe5Fm8ewDhwlNjPcIAGx435JK4ivOaWoSH8T27
	 3TSLTZdRUH7WMZCLsjEDSbNArgGk3M2/az9xygGasFxVA36qGTP8ah5jAWfiYLOBnc
	 VlfbYbwd46OKA==
Date: Tue, 8 Jul 2025 13:56:03 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 1928a4228b2f
Message-ID: <z3bupeq3h5bqdebjqu2gkrg5ndov3cyzywqcoymrf5yagnv6cz@p7s2awrglr4z>
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

1928a4228b2f Merge branch 'xfs-6.17-merge' into for-next

15 new commits:

Carlos Maiolino (2):
      [ec5a785ea7c5] Merge branch 'xfs-6.16-fixes' into for-next
      [1928a4228b2f] Merge branch 'xfs-6.17-merge' into for-next

Christoph Hellwig (6):
      [a578a8efa707] xfs: clean up the initial read logic in xfs_readsb
      [d9b1e348cff7] xfs: remove the call to sync_blockdev in xfs_configure_buftarg
      [e74d1fa6a7d7] xfs: add a xfs_group_type_buftarg helper
      [e4a7a3f9b243] xfs: refactor xfs_calc_atomic_write_unit_max
      [988a16827582] xfs: rename the bt_bdev_* buftarg fields
      [9b027aa3e8c4] xfs: remove the bt_bdev_file buftarg field

Fedor Pchelkin (6):
      [c4c6aee6ba87] xfs: rename diff_two_keys routines
      [fb7eff8c9f1b] xfs: rename key_diff routines
      [ff48e83c9dcd] xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
      [786b3b2e1660] xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
      [a0b2b28e1cc1] xfs: use a proper variable name and type for storing a comparison result
      [10e4f0aebdad] xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()

Pranav Tyagi (1):
      [f2eb2796b951] xfs: replace strncpy with memcpy in xattr listing

Code Diffstat:

 fs/xfs/libxfs/xfs_alloc_btree.c      | 52 ++++++++-----------
 fs/xfs/libxfs/xfs_bmap_btree.c       | 32 ++++--------
 fs/xfs/libxfs/xfs_btree.c            | 33 ++++++------
 fs/xfs/libxfs/xfs_btree.h            | 41 ++++++++-------
 fs/xfs/libxfs/xfs_ialloc_btree.c     | 24 ++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c   | 18 +++----
 fs/xfs/libxfs/xfs_rmap_btree.c       | 67 +++++++++----------------
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 18 +++----
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 67 +++++++++----------------
 fs/xfs/scrub/btree.c                 |  2 +-
 fs/xfs/scrub/rcbag_btree.c           | 38 ++++----------
 fs/xfs/xfs_buf.c                     | 15 ++----
 fs/xfs/xfs_buf.h                     |  8 ++-
 fs/xfs/xfs_discard.c                 | 29 +++--------
 fs/xfs/xfs_file.c                    |  2 +-
 fs/xfs/xfs_inode.h                   |  2 +-
 fs/xfs/xfs_iomap.c                   |  2 +-
 fs/xfs/xfs_iops.c                    |  2 +-
 fs/xfs/xfs_mount.c                   | 97 +++++++++++++++---------------------
 fs/xfs/xfs_mount.h                   | 17 +++++++
 fs/xfs/xfs_notify_failure.c          |  3 +-
 fs/xfs/xfs_trace.h                   | 31 ++++++------
 fs/xfs/xfs_xattr.c                   |  2 +-
 23 files changed, 249 insertions(+), 353 deletions(-)
