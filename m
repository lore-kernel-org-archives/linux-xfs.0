Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFDB33E8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307532; cv=none; b=hHtWgutzVpk8KiSYIci/MhivKyckoodRWQhRGBWV0O2O/QEmsrgQI/P2/bpHZcgHM2/+ATxL29G2BNnKijixOJPG5m+1svQGQghSxGt8KNTlA9JU3dt/NwuqUIFoaQYLFfbVxXSy/8+wo8XRow1ABqQLno/bJdzTO0bbdGEX+ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307532; c=relaxed/simple;
	bh=nYmB2qIQnEfonwz6ZaCerovnZbKqOezV1b0VUAn8hbQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=fIYDhQe29+jW8HlHB8ycQr5eiodpZKAmISMzOG0MPIIcceJH8HUbgrFhXUgXjQcLFlhESdgvv8cQCWiYxZtf/njcqHt+SUoLmaIiLnep1WZr91GmkZJCfuamG7X0hRafEOuvjNabxuf2VVq8cpehciw94IEhxLSIaAqYBiQ8Iyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q/Avt5RD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/Avt5RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED05C32786;
	Tue, 30 Jul 2024 02:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307531;
	bh=nYmB2qIQnEfonwz6ZaCerovnZbKqOezV1b0VUAn8hbQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q/Avt5RDj3A0Ojyh85Qz2wVBjOE90fGwnjCa1wr7X/0QgrtnY55+35OMbjCS5kn/T
	 17nci/pPeeY8ibf4fNKE8I3k2P4pVif0J+4E6/YqKu2DugKm5WlzPwmjcZRChAQQ/X
	 bVsKHCj43fnrZi6hdUAvrh/HDA11/Mgk48++K75wwry/Nnb50AB+GgFq3b9fBS9MXN
	 17XatsEZnhISQfHA60shjgt4zYdfFnShcdsGH8QPAHsC1LpoNXt4OXzMtFtxBNm9h/
	 1KNfzXqmn8X1Rmu7hxd9YP/++uYzghTL026/TFo8CJ6Z+OPepFjCZtmfIRGH9cqWpq
	 hF8JdtNK3MdbQ==
Date: Mon, 29 Jul 2024 19:45:31 -0700
Subject: [GIT PULL 20/23] xfsprogs: offline repair for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459824.1455085.8492552821249651926.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 4b327cc2f5d03b772dd6d3352cbe28452cd41ef0:

man2: update ioctl_xfs_scrub_metadata.2 for parent pointers (2024-07-29 17:01:12 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-pptrs-6.10_2024-07-29

for you to fetch changes up to 7ea215189a3cac45cb9323439318fcc3410727d4:

xfs_repair: wipe ondisk parent pointers when there are none (2024-07-29 17:01:13 -0700)

----------------------------------------------------------------
xfsprogs: offline repair for parent pointers [v13.8 20/28]

This series implements online checking and repair for directory parent
pointer metadata.  The checking half is fairly straightforward -- for
each outgoing directory link (forward or backwards), grab the inode at
the other end, and confirm that there's a corresponding link.  If we
can't grab an inode or lock it, we'll save that link for a slower loop
that cycles all the locks, confirms the continued existence of the link,
and rechecks the link if it's actually still there.

Repairs are a bit more involved -- for directories, we walk the entire
filesystem to rebuild the dirents from parent pointer information.
Parent pointer repairs do the same walk but rebuild the pptrs from the
dirent information, but with the added twist that it duplicates all the
xattrs so that it can use the atomic extent swapping code to commit the
repairs atomically.

This introduces an added twist to the xattr repair code -- we use dirent
hooks to detect a colliding update to the pptr data while we're not
holding the ILOCKs; if one is detected, we restart the xattr salvaging
process but this time hold all the ILOCKs until the end of the scan.

For offline repair, the phase6 directory connectivity scan generates an
index of all the expected parent pointers in the filesystem.  Then it
walks each file and compares the parent pointers attached to that file
against the index generated, and resyncs the results as necessary.

The last patch teaches xfs_scrub to report pathnames of files that are
being repaired, when possible.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (12):
xfs_db: remove some boilerplate from xfs_attr_set
xfs_db: actually report errors from libxfs_attr_set
xfs_repair: junk parent pointer attributes when filesystem doesn't support them
xfs_repair: add parent pointers when messing with /lost+found
xfs_repair: junk duplicate hashtab entries when processing sf dirents
xfs_repair: build a parent pointer index
xfs_repair: move the global dirent name store to a separate object
xfs_repair: deduplicate strings stored in string blob
xfs_repair: check parent pointers
xfs_repair: dump garbage parent pointer attributes
xfs_repair: update ondisk parent pointer records
xfs_repair: wipe ondisk parent pointers when there are none

db/attrset.c             |   36 +-
libxfs/libxfs_api_defs.h |    6 +
libxfs/xfblob.c          |    9 +
libxfs/xfblob.h          |    2 +
repair/Makefile          |    6 +
repair/attr_repair.c     |   30 ++
repair/listxattr.c       |  271 ++++++++++
repair/listxattr.h       |   15 +
repair/phase6.c          |  121 ++++-
repair/pptr.c            | 1331 ++++++++++++++++++++++++++++++++++++++++++++++
repair/pptr.h            |   17 +
repair/strblobs.c        |  211 ++++++++
repair/strblobs.h        |   24 +
13 files changed, 2069 insertions(+), 10 deletions(-)
create mode 100644 repair/listxattr.c
create mode 100644 repair/listxattr.h
create mode 100644 repair/pptr.c
create mode 100644 repair/pptr.h
create mode 100644 repair/strblobs.c
create mode 100644 repair/strblobs.h

