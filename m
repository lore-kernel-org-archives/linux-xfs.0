Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2F55B1E1
	for <linux-xfs@vger.kernel.org>; Tue,  6 Feb 2024 05:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707197412; cv=none; b=McZQznuU6Pj4+qFLhh0giE69zL0oFbqMUC18VAJyB9rAyAIVHN7w0gguXCW5iWc3bhGa4jYiPzPsZz+snELcN4aQH2dHRDZatQGbnEGrZWSXLICn1dVQOZVhHH7fvsZ4U64pybYyWJgJn3YcxXY4RJl/O+N/2nP+EG0fjd7OHS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707197412; c=relaxed/simple;
	bh=H/TSPrWx2QrDvRs1sopHr6tKAdCPeVEPEl3rXtmLhr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SATDoeIQRK57bNOGthCGAuwt95P5pHICiI/2q+e4zBjS0uxtA/k1yb8owH3Xr2ocm+XTR/hzfCzI14uPiQeS4/Mllrh1gTZlsCJxy4re2TCGUWw6U6wri2SjLNmqr/SVkWhwVkIasH4q9EnmkAXZgoG69VevA+q36LUBWgLYTzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBuUX1we; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBuUX1we"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7D3C433C7;
	Tue,  6 Feb 2024 05:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707197412;
	bh=H/TSPrWx2QrDvRs1sopHr6tKAdCPeVEPEl3rXtmLhr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WBuUX1weXr6n8rZk01t8ZfrP9U7ieJc2+LX23N0E3Wfu2HxDIPnw2S8lvp9Nw4lvJ
	 PAOYzMEpX/0esgSvwcgm0aMrAehvLBkNr8THMKsrXjJaSnFiHHeXmRCuz+O3cHnTdW
	 jrs0DPP3kQfS/E4su8HqFPfJIErDBZi5Rtp6dxmf1jodfJdnO/ZNeVxy5vtcx7+4gD
	 Hpy7Cf/4hzp+aGEanqGU83+zM+cC3fxtuktLJjaIfZ5v0SKqEogFk8cs3vu1kZJa4i
	 Cj1Ohp4Wf1kCsUuDVthXZChI6iXp+L7DzIm+fNPUfb2WUDqhi2BzpSiFK1kCgT05ng
	 3HvBQ5jOqtXkQ==
Date: Mon, 5 Feb 2024 21:30:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_clear_incompat_log_features considered harmful?
Message-ID: <20240206053011.GB6226@frogsfrogsfrogs>
References: <20240131230043.GA6180@frogsfrogsfrogs>
 <ZcA1Q5gvboA/uFCC@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcA1Q5gvboA/uFCC@dread.disaster.area>

On Mon, Feb 05, 2024 at 12:09:23PM +1100, Dave Chinner wrote:
> On Wed, Jan 31, 2024 at 03:00:43PM -0800, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > Christoph spied the xfs_swapext_can_use_without_log_assistance
> > function[0] in the atomic file updates patchset[1] and wondered why we
> > go through this inverted-bitmask dance to avoid setting the
> > XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT feature.
> > 
> > (The same principles apply to xfs_attri_can_use_without_log_assistance
> > from the since-merged LARP series.)
> > 
> > The reason for this dance is that xfs_add_incompat_log_feature is an
> > expensive operation -- it forces the log, pushes the AIL, and then if
> > nobody's beaten us to it, sets the feature bit and issues a synchronous
> > write of the primary superblock.  That could be a one-time cost
> > amortized over the life of the filesystem, but the log quiesce and cover
> > operations call xfs_clear_incompat_log_features to remove feature bits
> > opportunistically.  On a moderately loaded filesystem this leads to us
> > cycling those bits on and off over and over, which hurts performance.
> > 
> > Why do we clear the log incompat bits?  Back in ~2020 I think Dave and I
> > had a conversation on IRC[2] about what the log incompat bits represent.
> > IIRC in that conversation we decided that the log incompat bits protect
> > unrecovered log items so that old kernels won't try to recover them and
> > barf.  Since a clean log has no protected log items, we could clear the
> > bits at cover/quiesce time.  At the time, I think we decided to go with
> > this idea because we didn't like the idea of reducing the span of
> > kernels that can recover a filesystem over the lifetime of that
> > filesystem.
> 
> I don't think that was the issue - it was a practical concern that
> having unnecessary log incompat fields set would prevent the common
> practice of provisioning VMs with newer kernels than the host is
> running.

aha, thanks for refreshing my memory.

> The issue arises if the host tries to mount the guest VM image to
> configure the clone of a golden image prior to first start. If there
> are log incompat fields set in the golden image that was generated
> by a newer kernel/OS image builder then the provisioning
> host cannot mount the filesystem even though the log is clean and
> recovery is unnecessary to mount the filesystem.
> 
> Hence on unmount we really want the journal contents based log
> incompat bits cleared because there is nothing incompatible in the
> log and so there is no reason to prevent older kernels from
> mounting the filesytsem.

<nod> Will it be a problem if we crash with a log incompat bit set but
none of the actual log items that it protects in the ondisk log?

> > [ISTR Eric pointing out at some point that adding incompat feature bits
> > at runtime could confuse users who crash and try to recover with Ye Olde
> > Knoppix CD because there's now a log incompat bit set that wasn't there
> > at format time, but my memory is a bit hazy.]
> > 
> > Christoph wondered why I don't just set the log incompat bits at mkfs
> > time, especially for filesystems that have some newer feature set (e.g.
> > parent pointers, metadir, rtgroups...) to avoid the runtime cost of
> > adding the feature flag.  I don't bother with that because of the log
> > clearing behavior.  He also noted that _can_use_without_log_assistance
> > is potentially dangerous if distro vendors backport features to old
> > kernels in a different order than they land in upstream.
> 
> This is what incompat feature bits are for, not log incompat bits.
> We don't need log incompat bits for pp, metaddir, rtgroups, etc
> because older kernels won't even get to log recovery as they see
> incompat feature bits set when they first read the superblock.
> 
> IOWs, a log incompat flag should only be necessary to prevent log
> recovery on older kernels if we change how something is logged
> without otherwise changing the on disk format of those items (e.g.
> LARP). There are no incompat feature bits that are set in these
> cases, so we need a log incompat bit to be set whilst the journal
> has those items in it....

Ok.

> > Another problem with this scheme is the l_incompat_users rwsem that we
> > use to protect a log cleaning operation from clearing a feature bit that
> > a frontend thread is trying to set -- this lock adds another way to fail
> > w.r.t. locking.  For the swapext series, I shard that into multiple
> > locks just to work around the lockdep complaints, and that's fugly.
> 
> We can avoid that simply by not clearing the incompat bit at cover
> time, and instead do it only at unmount. Then it only gets set once
> per mount, and only gets cleared when we are running single threaded
> on unmount. No need for locking at this point holding the superblock
> buffer locked will serialise feature bit addition....

Ok.  I can live with that -- clearing the log-incompat bits on a clean
unmount, and leaving them set at cleaning time.  I think this means
l_incompat_users can go away too.

> > Going forward, I'd make mkfs set the log incompat features during a
> > fresh format if any of the currently-undefined feature bits are set,
> > which means that they'll be enabled by default on any filesystem with
> > directory parent pointers and/or metadata directories.  I'd also add
> > mkfs -l options so that sysadmins can turn it on at format time.
> 
> At this point they are just normal incompat feature bits. Why not
> just use those instead? i.e. Why do we need log incompat bits to be
> permanently sticky when we've already got incompat feature bits for
> that?

Without the "clear log incompat on clean" behavior, I don't think we
need anything I wrote about in that paragraph anymore either.

So, if I'm reading you both correctly, I'll:

1. change the log incompat handling code to clear them on umount only;
2. add a mount option to allow admins to permit setting of log incompat
   flags;
3. leave the xfs_{swapext,attri}_can_use_without_log_assistance
   functions as they are in djwong-wtf so that new incompat filesystem
   features will eliminate the need for setting/clearing the log
   incompat flags

Did I get that right?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
