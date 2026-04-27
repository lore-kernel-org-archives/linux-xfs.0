Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E903C6609
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 13:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296369; cv=none; b=ZL/0o97nQpcILJDmeauEDcj/8f+v9VZ1L83C5r92SVhX/4UdVWpwRj+pO0Rf+j8DeUEkL1IR8MJ2JDBlZvvYa3EkFS7ROASttdR0rXQSYkxiOtyfj2Iagetp5LHWoclP6P/uvHlZwb8N6ZLvT0JzpwDiWhs3+f7yKmPyLyBP0xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296369; c=relaxed/simple;
	bh=d40b6do6mSX6I+pJ7RTWIoHJIdH9WeoUIL1VQuibdQY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pNvS3ZdeN+tusWA/ICukrGuK6BJz8YwKUz5KMnP6ehLkf4Ouo4FBqXmFHUc0l8SWFSDDRVkC/rTx8nRklT4rg2P88GSZ5JC3PpECtp/NmaYKbaflPYUlAWRQ3AbV8zb4JS2cFe6DM+apACwJdGUu/nVMk30JKUzU4c/qHrf9YO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+dgNeud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+dgNeud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1180C2BCB5
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296369;
	bh=d40b6do6mSX6I+pJ7RTWIoHJIdH9WeoUIL1VQuibdQY=;
	h=Date:From:To:Subject:From;
	b=e+dgNeudPv/kxGgwEoNbbC1bUFWY5v34RhU0X9Nap+RI+wAwyKgrn3rg7Ls6AqV+k
	 +bHzTJcFr3TloAY2l6+QQ2C7wa5cg/eEGPlR9yUG99ulHw/EYFUk74ObZuBZOsSinp
	 FUsCTtxETb4X8p6Qip/12PlM+x4UwzCukD3G9yjP8qXYI0wZofKxN4lgeredNiNFCz
	 mloywWND0BuL8kSkpl4rY+BViLq2+t6146pbrOXldFdudXoVB3W6E2ZxQT59dWnkOB
	 Pah9lD77o+XvQ7hiQ1lGc+ZW2C5DfuEWpr9xYsAlFbg0kqoApa+HZo11IFD3goTmL3
	 NiVqefnjRTALQ==
Date: Mon, 27 Apr 2026 15:26:05 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 87e63466c9fc
Message-ID: <ae9jarjvEDYL0G-Z@nidhogg.toxiclabs.cc>
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

has just been updated to 7.1-rc1 and a few fixes.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

87e63466c9fc xfs: flush delalloc blocks on ENOSPC in xfs_trans_alloc_icreate

8 new commits:

Jinliang Zheng (1):
      [bfb4dc533d0a] xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING

Ravi Singh (1):
      [87e63466c9fc] xfs: flush delalloc blocks on ENOSPC in xfs_trans_alloc_icreate

Wilfred Mallawa (2):
      [592975da8c3c] xfs: fix memory leak on error in xfs_alloc_zone_info()
      [af47a4be6a90] xfs: fix memory leak for data allocated by xfs_zone_gc_data_alloc()

Yuto Ohnuki (4):
      [00dd8d7ec525] xfs: zero entire directory data block header region at init
      [8fbb1877dfa5] xfs: zero directory data block padding on write verification
      [939919ccddfc] xfs: check directory data block header padding in scrub
      [fca20fcb76a2] xfs: check da node block pad field during scrub

Code Diffstat:

 fs/xfs/libxfs/xfs_dir2_data.c | 18 +++++++++++-------
 fs/xfs/libxfs/xfs_refcount.c  |  3 +--
 fs/xfs/scrub/common.c         | 11 +++++++++++
 fs/xfs/scrub/common.h         |  2 ++
 fs/xfs/scrub/dabtree.c        |  7 ++++++-
 fs/xfs/scrub/dir.c            |  7 ++++++-
 fs/xfs/xfs_inode.c            |  6 ------
 fs/xfs/xfs_trans.c            | 11 +++++++++++
 fs/xfs/xfs_zone_alloc.c       |  2 +-
 fs/xfs/xfs_zone_gc.c          |  2 +-
 10 files changed, 50 insertions(+), 19 deletions(-)
