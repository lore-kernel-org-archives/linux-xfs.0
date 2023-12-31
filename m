Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4FDB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKgbIL9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6242EC433C7;
	Sun, 31 Dec 2023 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052395;
	bh=rZe1zwEjqfTmiN4zDEIgF4SJ6WG9GVt7tdQLVZpVsyY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iKgbIL9CkoZslob5O3607cGTH4pUphnJ879bGwscqEXzzYLGOIDt1efCB6edpTkTA
	 AIYQb6iSy415OvSy60cKo/xVQVWniaeoU3k6blvWTBLMhQ9WbhcqgENsoXVsUNk4ml
	 +tWyxCGHiB8B2XVw5IYozq+opAevLlv3NsTTi44T7s6dRUbHYXR8WlqqwvnTFaOt7G
	 FMkS2pXQDuY9+dx0VwYqWC0IesHm7tpOeVA8buK2R2ZYnxcWVE/2De0IfhWvAiGGR3
	 hd2uI9ZZUMOzoZs2FJ2AHN6livHeK/PE85e4TcSktVKUqMDLvVzOHSQTmpD1NG0s2l
	 O9I0InetFwPwQ==
Date: Sun, 31 Dec 2023 11:53:14 -0800
Subject: [PATCHSET v2.0 06/17] xfsprogs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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
these files.  It would be very useful if we could begin to tackle these
problems by sharding the realtime section, so create the notion of
realtime groups, which are similar to allocation groups on the data
section.

While we're at it, define a superblock to be stamped into the start of
each rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and helpfully avoids the situation
where a file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

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
 db/Makefile                           |    2 
 db/bit.c                              |   24 +
 db/bit.h                              |    1 
 db/check.c                            |   65 +++-
 db/command.c                          |    2 
 db/convert.c                          |   46 ++-
 db/field.c                            |   18 +
 db/field.h                            |   11 +
 db/fprint.c                           |   11 +
 db/inode.c                            |    9 -
 db/metadump.c                         |   61 +++
 db/rtgroup.c                          |  169 ++++++++++
 db/rtgroup.h                          |   21 +
 db/sb.c                               |  136 +++++++-
 db/type.c                             |   16 +
 db/type.h                             |   32 ++
 db/xfs_metadump.sh                    |    5 
 include/libxfs.h                      |    2 
 include/xfs_arch.h                    |    6 
 include/xfs_metadump.h                |    8 
 include/xfs_mount.h                   |   13 +
 include/xfs_trace.h                   |    7 
 include/xfs_trans.h                   |    1 
 io/Makefile                           |    2 
 io/aginfo.c                           |  215 ++++++++++++
 io/bmap.c                             |   30 +-
 io/fsmap.c                            |   23 +
 io/init.c                             |    1 
 io/io.h                               |    1 
 io/scrub.c                            |   40 ++
 libfrog/div64.h                       |    6 
 libfrog/fsgeom.c                      |   24 +
 libfrog/fsgeom.h                      |    4 
 libfrog/scrub.c                       |   10 +
 libfrog/scrub.h                       |    1 
 libfrog/util.c                        |   26 +
 libfrog/util.h                        |    3 
 libxfs/Makefile                       |    2 
 libxfs/defer_item.c                   |   17 +
 libxfs/init.c                         |   68 ++++
 libxfs/libxfs_api_defs.h              |    6 
 libxfs/libxfs_io.h                    |    1 
 libxfs/libxfs_priv.h                  |   25 +
 libxfs/rdwr.c                         |   17 +
 libxfs/topology.c                     |   42 ++
 libxfs/topology.h                     |    3 
 libxfs/trans.c                        |   29 ++
 libxfs/util.c                         |    7 
 libxfs/xfs_bmap.h                     |    5 
 libxfs/xfs_format.h                   |   96 +++++
 libxfs/xfs_fs.h                       |    9 -
 libxfs/xfs_fs_staging.h               |   17 +
 libxfs/xfs_health.h                   |   30 ++
 libxfs/xfs_ondisk.h                   |    2 
 libxfs/xfs_rtbitmap.c                 |  141 +++++++-
 libxfs/xfs_rtbitmap.h                 |   68 ++++
 libxfs/xfs_rtgroup.c                  |  582 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h                  |  252 ++++++++++++++
 libxfs/xfs_sb.c                       |  126 +++++++
 libxfs/xfs_shared.h                   |    4 
 libxfs/xfs_types.c                    |   46 ++-
 libxfs/xfs_types.h                    |    4 
 man/man2/ioctl_xfs_rtgroup_geometry.2 |   99 ++++++
 man/man2/ioctl_xfs_scrub_metadata.2   |   21 +
 man/man8/mkfs.xfs.8.in                |   44 ++
 man/man8/xfs_admin.8                  |    9 +
 man/man8/xfs_db.8                     |   17 +
 man/man8/xfs_io.8                     |   29 ++
 man/man8/xfs_mdrestore.8              |   10 +
 man/man8/xfs_metadump.8               |   11 +
 man/man8/xfs_spaceman.8               |    5 
 mdrestore/xfs_mdrestore.c             |   53 ++-
 mkfs/proto.c                          |  107 ++++++
 mkfs/xfs_mkfs.c                       |  281 ++++++++++++++++
 repair/agheader.c                     |    2 
 repair/globals.c                      |    1 
 repair/globals.h                      |    1 
 repair/incore.c                       |   22 +
 repair/phase2.c                       |   42 ++
 repair/phase3.c                       |    3 
 repair/phase6.c                       |   37 ++
 repair/rt.c                           |  186 ++++++++++-
 repair/rt.h                           |    3 
 repair/sb.c                           |   49 +++
 repair/xfs_repair.c                   |   22 +
 scrub/phase2.c                        |  100 ++++++
 scrub/phase7.c                        |    7 
 scrub/phase8.c                        |   36 ++
 scrub/repair.c                        |    1 
 scrub/scrub.c                         |    3 
 scrub/scrub.h                         |    9 +
 scrub/spacemap.c                      |   74 ++++
 scrub/xfs_scrub.c                     |    2 
 scrub/xfs_scrub.h                     |    1 
 spaceman/health.c                     |   59 +++
 95 files changed, 3840 insertions(+), 157 deletions(-)
 create mode 100644 db/rtgroup.c
 create mode 100644 db/rtgroup.h
 create mode 100644 io/aginfo.c
 create mode 100644 libxfs/xfs_rtgroup.c
 create mode 100644 libxfs/xfs_rtgroup.h
 create mode 100644 man/man2/ioctl_xfs_rtgroup_geometry.2

