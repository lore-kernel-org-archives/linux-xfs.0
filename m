Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5DD1EA7CB;
	Wed, 19 Feb 2025 00:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926125; cv=none; b=eBSvvTFMOIOX9tMUvBXcPmOcBwbAdNugLIY17yzU7Bny5b9hxwzIa2xR4GF0xALJ4LwtMlaLKdbC/0pcVAdmtzolx9YYdXAcF9FaXdX2fjz1UkdPDwwWwpcbSNloUe1q9cHh2hUmAij6j8pshDUrKuOElu1nFp/KTbm7Uufe36s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926125; c=relaxed/simple;
	bh=EwHkym60kR3igc1KHLR0eJc/wv9ymOOk5Cmlw5/kugo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B8ZjaK+HO1Ed8LVQjjGpJApGuKbGABh1QSJ/+kLX0rR0gidhh2c2Kxptb3pmiEc7xGKRrbGRb5pEBzwEczaLHSF25fuIUv0rpQfPxqoIMdBkBmdDOJ1Uo5SidV6a6rjxo9eWezFJ+CMUfMVq0KAfIo21z+3dZZWkjD0eNZu8+QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLdff/HL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLdff/HL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22ED3C4CEE2;
	Wed, 19 Feb 2025 00:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926125;
	bh=EwHkym60kR3igc1KHLR0eJc/wv9ymOOk5Cmlw5/kugo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bLdff/HL71kj06I1HKsURwlYxJgiN9pdCpQ2TMVBsvvfJ09KQ7H0Dz+6lQ9YdbJkz
	 8IY5KkzdAg21LR01/OrkKpPrie3VeicGhc7RnI+vH0UAKRkehzJvWDqPGfU1Y/xBEe
	 04yChf6l8Ntf3W4wFvuRH1hUVTpSnt2VsLQ8UTS1riqTT197sIL/BdhIhEQzfprzJU
	 ZaQtqu4HTlUz3gpwUMvFG8YT0A5Sv3Yvvh9dKlPj5ArdSF1wuDREeH/rnDvx5hJbnG
	 VZf7DZ7y2qbJ7tkvRPK88F7erLOui2cb+7ws5tJ1X9sm81e1UY619OLWzJ4nae90oy
	 DcJcnLLVOZH8w==
Date: Tue, 18 Feb 2025 16:48:44 -0800
Subject: [PATCHSET v6.4 11/12] fstests: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
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

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then widening of the
API parameters; and introduction of the new btree format and inode fork
format.  Next comes enabling CoW and remapping for the rt device; new
scrub, repair, and health reporting code; and at the end we implement
some code to lengthen write requests so that rt extents are always CoWed
fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
Commits in this patchset:
 * common/populate: create realtime refcount btree
 * xfs: create fuzz tests for the realtime refcount btree
 * xfs/27[24]: adapt for checking files on the realtime volume
 * xfs: race fsstress with realtime refcount btree scrub and repair
 * xfs: remove xfs/131 now that we allow reflink on realtime volumes
 * generic/331,xfs/240: support files that skip delayed allocation
 * common/xfs: fix _xfs_get_file_block_size when rtinherit is set and no rt section
---
 common/populate       |   26 ++++++++++++++++++---
 common/xfs            |   15 ++++++++++++
 tests/generic/331     |   13 +++++++++-
 tests/generic/331.out |    2 +-
 tests/xfs/131         |   46 ------------------------------------
 tests/xfs/131.out     |    5 ----
 tests/xfs/1538        |   38 ++++++++++++++++++++++++++++++
 tests/xfs/1538.out    |    4 +++
 tests/xfs/1539        |   38 ++++++++++++++++++++++++++++++
 tests/xfs/1539.out    |    4 +++
 tests/xfs/1540        |   38 ++++++++++++++++++++++++++++++
 tests/xfs/1540.out    |    4 +++
 tests/xfs/1541        |   39 +++++++++++++++++++++++++++++++
 tests/xfs/1541.out    |    4 +++
 tests/xfs/1542        |   38 ++++++++++++++++++++++++++++++
 tests/xfs/1542.out    |    4 +++
 tests/xfs/1543        |   37 +++++++++++++++++++++++++++++
 tests/xfs/1543.out    |    4 +++
 tests/xfs/1544        |   37 +++++++++++++++++++++++++++++
 tests/xfs/1544.out    |    4 +++
 tests/xfs/1545        |   38 ++++++++++++++++++++++++++++++
 tests/xfs/1545.out    |    4 +++
 tests/xfs/1818        |   40 ++++++++++++++++++++++++++++++++
 tests/xfs/1818.out    |    2 ++
 tests/xfs/1819        |   40 ++++++++++++++++++++++++++++++++
 tests/xfs/1819.out    |    2 ++
 tests/xfs/1893        |    2 +-
 tests/xfs/240         |   12 ++++++++-
 tests/xfs/240.out     |    2 +-
 tests/xfs/272         |   40 +++++++++++++++++++++-----------
 tests/xfs/274         |   62 ++++++++++++++++++++++++++++++++++---------------
 31 files changed, 551 insertions(+), 93 deletions(-)
 delete mode 100755 tests/xfs/131
 delete mode 100644 tests/xfs/131.out
 create mode 100755 tests/xfs/1538
 create mode 100644 tests/xfs/1538.out
 create mode 100755 tests/xfs/1539
 create mode 100644 tests/xfs/1539.out
 create mode 100755 tests/xfs/1540
 create mode 100644 tests/xfs/1540.out
 create mode 100755 tests/xfs/1541
 create mode 100644 tests/xfs/1541.out
 create mode 100755 tests/xfs/1542
 create mode 100644 tests/xfs/1542.out
 create mode 100755 tests/xfs/1543
 create mode 100644 tests/xfs/1543.out
 create mode 100755 tests/xfs/1544
 create mode 100644 tests/xfs/1544.out
 create mode 100755 tests/xfs/1545
 create mode 100644 tests/xfs/1545.out
 create mode 100755 tests/xfs/1818
 create mode 100644 tests/xfs/1818.out
 create mode 100755 tests/xfs/1819
 create mode 100644 tests/xfs/1819.out

