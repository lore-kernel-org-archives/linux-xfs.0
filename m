Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B921E1DED7B
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 13:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760363656; cv=none; b=hwD3JAUUoA+X8rtCHjrwS2APysbcddfsS+ExqNX5tq1lTztIJm3GE0ut05cX77fTKSdMyNthIqOra2M/goJGoYA23mgT5yjdWQz52f0YLfMNOCOnUaBap4h8QFC7wxEsmAciPETvKJiGqZ4y7ovVsTx8/WPTAnFNXJ5NximMNMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760363656; c=relaxed/simple;
	bh=s04jhQU7TEEHuW18xm8WJIovsRXHdzd0vBkp10CuEiI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oVOIPYjxfXP368gj1XEaUdpcAnLiHWpkoDWDxTjcqM/20JQdO51cR1xH1dbdYsDsm5dEYBHZUMDh/vrWIegvrGj+fQGJ1ppm8qPt14sWYYKx+cAdDkVFF9+J/LsL7+chK/S7nkK+9AXUTZd0aeSUOW9ZG7h7IYa6Nk1p49P/7IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EbphR9Up; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EbphR9Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8461C4CEE7;
	Mon, 13 Oct 2025 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760363656;
	bh=s04jhQU7TEEHuW18xm8WJIovsRXHdzd0vBkp10CuEiI=;
	h=Date:From:To:Cc:Subject:From;
	b=EbphR9UprEubB2JUqQLzC/wcmK/ZNxUZm7Lq66g+crJa88s0zHHm9Z/nsLK0eL0PC
	 Gl1oJudjhbMKEKEd6Q1kzb/b+IsdeBh7li4sZ9ScirPB4dT2XJOq9eJrPaNLPw4OxQ
	 wuUemxCZHvNNZuwp+cdlGwmzJYvHgUFY3mkQ3/0ferjFFOeQLpwHY273BRGV7owvpo
	 WT3j/iaLJXB3m2NHVAwMWD7AaAH5GEYCSVrZxuE+LAGu0MncM+eITdgq/7r+y6aVoi
	 Np3SuG/Id+bevwKYDD32FCOSxKIK5DeaIMFqPTt0A9v3yzJwQh+7AjxgczrRuQTiOK
	 V37b/cZqUaUaA==
Date: Mon, 13 Oct 2025 15:54:08 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: AWilcox@wilcox-tech.com, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, 
	pchelkin@ispras.ru, pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 059eef174487
Message-ID: <k3tvlqxiaeqvk4h5jognyo7zre4uhgdk5nlme34f6mqtd36sv4@snrrskkkqkhk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

059eef174487133bec609752b6deb3b9db5e64bb

New commits:

Christoph Hellwig (3):
      [fc46966ce3d5] xfs: return the allocated transaction from xfs_trans_alloc_empty
      [c6135e4201a1] xfs: improve the xg_active_ref check in xfs_group_free
      [620910fd6440] xfs: don't use a xfs_log_iovec for ri_buf in log recovery

Darrick J. Wong (4):
      [add1e9d2f576] mkfs: fix libxfs_iget return value sign inversion
      [e51aa35ec4c8] libfrog: pass mode to xfrog_file_setattr
      [41aac2782dba] xfs_scrub: fix strerror_r usage yet again
      [bb52ff815e54] mkfs: fix copy-paste error in calculate_rtgroup_geometry

Eric Sandeen (1):
      [059eef174487] xfs: do not propagate ENODATA disk errors into xattr code

Fedor Pchelkin (6):
      [313be3605966] xfs: rename diff_two_keys routines
      [a6b87a3a466c] xfs: rename key_diff routines
      [4a902e04d98e] xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
      [fe6a679a9b30] xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
      [a9be1f9d2bae] xfs: use a proper variable name and type for storing a comparison result
      [ff1a5239a94f] xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()

Pranav Tyagi (1):
      [86c2579ddf30] fs/xfs: replace strncpy with memtostr_pad()

Code Diffstat:

 configure.ac                  |  1 +
 db/attrset.c                  |  6 +---
 db/dquot.c                    |  4 +--
 db/fsmap.c                    |  8 +-----
 db/info.c                     |  8 +-----
 db/metadump.c                 |  2 +-
 db/namei.c                    |  4 +--
 db/rdump.c                    | 11 ++-----
 include/builddefs.in          |  1 +
 include/platform_defs.h       | 13 +++++++++
 include/xfs_trans.h           |  2 +-
 io/attr.c                     |  4 +--
 libfrog/file_attr.c           |  4 +--
 libfrog/file_attr.h           |  9 ++----
 libxfs/inode.c                |  4 +--
 libxfs/trans.c                | 37 ++++++++++++++----------
 libxfs/xfs_alloc_btree.c      | 52 ++++++++++++++-------------------
 libxfs/xfs_attr_remote.c      |  7 +++++
 libxfs/xfs_bmap_btree.c       | 32 +++++++--------------
 libxfs/xfs_btree.c            | 33 ++++++++++-----------
 libxfs/xfs_btree.h            | 41 ++++++++++++++------------
 libxfs/xfs_da_btree.c         |  6 ++++
 libxfs/xfs_format.h           |  2 +-
 libxfs/xfs_group.c            |  3 +-
 libxfs/xfs_ialloc_btree.c     | 24 ++++++++--------
 libxfs/xfs_log_recover.h      |  4 +--
 libxfs/xfs_refcount.c         |  4 +--
 libxfs/xfs_refcount_btree.c   | 18 ++++++------
 libxfs/xfs_rmap_btree.c       | 67 +++++++++++++++----------------------------
 libxfs/xfs_rtrefcount_btree.c | 18 ++++++------
 libxfs/xfs_rtrmap_btree.c     | 67 +++++++++++++++----------------------------
 libxlog/xfs_log_recover.c     | 14 ++++-----
 logprint/log_print_all.c      | 59 ++++++++++++++++++-------------------
 logprint/log_redo.c           | 52 ++++++++++++++++-----------------
 m4/package_libcdev.m4         | 46 +++++++++++++++++++++++++++++
 mkfs/proto.c                  |  2 +-
 mkfs/xfs_mkfs.c               |  2 +-
 quota/project.c               |  6 ++--
 repair/phase2.c               |  6 +---
 repair/pptr.c                 |  4 +--
 repair/quotacheck.c           |  9 ++----
 repair/rcbag.c                |  8 ++----
 repair/rcbag_btree.c          | 56 ++++++++++++++----------------------
 repair/rmap.c                 |  4 +--
 repair/rt.c                   | 10 ++-----
 scrub/Makefile                |  4 +++
 scrub/common.c                |  8 ++++--
 scrub/inodes.c                |  2 --
 48 files changed, 377 insertions(+), 411 deletions(-)

-- 
- Andrey
