Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD231CF9C
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 09:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710320501; cv=none; b=dEcx4kmKmIhtOYO/QI+O2o0lIbhktw3LRm1mRg/0eOhrmTbUYIjElE35MH+8o31hLhqmX0KKLiFEF847NSB6sg8dgCNyLluzvpK72H0BR6o21j6VseqeOj0Xc3WfXZizIe9FyGvnSH4WjbcX8qCewlR8PVXIPeUPwfPuMnEPKHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710320501; c=relaxed/simple;
	bh=GbdgaaO6TTX+CRJZ6eZP7WcObay4UgFJaPM9NRqlDrs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EIvoA7kWPwtR5tsjbNeP4jyPsSvC9Z7snqpI1fJ5pvvtrERaLppdkcWsq6I1oXWsvXwQ3h9gwxq9SPs1gj2LHoYSWNneBfb+cWLZPwv1vFkn7iV2HUAeWeX27Hj9TB1OcITxLYKNUJ8NsZe0yDqUs1ZsXRPbqYDtLNg0r15MhU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVs1ER/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVs1ER/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AD9C43390
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 09:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710320500;
	bh=GbdgaaO6TTX+CRJZ6eZP7WcObay4UgFJaPM9NRqlDrs=;
	h=Date:From:To:Subject:From;
	b=RVs1ER/zLR1buwmzTDrK3WXL0Vmy+u0kEdGo9/ntJ1VEkqZtf+hUP/svf2lt8UIa8
	 Ortg5EUUOKFpkwR9LuOeFz0mMjGxXbvY0WNf5NzkcBwmOlqxhQmcp/++uOM2kOVD7B
	 hPXZVvyW/ePq6wmidBFl+NVjoHre9UaABAnF/RLhRFYnBTo9hIymhSul8t+RAN1FjG
	 fKT+vcw7pB7FfV7ZwZxdCUh7CIgEvMSZTsbFZdtSZrT4zWetyMrPuk7X6Bw44sYa1F
	 68HRru9VLeTt3kXz8Uj/vPPb/l1db5EHiorYzWnj+cGKJZf0PvYHxVbr/EQwMzIp9o
	 bWIDfK9ua8MJg==
Date: Wed, 13 Mar 2024 10:01:37 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: followup for-next update to c6be1c78f
Message-ID: <i3qm7tnrk3uh5dthmehjwkhvlmssiwixgqnpddc3rvgg6yhwl7@insuyi6oglea>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

This is a follow-up update on top of yesterday's update, as it was missing a
series from Christoph. This update just pushes his series to for-next

The new head of the for-next branch is commit:

c6be1c78f1631884ff0befc6b19d762d2b8f4e5d

26 new commits:

Christoph Hellwig (26):
      [a18202542] include: remove the filldir_t typedef
      [87d0aad10] include: unconditionally define umode_t
      [c7820bbb4] repair: refactor the BLKMAP_NEXTS_MAX check
      [4b641cc08] include: stop using SIZEOF_LONG
      [0fa9dcb61] include: stop generating platform_defs.h
      [f367d5629] io: don't redefine SEEK_DATA and SEEK_HOLE
      [dbe764ee7] configure: don't check for getmntent
      [bd07eedea] configure: require libblkid
      [1b8d539cc] configure: don't check for fadvise
      [04e3bb974] configure: don't check for sendfile
      [90bcaf5a7] configure: don't check for madvise
      [6539cd18e] configure: don't check for mincor
      [920130ef5] configure: don't check for fiemap
      [2f5de3cee] configure: don't check for sync_file_range
      [015b44e7f] configure: don't check for readdir
      [055629e00] configure: don't check for fls
      [15fb447f8] configure: don't check for fallocate
      [bafafcb96] configure: don't check for syncfs
      [636f77efe] configure: don't check for preadv and pwritev
      [47f7c0445] configure: don't check for mremap
      [25c2a1981] configure: don't check for fsetxattr
      [0c026db1e] configure: don't check for the f_flags field in statfs
      [810b515b4] configure: don't check for openat
      [86b43bd0d] configure: don't check for fstatat
      [0b50e9fa9] configure: don't check for SG_IO
      [c6be1c78f] configure: don't check for HDIO_GETGEO

Code Diffstat:

 Makefile                                        |  15 +-
 configure.ac                                    |  32 ---
 fsr/Makefile                                    |   4 -
 fsr/xfs_fsr.c                                   |   2 -
 include/bitops.h                                |   2 -
 include/builddefs.in                            |  36 ---
 include/linux.h                                 |   2 -
 include/{platform_defs.h.in => platform_defs.h} |  10 +-
 io/Makefile                                     |  69 +----
 io/io.h                                         |  36 ---
 io/mmap.c                                       |   8 -
 io/pread.c                                      |   8 -
 io/prealloc.c                                   |   8 -
 io/pwrite.c                                     |   8 -
 io/seek.c                                       |   5 -
 io/stat.c                                       |   2 -
 io/sync.c                                       |   4 -
 libfrog/Makefile                                |   4 -
 libfrog/paths.c                                 |   9 +-
 libxfs/topology.c                               |  37 +--
 m4/Makefile                                     |   1 -
 m4/package_libcdev.m4                           | 329 ------------------------
 m4/package_types.m4                             |  14 -
 repair/bmap.c                                   |  23 +-
 repair/bmap.h                                   |  13 -
 scrub/Makefile                                  |  16 +-
 scrub/common.h                                  |   8 -
 scrub/disk.c                                    |  30 +--
 28 files changed, 35 insertions(+), 700 deletions(-)
 rename include/{platform_defs.h.in => platform_defs.h} (95%)
 delete mode 100644 m4/package_types.m4
