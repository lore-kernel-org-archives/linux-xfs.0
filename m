Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656E953365
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844280; cv=none; b=Jc4AFBJrOh9ZdgSvZbVdGbXWipODwYp7IJR7UjsLm+kOnpi5OJOheDDxoHt8I+8K8FgtAInZpEHZe/AvAjMagb9wyHa0lgZ8cEHR0xwpCfOfnM9yKHxCYZ5BtaxgcdfMBYNiZUNQalmIGJf7Kc1xmLclQD31wJsgpq6B4JdrxCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844280; c=relaxed/simple;
	bh=LNcrvl1C18iMRxletAxaoKinqfrK76OpjaomNS/Qa+U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=maxW2P5CSNWy6CKRyn/eYkqrq3PueszZ7UHR3HecWX5wxxFbzjqNSoHiLUAn+feMz9Y6UYofrq5PSh6QRXHgxxeP5G+PlaRBb3fFn4jhjjIckJqkaTE+IVl8XRw+g3d8jt6xq7jWvMZ2VmFN7aW8ou9jtz6d6Be82MwKGC+r6zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYR/P5MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYR/P5MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE062C4CECF;
	Tue,  5 Nov 2024 22:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844280;
	bh=LNcrvl1C18iMRxletAxaoKinqfrK76OpjaomNS/Qa+U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OYR/P5MGGNsIwzzBU1GZA0BW+zCx5gNqbmsOkQZNMLs0cpyPiN8XALFNoxhPDxIkD
	 sK4kewawpSu+8R3R2UAWNb9WDM6IDWbkXmESQnXRnxq9KLbOlVEEDtPC7bWLrHm1dP
	 gjrjWBUl1bkG1lXnexBMghme12VKbjdUzhrWfqIXvj4hqD+pxuXFmftFj++MI+SKyp
	 eFnIQwg6w5CgEsk3Jw9E1QDw5cyLWwyD49YGXXyXl/QY77VnXITyOPWdKtURnRoXmP
	 1uGzNhKc5to6+WZFngPDbcSe6mKhG9HTX3eGUvURY6kPzbniLT6tq7Yw5G7IiNE6O/
	 CzpHpupIJkPLA==
Date: Tue, 05 Nov 2024 14:04:39 -0800
Subject: [PATCHSET v5.5 03/10] xfs: metadata inode directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
In-Reply-To: <20241105215840.GK2386201@frogsfrogsfrogs>
References: <20241105215840.GK2386201@frogsfrogsfrogs>
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

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadata-directory-tree-6.13
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
 fs/xfs/scrub/repair.c           |   14 +
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
 fs/xfs/xfs_message.c            |   51 ++++
 fs/xfs/xfs_message.h            |   20 +
 fs/xfs/xfs_mount.c              |   31 ++
 fs/xfs/xfs_mount.h              |   25 +-
 fs/xfs/xfs_pnfs.c               |    3 
 fs/xfs/xfs_qm.c                 |   36 +++
 fs/xfs/xfs_quota.h              |    5 
 fs/xfs/xfs_rtalloc.c            |   38 ++-
 fs/xfs/xfs_super.c              |   13 -
 fs/xfs/xfs_trace.c              |    2 
 fs/xfs/xfs_trace.h              |  102 ++++++++
 fs/xfs/xfs_trans_dquot.c        |    6 
 fs/xfs/xfs_xattr.c              |    3 
 72 files changed, 2333 insertions(+), 206 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_metadir.c
 create mode 100644 fs/xfs/libxfs/xfs_metadir.h
 create mode 100644 fs/xfs/libxfs/xfs_metafile.c
 create mode 100644 fs/xfs/libxfs/xfs_metafile.h
 create mode 100644 fs/xfs/scrub/metapath.c

