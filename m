Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1410E31D38B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544614; cv=none; b=PHIalxf0hGDkVR6WmPtkE9Y6bwSsJ+/RT3SDpGvS90Amgek9QfAxvhVmb/kbq5OtUJNoPwQ9XQ/JSnRLDFH925pYIQraeuphDD5rGmvJyPaIJB6Yz13/m/5+N6RXC80vANwhF5gE8CKiwSKNdQkD968OgqqCGHIEA1k9Kueg0oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544614; c=relaxed/simple;
	bh=VDh/G87H8ap7Kzietx9uyR6Lu95sz4YO0Uoybq04kT8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=u8inViHruhRNs3TtYXryCw72yEdotO92s7TOjfJtFD6zEdZqdIHJi1UWXmGTdPQN6VxWMtNVadkypalmAonO6wSNa3C3UV4hbf+8EmNOJVFPfw+8Zo+bmF3ZdAPaTO/smsLMmy7g4PEPpZxxSrTuTcB289ccTgEx57tOajWDI8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vuvv7X2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vuvv7X2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C97C4CEF7;
	Thu, 19 Feb 2026 23:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544614;
	bh=VDh/G87H8ap7Kzietx9uyR6Lu95sz4YO0Uoybq04kT8=;
	h=Date:Subject:From:To:Cc:From;
	b=Vuvv7X2MCPxblxI0fladWECWiRruVpT5z7GLFG4Y0+I2qKWedRutUI8o2vQx22N4y
	 cu4PlUIb+U+ULzXlxq4sjmp2L/w/oeRT0bOM3EpOaOnwRyPyb2FkOD9Atxh7/aENq7
	 amhldbZLwn09P7L/HC94liOIW6ajRjP0KwuVQBIZUXGamFRC7xxnL3tKLqwv8L/4dG
	 +x+lLdHi3q/uiMKISK30e0AWJ5noDvxrdWc6qJFGAj0ueDY8nNrMZgxO89oqhhyRMV
	 Apv5Owmgk26aP9MPgKKrA0z73+aLPp9EAR0F7XxLVBYMh4nzHg7apeoyLr9L5VU09y
	 9Q6T2Hpc6Lfsw==
Date: Thu, 19 Feb 2026 15:43:33 -0800
Subject: [PATCHSET 1/2] xfsprogs: new libxfs code from kernel 6.19
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: brauner@kernel.org, axboe@kernel.dk, dlemoal@kernel.org,
 cmaiolino@redhat.com, cem@kernel.org, hans.holmberg@wdc.com,
 bfoster@redhat.com, martin.petersen@oracle.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Port kernel libxfs code to userspace.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-6.19-sync
---
Commits in this patchset:
 * xfs: error tag to force zeroing on debug kernels
 * xfs: use blkdev_report_zones_cached()
 * xfs: add a xfs_groups_to_rfsbs helper
 * xfs: use a lockref for the xfs_dquot reference count
 * xfs: add a XLOG_CYCLE_DATA_SIZE constant
 * xfs: remove xlog_in_core_2_t
 * xfs: remove the xlog_rec_header_t typedef
 * xfs: remove xarray mark for reclaimable zones
 * xfs: validate that zoned RT devices are zone aligned
 * xfs: mark __xfs_rtgroup_extents static
 * xfs: fix an overly long line in xfs_rtgroup_calc_geometry
 * xfs: set max_agbno to allow sparse alloc of last full inode chunk
---
 include/libxlog.h         |    4 ++-
 libxfs/xfs_errortag.h     |    6 +++--
 libxfs/xfs_group.h        |    9 ++++++++
 libxfs/xfs_log_format.h   |   38 ++++++++++++++++----------------
 libxfs/xfs_ondisk.h       |    6 +++--
 libxfs/xfs_quota_defs.h   |    4 +--
 libxfs/xfs_rtgroup.h      |   16 +++++++-------
 configure.ac              |    1 +
 include/builddefs.in      |    1 +
 libxfs/Makefile           |    4 +++
 libxfs/rdwr.c             |    2 +-
 libxfs/xfs_ialloc.c       |   11 +++++----
 libxfs/xfs_rtgroup.c      |   53 +++++++++++++++++++++++----------------------
 libxfs/xfs_sb.c           |   15 +++++++++++++
 libxfs/xfs_zones.c        |    1 +
 libxlog/util.c            |    6 +++--
 libxlog/xfs_log_recover.c |   52 +++++++++++++++++++++++++-------------------
 logprint/log_dump.c       |    4 ++-
 m4/package_libcdev.m4     |   18 +++++++++++++++
 19 files changed, 155 insertions(+), 96 deletions(-)

