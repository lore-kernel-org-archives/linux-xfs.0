Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35355B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNyO+Ucu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A619C433C8;
	Sun, 31 Dec 2023 19:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051582;
	bh=RTiM/SaEk0Eqlw4u1TiR7bWWVtiZ2z2aNHsG6IGToK0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HNyO+UcuVIvQ551AGgdzgazwNKJMC0kEpDaGdOM/7FIu/3a1Wc1SsrO6uc9wQ+IR4
	 5Ik3c0now7WdBvllzCAkWq3Nx0nJ+3DLFgif+DFt8LWRXz1LuPArlmfbm0BCCEpcy+
	 kGNW8ASnr69QwF6nDrGe7bfFzemLmjFOFpZDqQYPjNfst1sjg3B8fMG7kCOc/pJ09g
	 pE8J1LtoLHT15S4DtIZ1zHMVFxJ59hDKbaEo5VlblMRFk2rQwAW5NK/gLNqawFqQxI
	 UPJpko5teUnnnJ1XETniwWLyZH5pe+54y/HhVxC1ot25vJXPr2PSb9x20wNmtMVBLF
	 y+LIzQDwoxUYA==
Date: Sun, 31 Dec 2023 11:39:41 -0800
Subject: [PATCHSET v2 5/5] xfs: aligned file data extent mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Message-ID: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182553.GV361584@frogsfrogsfrogs>
References: <20231231182553.GV361584@frogsfrogsfrogs>
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

Years ago during the adaptation of XFS to persistent memory, a product
development team expressed a desire to guarantee that mmap mappings of
an S_DAX file on pmem would always get a PMD mapping to increase TLB hit
rates.  That means ensuring that all space allocations are aligned to
2MB (on x86) and ensuring that the file range of each file space mapping
are aligned to 2MB.  Then pmem faded.

NVME/SCSI atomic write unit support has brought this discussion back to
the forefront, because untorn writes to conventional storage only work
if the space allocations are aligned to the max atomic write unit.  To
simplify the administrative model a bit, we want to ensure that the
mappings are aligned to the same value.  IOWs, for a storage device that
supports up to 64k atomic write units, we want to ensure that the file
range of all mappings are aligned to 64k.

From a file metadata perspective, these are nearly the same use case.
The realtime volume already has a realtime extent size field that forces
the alignment of both space and mapping, but not everyone wants to
adminster a realtime volume.  This patchset adds a forcealign superblock
feature and inode flag so that we can impose the same alignment
restrictions on selected files on the data volume.

IOWs, you can now set an inode flag that causes regular files on the
data volume to have rextsize-aligned space mappings.  This is an
improvement over ext4 bigalloc style things that impose the larger
allocation unit size even for things that don't need it.

Note: Currently this patchset reuses sb_rextsize for the forcealign
value because that enabled reuse of the COW around code that I wrote for
realtime reflink that ensures that remapping operations follow
forcealign.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=file-force-align

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=file-force-align
---
 fs/xfs/libxfs/xfs_bmap.c       |   48 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_format.h     |   19 +++++++++++++---
 fs/xfs/libxfs/xfs_inode_buf.c  |   36 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.h  |    3 +++
 fs/xfs/libxfs/xfs_inode_util.c |   14 ++++++++++++
 fs/xfs/libxfs/xfs_sb.c         |   30 +++++++++++++++++++++++++
 fs/xfs/scrub/inode_repair.c    |   41 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h           |    1 +
 fs/xfs/xfs_bmap_util.c         |    2 --
 fs/xfs/xfs_bmap_util.h         |    4 ++-
 fs/xfs/xfs_inode.c             |    2 +-
 fs/xfs/xfs_inode.h             |    8 ++++++-
 fs/xfs/xfs_ioctl.c             |   14 ++++++++++++
 fs/xfs/xfs_iomap.c             |    4 +++
 fs/xfs/xfs_mount.h             |    2 ++
 fs/xfs/xfs_reflink.c           |   16 ++++++++++---
 fs/xfs/xfs_rtalloc.c           |    4 +++
 fs/xfs/xfs_super.c             |    4 +++
 fs/xfs/xfs_trace.h             |    4 ---
 include/uapi/linux/fs.h        |    2 ++
 20 files changed, 236 insertions(+), 22 deletions(-)

