Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFAD653
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298697; cv=none; b=VI0gNwCIdjnfoS1D+9un0Eq6m+MCNi/y8HKatzQCZq6x7IUNctK4BJ05nvInL+LA2AVZx7ejU4tpQF7ymKWeME8uJm9qV7R8O/AZXIn3Iq+FuhtMj0uwybCoj7sGxoHSUXn8FXHG5HnHaTkr+BHGzX1HB473nnGJTQd8sPmyKBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298697; c=relaxed/simple;
	bh=wzVLRpKjDtxp+OTRFUazT538O4fWi/Qfq9+oPox+8fE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ni/YA4bJsz5T3DJa/4nO0GwWrKfxiu3ikfC6BmGriESWW459NV7a46UX7mPSR7GAcNU4+zBupAHHHo/1UNl+Vgu/SnKCzaGay5BZLEIMk+eV17BDd6iwaBJJB1Q8fXbbHDm/slbOAM+8tggQMqqJRxL0Ue3wUTat2oORCl6C/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aV5Oim5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aV5Oim5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AE4C32786;
	Tue, 30 Jul 2024 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298697;
	bh=wzVLRpKjDtxp+OTRFUazT538O4fWi/Qfq9+oPox+8fE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aV5Oim5sosvWrNB1/OXa6HQ4Ex9tmRbt9TpI7+4RkZz3TmWUEY9MdzsjH+ilYPFXd
	 0w0BA8CWE+WNYpgWj1rQY3+6McpK86qY52WBpP9dHMzvvRrBoElCuqS8s62QbT5tts
	 T89K3NbhZvdBOwp67dqzSedvMAH7nNRMngZLhzePPCzCU7qKXFJnLcEit0tjLSbIfU
	 stTEap82kxQ1b4b6zN/vPRm+SLw14qsQK0hrDgoXZ0Djli5dbeM+PZoDRK0sXmGkfP
	 JrRfOb5Vdt2X6lOcKNv/3eXL1icmFst3QvASYP6F2lpbuKL3HOIOwzegGw6xyaxO6b
	 Ng6pFxCStqubw==
Date: Mon, 29 Jul 2024 17:18:17 -0700
Subject: [PATCHSET v30.9 07/23] xfs_scrub: improve warnings about difficult
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

While I was poking through the QA results for xfs_scrub, I noticed that
it doesn't warn the user when the primary and secondary realtime
metadata are so out of whack that the chances of a successful repair are
not so high.  I decided that it was worth refactoring the scrub code a
bit so that we could warn the user about these types of things, and
ended up refactoring unnecessary helpers out of existence and fixing
other reporting gaps.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-better-repair-warnings-6.10
---
Commits in this patchset:
 * xfs_scrub: fix missing scrub coverage for broken inodes
 * xfs_scrub: collapse trivial superblock scrub helpers
 * xfs_scrub: get rid of trivial fs metadata scanner helpers
 * xfs_scrub: split up the mustfix repairs and difficulty assessment functions
 * xfs_scrub: add missing repair types to the mustfix and difficulty assessment
 * xfs_scrub: any inconsistency in metadata should trigger difficulty warnings
 * xfs_scrub: warn about difficult repairs to rt and quota metadata
 * xfs_scrub: enable users to bump information messages to warnings
---
 man/man8/xfs_scrub.8 |   19 ++++++++++++++++++
 scrub/common.c       |    2 ++
 scrub/phase1.c       |    2 +-
 scrub/phase2.c       |   53 +++++++++++++++++++++++++++++++-------------------
 scrub/phase3.c       |   21 ++++++++++++++++----
 scrub/phase4.c       |    9 +++++---
 scrub/phase5.c       |   15 +++++++-------
 scrub/repair.c       |   47 ++++++++++++++++++++++++++++++++++----------
 scrub/repair.h       |   10 +++++++--
 scrub/scrub.c        |   52 +------------------------------------------------
 scrub/scrub.h        |    7 ++-----
 scrub/xfs_scrub.c    |   45 ++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.h    |    1 +
 13 files changed, 175 insertions(+), 108 deletions(-)

