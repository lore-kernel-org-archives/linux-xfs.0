Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25BC1B040B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 21:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531567; cv=none; b=qkWsf9NM12TlkBEwdqrAYF48ohrDivwKkfLgqPv+IJqGGTcbbeWE+zWgFaeUln/vH2q64AvpkSP4XjbsXjI4PDzgCeOw0fC+sBHHTgUWQR0lhGBuADHbB6mbEQWBbCurDPgqrMA1j9li+EuTx+RxLGjfplpJuPYWeacpgL6moBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531567; c=relaxed/simple;
	bh=aoia2jxoqN0OYflZ+t5TrSsk/2iB5DTiqbVUCIy9gAA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=uz0nWHBAor+q++1nTfN0xSWpCRbxtJax2yrcdRgizkpumu4wPkqn5Ybd5mmVjiZMWIF7NGz5cyh7pIUWHZnzoKxVD4cszmhgHjK3EzaL8ujjcqooXMay40JviG0Dkuf8In61B4gr0gCXgaiHtnsI1rtz719eIcyj9tr3xqcIkYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xv+yqwmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xv+yqwmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B30C4CEE3;
	Thu, 24 Apr 2025 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745531567;
	bh=aoia2jxoqN0OYflZ+t5TrSsk/2iB5DTiqbVUCIy9gAA=;
	h=Date:Subject:From:To:Cc:From;
	b=Xv+yqwmgiWORJtiqVRsDyocSpCI3b6kZyAVHgACx7LbReZk6AY1ec1r599A27F2JH
	 Z0Q619R6CTm/6JOPWU741sj7/m9jCMc1IRnrj0p/1Q1bAc0QMZnjnv7Xz+Tzm9jmR+
	 aatOBJJLKCxcwAE3gNfByguAT37SLg05S/Xf59XItYQlX8dxbf+bpUONxd7zJKWy/i
	 TSij9LEgrDuWEIb/1QZiH4kTRL+7o8TJhTV5q5rFPPVS9Dv5FyYpdFrdLB9jhNz2Gm
	 vVhn+o9DhvyWz77NK/rANLdpg95XEJ/M+lGTAHsW3GwrVa36+7lfcULQjCz1isB9fd
	 NAOW4+P/g7XCA==
Date: Thu, 24 Apr 2025 14:52:46 -0700
Subject: [PATCHSET] xfsprogs: random bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, ritesh.list@gmail.com, linux-xfs@vger.kernel.org
Message-ID: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a pile of assorted bug fixes from around the codebase.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

The only unreviewed patches are these:
  [PATCH 3/5] xfs_io: redefine what statx -m all does
  [PATCH 4/5] xfs_io: make statx mask parsing more generally useful

(I haven't seen a for-next push, so that's why I'm resending the other
accumulated fixes.  They haven't changed much.)

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes-6.15
---
Commits in this patchset:
 * man: fix missing cachestat manpage
 * xfs_io: catch statx fields up to 6.15
 * xfs_io: redefine what statx -m all does
 * xfs_io: make statx mask parsing more generally useful
 * mkfs: fix blkid probe API violations causing weird output
---
 io/statx.h            |   33 ++++++++++++
 io/stat.c             |  130 +++++++++++++++++++++++++++++++++++++++++++------
 libxfs/topology.c     |    3 +
 m4/package_libcdev.m4 |    2 -
 man/man8/xfs_io.8     |   17 ++++++
 5 files changed, 163 insertions(+), 22 deletions(-)

