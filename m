Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EE422338
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391750; cv=none; b=ZLakalSCkdO92FQun0KdipcGuBoOx9NNsd76w5p/dVEoWvIYzZTLgCESpZmKlNca5nUsQmovAkuzkspIXBvX+v8lFkC88t/23sD3Z7iC68UOaQpTh5WDKlOSq1ToNAfZ44joB/9yKwQh2vJC7e5WQmy4mxz4mZBdbUQKtsS13wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391750; c=relaxed/simple;
	bh=Azxd6aMgbqHeE2re3EyhVa+9CgT1UscScVTNG2fzrxk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=iORMUDb8qdzZJ4WbeAE3yNEQBvInyCTyK2xOEo6rgXKSniWAtclqt5upiOdwlfGPfouIFlDPie/uuuNP4EmTcMLblGHILf4C5MM+56tTFnUrL1xYB18hrLapMwlwcAffADGV8+QwUYzoirlxU6JzoLfOuAYIJdU6Mxta8SrMfZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jk485Woi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jk485Woi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04F9C072AA;
	Wed, 17 Apr 2024 22:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391749;
	bh=Azxd6aMgbqHeE2re3EyhVa+9CgT1UscScVTNG2fzrxk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jk485WoihrtmqoEyOjMVGXAtwFq9KzmHFnDYrpTpbbF3lUleQUsLx4G5bKSZgxgrH
	 TDqSWovzpHK85D0TlvFHANdOaZH2n07PzgMnqelMvdD+9NP+FdzNOnTlWk7hlg0/gp
	 0pt4v8HoBWokMU7hUoLfOKITo/u85HOkYWpnfAgmP8xYE4GnvVJBMCYAVdDSaPWJb3
	 zMGOfueKuojjpS+og9mBYzQ7oeIL5pEZG6fRcQwZckBcqBwBcAaB8YFxwiQXucTTay
	 uZoauNOOiHLdivMMu4VjeZSr5qkxBU6x92cg2r7P0cI1D3EBHhpzpZnLmUZZAN/u42
	 b0usUpaHWY3BQ==
Date: Wed, 17 Apr 2024 15:09:09 -0700
Subject: [GIT PULL 07/11] xfsprogs: fix log sector size detection
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org, p.raghav@samsung.com
Message-ID: <171339160678.1911630.18411132544715274906.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 16a75c71b4c04373c0c726b8e6ddfd030a81c93e:

xfs_io: add linux madvise advice codes (2024-04-17 14:06:27 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/mkfs-fix-log-sector-size-6.8_2024-04-17

for you to fetch changes up to 53bf0604e104bc053778495faef94b3570582aac:

mkfs: use a sensible log sector size default (2024-04-17 14:06:27 -0700)

----------------------------------------------------------------
xfsprogs: fix log sector size detection [V3 07/20]

From Christoph Hellwig,

this series cleans up the libxfs toplogy code and then fixes detection
of the log sector size in mkfs.xfs, so that it doesn't create smaller
than possible log sectors by default on > 512 byte sector size devices.

Note that this doesn't cleanup the types of the topology members, as
that creeps all the way into platform_findsize.  Which has a lot more
cruft that should be dealth with and is worth it's own series.

Changes since v2:
- rebased to the lastest for-next branch

Changes since v1:
- fix a spelling mistake
- add a few more cleanups

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (5):
libxfs: remove the unused fs_topology_t typedef
libxfs: refactor the fs_topology structure
libxfs: remove the S_ISREG check from blkid_get_topology
libxfs: also query log device topology in get_topology
mkfs: use a sensible log sector size default

libxfs/topology.c | 109 +++++++++++++++++++++++++++---------------------------
libxfs/topology.h |  19 ++++++----
mkfs/xfs_mkfs.c   |  71 +++++++++++++++++------------------
repair/sb.c       |   2 +-
4 files changed, 100 insertions(+), 101 deletions(-)

