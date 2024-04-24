Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B4413340B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929697; cv=none; b=Xexlo/TVaEaJR/z3iUXBO6cfzuK9+nQ5w+6zNZPwQH0DhKHrFTKT4h560rtRc7BP1xKNlSHOQMsrevCwxUZV+zfcdLtXKkIziT5WnSQ1Au1zsbD9MQj7xW+J7/FVhGYUIMdIOKCZfC3vCRwUQCjMwG+/bUE+lcAJZAkUBkbjBaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929697; c=relaxed/simple;
	bh=I/hDE0wvXKvfg9CKDlO3S7C/S2bXNMviAikDbe3z0kY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=FGr1gaxMUin2X0/g01RQcqe4gYGAi3NvaWaCanFhiXc9dLAAkCdFNbMIcsNR04h+aMFCW+gECqF4NVYRV2TUg58BEoDDsmgeWrys/VwmMTENU/DuVaTYq4o1mDHkEjZYd+wMq/VIe/oR2vco0Qnk3cCv6YHVsGRqUQL9e0z880o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ouK/LhsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ouK/LhsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911CCC116B1;
	Wed, 24 Apr 2024 03:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929697;
	bh=I/hDE0wvXKvfg9CKDlO3S7C/S2bXNMviAikDbe3z0kY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ouK/LhsKqHiZX2DyS8e2u0HMVPLX+/yyZvJBMXyNNl5jJGeLQ/vNBAal2Ur7BZHPt
	 ngu05rmISiWeizTGV+FsbC0+btj+0uu/c9VEJDpHOhR5SsQWgMn7P5lj2iZAScZZkt
	 3zhIUKp2smOvsiKpegGmSYc+N4/q1GyeLRKnJvDZNz23RQcEDpMNyxb4QCpS5OF5gM
	 qx0SO3rAPNyP/eyjTBwjmh97YQH/Vlw3P3FDixSx1VBTUnMFbn/3DdrSfFmthMF9S6
	 HWzNyXoM0NQMXwQ6ThKEFLXxBZGnuXYtJFu6zzoBUiAXfB0ssdnCs4RrX+oZhUyJWP
	 JlEMU4Sg9rfkw==
Date: Tue, 23 Apr 2024 20:34:57 -0700
Subject: [GIT PULL 5/9] xfs: online repair for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392951775.1941278.427384803477410943.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 59a2af9086f0d60fc8de7346da67db7d764c7221:

xfs: check parent pointer xattrs when scrubbing (2024-04-23 07:47:03 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-pptrs-6.10_2024-04-23

for you to fetch changes up to 327ed702d84034879572812f580cb769848af7ae:

xfs: inode repair should ensure there's an attr fork to store parent pointers (2024-04-23 16:55:16 -0700)

----------------------------------------------------------------
xfs: online repair for parent pointers [v13.4 5/9]

This series implements online repair for directory parent pointer
metadata.  The checking half is fairly straightforward -- for each
outgoing directory link (forward or backwards), grab the inode at the
other end, and confirm that there's a corresponding link.  If we can't
grab an inode or lock it, we'll save that link for a slower loop that
cycles all the locks, confirms the continued existence of the link, and
rechecks the link if it's actually still there.

Repairs are a bit more involved -- for directories, we walk the entire
filesystem to rebuild the dirents from parent pointer information.
Parent pointer repairs do the same walk but rebuild the pptrs from the
dirent information, but with the added twist that it duplicates all the
xattrs so that it can use the atomic extent swapping code to commit the
repairs atomically.

This introduces an added twist to the xattr repair code -- we use dirent
hooks to detect a colliding update to the pptr data while we're not
holding the ILOCKs; if one is detected, we restart the xattr salvaging
process but this time hold all the ILOCKs until the end of the scan.

For offline repair, the phase6 directory connectivity scan generates an
index of all the expected parent pointers in the filesystem.  Then it
walks each file and compares the parent pointers attached to that file
against the index generated, and resyncs the results as necessary.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (16):
xfs: remove some boilerplate from xfs_attr_set
xfs: make the reserved block permission flag explicit in xfs_attr_set
xfs: salvage parent pointers when rebuilding xattr structures
xfs: add raw parent pointer apis to support repair
xfs: repair directories by scanning directory parent pointers
xfs: implement live updates for directory repairs
xfs: replay unlocked parent pointer updates that accrue during xattr repair
xfs: repair directory parent pointers by scanning for dirents
xfs: implement live updates for parent pointer repairs
xfs: remove pointless unlocked assertion
xfs: split xfs_bmap_add_attrfork into two pieces
xfs: add a per-leaf block callback to xchk_xattr_walk
xfs: actually rebuild the parent pointer xattrs
xfs: adapt the orphanage code to handle parent pointers
xfs: repair link count of nondirectories after rebuilding parent pointers
xfs: inode repair should ensure there's an attr fork to store parent pointers

fs/xfs/libxfs/xfs_attr.c     |   76 ++-
fs/xfs/libxfs/xfs_attr.h     |    3 +-
fs/xfs/libxfs/xfs_bmap.c     |   38 +-
fs/xfs/libxfs/xfs_bmap.h     |    3 +-
fs/xfs/libxfs/xfs_dir2.c     |    2 +-
fs/xfs/libxfs/xfs_dir2.h     |    2 +-
fs/xfs/libxfs/xfs_parent.c   |   64 +++
fs/xfs/libxfs/xfs_parent.h   |    6 +
fs/xfs/scrub/attr.c          |    2 +-
fs/xfs/scrub/attr_repair.c   |  484 +++++++++++++++-
fs/xfs/scrub/attr_repair.h   |    4 +
fs/xfs/scrub/dir_repair.c    |  567 +++++++++++++++++-
fs/xfs/scrub/findparent.c    |   12 +-
fs/xfs/scrub/findparent.h    |   10 +-
fs/xfs/scrub/inode_repair.c  |   41 ++
fs/xfs/scrub/listxattr.c     |   10 +-
fs/xfs/scrub/listxattr.h     |    4 +-
fs/xfs/scrub/nlinks.c        |    3 +-
fs/xfs/scrub/orphanage.c     |   38 ++
fs/xfs/scrub/orphanage.h     |    3 +
fs/xfs/scrub/parent.c        |    7 +-
fs/xfs/scrub/parent_repair.c | 1307 +++++++++++++++++++++++++++++++++++++++++-
fs/xfs/scrub/scrub.c         |    2 +
fs/xfs/scrub/trace.h         |  153 +++++
fs/xfs/xfs_xattr.c           |   26 +-
25 files changed, 2743 insertions(+), 124 deletions(-)

