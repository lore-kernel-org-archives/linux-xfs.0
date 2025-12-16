Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC7B3128A2;
	Tue, 16 Dec 2025 05:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765861947; cv=none; b=D9waCqimihzzkuiiwwjVRGm8HqMIoZyjMMNJzz0amhWalSX6SABlKFvUThhN0xBeDdKm83JM+7FtieeMDR29h9Crb820Ln0lUduXMJZcPk1ZpDzpZpiWi2zUE1pJciievp4INf1QBqeoNR6IgdF4qeUTqYo15Ngasx0Ruzb3Vqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765861947; c=relaxed/simple;
	bh=qlLIIoRRYelN+cpqRF/1aWnIKwXKBokTNfxN3ltG3p8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2K6H4E3GU1nRjCgFjDabMzDYBKDencduWusqjHHX3TW/zruKdTdVHMm/XZ4mNwrlcnHMUy9zRmRSsEcq+qj5jWNSy7DFR33AOd92cTErUytBlXLb6MF1aLNPnfZyLcWkvlFmEZM+52jTC9q1xJ+RVcxuFMk7QfWuwuHKX3cp6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2B9E227A87; Tue, 16 Dec 2025 06:12:06 +0100 (CET)
Date: Tue, 16 Dec 2025 06:12:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a test that zoned file systems with rump
 RTG can't be mounted
Message-ID: <20251216051205.GB26237@lst.de>
References: <20251215095036.537938-1-hch@lst.de> <20251215095036.537938-2-hch@lst.de> <20251215193345.GM7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215193345.GM7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 15, 2025 at 11:33:45AM -0800, Darrick J. Wong wrote:
> > +_scratch_mkfs > /dev/null 2>&1
> > +blocks=$(_scratch_xfs_db -c 'sb 0' -c 'print rblocks' | awk '{print $3}')
> > +blocks=$((blocks - 4096))
> > +_scratch_xfs_db -x -c 'sb 0' -c "write -d rblocks $blocks" > /dev/null 2>&1
> > +_scratch_xfs_db -x -c 'sb 0' -c "write -d rextents $blocks" > /dev/null 2>&1
> 
> You could put both of the write commands in the same invocation, e.g.
> 
> _scratch_xfs_db -x \
> 	-c 'sb 0' \
> 	-c "write -d rblocks $blocks" \
> 	-c "write -d rextents $blocks" > /dev/null 2>&1
> 
> For a little bit lower runtime.

I can do that, but I doubt it really matters..

> > +if _try_scratch_mount >/dev/null 2>&1; then
> > +	# for non-zoned file systems this can succeed just fine
> > +	_require_xfs_scratch_non_zoned
> 
> The logic in this test looks fine to me, but I wonder: have you (or
> anyone else) gone to Debian 13 and noticed this:
> 
> # mount /dev/sda /mnt
> # mount /dev/sda /mnt
> # grep /mnt /proc/mounts
> /dev/sda /mnt xfs rw,relatime,inode64,logbufs=8,logbsize=32k,noquota 0 0
> /dev/sda /mnt xfs rw,relatime,inode64,logbufs=8,logbsize=32k,noquota 0 0
> 
> It looks like util-linux switched to the new fsopen mount API between
> Debian 12 and 13, and whereas the old mount(8) would fail if the fs was
> already mounted, the new one just creates two mounts, which both then
> must be unmounted.  So now I'm hunting around for unbalanced
> mount/unmount pairs in fstests. :(

The old mount API also supported that at the syscall level, but it got
disable in mount(8), so if mount now does this and previously didn't it
seems like an unintended change.

