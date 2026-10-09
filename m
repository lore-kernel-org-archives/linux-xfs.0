Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B0B35B14E
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589538; cv=none; b=uQ7wGNWrl2+R3PryXWCkx58oq3pSRekJ6NfoIuzK8FMu9l4hYMITrvSHi9k3AydRJNZHaQ7+4reFjDOoj/YrYFNN4MsxmyVK54BNOb7RHRpyCn2GqqbWqs8HjfbP4GvAPtDlqvmwUI0Jkr4mkOzqi8vlusTB7aklZ4cSB/bgHJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589538; c=relaxed/simple;
	bh=Zikcak+SXxDRpcfCc002wHmMZ94wYU2hqjgvkwOx6Fg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=XIhHXZmAgxX9h9y46tXGy7SJo/UfCG5qu4O+ZLQS4Gat8yL3NKAAjykLZenrp1T9rki2JoOR5/P/UGzxoTWHCurGmYWtjWRbtFVGAN+nOCNZMrNPM13rOx+MjnOQUSCzjUCs9cuOdqZv41n7u5g1jPXCmP/GrLyeODRIvTotbQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsyVp2m5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsyVp2m5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2B9CD1F000FF;
	Fri,  9 Oct 2026 23:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589537;
	bh=6u17b137qwQf7wZHIM0NXZiIYNuCnPqMvPd9MN4z8+8=;
	h=Date:Subject:From:To:Cc;
	b=dsyVp2m5tLyDhD4epXlGS4ZCWtpMOVY3dm9TuK5bGOyACeKV7rIJX+a0ZTuopYQHM
	 jQ0VZlSbfHExv6bAFPJq4yof4c1RsITEe6aqWNN3cm6IIab0ZOb+FB1KjnIJ2pCX7O
	 peb2PG9zIwNRd8dZF2hCmeBQfdD6aA0mCpt1WZWVzmJKaWbbvwYY8HetZr5+J83EAl
	 VQU7JNGaDFuJ7ebMZUFCGO8MdbVmkRug80dkAHRYhE8Jua+iOaTftVzPoaaRQfPXDr
	 k/HrG1MI5ULB1NW0AWuD9HNaQtUyg/mrywsnwLY9c8PDItTcDWPNj4NDwMb+BFm9os
	 SWXSEnPMWOGkQ==
Date: Fri, 09 Oct 2026 16:45:36 -0700
Subject: [PATCHSET 1/3] xfsprogs: new libxfs code from kernel 7.3
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, zenghongling@kylinos.cn, yun.zhou@windriver.com,
 cem@kernel.org, syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
 kees+treewide@kernel.org, yijiangshan@kylinos.cn, floss@jetm.me,
 dgc@kernel.org, jiapenglin@tencent.com, hemanth.selam@gmail.com, hch@lst.de,
 cihan.cihan@gmail.com, johannes.thumshirn@wdc.com, linux-xfs@vger.kernel.org
Message-ID: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series ports kernel libxfs code to userspace from 7.3-rc4.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-7.3-sync
---
Commits in this patchset:
 * xfs: add xfs_metadir_create_file helper
 * xfs: create quota metadir inodes using xfs_metadir_create_file
 * xfs: create rtgroup metadir inodes using xfs_metadir_create_file
 * xfs: mark internal metadir file creation helpers static
 * xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int
 * xfs: remove spurious XBF_DONE clearing on readahead validation failure
 * xfs: hide b_flags manipulation from code outside of xfs_buf.c
 * xfs: validate attr entry pointer before field access
 * xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
 * treewide: refresh kmalloc_obj() conversions
 * xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN
 * xfs: initialise error in xfs_defer_finish_one()
 * xfs: give the deferred barrier op type a name
 * xfs: report the error that made deferred work shut down the fs
 * xfs: correct the parent pointer space reservation comment
 * xfs: initialise args->total for parent pointer updates
 * xfs: assert the reservation covers each da fork growth
 * xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
 * xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
 * xfs: preserve owner on in-memory btree creation
 * xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
 * xfs: fix under-reservation of blocks when repairing sf directories
 * xfs: remove duplicate INO1_WRITTEN check
 * xfs: fix typos and repeated words in comments
 * xfs: don't let hidden_space go negative in xfs_metafile_resv_init
 * xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots
---
 include/kmem.h                |   14 +++++++
 libxfs/stubs/xfs_mount.h      |    3 +
 libxfs/xfs_ag.h               |    2 -
 libxfs/xfs_da_btree.h         |    2 +
 libxfs/xfs_errortag.h         |    2 -
 libxfs/xfs_format.h           |    2 -
 libxfs/xfs_metadir.h          |    8 ++--
 libxfs/xfs_platform.h         |    5 ++
 libxfs/xfs_rtgroup.h          |    6 ++-
 libxfs/xfs_alloc.c            |    4 +-
 libxfs/xfs_attr_leaf.c        |   16 +++++++-
 libxfs/xfs_btree_mem.c        |    2 +
 libxfs/xfs_btree_staging.c    |   11 +++--
 libxfs/xfs_da_btree.c         |   10 ++---
 libxfs/xfs_defer.c            |   18 ++++++++-
 libxfs/xfs_dquot_buf.c        |   47 +++++++----------------
 libxfs/xfs_exchmaps.c         |    2 -
 libxfs/xfs_ialloc.c           |    2 -
 libxfs/xfs_inode_buf.c        |   17 ++++----
 libxfs/xfs_metadir.c          |   84 ++++++++++++++++++++++++-----------------
 libxfs/xfs_metafile.c         |    8 ++--
 libxfs/xfs_parent.c           |   12 +++++-
 libxfs/xfs_rtgroup.c          |   58 +++++++++++++---------------
 libxfs/xfs_rtrefcount_btree.c |   11 +++--
 libxfs/xfs_rtrmap_btree.c     |    6 ++-
 libxfs/xfs_sb.c               |   37 ++++++++----------
 libxfs/xfs_trans_space.c      |   19 ++++++++-
 27 files changed, 243 insertions(+), 165 deletions(-)

