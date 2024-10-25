Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C481D9A46
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 22:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729894760; cv=none; b=YXmr1mDIACCpNIkFWwMuGc5IYIoU+Y3iS6E7glBOZo/gfOEEbViXDCqb760Wgbf9BCl752ZiHqpUD4UgmLQQFNN/Ni2KD1EJ2rat1Wgks5BmlquwdYk66IYEQh2xWkkzqSDjeCkklFIAECAgIiaD2pHCiiHqIHnrhxggJ0uTUgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729894760; c=relaxed/simple;
	bh=ULUTog71d+iXYLwrJNaHVxIJGuiezm2qQCOgdSovMRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOkssQLCLuU/ARsfEcmzbWlxlt0Fw938uuYWRGUNRTad+hPdLdhWvfpTPtSMXeEN8eV6WwdoIOCHGMIYrP9rNKNnpxmSM7ReC3aV08V7vPUKeSq2AVjCetsnFDyrK8PQJdsA3io5z6LHKfZkK5nKxs3Ixe7FnOpR3C2erONl4hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBaLLWh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBaLLWh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FA6C4CEC3;
	Fri, 25 Oct 2024 22:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729894760;
	bh=ULUTog71d+iXYLwrJNaHVxIJGuiezm2qQCOgdSovMRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IBaLLWh+2NRaqjARnfA+psiazI7oFvQB2F3HZ2kcVQuBoeU6NS3jA3a78lIqLvqR2
	 oBPLSm77R9RcTf7NUJZCNdD35TDqj2Ppdm9v9i1zZdg4lbVaZzOQmhO3tUbsNG+R4V
	 148rGlA1H7yp/eZIPyCqAdVDYKgFdML2arA6LsTksxf06kv/oo1jr+3vvfvQ7YgfoQ
	 y7Q5vjjHZHDx6XxUSxLd18f49Qfsz1W275bjix/Yq5fQQHu91GP/RvzkA6PB0akAms
	 LJuVKM4L+wD+Iv4hCCycGpoAj4Y8fTvfgMwzSRij87fjhZg5eeVGTzK5kiwOWQl0q1
	 WCYycYg4XQx6Q==
Date: Fri, 25 Oct 2024 15:19:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: allow sparse inode records at the end of runt
 AGs
Message-ID: <20241025221919.GP2386201@frogsfrogsfrogs>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <20241024025142.4082218-3-david@fromorbit.com>
 <20241024170038.GJ21853@frogsfrogsfrogs>
 <Zxs+HQGuJziECU5i@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxs+HQGuJziECU5i@dread.disaster.area>

On Fri, Oct 25, 2024 at 05:43:41PM +1100, Dave Chinner wrote:
> On Thu, Oct 24, 2024 at 10:00:38AM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 24, 2024 at 01:51:04PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Due to the failure to correctly limit sparse inode chunk allocation
> > > in runt AGs, we now have many production filesystems with sparse
> > > inode chunks allocated across the end of the runt AG. xfs_repair
> > > or a growfs is needed to fix this situation, neither of which are
> > > particularly appealing.
> > > 
> > > The on disk layout from the metadump shows AG 12 as a runt that is
> > > 1031 blocks in length and the last inode chunk allocated on disk at
> > > agino 8192.
> > 
> > Does this problem also happen on non-runt AGs?
> 
> No. The highest agbno an inode chunk can be allocated at in a full
> size AG is aligned by rounding down from sb_agblocks.  Hence
> sb_agblocks can be unaligned and nothing will go wrong. The problem
> is purely that the runt AG being shorter than sb_agblocks and so
> this highest agbno allocation guard is set beyond the end of the
> AG...

Ah, right, and we don't want sparse inode chunks to cross EOAG because
then you'd have a chunk whose clusters would cross into the next AG, at
least in the linear LBA space.  That's why (for sparse inode fses) it
makes sense that we want to round last_agino down by the chunk for
non-last AGs, and round it down by only the cluster for the last AG.

Waitaminute, what if the last AG is less than a chunk but more than a
cluster's worth of blocks short of sb_agblocks?  Or what if sb_agblocks
doesn't align with a chunk boundary?  I think the new code:

	if (xfs_has_sparseinodes(mp) && agno == mp->m_sb.sb_agcount - 1)
		end_align = mp->m_sb.sb_spino_align;
	else
		end_align = M_IGEO(mp)->cluster_align;
	bno = round_down(eoag, end_align);
	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;

will allow a sparse chunk that (erroneously) crosses sb_agblocks, right?
Let's say sb_spino_align == 4, sb_inoalignmt == 8, sb_agcount == 2,
sb_agblocks == 100,007, and sb_dblocks == 200,014.

For AG 0, eoag is 100007, end_align == cluster_align == 8, so bno is
rounded down to 100000.  *last is thus set to the inode at the end of
block 99999.

For AG 1, eoag is also 100007, but now end_align == 4.  bno is rounded
down to 100,004.  *last is set to the inode at the end of block 100003,
not 99999.

But now let's say we growfs another 100007 blocks onto the filesystem.
Now we have 3x AGs, each with 100007 blocks.  But now *last for AG 1
becomes 99999 even though we might've allocated an inode in block
100000 before the growfs.  That will cause a corruption error too,
right?

IOWs, don't we want something more like this?

	/*
	 * The preferred inode cluster allocation size cannot ever cross
	 * sb_agblocks.  cluster_align is one of the following:
	 *
	 * - For sparse inodes, this is an inode chunk.
	 * - For aligned non-sparse inodes, this is an inode cluster.
	 */
	bno = round_down(sb_agblocks, cluster_align);
	if (xfs_has_sparseinodes(mp) &&
	    agno == mp->m_sb.sb_agcount - 1) {
		/*
		 * For a filesystem with sparse inodes, an inode chunk
		 * still cannot cross sb_agblocks, but it can cross eoag
		 * if eoag < agblocks.  Inode clusters cannot cross eoag.
		 */
		last_clus_bno = round_down(eoag, sb_spino_align);
		bno = min(bno, last_clus_bno);
	}
	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;

This preserves the invariant that inode chunks cannot span sb_agblocks,
while permitting sparse clusters going right up to EOAG so long as the
chunk doesn't cross sb_agblocks.

> > If the only free space
> > that could be turned into a sparse cluster is unaligned space at the
> > end of AG 0, would you still get the same corruption error?
> 
> It will only happen if AG 0 is a runt AG, and then the same error
> would occur. We don't currently allow single AG filesystems, nor
> when they are set up  do we create them as a runt - the are always
> full size. So current single AG filesystems made by mkfs won't have
> this problem.

Hmm, do you have a quick means to simulate this last-AG unaligned
icluster situation?

> That said, the proposed single AG cloud image filesystems that set
> AG 0 up as a runt (i.e. dblocks smaller than sb_agblocks) to allow
> the AG 0 size to grow along with the size of the filesystem could
> definitely have this problem. i.e. sb_dblocks needs to be inode
> chunk aligned in this sort of setup, or these filesystems need to
> be restricted to fixed kernels....

I wonder if we *should* have a compat flag for these cloud filesystems
just as a warning sign to us all. :)

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
