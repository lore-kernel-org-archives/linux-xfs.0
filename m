Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF7FB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sN0xfIED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63D7C433C7;
	Sun, 31 Dec 2023 19:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051472;
	bh=hy4zNYuDF73Zbt30+Y3OEb96JMnVcp7qr5XThYe81FA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sN0xfIED7cfpc6rAEDdo+MrVTx+S565WIVGCRT4DSG83iRvd9ivpqEI93OD5BbJyD
	 S4exr53CeowlJkhVb4bAMKMF8gruRkeID400EStWtsXHVgY+oicM05sFm0TkgdoJoV
	 CleAKqWJRMzAj95+gqsvZqAvoQIElxuPoFC3HPbAF21pQ0QNZ6AzUnCaAo91zwNtvb
	 7G1Ii5Ym66k6tCt1S4n+dcFkXcRaCqdbfjDWi6YGWCCIIWYCrx/6xibyTLpwPbm5SP
	 8asRF4I6jIh7eF9gUaQxo3+dLfd9IH7bFptrzPtcUgHZq+CHzH7Iswu/NJPjrhN3WP
	 ZhyjnqXgdbCCA==
Date: Sun, 31 Dec 2023 11:37:52 -0800
Subject: [PATCHSET v2.0 13/15] xfs: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile                      |    3 
 fs/xfs/libxfs/xfs_bmap.c             |   31 +
 fs/xfs/libxfs/xfs_btree.c            |    5 
 fs/xfs/libxfs/xfs_btree.h            |   12 -
 fs/xfs/libxfs/xfs_defer.h            |    1 
 fs/xfs/libxfs/xfs_format.h           |   25 +
 fs/xfs/libxfs/xfs_fs.h               |    6 
 fs/xfs/libxfs/xfs_fs_staging.h       |    1 
 fs/xfs/libxfs/xfs_health.h           |    4 
 fs/xfs/libxfs/xfs_inode_buf.c        |   36 +-
 fs/xfs/libxfs/xfs_inode_fork.c       |   13 +
 fs/xfs/libxfs/xfs_log_format.h       |    6 
 fs/xfs/libxfs/xfs_log_recover.h      |    2 
 fs/xfs/libxfs/xfs_ondisk.h           |    2 
 fs/xfs/libxfs/xfs_refcount.c         |  342 ++++++++++++--
 fs/xfs/libxfs/xfs_refcount.h         |   29 +
 fs/xfs/libxfs/xfs_rmap.c             |   14 +
 fs/xfs/libxfs/xfs_rtgroup.c          |   10 
 fs/xfs/libxfs/xfs_rtgroup.h          |    8 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  805 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |  196 ++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   28 +
 fs/xfs/libxfs/xfs_sb.c               |    8 
 fs/xfs/libxfs/xfs_shared.h           |    2 
 fs/xfs/libxfs/xfs_trans_resv.c       |   25 +
 fs/xfs/libxfs/xfs_types.h            |    5 
 fs/xfs/scrub/bmap.c                  |   31 +
 fs/xfs/scrub/bmap_repair.c           |   26 +
 fs/xfs/scrub/common.c                |   40 +-
 fs/xfs/scrub/common.h                |    5 
 fs/xfs/scrub/cow_repair.c            |  212 ++++++++-
 fs/xfs/scrub/health.c                |    1 
 fs/xfs/scrub/inode.c                 |   32 +
 fs/xfs/scrub/inode_repair.c          |   68 +++
 fs/xfs/scrub/metapath.c              |   14 +
 fs/xfs/scrub/quota.c                 |    8 
 fs/xfs/scrub/quota_repair.c          |    2 
 fs/xfs/scrub/reap.c                  |  227 ++++++++++
 fs/xfs/scrub/reap.h                  |    7 
 fs/xfs/scrub/refcount.c              |    2 
 fs/xfs/scrub/refcount_repair.c       |    4 
 fs/xfs/scrub/repair.c                |   27 +
 fs/xfs/scrub/repair.h                |    9 
 fs/xfs/scrub/rgb_bitmap.h            |   37 ++
 fs/xfs/scrub/rmap_repair.c           |   36 ++
 fs/xfs/scrub/rtb_bitmap.h            |   37 ++
 fs/xfs/scrub/rtbitmap.c              |    2 
 fs/xfs/scrub/rtbitmap_repair.c       |   24 +
 fs/xfs/scrub/rtrefcount.c            |  671 ++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrefcount_repair.c     |  781 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c                |   54 ++
 fs/xfs/scrub/rtrmap_repair.c         |  105 ++++
 fs/xfs/scrub/scrub.c                 |    7 
 fs/xfs/scrub/scrub.h                 |   12 +
 fs/xfs/scrub/stats.c                 |    1 
 fs/xfs/scrub/trace.h                 |  108 +++++
 fs/xfs/xfs_bmap_util.c               |   66 ++-
 fs/xfs/xfs_buf_item_recover.c        |    4 
 fs/xfs/xfs_fsmap.c                   |   22 +
 fs/xfs/xfs_fsops.c                   |    2 
 fs/xfs/xfs_health.c                  |    4 
 fs/xfs/xfs_inode.c                   |   13 +
 fs/xfs/xfs_inode_item.c              |   16 +
 fs/xfs/xfs_inode_item_recover.c      |    5 
 fs/xfs/xfs_ioctl.c                   |   21 +
 fs/xfs/xfs_log_recover.c             |    2 
 fs/xfs/xfs_mount.c                   |    7 
 fs/xfs/xfs_mount.h                   |    9 
 fs/xfs/xfs_quota.h                   |    6 
 fs/xfs/xfs_refcount_item.c           |  260 ++++++++++-
 fs/xfs/xfs_reflink.c                 |  231 ++++++++--
 fs/xfs/xfs_rtalloc.c                 |  141 ++++++
 fs/xfs/xfs_super.c                   |   19 +
 fs/xfs/xfs_trace.c                   |    9 
 fs/xfs/xfs_trace.h                   |  116 +++--
 fs/xfs/xfs_trans_dquot.c             |   11 
 76 files changed, 4843 insertions(+), 330 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h
 create mode 100644 fs/xfs/scrub/rgb_bitmap.h
 create mode 100644 fs/xfs/scrub/rtb_bitmap.h
 create mode 100644 fs/xfs/scrub/rtrefcount.c
 create mode 100644 fs/xfs/scrub/rtrefcount_repair.c

