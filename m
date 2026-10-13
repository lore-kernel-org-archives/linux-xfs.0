Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32F44B95C2;
	Tue, 13 Oct 2026 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893053; cv=none; b=sQ4ROap0Ttx+aU5yLPL7E6eR2dnG4osy3QLs6wQoKFi67JGhz49tVigSQejfNO2wk/axw0jTmpPUOQAVST9mOIhxFWVDDUnkuIMNJNbVm9TStAG+5Tw1NWiJr5z8pdYOZ2Py/ELwlh+tLTslxpcMKz2cjwFL0KtYsfNoCR6it7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893053; c=relaxed/simple;
	bh=cYNuoVj+0b74qYjMmfINj5qejPfZPrH8RThi6u5dHtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Io6WtneAciZv3hCicXi2kigZhUCgnMrNhhvg3clyKRsHqLEUfsQ9ep1//S9ZT+/erNCu3U2DL7C3B2u4pbvtwAvuCyxwqtQUhbDOqTw9oZSJ5cONGbAMYlBsvdCmSuwSvrZpYklebHaR6vPjYCKHrMVfDLZrnBa14xbRJA6yU4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5F892227A88; Tue, 13 Oct 2026 14:04:00 +0200 (CEST)
Date: Tue, 13 Oct 2026 14:04:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: refuse a pNFS LAYOUTCOMMIT of a range without
 blocks
Message-ID: <20261013120359.GB2944@lst.de>
References: <20261013-xfs-pnfs-commit-hole-v1-1-740912db9102@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-xfs-pnfs-commit-hole-v1-1-740912db9102@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 13, 2026 at 03:00:51PM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> xfs_fs_commit_blocks() passes every range that a pNFS client commits to
> xfs_iomap_write_unwritten(), whatever is mapped there, and the range can
> be a hole. nfsd does not check the extents of a block or SCSI layout
> LAYOUTCOMMIT against the layouts it handed out, and for a reclaim during
> the grace period it has no layouts to check against, so a client can
> commit a range that it never had a layout for. Blocks under a layout can
> also be freed: blockgc frees blocks past EOF that were already allocated
> when a write layout handed them out, and a check in nfsd would not
> notice that.

blockgc really should not free them due to the prealloc inode flag.
Do you still see that with your prefix flag setting fix?  If so we
have a deeper problem.


> With this, both LAYOUTCOMMITs get NFS4ERR_IO, XFS keeps running and no
> block is allocated. A LAYOUTCOMMIT of the laid-out range together with
> the 64 KiB hole also gets NFS4ERR_IO and converts nothing, so the
> laid-out range stays unwritten.

Yeah, I think even when blockgc should not happen a sanity check
for misbehaving clients is a good idea.

> it. XFS for-next also has commit e3c682dd1130 ("xfs: map pNFS layouts to
> the end of the extent again") in xfs_fs_map_blocks(), which nfsd-testing
> does not have. xfs_fs_commit_blocks() and xfs_iomap_write_unwritten()
> are the same in both trees. The pynfs tests for this are local; I can
> post them if they are wanted.

It would be great to get these included in pynfs.

Also a little doc on your setup to run pynfs in client mode against
nfsd with block/scsilayout would probably useful.

> +/*
> + * Ensure the committed range is backed by allocated blocks. A client may only
> + * write to blocks that a layout handed out, xfs_fs_map_blocks() allocates
> + * blocks for any hole in a write layout, and no layout hands out a delalloc
> + * extent. A hole or a delalloc extent in the range was either never laid out
> + * or lost its blocks after the layout was handed out, so nothing the client
> + * wrote can be committed there. Converting a hole would also allocate blocks
> + * that the transaction did not reserve.
> + */
> +static int
> +xfs_pnfs_validate_commit(
> +	struct xfs_inode	*ip,
> +	xfs_off_t		start,
> +	xfs_off_t		end)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, start);
> +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end);
> +	struct xfs_bmbt_irec	imap;
> +	uint			lock_flags;
> +	int			nimaps;
> +	int			error = 0;
> +
> +	lock_flags = xfs_ilock_data_map_shared(ip);
> +	while (offset_fsb < end_fsb) {
> +		nimaps = 1;
> +		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> +				&imap, &nimaps, 0);
> +		if (error)
> +			break;
> +		if (!nimaps || !xfs_bmap_is_real_extent(&imap)) {
> +			error = -EIO;
> +			break;
> +		}
> +		offset_fsb = imap.br_startoff + imap.br_blockcount;
> +	}
> +	xfs_iunlock(ip, lock_flags);
> +	return error;

As soon as we drop the lock, the result might be stale.  So I suspect
we want a CONVERT_ONLY flag to xfs_bmapi_write that makes it refuse
to allocate blocks instead in one atomic operation.

