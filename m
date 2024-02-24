Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD25625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738310; cv=none; b=tW3yTK7kbsShp7g5vtiXWljzkIDuGqzf2bbYqGiQaOm3+zMjVu/8sEmxWYenm9/m/fzr481p64MB1ikooHf+2SHPTO20wm+G8ceMqaeet1Q/tUekA5Iz1ZnfHvJ+MEQfTbMrvYD672n05NpAruzXzLKnjZQe8Pb7D1OH9VBEzXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738310; c=relaxed/simple;
	bh=pResZIT9N+Z3yPRkJ9mHr6/wyCdmZyUvyRAtV0JUd8E=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=U4/IzyQ6li5Zo/sVSUDfKmwCofheSbcRV38ri/3bvGeuG6TFpf1rusalJRELBE1EUxNfaQyfoBpUMS0JW9MzkqDFl/jfB1puxwaQj5gmQvQdL9GARb0bVnvzPDOt3QCZoqNREp9fsLm3+arXlTNd+EPNhSe+RqRoDigl6KrRhQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FiDyMGsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FiDyMGsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17E8C433F1;
	Sat, 24 Feb 2024 01:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738309;
	bh=pResZIT9N+Z3yPRkJ9mHr6/wyCdmZyUvyRAtV0JUd8E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FiDyMGszo/v7FN1w4UjqY14Vgm2jgXBG6dthbUtGM5+UPskEi/bvbFTNjc0sW9mqA
	 PxbWWKb4wpWoxaEUVL95r0y7U6ZW7HTtKrNYsEScFURp8wfd6BLKpuI25B2Lb4Kq3o
	 ghrxd7zQkRltUKksrGLYVhkmI7P7ASqYACbqqyoAbrLbfEneSnkOBF+sPiP17uHdZz
	 BA2gPPGWMCm7EHggUVBr+N62bzS191YM7VfEFpxcrkabHLz4D2U3I0GsEXdvCl0xpS
	 hPeoX2EQbytoPa8WU2l7jS2xT6p9DNhgU9xFEjunkLsGQKG3ITJu/iyPifeMKrilHd
	 bgdCCvpE2zWXA==
Date: Fri, 23 Feb 2024 17:31:49 -0800
Subject: [GIT PULL 11/18] xfs: buftarg cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873804706.1891722.8290634043484810651.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 24f755e4854e0fddb78d18f610bf1b5cb61db520:

xfs: split xfs_buf_rele for cached vs uncached buffers (2024-02-22 12:41:02 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/buftarg-cleanups-6.9_2024-02-23

for you to fetch changes up to 1c51ac0998ed9baaca3ac75c0083b4c3b4d993ef:

xfs: move setting bt_logical_sectorsize out of xfs_setsize_buftarg (2024-02-22 12:42:45 -0800)

----------------------------------------------------------------
xfs: buftarg cleanups [v29.3 11/18]

Clean up the buffer target code in preparation for adding the ability to
target tmpfs files.  That will enable the creation of in memory btrees.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (3):
xfs: remove the xfs_buftarg_t typedef
xfs: remove xfs_setsize_buftarg_early
xfs: move setting bt_logical_sectorsize out of xfs_setsize_buftarg

fs/xfs/xfs_buf.c   | 34 +++++++++++++---------------------
fs/xfs/xfs_buf.h   |  4 ++--
fs/xfs/xfs_log.c   | 14 +++++++-------
fs/xfs/xfs_mount.h |  6 +++---
4 files changed, 25 insertions(+), 33 deletions(-)

