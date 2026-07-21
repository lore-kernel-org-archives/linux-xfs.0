Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F46481FC4
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 10:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630684; cv=none; b=bu0B0X8T/gYnYBRpLpvxd+Zs36yLzQAFnGmCbDcKxpGKKkJ7pFin0sBGhV+5BqoNKAJbeTLDx6D33SMSUMESiOhtBT2Ww6946wZQf8MD+n5iYJC2omdkOBf+zborcR4yf4NbzW/dWL1mVL2XKu51EKdGC7y2X8uY4kOSKMelRY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630684; c=relaxed/simple;
	bh=I/+8DdAUWqyjPd1Q62ZtiRGEwZo1yIXmPo5c1TDu1/s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WQlA5JJUhCAjUaE1iySn7aBWdSWFWMWGB0GS7VZlsI7J4XM/qfF8AumTCoEaf5746nWaYnuDCC6Fbg/pYnC+2cdTW15w8IAnGXRRy8EXG5ZogzSbomoepR1RfTgzWuXOHw3LbqXetLQoMrZlGeIwSMccROtayggCNMT723xJ7H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtjJ3AoD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtjJ3AoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF931F00ADB
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 10:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630673;
	bh=BPQdNZt495MO6Sy2hR9ua9v+lUZCrTNd8r5mxnyKWXY=;
	h=Date:From:To:Subject;
	b=VtjJ3AoDkN/gF2boAmJdTUzMvv+87jfPqR65gx00acM4Bz55cNE9iSxk71KSNVtn/
	 WWChSRKKpu9AshTOcQ6hiGq0qMkLC+oUR2le3gaBTbDMelm1wqP2VYkBouf1BUORoL
	 oWApPrnKCmUj1i+4pNL8uY8UraYacliZ/9Um7CrMAxqkV91YCW72M1DmciubXEqijj
	 SwdmaVxJ9DfqeLHCY7lxrE3fmKsPyTufYw45kXIlwXnlABwWlCEtuCEelk2EooEfkY
	 UlsEnvzhsb4lCn0E8PpijygwuEtdfEZbijm0RH0+2Q3+zIOwR+oS+jyL6Syemo8o9j
	 39zl4MVu9Sjyw==
Date: Tue, 21 Jul 2026 12:44:30 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 97f341687692
Message-ID: <al9NTTxqtw41CazC@nidhogg.toxiclabs.cc>
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

97f341687692 xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int

19 new commits:

Christoph Hellwig (1):
      [39de8c9f3e4b] xfs: update BDI {io,ra}_pages values based on the RT device limits

Cihan Karadag (1):
      [97f341687692] xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int

Darrick J. Wong (5):
      [a75913d55437] xfs: check cowextsize in xrep_inode_cowextsize
      [442b827ea7d3] xfs: fix transaction block reservation in xrep_rtbitmap
      [b6d9247dd5f0] xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error
      [266088be85e7] xfs: zero i_nlink before repair puts inode on unlinked list
      [7b2a43bb08b7] xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems

Guanghui Yang (1):
      [b7e53968cb88] xfs: propagate errors from xfs_rtginode_load

Ibrahim Hashimov (1):
      [c42b8e3237f6] xfs: bounds-check buffer log item's dirty bitmap

Johannes Thumshirn (4):
      [9bb976117a1b] xfs: add xfs_metadir_create_file helper
      [6b0b126b05cd] xfs: create quota metadir inodes using xfs_metadir_create_file
      [4885de0d9a15] xfs: create rtgroup metadir inodes using xfs_metadir_create_file
      [eaef2d68a491] xfs: mark internal metadir file creation helpers static

Pankaj Raghav (2):
      [a12a5f85daf0] xfs: add an allocation mode to xfs_alloc_file_space()
      [e105fd8ccfa5] xfs: add support for FALLOC_FL_WRITE_ZEROES

Qiang Ma (1):
      [38cd012fba2c] xfs: clear zapped attr fork state when bmap repair finds no attr fork

Xiang Mei (1):
      [fde50b32183f] xfs: fix off-by-one in rtrefcount btree root level validation

Yun Zhou (2):
      [b9ad0b9891dd] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
      [2ba9288085f1] xfs: handle NULL b_addr in xfs_buf_free

Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c         |  3 +-
 fs/xfs/libxfs/xfs_dquot_buf.c        | 39 +++++----------
 fs/xfs/libxfs/xfs_metadir.c          | 64 +++++++++++++++----------
 fs/xfs/libxfs/xfs_metadir.h          |  8 ++--
 fs/xfs/libxfs/xfs_rtgroup.c          | 58 ++++++++++-------------
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  4 +-
 fs/xfs/libxfs/xfs_sb.c               | 37 ++++++++-------
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
 21 files changed, 378 insertions(+), 161 deletions(-)

