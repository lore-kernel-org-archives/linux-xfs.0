Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2993D0C07;
	Wed, 19 Aug 2026 07:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123921; cv=none; b=XEBYjfIfcQgFuwsMcEXFEerz87EkKxtAXk89DBL5tXUAyML1AvX1jA97n4fdMX1qiOQBGydmmfYsOWoSbK6t2AW2NaxcUGwdp81nsRG34F/CSPtpvI/A7O10N9qPL0D6R3HYoqgxHt5t3QMYhupgeQ/BCEXF0Jeeuz9G07U/wZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123921; c=relaxed/simple;
	bh=/zOrhupMYLqPvuTP70Aq+7nb9Ccjgu6peXt6CRwSEpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJ5FWxuAEil+j8ENOt7ClsDvRrLWG+LDNPKGyz/6TIWU77vLjkv+kQaYiyEjU1bDtBxXaYIJroi4y1EQ/L6tiRCixdcQGeGt5Gjl9R3tHwFjksGKw/lsCWfNGhhAY8B8N3JA/FvaCXXCij00Or+G8bVf+vV6em2YK15QjkdqnTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2C3468C7B; Wed, 19 Aug 2026 09:18:35 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:18:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj1072538@gmail.com>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 3/6] xfs: implement write-stream management support
Message-ID: <20260819071835.GF1541@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c@epcas5p3.samsung.com> <20260717125538.508925-4-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +int
> +xfs_inode_max_write_streams(
> +	struct xfs_inode	*ip)
> +{
> +	struct block_device	*bdev;
> +	bool			is_filestream, is_realtime;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	is_filestream = xfs_inode_is_filestream(ip);
> +	is_realtime = XFS_IS_REALTIME_INODE(ip);
> +	bdev = xfs_inode_buftarg(ip)->bt_bdev;
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	if (!bdev || is_filestream || is_realtime)
> +		return 0;

All this information is stale as soon as soon as the lock is
dropped.  Also a NULL bdev can only happen for the in-memory
buftarg used by repair, so no need to check this.

> +uint16_t
> +xfs_inode_get_write_stream(
> +	struct xfs_inode	*ip)
> +{
> +	uint16_t	stream_id;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	stream_id = ip->i_write_stream;
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);

Same here.  READ_ONCE/WRITE_ONCE might be a better idea to simply
avoid the lock at read time.

> +{
> +	struct xfs_write_stream	*ws = file->private_data;
> +	struct xfs_mount	*mp = ws->mp;
> +
> +	spin_lock(&mp->m_streams_lock);
> +	clear_bit(ws->stream_id - 1, mp->m_streams_in_use);

Given that all accesses to the m_streams_in_use bitmap use a lock,
there is no need for the atomic bitops.  We could use the __-versions
or just code the logic.  Or not bother because none of this is
performance critical :)

> +	ws = fd_file(f)->private_data;
> +	if (ws->mp != ip->i_mount)
> +		return -EINVAL;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	if (XFS_IS_REALTIME_INODE(ip) || xfs_inode_is_filestream(ip) ||
> +	    VFS_I(ip)->i_write_hint != WRITE_LIFE_NOT_SET) {

If we want to enforce a hint vs stream exlusion we'd also need to
do this when setting the hints.  Another approach might be to allow
them to coexist, and set a lifetime hint on each stream, which the
inode must match.  Although I'm not sure this would be all that
useful.

