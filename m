Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756C519E98C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734635754; cv=none; b=X6HEJO0qtaRQlJoWFbkp/rN9XXpEMaTbSJPpkkL8VWbteosoQiNiFUxpBLQ0xQrAp8kbq9k4xvM+NAPAcmua1Eh888LT9KSKQ1mx6jOHlb6YEwCulM6z7Uax09BZhP65x5iZwOkKlvF3SAH77DW4h5bwcR6rcfuo5HLbjFBLE94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734635754; c=relaxed/simple;
	bh=0DJsreMYDEQvLYkPrYxKJKKshBjMAJvK2t1VkF1i9e8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=N6OVZwypCEzdRSq8al4lvKqXQ1GebyZGIXbD/MSNAjchTMcnwkquGhI1IkAlTvQGATpGX7Zp0nicct7qxnZzFU0TSYoBO6k90nqLfoij47cw7whJPlTB7bFBcMZZaMEL+9lY55uq24HqKxm8fpfs0ZmJFm5qkL0yZ/NE2v5H+Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5pv9X1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5pv9X1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4BEC4CED0;
	Thu, 19 Dec 2024 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734635754;
	bh=0DJsreMYDEQvLYkPrYxKJKKshBjMAJvK2t1VkF1i9e8=;
	h=Date:From:To:Cc:Subject:From;
	b=K5pv9X1+io/3uQ+pQnzQ5iAtWWJ73tx42gmv9L1m7R3LkUnwdmc7of2ucE/mdAyOX
	 datJl790XequfgPFQ5a8KZ5U0McJJPrbdjkqYe00AZbF7H5c4eCwfboZKwIOoA6h9r
	 LctjTolKgZJ1MSmtIgaeUpMVdgltpauEdWLFWl62DaDVr2diq/adQ45tn0wR8SQL9B
	 AoUnoYETs20VAzIW4q/Ohkw71gbN+Q0TjUnFFInD5Q/3MlyuOhpeOKPNtd4Vci37Mt
	 i4u+0b0Wmq+oLQAkDK/Qw8RNeCmZrMK0tbxlU7RoUVPDa3jCyrKmWyiSiZsabxrAnB
	 gLTSTOW+QbtKA==
Date: Thu, 19 Dec 2024 11:15:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB 6.14 v6.1] xfs: realtime rmap and reflink
Message-ID: <20241219191553.GI6160@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[resend, this time not as a reply to the v6.0 series]

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
