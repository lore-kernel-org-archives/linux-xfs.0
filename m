Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2831B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7GaZdjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8C2C433C7;
	Sun, 31 Dec 2023 19:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052332;
	bh=ml5ugn+PtCzdkXYjvVQZN6k2rBEPkE83TmDULWtc+f8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k7GaZdjc1Crg7pz9wcvCptkUj4TT/PhGBqstLp4VX/ag2p/ze6vcvLzrfvWuvNLPS
	 UZ4jKNwjnALwWZ2Yk5SHBnbU1++thMbbsgXshFWy4VO/SXUpG/DmSs3vgbBxJxPDiC
	 dZuhmRtSWKKmS3unjpgbhkaAn3BBIAQKpugrgsip3JgYjsdzwN2lMayYgoro5ELtUh
	 BkylT2oxX3AoMvmnqTaKqxzobpJHqet/MMwqhAeYEOkBSEe+SrNV1eJFjKBRaJC+2A
	 bX505YOFjgOLb9odZsN/A/J6CX4hckq/jkWT3u5/ngC57YyuBgp3zVWbdk9vj26HQ+
	 h/alS0nJVQ5DA==
Date: Sun, 31 Dec 2023 11:52:12 -0800
Subject: [PATCHSET v2.0 02/17] xfsprogs: metadata inode directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Add libxfs code from the kernel, then teach xfs_repair and mkfs to
use the metadir functions to find metadata inodes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
 db/check.c                          |   25 +
 db/inode.c                          |    3 
 db/iunlink.c                        |    2 
 db/metadump.c                       |  114 +++-
 db/namei.c                          |   71 ++
 db/sb.c                             |   47 +-
 include/kmem.h                      |    5 
 include/libxfs.h                    |    2 
 include/xfs_inode.h                 |   13 
 include/xfs_mount.h                 |    3 
 include/xfs_trace.h                 |   16 +
 include/xfs_trans.h                 |    3 
 io/bulkstat.c                       |   16 -
 io/scrub.c                          |   62 ++
 libfrog/bulkstat.c                  |    3 
 libfrog/fsgeom.c                    |    4 
 libfrog/scrub.c                     |   34 +
 libfrog/scrub.h                     |    2 
 libxfs/Makefile                     |    4 
 libxfs/imeta_utils.c                |  320 ++++++++++
 libxfs/imeta_utils.h                |   29 +
 libxfs/init.c                       |   47 +-
 libxfs/inode.c                      |  132 ++++
 libxfs/libxfs_api_defs.h            |   27 +
 libxfs/libxfs_priv.h                |    4 
 libxfs/trans.c                      |   33 +
 libxfs/xfs_attr.c                   |    5 
 libxfs/xfs_bmap.c                   |    5 
 libxfs/xfs_format.h                 |   72 ++
 libxfs/xfs_fs.h                     |   29 +
 libxfs/xfs_health.h                 |    6 
 libxfs/xfs_ialloc.c                 |   56 +-
 libxfs/xfs_ialloc.h                 |    2 
 libxfs/xfs_imeta.c                  | 1076 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h                  |  110 ++++
 libxfs/xfs_inode_buf.c              |   73 ++
 libxfs/xfs_inode_buf.h              |    3 
 libxfs/xfs_inode_util.c             |    5 
 libxfs/xfs_ondisk.h                 |    1 
 libxfs/xfs_sb.c                     |   35 +
 libxfs/xfs_trans_resv.c             |  106 +++
 libxfs/xfs_trans_resv.h             |    3 
 libxfs/xfs_types.c                  |    7 
 man/man2/ioctl_xfs_fsgeometry.2     |    3 
 man/man2/ioctl_xfs_scrub_metadata.2 |   38 +
 man/man8/mkfs.xfs.8.in              |   11 
 man/man8/xfs_admin.8                |    8 
 man/man8/xfs_db.8                   |   23 +
 man/man8/xfs_io.8                   |   13 
 man/man8/xfs_protofile.8            |   33 +
 mdrestore/xfs_mdrestore.c           |    6 
 mkfs/Makefile                       |   10 
 mkfs/lts_4.19.conf                  |    1 
 mkfs/lts_5.10.conf                  |    1 
 mkfs/lts_5.15.conf                  |    1 
 mkfs/proto.c                        |  227 +++++--
 mkfs/xfs_mkfs.c                     |   26 +
 mkfs/xfs_protofile.in               |  152 +++++
 repair/agheader.c                   |   19 -
 repair/dino_chunks.c                |   58 ++
 repair/dinode.c                     |  173 +++++-
 repair/dinode.h                     |    6 
 repair/dir2.c                       |  123 +++-
 repair/globals.c                    |    4 
 repair/globals.h                    |    4 
 repair/incore.h                     |   50 +-
 repair/incore_ino.c                 |    1 
 repair/phase1.c                     |    2 
 repair/phase2.c                     |   76 ++
 repair/phase4.c                     |   21 +
 repair/phase5.c                     |    7 
 repair/phase6.c                     |  910 ++++++++++++++++++++++++------
 repair/pptr.c                       |   51 ++
 repair/pptr.h                       |    2 
 repair/protos.h                     |    6 
 repair/quotacheck.c                 |    5 
 repair/sb.c                         |    3 
 repair/scan.c                       |   43 +
 repair/scan.h                       |    7 
 repair/xfs_repair.c                 |   98 +++
 scrub/inodes.c                      |   11 
 scrub/inodes.h                      |    5 
 scrub/phase3.c                      |    7 
 scrub/phase5.c                      |  102 +++
 scrub/phase6.c                      |    2 
 scrub/scrub.c                       |   18 +
 scrub/scrub.h                       |    7 
 spaceman/health.c                   |    2 
 88 files changed, 4531 insertions(+), 460 deletions(-)
 create mode 100644 libxfs/imeta_utils.c
 create mode 100644 libxfs/imeta_utils.h
 create mode 100644 libxfs/xfs_imeta.c
 create mode 100644 libxfs/xfs_imeta.h
 create mode 100644 man/man8/xfs_protofile.8
 create mode 100644 mkfs/xfs_protofile.in

