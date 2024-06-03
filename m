Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100E9F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440567; cv=none; b=g686G5GE5rpFGoD7QOr2v8TQQ1FTbrAyGqtyBmmEqIEDd8bCi2NtPx2LG++8pgjvRbfxyeTo3fvSmiPzAAeMj6nIh2OwhQyE/veSN2RpzI3EDIW6EYv4BzdW4vslN9jJl1K+gl4tobKAU1I5S7JcN3PmYtmVhOrzPn/Qx7t64/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440567; c=relaxed/simple;
	bh=5i05vUsH4wf0NDMt5S93Yui3V/j9jSE9iJe7P1J8Y70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+jmBw6fjfjKFNhIyPuNSBMphWRlk2ppvgUM1TRa2rKK12kIzRNo4wzbBxtbz7nzXaChH2mtV0mSyhS2B6IajZQA5QsIt+EkYEIhB6P9wV5QBLlKpxCwGnIy7jtdlzlVx54oH79IWEEpHmW9JEvxogm+PCZxTzK+6mWk0++IOlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwpMVrXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwpMVrXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC667C2BD10;
	Mon,  3 Jun 2024 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440566;
	bh=5i05vUsH4wf0NDMt5S93Yui3V/j9jSE9iJe7P1J8Y70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VwpMVrXn0VHiPeU/KqZ/aemwxSxjsEaw0YYKEHY2E3+j7bqF+MSTUw+xnyvzqD/q6
	 9iH0rNoAaClFIjs0fI7GfNEqqOjEaniXXShqq95gpavJlBygwyD/PBrurdF0H/+v/s
	 zLK+rDdzxNRbkRZb8PLqgyZJ+0kHni8gdEVxNsAHRLvbmnjMgAXcKfSoTHQiLZJUOb
	 onaCIaeIp4tDELJiFpPKHwU529uSvF7DsZm42snjngS3W8JuJQDrTRjIRAS5YZudB/
	 g0I9KcQIIVHEhPjDWkK3/Z5CbU1ePzyPL0iIE3zqLb8/eCUcvaWWioLqoBWRYIti7s
	 cw5R9QBkSDQjA==
Date: Mon, 03 Jun 2024 11:49:26 -0700
Subject: [PATCHSET v30.5 03/10] xfsprogs: bmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744041355.1447589.2661742462217465267.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
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

