Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F472E7F2C
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781253725; cv=none; b=REuqj9FOISIw6l0FaKe97RKtMMm8isFaepK5qAgGQrreENKePtQBDCxlQ1cGR1ylIzUQXAf9Souk16aNe6Qv5xmtQpiafa5wuiPI6reL9+jCYlGoGmtQRTNt5VPlaDRJ/C/JqQiC77nufBsCtv3P4qjy6U6TfUNne0gs+E2Nebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781253725; c=relaxed/simple;
	bh=esxlZFlifu9wmtAGO80MtoAqZFXqfUUR7O1zbPjK/x0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UhgdSiGINz3lMZ4Hgj2L02dPorDS1OEIGAmOVFU+LAX01F3+ZysIjN9cK8ATtXrUd/N+H3Klhx4P5hIDNTcdbmBIEfpYq5EaFleL0U+ew25xkPqrLZCSozun2EX+06BZJpreg7Yr10FwjlemWRRlyNelRwArAmYunuZzO0pRgGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTIFHxNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTIFHxNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5635F1F00A3F
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 08:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781253723;
	bh=quB8mvIKvzJe70bR4s2kfiUVuVVyq5Hc5ZGKneIYGEo=;
	h=Date:From:To:Subject;
	b=HTIFHxNxEAllQL9d31DfQ4xYpWHdMTpmy27pktaJi8e0suBP0WB3eTBzhjI7bZxuA
	 f+qtFWqu6E03gb9Y5LnO59rn/L1pHufKamGIKAi5sXwkqFuXvVVGd3/y9uzFZWbQEb
	 BwCjJ2CYYBwOQvVnJs1u7+zPHu/i6vofq5NHb5onV4ZkPZrpsRkXbJ1foRrGqu+MkQ
	 faKDPn9VzcSW25jphhIQvGOsLflXs2e0D8IIATTkV09HZUxTpcdNziqx011fAQrB0O
	 5DJ2QUxD8ahicz94Wlp8rubU/6FGvB4zYt2zjG17Fh76D46gJUVkxo/AecjvHA56vp
	 VTRKUSwZkjPCw==
Date: Fri, 12 Jun 2026 10:42:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 804826eac53c
Message-ID: <aivFQIqgE5nCg0oq@nidhogg.toxiclabs.cc>
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

This is the last batch of patches for 7.2 merge window unless something
urgent appears (or I missed something important).

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

804826eac53c xfs: shut down the filesystem on a failed mount

4 new commits:

Christoph Hellwig (1):
      [202ff980a464] xfs: move XFS_LSN_CMP to xfs_log_format.h

Mikhail Lobanov (2):
      [07e2939ddab8] xfs: skip inode inactivation on a shut down mount
      [804826eac53c] xfs: shut down the filesystem on a failed mount

Yao Sang (1):
      [f4f28ffe0924] xfs: shut down zoned file systems on writeback errors

Code Diffstat:

 fs/xfs/libxfs/xfs_log_format.h | 13 +++++++++++++
 fs/xfs/libxfs/xfs_parent.c     |  1 -
 fs/xfs/xfs_aops.c              | 11 +++++++++++
 fs/xfs/xfs_inode.c             | 17 +++++++++++++++--
 fs/xfs/xfs_log.h               | 17 -----------------
 fs/xfs/xfs_mount.c             | 16 ++++++++++++----
 6 files changed, 51 insertions(+), 24 deletions(-)
