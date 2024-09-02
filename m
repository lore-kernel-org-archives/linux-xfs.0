Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27C019CC0F
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302524; cv=none; b=sFskgPFU7RBObUrLrJhI9vA4k2vmiEA3Ra1t7IPj0e1rLn1S8Coq6DsTzkZVA4d8MyMGd8wV0vi4Ep9JHsjLXHBUtqIO6QBJSPHTkwt4bDMS9YoTyOCdDm3bZ+O7/KZvMVwY/LrbLHZGe3FUuugsTqsFTZDXaZKJ+1Mv9HjQWPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302524; c=relaxed/simple;
	bh=MBjC4jXJ+mnmulNSa6RuhCMT9BZuhOr9GrbDu+YXsGU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=H0obw4Em4r3D/v6EDvqKBNBW8b0wCMLsSehRKbbKGuGZW8UX1eRrVQQ8PxYZl9ZEEfUsj2rSTwNieNbOPI3oY7IHD0I9V+gJFpnpGtifqIiQD/IG+tsteUvU+3mGa0cHIYChMg2GBBD/xn5bXTa+DcNyfhRnnmxMI6M3rwBCzP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StSlhDTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StSlhDTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7856EC4CEC2;
	Mon,  2 Sep 2024 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302524;
	bh=MBjC4jXJ+mnmulNSa6RuhCMT9BZuhOr9GrbDu+YXsGU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=StSlhDTBwamA7kewX5GMQ6KRySH3wH/Ni1MaWxoUbRIyd6OMcjW3cD8Vkl1Tv+cQc
	 HJWL6QEF5zLwUvLbaILdQhqptyXTFbkqA2B5ip+8PBpMD2zrD5BxLKTnWc2NN3QD0R
	 3gdn+R3kD8FNSztIUpBc2IwfS3s9F5rNNwtDqVZlg3bu0STH5iawkFva51LY4/3T6u
	 cIi/HpTBVxCoKzhdsdveaPtzZwPDEGBXtqHIm9EQZAwZnuXIYg9MIEvzWDbVpdTnVV
	 oaANM9Bte8EbiDYhKuczUdXG8q261d4vkEfug4axHY0Flpr5ZekcMyVhfEtV4J+59Z
	 31ojoW6IJMSAg==
Date: Mon, 02 Sep 2024 11:42:04 -0700
Subject: [GIT PULL 2/8] xfs: cleanups before adding metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172530248037.3348968.17440606333983461893.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240902184002.GY6224@frogsfrogsfrogs>
References: <20240902184002.GY6224@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 398597c3ef7fb1d8fa31491c8f4f3996cff45701:

xfs: introduce new file range commit ioctls (2024-09-01 08:58:19 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/metadir-cleanups-6.12_2024-09-02

for you to fetch changes up to 390b4775d6787706b1846f15623a68e576ec900c:

xfs: pass the icreate args object to xfs_dialloc (2024-09-01 08:58:19 -0700)

----------------------------------------------------------------
xfs: cleanups before adding metadata directories [v4.2 2/8]

Before we start adding code for metadata directory trees, let's clean up
some warts in the realtime bitmap code and the inode allocator code.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
xfs: match on the global RT inode numbers in xfs_is_metadata_inode

Darrick J. Wong (2):
xfs: validate inumber in xfs_iget
xfs: pass the icreate args object to xfs_dialloc

fs/xfs/libxfs/xfs_ialloc.c | 5 +++--
fs/xfs/libxfs/xfs_ialloc.h | 4 +++-
fs/xfs/scrub/tempfile.c    | 2 +-
fs/xfs/xfs_icache.c        | 2 +-
fs/xfs/xfs_inode.c         | 4 ++--
fs/xfs/xfs_inode.h         | 7 ++++---
fs/xfs/xfs_qm.c            | 2 +-
fs/xfs/xfs_symlink.c       | 2 +-
8 files changed, 16 insertions(+), 12 deletions(-)

