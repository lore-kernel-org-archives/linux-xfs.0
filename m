Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6250318C933
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881024; cv=none; b=aX7X/X/ruAEgubK1cVIZ0NLzsRy0ZBNY4Uwth/WQNMZQjTOrgx7v9kCp7pMLOufDQ51j3+YrWD0/Q8vH7H9vA9Jeef6tlP8bB6NILDjLdRnwGpRAwflTb9/n99CF5dR5A/y+L6E/O2PSVZOdX32a9dLfORDG7MZG+jklGbWSj20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881024; c=relaxed/simple;
	bh=auEWbLl5kkJKoOGWGtzbzLt85cBlEPwHjiLYcrEE+Dk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B3YOMkvE10Kjo1m3y6wbZR3d0/lhY1pRTb0l7UtzLlM2ecbLLMB9ka3DAeTlUIFKxpYzr4J4fn5zjivZ86+ibnqjLtB+yOrvosimSbT61ivHsTXl+xMXn9b+KtsMdqqvM6pAp4Kie9I8TifKPhh5MPlCN47go2z5EyU6o2+lLqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eoqzBDFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eoqzBDFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C9CC4CEDF;
	Thu,  6 Feb 2025 22:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881023;
	bh=auEWbLl5kkJKoOGWGtzbzLt85cBlEPwHjiLYcrEE+Dk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eoqzBDFB5vg3THwu7W/Gti61mRlXrc4Ug076F1/4sjvgu7xaCbTNbvrvzz8/NgXAd
	 d2pcBb0Wp5Vuo9Fl5R+2pYQO3u95lDOoblog/6eK4r8h4pXsglSA8v31rHy7h2NY3P
	 7YgP/4orY1wk8905aUEWDMeb2RcjyP+FoJBq5dbnrwQfuSnVBF5mVCLtDV2Qotp68f
	 HX0pG1CDxvT29giWdV//Gjj5bEpF9GfqYbHccmzg7fSO5UKDCVJ97sqdBj+e5ciU44
	 99JrJv/TWUBQEV6by2XCzpRkmNKEwcemnNfCvfpFySvf0dSRCzy7A64MRdTtnnYMwz
	 WFlV3p+bSTU3g==
Date: Thu, 06 Feb 2025 14:30:23 -0800
Subject: [PATCHSET v6.3 4/5] xfsprogs: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
In-Reply-To: <20250206222122.GA21808@frogsfrogsfrogs>
References: <20250206222122.GA21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then  introduction of
the new btree format and inode fork format.  Next comes enabling CoW and
remapping for the rt device; new scrub, repair, and health reporting
code; and at the end we implement some code to lengthen write requests
so that rt extents are always CoWed fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
Commits in this patchset:
 * libxfs: compute the rt refcount btree maxlevels during initialization
 * libxfs: add a realtime flag to the refcount update log redo items
 * libxfs: apply rt extent alignment constraints to CoW extsize hint
 * libfrog: enable scrubbing of the realtime refcount data
 * man: document userspace API changes due to rt reflink
 * xfs_db: display the realtime refcount btree contents
 * xfs_db: support the realtime refcountbt
 * xfs_db: copy the realtime refcount btree
 * xfs_db: add rtrefcount reservations to the rgresv command
 * xfs_spaceman: report health of the realtime refcount btree
 * xfs_repair: allow CoW staging extents in the realtime rmap records
 * xfs_repair: use realtime refcount btree data to check block types
 * xfs_repair: find and mark the rtrefcountbt inode
 * xfs_repair: compute refcount data for the realtime groups
 * xfs_repair: check existing realtime refcountbt entries against observed refcounts
 * xfs_repair: reject unwritten shared extents
 * xfs_repair: rebuild the realtime refcount btree
 * xfs_repair: allow realtime files to have the reflink flag set
 * xfs_repair: validate CoW extent size hint on rtinherit directories
 * xfs_logprint: report realtime CUIs
 * mkfs: validate CoW extent size hint when rtinherit is set
 * mkfs: enable reflink on the realtime device
---
 db/bmroot.c                         |  148 +++++++++++++++
 db/bmroot.h                         |    2 
 db/btblock.c                        |   53 ++++++
 db/btblock.h                        |    5 +
 db/btdump.c                         |    8 +
 db/btheight.c                       |    5 +
 db/field.c                          |   15 ++
 db/field.h                          |    6 +
 db/info.c                           |   13 +
 db/inode.c                          |   22 ++
 db/metadump.c                       |  114 ++++++++++++
 db/type.c                           |    5 +
 db/type.h                           |    1 
 libfrog/scrub.c                     |   10 +
 libxfs/defer_item.c                 |   34 +++-
 libxfs/init.c                       |    8 +
 libxfs/libxfs_api_defs.h            |   14 +
 libxfs/logitem.c                    |   14 +
 logprint/log_misc.c                 |    2 
 logprint/log_print_all.c            |    8 +
 logprint/log_redo.c                 |   24 ++
 man/man2/ioctl_xfs_scrub_metadata.2 |   10 +
 man/man8/xfs_db.8                   |   49 +++++
 mkfs/xfs_mkfs.c                     |   83 ++++++++-
 repair/Makefile                     |    1 
 repair/agbtree.c                    |    4 
 repair/dino_chunks.c                |   11 +
 repair/dinode.c                     |  287 +++++++++++++++++++++++++++---
 repair/dir2.c                       |    5 +
 repair/incore.h                     |    1 
 repair/phase4.c                     |   34 +++-
 repair/phase5.c                     |    6 -
 repair/phase6.c                     |   14 +
 repair/rmap.c                       |  241 ++++++++++++++++++++-----
 repair/rmap.h                       |   15 +-
 repair/rt.h                         |    4 
 repair/rtrefcount_repair.c          |  257 +++++++++++++++++++++++++++
 repair/scan.c                       |  337 ++++++++++++++++++++++++++++++++++-
 repair/scan.h                       |   33 +++
 scrub/repair.c                      |    1 
 spaceman/health.c                   |   10 +
 41 files changed, 1792 insertions(+), 122 deletions(-)
 create mode 100644 repair/rtrefcount_repair.c

