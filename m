Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DBF4688
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738372; cv=none; b=PRlnQAMwuAOoL5Yxypo2KNnXqx+5HyAsZ8cruGWTWUJHeJXGpxbsNy7nlXPq4PkG2abbCiI3sMX2B6WBpKGTkvSXzPeejwhaC8OPUD8Q6c9vKKEovNwMGC/YHe0tbd/g6ptmjRmN4K2yuk1FCdqLi3sQsFII7+kD0wyaaRpPI6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738372; c=relaxed/simple;
	bh=1PpPRfSyxqrcQQstLqdVE4i0UxOB93MuhJQH82WEJeo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=R0O9uE7JqAdSrq/ZiqrGZwQUD7GfMEKIEKMhI/FCAGmFj24ufCs078utAqvTKJXscrym3PNrMUHfKY4DO0tHArbHVWEQcVbKK83YlrbyeEnGsPTJ2X1fxL0ki9SJ7uPnpBIU91VCcGksaHlPbTcXsgBTEM2QUdUXGTPUe16C3kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHfVR4Ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHfVR4Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E002C433F1;
	Sat, 24 Feb 2024 01:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738372;
	bh=1PpPRfSyxqrcQQstLqdVE4i0UxOB93MuhJQH82WEJeo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GHfVR4Apbwyi/MkPl/xYKOUgb12a7as2E72rh90y82ifKSefny2+UJm/54RZTJYkE
	 EN1fkQd4we7xYkNOWeSiDOs5qv6u/k1/MU8FXrqjqwINYUaAcSAAtuJvPvK5EFeGTB
	 tG0tuwMrVmbDe2pjF/fvqsHzH+gdMLkTELJBvQXg93WtCLF2VjbVSR02v4CqVuiLs/
	 hcvKo2dbAKlImRkZGJrg3ilyQ+LvLGr9zcoemh3rdPoK2VhrEH8A6V1gXpG1K5B3Bp
	 9uamxNUBLML6PXvEVdZneVu9yQyyz4DNkInnvXqs6ph6WpYimUcAGN3uu8HKiyET8E
	 dZDrMAsFDzkKw==
Date: Fri, 23 Feb 2024 17:32:52 -0800
Subject: [GIT PULL 15/18] xfs: bmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873806470.1891722.15784103742656368395.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 7fbaab57a80f1639add1c7d02adeb9d17bd50206:

xfs: port refcount repair to the new refcount bag structure (2024-02-22 12:43:42 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/bmap-intent-cleanups-6.9_2024-02-23

for you to fetch changes up to c75f1a2c154979287ee12c336e2b8c3122832bf7:

xfs: add a xattr_entry helper (2024-02-22 12:44:22 -0800)

----------------------------------------------------------------
xfs: bmap log intent cleanups [v29.3 15/18]

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
xfs: split tracepoint classes for deferred items
xfs: clean up bmap log intent item tracepoint callsites
xfs: remove xfs_trans_set_bmap_flags
xfs: add a bi_entry helper
xfs: reuse xfs_bmap_update_cancel_item
xfs: move xfs_bmap_defer_add to xfs_bmap_item.c
xfs: add a xattr_entry helper

fs/xfs/libxfs/xfs_bmap.c |  21 +---
fs/xfs/libxfs/xfs_bmap.h |   7 +-
fs/xfs/xfs_attr_item.c   |  11 +-
fs/xfs/xfs_bmap_item.c   |  95 +++++++++--------
fs/xfs/xfs_bmap_item.h   |   4 +
fs/xfs/xfs_trace.c       |   1 +
fs/xfs/xfs_trace.h       | 267 ++++++++++++++++++++++++++++++-----------------
7 files changed, 237 insertions(+), 169 deletions(-)

