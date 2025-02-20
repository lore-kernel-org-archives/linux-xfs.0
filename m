Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFE61EDA37;
	Thu, 20 Feb 2025 22:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089107; cv=none; b=nAR9+nuj6Md2PfBzsrjHtFMI/0BHXiGEO3czNQlBVja3BOcV6qw7n+ntjV39tDcinoK3fkaI5zUaB2QF+HsoYUx2UDtV3dYMB1l73UGLZic+Hn83Ol6/cn3JI7PboX9cvsnV1rA0UbtXE1Gh26acZNmGQJBzRoTqUGiuqQBh5d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089107; c=relaxed/simple;
	bh=Dbe9E0LTvnOLUlx7sCcVHKUFAEvE2UQ+rdwsynEecXA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=T0KG15gAy1dncgupa+qQ9PFlroacqPHGV+r0Tu262GvhlU/OSCJzeauvrDhTpa+wpu30eK1vcuwkc9KXpo82NXLxc5sXrNEaGF8bIUUB5fV29t87B3Yms/3/e5Ao3OIQTT+fxwm5gB1//rFhRU8gc4EqSaNjdzA2R4yvB1DeX/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5nCgq42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5nCgq42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38910C4CED1;
	Thu, 20 Feb 2025 22:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089107;
	bh=Dbe9E0LTvnOLUlx7sCcVHKUFAEvE2UQ+rdwsynEecXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J5nCgq42akS2wal+VWH5L2cF63UKvOzU1TsG9m4L6jT/tMjQ+dsSNQBI+/Y5aXNSY
	 9jjPVjdakNQ3dwYWUf0Q/Vl+6mi+WwAb9aPOwfmGW/Iqg4WJL4wnDS7LY0YERGmF9Y
	 3NfbELcIT6ynhiBZxaILR2EEl5ie3R7bPV9jlT7NarScOpisLUTn7XgonziHMgTMbh
	 cEWmb6xpiSF9i5+IiibgHdeh+QbXf1PzdbWgYMyC+ubQ08nmjsW7rXDC/DK9UPgHWo
	 AnYwoNesbX2YDJfUfRiRDSJfKHukfmgjuFcJavhSTKOLzh43jV2iUwi/k2U+sNx3Ly
	 DfHUjdPd/y6Xg==
Date: Thu, 20 Feb 2025 14:05:06 -0800
Subject: [GIT PULL 04/10] fstests: make protofiles less janky
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008901711.1712746.14015120967489849682.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250220220245.GW21799@frogsfrogsfrogs>
References: <20250220220245.GW21799@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Zorro,

Please pull this branch with changes for fstests.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 4ddd7a7083e4517a20b933d1eac306527a5e0019:

xfs: test metapath repairs (2025-02-20 13:52:18 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/protofiles_2025-02-20

for you to fetch changes up to 915630e294582b91658e300b2302129d77f36504:

fstests: test mkfs.xfs protofiles with xattr support (2025-02-20 13:52:18 -0800)

----------------------------------------------------------------
fstests: make protofiles less janky [v6.5 04/22]

Add a new regression test for xattr support of xfs protofiles.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs/019: reduce _fail calls in test
xfs/019: test reserved file support
xfs: test filesystem creation with xfs_protofile
fstests: test mkfs.xfs protofiles with xattr support

common/config      |   1 +
tests/xfs/019      |  14 ++++--
tests/xfs/019.out  |   5 ++
tests/xfs/1894     | 115 ++++++++++++++++++++++++++++++++++++++++++
tests/xfs/1894.out |   4 ++
tests/xfs/1937     | 144 +++++++++++++++++++++++++++++++++++++++++++++++++++++
tests/xfs/1937.out | 102 +++++++++++++++++++++++++++++++++++++
7 files changed, 380 insertions(+), 5 deletions(-)
create mode 100755 tests/xfs/1894
create mode 100644 tests/xfs/1894.out
create mode 100755 tests/xfs/1937
create mode 100644 tests/xfs/1937.out

