Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0631A9B32
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734635659; cv=none; b=EeBf8WuOTIbcLQamMT/PP6A6tDbW63xbwcqW4/crSR3fVzx5DFbTkstBXbnfV+/QdwEVoDVI6SQwT72ef9TgJKfkcSBID/OtF6sPC4okmIH2wRywT3MAdOrND7DP6G5qiBwMyLUx75XCbdZtzDA6MVogsxbDKl7o9606BhRjYLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734635659; c=relaxed/simple;
	bh=A/J21ppEsaimP63MU4RG+wiU1SJdSVIe/eRxUT89S5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABrwvm3COaseeG1VLNNVgXA0Ci3U0Xd/B8Rs45S0U51qdRWQ2uv2vqb8H8LerZ3LSStrcbIoFrjFC1qyeHo0wZTKSVbGevmxF9dwfsRIKLYRMWQ3p4i7Jp8UoNV8zIA62ZyeV0oFAcVKZjkgrsXhwxPI8ZPicyBvjO/c4KoAAws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jk8LeRpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jk8LeRpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B37C4CECE;
	Thu, 19 Dec 2024 19:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734635659;
	bh=A/J21ppEsaimP63MU4RG+wiU1SJdSVIe/eRxUT89S5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jk8LeRpMSDF9hcC/gNTkc6p6dMKopeFQujY3OkhY1s3cTYGYWvJ6IIqgBgnhuDUFD
	 q9vU0A2R48UXPh1zoUwGpe+Gc7x1Zyke7X5zVXQywGu1Fb6m2MCLHwjMFaggX1SJj8
	 CDOR1aUkd9jFJnGZ8nsu+jL4UyFvqCdiENsgZBA0Acdl/vX1ws6Cb7GPNmPUJVX+ue
	 2+WXCVF8wx5iURYFxpPQ9MK/2mmRIkFjqa8EJ4ddvZ9T+qnopD9eiJsPo4CB84wLUh
	 9fa2GljcSzKdDrOnLPCgSE1KUXUM2SsBXHA1YIeUq0zlIx7Qs9iSILstIq0VOyMlou
	 nahKaMsgfYJBg==
Date: Thu, 19 Dec 2024 11:14:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB 6.14 v6.1] xfs: realtime rmap and reflink
Message-ID: <20241219191418.GP6174@frogsfrogsfrogs>
References: <20241213005314.GJ6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213005314.GJ6678@frogsfrogsfrogs>

Hi everyone,

Christoph and I have been working on getting the long-delayed port of
reverse mapping and reflink to the realtime device into mergeable shape.
With these changes, the realtime volume finally reaches feature parity
with the data device.  This is the base for building more functionality
into xfs, such as the zoned storage support that Christoph posted last
week.

Since v6.0 I've added Christoph's review tags, and folded in the
documentation updates requested during review.

The first patchset are bug fixes.  The final patchset are a few xfsprogs
patches that complete the metadir/rtgroups changes.  Both of these are
technically 6.13 material.

The second and third patchsets are all cleanups and refactoring so that
we can fully support having btrees rooted in an inode's data fork.  This
is necessary because the generic btree code only supports using the
immediate area as an internal tree node -- conversion from extents to
bmbt format only happens when there are too many leaf records to fit in
the immediate area.  Therefore, we need to remodel it to support storing
records in the immediate area.  We also need to be able to reserve space
for future btree expansion, so the second patchset enables tracking
per-inode reservations from the free space.

The fourth patchset ports reverse mapping btree to the realtime device,
which mainly consists of constructing a btree in an inode, linking the
inode into the metadata directory tree, and updating the log items to
handle rt rmap update log intent items.

The fifth patchset ports the refcount btree, block sharing, and copy on
write to the realtime device.

I dropped the fifth patchset from v6.0 because rtextsize>1 is a fringe
feature and doesn't need to be added right now.

Please have a look at the git tree links for code changes:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink_2024-12-19
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink_2024-12-19
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink_2024-12-19

(fstests is still behind because I haven't rebased atop the parallel
fstests work)

These are the patches that haven't passed review yet.

[PATCHSET 1/5] xfs: bug fixes for 6.13
  [PATCH 2/2] xfs: release the dquot buf outside of qli_lock
[PATCHSET v6.1 3/5] xfs: enable in-core block reservation for rt
  [PATCH 1/2] xfs: prepare to reuse the dquot pointer space in struct
  [PATCH 2/2] xfs: allow inode-based btrees to reserve space in the
[PATCHSET v6.1 4/5] xfs: realtime reverse-mapping support
  [PATCH 27/37] xfs: online repair of realtime file bmaps
  [PATCH 32/37] xfs: online repair of the realtime rmap btree
  [PATCH 35/37] xfs: don't shut down the filesystem for media failures
  [PATCH 36/37] xfs: react to fsdax failure notifications on the rt
  [PATCH 37/37] xfs: enable realtime rmap btree
[PATCHSET v6.1 5/5] xfs: reflink on the realtime device
  [PATCH 28/43] xfs: scrub the realtime refcount btree
  [PATCH 42/43] xfs: fix CoW forks for realtime files
  [PATCH 43/43] xfs: enable realtime reflink
[PATCHSET v6.1] xfsprogs: last few bits of rtgroups patches
  [PATCH 1/3] xfs_db: drop the metadata checking code from blockget
  [PATCH 2/3] xfs_mdrestore: refactor open-coded fd/is_file into a
  [PATCH 3/3] xfs_mdrestore: restore rt group superblocks to realtime

--D
