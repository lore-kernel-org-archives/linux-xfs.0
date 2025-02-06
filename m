Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322E923C390
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738880483; cv=none; b=oDEUdHldCI6xeUaao1U4x9p2HNb3Fc/kfFmgjO9Iv7UjJHsu3DM2Ns19JLYsnrGFyFu2Mv7vrkAX6MBFLYh8p6SWFU5ts0J0EJPr/FmT5NzsH79juAjXjHwpYRs8sIoQiQJz5O9OXOXpUDr1Egjzr1a4kLXGt9DbHI7QL5sf6X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738880483; c=relaxed/simple;
	bh=B0Pdf4NSx5k5AXWZ/5z4jJauzTJM6ozLtZg2QE/55+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NyjWe3kWLDUa0c7BQWjAqyOKzn/Sf7KaGz42Y4AFeo7fA3hk0/1p3GwknReAZFNyOb9yTfc5pryf/boVRt9rD9N/ZQ5aNwdjdkWDekX2NYjIcl35fN4C7fdwZgywmR6hDtuI4hM+0b8JOpHd5S77yQUeiGs38UZJbGgj1nSZHs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sidki2ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sidki2ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE6DC4CEDD;
	Thu,  6 Feb 2025 22:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738880482;
	bh=B0Pdf4NSx5k5AXWZ/5z4jJauzTJM6ozLtZg2QE/55+Y=;
	h=Date:From:To:Cc:Subject:From;
	b=sidki2iahRImbMdOd73pPU3B2iQwXYmjo8Sk6VbxcNXGRG/IJzHSALttS+17KyALS
	 SCvGJ+NRA6tOLp+GvmgQzzRxe49EIRIcoKjgfjXRZghOTZ1WxLGZcZ4m2AhG4mkXck
	 pBvhLWOwR0zW8yNLcaBu1A/uZx/v4mRqZyaPceaCc4n5sLg+hf+6yEt6aVhHODaGli
	 ARco6Nu9hFCdpfBlO7F/ZLTzjh0S0I3IQEvw2mc5IoZZyVKmHyXH98/RnFVDWnu3Jf
	 U2oNaWDTTJKJXRfgtPvkKWiSoDaqk9gy0S8UAs0VVYxCiwikPFDMPHmc6aKra9xsbE
	 oD17kshDo7ibw==
Date: Thu, 6 Feb 2025 14:21:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB] xfsprogs: all my changes for 6.14
Message-ID: <20250206222122.GA21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Now that I /think/ we're done with xfsprogs 6.13, here's a patchbomb
with all my code submissions for xfsprogs 6.14.  The first patchset
fixes some performance problems that Christoph observed with metadir
enabled and a very large number of rtgroups.

The second patchset is the usual libxfs resync; I'll only post it once
for archiving on the list.

The third and fourth patchsets implement all the userspace code needed
to handle reverse mapping and reflinks on the realtime volume.

The fifth patchset implements an "rdump" command for xfs_db.  This tool
has two intended users: support and recovery people who have a badly
damaged unmountable filesystem who want to try to extract as much of a
subdirectory as they can; and people who realize that they have an old
XFSv4 filesystem containing files they want, but kernel support for that
has been removed and finding/running an old kernel isn't possible or as
easy as running a program.

Nearly everything in here is unreviewed, but here's the list in case you
were wondering:

[PATCHSET 1/5] xfs_scrub: fixes and cleanups for inode iteration
  [PATCH 01/17] libxfs: unmap xmbuf pages to avoid disaster
  [PATCH 03/17] man: document new XFS_BULK_IREQ_METADIR flag to
  [PATCH 04/17] libfrog: wrap handle construction code
  [PATCH 05/17] xfs_scrub: don't report data loss in unlinked inodes
  [PATCH 06/17] xfs_scrub: call bulkstat directly if we're only
  [PATCH 07/17] xfs_scrub: remove flags argument from
  [PATCH 08/17] xfs_scrub: selectively re-run bulkstat after re-running
  [PATCH 09/17] xfs_scrub: actually iterate all the bulkstat records
  [PATCH 10/17] xfs_scrub: don't double-scan inodes during phase 3
  [PATCH 11/17] xfs_scrub: don't (re)set the bulkstat request icount
  [PATCH 12/17] xfs_scrub: don't complain if bulkstat fails
  [PATCH 13/17] xfs_scrub: return early from bulkstat_for_inumbers if
  [PATCH 14/17] xfs_scrub: don't blow away new inodes in
  [PATCH 15/17] xfs_scrub: hoist the phase3 bulkstat single stepping
  [PATCH 16/17] xfs_scrub: ignore freed inodes when single-stepping
  [PATCH 17/17] xfs_scrub: try harder to fill the bulkstat array with
[PATCHSET 2/5] xfsprogs: new libxfs code from kernel 6.14
[PATCHSET v6.2 3/5] xfsprogs: realtime reverse-mapping support
  [PATCH 01/27] libxfs: compute the rt rmap btree maxlevels during
  [PATCH 02/27] libxfs: add a realtime flag to the rmap update log redo
  [PATCH 03/27] libfrog: enable scrubbing of the realtime rmap
  [PATCH 04/27] man: document userspace API changes due to rt rmap
  [PATCH 05/27] xfs_db: compute average btree height
  [PATCH 06/27] xfs_db: don't abort when bmapping on a non-extents/bmbt
  [PATCH 07/27] xfs_db: display the realtime rmap btree contents
  [PATCH 08/27] xfs_db: support the realtime rmapbt
  [PATCH 09/27] xfs_db: copy the realtime rmap btree
  [PATCH 10/27] xfs_db: make fsmap query the realtime reverse mapping
  [PATCH 11/27] xfs_db: add an rgresv command
  [PATCH 12/27] xfs_spaceman: report health status of the realtime rmap
  [PATCH 13/27] xfs_repair: tidy up rmap_diffkeys
  [PATCH 14/27] xfs_repair: flag suspect long-format btree blocks
  [PATCH 15/27] xfs_repair: use realtime rmap btree data to check block
  [PATCH 16/27] xfs_repair: create a new set of incore rmap information
  [PATCH 17/27] xfs_repair: refactor realtime inode check
  [PATCH 18/27] xfs_repair: find and mark the rtrmapbt inodes
  [PATCH 19/27] xfs_repair: check existing realtime rmapbt entries
  [PATCH 20/27] xfs_repair: always check realtime file mappings against
  [PATCH 21/27] xfs_repair: rebuild the realtime rmap btree
  [PATCH 22/27] xfs_repair: check for global free space concerns with
  [PATCH 23/27] xfs_repair: rebuild the bmap btree for realtime files
  [PATCH 24/27] xfs_repair: reserve per-AG space while rebuilding rt
  [PATCH 25/27] xfs_logprint: report realtime RUIs
  [PATCH 26/27] mkfs: add some rtgroup inode helpers
  [PATCH 27/27] mkfs: create the realtime rmap inode
[PATCHSET v6.2 4/5] xfsprogs: reflink on the realtime device
  [PATCH 01/22] libxfs: compute the rt refcount btree maxlevels during
  [PATCH 02/22] libxfs: add a realtime flag to the refcount update log
  [PATCH 03/22] libxfs: apply rt extent alignment constraints to CoW
  [PATCH 04/22] libfrog: enable scrubbing of the realtime refcount data
  [PATCH 05/22] man: document userspace API changes due to rt reflink
  [PATCH 06/22] xfs_db: display the realtime refcount btree contents
  [PATCH 07/22] xfs_db: support the realtime refcountbt
  [PATCH 08/22] xfs_db: copy the realtime refcount btree
  [PATCH 09/22] xfs_db: add rtrefcount reservations to the rgresv
  [PATCH 10/22] xfs_spaceman: report health of the realtime refcount
  [PATCH 11/22] xfs_repair: allow CoW staging extents in the realtime
  [PATCH 12/22] xfs_repair: use realtime refcount btree data to check
  [PATCH 13/22] xfs_repair: find and mark the rtrefcountbt inode
  [PATCH 14/22] xfs_repair: compute refcount data for the realtime
  [PATCH 15/22] xfs_repair: check existing realtime refcountbt entries
  [PATCH 16/22] xfs_repair: reject unwritten shared extents
  [PATCH 17/22] xfs_repair: rebuild the realtime refcount btree
  [PATCH 18/22] xfs_repair: allow realtime files to have the reflink
  [PATCH 19/22] xfs_repair: validate CoW extent size hint on rtinherit
  [PATCH 20/22] xfs_logprint: report realtime CUIs
  [PATCH 21/22] mkfs: validate CoW extent size hint when rtinherit is
  [PATCH 22/22] mkfs: enable reflink on the realtime device
[PATCHSET 5/5] xfsprogs: dump fs directory trees
  [PATCH 1/4] xfs_db: pass const pointers when we're not modifying them
  [PATCH 2/4] xfs_db: use an empty transaction to try to prevent
  [PATCH 3/4] xfs_db: make listdir more generally useful
  [PATCH 4/4] xfs_db: add command to copy directory trees out of

--D
