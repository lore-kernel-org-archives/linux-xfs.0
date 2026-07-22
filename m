Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525BC30BB80
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 13:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726297; cv=none; b=rsedfW+bJCqc77P4hW3+sx/1MKhEmhGMwO6pa8Lv6Jqfd1J9g32J56CwdMxzr3r60RwfYx7SJPY22bSFM3ZMT2cnIi1fiBIDSHU247lKczblWR9TWMpwEvQrtNiaXqHkiX1x6xS9VQLIUgnzlI0PqOYnB4M2pTvjfORGEavpQYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726297; c=relaxed/simple;
	bh=vkE9A1EfzhQ89kJ956Kfzgb3ZMU3kNoLqi9U/bQUN6Y=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=riaZCPGyXFZ/psQQ4I87m7NLLZ9OqRsYHSn3IxkA/d6mA5F+Ar0pI97TGgAT83K6IZ9ZpVCk0nUX+Z4LWniwdat/LhY/U2JTTVy5RiG+ieb7ZQkvYfe+H3hhelPt6H88HWbfUzul4MJ3uaZw0fahJ53vVNGVWaZIBYwXt9zVEpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDYxG2At; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDYxG2At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEDE1F000E9
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784726295;
	bh=RxRInk/Oms753iC8TglVLF6tJimdkPN8ueBs9WDFfcw=;
	h=Date:From:To:Subject;
	b=jDYxG2AtCAqj/65yifsx/xjHdHnIJszKoLLcyrmYGuBjNuxp2EpPACAtiS3vyNmQT
	 SDH/JRWMDiptN8n3f0cV8yg2jv8QJZcTWfmAas30pTyHVWnoottAxN5MAOZty86vI3
	 lVuDoycur+ujqvIE003qhmyAR2OmO6lUYeYuUC1q2MVOSJ029sAbC5Gb7nhSv0ozgI
	 DCzEdSOFId46iB+vOZFyPUQr29IvCvnASLf17tFWN4x3c8xukQm7fEATa3iz0CJ5wP
	 KoK6kVgyKtDWH9wpxuTeZX1HqkNCX4Z8PRNQutdJ7cz+fwiMhLN9abNq3JeZY3IVPB
	 Afy+rrN4D2p2w==
Date: Wed, 22 Jul 2026 15:18:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 56aa9ef3c413
Message-ID: <amDCWI4UwZpRQKJR@andromeda.toxiclabs.cc>
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

	ssh://git@gitolite.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

This removes a single patch from the previous push, everything else is
the same.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

56aa9ef3c413 xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int

18 new commits:

Christoph Hellwig (1):
      [7aa67044e7d8] xfs: update BDI {io,ra}_pages values based on the RT device limits

Cihan Karadag (1):
      [56aa9ef3c413] xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int

Darrick J. Wong (5):
      [270ffcd9b0a4] xfs: check cowextsize in xrep_inode_cowextsize
      [61606f8846a9] xfs: fix transaction block reservation in xrep_rtbitmap
      [8ed78104722b] xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error
      [49933254ba8d] xfs: zero i_nlink before repair puts inode on unlinked list
      [b28d23c51635] xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems

Guanghui Yang (1):
      [b7e53968cb88] xfs: propagate errors from xfs_rtginode_load

Ibrahim Hashimov (1):
      [813f8136a2ce] xfs: bounds-check buffer log item's dirty bitmap

Johannes Thumshirn (4):
      [daf43402da0d] xfs: add xfs_metadir_create_file helper
      [e6ecb1a98d14] xfs: create quota metadir inodes using xfs_metadir_create_file
      [de64b150a70c] xfs: create rtgroup metadir inodes using xfs_metadir_create_file
      [c6c54d05b129] xfs: mark internal metadir file creation helpers static

Pankaj Raghav (2):
      [86e332447d72] xfs: add an allocation mode to xfs_alloc_file_space()
      [b16b63a47902] xfs: add support for FALLOC_FL_WRITE_ZEROES

Qiang Ma (1):
      [87b2a82e135b] xfs: clear zapped attr fork state when bmap repair finds no attr fork

Xiang Mei (1):
      [cc3144da377d] xfs: fix off-by-one in rtrefcount btree root level validation

Yun Zhou (1):
      [d852729c5f4f] xfs: handle NULL b_addr in xfs_buf_free

Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c         |  3 +-
 fs/xfs/libxfs/xfs_dquot_buf.c        | 39 +++++----------
 fs/xfs/libxfs/xfs_metadir.c          | 64 +++++++++++++++----------
 fs/xfs/libxfs/xfs_metadir.h          |  8 ++--
 fs/xfs/libxfs/xfs_rtgroup.c          | 58 ++++++++++-------------
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  4 +-
 fs/xfs/scrub/agheader.c              |  2 +-
 fs/xfs/scrub/bmap.c                  |  5 ++
 fs/xfs/scrub/inode_repair.c          |  2 +-
 fs/xfs/scrub/nlinks_repair.c         |  7 ++-
 fs/xfs/scrub/rtbitmap_repair.c       | 46 +++++++++++-------
 fs/xfs/scrub/rtsummary.c             |  2 +-
 fs/xfs/xfs_bmap_util.c               | 42 +++++++++++++---
 fs/xfs/xfs_bmap_util.h               |  7 ++-
 fs/xfs/xfs_buf.c                     |  2 +-
 fs/xfs/xfs_buf_item_recover.c        | 57 +++++++++++++++-------
 fs/xfs/xfs_file.c                    | 92 ++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h                   |  7 +++
 fs/xfs/xfs_rtalloc.c                 |  2 +-
 fs/xfs/xfs_super.c                   | 53 ++++++++++++++++++++-
 20 files changed, 359 insertions(+), 143 deletions(-)
