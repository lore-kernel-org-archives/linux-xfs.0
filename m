Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2C033981
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504478; cv=none; b=JctaoG30MH+sbS/+MhYjJPPNMNaD3lNa8Q0VLZmGB3RsyROF8ZLtynzmuvLqHxNNOhyZ/bBZYguBGqZboZaZjNdd54sxEG1YvH7Z95L/upv/AH0fnrk33MOl42up3aeqshLJXrHd1ZfDcIXOY435T2E2/J56k2zb0B6RIgmzr+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504478; c=relaxed/simple;
	bh=N997N40osS04AbEdVKlJJqoOdTrA6bMefEFo9Ya25MI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=HluQMT21n0vfOfsSmvC29s8FIJQsqb6BNlQmpHSalO5IRFqc9nX8UXgK2XAzVmBcRzAsI194kINQPrjBcJBij0koG6mExSq9yjU/7uWBjV3fRe5UmYGj5CABT9KwOy9PGRsL2IFgA0+Lz3n+DdVep1pnOBwod+Lb9PNO88FoIw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDvKlx2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDvKlx2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C54CC4CEE2;
	Tue, 25 Feb 2025 17:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504478;
	bh=N997N40osS04AbEdVKlJJqoOdTrA6bMefEFo9Ya25MI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dDvKlx2gC9Ia7YgrGflsQv2PpzNP+LlWYopgJ8G24tRo47T1uRkUGRw8C9PfZhobA
	 TfAu64WXvnpRyISGRjo541lIp00wmurVfi1ioOB1TUJ3mPevgDw+y11lazXjDaQtQt
	 Ch1V+4HGEOTF6FAiK+utdKC0D4dnRbJZ0uNKmpuBG8I5YyX2b6wib0cz+76JBVA6sB
	 e1Rtty6m/JDnVF9SG5e+9M4tNK+xcWrxTuitKLHquKO7hKywJidypdljMwg5yXI6cJ
	 ryV7iz1n3/rUBIgfwJ2U1yJHbk9ukQBF5m9+8p23V5VhB+Y3cIPHSvcSaZR/vNQZnV
	 xE7FVT3RNHzaQ==
Date: Tue, 25 Feb 2025 09:27:57 -0800
Subject: [GIT PULL 6/7] xfs_db: dump fs directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174050433006.404908.16660169554728763047.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250225172123.GB6242@frogsfrogsfrogs>
References: <20250225172123.GB6242@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.14-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 17408f8871e100b2987174b6cf480ee68e44e1a3:

mkfs: enable reflink on the realtime device (2025-02-25 09:16:02 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/rdump-6.14_2025-02-25

for you to fetch changes up to 8c4e704f370e0361c3e3dae5f8751ff580fa95a4:

xfs_db: add command to copy directory trees out of filesystems (2025-02-25 09:16:03 -0800)

----------------------------------------------------------------
xfs_db: dump fs directory trees [6/7]

Before we disable XFS V4 support by default in the kernel ahead of
abandoning the old ondisk format in 2030, let's create a userspace
extraction tool so that in the future, people can extract their files
without needing to load an old kernel or figure out how to set up
lklfuse.  This also enables at least partial data recovery from
filesystems that cannot be mounted due to severe or unfixable
inconsistencies.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs_db: pass const pointers when we're not modifying them
xfs_db: use an empty transaction to try to prevent livelocks in path_navigate
xfs_db: make listdir more generally useful
xfs_db: add command to copy directory trees out of filesystems

db/command.h             |    1 +
db/namei.h               |   19 +
libxfs/libxfs_api_defs.h |    2 +
db/Makefile              |    3 +-
db/command.c             |    1 +
db/namei.c               |  115 +++--
db/rdump.c               | 1056 ++++++++++++++++++++++++++++++++++++++++++++++
man/man8/xfs_db.8        |   26 ++
8 files changed, 1184 insertions(+), 39 deletions(-)
create mode 100644 db/namei.h
create mode 100644 db/rdump.c

