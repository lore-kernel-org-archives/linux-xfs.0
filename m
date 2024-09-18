Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EDD21364
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 06:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726639871; cv=none; b=abl9K4b+7s9AyRIEyWpec95iP29pGwlZlz8wmY8GJt/yAElR6d8nZcmvt7L7BOy2XqOXZwqutUaQWfJBHvobd2XZx5aRkmtdnKO7kRap+Yot4NKfkGxT82BDH3aYTGCkVn0b9tRnoIbpzeftN+KifAUx7zdnG6KepNCgqmdSd3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726639871; c=relaxed/simple;
	bh=Fs7SkJiNyTPzB9lUdr8kGe29nej2ttEaZvqPCwdl6Lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J9o89YKGQUv/B5sF9RiFtufx/rNhxOlq+yN4/+yAiKz6pSP3ZzdLE2nDwX3xrHlj/MeISpbYXnL+PSIzcBTcJr+MCzGobUeCgLIkDdmU5rYPkM9dcjGsaIGdeoakIHvIGd0ZMWoolYQGn1SrCT2NU28bBsS57p+uvLoImUO9n5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 53753227A88; Wed, 18 Sep 2024 08:11:05 +0200 (CEST)
Date: Wed, 18 Sep 2024 08:11:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create perag structures as soon as possible
 during log recovery
Message-ID: <20240918061105.GA31947@lst.de>
References: <20240910042855.3480387-1-hch@lst.de> <20240910042855.3480387-4-hch@lst.de> <ZueJusTG7CJ4jcp5@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZueJusTG7CJ4jcp5@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 16, 2024 at 11:28:26AM +1000, Dave Chinner wrote:
> I'm missing something - the intents aren't processed until the log
> has been recovered - queuing an intent to be processed does
> not require the per-ag to be present. We don't take per-ag
> references until we are recovering the intent. i.e. we've completed
> journal recovery and haven't found the corresponding EFD.
> 
> That leaves the EFI in the log->r_dfops, and we then run
> ->recover_work in the second phase of recovery. It is
> xfs_extent_free_recover_work() that creates the
> new transaction and runs the EFI processing that requires the
> perag references, isn't it?
> 
> IOWs, I don't see where the initial EFI/EFD recovery during the
> checkpoint processing requires the newly created perags to be
> present in memory for processing incomplete EFIs before the journal
> recovery phase has completed.

So my new test actually blows up before creating intents:

[   81.695529] XFS (nvme1n1): Mounting V5 Filesystem 07057234-4bec-4f17-97c5-420c71c83292
[   81.704541] XFS (nvme1n1): Starting recovery (logdev: internal)
[   81.707260] XFS (nvme1n1): xfs_buf_map_verify: daddr 0x40003 out of range, EOFS 0x40000
[   81.707974] ------------[ cut here ]------------
[   81.708376] WARNING: CPU: 1 PID: 5004 at fs/xfs/xfs_buf.c:553 xfs_buf_get_map+0x8b4/0xb70

Because sb_dblocks hasn't been updated yet.  I'd kinda assume we run
into the intents next, but maybe we don't.  I can try how far just
fixing the sb would get us, but that will potentially gets us into
more problems late the more we actually use the pag structure.

> If we are going to keep this logic, can you do this as a separate
> helper function? i.e.:

I actually did that earlier, and it turned out to create a bit more
boilerplate than I liked, but I can revert to it if there is a strong
preference.

> > +	xfs_sb_from_disk(&mp->m_sb, dsb);
> > +	if (mp->m_sb.sb_agcount < old_agcount) {
> > +		xfs_alert(mp, "Shrinking AG count in log recovery");
> > +		return -EFSCORRUPTED;
> > +	}
> > +	mp->m_features |= xfs_sb_version_to_features(&mp->m_sb);
> 
> I'm not sure this is safe. The item order in the checkpoint recovery
> isn't guaranteed to be exactly the same as when feature bits are
> modified at runtime. Hence there could be items in the checkpoint
> that haven't yet been recovered that are dependent on the original
> sb feature mask being present.  It may be OK to do this at the end
> of the checkpoint being recovered.
> 
> I'm also not sure why this feature update code is being changed
> because it's not mentioned at all in the commit message.

Mostly to keep the features in sync with the in-memory sb fields
updated above.  I'll switch to keep this as-is, but I fail to see how
updating features only after the entire reocvery is done will be safe
for all cases either.

Where would we depend on the old feature setting?

> 
> > +	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
> > +			mp->m_sb.sb_dblocks, &mp->m_maxagi);
> 
> Why do this if sb_agcount has not changed?  AFAICT it only iterates
> the AGs already initialised and so skips them, then recalculates
> inode32 and prealloc block parameters, which won't change. Hence
> it's a total no-op for anything other than an actual ag count change
> and should be skipped, right?

Yes, and the way how xfs_initialize_perag it is an entire no-op.
But I can add an extra explicit check to make that more clear.

