Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DD418C36
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504120; cv=none; b=rDbdsRBRQfAEhjsYN/sGnGX2E1zpevDXtC5umrBqxvTl19KkVooVGHrnNG46n1L0DoBC63HhMHPHx9wHaVs3OPt11LMQkfqOYc6CB2CuKtfG8Wb4IjdcL6ORhu7wVw6sm/8h6BPjuJlWiS4wkcJFeUmAR8mO71c6iPzk2u1pAAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504120; c=relaxed/simple;
	bh=D6/lUZrQ2EATIuSX4bwDZeqbn9pTnpUe55nwxpm3Tt4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UtASfRas8lXYBivIvCeDL6vxnZ8Hof2mgoV6dUre2ys978MKaz2IsLfqhkT5sgfLZsyVekQIKH77j5afhMBIjTKew5/bQK5a4P7dFL/Nz6hH4SMyoCU1Bj59IveZ5dqRXeXFrL1DkqM4X7ifkmF+m4aYAI1EFR4INQHRmzxjMoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8MGFQlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8MGFQlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3475C433C7;
	Wed, 27 Mar 2024 01:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504120;
	bh=D6/lUZrQ2EATIuSX4bwDZeqbn9pTnpUe55nwxpm3Tt4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L8MGFQlZDtd7luxSLpDOYF8qYliKXWFvc7pjCk4L5e5oLiVYXvb+qM671W3zORAFl
	 ZoGHTJTCE4p+iMGVsS38cFgblNujNUPO4Ep1F7I9wvscseaIM21P4NCi2z0dQypUuV
	 U8hMEQvw6gFC8+wPsCt+/Ky3ib8pvyL2QWh+kOjy2/qFwUNTs9XG5N3bfc2TXSYGaS
	 PUAP//6NQhfECDWAew4mZ52aSXsC1Jddmf6Y2DBXTPtCS3F295eFAw/efoTDH2rtqT
	 8NYNZ69WaZJcbSMKDwH7TTUUL6HWKXR7FRxwXLOPSgMzQszYIdhShB2K00NavfaH+k
	 vMd71uurJUIMw==
Date: Tue, 26 Mar 2024 18:48:39 -0700
Subject: [PATCHSET v30.1 09/15] xfs: online repair of inode unlinked state
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150383111.3217890.14975563638879707412.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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

