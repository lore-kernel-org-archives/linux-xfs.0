Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD023033DE
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 05:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563548; cv=none; b=s5yANmX0kkYJ/efqxLCerFgmCKpQ3dXX9vk5aZJ7IiMvj+hZca5aOL+zRe5RDTnpYvj1rcdt1oBZUG+1kA9NLXFQC4Lm31yor83TvE404t7OGS5wz5NUFvmTDmO465h4uHZLL2BIlwmis53xPYGZg05KIHHl4iEPB4rABZwX4i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563548; c=relaxed/simple;
	bh=hXItnFK1UmSi0b0rWCJdwb88leV1vRHlv1ko6JVy43g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=drPC6oRoBs1DXHFdfZ+mTmzJg7u7g++TrHOsusZFmM1490YAIwDwb01cPpwafzsh+kg0nvHXVMAYj+peaVqY0H35WaDlnNIrfmIfpuC+C5cPaF/rZG7rnbCYnksX2FZBlGAOPkrmNDaV2i8y4FHhbZGO5e+0oWetx9HSlXEf9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iv+SG/i2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iv+SG/i2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD6EC2BCB8;
	Tue, 12 May 2026 05:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778563547;
	bh=hXItnFK1UmSi0b0rWCJdwb88leV1vRHlv1ko6JVy43g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iv+SG/i2OgPql4j9f418fM+CpaAtjFhQgTcnocHFVZHHbtWz5MZ6UKa8cMhRZKVrB
	 F/NK3T2rkeGacTHBqHQIpVRwWzIaW78NUeih7/i0iVdL86+LnpaA8uy9RrPzvjrHXt
	 Pvu+QbWrtckr+ilqGPn5xMV7OGqkmxJ0A/VYHXpDdyg8kPE5YQTz4V4wpvwfSUVB4D
	 ANe3hgRnHul8RLThIwDhLUHQTnJix+Vda5Wm3qR/mJrjA98B8rjWCgEj3eI488pQBh
	 yOp8VeDcKrD/wrpyh1xKlcNesagS+CEo/F7JhCp82ekJfXE6AqV9OFTxEWKMT/Cq90
	 33i0osvzWdwQQ==
Date: Tue, 12 May 2026 15:25:41 +1000
From: Dave Chinner <dgc@kernel.org>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Andres Freund <andres@anarazel.de>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>, gost.dev@samsung.com,
	p.raghav@samsung.com
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
Message-ID: <agK51XboX2fc2ll7@dread>
References: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>
 <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6>

On Thu, May 07, 2026 at 10:34:43PM +0200, Pankaj Raghav (Samsung) wrote:
> On Wed, May 06, 2026 at 09:26:25AM -0400, Andres Freund wrote:
> > Hi,
> > 
> > While looking at performance issues on Samsung client drives due to slow FUA,
> > I tried to reproduce older numbers on a recent kernel.  And couldn't, at first
> > - but not because the problem went away, but because the fdatasync numbers
> > (which shouldn't use FUA) got *much* worse.
> > 
> > These drives have FUA writes that are slower than full flushes, making
> > O_DIRECT|O_DSYNC writes perform poorly and fdatasync() comparatively better.
> > 
> > 
> > What I'm seeing is that with recent kernels the fdatasync() performance is
> > roughly as bad as the O_DSYNC, whereas previously it was > 2x as
> > fasts. blktrace showed that there are ongoing FUA writes during a workload
> > with just overwriting writes and an fdatasync after every write.
> > 
> > 
> > At first I thought it was a regression between 7.0..7.1-rc2, but that turned
> > out to be only because the 7.0 machine did not have lazytime enabled. After
> > fixing that discrepancy, the regression is also visible in 7.0.  I have
> > confirmed it's not visible in 6.18.
> 
> I was able to reproduce this issue. The commit causing the issue is
> indeed from nonblocking timestamps series as you indicated 
> (fs: add support for non-blocking timestamp updates).
> 
> In inode_update_cmtime, we have the following changes as a part of the
> series:
> ...
> mtime_changed = !timespec64_equal(&now, &mtime);
> 	if (mtime_changed || !timespec64_equal(&now, &ctime))
> 		dirty = inode_time_dirty_flag(inode);  // #1
> 
> 	/*
> 	 * Pure timestamp updates can be recorded in the inode without blocking
> 	 * by not dirtying the inode.  But when the file system requires
> 	 * i_version updates, the update of i_version can still block.
> 	 * Error out if we'd actually have to update i_version or don't support
> 	 * lazytime.
> 	 */
> 	if (IS_I_VERSION(inode)) {
> 		if (flags & IOCB_NOWAIT) {
> 			if (!(inode->i_sb->s_flags & SB_LAZYTIME) ||
> 			    inode_iversion_need_inc(inode))
> 				return -EAGAIN;
> 		} else {
> 			if (inode_maybe_inc_iversion(inode, !!dirty)) //#2
> 				dirty |= I_DIRTY_SYNC;
> 		}
> 	}
> 
> ...

Ugh. Given we don't support i_version as an externally visible
change_cookie any more (we have multigrained timestamps for that
now), why do we still set SB_I_VERSION and jump
through all these complex hoops to set maintain something we don't
actually need?

i.e. going back to ip->di_version++ whenever the inode is logged to
maintain the on-disk change version would make things so much
simpler here...

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
