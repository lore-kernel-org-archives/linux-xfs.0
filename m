Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5818B382F1C
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 12:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560114; cv=none; b=E3D0ZymXwziYASdfwlIDSxX/uwolOH0sJYLJOGa66R/g48CUEbQE+AoEGncDPVzwvtgibPe/CuC0hSBqMjvM5ArgRjE7GqT0eK6/FzSBXDKJLcVjrUITo8U4kctP7/O+VWDYzBIEU8klNZ/MqDBW+MhJ4ejIh4qphq+unmuDBM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560114; c=relaxed/simple;
	bh=5d7kAxFeEEJAylz/wDsNHXumP2Ak0udpCucJAz33cC4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=py6l0Xl9Z9OkyerdWBkf0+qmUfqQLalTeHT9EyOVzPnCTKXWN9zN9j8eStyMAbqVC6ZEBiMvl0fbqx6+mIaTModhBK99/revlopQUi9RN8DAKs5fWOtOyR0Yd+dtWBroD8zOlYYVSj+oLHTH0zIh9r7kjZ+bg5fAICnoXR1syJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KADP6T70; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KADP6T70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34971F00898
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 12:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560106;
	bh=qSODQgKcIj41SawUhbAF4+EfQDfG7uxBNdqgpGkRLd4=;
	h=Date:From:To:Subject;
	b=KADP6T705IFBzaCHR/zDuE8iL4NUOIzP7xcGMQquQFuQgGv02Q9b08+77gzfXoYKY
	 W56Gmf+N0EZ/4yHTZguaUF67WhOpSo6+Ij/5MOA1JhR4Z4BeTapx2WmruJaykws82I
	 wV6qtE0n2uIsjIIjkGxnT/rc4y0xMswYzmbXcPZguPkNBmpVl4nluTBv/AoAqKIBfA
	 kAvd5KU+huX/fII0PuNvdsUxeYXX9m3JJRuIoqGYeaP4oMmi6/C7bSLMoaiSXze4kO
	 IaUet19z8MSvdQ/mt+aNXmDeYaPuSzZaV+yppBIpgOf3rdfEC7HeKqBXd3xpkZTmCr
	 2q9q/RIyecTDA==
Date: Wed, 16 Sep 2026 14:01:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 57f268f3c80a
Message-ID: <aqqFAKTRnmqWUlfJ@nidhogg.toxiclabs.cc>
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

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

57f268f3c80a Merge branch 'xfs-7.3-fixes' into for-next

28 new commits:

Aditya Prakash Srivastava (1):
      [6fdfe8606f99] xfs: prevent close() from hanging on frozen filesystems

Anuj Gupta (1):
      [c16b885ad6b5] xfs: remove unused xfs_reflink_remap_range declaration

Carlos Maiolino (1):
      [57f268f3c80a] Merge branch 'xfs-7.3-fixes' into for-next

Christoph Hellwig (1):
      [14e379600d3e] xfs: don't try to get a reference to a NULL oz in xfs_get_cached_zone

Darrick J. Wong (22):
      [5b644229bd67] xfs: guard against igrab failure in xrep_findparent_from_dcache
      [afbccf99f7f8] xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY scans return corruption
      [bb991b7f79dd] xfs: fix attr fork block count checks in xrep_inode_blockcounts
      [1c32cdc98646] xfs: release orphanage dir inode if chown fails
      [8b4ad2814274] xfs: release AGFL after walking it during rmapbt repair
      [984aab2d905a] xfs: use correct jiffies comparison function in xchk_maybe_relax
      [3083ba8dde76] xfs: check padding field in xfs_ioc_commit_range
      [8fc18580ec17] xfs: don't call xfs_exchange_range_finish for a dry run
      [471e0b6e2dda] xfs: use the correct reservations for rtrmap/refcount recovery
      [46c1b6674a7b] xfs: fix integer overflows in xbitmap set functions
      [c54110d814c3] xfs: only flag zero padding for dir3 data blocks, not dir3 block blocks
      [e9193f2f1ce3] xfs: check di_forkoff correctly in scrub
      [cb2194c0d7b2] xfs: call xfs_dquot_set_prealloc_limits if we installed default rtb limits
      [bfcb66fe0df3] xfs: fix rtgroup repair estimations
      [77b4ee150904] xfs: don't cross reference rmapbt with bitmaps if they're incomplete
      [06f5d4c2be3b] xfs: don't let memory failures leak blocks and kill repairs
      [509688570a42] xfs: don't merge different file IO error types
      [4e07c52ca4bd] xfs: fix blockgc group quota scanning when usrquota isn't enforced
      [d3bb71b6c6c2] xfs: fix cursor and pointer handling when recovering iunlink buckets
      [979dbd93efd5] xfs: drop dquot flush lock when we can't find a buffer to flush
      [d2d0237773de] xfs: don't let hidden_space go negative in xfs_metafile_resv_init
      [407b04dca661] xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots

Hemanth Selam (1):
      [2f3c2a6f963e] xfs: fix typos and repeated words in comments

Jiangshan Yi (1):
      [ce2b91bebc7b] xfs: remove duplicate INO1_WRITTEN check

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.h               |  2 +-
 fs/xfs/libxfs/xfs_alloc.c            |  4 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c        |  2 +-
 fs/xfs/libxfs/xfs_errortag.h         |  2 +-
 fs/xfs/libxfs/xfs_exchmaps.c         | 12 +-----------
 fs/xfs/libxfs/xfs_format.h           |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c        |  2 +-
 fs/xfs/libxfs/xfs_metafile.c         |  8 ++++----
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  4 ++--
 fs/xfs/scrub/agheader_repair.c       |  2 +-
 fs/xfs/scrub/alloc_repair.c          |  2 +-
 fs/xfs/scrub/bitmap.c                | 26 ++++++++++++++++++--------
 fs/xfs/scrub/dir.c                   |  2 +-
 fs/xfs/scrub/dirtree.c               |  2 +-
 fs/xfs/scrub/findparent.c            |  3 +++
 fs/xfs/scrub/health.c                |  6 +++---
 fs/xfs/scrub/inode.c                 |  2 +-
 fs/xfs/scrub/inode_repair.c          |  2 +-
 fs/xfs/scrub/newbt.c                 |  8 +++++---
 fs/xfs/scrub/orphanage.c             |  6 +++++-
 fs/xfs/scrub/reap.c                  |  2 +-
 fs/xfs/scrub/repair.c                | 19 +++++++++++++++++--
 fs/xfs/scrub/rmap.c                  | 20 ++++++++++++++------
 fs/xfs/scrub/rmap_repair.c           |  1 +
 fs/xfs/scrub/scrub.h                 |  2 +-
 fs/xfs/scrub/trace.h                 | 12 ++++++++----
 fs/xfs/xfs_bmap_item.c               |  2 +-
 fs/xfs/xfs_dquot.c                   |  8 ++++++--
 fs/xfs/xfs_exchrange.c               | 13 +++++++++----
 fs/xfs/xfs_file.c                    | 22 +++++++++++++---------
 fs/xfs/xfs_healthmon.c               |  4 +++-
 fs/xfs/xfs_icache.c                  |  2 +-
 fs/xfs/xfs_inode.c                   |  2 +-
 fs/xfs/xfs_log_cil.c                 |  2 +-
 fs/xfs/xfs_log_recover.c             | 13 ++++++++-----
 fs/xfs/xfs_platform.h                |  2 +-
 fs/xfs/xfs_qm.c                      | 10 ++++++++--
 fs/xfs/xfs_refcount_item.c           |  8 ++++++--
 fs/xfs/xfs_reflink.h                 |  3 ---
 fs/xfs/xfs_rmap_item.c               |  8 ++++++--
 fs/xfs/xfs_zone_alloc.c              |  4 ++--
 fs/xfs/xfs_zone_gc.c                 |  2 +-
 42 files changed, 163 insertions(+), 97 deletions(-)
