Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3F2158520;
	Thu, 16 Jan 2025 23:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069851; cv=none; b=kB++5/Y9izaceoUk5Gd3w3kQOJ8IBJoMsG0wuryAWrcn/z5qoJQv0cT1qil4hkDVRf4RiEV0grxnfJmv+LXcr8+nIc3r6pe4PANuEULX+h3ldjZZ3K/t8XO2mDLbjjhljBux4MN7WwSRweeh3V9a2OWHw9lE0pLLDomreyOXyIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069851; c=relaxed/simple;
	bh=rnBLUakr8b0CFZJURjl9maeTohunlVSlFBlca+Gh98c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sH9zoCS9yrVmUYxSCg3d032mKfKA+zMB2cO2D4lAsagxm3EPein7OLAPaNDWMAmBMk4rkkw0+UXgXjDzrQXGAMacyK0xY47g+5ZaZefQrwiL5uy+XRG+hxKx5z2UB7pQixm9Om79XmJ4podNfwOP8K8/GTbp6z6JqiUlSNnJpVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVoRMoF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVoRMoF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABDAC4CED6;
	Thu, 16 Jan 2025 23:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069848;
	bh=rnBLUakr8b0CFZJURjl9maeTohunlVSlFBlca+Gh98c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VVoRMoF1M+M3ol/02cMVJo+s2+N12SsdEFSyei0jHQE6evepLgFfO6TUHYVim7Hlh
	 9Yf2x/utgkPfhcvfsSmsT6HPg2GSeNjsNSG/gq9k6YH2m1R8GjmDCFVpSGzHz85dpa
	 woGeAWzVgr2nuopqtahF9TGLGeuFe57F8WSE9XgDTEVyJvMToi9e8LYdX6yR5Yu61C
	 0ZNRyhZmQMRFXESV2hGToqI29KlpxDZBt7X0nhR3mILuagd2/2YkK2llU/nOAl3QPR
	 lM8ScarCut7YwNK5exHJ/9fx5IQYQeAMf4wkjEZxjINToJfzTPIsWhC+wLAx/ww0gq
	 kpfXIB/+Fay2g==
Date: Thu, 16 Jan 2025 15:24:08 -0800
Subject: [PATCHSET v6.2 3/7] fstests: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
In-Reply-To: <20250116232151.GH3557695@frogsfrogsfrogs>
References: <20250116232151.GH3557695@frogsfrogsfrogs>
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
 * scrub: race metapath online fsck with fsstress
 * xfs: test metapath repairs
---
 common/filter      |    7 ++-
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
 47 files changed, 765 insertions(+), 78 deletions(-)
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

