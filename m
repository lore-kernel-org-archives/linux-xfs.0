Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5154680605;
	Wed,  6 Mar 2024 14:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736005; cv=none; b=P1IfZYrcO2XIILPuBRyRpjwSjuSD2h34lepFX7eU1g5LnN73R2xid9B+f0VhOSqQMHEHJU7A11eO/T0RMU9RWErek2wm8H0xzGQ151E6/3/ry/x6RTURTR34iU5hWMngYEjILVdDeyKUM0sjK5YMYG7sWxGfeKJtHFf4GBoPkQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736005; c=relaxed/simple;
	bh=koJk699EPFSly+xXOqFMlY8kRTPIJ3vKQmmjIcYpl8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOOb/aJun2ryV0kqsWnFjcvB35BWK76J4zV9s7kz30v+xnFkTMQxKE3IfDwN8+wvF96bjLFJx4cvwwJNMrzqypQ33pYmXujZkJ/YNfKrNa57zLfVJPwUsnwrBA5HPVXBzKJ5LaaPjPvJD53TBo7l1AFoP4pPWilvimQGBEIqqnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=og639Qky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="og639Qky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8E7C433C7;
	Wed,  6 Mar 2024 14:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709736004;
	bh=koJk699EPFSly+xXOqFMlY8kRTPIJ3vKQmmjIcYpl8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=og639QkyYLmG/9kCI8RLcUNk4Ym4UZCbpDNC5u3oUPTD/0PWn2SkbqYsyvxGSudg8
	 BDGUuUEnwjS9yJCx5S3tv2Q8bamnW9a4W5u1ojHwvtb9JRkWrz3tE6L34TMo4mC9+3
	 IFCCAJg9whzRaij6l/MOTso6/C/3qj9ixwO3CF9/0TEoNEGmwuTzmjl3iXr+OZtUL4
	 y2kV0DpjD5W12+GA4uyjuGGJPCbJZWTeRV8fHKVQ2eA+nnmWEW0nYXj7+SlCAIiZFH
	 AcTxE6snyXb44wRSXMhUqBZ1iLhL2bfHpfydCh1yfzt5Thprkl00Vel6wcLIRQ9cwP
	 oPZmfMq0g4k6w==
Date: Wed, 6 Mar 2024 07:40:02 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] General protection fault while discarding extents
 on XFS on next-20240305
Message-ID: <ZeiAQv6ACQgIrsA-@kbusch-mbp>
References: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zehi_bLuwz9PcbN9@infradead.org>
 <Zeh_e2tUpx-HzCed@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zeh_e2tUpx-HzCed@kbusch-mbp>

On Wed, Mar 06, 2024 at 07:36:43AM -0700, Keith Busch wrote:
> On Wed, Mar 06, 2024 at 04:35:09AM -0800, Christoph Hellwig wrote:
> > On Wed, Mar 06, 2024 at 12:49:29PM +0530, Chandan Babu R wrote:
> > > The above *probably* occured because __blkdev_issue_discard() noticed a pending
> > > signal, processed the bio, freed the bio and returned a non-NULL bio pointer
> > > to the caller (i.e. xfs_discard_extents()).
> > > 
> > > xfs_discard_extents() then tries to process the freed bio once again.
> > 
> > Yes, __blkdev_issue_discard really needs to clear *biop to NULL for
> > this case, i.e.:
> > 
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index dc8e35d0a51d6d..26850d4895cdaf 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -99,6 +99,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
> >  		cond_resched();
> >  		if (fatal_signal_pending(current)) {
> >  			await_bio_chain(bio);
> > +			*biop = NULL;
> >  			return -EINTR;
> >  		}
> >  	}
> 
> But everyone who calls this already sets their local bio to NULL by
> default, and __blkdev_issue_discard updates *biop only on success, so
> '*biop' should already be NULL here. ?

Oh my mistake: xfs_discard_extents() does this in a loop and chains
along the previous iteration's bio. Your update is needed and looks
good.
