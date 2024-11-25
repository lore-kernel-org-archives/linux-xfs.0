Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F59E2AD17
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 10:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732530085; cv=none; b=t+807BMV/jNIeB7Su78wM6Yv0EaZ/txtM0Ah7eIHEtZoTk5rx9C9YwCj5mi6xhw8EjSJn+vFmHV5eeGiQAB5hosalxkKQIKG8+S1K2iLeTr8+RBJsSC9BPgdYlbI7mOEuikvxH3oeFzx7POzhkQ+ch2MYr4x9ztdga9FoW/gp2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732530085; c=relaxed/simple;
	bh=Nh6cZlDG38Iff60G2n4db5yciQGO+DCp1B4a0cx9lmE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SCIzgHhtsJqzozd5LEvfzD2Go4//jU6+Mkzsyx1FwFOsGJ00rFs+WDGfsbMvockl19pabbLlyIulAP5c0GXs5WDcAt1kfppUduJCaFQJoROC/XNqBFck4nLPbUdHQvOLJFILGaM5COEXkyhE6e8jSYqIXZmSFNCKFaMivvoJKV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKulxT/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKulxT/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AADC4CECE
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 10:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732530084;
	bh=Nh6cZlDG38Iff60G2n4db5yciQGO+DCp1B4a0cx9lmE=;
	h=Date:From:To:Subject:From;
	b=OKulxT/OfwaUSCKovFlb9PUDZPdaf5FNiN3YzEZ3FFZ9kjYQpyRs/AL1bGztJYK80
	 zsSIyK57MhHTLjqKpLCZBio64VkjuO/Vvj/IwfO9QuDxjPCYvfCsfL5B85hVtXAXDd
	 bgcC3JV0rlusuOvbt61k6WUN/kpT3CsXU1ngkGJOfHl8itiXo3gLbK5qEFB6zX4cuA
	 3Iu/s1xdoKNswkNleSK3FZfyh3huT1mQgqHmu4oFTDu4zcUSfSSptrTwcOSYw5myb9
	 +aNxPnLP7RE2FT1Jz39xACPYIQNUzGFrA8Bm5dKUfpIvlu/9VQDLAZIEHW/PUAXMxi
	 sE86oSzDxWfYQ==
Date: Mon, 25 Nov 2024 11:21:21 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 409477af604f
Message-ID: <mfaxiwa67ghklnysus4hzydvm5sydgzyswndx7zhzonvevcnum@7dhoxywuexhl>
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

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

409477af604f465169be9b2cbe259fe382f052ae

4 new commits:

Catherine Hoang (1):
      [409477af604f] xfs_io: add support for atomic write statx fields

Chi Zhiling (1):
      [0cc807347d5a] xfs: Reduce unnecessary searches when searching for the best extents

Darrick J. Wong (2):
      [2c054ce65a40] xfs_repair: fix crasher in pf_queuing_worker
      [09f319213924] xfs_repair: synthesize incore inode tree records when required

Code Diffstat:

 configure.ac          |  1 +
 include/builddefs.in  |  4 ++++
 io/stat.c             |  7 +++++++
 io/statx.h            | 23 ++++++++++++++++++++++-
 libxfs/xfs_alloc.c    |  2 +-
 m4/package_libcdev.m4 | 20 ++++++++++++++++++++
 repair/dino_chunks.c  | 28 ++++++++++++++++++++++++++++
 repair/prefetch.c     |  2 ++
 8 files changed, 85 insertions(+), 2 deletions(-)
