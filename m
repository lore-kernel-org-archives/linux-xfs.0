Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0AF143746
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924258; cv=none; b=plpbwuwULoPAOULWZ2G8I7SItdnI/hy7WPJwC9N02WzHSf0ajtLxGxteQxB3e5UNb8141pVPBAggiBApw0mxcBjvLu5SCFRuQtlaHACwL5RMfQdyirx6Ss9YHt9vq/FyMMo5ONGUrI2C8k5uBRAsF0FsG3N2apIt3zhaH+suceU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924258; c=relaxed/simple;
	bh=lHHak+HEl6CkExHdK6+/JqDavrujLEBVwOxNjKRkeeE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chssWQ8kHMFGW0jpCGDSYCj4heDQTeUtADLbfVAyB3ifwt9zOnZqwa15mT96znk3vreW8GXM7vSBNS9ubEH/FY+tcy1uR7Q3sSgW4bGGQfMMT7MGRjgQodUZIPAWhs26XJ2EBSBBZcY/xO8tCMPV5EpJa/gcaW+mq+4BZpep3EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQ6FT6JI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQ6FT6JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA726C2BD10;
	Thu, 20 Jun 2024 22:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924257;
	bh=lHHak+HEl6CkExHdK6+/JqDavrujLEBVwOxNjKRkeeE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LQ6FT6JIm/DkEe3CrW/X681GvpZclYicdL8yTpEMYEQ7e240JURsKvCvla/7yTKUk
	 ATQzSGTUI6tgItTCy4ng1gU6As0XDOh3lighL6NIzrUfZvrbFvJdBg2IZYrG2U30pR
	 1EWYLh35IDNPhK2h3GNTSkU9e5nQzgS51NydnadAS/ycErthrFsZ1Zm2RTDgY21a7+
	 ED2X1Y5RUdJaTpbnfeXmwUrswVpWsHQq7AGNcq4pZKii+n7aLeSdeG3rTjyTfz/s9X
	 FhMwlVCzScbShg7uNdSbm3L82h4fF3vayCvTkZ5DSZMDFGADlQB079clA4sblOKxe+
	 J8H5MBfvY6G/g==
Date: Thu, 20 Jun 2024 15:57:37 -0700
Subject: [PATCHSET v3.0 2/5] xfs: extent free log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
In-Reply-To: <20240620225033.GD103020@frogsfrogsfrogs>
References: <20240620225033.GD103020@frogsfrogsfrogs>
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

This series cleans up some warts in the extent freeing log intent code.
We start by acknowledging that this mechanism does not have anything to
do with the bmap code by moving it to xfs_alloc.c and giving the
function a more descriptive name.  Then we clean up the tracepoints and
the _finish_one call paths to pass the intent structure around.  This
reduces the overhead when the tracepoints are disabled and will make
things much cleaner when we start adding realtime support in the next
patch.  I also incorporated a bunch of cleanups from Christoph Hellwig.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=extfree-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=extfree-intent-cleanups
---
Commits in this patchset:
 * xfs: clean up extent free log intent item tracepoint callsites
 * xfs: convert "skip_discard" to a proper flags bitset
 * xfs: pass the fsbno to xfs_perag_intent_get
 * xfs: add a xefi_entry helper
 * xfs: reuse xfs_extent_free_cancel_item
 * xfs: factor out a xfs_efd_add_extent helper
 * xfs: remove duplicate asserts in xfs_defer_extent_free
 * xfs: remove xfs_defer_agfl_block
 * xfs: move xfs_extent_free_defer_add to xfs_extfree_item.c
---
 fs/xfs/libxfs/xfs_ag.c             |    2 -
 fs/xfs/libxfs/xfs_alloc.c          |   92 ++++++++---------------------
 fs/xfs/libxfs/xfs_alloc.h          |   12 ++--
 fs/xfs/libxfs/xfs_bmap.c           |   12 +++-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 -
 fs/xfs/libxfs/xfs_ialloc.c         |    5 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 -
 fs/xfs/libxfs/xfs_refcount.c       |    6 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 -
 fs/xfs/scrub/newbt.c               |    5 +-
 fs/xfs/scrub/reap.c                |    7 +-
 fs/xfs/xfs_bmap_item.c             |    6 --
 fs/xfs/xfs_drain.c                 |    8 +--
 fs/xfs/xfs_drain.h                 |    5 +-
 fs/xfs/xfs_extfree_item.c          |  115 +++++++++++++++++-------------------
 fs/xfs/xfs_extfree_item.h          |    6 ++
 fs/xfs/xfs_refcount_item.c         |    5 --
 fs/xfs/xfs_reflink.c               |    2 -
 fs/xfs/xfs_rmap_item.c             |    5 --
 fs/xfs/xfs_trace.h                 |   33 +++++-----
 20 files changed, 141 insertions(+), 191 deletions(-)

