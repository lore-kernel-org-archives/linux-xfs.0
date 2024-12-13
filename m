Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB89175AB
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 00:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051479; cv=none; b=P+MqEaXmW3uQzEypNRqrtIT9w1+AayMlxCWoykPCuQ0nI9hUpsYpbrWP8s9+kNGb4aZw8WnRMHw4Z39y6brxGsSISdJ8aP4GK5ktVm7I4qWGAqqXDihZYZmH7TvvvEwpEZH4az8hiY7RZvFw0JM7gchispKYpCvwqqdWllES0LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051479; c=relaxed/simple;
	bh=oiyVnSZXwE8xprcMCfNIonKk6ALl+XFn9/yntbHvQdw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NA3gP8EmOKEI+qfjt4YLYZJ0XLRAKd2amo5OEmRkZGKhPlKdiKEhRh9kLng12XoRFY0JXtRqWPrKpesK5o8HbgfUItd+VWo4fe0ILODsshIH2GoyFN54aUWVv6gy+xhPnNT8yKD15BurNqYJKm7aPtVOhzwF8AnfC7lfxnFNp9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTkuI4fJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTkuI4fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30124C4CED3;
	Fri, 13 Dec 2024 00:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051479;
	bh=oiyVnSZXwE8xprcMCfNIonKk6ALl+XFn9/yntbHvQdw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aTkuI4fJAoUo9hsIRHXgkJnuvz452T6am6LAfFQMXoLv6GU4C4j3WMSbwJSi4lb1O
	 wTAg43CuawpFBfiWaUU3E8BEzynICizYiGTin3NsqFRq9r4GMly4HYjrX6VLe9WP/b
	 EFX+AesfDSSYCfOfCncxjjYjPUbMOY07UIcRyxjRR+2vPn6QkwlHIdFpURkBGjW64h
	 b2ZhTz0AvKxueZ7pQzHYQ4CshakWyk39x6b4fhxsaHBODKKQdHTi7s1RQHWIINbWfN
	 JrE0vBTpLza8zacRboDiB03NaBYXcu8TY3+bb4Wob+XvsvXxRrM5mB6m93SuRQG884
	 m5FGO02mxYHoQ==
Date: Thu, 12 Dec 2024 16:57:58 -0800
Subject: [PATCHSET v6.0 5/5] xfs: reflink with large realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
In-Reply-To: <20241213005314.GJ6678@frogsfrogsfrogs>
References: <20241213005314.GJ6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Now that we've landed support for reflink on the realtime device for
cases where the rt extent size is the same as the fs block size, enhance
the reflink code further to support cases where the rt extent size is a
power-of-two multiple of the fs block size.  This enables us to do data
block sharing (for example) for much larger allocation units by dirtying
pagecache around shared extents and expanding writeback to write back
shared extents fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink-extsize

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-extsize
---
Commits in this patchset:
 * vfs: explicitly pass the block size to the remap prep function
 * iomap: allow zeroing of written extents beyond EOF
 * xfs: convert partially written rt file extents to completely written
 * xfs: enable CoW when rt extent size is larger than 1 block
 * xfs: forcibly convert unwritten blocks within an rt extent before sharing
 * xfs: add some tracepoints for writeback
 * xfs: extend writeback requests to handle rt cow correctly
 * xfs: enable extent size hints for CoW when rtextsize > 1
 * xfs: allow reflink on the rt volume when extent size is larger than 1 rt block
 * xfs: fix integer overflow when validating extent size hints
 * xfs: support realtime reflink with an extent size that isn't a power of 2
---
 fs/dax.c                      |    5 +
 fs/gfs2/bmap.c                |    2 
 fs/iomap/buffered-io.c        |   25 +++-
 fs/remap_range.c              |   30 +++--
 fs/xfs/libxfs/xfs_bmap.c      |   22 +++
 fs/xfs/libxfs/xfs_inode_buf.c |   20 +--
 fs/xfs/libxfs/xfs_rtbitmap.h  |   12 ++
 fs/xfs/xfs_aops.c             |   57 ++++++++-
 fs/xfs/xfs_bmap_util.c        |  182 ++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h        |    7 +
 fs/xfs/xfs_file.c             |  270 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.h             |    3 
 fs/xfs/xfs_inode.h            |    6 +
 fs/xfs/xfs_iomap.c            |   27 ++++
 fs/xfs/xfs_iops.c             |   29 ++++
 fs/xfs/xfs_reflink.c          |  248 +++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_reflink.h          |    2 
 fs/xfs/xfs_rtalloc.c          |    4 -
 fs/xfs/xfs_super.c            |    9 -
 fs/xfs/xfs_trace.h            |   50 +++++++-
 include/linux/fs.h            |    3 
 include/linux/iomap.h         |    6 +
 22 files changed, 925 insertions(+), 94 deletions(-)

