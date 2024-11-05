Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5754149C53
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850745; cv=none; b=ts+ofTv+J0sG1HeyvNdFgOSofIHS84bM/SUc/PMU35GJGWETkAEaU6Ibt5v4pYXVxxUR2h5IvYHvY7JSs8L0JE0Qr5RdoTzjGU/esjXylNYIzXsQ9GhPhw/FjyxsLxKOs11fo44ZHGC9FxXswG7tyFpia6VNfhS7A3AWeUwsGs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850745; c=relaxed/simple;
	bh=+OtOQiDV5O9nySeMJuygQhU6AsSqdXZbwR9LBK9wblg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=GJTWRPflT5Cc5adKUmGr2IDC3u4ABYeIZ7ynaQBsdeFH4Pkegn08umzq4fFT/bLQkB2ZYan+5bXMEByORt3uPJF/Z8M1uwV4NQmWfbTQ8TTYquLxHFIU1nfr2YvdBa8tcQeM/0Gulr8JYw8jHn0Ya5izRUlTcN0qXVj4DI19lAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EjVVk5TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EjVVk5TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BCFC4CECF;
	Tue,  5 Nov 2024 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850744;
	bh=+OtOQiDV5O9nySeMJuygQhU6AsSqdXZbwR9LBK9wblg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EjVVk5TUXEzncRRUucKv3RTY77F12lTYAGN3RoEUsvrLSai7vG54MWBE3yIiXNvzS
	 GAJDN+Wr7v0EgELb1DMoVT1jvHzPJaQeBM1YdkjOgExfirpT3p6hyGHTD9d12QoT1q
	 w+y25ULf/hKMR49pt5T09eDkTDcrgaYmxQrMZ8KKSAA5hhZlj8F5Mr7mazyxJhbvez
	 Rl6KLZU2F59ptgAUboTFYfBo4iABnzohEdQ9J9kHngtIT0H2cBj2koG4a39nTXTr8A
	 Xf+crdHRgbiO12NDgpu5rw/uWw4wiaihoEZ4KICvg4zkZ8y9zjVyUar9DuyRZz6LHv
	 +Et+eMgrvIq2w==
Date: Tue, 05 Nov 2024 15:52:23 -0800
Subject: [GIT PULL 09/10] xfs: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173085054684.1980968.3118969438406362583.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105234839.GL2386201@frogsfrogsfrogs>
References: <20241105234839.GL2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit edc038f7f3860911d4fc2574e63cedfe56603f1b:

xfs: enable realtime quota again (2024-11-05 13:38:46 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/metadir-6.13_2024-11-05

for you to fetch changes up to ea079efd365e60aa26efea24b57ced4c64640e75:

xfs: enable metadata directory feature (2024-11-05 13:38:46 -0800)

----------------------------------------------------------------
xfs: enable metadir [v5.5 09/10]

Actually enable this very large feature, which adds metadata directory
trees, allocation groups on the realtime volume, persistent quota
options, and quota for realtime files.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: update sb field checks when metadir is turned on
xfs: enable metadata directory feature

fs/xfs/libxfs/xfs_format.h |  3 ++-
fs/xfs/scrub/agheader.c    | 36 ++++++++++++++++++++++++------------
2 files changed, 26 insertions(+), 13 deletions(-)

