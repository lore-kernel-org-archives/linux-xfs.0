Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337460;
	b=mH7tigZ9EuCCkpu9yvH7nEFQMzxQr0RzoryCdm9Z9hVbemJYvVqPHI3vaqGlRk61cFcp
	 J0PRmRFRSWXoHJoERB75XYeK8ZDnxHPrYCcoktQwwOdhvbv+WaTFNRUnGsoVfSECu3gO5
	 AZQfY+uPoW/duefP0iOaNF6njAJrFp1D3eMEI3bwsHYm4YQ/Yr5FHywKiGoICFiCXKqh2
	 IcR/nF5fvgY4AjdSR/5krjSuMeL5vU/EQRrLzkmTh3pWwyDDkIb1He2GglGVjLA7YiFem
	 D9Xdwf/+Fp/3EHe1+0wTzZS4aKt8Upq/FUqu+A86NmmiY1LqWz7Y+M4jnK/f37fXZBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337460;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=EnnxGoeGYm0FUifkifY9nHaG5KtKkTzcDn7h3Fya62I=;
	b=zOwJzVP8+6fUQMgoMRLGkINI+UA1Nzb7gJinJzLoXTe2mUJES61h1GEAU1pz8L6Rj0wv
	 tvPDwnUgoSVHwrLkubWT9BRLIrr1UzeG/Hou0qqbRj6P21KGWVpgF2JIxjmDVz92aO0w2
	 ndxBBwKlsfYKIu9GfX5o7t5orAzzwRlU42ROkV+8xm0LpnHTujCgx4ESA4pZ+Y1O6drlm
	 tzbCUCIzJhKhvYsoN63E6nNIcveJj+/DNaGLowqJeZHQKuZPOoEqhkcUC+kMH9D8j5wdp
	 ymDlN1W+QMSJMNew7FkCKiHOoVpI8BMfb7UsKZTmXZ0UiGq30wGaX+08mSpGdsrwG8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI9zv8nr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867FF606A321;
	Tue, 10 Nov 2026 19:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI9zv8nr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35D51F0089F;
	Tue, 10 Nov 2026 19:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337460;
	bh=EnnxGoeGYm0FUifkifY9nHaG5KtKkTzcDn7h3Fya62I=;
	h=From:To:Subject:Date;
	b=VI9zv8nrU3+0aOqIagM3RbUZ0jV8Yp6HBWHBrJR+XQmNfseHwTnBx+3FULa032Hnb
	 0+3WzZjGTn8KR+uXvI/SYl5PLy57Ix2LFWJNjv5wBtdDJoZe3ELjJGX1ULcSVymkcc
	 xBr+EVfx/sgAN8zXfdRZS6PEKRMAy2oX5TtSW4kVC2ZKg3CFGk0fnQDQoLbquY4FFA
	 rPUHCSTmBG6i9uJZVZCMcxBgf4v0r8CnCbs6re6qa5Zee1Hos0LUf6hZ+d1zSIM4bn
	 4ujldYnHMC1azkYz8vOWXvz9+xRr2ODf8rRJfXs8hzmyWJjfPMS6cfK942ODo9G/YG
	 YZmfBJ+sJVStw==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v7 00/11] reflink and atomic write bugs
Date: Tue, 10 Nov 2026 14:04:17 -0500
Message-ID: <20261110190417.32650-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series did a few rounds privately, but looks ready for the list
now.  Carlos has accepted patches 1-4, but I've kept them here so the
whole series can still be tested.

Except for Christoph's patch, these were all found and fixed
by an LLM.

The meat of the series is fixing reflink corner cases that incorrectly
let you write into the source of a reflink.  LLMs also tripped over a
few ways to use atomic writes to expose stale blocks on the drive, and a
few races with realtime flag manipulations.

v6->v7:

Sashiko noticed a few pre-existing corners that I had ignored, so we
have 3 additional patches dealing with races between FS_IOC_FSSETXATTR
and decisions about file writes.

"xfs: restart faults racing with realtime flag changes" changed enough
that I dropped Christoph's review.

Chris Mason (10):
  xfs: don't skip the flush before shifting extents
  xfs: flush the shifted range before changing the file
  xfs: don't change the block map under a dirty folio
  iomap: don't punch delalloc under a dirty EOF block
  fs: validate atomic writes after O_APPEND and limits
  xfs: recheck direct write alignment after write checks
  xfs: test for reflink after the dio write checks
  xfs: test for always COW after the dio write checks
  xfs: refuse fallocate racing with realtime flag changes
  xfs: restart faults racing with realtime flag changes

Christoph Hellwig (1):
  xfs: refuse writes to files racing with realtime inode flag changes

 fs/ext4/file.c         |   4 -
 fs/iomap/buffered-io.c |  34 ++++++++-
 fs/read_write.c        |  13 ++++
 fs/xfs/xfs_bmap_util.c |  19 ++++-
 fs/xfs/xfs_file.c      | 167 ++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_iomap.c     |  40 +++++++++-
 fs/xfs/xfs_reflink.c   |   2 +-
 7 files changed, 230 insertions(+), 49 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
--
2.55.0

