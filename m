Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C346AD50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881562; cv=none; b=SRAKKZDcuE66E6u62SEtwk+GMG2w983gZg/Oafzub/Hn2cmdy6XeaSmZzOgNu45Hy6UynwoYZSIAa7WYavrk+EPRJfTmCl6Oi5bf2xC1gmeYC5LYrYowy6Ie/fGSoyaM5KDHbw8QDv+FEc10WvSZL0VW6Rxz0dxeQqn/zPKXzEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881562; c=relaxed/simple;
	bh=dl8harBhQIocM4VA+a+Se2OKaY3v3ayPpZQH7Vc7NNE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ukpVNhideJRCzNpm+o9qGL+SlPnV6Pi3M4AuB0YMm71Owq7Y3WizX3mQmiXl+X8Pmy2HieqAhLd1AaKaxZfT28Ud8HpCaA7813y6JgqVgSZIW9skAjOTf9MigjOCIPf2PdV0EVG3StB3/U5PEAYUkGPBb8c6Z0dsL5Jfyatdxk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCFBEKBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCFBEKBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ACFC116B1;
	Tue,  2 Jul 2024 00:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881562;
	bh=dl8harBhQIocM4VA+a+Se2OKaY3v3ayPpZQH7Vc7NNE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vCFBEKBZokqBZWc2qy9SuGdYmguanAesPLhN3TYagrv6o2/2/d0X09x7QkDZ266VR
	 gNaQl4FkTRxRBtZtHb4v3689zUkz7xezT5sHpf8+xFYlDKNHI/OuISkyObP5ZiTuRx
	 8BYNIi20Ny5NVaG5Z38uRIqlE/f8BwRrJWxphmAIRr6RfmntHNLfxrkbllbkWEThWy
	 3DVgealrQrteKP7OimO20rCBqPjKBxJw8ZQ8MercoEaX1+iK0GdkJfBbZg8+skHoXX
	 rSgH1bLzbu1kbj1e5hztqGP/zd7AIU1XKT6h2GuBY1wxb6eukdHhrjx2epE88bwsoY
	 m6YjzwGy1tYvA==
Date: Mon, 01 Jul 2024 17:52:42 -0700
Subject: [PATCHSET v13.7 13/16] xfsprogs: offline repair for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-pptrs
---
Commits in this patchset:
 * xfs_db: remove some boilerplate from xfs_attr_set
 * xfs_db: actually report errors from libxfs_attr_set
 * xfs_repair: junk parent pointer attributes when filesystem doesn't support them
 * xfs_repair: add parent pointers when messing with /lost+found
 * xfs_repair: junk duplicate hashtab entries when processing sf dirents
 * xfs_repair: build a parent pointer index
 * xfs_repair: move the global dirent name store to a separate object
 * xfs_repair: deduplicate strings stored in string blob
 * xfs_repair: check parent pointers
 * xfs_repair: dump garbage parent pointer attributes
 * xfs_repair: update ondisk parent pointer records
 * xfs_repair: wipe ondisk parent pointers when there are none
---
 db/attrset.c             |   36 +
 libxfs/libxfs_api_defs.h |    6 
 libxfs/xfblob.c          |    9 
 libxfs/xfblob.h          |    2 
 repair/Makefile          |    6 
 repair/attr_repair.c     |   30 +
 repair/listxattr.c       |  271 +++++++++
 repair/listxattr.h       |   15 +
 repair/phase6.c          |  121 ++++
 repair/pptr.c            | 1331 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h            |   17 +
 repair/strblobs.c        |  211 +++++++
 repair/strblobs.h        |   24 +
 13 files changed, 2069 insertions(+), 10 deletions(-)
 create mode 100644 repair/listxattr.c
 create mode 100644 repair/listxattr.h
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h

