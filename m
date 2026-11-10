Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794303935;
	b=q3LgCVx1fBvKqY282fMQ2BvDhN9BUmCy9Si95gzqAj+pTvksZFhkJcLuraqBfbvidx2S
	 lmwWhPaZFwloMBwvSlyt0zGYGQ1M/YdaAZs4VQhUS9okukl4BZpNkNsJifxj8By6jv+25
	 ScsBUXw7bZ+64yTS30UneTWeI4Q1kz2AGp2PzztcSaCBQzhOuQ0bCKc1MgWW3Ib0HA/iN
	 A986shwcvWshuiTMv9GZNkdxdUtafZtsDRr8qJzU9puNYuVx4Z1IOYvzRL4E9+tBUhP8C
	 8sHb4fVJi2p8ZHJaapxh98YLpr73l/0Mv8WVtecLp0gbl1L6TJtzPQMrZ1hSAXLODUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794303935;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=emaQ4h6i8bdfXPn+Ux2yP+G7QUxdsitO9sarli3rvjA=;
	b=HGr8ghZ/z5Sw+QtGco2ZINo4Af3NwuKT++G8UQ55BBMSqUvZKqxn9xmqOk1AXNb5W/qH
	 3fPhXl4dCj6FE6h4Wh3gWz7Mtu421z4471oaERGlNh2FSD6kzwQg9RqO5m6VSQ/E8Vbl/
	 EWbYSA+ovAh/vbJay4k8IHJ4Iox9pEbwNUqACyuqlWnJJPkBTeKgBs6SCPXUhki/7gYPt
	 5qY/GbJW9p0Ah4uIwoOemg0khiPYolMXjkWGSoL7sYGq5ZXNHVzmcgZx+SiKaxLPTHIDa
	 c8MRw09Bv3o3U1lTdPgGS/1ZJhG7B7jE4KauWUTwFYi78WigD0qU2Y0NH9mF/CLjOuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="R/gzEaUX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF46A606C645;
	Tue, 10 Nov 2026 09:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R/gzEaUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0821F0089F;
	Tue, 10 Nov 2026 09:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794303934;
	bh=emaQ4h6i8bdfXPn+Ux2yP+G7QUxdsitO9sarli3rvjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R/gzEaUXCMpLNnQZ6Sthm8OqHcosXH2iZ1aA+05Yi/lG9FuRjvjn4IYL/BYtNqz5t
	 M6qHat5CV51T5MWDvi0EjahzNi+ACZDR24QEgn7m2qlwT1rkdXZ+BSiIhSJCUs4rgf
	 XCMTZYFOVJ2e7DSObpdVk+Mv8/mBQVBZb8i3eZq5y0WzUgM7mDuXOxOVmvEYbYeshf
	 QeLAwRu/iZp6s8uSWpziQ9hLGsvJTVk5oEJd4Jf8OqcUyxP0/oCR42A5XNLX1oMXxt
	 wSojJEidI8NsmLbnUVy1zjDmrX1mwux+rc0ej3nRKwrMQ2jKrD8iJkewJsNMEdCdr0
	 0oS0a1pbHh/dA==
Date: Tue, 10 Nov 2026 10:45:29 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
	josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 00/10] reflink and atomic write bugs
Message-ID: <avLnU46F6YZckcbo@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109235111.14129-1-mason@kernel.org>

On Mon, Nov 09, 2026 at 06:51:11PM -0500, Chris Mason wrote:
> Hi everyone,
> 
> This series did a few rounds privately, but looks ready for the list
> now.  Except for Christoph's patch, these were all found and fixed
> by an LLM.
> 
> The meat of the series is fixing reflink corner cases that incorrectly
> let you write into the source of a reflink.  LLMs also tripped over a
> few ways to use atomic writes to expose stale blocks on the drive, and a
> few races with realtime flag manipulations.
> 
> Carlos and Christoph ran these through fstests (thanks guys).
> 
> Chris Mason (9):
>   xfs: don't skip the flush before shifting extents
>   xfs: flush the shifted range before changing the file
>   xfs: don't change the block map under a dirty folio
>   iomap: don't punch delalloc under a dirty EOF block
>   fs: validate atomic writes after O_APPEND and limits
>   xfs: recheck direct write alignment after write checks
>   xfs: test for reflink after the dio write checks
>   xfs: refuse fallocate racing with realtime flag changes
>   xfs: restart faults racing with realtime flag changes
> 
> Christoph Hellwig (1):
>   xfs: refuse writes to files racing with realtime inode flag changes

Sashiko found a few issues that I believe are worth looking at. If there
are no objections though, I'll pull in the first 4 patches which are the
most critical ones so far until we figure out the other ones. If there
are objections please let me know and I'll revert them back.


> 
>  fs/ext4/file.c         |   4 --
>  fs/iomap/buffered-io.c |  34 ++++++++--
>  fs/read_write.c        |  13 ++++
>  fs/xfs/xfs_bmap_util.c |  19 +++++-
>  fs/xfs/xfs_file.c      | 150 +++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_iomap.c     |  33 ++++++++-
>  fs/xfs/xfs_reflink.c   |   2 +-
>  7 files changed, 215 insertions(+), 40 deletions(-)
> 
> 
> base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
> --
> 2.55.0
> 
> 
