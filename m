Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0B93FD4;
	Wed, 19 Feb 2025 00:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739925834; cv=none; b=WKDeUjqyl8LmxtuFjn/28si+7f62HJmVvc4mWsMijNKEj8J7ws5O7s65+Sq+yZXVCr86vDZ207yvXUYlOzHKqpn+sfKWaldJ2wrH9YqhD8KqdIpwK4aLnLV50KSGIsMv7HklFK9RooyoLWj78dHaxSXi8uM5SR3YW/upgTZZZqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739925834; c=relaxed/simple;
	bh=0PxecSmyQW5YO+QHbAgnXbHMjNG3fJ076kX5dM+DD38=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eL3rnE8IG/k237WmgPNHOfwv8J31yp0CEKVAopolv0YYv2oCsENxkWQKl/Qz/LVvjkHaDuVswCy6NneoRhVYzpEm+ISn4Fg8Fuvd0CYq1nYlFN+lRJbnxDodI+OQUH0ecP1tEkSiOLY95mAc6qQPQ/hIR7iqgYdFF9xK9eNhRaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V166Kz/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V166Kz/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BEAC4CEE6;
	Wed, 19 Feb 2025 00:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739925834;
	bh=0PxecSmyQW5YO+QHbAgnXbHMjNG3fJ076kX5dM+DD38=;
	h=Date:From:To:Cc:Subject:From;
	b=V166Kz/zZOFohzOHkdqOMOUlHn/JSDkieLlptQZJSFY0iRFFMicfUdjo3sLJWe23l
	 VTb5KipJ4wZHObaPcGloFrh0vNhjcahdvqLsv8fHnN+ez/vICxO2JOsx5pD44VxTIF
	 KrqEq3y3PbcbVMm3RYmDKEdPNPjDa/TbdmuNn0ZkXAn61rYwsIIy4BebBNUazKlB0d
	 fttwdNptnLTtSC//Go4MhvLRbyImzv2uv17GirK1N4X75nU1OjjFzhb9t7rlCO7F8q
	 xjWHwyh7gf48L4hHj+DmBx6N51XFY8f6wVFU84cFK3rvvvc4EKQKAGmu356VoJ0X7X
	 PiOPJqFT3siqg==
Date: Tue, 18 Feb 2025 16:43:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB] fstests: catch us up to 6.12-6.14 changes
Message-ID: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

As most developers are aware, the fstests for-next branch has not moved
forward since early December.  That logjam is hopefully resolved at long
last in the patches-in-queue branch:

https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/log/?h=patches-in-queue

So here's all the stuff that I was *going* to send late last year to
catch up fstests to the final versions of online fsck (6.12) and the xfs
metadata directory changes (6.13).  I'm adding the realtime rmap and
reflink changes (6.14) because we're three weeks past the merge window.

These patches are (more or less) based atop the patches in queue branch.
First come some fixes for last week's for-next push, and some gentle
reworking of the zeroout support in the log replay code that I was
working on last October.

After that is all the 6.12-6.14 stuff, and a functional test for the
rdump command that's out for review.  Apologies for the huge dump, I
was not expecting things to back up for 79 days.

You might want to just pull the branch:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=rdump_2025-02-18

--Darrick

Here's the list of unreviewed patches, though it's basically every patch
in here.

[PATCHSET 01/12] fstests: more random fixes for v2025.02.16
  [PATCH 1/2] dio-writeback-race: fix missing mode in O_CREAT
  [PATCH 2/2] dio_writeback_race: align the directio buffer to base
[PATCHSET 02/12] fstests: fix logwrites zeroing
  [PATCH 1/3] logwrites: warn if we don't think read after discard
  [PATCH 2/3] logwrites: use BLKZEROOUT if it's available
  [PATCH 3/3] logwrites: only use BLKDISCARD if we know discard zeroes
[PATCHSET v32.1 03/12] fstests: fix online and offline fsck test
  [PATCH 01/12] misc: drop the dangerous label from xfs_scrub fsstress
  [PATCH 02/12] misc: rename the dangerous_repair group to
  [PATCH 03/12] misc: rename the dangerous_online_repair group to
  [PATCH 04/12] misc: rename the dangerous_bothrepair group to
  [PATCH 05/12] misc: rename the dangerous_norepair group to
  [PATCH 06/12] misc: fix misclassification of xfs_repair fuzz tests
  [PATCH 07/12] misc: fix misclassification of xfs_scrub + xfs_repair
  [PATCH 08/12] misc: fix misclassification of verifier fuzz tests
  [PATCH 09/12] misc: add xfs_scrub + xfs_repair fuzz tests to the
  [PATCH 10/12] misc: remove the dangerous_scrub group
  [PATCH 11/12] xfs/28[56],xfs/56[56]: add to the auto group
  [PATCH 12/12] xfs/349: reclassify this test as not dangerous
[PATCHSET v6.4 04/12] fstests: enable metadir
  [PATCH 01/12] various: fix finding metadata inode numbers when
  [PATCH 02/12] xfs/{030,033,178}: forcibly disable metadata directory
  [PATCH 03/12] common/repair: patch up repair sb inode value
  [PATCH 04/12] xfs/206: update for metadata directory support
  [PATCH 05/12] xfs/{050,144,153,299,330}: update quota reports to
  [PATCH 06/12] xfs/509: adjust inumbers accounting for metadata
  [PATCH 07/12] xfs: create fuzz tests for metadata directories
  [PATCH 08/12] xfs/163: bigger fs for metadir
  [PATCH 09/12] xfs/122: disable this test for any codebase that knows
  [PATCH 10/12] common/populate: label newly created xfs filesystems
  [PATCH 11/12] scrub: race metapath online fsck with fsstress
  [PATCH 12/12] xfs: test metapath repairs
[PATCHSET v6.4 05/12] fstests: make protofiles less janky
  [PATCH 1/4] xfs/019: reduce _fail calls in test
  [PATCH 2/4] xfs/019: test reserved file support
  [PATCH 3/4] xfs: test filesystem creation with xfs_protofile
  [PATCH 4/4] fstests: test mkfs.xfs protofiles with xattr support
[PATCHSET v6.4 06/12] fstests: shard the realtime section
  [PATCH 01/15] common/populate: refactor caching of metadumps to a
  [PATCH 02/15] common/{fuzzy,populate}: use _scratch_xfs_mdrestore
  [PATCH 03/15] fuzzy: stress data and rt sections of xfs filesystems
  [PATCH 04/15] fuzzy: run fsx on data and rt sections of xfs
  [PATCH 05/15] common/ext4: reformat external logs during mdrestore
  [PATCH 06/15] common/populate: use metadump v2 format by default for
  [PATCH 07/15] punch-alternating: detect xfs realtime files with large
  [PATCH 08/15] xfs/206: update mkfs filtering for rt groups feature
  [PATCH 09/15] common: pass the realtime device to xfs_db when
  [PATCH 10/15] xfs/185: update for rtgroups
  [PATCH 11/15] xfs/449: update test to know about xfs_db -R
  [PATCH 12/15] xfs/271,xfs/556: fix tests to deal with rtgroups output
  [PATCH 13/15] common/xfs: capture realtime devices during
  [PATCH 14/15] common/fuzzy: adapt the scrub stress tests to support
  [PATCH 15/15] xfs: fix fuzz tests of rtgroups bitmap and summary
[PATCHSET v6.4 07/12] fstests: store quota files in the metadir
  [PATCH 1/4] xfs: update tests for quota files in the metadir
  [PATCH 2/4] xfs: test persistent quota flags
  [PATCH 3/4] xfs: fix quota detection in fuzz tests
  [PATCH 4/4] xfs: fix tests for persistent qflags
[PATCHSET v6.4 08/12] fstests: enable quota for realtime volumes
  [PATCH 1/3] common: enable testing of realtime quota when supported
  [PATCH 2/3] xfs: fix quota tests to adapt to realtime quota
  [PATCH 3/3] xfs: regression testing of quota on the realtime device
[PATCHSET 09/12] fstests: check new 6.14 behaviors
  [PATCH 1/1] common: test statfs reporting with project quota
[PATCHSET v6.4 10/12] fstests: realtime reverse-mapping support
  [PATCH 01/13] xfs: fix tests that try to access the realtime rmap
  [PATCH 02/13] xfs/336: port to common/metadump
  [PATCH 03/13] fuzz: for fuzzing the rtrmapbt,
  [PATCH 04/13] xfs: race fsstress with realtime rmap btree scrub and
  [PATCH 05/13] xfs: fix various problems with fsmap detecting the data
  [PATCH 06/13] xfs/341: update test for rtgroup-based rmap
  [PATCH 07/13] xfs/3{43,32}: adapt tests for rt extent size greater
  [PATCH 08/13] xfs/291: use _scratch_mkfs_sized instead of opencoding
  [PATCH 09/13] xfs: skip tests if formatting small filesystem fails
  [PATCH 10/13] xfs/443: use file allocation unit, not dbsize
  [PATCH 11/13] populate: adjust rtrmap calculations for rtgroups
  [PATCH 12/13] populate: check that we created a realtime rmap btree
  [PATCH 13/13] fuzzy: create missing fuzz tests for rt rmap btrees
[PATCHSET v6.4 11/12] fstests: reflink on the realtime device
  [PATCH 1/7] common/populate: create realtime refcount btree
  [PATCH 2/7] xfs: create fuzz tests for the realtime refcount btree
  [PATCH 3/7] xfs/27[24]: adapt for checking files on the realtime
  [PATCH 4/7] xfs: race fsstress with realtime refcount btree scrub and
  [PATCH 5/7] xfs: remove xfs/131 now that we allow reflink on realtime
  [PATCH 6/7] generic/331,xfs/240: support files that skip delayed
  [PATCH 7/7] common/xfs: fix _xfs_get_file_block_size when rtinherit
[PATCHSET 12/12] fstests: dump fs directory trees
  [PATCH 1/1] xfs: test filesystem recovery with rdump
