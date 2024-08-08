Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F65218FC79
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723135871; cv=none; b=IgXx4gq04Bjyljd4dWmALK0CRq6wUTLpxAR6IXgSV8ElLCB/QAvQLCG8DlB3Yu8VSdkcEwNlmaeKWktUAfHq2duxjZcWkPiEf6SpXt4gcMkGnSnjfr88ZIE2FzZRc5z7rd/+FiEIXGQF4hUJ/lFLT69OyholdCWjhVSA3YQvw3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723135871; c=relaxed/simple;
	bh=yDBD8R86HhDPhNrpaE9zdBuo0bA0Ww3tsXvkRVrBroo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=tSZSlOKCrkT4LV0rZdaa8YEMq+2AdjYwhKRmJ86Zw+5SzdtgWRn6iREsuG8FrkYZDcA3/QynfSnAU46eligU41/YU2QzD9LrwSSkfIl8oecydUBA8XZtT3/LWZclM02lvfTN8tthhsIFB8w1O3XO0x3QPFfpeeKX12wfCZOwzDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nN3VEz4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nN3VEz4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78F8C32782;
	Thu,  8 Aug 2024 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723135870;
	bh=yDBD8R86HhDPhNrpaE9zdBuo0bA0Ww3tsXvkRVrBroo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nN3VEz4bl6sjv7Xe1Awjkr9SIqYA3ZV+nZ7wkXxd8lwkG+/vc7n4YL2mWbaSfc1t5
	 CqPggNzz+zweXqWIRIvIxJA+2Xsfw+oybWmKDat9SHgW90t8iZOSQwdFvvdYJwWanJ
	 p3w7lkzDZzLzUmzMS7X401FUEJMx9hjpvXN05QKHW0cBMJIuII5FeHKYzJ/RqwkHeE
	 8Oz/AaXaZ5Da0lGDl4NuLOonFRfRET2wSXHPMdwUplYU5n4wdaHEWghit+yUMpWL1J
	 N+y7UJGUIpF/ab4Kp4p0Wl9Gv5xpN9aWvI8ifuRjrCROxN4aCJt5KdD/5JW+obGfNY
	 0McyGQQX6/Kuw==
Date: Thu, 08 Aug 2024 09:51:10 -0700
Subject: [GIT PULL 1/2] xfs_scrub: admin control of automatic fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172313566725.2167713.11998419691903109060.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240808164615.GP6051@frogsfrogsfrogs>
References: <20240808164615.GP6051@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 5a43a00432ebe9ab8b54155703a9eb9e1a1dd4ec:

xfs_repair: allow symlinks with short remote targets (2024-07-29 17:01:13 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/autofsck-6.10_2024-08-08

for you to fetch changes up to 7fd2c79b3343e4562b4176728e4dd71b187bbbc9:

mkfs: set autofsck filesystem property (2024-08-08 09:38:48 -0700)

----------------------------------------------------------------
xfs_scrub: admin control of automatic fsck [v30.11 1/2]

Now that we have the ability to set per-filesystem properties, teach the
background xfs_scrub service to pick up advice from the filesystem that it
wants to examine, and pick a mode from that.  We're only going to enable this
by default for newer filesystems.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (11):
libfrog: support editing filesystem property sets
xfs_io: edit filesystem properties
xfs_db: improve getting and setting extended attributes
libxfs: hoist listxattr from xfs_repair
libxfs: pass a transaction context through listxattr
xfs_db: add a command to list xattrs
xfs_property: add a new tool to administer fs properties
libfrog: define a autofsck filesystem property
xfs_scrub: allow sysadmin to control background scrubs
xfs_scrub: use the autofsck fsproperty to select mode
mkfs: set autofsck filesystem property

db/attrset.c                      | 463 +++++++++++++++++++++++++++++++++++++-
io/Makefile                       |   4 +-
io/fsproperties.c                 | 365 ++++++++++++++++++++++++++++++
io/init.c                         |   1 +
io/io.h                           |   1 +
io/xfs_property                   |  77 +++++++
libfrog/Makefile                  |   7 +
libfrog/fsproperties.c            |  77 +++++++
libfrog/fsproperties.h            |  66 ++++++
libfrog/fsprops.c                 | 202 +++++++++++++++++
libfrog/fsprops.h                 |  34 +++
libxfs/Makefile                   |   2 +
{repair => libxfs}/listxattr.c    |  42 ++--
libxfs/listxattr.h                |  17 ++
man/man8/mkfs.xfs.8.in            |   6 +
man/man8/xfs_db.8                 |  68 +++++-
man/man8/xfs_io.8                 |  16 +-
man/man8/xfs_property.8           |  69 ++++++
man/man8/xfs_scrub.8              |  46 ++++
mkfs/lts_4.19.conf                |   1 +
mkfs/lts_5.10.conf                |   1 +
mkfs/lts_5.15.conf                |   1 +
mkfs/lts_5.4.conf                 |   1 +
mkfs/lts_6.1.conf                 |   1 +
mkfs/lts_6.6.conf                 |   1 +
mkfs/xfs_mkfs.c                   | 122 +++++++++-
repair/Makefile                   |   2 -
repair/listxattr.h                |  15 --
repair/pptr.c                     |   9 +-
scrub/Makefile                    |   3 +-
scrub/phase1.c                    |  91 ++++++++
scrub/xfs_scrub.c                 |  14 ++
scrub/xfs_scrub.h                 |   7 +
scrub/xfs_scrub@.service.in       |   2 +-
scrub/xfs_scrub_media@.service.in |   2 +-
35 files changed, 1783 insertions(+), 53 deletions(-)
create mode 100644 io/fsproperties.c
create mode 100755 io/xfs_property
create mode 100644 libfrog/fsproperties.c
create mode 100644 libfrog/fsproperties.h
create mode 100644 libfrog/fsprops.c
create mode 100644 libfrog/fsprops.h
rename {repair => libxfs}/listxattr.c (84%)
create mode 100644 libxfs/listxattr.h
create mode 100644 man/man8/xfs_property.8
delete mode 100644 repair/listxattr.h

