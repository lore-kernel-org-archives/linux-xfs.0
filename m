Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D664313FD69
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717171254; cv=none; b=jwhigiTdTmCBM23rBHKp5hYErGl27Y53Pfn3oL+XOJTPcBxT+Kx81fU5HQ9KTubDtwa1x05PqlAjKiCVlrIfSbVbrRQuFl4U2lcAeBEnBZl4epND7QWQA2nawlmCJeYIu9HKtBqg3jHf6xN4yzEcaD9366T4N6ZOdh8vc2VoeV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717171254; c=relaxed/simple;
	bh=Q7ByjXCKnhpnn2HXJZlTb+B2QfTijpEgmdLToDRcV1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nswEBJg7gmeLPp7Jc+5NU088+J1WvBmqOI8CbJUnrbuIW0+Yb6KsrVRy37GzJDIceMBjE1f9cTq5xNkNBOK032Ea0PlRGxfDWczTxmwie03mEn6IADa7I/ozxZiulZgOBHUsKsv3wWdkunbhubbQ1Gcx5neWoYNLWelegktRajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TH2o7j+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TH2o7j+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A5AC116B1;
	Fri, 31 May 2024 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717171254;
	bh=Q7ByjXCKnhpnn2HXJZlTb+B2QfTijpEgmdLToDRcV1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TH2o7j+Ow0Jjfthcz6GhD2gqGhS3etVFIV+996d0i1OEflHR/8ik3Shi7nWuU31zl
	 iG8pcCSrfTQHAtLFTH87h6LLdaaa52y5R0qveGdFxM6062zhOjdiHvcuCK1J1L5sOX
	 XWW9nP4uhkzTruvlthfsftrqOOp7TPf02VaTCfVq/rxuwuCkG9Df9lOJNRrtQQ7iYX
	 AfamqytR7VNRm1UmQbWLj5FiN+AM6PoS5IVDPRvKUKAbBWQhbllSe4ex1KXz9vegNV
	 YGmKELNjphfnEO5r5qDE8EOgyzDuXfkbxIZgrTDt1VzWkWCo+tBEzCm+3r66xPXpn9
	 gB2vpEgAZxt8A==
Date: Fri, 31 May 2024 09:00:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Message-ID: <20240531160053.GQ52987@frogsfrogsfrogs>
References: <20240517212621.9394-1-wen.gang.wang@oracle.com>
 <20240520180848.GI25518@frogsfrogsfrogs>
 <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>

On Mon, May 20, 2024 at 10:42:02PM +0000, Wengang Wang wrote:
> Thanks Darrick for review, pls see inlines:
> 
> > On May 20, 2024, at 11:08 AM, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Fri, May 17, 2024 at 02:26:21PM -0700, Wengang Wang wrote:
> >> Unsharing blocks is implemented by doing CoW to those blocks. That has a side
> >> effect that some new allocatd blocks remain in inode Cow fork. As unsharing blocks
> > 
> >                       allocated
> > 
> >> has no hint that future writes would like come to the blocks that follow the
> >> unshared ones, the extra blocks in Cow fork is meaningless.
> >> 
> >> This patch makes that no new blocks caused by unshare remain in Cow fork.
> >> The change in xfs_get_extsz_hint() makes the new blocks have more change to be
> >> contigurous in unshare path when there are multiple extents to unshare.
> > 
> >  contiguous
> > 
> Sorry for typos.
> 
> > Aha, so you're trying to combat fragmentation by making unshare use
> > delayed allocation so that we try to allocate one big extent all at once
> > instead of doing this piece by piece.  Or maybe you also don't want
> > unshare to preallocate cow extents beyond the range requested?
> > 
> 
> Yes, The main purpose is for the later (avoid preallocating beyond).

But the user set an extent size hint, so presumably they want us to (try
to) obey that even for unshare operations, right?

> The patch also makes unshare use delayed allocation for bigger extent.

If there's a good reason for not trying, can we avoid the iflag by
detecting IOMAP_UNSHARE in the @flags parameter to
xfs_buffered_write_iomap_begin and thereby use delalloc if there isn't
an extent size hint set?

(IOWs I don't really like that an upper layer of the fs sets a flag for
a lower layer to catch based on the context of whatever operation it's
doing, and in the meantime another thread could observe that state and
make different decisions.)

> >> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >> ---
> >> fs/xfs/xfs_inode.c   | 17 ++++++++++++++++
> >> fs/xfs/xfs_inode.h   | 48 +++++++++++++++++++++++---------------------
> >> fs/xfs/xfs_reflink.c |  7 +++++--
> >> 3 files changed, 47 insertions(+), 25 deletions(-)
> >> 
> >> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >> index d55b42b2480d..ade945c8d783 100644
> >> --- a/fs/xfs/xfs_inode.c
> >> +++ b/fs/xfs/xfs_inode.c
> >> @@ -58,6 +58,15 @@ xfs_get_extsz_hint(
> >>  */
> >> if (xfs_is_always_cow_inode(ip))
> >> return 0;
> >> +
> >> + /*
> >> +  * let xfs_buffered_write_iomap_begin() do delayed allocation
> >> +  * in unshare path so that the new blocks have more chance to
> >> +  * be contigurous

"contiguous"

> >> +  */
> >> + if (xfs_iflags_test(ip, XFS_IUNSHARE))
> >> + return 0;
> > 
> > What if the inode is a realtime file?  Will this work with the rt
> > delalloc support coming online in 6.10?
> 
> This XFS_IUNSHARE is not set in xfs_reflink_unshare() for rt inodes. 
> So rt inodes will keep current behavior.

<nod> Please rebase this patch against 6.10-rc1 now that it's out.

--D

> > 
> >> +
> >> if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
> >> return ip->i_extsize;
> >> if (XFS_IS_REALTIME_INODE(ip))
> >> @@ -77,6 +86,14 @@ xfs_get_cowextsz_hint(
> >> {
> >> xfs_extlen_t a, b;
> >> 
> >> + /*
> >> +  * in unshare path, allocate exactly the number of the blocks to be
> >> +  * unshared so that no new blocks caused the unshare operation remain
> >> +  * in Cow fork after the unshare is done
> >> +  */
> >> + if (xfs_iflags_test(ip, XFS_IUNSHARE))
> >> + return 1;
> > 
> > Aha, so this is also about turning off speculative preallocations
> > outside the range that's being unshared?
> 
> Yes.
> 
> > 
> >> +
> >> a = 0;
> >> if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
> >> a = ip->i_cowextsize;
> >> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> >> index ab46ffb3ac19..6a8ad68dac1e 100644
> >> --- a/fs/xfs/xfs_inode.h
> >> +++ b/fs/xfs/xfs_inode.h
> >> @@ -207,13 +207,13 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
> >>  * i_flags helper functions
> >>  */
> >> static inline void
> >> -__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
> >> +__xfs_iflags_set(xfs_inode_t *ip, unsigned long flags)
> > 
> > I think this is already queued for 6.10.
> 
> Good to know.
> 
> Thanks,
> Wengang
> 
