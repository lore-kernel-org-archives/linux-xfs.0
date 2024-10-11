Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB33EAFA;
	Fri, 11 Oct 2024 00:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607030; cv=none; b=oCpukT2HtNO0qKbFZKdh5f0KdJI0H5cIU23kNeO9W1w7YzIcsSgtngo90R7dr0soFCR1Fr7TeNab036AjpAvBr5wmSzygBGj5rrdkkV0bucBanL9lArUX0hLmE/KlIferk4k+s93kdIPVJlE1XraV7nMOQB7QGnfa5LXgHOVsKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607030; c=relaxed/simple;
	bh=syw8KlQ8zL2zcDPEraBpOJ8f0wJNtBoQnPBot9hgFZo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWlct+/+t47kAw3P9FkVyvdkKvUkB5E75Beos0q6XI2G+tF84pS+ZEQp8ZSK8c3JnOxjd8ZBV+JJzhaDkZSW/qg3JTJNJUogtJVCn25/Bj5RrHyeJimjrWTxYXNYiB8LUXKLThzxdFy5eb4wrpPRN5dI6r/RjsS2XS8pa2kgw74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o6xZRMZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o6xZRMZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA81C4CEC5;
	Fri, 11 Oct 2024 00:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607030;
	bh=syw8KlQ8zL2zcDPEraBpOJ8f0wJNtBoQnPBot9hgFZo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o6xZRMZtAXuCZccg5+GraipH2gbdGrD/a7nGY5uXKGVtVVa9lWE1JY6y7FqDlMXwb
	 DoiuAz5UOqXKx1fg0CETP/l6yR9T9CzInFxWztiQt2e9trRhyPl/9kbo/dCas8Allw
	 iXvBOgR/+RolBb6q+THLQv0kE7ebSlbfMCf3WSHz01wO0LO1nOs6G32UkbXL5OATtp
	 SX9M2P9zehD0C9lhSXA1IFq4pPjxTtwQHguOWcwugItwYstiq9rXE/XUHy9YZ3RjlA
	 XdZzvvUSjNOS+5uiB6zSD56ixPEs3qDiC5ABzG/hBABD9g+XjIqkPhTrNbDiIirVcq
	 BUXlK2Jf+spUQ==
Date: Thu, 10 Oct 2024 17:37:09 -0700
Subject: [PATCHSET v5.0 1/3] fstests: test XFS metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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

Adjust fstests as needed to support the XFS metadata directory feature,
and add some new tests for online fsck and fuzz testing of the ondisk
metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
Commits in this patchset:
 * xfs/122: fix metadirino
 * various: fix finding metadata inode numbers when metadir is enabled
 * xfs/{030,033,178}: forcibly disable metadata directory trees
 * common/repair: patch up repair sb inode value complaints
 * xfs/206: update for metadata directory support
 * xfs/{050,144,153,299,330}: update quota reports to handle metadir trees
 * xfs/509: adjust inumbers accounting for metadata directories
 * xfs/122: adjust for metadata directories
 * xfs: create fuzz tests for metadata directories
 * xfs/163: bigger fs for metadir
 * xfs: test metapath repairs
---
 common/filter      |    7 ++-
 common/repair      |    4 ++
 common/xfs         |   85 ++++++++++++++++++++++++++++++++++++-
 tests/xfs/007      |   16 ++++---
 tests/xfs/030      |    1 
 tests/xfs/033      |    1 
 tests/xfs/050      |    5 ++
 tests/xfs/122.out  |    4 +-
 tests/xfs/153      |    5 ++
 tests/xfs/1546     |   34 +++++++++++++++
 tests/xfs/1546.out |    4 ++
 tests/xfs/1547     |   34 +++++++++++++++
 tests/xfs/1547.out |    4 ++
 tests/xfs/1548     |   34 +++++++++++++++
 tests/xfs/1548.out |    4 ++
 tests/xfs/1549     |   35 +++++++++++++++
 tests/xfs/1549.out |    4 ++
 tests/xfs/1550     |   34 +++++++++++++++
 tests/xfs/1550.out |    4 ++
 tests/xfs/1551     |   34 +++++++++++++++
 tests/xfs/1551.out |    4 ++
 tests/xfs/1552     |   34 +++++++++++++++
 tests/xfs/1552.out |    4 ++
 tests/xfs/1553     |   35 +++++++++++++++
 tests/xfs/1553.out |    4 ++
 tests/xfs/163      |    2 -
 tests/xfs/178      |    1 
 tests/xfs/1874     |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1874.out |   19 ++++++++
 tests/xfs/206      |    1 
 tests/xfs/299      |    1 
 tests/xfs/330      |    6 ++-
 tests/xfs/509      |   23 +++++++++-
 tests/xfs/529      |    5 +-
 tests/xfs/530      |    6 +--
 tests/xfs/739      |    9 +---
 tests/xfs/740      |    9 +---
 tests/xfs/741      |    9 +---
 tests/xfs/742      |    9 +---
 tests/xfs/743      |    9 +---
 tests/xfs/744      |    9 +---
 tests/xfs/745      |    9 +---
 tests/xfs/746      |    9 +---
 43 files changed, 610 insertions(+), 79 deletions(-)
 create mode 100755 tests/xfs/1546
 create mode 100644 tests/xfs/1546.out
 create mode 100755 tests/xfs/1547
 create mode 100644 tests/xfs/1547.out
 create mode 100755 tests/xfs/1548
 create mode 100644 tests/xfs/1548.out
 create mode 100755 tests/xfs/1549
 create mode 100644 tests/xfs/1549.out
 create mode 100755 tests/xfs/1550
 create mode 100644 tests/xfs/1550.out
 create mode 100755 tests/xfs/1551
 create mode 100644 tests/xfs/1551.out
 create mode 100755 tests/xfs/1552
 create mode 100644 tests/xfs/1552.out
 create mode 100755 tests/xfs/1553
 create mode 100644 tests/xfs/1553.out
 create mode 100755 tests/xfs/1874
 create mode 100644 tests/xfs/1874.out

