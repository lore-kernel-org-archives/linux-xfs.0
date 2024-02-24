Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84321870
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738231; cv=none; b=JCdpbTEC0rDC4acJQt/AePQE+rTpe0/31QNiy5oa0VEkzYsW+yG8A3ljnMiNbT9cFMocOMm6PP8XB/MHoo2zll87jhEth0TL9ZGwEpqAmOL8QOArz5b/9kgtBP63NXIrBEBgUImow7/9Lc4cWOCN5AWSg1XaPgQs51dNjQJFsX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738231; c=relaxed/simple;
	bh=OQG7RsKBnTatW66q/BKNCY4aBCB578bMo13ZMk6COEc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=N9qfkeaaXItQPhx5tzqJmlwPc4MMiEdYZ6ugCSZ1m9aX0zaMj8AjLD2rfUYyTfT/8T/IFyMaWWvcyKxgCaXOY2hkM0omeW8kssmmtUyHzHRvvsQnG89ScGFnr7rdK92Ar7Rghe41EgSK5HGCr2v7BKk+3AS7UopC2yzhYv658BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NU3+NN6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NU3+NN6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6795C433C7;
	Sat, 24 Feb 2024 01:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738231;
	bh=OQG7RsKBnTatW66q/BKNCY4aBCB578bMo13ZMk6COEc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NU3+NN6C9tZgRDW1rEbZsRWj9gVaGdVkSnOR8wHFltc5YNHsG2CWpDiyNJUHp12fR
	 dYs/N2wqO04lKFDOuq/itqfWrcc8AM48+9Nvwld9ve/wgmO0ckwBJgmutFmLcjNU+x
	 yPCbga+gb7LAolwmYXtc5Mqwk8z78hWFlTUu/NVFaa3C19xzIZI4tGp2tlYlNEODK+
	 Jz3TrORD/IJJXtYRmhJkMHMBFuVEDzFYcVicoZ4XxfWkUCcwln+bTou5NHq9785VX/
	 8IHMTtf1IM8l+NjzXSXir/rJxcBHbqcDIf/uw2FHy2v/Ij/1emKtJZ85Io1kMMbKw1
	 /JxrR9ZZpv0KA==
Date: Fri, 23 Feb 2024 17:30:31 -0800
Subject: [GIT PULL 6/18] xfs: online repair for fs summary counters
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873802501.1891722.17210275939815856680.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit a1f3e0cca41036c3c66abb6a2ed8fedc214e9a4c:

xfs: update health status if we get a clean bill of health (2024-02-22 12:33:04 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-fscounters-6.9_2024-02-23

for you to fetch changes up to 4ed080cd7cb077bbb4b64f0712be1618c9d55a0d:

xfs: repair summary counters (2024-02-22 12:33:05 -0800)

----------------------------------------------------------------
xfs: online repair for fs summary counters [v29.3 06/18]

A longstanding deficiency in the online fs summary counter scrubbing
code is that it hasn't any means to quiesce the incore percpu counters
while it's running.  There is no way to coordinate with other threads
are reserving or freeing free space simultaneously, which leads to false
error reports.  Right now, if the discrepancy is large, we just sort of
shrug and bail out with an incomplete flag, but this is lame.

For repair activity, we actually /do/ need to stabilize the counters to
get an accurate reading and install it in the percpu counter.  To
improve the former and enable the latter, allow the fscounters online
fsck code to perform an exclusive mini-freeze on the filesystem.  The
exclusivity prevents userspace from thawing while we're running, and the
mini-freeze means that we don't wait for the log to quiesce, which will
make both speedier.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: repair summary counters

fs/xfs/Makefile                  |  1 +
fs/xfs/scrub/fscounters.c        | 27 +++++++--------
fs/xfs/scrub/fscounters.h        | 20 +++++++++++
fs/xfs/scrub/fscounters_repair.c | 72 ++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/repair.h            |  2 ++
fs/xfs/scrub/scrub.c             |  2 +-
fs/xfs/scrub/trace.c             |  1 +
fs/xfs/scrub/trace.h             | 21 +++++++++---
8 files changed, 128 insertions(+), 18 deletions(-)
create mode 100644 fs/xfs/scrub/fscounters.h
create mode 100644 fs/xfs/scrub/fscounters_repair.c

