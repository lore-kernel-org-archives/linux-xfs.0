Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299E62D3EE7
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751028912; cv=none; b=uiT62sofD7d0J7KhBRRC8NL1hTDKxydW1OAt01wC9mi6g2qkm59aV2Q4UBMzg8klm6s95kN6J4CLtklAzhIHk30yrujqqqKxFa/5p8LlOO4rmFjNTsjBB95oON4YKhal8UlpbR8loyXEZcUQLIh1Dl6rmzT2nRYyAMKVqREVmx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751028912; c=relaxed/simple;
	bh=OEpN7O74zHcx9W5gwoliQif2EXrjilwQcE/nCzOBBis=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FqydPqxtKV2puaP/FdLnC3zuyxVe7BwTT5QGg3i9Gx4o1DTfRN8eLLvq06p18Aa762ijpbhgRXTX9oWz1IR4ew+xTnET7rpMTxajC0TifH26OopV445k6hXpjl9cevlj59vpxOUfCMFPV2jmAWT+E52IhR3DDnwIMW6xTpc3f+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQpQPlEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQpQPlEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F957C4CEE3
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 12:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751028910;
	bh=OEpN7O74zHcx9W5gwoliQif2EXrjilwQcE/nCzOBBis=;
	h=Date:From:To:Subject:From;
	b=IQpQPlEISWTb72rQT2vQiyfxITzlePjKSvGUwa0fJ5aqtgdHe+octwLyspEZazfAG
	 dGK9lYBLWpmVmn3P2nqp5Rze2ouXn1OYodpH0l+auJaZj/wrTRhKmxT7ohorGGc9pe
	 wTR3t32rBHXzwW6QrdVhqJgsooCsEJJ1Hhl+2UWlrhLBIl9a0Uw+2AeIXdkcbaCvgB
	 oIT8yJmqED68bkaliSSHQJuZeX68vVQYoIA4rbikQ5Q0YEvL+opZRnrGbw4WXrMezQ
	 +0f0Nnt+ymDofnrJfG1ePQB0SzOLUeitVbpoRxp0eCROPRVJnO5/OscCpM3OZN/FRZ
	 436FCxeXTtjTA==
Date: Fri, 27 Jun 2025 14:55:06 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to f259584cb40c
Message-ID: <hyw5332gxstbro2j5lswrypary3h2snvozqw5tszboku4trals@3x3wntciy3bi>
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

f259584cb40c Merge branch 'xfs-6.17-merge' into for-next

21 new commits:

Carlos Maiolino (1):
      [f259584cb40c] Merge branch 'xfs-6.17-merge' into for-next

Dave Chinner (7):
      [09234a632be4] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
      [db6a2274162d] xfs: catch stale AGF/AGF metadata
      [d62016b1a2df] xfs: avoid dquot buffer pin deadlock
      [fc48627b9c22] xfs: add tracepoints for stale pinned inode state debug
      [d2fe5c4c8d25] xfs: rearrange code in xfs_buf_item.c
      [816c330b605c] xfs: factor out stale buffer item completion
      [7b5f775be14a] xfs: fix unmount hang with unflushable inodes stuck in the AIL

Steven Rostedt (13):
      [c0ed3d33cea1] xfs: remove unused trace event xfs_attr_remove_iter_return
      [4b1b26f4fded] xfs: remove unused event xlog_iclog_want_sync
      [159e1d454d6d] xfs: remove unused event xfs_ioctl_clone
      [1905a13e44d9] xfs: remove unused xfs_reflink_compare_extents events
      [3a81e9a6d78d] xfs: remove unused trace event xfs_attr_rmtval_set
      [3f9b08fedc35] xfs: remove unused xfs_attr events
      [9e6d839093cb] xfs: remove unused event xfs_attr_node_removename
      [6f4d1600b0ba] xfs: remove unused event xfs_alloc_near_error
      [7352e1419858] xfs: remove unused event xfs_alloc_near_nominleft
      [4b7169eb63ab] xfs: remove unused event xfs_pagecache_inval
      [5a3b36801c7d] xfs: remove usused xfs_end_io_direct events
      [8f648ef996bf] xfs: only create event xfs_file_compat_ioctl when CONFIG_COMPAT is configure
      [9075fe1225ad] xfs: change xfs_xattr_class from a TRACE_EVENT() to DECLARE_EVENT_CLASS()

Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c  |  41 +++++--
 fs/xfs/libxfs/xfs_ialloc.c |  31 ++++-
 fs/xfs/scrub/trace.h       |   2 +-
 fs/xfs/xfs_buf.c           |  38 ------
 fs/xfs/xfs_buf.h           |   1 -
 fs/xfs/xfs_buf_item.c      | 295 +++++++++++++++++++++++++++------------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_dquot.c         |   4 +-
 fs/xfs/xfs_icache.c        |   8 ++
 fs/xfs/xfs_inode.c         |   2 +-
 fs/xfs/xfs_inode_item.c    |   5 +-
 fs/xfs/xfs_log_cil.c       |   4 +-
 fs/xfs/xfs_qm.c            |  86 +++----------
 fs/xfs/xfs_trace.h         |  78 ++----------
 fs/xfs/xfs_trans.c         |   4 +-
 15 files changed, 290 insertions(+), 312 deletions(-)
