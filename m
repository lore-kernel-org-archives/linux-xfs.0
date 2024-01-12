Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F51B110D
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 02:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRjeynqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1171DC433C7;
	Fri, 12 Jan 2024 02:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705025786;
	bh=GmZeOXF3k83Xj43hy2Logx9/rJOJUv/QjwOociPIYCE=;
	h=Date:Subject:From:To:Cc:From;
	b=DRjeynqsFnQOzCaseKV1guMNV/L7ZQSewnnev7UWUY0kyU4uT4GMtxBGOvKgxnQN/
	 fzBnsqt0LZRcZjDCHi8686YYHl3WTffYQNjHbimpf2LqjeXX618Dk/ihJdfYPBPKEW
	 9nberxhUqcbp5KMmmSbVuFymdfdraSVTsLoWcD029CPBEkv8lBEkQMgVdRAF4K6E+C
	 oVROUkCwJQno6GmSfFpMeygiIhkLlVS64IJfQoBccwtrHE7YOMQ2Wr+kvSQBz/7UC2
	 3T4/RgYygeAO9M2Px9OGhnRC1ftiomwyQqUKhVogIgcotiJmx0IO2QcNVJm4BTu4dx
	 IAeat4gOrJFBQ==
Date: Thu, 11 Jan 2024 18:16:25 -0800
Subject: [GIT PULL 1/6] xfsprogs: various bug fixes for 6.6
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170502573166.996574.10606759915783984277.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit c2371fdd0ffeecb407969ad3e4e1d55f26e26407:

xfs_scrub: try to use XFS_SCRUB_IFLAG_FORCE_REBUILD (2023-12-21 18:29:14 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfsprogs-fixes-6.6_2024-01-11

for you to fetch changes up to 55021e7533bc55100f8ae0125aec513885cc5987:

libxfs: fix krealloc to allow freeing data (2024-01-11 18:07:03 -0800)

----------------------------------------------------------------
xfsprogs: various bug fixes for 6.6 [1/6]

This series fixes a couple of bugs that I found in the userspace support
libraries.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
libxfs: fix krealloc to allow freeing data

libxfs/kmem.c | 10 ++++++++++
1 file changed, 10 insertions(+)

