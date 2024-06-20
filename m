Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32C62BAF3;
	Thu, 20 Jun 2024 20:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916781; cv=none; b=aRxexEmn4ixdKMUsFhVZw/R9xopkwqAYLhvlTRDD3WTa5D97R0jVoqFUzVA48yfobQzg8MSsyVzxQeseSryw6LxTC6rEr+Z5V3kONEPhgWL7uwy5FsXNUxbtG3Ho2/zre1l7AYn/YZz/qovTZseKzt3bXowZMI3ZfjQys6LULfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916781; c=relaxed/simple;
	bh=r9lm1+2e+kfy1IjXBgbW103WzQYuVX7KxS0VP8w7X6I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxDY+B3V+dQD0hUf2eqCkHTejSVng1zHBIJ9gK/9DkpxO7PCHQYMJY1Kr8FD+tLG7BQOiX7m1XhoWTwje6dpH4MC4je6bng8YDnYmq7AJQxtI3lTPgxgIf+ejypqC5gqto4rZ1SJlrpJisEneJ9jMqs4Iq28OcsuERkG8Xh42/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ik32ijop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ik32ijop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6115CC2BD10;
	Thu, 20 Jun 2024 20:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916781;
	bh=r9lm1+2e+kfy1IjXBgbW103WzQYuVX7KxS0VP8w7X6I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ik32ijopJtpUhJjhqcy/cNED9Vs+f9znfWRwTn8DCf3rkVn1R+FRy+NpS5KJnMDRT
	 8Mlx/153GmoFihPR807Obj1NjQXu3vY75cwLshm/vJZKotx8a3IODh3nEJnIFwc6I7
	 uw1TWCKVzoysFeqVxwLZdS6ZSp2zyKxnakTlq+tL2qtNd+uVasWw65UfcXg6ZMqjjM
	 zfOXgQdqw7QVvEVTBGmIyywwulJBgnGKz5xEdspMvV9yeYDKKRxLm9C1qs6xC8Whjh
	 WXa5vLRy0SEJRYdDSr+9KQCd7/Sjn75MEEZemP5s/crnnRI0vqCJCgq7g7yXE22htV
	 oDgWLP6DUnn4Q==
Date: Thu, 20 Jun 2024 13:53:00 -0700
Subject: [PATCHSET v13.6 3/6] fstests: adjust tests for xfs parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Catherine Hoang <catherine.hoang@oracle.com>,
 fstests@vger.kernel.org, allison.henderson@oracle.com,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
In-Reply-To: <20240620205017.GC103020@frogsfrogsfrogs>
References: <20240620205017.GC103020@frogsfrogsfrogs>
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

These are the test adjustments that are required for parent pointers.
There's also a few new tests to ensure that the GETPARENTS ioctl (and
 file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=pptrs
---
Commits in this patchset:
 * generic: test recovery of extended attribute updates
 * xfs/206: filter out the parent= status from mkfs
 * xfs/122: update for parent pointers
 * populate: create hardlinks for parent pointers
 * xfs/021: adapt golden output files for parent pointers
 * xfs/{018,191,288}: disable parent pointers for these tests
 * xfs/306: fix formatting failures with parent pointers
 * common: add helpers for parent pointer tests
 * xfs: add parent pointer test
 * xfs: add multi link parent pointer test
 * xfs: add parent pointer inject test
---
 common/parent             |  209 +++++++++
 common/populate           |   42 ++
 common/rc                 |    7 
 common/xfs                |   28 +
 doc/group-names.txt       |    1 
 src/popdir.pl             |   11 
 tests/generic/1834        |   93 ++++
 tests/generic/1834.out    |    2 
 tests/xfs/018             |    4 
 tests/xfs/021             |   15 +
 tests/xfs/021.cfg         |    1 
 tests/xfs/021.out.default |    0 
 tests/xfs/021.out.parent  |   64 +++
 tests/xfs/122.out         |    4 
 tests/xfs/1851            |  116 +++++
 tests/xfs/1851.out        |   69 +++
 tests/xfs/1852            |   69 +++
 tests/xfs/1852.out        | 1002 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1853            |   85 ++++
 tests/xfs/1853.out        |   14 +
 tests/xfs/191             |    3 
 tests/xfs/206             |    1 
 tests/xfs/288             |    4 
 tests/xfs/306             |    9 
 24 files changed, 1846 insertions(+), 7 deletions(-)
 create mode 100644 common/parent
 create mode 100755 tests/generic/1834
 create mode 100644 tests/generic/1834.out
 create mode 100644 tests/xfs/021.cfg
 rename tests/xfs/{021.out => 021.out.default} (100%)
 create mode 100644 tests/xfs/021.out.parent
 create mode 100755 tests/xfs/1851
 create mode 100644 tests/xfs/1851.out
 create mode 100755 tests/xfs/1852
 create mode 100644 tests/xfs/1852.out
 create mode 100755 tests/xfs/1853
 create mode 100644 tests/xfs/1853.out

