Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B62609D0
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 16:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760979424; cv=none; b=hAO+lty40hA7fJO0b6bzHRUHpmCp3bnfRoEBxGv29EG/rahrKDLU0xaaH25+q6k4XVHvD6jOtmpOYnX3jEG7pomBGMLYTD7yppnxSQVs2K2S4tF+DJwXfFygw3dOnC3YG6pu8MbM0QuFaWnuWf2R+B3byKfv6z+whqGSZmCjpIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760979424; c=relaxed/simple;
	bh=7DrgFsKCjYacYFLU2xivAuyfxfXWDuYQ/FbDyCF2IOg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=s3K8AO8SkDaDMbgGlfksLBBYLQgrftkE+fIhxS0+RXvLSAyrDRRDaQCTxXEr7IyPS0X/PHykBSJ5rqIgekMQdtw/wkHTXGmnSs//0jZK/Ar5JEkWlZj3Eh0dGRznc6COUt9JjYD9swViwW65vJC0/jYN4Q1iq4ZmFoQMyJnzAAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQjBuJVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQjBuJVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5118C4CEF9;
	Mon, 20 Oct 2025 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760979422;
	bh=7DrgFsKCjYacYFLU2xivAuyfxfXWDuYQ/FbDyCF2IOg=;
	h=Date:From:To:Cc:Subject:From;
	b=kQjBuJVVKtzawrHCp66mxbXruAG8vtI538/3b6XOR0tXVjTHDzGUPSXYMwztsdMPS
	 RYvb5Gl31riLSYkVXuin7Bsw1Oj4Vg1Yah2RuuRl8sX5XZL2VxmK7CxKwtgn6wu6hS
	 ws23NWUVY/R8Yhdqtsx3dMoT0Q2B+5n0EpXLI2ce1zmjaSmb/mNG3Z8dYVuldeLTnD
	 0nLu4LW/J9to4lP/IYHKzs6a3ytTIB79NnaoZrC6XcsLtyBXjxBCWWvdWfVg1X3hVe
	 Cd0qYOntahzcmK6xQ1QGsxeFcNjkiH+Fwzxu4wuzVF+ru8ZkrNbt0O4EqBbV9MS7/+
	 puNIuN7VyjTyw==
Date: Mon, 20 Oct 2025 18:56:56 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: AWilcox@wilcox-tech.com, aalbersh@kernel.org, aalbersh@redhat.com, 
	arkamar@gentoo.org, cem@kernel.org, cmaiolino@redhat.com, djwong@kernel.org, 
	hch@lst.de, iustin@debian.org, johannes@nixdorf.dev, 
	linux-xfs@vger.kernel.org, lists@nerdbynature.de, luca.dimaio1@gmail.com, 
	pchelkin@ispras.ru, pranav.tyagi03@gmail.com, sandeen@redhat.com, 
	yi.zhang@huawei.com
Subject: [ANNOUNCE] xfsprogs: v6.17.0 released
Message-ID: <px423cmgn2fmflxqmf742fuojbgniacxfigkhfx6eaqsyywz3m@4tuulf4e43vf>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

de85869984a4095826fb170fc9bd6ae0053c9006

New commits:

A. Wilcox (1):
      [75faf2bc9075] xfs_scrub: Use POSIX-conformant strerror_r

Andrey Albershteyn (5):
      [56af42ac219b] libfrog: add wrappers for file_getattr/file_setattr syscalls
      [961e42e0265c] xfs_quota: utilize file_setattr to set prjid on special files
      [7c850f317ef8] xfs_io: make ls/chattr work with special files
      [128ac4dadbd6] xfs_db: use file_setattr to copy attributes on special files with rdump
      [de85869984a4] xfsprogs: Release v6.17.0

Carlos Maiolino (1):
      [9bd2142c5e35] Improve information about logbsize valid values

Christian Kujau (1):
      [9c83bdfeef71] xfsprogs: fix utcnow deprecation warning in xfs_scrub_all.py

Christoph Hellwig (3):
      [fc46966ce3d5] xfs: return the allocated transaction from xfs_trans_alloc_empty
      [c6135e4201a1] xfs: improve the xg_active_ref check in xfs_group_free
      [620910fd6440] xfs: don't use a xfs_log_iovec for ri_buf in log recovery

Darrick J. Wong (5):
      [add1e9d2f576] mkfs: fix libxfs_iget return value sign inversion
      [e51aa35ec4c8] libfrog: pass mode to xfrog_file_setattr
      [41aac2782dba] xfs_scrub: fix strerror_r usage yet again
      [bb52ff815e54] mkfs: fix copy-paste error in calculate_rtgroup_geometry
      [15fd6fc686d5] xfs_scrub_fail: reduce security lockdowns to avoid postfix problems

Eric Sandeen (1):
      [059eef174487] xfs: do not propagate ENODATA disk errors into xattr code

Fedor Pchelkin (6):
      [313be3605966] xfs: rename diff_two_keys routines
      [a6b87a3a466c] xfs: rename key_diff routines
      [4a902e04d98e] xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
      [fe6a679a9b30] xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
      [a9be1f9d2bae] xfs: use a proper variable name and type for storing a comparison result
      [ff1a5239a94f] xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()

Johannes Nixdorf (2):
      [6cfae337a101] configure: Base NEED_INTERNAL_STATX on libc headers first
      [07956672b784] libfrog: Define STATX__RESERVED if not provided by the system

Luca Di Maio (1):
      [8a4ea7272493] proto: add ability to populate a filesystem from a directory

Pranav Tyagi (1):
      [86c2579ddf30] fs/xfs: replace strncpy with memtostr_pad()

Zhang Yi (1):
      [7b65201af8a7] xfs_io: add FALLOC_FL_WRITE_ZEROES support

Code Diffstat:

 VERSION                          |   2 +-
 configure.ac                     |   4 +-
 db/attrset.c                     |   6 +-
 db/dquot.c                       |   4 +-
 db/fsmap.c                       |   8 +-
 db/info.c                        |   8 +-
 db/metadump.c                    |   2 +-
 db/namei.c                       |   4 +-
 db/rdump.c                       |  27 +-
 debian/changelog                 |   6 +
 doc/CHANGES                      |  15 +
 include/builddefs.in             |   6 +
 include/linux.h                  |  20 +
 include/platform_defs.h          |  13 +
 include/xfs_trans.h              |   2 +-
 io/attr.c                        | 138 ++++---
 io/io.h                          |   2 +-
 io/prealloc.c                    |  36 ++
 io/stat.c                        |   2 +-
 libfrog/Makefile                 |   2 +
 libfrog/file_attr.c              | 121 ++++++
 libfrog/file_attr.h              |  30 ++
 libfrog/statx.h                  |   5 +-
 libxfs/inode.c                   |   4 +-
 libxfs/trans.c                   |  37 +-
 libxfs/xfs_alloc_btree.c         |  52 ++-
 libxfs/xfs_attr_remote.c         |   7 +
 libxfs/xfs_bmap_btree.c          |  32 +-
 libxfs/xfs_btree.c               |  33 +-
 libxfs/xfs_btree.h               |  41 ++-
 libxfs/xfs_da_btree.c            |   6 +
 libxfs/xfs_format.h              |   2 +-
 libxfs/xfs_group.c               |   3 +-
 libxfs/xfs_ialloc_btree.c        |  24 +-
 libxfs/xfs_log_recover.h         |   4 +-
 libxfs/xfs_refcount.c            |   4 +-
 libxfs/xfs_refcount_btree.c      |  18 +-
 libxfs/xfs_rmap_btree.c          |  67 ++--
 libxfs/xfs_rtrefcount_btree.c    |  18 +-
 libxfs/xfs_rtrmap_btree.c        |  67 ++--
 libxlog/xfs_log_recover.c        |  14 +-
 logprint/log_print_all.c         |  59 +--
 logprint/log_redo.c              |  52 +--
 m4/package_libcdev.m4            |  75 +++-
 man/man5/xfs.5                   |  12 +-
 man/man8/mkfs.xfs.8.in           |  38 +-
 man/man8/xfs_io.8                |   6 +
 mkfs/proto.c                     | 771 ++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h                     |  18 +-
 mkfs/xfs_mkfs.c                  |  25 +-
 quota/project.c                  | 144 ++++----
 repair/phase2.c                  |   6 +-
 repair/pptr.c                    |   4 +-
 repair/quotacheck.c              |   9 +-
 repair/rcbag.c                   |   8 +-
 repair/rcbag_btree.c             |  56 ++-
 repair/rmap.c                    |   4 +-
 repair/rt.c                      |  10 +-
 scrub/Makefile                   |   4 +
 scrub/common.c                   |   5 +
 scrub/inodes.c                   |   2 -
 scrub/xfs_scrub_all.py.in        |   8 +-
 scrub/xfs_scrub_fail@.service.in |  57 +--
 63 files changed, 1646 insertions(+), 623 deletions(-)
 create mode 100644 libfrog/file_attr.c
 create mode 100644 libfrog/file_attr.h

-- 
- Andrey
