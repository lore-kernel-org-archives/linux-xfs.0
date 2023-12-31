Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795FEB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjGdQslo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44303C433C7;
	Sun, 31 Dec 2023 19:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052489;
	bh=aJxy1QzM2x3uS9Qc8XWQP+prwk5g+v5QEc2hR6LM514=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LjGdQslo6M3pbAlJfj6oL2CB8jvVBKRob9vIyugOC53RxpGFOxg7hqyt+h+QaU5OE
	 6TIzwbvaRj7KS5OP5ePN7/z4bbK6iLskrK0EJ3pcT6bVO/8aXVmTu9oV64OzWRHDF+
	 Fmy+0SMcTEDC4IQo4+akc5l6BrW2pipAloE0AGGDqX7sfn+u01FPwaqrp+sHLRne7Y
	 +cW8FEdgiVQHzunzCpH1/Ye52qFVlyEAu4fA0JBRCUlZ8PiYw4HxVqzwXzVZfh4N8h
	 PB2Oqd5/D1o36JOqq2dXrfqKQRf5Yk4KZpCwxDIRQRTzPyNKYmBmv+nR/pOTs0Sdpv
	 HHPChpg+bZnLQ==
Date: Sun, 31 Dec 2023 11:54:48 -0800
Subject: [PATCHSET v2.0 12/17] xfsprogs: realtime reverse-mapping support
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Add libxfs code from the kernel, then teach the various utilities about
how to access realtime rmapbt information and rebuild it.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
 db/bmroot.c                           |  149 +++++
 db/bmroot.h                           |    2 
 db/btblock.c                          |  103 +++
 db/btblock.h                          |    5 
 db/btdump.c                           |   64 ++
 db/btheight.c                         |    5 
 db/check.c                            |  203 ++++++-
 db/field.c                            |   11 
 db/field.h                            |    5 
 db/fsmap.c                            |  164 +++++
 db/inode.c                            |  128 ++++
 db/inode.h                            |    4 
 db/metadump.c                         |  129 ++++
 db/type.c                             |    5 
 db/type.h                             |    1 
 include/libxfs.h                      |    2 
 include/xfs_mount.h                   |   21 +
 io/scrub.c                            |   41 +
 libfrog/scrub.c                       |   10 
 libxfs/Makefile                       |    2 
 libxfs/defer_item.c                   |  115 +++-
 libxfs/init.c                         |   20 -
 libxfs/libxfs_api_defs.h              |   19 +
 libxfs/rdwr.c                         |    2 
 libxfs/trans.c                        |    1 
 libxfs/xfbtree.c                      |    2 
 libxfs/xfs_bmap.c                     |   23 +
 libxfs/xfs_btree.c                    |   77 ++
 libxfs/xfs_btree.h                    |    7 
 libxfs/xfs_defer.h                    |    1 
 libxfs/xfs_format.h                   |   24 +
 libxfs/xfs_fs.h                       |    6 
 libxfs/xfs_fs_staging.h               |    1 
 libxfs/xfs_health.h                   |    4 
 libxfs/xfs_inode_buf.c                |   26 +
 libxfs/xfs_inode_fork.c               |   13 
 libxfs/xfs_log_format.h               |    6 
 libxfs/xfs_ondisk.h                   |    2 
 libxfs/xfs_refcount.c                 |    6 
 libxfs/xfs_rmap.c                     |  198 ++++++
 libxfs/xfs_rmap.h                     |   25 +
 libxfs/xfs_rtgroup.c                  |   12 
 libxfs/xfs_rtgroup.h                  |   20 +
 libxfs/xfs_rtrmap_btree.c             | 1028 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h             |  217 +++++++
 libxfs/xfs_sb.c                       |    6 
 libxfs/xfs_shared.h                   |    2 
 libxfs/xfs_swapext.c                  |    4 
 libxfs/xfs_trans_resv.c               |   12 
 libxfs/xfs_trans_space.h              |   13 
 libxfs/xfs_types.h                    |    5 
 logprint/log_misc.c                   |    2 
 logprint/log_print_all.c              |    8 
 logprint/log_redo.c                   |   24 +
 man/man2/ioctl_xfs_rtgroup_geometry.2 |    3 
 man/man2/ioctl_xfs_scrub_metadata.2   |    8 
 man/man8/xfs_db.8                     |   63 ++
 man/man8/xfs_io.8                     |    3 
 mkfs/proto.c                          |   56 ++
 mkfs/xfs_mkfs.c                       |   90 +++
 repair/Makefile                       |    1 
 repair/agbtree.c                      |    5 
 repair/bmap_repair.c                  |  131 ++++
 repair/bulkload.c                     |   41 +
 repair/bulkload.h                     |    2 
 repair/dino_chunks.c                  |   13 
 repair/dinode.c                       |  381 ++++++++++--
 repair/dir2.c                         |    4 
 repair/globals.c                      |    6 
 repair/globals.h                      |    2 
 repair/incore.h                       |    1 
 repair/phase2.c                       |  100 +++
 repair/phase4.c                       |   12 
 repair/phase5.c                       |  116 ++++
 repair/phase6.c                       |  208 +++++++
 repair/rmap.c                         |  560 +++++++++++++++---
 repair/rmap.h                         |   17 -
 repair/rtrmap_repair.c                |  261 ++++++++
 repair/scan.c                         |  411 +++++++++++++
 repair/scan.h                         |   37 +
 repair/xfs_repair.c                   |    8 
 scrub/phase4.c                        |   54 ++
 scrub/phase5.c                        |   24 +
 scrub/repair.c                        |  159 +++++
 scrub/repair.h                        |    5 
 scrub/scrub.c                         |    3 
 scrub/scrub.h                         |    4 
 spaceman/health.c                     |   10 
 88 files changed, 5500 insertions(+), 284 deletions(-)
 create mode 100644 libxfs/xfs_rtrmap_btree.c
 create mode 100644 libxfs/xfs_rtrmap_btree.h
 create mode 100644 repair/rtrmap_repair.c

