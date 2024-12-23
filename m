Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E8E7462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995896; cv=none; b=qwag5GW1hwLXh+WwUBIdgdKYlH2+YYcICSClpMa+IsNNF4aqUzznnPwVJrIiDXFbzJ4Jlt+tw3A8JaF2E1aTdIE8H4li4ZliuVuKUOU8lBtHk8Y4/V6/CaJlh7s2gQWlkfWptNJfV4oGUi1SkuG6kM682yrm3cgFD1tv6LyDcHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995896; c=relaxed/simple;
	bh=IrGnXSFLU0ic85NWVsEzRJzFfHoLIUvZn8lwso30CY0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=U/M69i4cUK8TRlTKWduZSJyz22icJWlKoZdCXMWPPhi+rVzzDOiawZ+odePDZu3mqjdt7nkUkmO4o4Unjhb5zJfvWboNxpcdqt/oFW8yfyntJoUECpgOWc3Scqn/4e1v1sGckfQfnZIG/QspqsoqBXa6izM+3cv2r7zvu3zL5aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxDFDQBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxDFDQBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E27C4CED3;
	Mon, 23 Dec 2024 23:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995896;
	bh=IrGnXSFLU0ic85NWVsEzRJzFfHoLIUvZn8lwso30CY0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YxDFDQBBa5TbDW5E02xG7exxrSrczYmEv1ATbSZpNfEbnBA9HfnwTxbHDsqfnj7VH
	 qC/9g+tAcMhGVgl4BEhXGsrMouJD+vgGE5c9hORu2nc7Tyj/7VO3ZjSd9E4JymVnTG
	 UKydddLZGTN821lenuBsph2A8LORv4uqVtVokRQN2Gof3fUrQYXUnt+EjlfJsrDpVn
	 muXZmyiyzMAcubNQ2clu3/FJQjT0m0KC61N9DVT1cf6gpi5OA5n4ghOoyWghrm5Vkt
	 UsjWWSmvYsBipxazrgqYaR8+ZGAEgU+8hOfvzIwlp1l9GrPOIh2wKvHxi+uctcvOhj
	 8BRW/3zufwqyg==
Date: Mon, 23 Dec 2024 15:18:16 -0800
Subject: [GIT PULL 3/5] xfs: enable in-core block reservation for rt metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499428862.2382820.11178785771990555823.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223224906.GS6174@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 2f63b20b7a26c9a7c76ea5a6565ca38cd9e31282:

xfs: support storing records in the inode core root (2024-12-23 13:06:03 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/reserve-rt-metadata-space_2024-12-23

for you to fetch changes up to 05290bd5c6236b8ad659157edb36bd2d38f46d3e:

xfs: allow inode-based btrees to reserve space in the data device (2024-12-23 13:06:03 -0800)

----------------------------------------------------------------
xfs: enable in-core block reservation for rt metadata [v6.2 03/14]

In preparation for adding reverse mapping and refcounting to the
realtime device, enhance the metadir code to reserve free space for
btree shape changes as delayed allocation blocks.

This enables us to pre-allocate space for the rmap and refcount btrees
in the same manner as we do for the data device counterparts, which is
how we avoid ENOSPC failures when space is low but we've already
committed to a COW operation.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: prepare to reuse the dquot pointer space in struct xfs_inode
xfs: allow inode-based btrees to reserve space in the data device

fs/xfs/libxfs/xfs_ag_resv.c  |   3 +
fs/xfs/libxfs/xfs_attr.c     |   4 +-
fs/xfs/libxfs/xfs_bmap.c     |   4 +-
fs/xfs/libxfs/xfs_errortag.h |   4 +-
fs/xfs/libxfs/xfs_metadir.c  |   4 +
fs/xfs/libxfs/xfs_metafile.c | 205 +++++++++++++++++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_metafile.h |  11 +++
fs/xfs/libxfs/xfs_types.h    |   7 ++
fs/xfs/scrub/tempfile.c      |   1 +
fs/xfs/xfs_dquot.h           |   3 +
fs/xfs/xfs_error.c           |   3 +
fs/xfs/xfs_exchrange.c       |   3 +
fs/xfs/xfs_fsops.c           |  17 ++++
fs/xfs/xfs_inode.h           |  16 +++-
fs/xfs/xfs_mount.c           |  10 +++
fs/xfs/xfs_mount.h           |   1 +
fs/xfs/xfs_qm.c              |   2 +
fs/xfs/xfs_quota.h           |   5 --
fs/xfs/xfs_rtalloc.c         |  21 +++++
fs/xfs/xfs_rtalloc.h         |   5 ++
fs/xfs/xfs_trace.h           |  45 ++++++++++
fs/xfs/xfs_trans.c           |   4 +
fs/xfs/xfs_trans_dquot.c     |   8 +-
23 files changed, 367 insertions(+), 19 deletions(-)

