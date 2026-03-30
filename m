Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B913385B6
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774883408; cv=none; b=fMTv4O6IKcFSX4PtvK4gUA0LbgcMTjZgcSrRHaA1FdNYbWSWHgtV3OFgMPJkD00eNXGwZo+/RkQO7YFMchluU+zSYRSZpVr5ax/abh5Nsiw4TuZNCzFGpSnLPCnbLBW1u1ZdCRUlX6w/cCS4Sx3KlqTpf+M50/s7jA46XypuDc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774883408; c=relaxed/simple;
	bh=xHbFEXcv8uc3RkbTJc9B8R2/11ln2SfLGe4O3QGT1Tk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mENx6hOe5vKhvnUcll0fiXNthbIVQvxuJ+iz95LYYAx6bJ9ch7SbMI+Yjk0CP0h8AJ2WkIiogDqb3VxRl5qGx8nswbrdFeTgvtfYh+CY6fz+WpQqD4fjoZmjgf+DGZZ/64rFCEa58OfJ3pomkBwrnvG8ZAEtzdIvqoEqycfguVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5MF6zWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5MF6zWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C695C2BCB1
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774883407;
	bh=xHbFEXcv8uc3RkbTJc9B8R2/11ln2SfLGe4O3QGT1Tk=;
	h=Date:From:To:Subject:From;
	b=h5MF6zWtCUfbsPtKiAUQpNRjGx534mI+CpkdCUIUIEccMFTcP4KsJdVWZQ0a09jUM
	 FXDC+LjKYRzn6q/gBL1RaGAG15/xStE9XFegcwO02/7HDuu8zBeTDEuJDeXM8q9yx9
	 ZtPPd8Kx40yuM2cnmrsRK/Gf+0JWKftXUaaNsNXAoKEHABUlyswzmb0XP6vId3sGJh
	 J8bT257eG2cubTlqM8iP24a699fkV04U5iduRbg8T2K7+i7vJGDE2u/fWpywaTujNa
	 UcBoNbL3dUL2/+Ue144pGbxaQhMCqPDZq3DprlLW4OtFRNA7XBfE97cJAtkYnvtLE/
	 twmN9RAVLscGw==
Date: Mon, 30 Mar 2026 17:10:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 181ea4e2de42
Message-ID: <acqR2ivkYEuSx6IO@nidhogg.toxiclabs.cc>
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

181ea4e2de42 xfs: start gc on zonegc_low_space attribute updates

5 new commits:

Christoph Hellwig (4):
      [67fe4303972e] xfs: don't keep a reference for buffers on the LRU
      [d02ee47bbeed] xfs: use a lockref for the buffer reference count
      [497560b9ef42] xfs: switch (back) to a per-buftarg buffer hash
      [8166876aadef] xfs: don't decrement the buffer LRU count for in-use buffers

Hans Holmberg (1):
      [181ea4e2de42] xfs: start gc on zonegc_low_space attribute updates

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c  |  13 +--
 fs/xfs/libxfs/xfs_ag.h  |   2 -
 fs/xfs/xfs_buf.c        | 235 +++++++++++++++++-------------------------------
 fs/xfs/xfs_buf.h        |  20 +----
 fs/xfs/xfs_buf_mem.c    |  11 +--
 fs/xfs/xfs_sysfs.c      |   7 +-
 fs/xfs/xfs_trace.h      |  10 +--
 fs/xfs/xfs_zone_alloc.h |   4 +
 fs/xfs/xfs_zone_gc.c    |  17 ++++
 9 files changed, 119 insertions(+), 200 deletions(-)
