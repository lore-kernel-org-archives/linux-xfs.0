Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9455F53BE
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 08:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752740807; cv=none; b=cQ2Y/NIj1PXhcl2svFII0UfaRBAzrpg23r8h/xEuhhbk6npoiFkE4a0BwjMM9UEyadJt/4hbrnIx/e1FY/3C0J3SZV0a2412zCaXhSGrmM7/ZoqaEbJ6OZ2fu8BoTZD042IYboWIEh2tgeiRPPm3dZKioeEAPoiaYfRmIjOKLTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752740807; c=relaxed/simple;
	bh=iBrFhseGtINIomVT6BrnnWTfLwCbKXIcm/a0Hy0tYY8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RIP7sXQ1x9j777BTYD255pK4sGhiHkJYw7SNZetH7ql2EGBpMutmAG6bGIQGKcX41IVJxPUCB4iLAyl3IN2T8M1Kha4YJBGZO4P4vs8PSRqpT7IuPUVS54bAXdAXVIP3BhKBA43mYLxpdHt2EKOm0bHkndrCmu8Bv8uV8RKPEWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csoH3eV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csoH3eV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944A3C4CEE3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 08:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752740807;
	bh=iBrFhseGtINIomVT6BrnnWTfLwCbKXIcm/a0Hy0tYY8=;
	h=Date:From:To:Subject:From;
	b=csoH3eV0eqnRT1RNlSZQ9ekl5wJGHNoXcjYGBh7hbQubekTs3Vh8viKXCBtSSUg1W
	 bHFP7aqfjy8NDl979rxEAwX4FVoRVMTWAwiJnSVX5DWDR+NKSuSTO4gTwY/i7bN1As
	 0nPNx5AHggcNXoa0e+eDeFFckYH+9jScPQsWsUxhUspJbNoa44x0xJmOiazQpLamAM
	 4Sxl0p93rrYDCMB5LLjlIEFXdznf2cF30asajYW/wzrnpWSC7eUcss2OuAAQwaVIP3
	 CN+PrydZpvgja2k97iamLz+Ma50c5TCTVwPdxgqXAZv+Ejz9IF/BfPOj7wvTZuaRnN
	 sLVvthm+SXTlA==
Date: Thu, 17 Jul 2025 10:26:43 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to ef3bdb8107c4
Message-ID: <hxblkucjcpfbypf3blmajeq4jb2mifdc772qkb4gvisam4uv7j@allahj33xd7z>
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

ef3bdb8107c4 Merge branch 'xfs-6.17-merge' into for-next

18 new commits:

Carlos Maiolino (2):
      [43b8ad99827e] Merge branch 'xfs-6.16-fixes' into for-next
      [ef3bdb8107c4] Merge branch 'xfs-6.17-merge' into for-next

Christoph Hellwig (15):
      [8f89c581c0da] xfs: use xfs_trans_reserve_more in xfs_trans_reserve_more_inode
      [e13f9ce5bec1] xfs: don't use xfs_trans_reserve in xfs_trans_reserve_more
      [ddf9708277eb] xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc
      [b4e174c374f6] xfs: don't use xfs_trans_reserve in xfs_trans_roll
      [e967dc40d501] xfs: return the allocated transaction from xfs_trans_alloc_empty
      [149b5cf8c7d2] xfs: return the allocated transaction from xchk_trans_alloc_empty
      [a766ae6fe120] xfs: remove xrep_trans_{alloc,cancel}_hook_dummy
      [d9dbddd143db] xfs: remove the xlog_ticket_t typedef
      [a10f18bc6778] xfs: improve the xg_active_ref check in xfs_group_free
      [48510b0d8522] xfs: don't allocate the xfs_extent_busy structure for zoned RTGs
      [c11330b4ac11] xfs: use a uint32_t to cache i_used_blocks in xfs_init_zone
      [8a034f984dfe] xfs: rename oz_write_pointer to oz_allocated
      [7a779c6867fa] xfs: stop passing an inode to the zone space reservation helpers
      [8196283484ec] xfs: improve the comments in xfs_max_open_zones
      [e381d3e2c80d] xfs: improve the comments in xfs_select_zone_nowait

Pranav Tyagi (1):
      [f161da941891] fs/xfs: replace strncpy with memtostr_pad()

Code Diffstat:

 fs/xfs/libxfs/xfs_format.h   |   2 +-
 fs/xfs/libxfs/xfs_group.c    |  17 ++--
 fs/xfs/libxfs/xfs_refcount.c |   4 +-
 fs/xfs/scrub/common.c        |   7 +-
 fs/xfs/scrub/common.h        |   2 +-
 fs/xfs/scrub/dir_repair.c    |   8 +-
 fs/xfs/scrub/fscounters.c    |   3 +-
 fs/xfs/scrub/metapath.c      |   4 +-
 fs/xfs/scrub/nlinks.c        |   8 +-
 fs/xfs/scrub/nlinks_repair.c |   4 +-
 fs/xfs/scrub/parent_repair.c |  12 +--
 fs/xfs/scrub/quotacheck.c    |   4 +-
 fs/xfs/scrub/repair.c        |  36 --------
 fs/xfs/scrub/repair.h        |   4 -
 fs/xfs/scrub/rmap_repair.c   |  14 +--
 fs/xfs/scrub/rtrmap_repair.c |  14 +--
 fs/xfs/scrub/scrub.c         |   5 +-
 fs/xfs/xfs_attr_item.c       |   5 +-
 fs/xfs/xfs_discard.c         |  12 +--
 fs/xfs/xfs_extent_busy.h     |   8 ++
 fs/xfs/xfs_file.c            |  24 ++---
 fs/xfs/xfs_fsmap.c           |   4 +-
 fs/xfs/xfs_icache.c          |   5 +-
 fs/xfs/xfs_inode.c           |   7 +-
 fs/xfs/xfs_ioctl.c           |   3 +-
 fs/xfs/xfs_iops.c            |   4 +-
 fs/xfs/xfs_itable.c          |  18 +---
 fs/xfs/xfs_iwalk.c           |  11 +--
 fs/xfs/xfs_log.c             |   6 +-
 fs/xfs/xfs_log_priv.h        |   4 +-
 fs/xfs/xfs_notify_failure.c  |   5 +-
 fs/xfs/xfs_qm.c              |  10 +--
 fs/xfs/xfs_rtalloc.c         |  13 +--
 fs/xfs/xfs_trace.h           |   8 +-
 fs/xfs/xfs_trans.c           | 207 ++++++++++++++++++++-----------------------
 fs/xfs/xfs_trans.h           |   3 +-
 fs/xfs/xfs_zone_alloc.c      |  45 +++++-----
 fs/xfs/xfs_zone_alloc.h      |   4 +-
 fs/xfs/xfs_zone_gc.c         |  18 ++--
 fs/xfs/xfs_zone_info.c       |   2 +-
 fs/xfs/xfs_zone_priv.h       |  16 ++--
 fs/xfs/xfs_zone_space_resv.c |  17 ++--
 42 files changed, 233 insertions(+), 374 deletions(-)
