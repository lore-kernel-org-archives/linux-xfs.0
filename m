Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90E71DFE1;
	Wed, 19 Feb 2025 00:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926014; cv=none; b=ci2ObR7dfJispoAeFvDUxkZPzOkOzaxK1l34yi1uIBWGVpB4lHKFkdLqPfCnHVC1ZtFVmqXbiwkV79FWidMIO9zZITiZgPDW1+FTRzWVqEovogBFflxAUTYxS3hPOGXU0cPfgDWzeDZnmP8enOu0jZMb9xmfq8AbZfXefJnci8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926014; c=relaxed/simple;
	bh=JC7+CrDXyn7ISnCEOYmzbo8SfXwXpBj16hn5YbtNaXA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jHOTs9R14/Rez+PE2foOqXFn2uc9/nEWTtiGRBx4iVs5tfA0GoUhwzkErK9NDW4zKxfpu10adRwwQCUu3BAqhQy67zdMM+Jj42aO+BKvI0IQDu5ARRsDu4QfH2l67oyrx2nnjND0bfMf75XE3TXcXMAVGxHICD9/gbIFLvY1hsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0LYI9X9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0LYI9X9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460ABC4CEE2;
	Wed, 19 Feb 2025 00:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926014;
	bh=JC7+CrDXyn7ISnCEOYmzbo8SfXwXpBj16hn5YbtNaXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F0LYI9X9A6J2tiFjuBsGrv1ja6C/5K2VizEyc0ZkRLFh44if5BqTsSchAq8yvLS8P
	 RmfvsEgKV6m8AA993r0zc0hjyKhviBL6V2OPwm1G+6k35lOMgmBcB+nGsUd+JS4Lkp
	 spyZ59lU3pdv8TBYZy/ve8YSj62Y3WvQ9fUfYb7cQXdIx3gIMwipplDATRKqcJ+4dF
	 zHXosOXzubrR+u4UFRMzfJnGx1puLgYyzkk6HzRslFVNRdXkyBwEIoD95JO7fnO0jL
	 h30wlmwS7F2PnOZR2akehXoJ4HzUFiSpB564LM9LZ39bZIwiNIP89d0WDktQADcNqO
	 W2mZY6uIr9knA==
Date: Tue, 18 Feb 2025 16:46:53 -0800
Subject: [PATCHSET v6.4 04/12] fstests: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
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
 * various: fix finding metadata inode numbers when metadir is enabled
 * xfs/{030,033,178}: forcibly disable metadata directory trees
 * common/repair: patch up repair sb inode value complaints
 * xfs/206: update for metadata directory support
 * xfs/{050,144,153,299,330}: update quota reports to handle metadir trees
 * xfs/509: adjust inumbers accounting for metadata directories
 * xfs: create fuzz tests for metadata directories
 * xfs/163: bigger fs for metadir
 * xfs/122: disable this test for any codebase that knows about metadir
 * common/populate: label newly created xfs filesystems
 * scrub: race metapath online fsck with fsstress
 * xfs: test metapath repairs
---
 common/filter      |    7 ++-
 common/populate    |    8 +++
 common/repair      |    4 ++
 common/xfs         |  100 +++++++++++++++++++++++++++++++++++++++++++-
 tests/xfs/007      |   16 ++++---
 tests/xfs/030      |    1 
 tests/xfs/033      |    1 
 tests/xfs/050      |    5 ++
 tests/xfs/122      |    6 +++
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
 tests/xfs/1892     |   66 +++++++++++++++++++++++++++++
 tests/xfs/1892.out |    2 +
 tests/xfs/1893     |   67 +++++++++++++++++++++++++++++
 tests/xfs/1893.out |    2 +
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
 48 files changed, 773 insertions(+), 78 deletions(-)
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
 create mode 100755 tests/xfs/1892
 create mode 100644 tests/xfs/1892.out
 create mode 100755 tests/xfs/1893
 create mode 100644 tests/xfs/1893.out

