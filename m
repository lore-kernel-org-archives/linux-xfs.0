Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC30B666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StTXg+8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C89CC433C8;
	Sun, 31 Dec 2023 19:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051754;
	bh=+PLZFeBmxqR39Qs7ExocmropiNtaAw6aGRoGFd4EpM0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=StTXg+8jaadspYfyuwelUdz23+F7mEl/FfljGSpS0IODVNhsUZ8k39F6TbPJAaTwe
	 eIfKT54bfBVoeFEAYNKUkOYzlLOtgpIaCwTLXeNgDce+TpcdMq4Tg7b1BuT6CQ3tgT
	 xe7dNf7Q8FtiFyty/Fgofa8osEbzb0nrs8P+JFigqNnqyyTuiNZ951VWTwF8MJ4a3w
	 AMhfEcPc7gG3EUFwwUUy4q8ykQWoP/DfNnP636bv8TA7/0B65E/LHEGaP1txGRmd7v
	 O0R5Wz1KSbNB+r9ZLaFkO+ennSeMT7wF8RdzlJ2iGAoUBd1exmdrGtv8uAEf6OlEMl
	 Nrnd6TV+DBUnA==
Date: Sun, 31 Dec 2023 11:42:33 -0800
Subject: [PATCHSET v29.0 11/40] xfsprogs: support in-memory btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

Online repair of the reverse-mapping btrees presens some unique
challenges.  To construct a new reverse mapping btree, we must scan the
entire filesystem, but we cannot afford to quiesce the entire filesystem
for the potentially lengthy scan.

For rmap btrees, therefore, we relax our requirements of totally atomic
repairs.  Instead, repairs will scan all inodes, construct a new reverse
mapping dataset, format a new btree, and commit it before anyone trips
over the corruption.  This is exactly the same strategy as was used in
the quotacheck and nlink scanners.

Unfortunately, the xfarray cannot perform key-based lookups and is
therefore unsuitable for supporting live updates.  Luckily, we already a
data structure that maintains an indexed rmap recordset -- the existing
rmap btree code!  Hence we port the existing btree and buffer target
code to be able to create a btree using the xfile we developed earlier.
Live hooks keep the in-memory btree up to date for any resources that
have already been scanned.

This approach is not maximally memory efficient, but we can use the same
rmap code that we do everywhere else, which provides improved stability
without growing the code base even more.  Note that in-memory btree
blocks are always page sized.

This patchset modifies the kernel xfs buffer cache to be capable of
using a xfile (aka a shmem file) as a backing device.  It then augments
the btree code to support creating btree cursors with buffers that come
from a buftarg other than the data device (namely an xfile-backed
buftarg).  For the userspace xfs buffer cache, we instead use a memfd or
an O_TMPFILE file as a backing device.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=in-memory-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=in-memory-btrees
---
 configure.ac                |    4 
 include/builddefs.in        |    4 
 include/libxfs.h            |    2 
 include/xfs_mount.h         |   10 +
 include/xfs_trace.h         |   15 +
 include/xfs_trans.h         |    1 
 libfrog/bitmap.c            |   64 +++
 libfrog/bitmap.h            |    3 
 libxfs/Makefile             |   18 +
 libxfs/init.c               |  121 +++++--
 libxfs/libxfs_io.h          |   23 +
 libxfs/libxfs_priv.h        |    5 
 libxfs/rdwr.c               |  109 +++++-
 libxfs/trans.c              |   40 ++
 libxfs/xfbtree.c            |  797 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfbtree.h            |   57 +++
 libxfs/xfile.c              |  299 ++++++++++++++++
 libxfs/xfile.h              |  108 ++++++
 libxfs/xfs_ag.c             |    6 
 libxfs/xfs_ag.h             |    4 
 libxfs/xfs_btree.c          |  173 ++++++++-
 libxfs/xfs_btree.h          |   17 +
 libxfs/xfs_btree_mem.h      |  128 +++++++
 libxfs/xfs_refcount_btree.c |    4 
 libxfs/xfs_rmap_btree.c     |    4 
 m4/package_libcdev.m4       |   66 ++++
 mkfs/xfs_mkfs.c             |    2 
 repair/prefetch.c           |   12 -
 repair/prefetch.h           |    1 
 repair/progress.c           |   14 -
 repair/progress.h           |    2 
 repair/scan.c               |    2 
 repair/xfs_repair.c         |   47 ++-
 33 files changed, 2022 insertions(+), 140 deletions(-)
 create mode 100644 libxfs/xfbtree.c
 create mode 100644 libxfs/xfbtree.h
 create mode 100644 libxfs/xfile.c
 create mode 100644 libxfs/xfile.h
 create mode 100644 libxfs/xfs_btree_mem.h

