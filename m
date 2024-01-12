Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBE2110D
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 02:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5zXbIJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43346C433C7;
	Fri, 12 Jan 2024 02:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705025817;
	bh=U+3fZN9mkpFj84/ufMJ8iuh3EsAUb59o3fxa5a+fL1s=;
	h=Date:Subject:From:To:Cc:From;
	b=T5zXbIJXY3IugHH+lZFs8+Z1s/VohSe+eyorFwBHaJbqdgWv832Bg8FB9tZqlB53r
	 hTRbu5obrLs4YrXYPI7dX8rauxMilQtjN+iQJOFvgRHZVCv/P+iMJ6dv61x0Jly9z0
	 9nJxG2rnh71bfg0swmcqdpZVJqmXEOS2dumBb0QfkjS0PF5BT4EMe2dTWqD41Uylpx
	 CFt2q53jWdlLRQLZDiYoIe38VOeLsLT4+Oksbz3kMkc2WO/kUgcT3b3ktBXbUqvDKh
	 ruFyrcKFNLHYGcAr6q0wXV+iFU5rliT4BeJemaBzyHDjc9fhjWPxpe61RQww6rZ5BC
	 ZpXYh3GUh+5yA==
Date: Thu, 11 Jan 2024 18:16:56 -0800
Subject: [GIT PULL 3/6] xfs_scrub: fixes to the repair code
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170502573357.996574.18197732259576686299.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 52520522199efa984dcf172a3eb8d835b93e324e:

xfs_scrub: update copyright years for scrub/ files (2024-01-11 18:08:46 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-repair-fixes-6.6_2024-01-11

for you to fetch changes up to 96ac83c88e01ff7f59563ff76a96e555477c8637:

xfs_scrub: don't report media errors for space with unknowable owner (2024-01-11 18:08:46 -0800)

----------------------------------------------------------------
xfs_scrub: fixes to the repair code [v28.3 3/6]

Now that we've landed the new kernel code, it's time to reorganize the
xfs_scrub code that handles repairs.  Clean up various naming warts and
misleading error messages.  Move the repair code to scrub/repair.c as
the first step.  Then, fix various issues in the repair code before we
start reorganizing things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs_scrub: flush stdout after printing to it
xfs_scrub: don't report media errors for space with unknowable owner

scrub/phase6.c    | 13 ++++++++++++-
scrub/xfs_scrub.c |  2 ++
2 files changed, 14 insertions(+), 1 deletion(-)

