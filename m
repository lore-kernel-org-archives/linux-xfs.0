Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7954A12838B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421872; cv=none; b=JmIdBrWrdXhUXgObKYclkJAMPCY4VoB9Gv0xmDoPD2cMoJUUf+7ILGV4vaVq2q55bjnXgU2U3DqRqdoki41a3KHLqhyVdUM1LTgCa0JzTi9uGydz6TXIjF6shmog6EnvB0/7S63gXIZcT8LQYCXTWsY8KNZJsr1v/AdaqWV90PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421872; c=relaxed/simple;
	bh=BkvfuaITlL1fAEgLqQxAQ4A3pbrY/emeUoJMcsHAgfM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ScPMVpIGHcL+erKqegCDWTTjnv0S8Ca+YkzSr3TsISIgnDrNeF1xTS8orOSqFwRTN2aauVt7aD4UWCL2Z1ywqQX9mwf9/ZpNTZ/9fuFwh8zNrXSrcTcPbpIAd0GTrL6hJdvQIVY7U4Q2E2cJrXhzanLQcj72MR2JZ+uAQv5uadc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+EfRKXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+EfRKXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443EFC43394;
	Tue, 26 Mar 2024 02:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421872;
	bh=BkvfuaITlL1fAEgLqQxAQ4A3pbrY/emeUoJMcsHAgfM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q+EfRKXYUEaF6vZcjYJn0tBwSzrKnfgXQzIYA6Vmbsd2W4RnoWVWCm/lmdx+VEaXL
	 zDdQPQR0mkqJI2B2yLjuFGIxdRQsOGiHRD9cXFQb1VC4bguci7RDcrDRCqsljCwzBO
	 +dGLEEigcHF9TQv4yggz4FujCcPrmNQAnrdyRhO7z/WU9g7e47pVIJIP7+8UPrTwTd
	 tcAl3WqambSpwGle4yMQ+z/SVSqvM5aAu8136UbCELXl9RXeaO6XQhpHyNmZI24p9+
	 YbIv0ANqvqVNblmQMgdaPzz/VwxbGkfYL7td8h9hcjCcy1ZxlQsZpKAMLhRvjdaczf
	 gUWt7dB37WHlw==
Date: Mon, 25 Mar 2024 19:57:51 -0700
Subject: [PATCHSET v29.4 12/18] xfsprogs: bmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142133286.2217863.14915428649465069188.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bmap-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bmap-intent-cleanups
---
Commits in this patchset:
 * libxfs: remove kmem_alloc, kmem_zalloc, and kmem_free
 * libxfs: add a bi_entry helper
 * xfs: reuse xfs_bmap_update_cancel_item
 * xfs: add a xattr_entry helper
---
 db/bmap_inflate.c         |    2 +-
 include/kmem.h            |   10 +-------
 libxfs/defer_item.c       |   58 ++++++++++++++++++++++++---------------------
 libxfs/init.c             |    2 +-
 libxfs/kmem.c             |   32 ++++++++-----------------
 libxlog/xfs_log_recover.c |   19 +++++++--------
 repair/bmap_repair.c      |    4 ++-
 7 files changed, 55 insertions(+), 72 deletions(-)

