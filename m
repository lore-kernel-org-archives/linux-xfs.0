Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F3E2652A2
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298581; cv=none; b=pXJn5mQ5KnrqnNvh/Qw1FTCW+s3/FnMDZI2jPs//VfRdYFRwOvEcvRL/U/6eXs430bNGIwa10NTI4kKtNYWqFU2PrVc9cQzPK2FXBx+WTr5FkiWvmDs1JpuJQrKjdecI6aAeQCZjgAiq3CsQDNUrNPmiA3MtYdJW1wmmHalpz/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298581; c=relaxed/simple;
	bh=KwOzIaBlSEDN8uVKkk6yCOebuuVHp9UGEdZK9nGJShs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bgzGuS6Tk13hDZMMPIIN8UKCVCWy4v4uWnJvJmSWEisuKT9TFD5KeUbbcw0NCCI1JTk9lEg3qBcAYLLz/J/pmhH5BGKvOMcjsdEGCy2ULWfDC1PT2JbTAye4EbH/VVBx+wy/0KfpLTjk++BNy7mrd40Fjr78gBOzoGDmMvZ9V9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnDZbkI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnDZbkI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C40FC4CEF0
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758298581;
	bh=KwOzIaBlSEDN8uVKkk6yCOebuuVHp9UGEdZK9nGJShs=;
	h=Date:From:To:Subject:From;
	b=RnDZbkI7d5YHwxtsTHsB18IQUPcyE2DqBk9TFH3BIDZNMO4mB0cjdPc0pM4K38YE6
	 HF7MTMxCO20op2+d/MZDl5WElCr6ZiEhIQz6eYmvJX1MDuTKuTG2KBSfz4h5Stbw8i
	 HtRrMPmuRiFlxyD1ulIEmmTI58B8A+2JyJRAkIpbD0yuZZ6hElDrfBuxFRxx4hkwrq
	 Wd1zI5UGxKevj5q8FUere9SFRttWFcSH80vTe185pP2bVzjp1mD1zalQqP6ltxAywK
	 pI+ePzqU0Unxg+YQDYP94vWrvTYThVBFM+HdnLcBcanDuXuzPSA+AYpcKnhgHh1JKW
	 aC0JdGEi5tDSA==
Date: Fri, 19 Sep 2025 18:16:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 3c54e6027f14
Message-ID: <dxfj6ldpbjmymga7ozm6jbzlmczefjumdp77hcs6p5uchf2ojv@jkusq6kjsv7j>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

3c54e6027f14 xfs: constify xfs_errortag_random_default

9 new commits:

Christoph Hellwig (7):
      [42c21838708c] xfs: move the XLOG_REG_ constants out of xfs_log_format.h
      [d5409ebf46bb] xfs: remove xfs_errortag_get
      [991dcadaddcc] xfs: remove xfs_errortag_set
      [807df3227d76] xfs: remove the expr argument to XFS_TEST_ERROR
      [b55dd7279811] xfs: remove pointless externs in xfs_error.h
      [71fa062196ae] xfs: centralize error tag definitions
      [3c54e6027f14] xfs: constify xfs_errortag_random_default

Damien Le Moal (2):
      [8e1cfa51320d] xfs: improve zone statistics message
      [ff3d90903f8f] xfs: improve default maximum number of open zones

Code Diffstat:

 fs/xfs/libxfs/xfs_ag_resv.c    |   7 +-
 fs/xfs/libxfs/xfs_alloc.c      |   5 +-
 fs/xfs/libxfs/xfs_attr_leaf.c  |   2 +-
 fs/xfs/libxfs/xfs_bmap.c       |  17 ++--
 fs/xfs/libxfs/xfs_btree.c      |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c   |   2 +-
 fs/xfs/libxfs/xfs_dir2.c       |   2 +-
 fs/xfs/libxfs/xfs_errortag.h   | 114 +++++++++++++---------
 fs/xfs/libxfs/xfs_exchmaps.c   |   4 +-
 fs/xfs/libxfs/xfs_ialloc.c     |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |   4 +-
 fs/xfs/libxfs/xfs_inode_fork.c |   3 +-
 fs/xfs/libxfs/xfs_log_format.h |  37 -------
 fs/xfs/libxfs/xfs_metafile.c   |   2 +-
 fs/xfs/libxfs/xfs_refcount.c   |   7 +-
 fs/xfs/libxfs/xfs_rmap.c       |   2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   2 +-
 fs/xfs/libxfs/xfs_zones.h      |   7 ++
 fs/xfs/scrub/cow_repair.c      |   4 +-
 fs/xfs/scrub/repair.c          |   2 +-
 fs/xfs/xfs_attr_item.c         |   2 +-
 fs/xfs/xfs_buf.c               |   4 +-
 fs/xfs/xfs_error.c             | 216 ++++++-----------------------------------
 fs/xfs/xfs_error.h             |  47 ++++-----
 fs/xfs/xfs_inode.c             |  28 +++---
 fs/xfs/xfs_iomap.c             |   4 +-
 fs/xfs/xfs_log.c               |   8 +-
 fs/xfs/xfs_log.h               |  37 +++++++
 fs/xfs/xfs_trans_ail.c         |   2 +-
 fs/xfs/xfs_zone_alloc.c        |   4 +-
 30 files changed, 217 insertions(+), 362 deletions(-)
