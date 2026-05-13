Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0743F4108
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 13:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778679841; cv=none; b=SkWqqhvkEYH950/+xZxiMkCwySUggFn+Jq7Q2mo74SXD/NLeUbCpnrRhkyDsmQBw9aG1QAGo44uVTfvRnCQ9/4uM29/upGlhE8lVUAxpO6KAi0iQ24W+dWQ+QOM99d6Oozh+R8uUOmX1dW/geVDb4xw/eRPJ8cfPO1wmff+Mxok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778679841; c=relaxed/simple;
	bh=Bb/oSp9jSi7F39De4S+SEYqjWHyFeI1172DsRA84Q68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/Xr0sABVZvVtjfkiAq4hCgt6GyTdZFsqDTOKoYb6tRh/OULXpmcdEL3gdUMt90htBC1/ajofBzoX4uEC5zEs1L1ZAaxJQUdJucLPnyBpDyVeRPvzb43+TqQBetC7F2aCNUnlQHtHWR9GVXk1vGviJEUPYj/3jomzC3eZnfSRoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TseXaPDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TseXaPDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0CEC2BCB7;
	Wed, 13 May 2026 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778679840;
	bh=Bb/oSp9jSi7F39De4S+SEYqjWHyFeI1172DsRA84Q68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TseXaPDHRg8Wu5tp0Jj8Tg6Q+33AphooNFa1JqdmxRn1jyn55SjfwB4OK1lBjDq9K
	 cUeQ898Av9tJ1r24SvphTHjX16dJzPEvU2L6q9ksU+RNCNzfuyCgupZVPOFEpNEeUL
	 x12otOwdVXGEBeArYwTkjykobuYojvWBZRre5yyuMLH02UHbhAC6+E4iWPonnLe9ZD
	 9ldAyNWY4Z0BMNcPiKzyHgqqevYYCYmc2regUMSfspXV7tBAVKbD39VbVkSjmzXBee
	 inolYf4yV5BNJPZCisp9WjgRwktLk5Bh+DrTShy/9wcQRzNykkk3LEYXQAWiw2qkGM
	 OgbdjfXcycBnA==
Date: Wed, 13 May 2026 23:43:51 +1000
From: Dave Chinner <dgc@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: return -ENOENT for unallocated inodes in
 xfs_imap_lookup
Message-ID: <agSAF-9YFa1ODMIG@dread>
References: <20260513063745.8067-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513063745.8067-1-hans.holmberg@wdc.com>

On Wed, May 13, 2026 at 08:37:45AM +0200, Hans Holmberg wrote:
> Under heavy garbage collection pressure from RocksDB workloads,
> filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
> xfs_iget() returns -EINVAL.
> 
> xfs_zone_gc_iter_irec expects -ENOENT when garbage collection races
> with file deletion,

xfs_iget() returns -ENOENT when a lookup races with an unlink on the
cache hot side. When the inode is not in cache, it cannot race with
file deletion.

If we miss the cache, it will go read the inode from disk and then
check the state of it before inserting it into the cache. If the
inode mode is zero on disk, then we raced with unlink and -ENOENT
will be returned.

IOWs, a plain xfs_iget() call will handle races with unlink...

> so that blocks belonging to deleted files can be
> skipped gracefully. Returning -EINVAL instead causes the GC code to
> treat this as a fatal error and forces a shutdown.

If it passes in XFS_IGET_UNTRUSTED to xfs_iget(), then it is saying
the inode number comes from an unknown source and that may be invalid.
Hence we do more rigorous and costly checks on the inode number
(like force a btree lookup) if it is not already validated and in
cache. If any of these validation checks fail we return EINVAL to
indicate it was an invalid inode number.

IOWs, xfs_iget(XFS_IGET_UNTRUSTED) callers need to handle -EINVAL,
because validity checking the inode number is what the caller -asked
it to do-.

If you are using inode number from a trusted source (i.e. internal
filesystem metadata like a directory data block or rmapbt) then you
don't need XFS_IGET_UNTRUSTED. The inode number is known to be good,
modulo races with unlink which xfs_iget() handles anyway...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
