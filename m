Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4E517BB3
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000309; cv=none; b=VngClQBVgC068GofLZK9j5Ok4A1Z8Yeqel4/G4rFySwRxzjCpg14nfNCMPPMVcACZrnsl/28rL3udlaVI08GVMFe329dwKk1l0UcLCDzCDwiEfr4FZsddZ6cW7MtDU5in9MZwrMMJLroTrHdcEVUQ/f/JU09seRT/jaefbP44qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000309; c=relaxed/simple;
	bh=D6/lUZrQ2EATIuSX4bwDZeqbn9pTnpUe55nwxpm3Tt4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=apdbXudI1E9bWgsgGz1t+Ykp6XJ8eKe5ArZfUq45Zoqo0sCsLbPvhAQSxr6RyzHpi9C3rQAXi0WssQ3dILyzX5L/I2i7IHt1XNcRzxEG9GVohb/a0gcZ5LZLG/p2y6WCpn45inmM3E3/4Wu+UjvQ8JX2y8otZwP9d8EUENSYhSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQtPStkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQtPStkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D6FC433C7;
	Tue, 27 Feb 2024 02:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000309;
	bh=D6/lUZrQ2EATIuSX4bwDZeqbn9pTnpUe55nwxpm3Tt4=;
	h=Date:Subject:From:To:Cc:From;
	b=RQtPStkAghKHWa6O1p3QtsyNDGlJOH/q56byESehQsvbuFW7N2tlde/GgWDuBZ/iB
	 LB5RdQcdK/T+n/YKyHk7wgngU0KuQYpc6LyOSjFkxp5mnKIh47SpWqnHr11kj6mqDf
	 k9rF27F95hvm0gbfR3c35YKdVYm2+qcw5X4RNEP/c3I/D1TU7n06KEJ4Dp7/9qk12f
	 RWY/2z43CVG+CjsTXaij6YbPWPiLImtCz0L9zTX9CRFVss9FMIpN8BLUejDhLUTmRd
	 S/l4M3suKUb0NhRKQa64X/LTm2LHJ9NG1sls8Yjl1+jRC1wqMA1aJTKyC10+Q/qTYd
	 k+oALfa39rprQ==
Date: Mon, 26 Feb 2024 18:18:28 -0800
Subject: [PATCHSET v29.4 08/13] xfs: online repair of inode unlinked state
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900014056.939412.3163260522615205535.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series adds some logic to the inode scrubbers so that they can
detect and deal with consistency errors between the link count and the
per-inode unlinked list state.  The helpers needed to do this are
presented here because they are a prequisite for rebuildng directories,
since we need to get a rebuilt non-empty directory off the unlinked
list.

Note that this patchset does not provide comprehensive reconstruction of
the AGI unlinked list; that is coming in a subsequent patchset.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-unlinked-inode-state
---
Commits in this patchset:
 * xfs: ensure unlinked list state is consistent with nlink during scrub
 * xfs: update the unlinked list when repairing link counts
---
 fs/xfs/scrub/inode.c         |   19 ++++++++++++++++++
 fs/xfs/scrub/inode_repair.c  |   45 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks_repair.c |   42 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.c           |    5 +----
 fs/xfs/xfs_inode.h           |    2 ++
 5 files changed, 100 insertions(+), 13 deletions(-)

