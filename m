Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ABB1DB548
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 17:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504463; cv=none; b=az9k/h45P+LcPLt5dHmIALiGMNaH7Hb5kF6lP+EK3tWwiN2LGqApg10ntlCUUFFj9r9jc/R5c8IwUnXSCOVDvrGCS5s/l+/2zyG4uf+v3PDXFzMi2xlDdz+5lI/uexuFSnxvlePf6enbdGXqtp/W3pECmxRYPcsFDtgRFNsbJ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504463; c=relaxed/simple;
	bh=fGHYl6lBIjL43bB6hNalPrm7KrM/G0rdQIigWdYKBVw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=b0r1Z/+omKiOmzhpGl19WdhPiQErdjwgnqehZkO4RhCYYE5OUAeyueDqjidp+xfIQhJyVT5erCEQFikTp4/yzDW0lmWfZmhb7nf+0GFafJ0Ir70P+jxaOm5ValbGm6Fw8c2Pr1Dhuc067bJQJP44Z+A9ZDYVnQi8VJXTpbdeogM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y03WS+4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y03WS+4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748F6C4CEDD;
	Tue, 25 Feb 2025 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504462;
	bh=fGHYl6lBIjL43bB6hNalPrm7KrM/G0rdQIigWdYKBVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y03WS+4ewCPz/C8WNPlTJAsuaBsqRqLQt2N/ETv3kNUFV/VeeU0hdxNXZqLU4KdWD
	 xe6JNwxnKws2Ac6broEhrCX6GNBrcGb8xXJcIzBSt6b9k2e08pIQAaPefM98jxHq2e
	 3ZJA1MGL6cHAdqvcHTAv9YvnSjZ4Ko3yS1cz+Hz7NWG9HwA33TndK21X1bPxwxqn3r
	 3r9DWZhtgIoThejdfvHkW8kJr3gVMTCmhr6p4JuqGvGDX58pMqyIOCVQNG3BHjNnzh
	 qeTW3buzHzN7sH4G9uyO0mpsEb+h4xbm6RJ+n/fYtJUa0tJwcxPBQ97KmZZKnNPlKP
	 8hilf67EoxrZw==
Date: Tue, 25 Feb 2025 09:27:41 -0800
Subject: [GIT PULL 5/7] xfsprogs: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174050432970.404908.14083485613928229663.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250225172123.GB6242@frogsfrogsfrogs>
References: <20250225172123.GB6242@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.14-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit d3fc26fa2ac96c39836884525065f5d47dda8b05:

mkfs: create the realtime rmap inode (2025-02-25 09:16:01 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/realtime-reflink-6.14_2025-02-25

for you to fetch changes up to 17408f8871e100b2987174b6cf480ee68e44e1a3:

mkfs: enable reflink on the realtime device (2025-02-25 09:16:02 -0800)

----------------------------------------------------------------
xfsprogs: reflink on the realtime device [v6.6 5/7]

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then  introduction of
the new btree format and inode fork format.  Next comes enabling CoW and
remapping for the rt device; new scrub, repair, and health reporting
code; and at the end we implement some code to lengthen write requests
so that rt extents are always CoWed fully.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (22):
libxfs: compute the rt refcount btree maxlevels during initialization
libxfs: add a realtime flag to the refcount update log redo items
libxfs: apply rt extent alignment constraints to CoW extsize hint
libfrog: enable scrubbing of the realtime refcount data
man: document userspace API changes due to rt reflink
xfs_db: display the realtime refcount btree contents
xfs_db: support the realtime refcountbt
xfs_db: copy the realtime refcount btree
xfs_db: add rtrefcount reservations to the rgresv command
xfs_spaceman: report health of the realtime refcount btree
xfs_repair: allow CoW staging extents in the realtime rmap records
xfs_repair: use realtime refcount btree data to check block types
xfs_repair: find and mark the rtrefcountbt inode
xfs_repair: compute refcount data for the realtime groups
xfs_repair: check existing realtime refcountbt entries against observed refcounts
xfs_repair: reject unwritten shared extents
xfs_repair: rebuild the realtime refcount btree
xfs_repair: allow realtime files to have the reflink flag set
xfs_repair: validate CoW extent size hint on rtinherit directories
xfs_logprint: report realtime CUIs
mkfs: validate CoW extent size hint when rtinherit is set
mkfs: enable reflink on the realtime device

db/bmroot.h                         |   2 +
db/btblock.h                        |   5 +
db/field.h                          |   6 +
db/type.h                           |   1 +
libxfs/libxfs_api_defs.h            |  14 ++
repair/incore.h                     |   1 +
repair/rmap.h                       |  15 +-
repair/rt.h                         |   4 +
repair/scan.h                       |  33 ++++
db/bmroot.c                         | 135 +++++++++++++++
db/btblock.c                        |  53 ++++++
db/btdump.c                         |   8 +
db/btheight.c                       |   5 +
db/field.c                          |  15 ++
db/info.c                           |  13 ++
db/inode.c                          |  22 ++-
db/metadump.c                       | 114 ++++++++++++
db/type.c                           |   5 +
libfrog/scrub.c                     |  10 ++
libxfs/defer_item.c                 |  34 +++-
libxfs/init.c                       |   8 +-
libxfs/logitem.c                    |  14 ++
logprint/log_misc.c                 |   2 +
logprint/log_print_all.c            |   8 +
logprint/log_redo.c                 |  24 ++-
man/man2/ioctl_xfs_scrub_metadata.2 |  10 +-
man/man8/xfs_db.8                   |  49 +++++-
mkfs/xfs_mkfs.c                     |  83 ++++++++-
repair/Makefile                     |   1 +
repair/agbtree.c                    |   4 +-
repair/dino_chunks.c                |  11 ++
repair/dinode.c                     | 287 +++++++++++++++++++++++++++---
repair/dir2.c                       |   5 +
repair/phase4.c                     |  34 +++-
repair/phase5.c                     |   6 +-
repair/phase6.c                     |  14 +-
repair/rmap.c                       | 241 ++++++++++++++++++++------
repair/rtrefcount_repair.c          | 257 +++++++++++++++++++++++++++
repair/scan.c                       | 337 ++++++++++++++++++++++++++++++++++--
scrub/repair.c                      |   1 +
spaceman/health.c                   |  10 ++
41 files changed, 1779 insertions(+), 122 deletions(-)
create mode 100644 repair/rtrefcount_repair.c

