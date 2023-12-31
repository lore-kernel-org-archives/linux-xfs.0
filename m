Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A125BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5O3WrPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A40C433C7;
	Sun, 31 Dec 2023 19:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052536;
	bh=ObfvgaViud4u+u2nh9aGiiTjYBJuxSzvB1DoFYho97o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P5O3WrPsfuYphzNaI8EGCJqDC+Rhleqi4sUkllLl+F7yY/I6vLMtgUjQmnBcFnjPP
	 E8/yGJRPxsrzZSNTe2lgodAFU3Zw9Ke+wfw7iO4nETvH/byuLyFDlylUj2JsJhZTD4
	 MVrvvBkerz7CjWtWK18FNRkEUqAL0Q7ShXzK7Y2Lj+MmxcWEFFUl77fMvasJUeQm16
	 GAIi3YpC4GYEwJt7O/LXdlZcZIzrDTL5g8pdH+vONy5otJlfl7DMyE2b9DSrhqFnge
	 QJyPFP2U8YvNOTt7P3XRJ3yzeBf9qi8TFUS1E8mqfFB/S584pRc9wonBHia5nK9Svu
	 vLu25usfK0z9w==
Date: Sun, 31 Dec 2023 11:55:35 -0800
Subject: [PATCHSET v2.0 15/17] xfsprogs: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then widening of the
API parameters; and introduction of the new btree format and inode fork
format.  Next comes enabling CoW and remapping for the rt device; new
scrub, repair, and health reporting code; and at the end we implement
some code to lengthen write requests so that rt extents are always CoWed
fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
 db/bmroot.c                           |  148 ++++++
 db/bmroot.h                           |    2 
 db/btblock.c                          |   53 ++
 db/btblock.h                          |    5 
 db/btdump.c                           |   11 
 db/btheight.c                         |    5 
 db/check.c                            |  326 ++++++++++++-
 db/field.c                            |   15 +
 db/field.h                            |    6 
 db/inode.c                            |   91 ++++
 db/inode.h                            |    2 
 db/metadump.c                         |  129 +++++
 db/type.c                             |    5 
 db/type.h                             |    1 
 include/libxfs.h                      |    1 
 include/xfs_mount.h                   |    9 
 libfrog/scrub.c                       |   10 
 libxfs/Makefile                       |    2 
 libxfs/defer_item.c                   |  101 ++++
 libxfs/init.c                         |   14 -
 libxfs/libxfs_api_defs.h              |   13 +
 libxfs/logitem.c                      |   14 +
 libxfs/xfs_bmap.c                     |   31 +
 libxfs/xfs_btree.c                    |    5 
 libxfs/xfs_btree.h                    |   12 
 libxfs/xfs_defer.h                    |    1 
 libxfs/xfs_format.h                   |   25 +
 libxfs/xfs_fs.h                       |    6 
 libxfs/xfs_fs_staging.h               |    1 
 libxfs/xfs_health.h                   |    4 
 libxfs/xfs_inode_buf.c                |   36 +
 libxfs/xfs_inode_fork.c               |   13 +
 libxfs/xfs_log_format.h               |    6 
 libxfs/xfs_ondisk.h                   |    2 
 libxfs/xfs_refcount.c                 |  341 ++++++++++++--
 libxfs/xfs_refcount.h                 |   29 +
 libxfs/xfs_rmap.c                     |   14 +
 libxfs/xfs_rtgroup.c                  |   10 
 libxfs/xfs_rtgroup.h                  |    8 
 libxfs/xfs_rtrefcount_btree.c         |  803 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h         |  196 ++++++++
 libxfs/xfs_rtrmap_btree.c             |   28 +
 libxfs/xfs_sb.c                       |    8 
 libxfs/xfs_shared.h                   |    2 
 libxfs/xfs_trans_resv.c               |   25 +
 libxfs/xfs_types.h                    |    5 
 logprint/log_misc.c                   |    2 
 logprint/log_print_all.c              |    8 
 logprint/log_redo.c                   |   24 +
 man/man2/ioctl_xfs_rtgroup_geometry.2 |    3 
 man/man2/ioctl_xfs_scrub_metadata.2   |    9 
 man/man8/xfs_db.8                     |   49 ++
 mkfs/proto.c                          |   36 +
 mkfs/xfs_mkfs.c                       |   79 +++
 repair/Makefile                       |    1 
 repair/agbtree.c                      |    4 
 repair/dino_chunks.c                  |   11 
 repair/dinode.c                       |  267 ++++++++++-
 repair/dir2.c                         |    2 
 repair/incore.h                       |    1 
 repair/phase2.c                       |   83 +++
 repair/phase4.c                       |   30 +
 repair/phase5.c                       |    3 
 repair/phase6.c                       |  133 +++++
 repair/rmap.c                         |  353 ++++++++++++---
 repair/rmap.h                         |   19 +
 repair/rtrefcount_repair.c            |  256 +++++++++++
 repair/scan.c                         |  324 +++++++++++++
 repair/scan.h                         |   33 +
 scrub/repair.c                        |    1 
 spaceman/health.c                     |   10 
 71 files changed, 4041 insertions(+), 274 deletions(-)
 create mode 100644 libxfs/xfs_rtrefcount_btree.c
 create mode 100644 libxfs/xfs_rtrefcount_btree.h
 create mode 100644 repair/rtrefcount_repair.c

