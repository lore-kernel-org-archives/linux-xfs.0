Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC7379C7;
	Thu, 25 Jan 2024 19:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209449; cv=none; b=s5sM9tmsOwdxcMxM/BjzACV67D6wluWV8ybdSiGD+mSQbLX8zXQ19e5gnSz0fFjVFhHxQxfloFe675JwEe8HD9AyCLnU8D68mb/b16RakPoMCBpI6bEkBhxQc2SLA/A5TB20FM/kgYRbKnz6lWenaqpRMycu/APlZOuujWYxdfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209449; c=relaxed/simple;
	bh=YBJu+AlFhxGenkIiOv4bOywaD+EfNmbrAs52cb4bV/Q=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=lbF3DFdbsKc+6XcxV3b7LNMnqxX7yvPUwikg6rGrrTIq/fkxJq+ZI7rD+6MGiOslETNhdbHDVLO/J/UPWttywXToZ2gzph6eDVE5FI3B/GxDNtCFthaOb8C8r9jD46qSETkLcdnPnm0q9BLIiv/MjZqaFAf9txuiGeDqucBWfbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jEkISJ4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEkISJ4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD74C433F1;
	Thu, 25 Jan 2024 19:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209448;
	bh=YBJu+AlFhxGenkIiOv4bOywaD+EfNmbrAs52cb4bV/Q=;
	h=Date:Subject:From:To:Cc:From;
	b=jEkISJ4BUCO4QQi7xeWxX+88RTfviEgcCRuM5gxAQjOQLrNlU4JgCyvA7n+pXeKIZ
	 PIfau6V/NOOGz26fAG9pXLzGZGrh1wGRtD4kuorute6OnS4dFH4hssip+HpPI6GRQJ
	 xiU3Id99JMe7qXceW+en3amIGwDhqHKk++sdTmry0+qRJSIh1xFyqACdedcuT1aUR7
	 GRwCeVUok/pFDJzVz2Z57ep4Q3gx/pezL6CkYBye+ocSk/Z60ByPH331BUv0mr+UI0
	 1tuaxyZy3eMOcLRjT0cmjnsGbSVd7KFvA1gtX9O/0aVtZNoie0cFI8vP+VymKKBxA7
	 tsIGXkx2LYBcQ==
Date: Thu, 25 Jan 2024 11:04:08 -0800
Subject: [PATCHSET] fstests: random fixes for v2024.01.14
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
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

Here's the usual odd fixes for fstests.  Most of these are cleanups and
bug fixes for the recently merged xfs metadump v2 testing code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * generic/256: constrain runtime with TIME_FACTOR
 * common/xfs: simplify maximum metadump format detection
 * common/populate: always metadump full metadata blocks
 * xfs/336: fix omitted -a and -o in metadump call
 * common: refactor metadump v1 and v2 tests
 * xfs/{129,234,253,605}: disable metadump v1 testing with external devices
 * xfs/503: test metadump obfuscation, not progressbars
 * xfs/503: split copy and metadump into two tests
 * common/xfs: only pass -l in _xfs_mdrestore for v2 metadumps
 * xfs/122: fix for xfs_attr_shortform removal in 6.8
---
 common/populate           |    2 -
 common/rc                 |   10 ---
 common/xfs                |   49 +++++++++++++++-
 common/xfs_metadump_tests |  138 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/256         |    7 ++
 tests/xfs/122.out         |    2 +
 tests/xfs/129             |   91 ++----------------------------
 tests/xfs/1876            |   54 ++++++++++++++++++
 tests/xfs/1876.out        |    4 +
 tests/xfs/234             |   92 ++----------------------------
 tests/xfs/253             |   90 ++---------------------------
 tests/xfs/284             |    4 +
 tests/xfs/291             |   32 ++++------
 tests/xfs/336             |    2 -
 tests/xfs/432             |   31 ++--------
 tests/xfs/503             |   82 ++++-----------------------
 tests/xfs/503.out         |    6 +-
 tests/xfs/605             |   92 +-----------------------------
 18 files changed, 304 insertions(+), 484 deletions(-)
 create mode 100644 common/xfs_metadump_tests
 create mode 100755 tests/xfs/1876
 create mode 100755 tests/xfs/1876.out

