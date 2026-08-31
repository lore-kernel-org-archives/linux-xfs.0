Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD2537E2E1
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 16:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194866; cv=none; b=qVWR6eiCLKhrEfAG7j8dADNvA2yJgipG6C+IG6GL5fLdVfISACTM0k1WSMHgs1iD0RyaanK7liUr9oVNuPIEzIKiSHJk/sISPMhGMbX10MxrEMFkSli167n4MJN8F9fvfLbjSWIzAuO4RvhOZY8aSmgmsK4VYoqP5q0NpLHBU9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194866; c=relaxed/simple;
	bh=T8hGUGfdrzv9poAqGM8GWsJysGFQ9Ct+w23F+KiQDRU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qnTPWdG6hUGVikxUWYMxWj3S76OGWCFLaAinqWA0vhNUTAdcxT8oit8lCANzr6Ghkqo7AlH1nOpo268B5haSN+Qd3PPEdsLiJ0+jpt1pxpi6hEDzLoNH+GTE+iw8P1nc5dYZWDLDup5y8phqd1gpanKdL9Na9wiQPmdI8O19Jik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTBKHJaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTBKHJaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F19D1F000E9;
	Mon, 31 Aug 2026 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788194865;
	bh=LdDpxGTEakKXWdyY75hoMWQ3YLJCh0JWAOcARD4u6io=;
	h=Date:From:To:Cc:Subject;
	b=jTBKHJafJNBz/F8Pnb6Xaj2KZrktJZWvMyH05gVSgShS5HicJj/eqcUZx7RtjGuBQ
	 Eu0QFRx52MxASDxQB03D/5iSJDoG8NkGs376Q6CumiZOZUXGb34AV9TT87NsMmmnkB
	 HaB+338OJFhWaIc86quFavhcITNW189yWpJN/U90oko/QNtCQhiquGLIvZOUVLi86U
	 YMkNUUVoNvBJlnX4C6df7CdpjKUBQCRKtQhj2RgYNvSwNlcg3YAoDzce2877CRpRZm
	 vEiYsBjsk+JikJ085EdgVlexxf78rLpTdNkS2pnC5kdVsTa2QYfrGozoqyO/NIX31D
	 FPKYsGR81G7QQ==
Date: Mon, 31 Aug 2026 18:47:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL V2] XFS: Fixes for v7.3-rc2
Message-ID: <apWqc-udmF9dLhy8@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

This is a V2 of my previous pull request with proper details,
if you haven't worked through the previous one yet, please use
this one. There is nothing different on the tag itself, just
more information below.

An attempt merge against your current TOT has been successful.

This pull request contains a few fixes for the zoned storage support,
a possible deadlock vector fix, some code refactoring patches and a
quota evasion fix on XFS while exporting it via NFS.

Please note that for the quota evasion fix, a couple patches for the
capability subsystem are included in the pull request. Those have been
ack'ed by the respective maintainer which also agreed to have them going
through the xfs tree.
This also includes a patch for the quota subsystem to stop issuing audit
messages during quota enforcing. Quota maintainer also ack'ed and agreed
with this going through xfs tree.

Thanks,
Carlos

"The following changes since commit 818bebeb63dd6bf5f4e07e145f6cdbace520a34c:

  drm/xe: Don't hand out the flat CCS storage as usable VRAM (2026-08-20 20:12:39 -0700)

are available in the Git repository at:

  gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.3-rc2

for you to fetch changes up to 412f89fb3988a344175899776c8bc7073524ad84:

  capability: unexport has_capability_noaudit (2026-08-21 09:09:55 +0200)

----------------------------------------------------------------
xfs: fixes for 7.3-rc2

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Carlos Maiolino (5):
      xfs: fix capability check in xfs
      capability: Add new capable_noaudit
      quota: Don't issue audit messages on quota enforcing
      xfs: replace ns_capable_noaudit
      capability: unexport has_capability_noaudit

Christoph Hellwig (9):
      xfs: split an assert in xfs_trans_log_buf
      xfs: don't flush and invalidate internal RT device twice in xfs_shutdown_devices
      xfs: use inode_init_always_gfp with __GFP_NOFAIL in xfs_inode_alloc
      xfs: handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones
      xfs: fix racy open zone caching
      xfs: fix zoned write iomap flags assignments
      xfs: factor out a xfs_iomap_set_anon_write helper
      xfs: split ioend handling into a separate source file
      xfs: restore bi_bdev in xfs_zone_gc_write_chunk

Tal Zussman (1):
      xfs: remove kmem_to_page()

Yun Zhou (1):
      xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf

 fs/quota/dquot.c            |   2 +-
 fs/xfs/Makefile             |   1 +
 fs/xfs/libxfs/xfs_rtgroup.h |   6 +-
 fs/xfs/libxfs/xfs_sb.c      |  37 ++++-----
 fs/xfs/xfs_aops.c           | 188 +-------------------------------------------
 fs/xfs/xfs_aops.h           |   1 -
 fs/xfs/xfs_file.c           |   2 +-
 fs/xfs/xfs_fsmap.c          |   3 +-
 fs/xfs/xfs_icache.c         |  16 ++--
 fs/xfs/xfs_ioctl.c          |   2 +-
 fs/xfs/xfs_ioend.c          | 184 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioend.h          |  16 ++++
 fs/xfs/xfs_iomap.c          |   7 +-
 fs/xfs/xfs_iomap.h          |  14 ++++
 fs/xfs/xfs_iops.c           |   2 +-
 fs/xfs/xfs_platform.h       |  11 ---
 fs/xfs/xfs_super.c          |   2 +-
 fs/xfs/xfs_trans_buf.c      |   3 +-
 fs/xfs/xfs_zone_alloc.c     |  66 +++++++++++++---
 fs/xfs/xfs_zone_gc.c        |   5 ++
 include/linux/capability.h  |   5 ++
 kernel/capability.c         |  19 ++++-
 22 files changed, 336 insertions(+), 256 deletions(-)
 create mode 100644 fs/xfs/xfs_ioend.c
 create mode 100644 fs/xfs/xfs_ioend.h"
