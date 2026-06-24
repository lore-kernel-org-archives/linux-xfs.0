Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B1A2745E;
	Wed, 24 Jun 2026 14:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309910; cv=none; b=JdFaPX3hymL5AxDPgGQsthlxYdHs6KQkhl/E5KqwYFXf2ZqExwJRwEiJUm77e9bwyJgQ/XXWJpryb7VIXwBrMzeP4uPTEGo4ZgWj9Jm+v2C+thRMCI7QU1MywWZgcAQDsRAPvDgWbHKfHVgkz7d56jy9Xh5AABYvssibclyYpxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309910; c=relaxed/simple;
	bh=7vc/EGqcQD3zdmSkUwy8GjD66tIqq3R3BfQ0AhSjUnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUWBVU96MTUpIQfqDmeVzqA1EX/iHNhOL3tJM6u3thH/en7L1pA/byF8tOcVvqI0cjxYcy0FMPSoVAQ33A5DwTmwFW3w/HBQrWSEhIDm5rrRcdKFw0RnUyblP6iyJe+LTh3IftgofYnQXB2WjJUlS/e20yhtgmIdS25YabxHGVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 786DA68B05; Wed, 24 Jun 2026 16:05:05 +0200 (CEST)
Date: Wed, 24 Jun 2026 16:05:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 01/18] xfs: fix the error unwind in
 xfs_open_devices()
Message-ID: <20260624140505.GA7692@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-1-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-1-7df6b864028e@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 16, 2026 at 04:08:17PM +0200, Christian Brauner wrote:
> Since the rt and log block devices are closed in xfs_free_buftarg() the
> buftarg owns the device file. The error unwind does not respect that:
> when the log buftarg allocation fails, out_free_rtdev_targ frees the rt
> buftarg - releasing rtdev_file - and then falls through to
> out_close_rtdev and releases it a second time.
> 
> The unwind also leaves mp->m_rtdev_targp and mp->m_ddev_targp pointing
> to the freed buftargs. The failed mount continues into
> deactivate_locked_super() -> xfs_kill_sb() -> xfs_mount_free(), which
> frees them again.
> 
> Clear the buftarg pointers once the unwind freed them and clear
> rtdev_file once the rt buftarg owns it, so nothing is released twice.
> 
> Reachable when a buftarg allocation fails after the data buftarg was
> set up: an I/O error in sync_blockdev() or an allocation failure in
> xfs_init_buftarg() while mounting with external rt and log devices.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I actually have a major rework of this area pending, but it probably
won't land for 7.2, so we might as well get this local fix in ASAP.

