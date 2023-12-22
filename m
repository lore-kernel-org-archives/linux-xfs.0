Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F61D610A
	for <linux-xfs@vger.kernel.org>; Fri, 22 Dec 2023 02:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3YXOWT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B49C433C7;
	Fri, 22 Dec 2023 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703212301;
	bh=Jw+S7MURGb7wou6AkflWDE50UDmmk2FAdYbHWPFkOvA=;
	h=Date:Subject:From:To:Cc:From;
	b=Y3YXOWT0z75lRYvCEm2CzaqRlfPyw/6hxkfGKW0tKw0bDPDLafaCY52QeKNXtt+oX
	 pwQhPfmtbzzD9upZqfdr1KyZTQtWc1talgpKGzAW4TqJzzMKu0oF2jWNjLrD2MmOBv
	 5rW4M273C9qF1sxSfbhYvKNrxuNtkmQ0OmpcQB5VKs9t4yKSof2xrgtg2IQztmUAcf
	 9GAKM817T+BSNT99ySZDp+m6vZoa0oPyeE5/e5FjhzcLhsGfBeFFYrzBInSMQv8ozu
	 BK8+QvuprWeUvYGP9adRp2waNyP3CRyS7VECiBcg8dZn1MRgEzacItAhThRC2VfB2m
	 qmpDu78aRE/+g==
Date: Thu, 21 Dec 2023 18:31:41 -0800
Subject: [GIT PULL 3/4] xfs_io: clean up scrub subcommand code
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170321220791.2974519.12145964426991516998.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 2cbc52f5c9a9588e1e9c8e54c0435c121424fe5a:

xfs_mdrestore: refactor progress printing and sb fixup code (2023-12-21 18:29:14 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/io-scrub-cleanups-6.6_2023-12-21

for you to fetch changes up to 9de9b74046527423dfd4a5140e86d74af69ee895:

xfs_io: support passing the FORCE_REBUILD flag to online repair (2023-12-21 18:29:14 -0800)

----------------------------------------------------------------
xfs_io: clean up scrub subcommand code [v28.3 3/8]

This series cleans up the code in io/scrub.c so that argument parsing is
more straightforward and there are fewer indirections.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs_io: set exitcode = 1 on parsing errors in scrub/repair command
xfs_io: collapse trivial helpers
xfs_io: extract control number parsing routines
xfs_io: support passing the FORCE_REBUILD flag to online repair

io/scrub.c        | 259 +++++++++++++++++++++++++++++-------------------------
man/man8/xfs_io.8 |   3 +
2 files changed, 140 insertions(+), 122 deletions(-)

