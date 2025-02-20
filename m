Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E16413AF2;
	Thu, 20 Feb 2025 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089185; cv=none; b=e6rsjrumW7dFlWXyWEk82vRIRhLU3Ng7fN3N/4GJb/wZKOWOj76V0zaHIA21VFPHXE2NmEUQbaKYfD8rJQsEly4F5WN/b63z7J9n7ZOU6RDS2tR2ZHRkokNuVEiMQfcCdzhUlc4nZUlW+yp9HhAn28SQNNCRqBsvntMj7KS5nJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089185; c=relaxed/simple;
	bh=8vLQQ+jp2qm8QjNBAPZAAViWBLvQ/I2hEv54CLS3DJU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=lpjpVhAXqJiwWCdcMF9Dsj0muEw3v380ukGVwgOeHOWKuFa1FjfXl1XYNprx44i4mwQxdD13M8LUJsHpKPuPFntIcQaH+pYYKsfQGOrrl5Nw8rScGM5dkUqwLtQAQZZTz4YnYuTSbea8IfgrJXO6/Jv9VBdJdzfGYZqtaK4zCzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0WgNN5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0WgNN5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A706C4CED1;
	Thu, 20 Feb 2025 22:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089185;
	bh=8vLQQ+jp2qm8QjNBAPZAAViWBLvQ/I2hEv54CLS3DJU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p0WgNN5rI9uMbzYQvUuq7TmxH5AHCEhubAMJg3KEUBIxNMvPzgfcLQ/Qq8bmGLLsU
	 1nkueWLQrJAbt1X+rrm5OXMk01bq+4x3ur0H0NMi084ryQoU1wh1sYJz58A6ovrmRK
	 QC/aB7xv/h2J3MpJvAgsM0UMBDa7VyiwHrPifkYyXKwFFMGakT4gDsPUuVKXWqY/v3
	 qFvaSJ7sSzqvrs5/beOKPOSEI2LFNqi6ieKB7xoQekzqkA46veC3CWL7rSbA0A0m9D
	 wAApjMjA/a1qjbpCwRebOP7EL0QGYe55qfIHdW1jA/pFcADWy1hdD/Uu3sNVKn1d7r
	 euEr2/QhNwypg==
Date: Thu, 20 Feb 2025 14:06:24 -0800
Subject: [GIT PULL 09/10] fstests: realtime reverse-mapping support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008902147.1712746.14970689865188811258.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit ab6d4b4067053679508792dc14d135d828b7e19b:

common: test statfs reporting with project quota (2025-02-20 13:52:20 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/realtime-rmap_2025-02-20

for you to fetch changes up to b18c215bfdbfae74b29f427b6cf6695a9f4b2dc6:

fuzzy: create missing fuzz tests for rt rmap btrees (2025-02-20 13:52:21 -0800)

----------------------------------------------------------------
fstests: realtime reverse-mapping support [v6.5 09/22]

Fix a few regressions in fstests when rmap is enabled on the realtime
volume.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (13):
xfs: fix tests that try to access the realtime rmap inode
xfs/336: port to common/metadump
fuzz: for fuzzing the rtrmapbt, find the path to the rt rmap btree file
xfs: race fsstress with realtime rmap btree scrub and repair
xfs: fix various problems with fsmap detecting the data device
xfs/341: update test for rtgroup-based rmap
xfs/3{43,32}: adapt tests for rt extent size greater than 1
xfs/291: use _scratch_mkfs_sized instead of opencoding the logic
xfs/104: use _scratch_mkfs_sized
xfs/443: use file allocation unit, not dbsize
populate: adjust rtrmap calculations for rtgroups
populate: check that we created a realtime rmap btree of the given height
fuzzy: create missing fuzz tests for rt rmap btrees

common/populate    | 36 +++++++++++++++++++++++++-
common/xfs         | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
tests/xfs/104      |  6 ++---
tests/xfs/122.out  |  1 -
tests/xfs/1528     | 38 ++++++++++++++++++++++++++++
tests/xfs/1528.out |  4 +++
tests/xfs/1529     | 37 +++++++++++++++++++++++++++
tests/xfs/1529.out |  4 +++
tests/xfs/1817     | 39 ++++++++++++++++++++++++++++
tests/xfs/1817.out |  2 ++
tests/xfs/1821     | 45 +++++++++++++++++++++++++++++++++
tests/xfs/1821.out |  2 ++
tests/xfs/1857     | 39 ++++++++++++++++++++++++++++
tests/xfs/1857.out |  2 ++
tests/xfs/1893     |  2 +-
tests/xfs/272      |  2 +-
tests/xfs/276      |  2 +-
tests/xfs/277      |  2 +-
tests/xfs/291      |  2 +-
tests/xfs/332      |  6 +----
tests/xfs/332.out  |  2 --
tests/xfs/333      | 43 -------------------------------
tests/xfs/333.out  |  6 -----
tests/xfs/336      | 34 ++++++++-----------------
tests/xfs/336.out  |  4 +--
tests/xfs/337      |  2 +-
tests/xfs/338      | 30 ++++++++++++++++++----
tests/xfs/339      |  5 ++--
tests/xfs/340      | 25 ++++++++++++++----
tests/xfs/341      | 12 +++------
tests/xfs/341.out  |  1 -
tests/xfs/342      |  4 +--
tests/xfs/343      |  2 ++
tests/xfs/406      |  6 +++--
tests/xfs/407      |  6 +++--
tests/xfs/408      |  7 ++++--
tests/xfs/409      |  7 ++++--
tests/xfs/443      |  9 ++++---
tests/xfs/481      |  6 +++--
tests/xfs/482      |  7 ++++--
40 files changed, 431 insertions(+), 132 deletions(-)
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

