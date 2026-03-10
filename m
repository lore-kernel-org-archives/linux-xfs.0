Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A602AD3D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773113092; cv=none; b=Pd4TnasnyJLzM6ipNUC0MitrQMtmEV3i6dkFO+xFa0Pymgv7VluJWhMipysLvHoGUatKeqIK1QgiXr2S/hgqtPlZ1Bdd2ZtdiVZTBnUXPz4Vff20Vz6C706na7tRaqTrMrEtr+6iG8ay68XdcLaHnk0I2gbImGP1/IoAEJdm40k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773113092; c=relaxed/simple;
	bh=qWgopt05Y2oEdel2Wr2v+8V7DLKfiOKNmYLfjDTIoyg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=tsNN7A5oF7kGnZdklWv6MYxGbQFYzrCUrV16tZhTunjzhMHXrneQMzWXSnRCXFtj1PwCW2KLQOWt9xuHB7uEkrK1M0bvXPt2zoa2tfWT4hrAF3NYY61AvQevuuME/cJCsOnAYMdxR1hGHcN27RmujJgBtPLmzztFQJcj0DodUfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovS0t0zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovS0t0zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D773C4CEF7;
	Tue, 10 Mar 2026 03:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773113092;
	bh=qWgopt05Y2oEdel2Wr2v+8V7DLKfiOKNmYLfjDTIoyg=;
	h=Date:Subject:From:To:Cc:From;
	b=ovS0t0zfwHz5jF4z4QkOQkhQw6+2W2lfOF0PizeR1lcgHUpMSpoOaecE1mBiB72ZF
	 S4R/vMHpNB8ENhHoG3WcxW5PMyJ8yzS6moIjMXEEd3SdoNNxWzjGwWHgB83mCje/AE
	 5oFqDPDZcHWXAnl1UsJLWs0EH5L5R6pwiHJ1UAT/x/HhQVUqnULomVgZfneHD+O1ux
	 iiOhqwFfrfKLj441xeYFiJKlIXnRjk07xWch4ebNkrPA9VUrlX0/0eqgVXqmJ4YlgA
	 b5ZG0oa24tqG73mtPCfOeO9egHYioxN/bYUsAEHla6e4STIoE0gf0ujXK1bIMpFQNT
	 ALf8K4Rq84vNQ==
Date: Mon, 09 Mar 2026 20:24:50 -0700
Subject: [PATCHSET v2] xfsprogs: various bug fixes for 6.19
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This is miscellaneous bugfixes.

v2: fix the external log sunit handling

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

Unreviewed patches in this series:
[PATCHSET v2] xfsprogs: various bug fixes for 6.19
  [PATCH 4/4] mkfs: fix log sunit automatic configuration

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * misc: fix a few memory leaks
 * libxfs: fix data corruption bug in libxfs_file_write
 * mkfs: fix protofile data corruption when in/out file block sizes don't match
 * mkfs: fix log sunit automatic configuration
---
 libxfs/util.c   |    5 +++--
 mkfs/proto.c    |   28 ++++++++++++++++++----------
 mkfs/xfs_mkfs.c |   29 ++++++++++++++++++-----------
 3 files changed, 39 insertions(+), 23 deletions(-)

