Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70A03921D1;
	Wed, 23 Sep 2026 05:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143053; cv=none; b=oZ7oi5SEMydFcbbJcNPEGSw57uziHhf286WkPktPohFjZBgAJWie4vNtQGulb6st9LmUoo2PlAo2pTNo0+JiQ5/bxKk6rQcLPwtNfgmrI5YXZjXHDVVQFpfLXti8K576xlKyKTpZBwyW+cXB7Pc+xHfWDXTB9Ww2bZ7sDI+lZfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143053; c=relaxed/simple;
	bh=COE85NiwsLG7ehO4yYr7cyhKL8IVG+vXWDLRSclnToo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=nnhxwtOrihZ+5nf63mCjfCuePSgZ2boE650zB2Wq5hmXVuA5Qs+M5+IUoh/hxo/3VaWgsjzjsRrjB8exQE9lKWi90Zi7+LFDW4Gl7yI1JbaMUjHIxJswdF+WmzS0drVSkZDZScoxGaASJToHRRpI4OApiDOm3YHFIYNi29PJRaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIGBYl/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIGBYl/u"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4CE031F000FF;
	Wed, 23 Sep 2026 05:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143052;
	bh=K3thJ3HP5Ux4FZDtG3c0eMs+je9zxJZtVNSaXw4Eowk=;
	h=Date:Subject:From:To:Cc;
	b=CIGBYl/uns6TH+jT/Vf0umkkLXZWSksxU5Emstp3QLjdbJQgzGUohBSU6K5FcNGi/
	 Z8Dg28j0bMgUKO5Gb2/ctFAWrtUSONU6hKcF6Ii7bbg+erXUO5jbssRPoYV9x0RRAY
	 pdx/TWNfpLQSsLSOE5Y10FOj5NmEsQ87Ze3KBFk7p/JNbuOFvyR1L4Pa9Y4QfpYXHI
	 4M4AOpdPiQLloZT8RIfVEqpwqjRRr/WapfeAZztIzxMAH+Q4O5RTN0e9eD/XLIS0RT
	 QltR0jcWuvLMSiaICr3n0Ctg2G5OTeaR3SHFT0ImDVq6ldDxYUZIelitgioMTYL2W5
	 rkkwvkS55w6tA==
Date: Tue, 22 Sep 2026 22:57:31 -0700
Subject: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 17
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a seventeenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-17
---
Commits in this patchset:
 * xfs: compute the correct fdblocks/frextents for repair when they're negative
 * xfs: mark cow extents bad if there's no rmap mapping for them
 * xfs: clear the symlink zapped flag if inline symlink is ok
 * xfs: reinitialize dquot block if non-first dquot can't load
 * xfs: fix inode btree repair when a cluster is larger than a chunk
 * xfs: fix integer overflow problem when setting large free areas
 * xfs: fix buffer overflow in corrupt inline attr structure
 * xfs: actually report corrupt xattrs as XFAIL during cross-referencing
 * xfs: improve dir block reporting when cross-referencing dirents to pptrs
 * xfs: fix unnecessary dapos truncation in xchk_dir_walk
 * xfs: actually lock the metafile reservation when adjusting after repair
 * xfs: avoid cross-rtgroup reaping after a repair
---
 fs/xfs/scrub/attr.c            |   11 ++++-
 fs/xfs/scrub/attr_repair.c     |    3 +
 fs/xfs/scrub/cow_repair.c      |   84 ++++++++++++++++++++++++++--------------
 fs/xfs/scrub/dir.c             |   20 ++++++----
 fs/xfs/scrub/fscounters.c      |    5 ++
 fs/xfs/scrub/ialloc_repair.c   |    8 ++--
 fs/xfs/scrub/quota_repair.c    |   16 +++++---
 fs/xfs/scrub/readdir.c         |    2 -
 fs/xfs/scrub/reap.c            |   59 +++++++++++++++++++++++-----
 fs/xfs/scrub/repair.c          |   18 ++++++---
 fs/xfs/scrub/rtbitmap_repair.c |    2 -
 fs/xfs/scrub/symlink.c         |   17 ++++----
 12 files changed, 168 insertions(+), 77 deletions(-)

