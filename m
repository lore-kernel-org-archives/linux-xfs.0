Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC6B23BB;
	Fri, 11 Oct 2024 00:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607061; cv=none; b=F/42KliWUBWYlpABHH5ftjeiigmV/GaTxZn/UfN1jP0hE9MTe+nWkpVPczEJsyzEFDLjyRUaAMeSTwJnBn1wMmkGMQ1h06VlYu+batpFGwEhP95GvrepL46mSwBEYvPf8E9d22/cnSQhdB9ModTlDhfz5yePNGicXZ+0fdOg2MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607061; c=relaxed/simple;
	bh=+OpSWVIiSKxY7voCoLwSywAjGfkICF5GMvhYjQq7mhY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sN5jz9Z3X3zkZTpBu0VM8H12LNB1IvYBbxXKR+DHW1xL1IdkUTtpIJVRUeoXK+w+WP+bPkWD3HKfBR5CbhuiOKroTJJ8TvX+uFISEOE/V/IqvJ2n5f4WAXCs2sPJynxw53Rl7dTX2Lzay3/w9tMriF+NouTdv7BiWHYiIBB+rZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olpgh5qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olpgh5qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851ECC4CEC5;
	Fri, 11 Oct 2024 00:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607061;
	bh=+OpSWVIiSKxY7voCoLwSywAjGfkICF5GMvhYjQq7mhY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=olpgh5qe2FNPV2kNxp+4tZGeljXOrfJXN5WoaNq7z+7RsubId2gS9sylq57Y9MPXd
	 95afmqtifSe+aqqOnThVJNRD62QtZW4EtleeLW+CWGdhM/1V99b/7HqX17KX8OVNsq
	 lTcHUaB3VrdKbvErj3WarTqzNsolK3MuV6uO+q9lT6M8iXnSPGOKzIDabGRS2OzjbZ
	 dVK72pm/zvRzjwol40QHRKrpA04zrgmG+lTLphCbJL2513r3FnPRZa5mx/IHzIwXNe
	 puk0ldW/4i3/LmGOB0faz42lXFqpzdmN1OIrOvzhB4wwxAIQ8Ra2jtI0kTk1PByZDb
	 RYzlpq1Jrw38A==
Date: Thu, 10 Oct 2024 17:37:41 -0700
Subject: [PATCHSET v5.0 3/3] fstests: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860659089.4189705.9536461796672270947.stgit@frogsfrogsfrogs>
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

Store the quota files in the metadata directory tree instead of the superblock.
Since we're introducing a new incompat feature flag, let's also make the mount
process bring up quotas in whatever state they were when the filesystem was
last unmounted, instead of requiring sysadmins to remember that themselves.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir-quotas
---
Commits in this patchset:
 * xfs/122: update for segmented rtblock addresses
 * xfs: update tests for quota files in the metadir
 * xfs: test persistent quota flags
 * xfs: fix tests for persistent qflags
---
 common/quota              |    1 
 common/rc                 |    1 
 common/xfs                |   21 ++++++
 tests/generic/563         |    8 ++
 tests/xfs/007             |    2 -
 tests/xfs/096             |    1 
 tests/xfs/096.out         |    2 -
 tests/xfs/106             |    2 -
 tests/xfs/116             |   13 ++++
 tests/xfs/116.cfg         |    1 
 tests/xfs/116.out.default |    0 
 tests/xfs/116.out.metadir |    3 +
 tests/xfs/122.out         |    5 +-
 tests/xfs/152             |    2 -
 tests/xfs/1856            |   13 ++++
 tests/xfs/1891            |  128 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1891.out        |  147 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/263             |    1 
 tests/xfs/263.out         |    2 -
 19 files changed, 344 insertions(+), 9 deletions(-)
 create mode 100644 tests/xfs/116.cfg
 rename tests/xfs/{116.out => 116.out.default} (100%)
 create mode 100644 tests/xfs/116.out.metadir
 create mode 100755 tests/xfs/1891
 create mode 100644 tests/xfs/1891.out

