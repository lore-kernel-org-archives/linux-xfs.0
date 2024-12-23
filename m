Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99338188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992955; cv=none; b=P5iyu4Ewafb+NZJMAbtmG/CWuJtFmnbQlSkldqcS8ygyK19I5OkN+0MJHwND3kZ6Q4h8zyyopBnY6RawrHS6IpItnU6mXF0tkVoDqRf+BwJQ6dsNKNJjTAFD2bp92Qq4FAF+XGC83E5BxDPZnyTjwoUrnBBD/ChqnaLmPdi30hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992955; c=relaxed/simple;
	bh=iWBQe8BKquwSFz81FMMcZbtlJIwxhXkEfQezw7jKT64=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=jLh9+O6cAMVudNcCVJD4Ie2G248CWvVZn9Yu+Qc9s6ami2vlMGfyf5RFIzTvjSJnTkR+Sr/RuKAtp/jl0cLt5b18NOOokRmlsw6qZFXoZe6YDucOAXojafrXoVj0HKC1n+cWeHGwQFSxs4BZSOgcdrKUx5E99XndfWfnieAPYio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J74DdiRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J74DdiRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2825CC4CED3;
	Mon, 23 Dec 2024 22:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992954;
	bh=iWBQe8BKquwSFz81FMMcZbtlJIwxhXkEfQezw7jKT64=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J74DdiRJAa06wOGQHBqMFWYn2JmLFgAnnfMeYjwKNK3YtG1GO3JvM2mqzeFY9pHWl
	 N3HySpngzyVmGLt4m5rGbCs9hgKlpVEIjvKe4a1ob8C6EnfqgMhM5Brbp4qNuOSx6D
	 hq8dq2MZ89mGBA1EyWbOXCsx7seCGewwurJLvG5BBYN1y4q6BJGh4k+xz1tHOHtosA
	 0ztsYyb04rS5hHcAWj5IzWARrsldKJUvVFLN/7dFuKzY0QOXQCcbGtb327pmR2KL+s
	 X3XUK/CCvZImzvzYxiRyQ44lLBc2pCZOrwZTYO6UhkgoOKjEku3O6nzbSSoo7Mny5L
	 N7eSFMl8XevxQ==
Date: Mon, 23 Dec 2024 14:29:13 -0800
Subject: [GIT PULL 7/8] xfsprogs: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498954648.2301496.9057937494026486784.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit be4f8d6c422045b7934b8763f013996d49627b00:

mkfs: format realtime groups (2024-12-23 13:05:16 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/metadir-quotas_2024-12-23

for you to fetch changes up to 6ec6c38c96d4427f12e214181a1bb8547fb4c355:

mkfs: add quota flags when setting up filesystem (2024-12-23 13:05:17 -0800)

----------------------------------------------------------------
xfsprogs: store quota files in the metadir [v6.2 07/23]

Store the quota files in the metadata directory tree instead of the
superblock.  Since we're introducing a new incompat feature flag, let's
also make the mount process bring up quotas in whatever state they were
when the filesystem was last unmounted, instead of requiring sysadmins
to remember that themselves.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
libfrog: scrub quota file metapaths
xfs_db: support metadir quotas
xfs_repair: refactor quota inumber handling
xfs_repair: hoist the secondary sb qflags handling
xfs_repair: support quota inodes in the metadata directory
xfs_repair: try not to trash qflags on metadir filesystems
mkfs: add quota flags when setting up filesystem

db/dquot.c               |  59 ++++++++++++-----
libfrog/scrub.c          |  20 ++++++
libxfs/libxfs_api_defs.h |   6 ++
man/man8/mkfs.xfs.8.in   |  48 ++++++++++++++
mkfs/xfs_mkfs.c          | 113 ++++++++++++++++++++++++++++++++-
repair/agheader.c        | 161 ++++++++++++++++++++++++++---------------------
repair/dinode.c          |  18 +++---
repair/dir2.c            |  12 ++--
repair/globals.c         | 111 ++++++++++++++++++++++++++++++--
repair/globals.h         |  15 +++--
repair/phase2.c          |   3 +
repair/phase4.c          | 116 +++++++++++++++++-----------------
repair/phase6.c          | 128 ++++++++++++++++++++++++++++++++++---
repair/quotacheck.c      | 118 +++++++++++++++++++++++++++++-----
repair/quotacheck.h      |   3 +
repair/sb.c              |   3 +
repair/versions.c        |   9 +--
repair/xfs_repair.c      |  13 ++--
18 files changed, 753 insertions(+), 203 deletions(-)

