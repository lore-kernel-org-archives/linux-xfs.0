Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4E21A840A
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 09:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776071472; cv=none; b=l21OgQNkoYL5c0Ewr/mpQe4QpAwB72QhY22P2leSQvdGoSRDRbePUDREqUwgdJKNH/Vrlo7+pTCMFlmNeiktafO7HXhslqj0LKOrGaZlyE+LgHDeyjv1oSzO8oqKduQuDrpKaEpZ16bgrEv+582eSqV/HnRtUJI9UiEMkiCIiUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776071472; c=relaxed/simple;
	bh=BBl6bcUZZSO/cZyaXpsdItjxV+PHIp6zxCFIojLy0zY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=b+vSv5B0CIv0FODez32JRtxd+HgpGjpX9j/2KrZ9yB3UrpXv8SyR+A4ZYSK0B1teDQFigzfnq+WLs7qQ306gvRtAZ3UDTXqYrDNDjiqXz5Q6YPMdyMRMYyKKmE6Wyoesvl7LCOpik4mS2ZKIFJ6mksNiLINVWvZPkc4/3DMbbKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2tV9/hF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2tV9/hF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF515C116C6;
	Mon, 13 Apr 2026 09:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776071471;
	bh=BBl6bcUZZSO/cZyaXpsdItjxV+PHIp6zxCFIojLy0zY=;
	h=Date:From:To:Cc:Subject:From;
	b=r2tV9/hFtk7howMfPC2Ast5HMPEu9HOvUqdYLHRFJ0UXbUEQQX4mQ+EEVbqncXnS6
	 8sQ3LFDIsnB4TTkWkfFTksn1gUlLuZwoMrJVTLufiDEewA5A6FJraYazaFOSXp8Nvk
	 zsc2+TUAUZP/+tYEfVwLuKRcm3yNAn/X/JEvj1/E2JT8EVMv/MpsvKK0+FUlEC8sQk
	 j2XxZq9h7I3R1HX8ZFibEnkJ+4t2imiL5cqZPv4yG3iYZpU+c7tbDoLa8YYkEy3Faz
	 ba7vARwE1SI6PAOXLuET9U0V+MWeRcJK8lJ0RvT7vTOvh/yUF0vz1VjsPzC9pEYMrn
	 z/o0A2FV4ooKw==
Date: Mon, 13 Apr 2026 11:11:08 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: New code for v7.1
Message-ID: <adypWanwxWF6j9Z1@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

Although those are targeting 7.1 merge window, there ain't any new
features. The whole series is just a collection of bug fixes and code
refactoring. There is some new information added a couple new
tracepoints, new data added to mountstats, but no big changes.

I'd just like to point out there is an iomap patch in this series, which
I agreed with Bruner this would be going through xfs tree as the changes
are tight together with xfs modifications.

Thanks,
Carlos

"The following changes since commit e31c53a8060e134111ed095783fee0aa0c43b080:

  xfs: remove file_path tracepoint data (2026-03-26 14:25:23 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.1

for you to fetch changes up to 2ffc6900d5c3a7cd59becda2aa67581d9bd3858e:

  xfs: fix number of GC bvecs (2026-04-07 13:33:11 +0200)

----------------------------------------------------------------
xfs: new code for Linux 7.1

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Brian Foster (8):
      xfs: fix iomap hole map reporting for zoned zero range
      xfs: flush dirty pagecache over hole in zoned mode zero range
      iomap, xfs: lift zero range hole mapping flush into xfs
      xfs: flush eof folio before insert range size update
      xfs: look up cow fork extent earlier for buffered iomap_begin
      xfs: only flush when COW fork blocks overlap data fork holes
      xfs: replace zero range flush with folio batch
      xfs: report cow mappings with dirty pagecache for iomap zero range

Carlos Maiolino (8):
      xfs: factor out isize updates from xfs_dio_write_end_io
      xfs: factor out xfs_dio_write_zoned_end_io
      xfs: factor out xfs_zone_inc_written
      xfs: opencode xfs_zone_record_blocks
      Merge branch 'xfs-7.1-merge' into for-next
      Merge branch 'xfs-7.0-fixes' into for-next
      Merge branch 'xfs-7.1-merge' into for-next
      Merge branch 'xfs-7.0-fixes' into for-next

Christoph Hellwig (18):
      xfs: don't keep a reference for buffers on the LRU
      xfs: use a lockref for the buffer reference count
      xfs: switch (back) to a per-buftarg buffer hash
      xfs: don't decrement the buffer LRU count for in-use buffers
      xfs: remove a duplicate assert in xfs_setattr_size
      xfs: fold xfs_setattr_size into xfs_vn_setattr_size
      xfs: refactor xfs_mount_zones
      xfs: handle too many open zones when mounting
      xfs: delay initial open of the GC zone
      xfs: add a separate tracepoint for stealing an open zone for GC
      xfs: put the open zone later xfs_open_zone_put
      xfs: rename xfs_zone_gc_iter_next to xfs_zone_gc_iter_irec
      xfs: refactor GC zone selection helpers
      xfs: streamline GC zone selection
      xfs: reduce special casing for the open GC zone
      xfs: expose the number of open zones in sysfs
      xfs: untangle the open zones reporting in mountinfo
      xfs: fix number of GC bvecs

Damien Le Moal (4):
      xfs: avoid unnecessary open zone check in xfs_select_zone_nowait()
      xfs: fix a comment typo in xfs_select_zone_nowait()
      xfs: display more zone related information in mountstats
      xfs: avoid unnecessary calculations in xfs_zoned_need_gc()

Hans Holmberg (1):
      xfs: start gc on zonegc_low_space attribute updates

Haoxiang Li (1):
      xfs: fix a resource leak in xfs_alloc_buftarg()

Lukas Herbolt (1):
      xfs: Use xarray to track SB UUIDs instead of plain array.

Ravi Singh (1):
      xfs: return default quota limits for IDs without a dquot

Wilfred Mallawa (1):
      xfs: add write pointer to xfs_rtgroup_geometry

Yuto Ohnuki (2):
      xfs: fix integer overflow in deferred intent sort comparators
      xfs: fix integer overflow in busy extent sort comparator

 Documentation/admin-guide/xfs.rst |   4 +
 fs/iomap/buffered-io.c            |   6 +-
 fs/xfs/libxfs/xfs_ag.c            |  13 +-
 fs/xfs/libxfs/xfs_ag.h            |   2 -
 fs/xfs/libxfs/xfs_fs.h            |   5 +-
 fs/xfs/xfs_buf.c                  | 236 +++++++++++--------------------
 fs/xfs/xfs_buf.h                  |  20 +--
 fs/xfs/xfs_buf_mem.c              |  11 +-
 fs/xfs/xfs_extent_busy.c          |   4 +-
 fs/xfs/xfs_extfree_item.c         |   2 +-
 fs/xfs/xfs_file.c                 | 112 +++++++++++----
 fs/xfs/xfs_ioctl.c                |  19 +++
 fs/xfs/xfs_iomap.c                | 146 ++++++++++++++-----
 fs/xfs/xfs_iops.c                 |  39 ++---
 fs/xfs/xfs_mount.c                |  75 +++++-----
 fs/xfs/xfs_mount.h                |   3 +
 fs/xfs/xfs_qm_syscalls.c          |  43 +++++-
 fs/xfs/xfs_refcount_item.c        |   2 +-
 fs/xfs/xfs_rmap_item.c            |   2 +-
 fs/xfs/xfs_sysfs.c                |  20 ++-
 fs/xfs/xfs_trace.h                |  12 +-
 fs/xfs/xfs_zone_alloc.c           | 194 ++++++++++++++++++-------
 fs/xfs/xfs_zone_alloc.h           |   4 +
 fs/xfs/xfs_zone_gc.c              | 290 ++++++++++++++++++++------------------
 fs/xfs/xfs_zone_info.c            |  23 +--
 fs/xfs/xfs_zone_priv.h            |  15 +-
 26 files changed, 754 insertions(+), 548 deletions(-)"
