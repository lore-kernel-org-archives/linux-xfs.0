Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E371096F;
	Fri,  5 Sep 2025 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087941; cv=none; b=ST4D+CWtzjce6Hpc8FX2hc6ImuVnR3D3VMQAIhpZiihpL+ihYqyoqxOFIhCi4X3Dt6oN0Ew69s1Vq/isYdASzIhUa8CJ3vkUemJyTr2BnOA8PpmoAjIFe63Ys+RE8Liy4hCfrZIdRjKpaBa/F478bYF+ggIn9mTLUYEQCmd1G68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087941; c=relaxed/simple;
	bh=hIAotabxJDFefPkdBzhwJSfIdRyc+dj/8HFRNGKHQTE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=sdPpp7h3AisLkfrGqxZDmCHFfEzsq6A5H2XYMaJguPMt3PL2KhnS+14cRsLZZMRtMd5u9UhZeLm5eQqeqh7ywqLWrJg29UIjZMSPYa1gnZCJf5XmSvr1wF+77BC6iSwrP2b0YfMzkgcdDjbs4nTd/qdAtlNR7/LTK1pNe4Ylh8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9br9pwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9br9pwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E70C4CEF4;
	Fri,  5 Sep 2025 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087941;
	bh=hIAotabxJDFefPkdBzhwJSfIdRyc+dj/8HFRNGKHQTE=;
	h=Date:Subject:From:To:Cc:From;
	b=k9br9pwAHdI6gX2HyQ2ggbI0OciK88gtZSt+3G8NoXUqNOFZ2fsbPkaumwkWtLENS
	 B2sfCMQdJA+YrBTzu7dFM/XeMB9U67JqSBpPG0VVr+8Kqmpug+YUl8udeSXtHLTKQy
	 JxWgY68g7Td1S8KO4ejhjfE/q3X6z6IddNLg5tTaM4NAjfqoxxHcNDZQaIFeXaZh/z
	 yxNHDY/HHhq97L0kjV9OTle29vH6uDWuBITjQoscWJaOEx0c2OiykY75M4LYcC/c6R
	 ocU8O8PLqOjOg/17m6hIqYBJyLoBmZYswIjCFvqt+lz1uKt6wQdyFY9shrCEXCKys/
	 +Oiq44EldohFA==
Date: Fri, 05 Sep 2025 08:59:00 -0700
Subject: [GIT PULL 6.18 1/2] xfs: improve online repair reap calculations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Message-ID: <175708766712.3403120.15088787175440332819.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit b320789d6883cc00ac78ce83bccbfe7ed58afcf0:

Linux 6.17-rc4 (2025-08-31 15:33:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-scrub-reap-calculations_2025-09-05

for you to fetch changes up to 07c34f8cef69cb8eeef69c18d6cf0c04fbee3cb3:

xfs: use deferred reaping for data device cow extents (2025-09-05 08:48:23 -0700)

----------------------------------------------------------------
xfs: improve online repair reap calculations [6.18 v2 1/2]

A few months ago, the multi-fsblock untorn writes patchset added a bunch
of log intent item helper functions to estimate the number of intent
items that could be added to a particular transaction.  Those helpers
enabled us to compute a safe upper bound on the number of blocks that
could be written in an untorn fashion with filesystem-provided out of
place writes.

Currently, the online fsck code employs static limits on the number of
intent items that it's willing to accrue to a single transaction when
it's trying to reap what it thinks are the old blocks from a corrupt
structure.  There have been no problems reported with this approach
after years of testing, but static limits are scary and gross because
overestimating the intent item limit could result in transaction
overflows and dead filesystems; and underestimating causes unnecessary
overhead.

This series uses the new log intent item size helpers to estimate the
limits dynamically based on worst-case per-block repair work vs. the
size of the scrub transaction.  After several months of testing this,
there don't seem to be any problems here either.

v2: rearrange patches, add review tags

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (9):
xfs: use deferred intent items for reaping crosslinked blocks
xfs: prepare reaping code for dynamic limits
xfs: convert the ifork reap code to use xreap_state
xfs: compute per-AG extent reap limits dynamically
xfs: compute data device CoW staging extent reap limits dynamically
xfs: compute realtime device CoW staging extent reap limits dynamically
xfs: compute file mapping reap limits dynamically
xfs: remove static reap limits from repair.h
xfs: use deferred reaping for data device cow extents

fs/xfs/scrub/repair.h |   8 -
fs/xfs/scrub/trace.h  |  45 ++++
fs/xfs/scrub/newbt.c  |   9 +
fs/xfs/scrub/reap.c   | 622 ++++++++++++++++++++++++++++++++++++++++----------
fs/xfs/scrub/trace.c  |   1 +
5 files changed, 554 insertions(+), 131 deletions(-)

