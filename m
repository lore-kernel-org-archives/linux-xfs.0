Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D96C8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cc1eWoL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2031FC433C8;
	Sun, 31 Dec 2023 19:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051332;
	bh=oHQwMFZ3F3MxpsRTcqftWhwR2aCx/1sDbbdO8KLHFd0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cc1eWoL7nt4ZceNUyqb327JDGM3MX5QaKGnA/mfPcxTvS+VTBoN/Ik7wdlWrSmShB
	 YMOijXGc4SAXlKhhGw43GTjN4Xy9pExh55SXxWKaRK/11C3VX1FhW5pv/V9w9e2SCR
	 t7InV5QKVvKpkvUL5iIvVpIOMdWzhTpA/gmoq9dom/DbZHeDPdqzNL5aFjBP2jTl7i
	 kHXAhI13i1EICd22SrSDca2AJgnuAyIzAyXZKNONiVx50j2DcYZ54qhr5SOuJjhdC6
	 VJoJsQwVHO5eiozY1pVjf3anWpe3Xd8vLJGkTnYWnh1hX10uGOQjVLObiCeQeTpqDR
	 V9TA/sFrByTHg==
Date: Sun, 31 Dec 2023 11:35:31 -0800
Subject: [PATCHSET v2.0 04/15] xfsprogs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile                 |    3 
 fs/xfs/libxfs/xfs_bmap.h        |    5 
 fs/xfs/libxfs/xfs_format.h      |   96 ++++++
 fs/xfs/libxfs/xfs_fs.h          |    9 -
 fs/xfs/libxfs/xfs_fs_staging.h  |   17 +
 fs/xfs/libxfs/xfs_health.h      |   30 ++
 fs/xfs/libxfs/xfs_ondisk.h      |    2 
 fs/xfs/libxfs/xfs_rtbitmap.c    |  143 +++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.h    |   68 ++++-
 fs/xfs/libxfs/xfs_rtgroup.c     |  585 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h     |  252 +++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |  126 ++++++++
 fs/xfs/libxfs/xfs_shared.h      |    4 
 fs/xfs/libxfs/xfs_types.c       |   46 +++
 fs/xfs/libxfs/xfs_types.h       |    4 
 fs/xfs/scrub/common.c           |   88 ++++++
 fs/xfs/scrub/common.h           |   52 ++-
 fs/xfs/scrub/health.c           |   25 ++
 fs/xfs/scrub/repair.h           |    3 
 fs/xfs/scrub/rgsuper.c          |   77 +++++
 fs/xfs/scrub/rgsuper_repair.c   |   48 +++
 fs/xfs/scrub/rtbitmap.c         |  127 ++++++++
 fs/xfs/scrub/rtbitmap.h         |    6 
 fs/xfs/scrub/rtsummary.c        |    7 
 fs/xfs/scrub/rtsummary_repair.c |   15 +
 fs/xfs/scrub/scrub.c            |   27 ++
 fs/xfs/scrub/scrub.h            |   42 +--
 fs/xfs/scrub/stats.c            |    2 
 fs/xfs/scrub/trace.h            |    6 
 fs/xfs/xfs_bmap_item.c          |   18 +
 fs/xfs/xfs_buf_item_recover.c   |   43 +++
 fs/xfs/xfs_fsops.c              |    4 
 fs/xfs/xfs_health.c             |  114 ++++++++
 fs/xfs/xfs_ioctl.c              |   35 ++
 fs/xfs/xfs_log_recover.c        |    6 
 fs/xfs/xfs_mount.c              |   12 +
 fs/xfs/xfs_mount.h              |   11 +
 fs/xfs/xfs_rtalloc.c            |  273 +++++++++++++++++-
 fs/xfs/xfs_rtalloc.h            |    5 
 fs/xfs/xfs_super.c              |   18 +
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   63 ++++
 fs/xfs/xfs_trans.c              |   38 ++-
 fs/xfs/xfs_trans.h              |    2 
 fs/xfs/xfs_trans_buf.c          |   25 +-
 45 files changed, 2460 insertions(+), 123 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h
 create mode 100644 fs/xfs/scrub/rgsuper.c
 create mode 100644 fs/xfs/scrub/rgsuper_repair.c

