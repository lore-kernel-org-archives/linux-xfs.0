Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25A3B65C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ul615HGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F6CC433C8;
	Sun, 31 Dec 2023 19:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050846;
	bh=6RmgVbVVYfsyWc0pIo58r65VlodYUtinqDuemoI/yPc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ul615HGaQWMorJOKk27APrWnO4bnHVEjGukgA6CQDCUbf7cnjWqpogehZIaRq4XwS
	 Oui8g0pvi+jB+DNvNxV0YWJ5pqKKnNS3fhS2MVrL0JIbQ/9xWCc4lJjcmwp9TJz+L8
	 V5x/6TY0KE1PXBiJCMvMjZnY6YZbIsYsSOM8D4VVNCgbPhiup2bDeTbF1gq1Pr4DRZ
	 l4+7ttXlPcKTLCn0210ZWEIbgnFUWlxEW+tp+dWt9RbXBKnFNLUdlOw9exP50Fka8O
	 mnaVC6AsmDEbU8s9EamuvdEc8hVy+xZ1HOh62/AQ2/dYo+VpV2P1LmllRwkboP7eow
	 0C404AjnuR1XQ==
Date: Sun, 31 Dec 2023 11:27:26 -0800
Subject: [PATCHSET v29.0 08/28] xfs: support in-memory btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
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
 fs/xfs/Kconfig                     |    8 
 fs/xfs/Makefile                    |    2 
 fs/xfs/libxfs/xfs_ag.c             |    6 
 fs/xfs/libxfs/xfs_ag.h             |    4 
 fs/xfs/libxfs/xfs_btree.c          |  173 ++++++-
 fs/xfs/libxfs/xfs_btree.h          |   17 +
 fs/xfs/libxfs/xfs_btree_mem.h      |  128 ++++++
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 
 fs/xfs/libxfs/xfs_rmap_btree.c     |    4 
 fs/xfs/scrub/bitmap.c              |   28 +
 fs/xfs/scrub/bitmap.h              |    3 
 fs/xfs/scrub/scrub.c               |    5 
 fs/xfs/scrub/scrub.h               |    3 
 fs/xfs/scrub/trace.c               |   11 
 fs/xfs/scrub/trace.h               |  109 +++++
 fs/xfs/scrub/xfbtree.c             |  837 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfbtree.h             |   63 +++
 fs/xfs/scrub/xfile.c               |  181 ++++++++
 fs/xfs/scrub/xfile.h               |   66 +++
 fs/xfs/xfs_aops.c                  |    5 
 fs/xfs/xfs_bmap_util.c             |    8 
 fs/xfs/xfs_buf.c                   |  203 ++++++---
 fs/xfs/xfs_buf.h                   |   79 +++
 fs/xfs/xfs_buf_xfile.c             |   97 ++++
 fs/xfs/xfs_buf_xfile.h             |   20 +
 fs/xfs/xfs_discard.c               |    9 
 fs/xfs/xfs_file.c                  |    6 
 fs/xfs/xfs_health.c                |    3 
 fs/xfs/xfs_ioctl.c                 |    3 
 fs/xfs/xfs_iomap.c                 |    4 
 fs/xfs/xfs_log.c                   |    4 
 fs/xfs/xfs_log_recover.c           |    3 
 fs/xfs/xfs_mount.h                 |    3 
 fs/xfs/xfs_trace.c                 |    3 
 fs/xfs/xfs_trace.h                 |   85 +++-
 fs/xfs/xfs_trans.h                 |    1 
 fs/xfs/xfs_trans_buf.c             |   42 ++
 37 files changed, 2105 insertions(+), 125 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_btree_mem.h
 create mode 100644 fs/xfs/scrub/xfbtree.c
 create mode 100644 fs/xfs/scrub/xfbtree.h
 create mode 100644 fs/xfs/xfs_buf_xfile.c
 create mode 100644 fs/xfs/xfs_buf_xfile.h

