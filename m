Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632843EA76
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716345970; cv=none; b=f58usvFRF2MQ8DENaDNym0v5v0seGSyGu0SdRkvGUYWOKIzIbxrkT/S5MjuM6BkVw5kEOIg/hmhoh+/ZO4mZ8w5/jvXNRHJEWbCWbDfd+vF8IyxifKUxt9X/vSPrukoT0z7TPDsfRLqxWhFvcJr1hgkrhLUxzDrWvo8yjBwZopg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716345970; c=relaxed/simple;
	bh=5i05vUsH4wf0NDMt5S93Yui3V/j9jSE9iJe7P1J8Y70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DdvOuv7Q9YYz47U2sRuUJkM6z3xTwW5uxCsgA661tuTM9BjgPG96KicNQyeYtaJwhSUTNrpWfrEnQkQHcnY+SiLIK/mGoPp1QoPEE800VFchVB7/VLXpKPJIJFQUiehTNSAcIkOA2ToAuaP+RVhl4b3cH3UNsI20XscCGOH/TDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q37Xu18/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q37Xu18/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1821C2BD11;
	Wed, 22 May 2024 02:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716345969;
	bh=5i05vUsH4wf0NDMt5S93Yui3V/j9jSE9iJe7P1J8Y70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q37Xu18/BBnB50EwsDa8c2dTW6K3z3+E6cV4tFDHQv4bVcnqGyJZWuLry9UF486Al
	 CDRtU1FKifpMxjakweiG9wB9v7o+FcA2m6DOtrm0YaAClmiMqipiT+36LcMeK03itH
	 9BNnJxnNRfRPj1r+FlQYFFJYht2564Z7nUCgsaEBSqqv5tOk+WAcIqcPNfTdqkSDvb
	 cU1N8KTr2z7B7WHx9CeOqUI1i3hDdRbohi/b16JGa04HiZsQeo4zyeuwZN5Y+eVJ2c
	 sHoS5r2x3WV1QTO0JbDVvwibu4cxdoo+kP0JUHrK12R6FX+QtEVf0nKeuA7Xz+9yRH
	 8IEEmBM6/oWlg==
Date: Tue, 21 May 2024 19:46:09 -0700
Subject: [PATCHSET v30.4 03/10] xfsprogs: bmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533692.2482547.7100831050962784521.stgit@frogsfrogsfrogs>
In-Reply-To: <20240522023341.GB25546@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
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

The next major target of online repair are metadata that are persisted
in blocks mapped by a file fork.  In other words, we want to repair
directories, extended attributes, symbolic links, and the realtime free
space information.  For file-based metadata, we assume that the space
metadata is correct, which enables repair to construct new versions of
the metadata in a temporary file.  We then need to swap the file fork
mappings of the two files atomically.  With this patchset, we begin
constructing such a facility based on the existing bmap log items and a
new extent swap log item.

This series cleans up a few parts of the file block mapping log intent
code before we start adding support for realtime bmap intents.  Most of
it involves cleaning up tracepoints so that more of the data extraction
logic ends up in the tracepoint code and not the tracepoint call site,
which should reduce overhead further when tracepoints are disabled.
There is also a change to pass bmap intents all the way back to the bmap
code instead of unboxing the intent values and re-boxing them after the
_finish_one function completes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bmap-intent-cleanups-6.9

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bmap-intent-cleanups-6.9
---
Commits in this patchset:
 * libxfs: remove kmem_alloc, kmem_zalloc, and kmem_free
 * libxfs: add a bi_entry helper
 * libxfs: reuse xfs_bmap_update_cancel_item
 * libxfs: add a xattr_entry helper
---
 db/bmap_inflate.c         |    2 +-
 include/kmem.h            |   10 +-------
 libxfs/defer_item.c       |   58 ++++++++++++++++++++++++---------------------
 libxfs/init.c             |    2 +-
 libxfs/kmem.c             |   32 ++++++++-----------------
 libxlog/xfs_log_recover.c |   19 +++++++--------
 repair/bmap_repair.c      |    4 ++-
 7 files changed, 55 insertions(+), 72 deletions(-)

