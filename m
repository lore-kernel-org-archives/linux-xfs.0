Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C91240604
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744891628; cv=none; b=AMRNjEqf7JrgvrJLChCXVIvYW3hnqCKI6YCbLeiY6NKi3JrUS93zVKgEDMFdrFQNu40gtOBl/jlqPOPLJfSjqwS9TSRfluAP/bKznhMvoWrCKIw4nBGX8I3Xhx0KfxlSjh6amw6tYJESOsr5+cAIR/eOFQ73HeIwaf21X7K7+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744891628; c=relaxed/simple;
	bh=lS0D/qdCtixxdW4nnJ/GLLZuiEl/8KxVKU5/BrknMiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=W4885SVhtzxLtiieRz/iEz0l3LTdYXNJdhBY27gma6MD1nlQenT9u1DJWTZOpgldO0ud+wraYxZK+n+RGFWowXcdEV8JPQDrT6HxDXJ6h7s+cYJN0TsrMt1H6yd9ydf6Z0nYzBtJHZn+7CIaUbm+XKlNweaXlSIQ8VqOO4qUCLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4dIlmDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4dIlmDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A49C4CEEB;
	Thu, 17 Apr 2025 12:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744891627;
	bh=lS0D/qdCtixxdW4nnJ/GLLZuiEl/8KxVKU5/BrknMiQ=;
	h=Date:From:To:Cc:Subject:From;
	b=j4dIlmDk/sKZ9lJGDvhyuCaavj4vyn9Aiefd3rOT/MKHZykHAWhrNIqpDG1Ul7vZf
	 MPyad6B5jlfrKS4Z4M57NYSawUHhu/c3v84AE0ISGnPOlIOhXWuzQ7LbSWxnymzzHm
	 jlXVFDkqR82DGDMMA18Q8TRX0VdJG9H8WI2R6rEiRYxSwzBT9uS+kAWn6eJkU0A3Wi
	 abtjxXrEhlDsH/CfaD9etLKFBWj+7lTdppV4K+Zbz7xSPl104xkJlmRJBfLhVgu4Z1
	 YIeV0yMK6KOWHtayPFOra9hFe+T9WaU0+k2p0B3XYDlQDA4Ggcu7HvkU0Zn4He28Gc
	 5f/0pPxvvunhg==
Date: Thu, 17 Apr 2025 14:07:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.15-rc3
Message-ID: <e3ip6gczsaxvbg7iddmvwy5svl54hig7tjbarvf7ttfqymcqcp@xlvtlw3se257>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

This PR mostly includes fixes and documentation for the zoned allocator
feature merged during previous merge window, but it also adds a sysfs
tunable for the zone garbage collector.

The last two patches on this PR were merged today, so they are not on
linux-next, although one of them is just documentation, and another fixes
a regression to the RT device that we'd like to fix ASAP now that we're
getting more users on the RT zoned allocator.

Thanks,
Carlos

The following changes since commit 8ffd015db85fea3e15a77027fda6c02ced4d2444:

  Linux 6.15-rc2 (2025-04-13 11:54:49 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc3

for you to fetch changes up to c7b67ddc3c999aa2f8d77be7ef1913298fe78f0e:

  xfs: document zoned rt specifics in admin-guide (2025-04-17 08:16:59 +0200)

----------------------------------------------------------------
XFS fixes for 6.15-rc3

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (2):
      xfs: remove the leftover xfs_{set,clear}_li_failed infrastructure
      xfs: mark xfs_buf_free as might_sleep()

Darrick J. Wong (2):
      xfs: compute buffer address correctly in xmbuf_map_backing_mem
      xfs: fix fsmap for internal zoned devices

Hans Holmberg (2):
      xfs: add tunable threshold parameter for triggering zone GC
      xfs: document zoned rt specifics in admin-guide

Zhang Xianwei (1):
      xfs: Fix spelling mistake "drity" -> "dirty"

 Documentation/admin-guide/xfs.rst | 50 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.c                  |  1 +
 fs/xfs/xfs_buf_mem.c              |  2 +-
 fs/xfs/xfs_dquot.c                |  3 +--
 fs/xfs/xfs_fsmap.c                | 51 +++++++++++++++++++++++++--------------
 fs/xfs/xfs_inode_item.c           |  6 -----
 fs/xfs/xfs_log.c                  |  2 +-
 fs/xfs/xfs_mount.h                |  1 +
 fs/xfs/xfs_sysfs.c                | 32 ++++++++++++++++++++++++
 fs/xfs/xfs_trans_ail.c            |  5 ++--
 fs/xfs/xfs_trans_priv.h           | 28 ---------------------
 fs/xfs/xfs_zone_alloc.c           |  7 ++++++
 fs/xfs/xfs_zone_gc.c              | 16 ++++++++++--
 13 files changed, 143 insertions(+), 61 deletions(-)

