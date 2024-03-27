Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7F018C36
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504167; cv=none; b=KoXRvt8FBwsBOpxg0NW7GKCWGHYZUzS8fErVlhh7ztL7ih9TKpAZS3/kpqW14vLQHi7S3WlRjFPbe6Ed9bCS5jJLlIPDvh8y7yEsS95ufk7pFWlF6OHBDxLuQh8ukIggneFvn6u0Z5rVRhoorLZRp7wxbvXhpJo6Qd1YZ6zA8ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504167; c=relaxed/simple;
	bh=J0Gb1VqJzAFzhad06oo3f8gbxZ9tHXrR8+6ey6lPeFo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JAWQFPCDDWsHs3BlSeSBFZczPsXuwO33Cvo+7A3mmjNPZ/Pgve8YAP5H0DGs4wLLqOfNfwX/hj0tkZs04ByWPv/xj0JNBZYNVeW/xKveetmKygngxh7xuNV/FJb0DWuBLqgyPtQv7sDaut/T4c9xVkaXWaeZUS7Hn3jG9iUi7aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sbgYRXjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sbgYRXjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B65C433F1;
	Wed, 27 Mar 2024 01:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504167;
	bh=J0Gb1VqJzAFzhad06oo3f8gbxZ9tHXrR8+6ey6lPeFo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sbgYRXjGshKHsV2PHnTw6+TfbSDnQ6U3m5jOFz6IpMk4SUX/kehozM2CKEvF38j4y
	 HEWNBUpCJ0OQSe1yNW/EiZD0/3ZHb/pZMA6apFjsXBmC3djRqoaVHVlVyqPBby03m+
	 q1O1Uwjn7vb+rOu16jvLi/z+kYZUwnoK6zUp83DTB3gZD6gNklE+5qrxFhvYhx8YbW
	 R2BAPlEU4UIdnjEDZq2hJpJpxgyC9KNxvzFGu5OYUs1bF7OUq9p1yMjrHEs3ync4QM
	 +xnFj9dUTvCJrCSZSlOQscWAKq5p4wAeVa4m0PfmzpOKkCXn77TlKO7uZe2UnLTprx
	 nM3ngw1NWFGNQ==
Date: Tue, 26 Mar 2024 18:49:26 -0700
Subject: [PATCHSET v30.1 12/15] xfs: online repair of symbolic links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150384345.3219922.17309419281818068194.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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

The sole patch in this set adds the ability to repair the target buffer
of a symbolic link, using the same salvage, rebuild, and swap strategy
used everywhere else.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-symlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-symlink
---
Commits in this patchset:
 * xfs: online repair of symbolic links
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_bmap.c           |   11 -
 fs/xfs/libxfs/xfs_bmap.h           |    6 
 fs/xfs/libxfs/xfs_symlink_remote.c |    9 -
 fs/xfs/libxfs/xfs_symlink_remote.h |   22 +-
 fs/xfs/scrub/repair.h              |    8 +
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   13 +
 fs/xfs/scrub/symlink_repair.c      |  504 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.c            |    5 
 fs/xfs/scrub/trace.h               |   46 +++
 11 files changed, 612 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c

