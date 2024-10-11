Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CCE1FC8
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606983; cv=none; b=GecIDVj46kKpob027FA84GI96nIZ522BPEdKjYESwxRwnTX5xEC3kfCl1WY2uNZwnHuAt2AMFsMIEeJv8QLAokLA7Z+Eq9c+M34ijsdt8D+KsIsevNSIPvk+hAuhN3d12Tf7JdB34l06X76+mDuKgBkF+WC0NHFZbhUApspOVUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606983; c=relaxed/simple;
	bh=omcmTK40+5vOrcBSbQiqqFrrNJLxvGJNaSEpc1Wwb6g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JdipVmEwk/lMjjvqzRKok5DoEKz73XiDMevbVtXSmCALzZJMvYXRapk5IzoBs75fKV9fKuECe4Xnv3gO302EIS5R51Vgm5UEWB7suL/iImv+T0YdWf0k1UdXowWyoboRObZ9WIZU9BbPpSpMsxPxz6s4sp/C3EKtV9MbjK1v2qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3OMgE+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3OMgE+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E467C4CEC5;
	Fri, 11 Oct 2024 00:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606983;
	bh=omcmTK40+5vOrcBSbQiqqFrrNJLxvGJNaSEpc1Wwb6g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d3OMgE+1CjGTBFWVLyXyX/YGlpcMA+sdTrBZWt3x3Z0Bt/IYoLRyJksspsaFjxx6W
	 NMcYO65yYdcvKznzeGYGQNokxfLBIZQAhcv1htI0M5t0ly+mv5iSpC3CYrKQUrnR9+
	 fy+KWbxqzCG2z/Bk1K+EkQcRJc5agCefgQlLpd3QzGzKj3W941w7AB6rBdnbUCDqpq
	 mV2ceJI4oLe/Zn2/0kOqMrOdfryaNdfkAW0qBp8DIQRjEj0B58ysp4Yjjq8kLl3yHL
	 cqqOWDhsbytojc6AxjGsbzqKl6dPDdqxswglOPTCvamH851NwW4aFEzBk9UMtv1Y0D
	 5viUuYUM+exRg==
Date: Thu, 10 Oct 2024 17:36:23 -0700
Subject: [PATCHSET v5.0 3/5] xfsprogs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Right now, the realtime section uses a single pair of metadata inodes to
store the free space information.  This presents a scalability problem
since every thread trying to allocate or free rt extents have to lock
these files.  Solve this problem by sharding the realtime section into
separate realtime allocation groups.

While we're at it, define a superblock to be stamped into the start of
the rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and avoids the situation where
anything written into block 0 of the realtime extent can be
misinterpreted as file data.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

This is a very large patchset, but it catches us up with 20 years of
technical debt that have accumulated.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-groups

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-groups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups
---
Commits in this patchset:
 * man: document the rt group geometry ioctl
 * libxfs: port userspace deferred log item to handle rtgroups
 * libxfs: implement some sanity checking for enormous rgcount
 * libfrog: support scrubbing rtgroup metadata paths
 * libfrog: report rt groups in output
 * libfrog: add bitmap_clear
 * xfs_logprint: report realtime EFIs
 * xfs_repair: adjust rtbitmap/rtsummary word updates to handle big endian values
 * xfs_repair: refactor phase4
 * xfs_repair: refactor offsetof+sizeof to offsetofend
 * xfs_repair: improve rtbitmap discrepancy reporting
 * xfs_repair: simplify rt_lock handling
 * xfs_repair: add a real per-AG bitmap abstraction
 * xfs_repair: support realtime groups
 * repair: use a separate bmaps array for real time groups
 * xfs_repair: find and clobber rtgroup bitmap and summary files
 * xfs_repair: support realtime superblocks
 * xfs_repair: repair rtbitmap and rtsummary block headers
 * xfs_repair: stop tracking duplicate RT extents with rtgroups
 * xfs_db: listify the definition of enum typnm
 * xfs_db: support dumping realtime group data and superblocks
 * xfs_db: support changing the label and uuid of rt superblocks
 * xfs_db: enable conversion of rt space units
 * xfs_db: metadump metadir rt bitmap and summary files
 * xfs_db: metadump realtime devices
 * xfs_db: dump rt bitmap blocks
 * xfs_db: dump rt summary blocks
 * xfs_db: report rt group and block number in the bmap command
 * xfs_mdrestore: restore rt group superblocks to realtime device
 * xfs_io: support scrubbing rtgroup metadata
 * xfs_io: support scrubbing rtgroup metadata paths
 * xfs_io: add a command to display allocation group information
 * xfs_io: add a command to display realtime group information
 * xfs_io: display rt group in verbose bmap output
 * xfs_io: display rt group in verbose fsmap output
 * xfs_spaceman: report on realtime group health
 * xfs_scrub: scrub realtime allocation group metadata
 * xfs_scrub: check rtgroup metadata directory connections
 * xfs_scrub: call GETFSMAP for each rt group in parallel
 * xfs_scrub: trim realtime volumes too
 * xfs_scrub: use histograms to speed up phase 8 on the realtime volume
 * mkfs: add headers to realtime bitmap blocks
 * mkfs: format realtime groups
---
 db/Makefile                           |    1 
 db/bmap.c                             |   56 +++-
 db/command.c                          |    2 
 db/convert.c                          |   60 ++++
 db/field.c                            |   20 +
 db/field.h                            |   10 +
 db/inode.c                            |   36 ++
 db/metadump.c                         |   58 ++++
 db/rtgroup.c                          |  154 ++++++++++
 db/rtgroup.h                          |   21 +
 db/sb.c                               |  117 +++++++-
 db/type.c                             |   16 +
 db/type.h                             |   32 ++
 db/xfs_metadump.sh                    |    5 
 include/xfs.h                         |   15 +
 include/xfs_metadump.h                |    8 +
 io/Makefile                           |    1 
 io/aginfo.c                           |  216 ++++++++++++++
 io/bmap.c                             |   27 +-
 io/fsmap.c                            |   22 +
 io/init.c                             |    1 
 io/io.h                               |    1 
 io/scrub.c                            |   81 +++++
 libfrog/bitmap.c                      |   25 +-
 libfrog/bitmap.h                      |    1 
 libfrog/div64.h                       |    6 
 libfrog/fsgeom.c                      |   24 +-
 libfrog/fsgeom.h                      |   16 +
 libfrog/scrub.c                       |   19 +
 libfrog/util.c                        |   12 +
 libfrog/util.h                        |    1 
 libxfs/defer_item.c                   |   73 +++--
 libxfs/init.c                         |   46 +++
 libxfs/libxfs_api_defs.h              |    5 
 libxfs/libxfs_priv.h                  |    6 
 libxfs/topology.c                     |   42 +++
 libxfs/topology.h                     |    3 
 logprint/log_misc.c                   |    2 
 logprint/log_print_all.c              |    8 +
 logprint/log_redo.c                   |   57 +++-
 man/man2/ioctl_xfs_rtgroup_geometry.2 |  103 +++++++
 man/man8/mkfs.xfs.8.in                |   31 ++
 man/man8/xfs_db.8                     |   17 +
 man/man8/xfs_io.8                     |   29 ++
 man/man8/xfs_mdrestore.8              |   10 +
 man/man8/xfs_metadump.8               |   11 +
 man/man8/xfs_spaceman.8               |    5 
 mdrestore/xfs_mdrestore.c             |   59 +++-
 mkfs/proto.c                          |   88 +++++-
 mkfs/xfs_mkfs.c                       |  282 ++++++++++++++++++
 repair/agheader.c                     |   21 -
 repair/dino_chunks.c                  |   58 +++-
 repair/dinode.c                       |  162 +++++++----
 repair/dir2.c                         |   13 +
 repair/globals.c                      |    3 
 repair/globals.h                      |    6 
 repair/incore.c                       |  235 +++++++++++----
 repair/incore.h                       |   36 ++
 repair/incore_ext.c                   |    3 
 repair/phase2.c                       |   51 ++-
 repair/phase3.c                       |    4 
 repair/phase4.c                       |  221 ++++++++------
 repair/phase5.c                       |    2 
 repair/phase6.c                       |  175 +++++++++++
 repair/rmap.c                         |    4 
 repair/rt.c                           |  506 +++++++++++++++++++++++++++++----
 repair/rt.h                           |   23 ++
 repair/sb.c                           |   36 ++
 repair/scan.c                         |   36 +-
 repair/xfs_repair.c                   |   19 +
 scrub/phase2.c                        |  124 ++++++--
 scrub/phase5.c                        |   24 +-
 scrub/phase7.c                        |    7 
 scrub/phase8.c                        |   36 ++
 scrub/scrub.c                         |    1 
 scrub/scrub.h                         |   13 +
 scrub/spacemap.c                      |   72 ++++-
 scrub/xfs_scrub.c                     |    2 
 scrub/xfs_scrub.h                     |    1 
 spaceman/health.c                     |   63 ++++
 80 files changed, 3329 insertions(+), 569 deletions(-)
 create mode 100644 db/rtgroup.c
 create mode 100644 db/rtgroup.h
 create mode 100644 io/aginfo.c
 create mode 100644 man/man2/ioctl_xfs_rtgroup_geometry.2

