Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32EE25760
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739943333; cv=none; b=tH/0Xs4Z11xdUQJTRI0/f2tmiZNIrRsWO3Ycb/7oYwpbpitdBEzLioLug3ahQFbL0YiYrNKY8EI22kLda4QXEMqp4nk3BpzJUNhWuRDWe6KCQDfEUe9sRK7UKMQAt+KMkg11cb80zD5ycWMGquLvJIu27KHSfGfwravaqGRCnDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739943333; c=relaxed/simple;
	bh=dsc6vdrB8//h88wR59lmS9U9/f2wdOcEmqjf+F6jngM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJWlyrdRYQqtp8gUHueF+WNCyEQobraea6rbwjLuo876ymmCZoy8BTWsYQTsMRbJJoyxfCORAUpY0FGszOiG0jdVn9KLdFa0erBHSFOV9OReti8S7SbnbgD6o5/oyysYImGbC66TSgr0fW77UHIfurVy/q98FvU5H6/znQz59Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 756D767373; Wed, 19 Feb 2025 06:35:27 +0100 (CET)
Date: Wed, 19 Feb 2025 06:35:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove most in-flight buffer accounting
Message-ID: <20250219053527.GC10173@lst.de>
References: <20250217093207.3769550-1-hch@lst.de> <20250217093207.3769550-4-hch@lst.de> <20250218202327.GI21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218202327.GI21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 18, 2025 at 12:23:27PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 17, 2025 at 10:31:28AM +0100, Christoph Hellwig wrote:
> > The buffer cache keeps a bt_io_count per-CPU counter to track all
> > in-flight I/O, which is used to ensure no I/O is in flight when
> > unmounting the file system.
> > 
> > For most I/O we already keep track of inflight I/O at higher levels:
> > 
> >  - for synchronous I/O (xfs_buf_read/xfs_bwrite/xfs_buf_delwri_submit),
> >    the caller has a reference and waits for I/O completions using
> >    xfs_buf_iowait
> >  - for xfs_buf_delwri_submit the only caller (AIL writeback) tracks the
> 
> Do you mean xfs_buf_delwri_submit_nowait here?

Yes.

> IOWs, only asynchronous readahead needs an explicit counter in the
> xfs_buf to prevent unmount because:
> 
> 0. Anything done in mount/unmount/freeze holds s_umount
> 1. Buffer reads done on behalf of a file hold the file open and pin the
>    mount
> 2. Dirty buffers have log items, and we can't unmount until those are
>    dealt with
> 3. Fsck holds an open fd and hence pins the mount
> 4. Unmount blocks until background gc finishes
> 
> Right?

Yes.

> I almost wonder if you could just have a percpu counter in the
> xfs_mount but that sounds pretty hot.

Well, that would remove the nice xfs_buftarg_wait() abstraction.
Givne that we don't even allocate an extra buftrag unless we use
it that doesn't seem very useful.

> > +	/* there are currently no valid flags for xfs_buf_get_uncached */
> > +	ASSERT(flags == 0);
> 
> Can we just get rid of flags then?  AFAICT nobody uses it either here or
> in xfsprogs, and in fact I think there's a nasty bug in the userspace
> rtsb code:

See my reply to the last patch: I actually have a patch to remove it,
but it conflicts with the zoned series.  So for now I'll defer it until
that is merged.

