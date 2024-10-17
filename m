Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E326D216A11;
	Thu, 17 Oct 2024 18:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190807; cv=none; b=FBjvSKTx/a14X0fooO5zGMoHdwLNGZCFaPSungf6zZQB1+jqOTw5KTBGSuw9JZ1B9XKlMZauRFLnUgjc0P2QVS5aBeQWm9Km5TnLcJMPYjiyY2C7YDmqV4zJSIOlU06/1VraQ4zBBRsPGvjOmImZZ1yY6md+U64bo625FcbKR7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190807; c=relaxed/simple;
	bh=aAHhJYYkCr39H6W4p52AUYa9rY6tExa8dCWnMZsuckU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1HHdKUlFBd92KLq8gU9knAr2vzpBuaH680q4jCRhQZkB58dkwuWufmI/6y50dQAhfIoJ5INb9GDDKGXuqJkQ7HDwlJd3Sbft6qraNV9OpNWO0Rp0Q+VkasdGvgoCZeQL5IV8by2BEY48GW/+jqvrdJnhDiU6IG7v28TWqCd2uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZTGMBap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZTGMBap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6BDC4CEC3;
	Thu, 17 Oct 2024 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190805;
	bh=aAHhJYYkCr39H6W4p52AUYa9rY6tExa8dCWnMZsuckU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iZTGMBaptI1XkEGdLvD1awXISqDeub0Bpvt8nnP87B+aEwmsEw8GidUh+c5N4YvWK
	 oOeyP6nQvCXNxZywWvhgt2tzMHbEz+vjFH6LWhoPX3jMgiH8N7TjswVxI8I0xk811b
	 N8ws18BJ5BcS/gzFegVxr8bMtYevXyjxs0ukLT3rOjkJa2CT7RQSNn5GiPOJzLqx9W
	 r0rDLYblmOZPTihAgrbsVX2HUQELffU2I0hEwH55lSCpCjbRbddE01mPgUT0mqsDbB
	 QuOTWV+r4nJM+OwIusRQH2UAISXqO8JbRkeRW5ZlV1DhSzdqSf8jUxLDL2uX/lfQe8
	 Y/TQ1qPEqVMNw==
Date: Thu, 17 Oct 2024 11:46:45 -0700
Subject: [PATCHSET v5.1 3/9] xfs: metadata inode directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
In-Reply-To: <20241017184009.GV21853@frogsfrogsfrogs>
References: <20241017184009.GV21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series delivers a new feature -- metadata inode directories.  This
is a separate directory tree (rooted in the superblock) that contains
only inodes that contain filesystem metadata.  Different metadata
objects can be looked up with regular paths.

Start by creating xfs_imeta{dir,file}* functions to mediate access to
the metadata directory tree.  By the end of this mega series, all
existing metadata inodes (rt+quota) will use this directory tree instead
of the superblock.

Next, define the metadir on-disk format, which consists of marking
inodes with a new iflag that says they're metadata.  This prevents
bulkstat and friends from ever getting their hands on fs metadata files.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadata-directory-tree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadata-directory-tree
---
Commits in this patchset:
 * xfs: constify the xfs_sb predicates
 * xfs: constify the xfs_inode predicates
 * xfs: rename metadata inode predicates
 * xfs: standardize EXPERIMENTAL warning generation
 * xfs: define the on-disk format for the metadir feature
 * xfs: iget for metadata inodes
 * xfs: load metadata directory root at mount time
 * xfs: enforce metadata inode flag
 * xfs: read and write metadata inode directory tree
 * xfs: disable the agi rotor for metadata inodes
 * xfs: hide metadata inodes from everyone because they are special
 * xfs: advertise metadata directory feature
 * xfs: allow bulkstat to return metadata directories
 * xfs: don't count metadata directory files to quota
 * xfs: mark quota inodes as metadata files
 * xfs: adjust xfs_bmap_add_attrfork for metadir
 * xfs: record health problems with the metadata directory
 * xfs: refactor directory tree root predicates
 * xfs: do not count metadata directory files when doing online quotacheck
 * xfs: don't fail repairs on metadata files with no attr fork
 * xfs: metadata files can have xattrs if metadir is enabled
 * xfs: adjust parent pointer scrubber for sb-rooted metadata files
 * xfs: fix di_metatype field of inodes that won't load
 * xfs: scrub metadata directories
 * xfs: check the metadata directory inumber in superblocks
 * xfs: move repair temporary files to the metadata directory tree
 * xfs: check metadata directory file path connectivity
 * xfs: confirm dotdot target before replacing it during a repair
 * xfs: repair metadata directory file path connectivity
---
 fs/xfs/Makefile                 |    5 
 fs/xfs/libxfs/xfs_attr.c        |    5 
 fs/xfs/libxfs/xfs_bmap.c        |    5 
 fs/xfs/libxfs/xfs_format.h      |  121 +++++++--
 fs/xfs/libxfs/xfs_fs.h          |   25 ++
 fs/xfs/libxfs/xfs_health.h      |    6 
 fs/xfs/libxfs/xfs_ialloc.c      |   58 +++-
 fs/xfs/libxfs/xfs_inode_buf.c   |   90 ++++++-
 fs/xfs/libxfs/xfs_inode_buf.h   |    3 
 fs/xfs/libxfs/xfs_inode_util.c  |    2 
 fs/xfs/libxfs/xfs_log_format.h  |    2 
 fs/xfs/libxfs/xfs_metadir.c     |  481 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_metadir.h     |   47 ++++
 fs/xfs/libxfs/xfs_metafile.c    |   52 ++++
 fs/xfs/libxfs/xfs_metafile.h    |   31 ++
 fs/xfs/libxfs/xfs_ondisk.h      |    2 
 fs/xfs/libxfs/xfs_sb.c          |   12 +
 fs/xfs/libxfs/xfs_types.c       |    4 
 fs/xfs/libxfs/xfs_types.h       |    2 
 fs/xfs/scrub/agheader.c         |    5 
 fs/xfs/scrub/common.c           |   65 ++++-
 fs/xfs/scrub/common.h           |    5 
 fs/xfs/scrub/dir.c              |   10 +
 fs/xfs/scrub/dir_repair.c       |   20 +
 fs/xfs/scrub/dirtree.c          |   32 ++
 fs/xfs/scrub/dirtree.h          |   12 -
 fs/xfs/scrub/findparent.c       |   28 ++
 fs/xfs/scrub/health.c           |    1 
 fs/xfs/scrub/inode.c            |   35 ++-
 fs/xfs/scrub/inode_repair.c     |   34 ++-
 fs/xfs/scrub/metapath.c         |  521 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.c           |    4 
 fs/xfs/scrub/nlinks_repair.c    |    4 
 fs/xfs/scrub/orphanage.c        |    4 
 fs/xfs/scrub/parent.c           |   39 ++-
 fs/xfs/scrub/parent_repair.c    |   37 ++-
 fs/xfs/scrub/quotacheck.c       |    7 -
 fs/xfs/scrub/refcount_repair.c  |    2 
 fs/xfs/scrub/repair.c           |   22 +-
 fs/xfs/scrub/repair.h           |    3 
 fs/xfs/scrub/scrub.c            |   12 +
 fs/xfs/scrub/scrub.h            |    2 
 fs/xfs/scrub/stats.c            |    1 
 fs/xfs/scrub/tempfile.c         |  105 ++++++++
 fs/xfs/scrub/tempfile.h         |    3 
 fs/xfs/scrub/trace.c            |    1 
 fs/xfs/scrub/trace.h            |   42 +++
 fs/xfs/xfs_dquot.c              |    1 
 fs/xfs/xfs_fsops.c              |    4 
 fs/xfs/xfs_health.c             |    2 
 fs/xfs/xfs_icache.c             |   74 ++++++
 fs/xfs/xfs_inode.c              |   19 +
 fs/xfs/xfs_inode.h              |   36 ++-
 fs/xfs/xfs_inode_item.c         |    7 -
 fs/xfs/xfs_inode_item_recover.c |    2 
 fs/xfs/xfs_ioctl.c              |    7 +
 fs/xfs/xfs_iops.c               |   15 +
 fs/xfs/xfs_itable.c             |   33 ++
 fs/xfs/xfs_itable.h             |    3 
 fs/xfs/xfs_message.c            |   47 ++++
 fs/xfs/xfs_message.h            |   19 +
 fs/xfs/xfs_mount.c              |   31 ++
 fs/xfs/xfs_mount.h              |   11 +
 fs/xfs/xfs_qm.c                 |   36 +++
 fs/xfs/xfs_quota.h              |    5 
 fs/xfs/xfs_rtalloc.c            |   38 ++-
 fs/xfs/xfs_super.c              |   13 -
 fs/xfs/xfs_trace.c              |    2 
 fs/xfs/xfs_trace.h              |  102 ++++++++
 fs/xfs/xfs_trans_dquot.c        |    6 
 fs/xfs/xfs_xattr.c              |    3 
 71 files changed, 2324 insertions(+), 201 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_metadir.c
 create mode 100644 fs/xfs/libxfs/xfs_metadir.h
 create mode 100644 fs/xfs/libxfs/xfs_metafile.c
 create mode 100644 fs/xfs/libxfs/xfs_metafile.h
 create mode 100644 fs/xfs/scrub/metapath.c

