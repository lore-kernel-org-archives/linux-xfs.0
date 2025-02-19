Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396761B4145;
	Wed, 19 Feb 2025 00:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926110; cv=none; b=YxfyTPJvWNExdg6L/U+65FCPZWYAo0p6gzZOHvyv/JQtm5weND1AeDdxAsOxgM23YztqJ8JWqdbTAeJdJwyrypKbgZzLj8lTVLfrHqxvk9e+xJvo9fGqnOSbgXB/hvUlDiInwCqoskd1Lnu69kYnWgxc9m1e7PbZF/5Ri/z4Yvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926110; c=relaxed/simple;
	bh=CqYJsDxppWUIxUYwFU+lnEF1CfQAYp4uZM/C6VM0TcM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dok+51Kz1ZQ3gU9OAD03ZiUxhOoBx7sY47ZJc0Qt2keUl0j7Ym6Lrabg0lx/jX8ubH1M7wnOC1vyCnD9nOfhHEvWxVl9g1eiQjCnn0IR7sF/U2oZnqkRPfcaltBjlHJ7SfeL83iKFLDLN9ORVg33fpCP6r0ys7eaITIyZmLUSt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfJOoB2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfJOoB2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA48C4CEE6;
	Wed, 19 Feb 2025 00:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926109;
	bh=CqYJsDxppWUIxUYwFU+lnEF1CfQAYp4uZM/C6VM0TcM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jfJOoB2Cb8i4rhCOacU9UpwFfOPrmDyQSDhzk1OcyGhDTXfY6bKONZJLuwgT7ljp4
	 BFyjZ/Qw/44CmnsLiu00s0vbKzT6zEALu1yFhDXC3NZ5QKcEqVzcNqVkZSJ/JIVg/e
	 RWBBfumGVH/Ns+QG5UbryvVEinOuryUF6jYBcRe94aF4WDzETzqC73pPyKrq/II5SN
	 kapD18d8ZvfL0YtRBYXeSq/ueePd6J6oyXMogLue1uh4875B2yy+a3O4bIxkBgLNFs
	 igWghJAXcSewccj1vFQ06LJchMz/imlJfr3wEtwGv0m883ZptXfFj5PXkwhGN1aped
	 6IGyX4Lh1vxzw==
Date: Tue, 18 Feb 2025 16:48:29 -0800
Subject: [PATCHSET v6.4 10/12] fstests: realtime reverse-mapping support
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix a few regressions in fstests when rmap is enabled on the realtime
volume.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
Commits in this patchset:
 * xfs: fix tests that try to access the realtime rmap inode
 * xfs/336: port to common/metadump
 * fuzz: for fuzzing the rtrmapbt, find the path to the rt rmap btree file
 * xfs: race fsstress with realtime rmap btree scrub and repair
 * xfs: fix various problems with fsmap detecting the data device
 * xfs/341: update test for rtgroup-based rmap
 * xfs/3{43,32}: adapt tests for rt extent size greater than 1
 * xfs/291: use _scratch_mkfs_sized instead of opencoding the logic
 * xfs: skip tests if formatting small filesystem fails
 * xfs/443: use file allocation unit, not dbsize
 * populate: adjust rtrmap calculations for rtgroups
 * populate: check that we created a realtime rmap btree of the given height
 * fuzzy: create missing fuzz tests for rt rmap btrees
---
 common/populate    |   36 +++++++++++++++++++++++++
 common/xfs         |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/104      |    1 +
 tests/xfs/122.out  |    1 -
 tests/xfs/1528     |   38 +++++++++++++++++++++++++++
 tests/xfs/1528.out |    4 +++
 tests/xfs/1529     |   37 ++++++++++++++++++++++++++
 tests/xfs/1529.out |    4 +++
 tests/xfs/1817     |   39 +++++++++++++++++++++++++++
 tests/xfs/1817.out |    2 +
 tests/xfs/1821     |   45 ++++++++++++++++++++++++++++++++
 tests/xfs/1821.out |    2 +
 tests/xfs/1857     |   39 +++++++++++++++++++++++++++
 tests/xfs/1857.out |    2 +
 tests/xfs/1893     |    2 +
 tests/xfs/272      |    2 +
 tests/xfs/276      |    2 +
 tests/xfs/277      |    2 +
 tests/xfs/291      |    2 +
 tests/xfs/332      |    6 +---
 tests/xfs/332.out  |    2 -
 tests/xfs/333      |   43 ------------------------------
 tests/xfs/333.out  |    6 ----
 tests/xfs/336      |   34 ++++++++----------------
 tests/xfs/336.out  |    4 +--
 tests/xfs/337      |    2 +
 tests/xfs/338      |   30 ++++++++++++++++++---
 tests/xfs/339      |    5 ++--
 tests/xfs/340      |   25 ++++++++++++++----
 tests/xfs/341      |   12 +++-----
 tests/xfs/341.out  |    1 -
 tests/xfs/342      |    4 +--
 tests/xfs/343      |    2 +
 tests/xfs/406      |    6 +++-
 tests/xfs/407      |    6 +++-
 tests/xfs/408      |    7 ++++-
 tests/xfs/409      |    7 ++++-
 tests/xfs/443      |    9 ++++--
 tests/xfs/481      |    6 +++-
 tests/xfs/482      |    7 ++++-
 40 files changed, 429 insertions(+), 129 deletions(-)
 create mode 100755 tests/xfs/1528
 create mode 100644 tests/xfs/1528.out
 create mode 100755 tests/xfs/1529
 create mode 100644 tests/xfs/1529.out
 create mode 100755 tests/xfs/1817
 create mode 100644 tests/xfs/1817.out
 create mode 100755 tests/xfs/1821
 create mode 100644 tests/xfs/1821.out
 create mode 100755 tests/xfs/1857
 create mode 100644 tests/xfs/1857.out
 delete mode 100755 tests/xfs/333
 delete mode 100644 tests/xfs/333.out

