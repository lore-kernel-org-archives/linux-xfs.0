Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444FE1FE44D
	for <linux-xfs@vger.kernel.org>; Fri,  4 Apr 2025 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743782973; cv=none; b=T2HKIYWeN5AzN9DST5ZCDljwQ9Ix2Vnm2vvj5Q/xu6XccMGPgofI2ZM0433y7f3xl1riziawl4AdzOMHAGIa8vUrBM8623LJiSPN0INSC39rfuzslDPI0ojYBPOY20qJAwmvqcW+bowoGUlyI3CI6MpqI/UxUle9AXAuFXDIKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743782973; c=relaxed/simple;
	bh=eoK7ExN7d7Yj0y6wENyG3jh/iWmpZN4k5bx6Xbu2MF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUu/HhC8y1S/KPgRFcw1FYmq3vFAXfKYbSgqK6+LYHDGQaILUxYGrsSSw0m4B6vR32s1LDtRAfLR/e3s3BCdc+6So/TK+vNek4mHz0/ZbbzE+OBSX6Xa82i2b7S783cmcd1Ty3OkHrpkRcAl77omVzCVqNaL3qN0J4AeBAbKeOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byXSiBOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byXSiBOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB945C4CEE9;
	Fri,  4 Apr 2025 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743782970;
	bh=eoK7ExN7d7Yj0y6wENyG3jh/iWmpZN4k5bx6Xbu2MF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=byXSiBOW/77RY7kBe4JZ97FgpZP7a7BpencYmMI1EMTUJTbE7mLn88QnbbuDbowSW
	 SzFLzXj3ZdgLsXheMibSXPPsuXPboj/k24HIyQlpZbTtMnwwNYPz5fiBGeemGwfYB0
	 QPjkd5CkbfA2COoAZCTt/jeyBIj1vcYKVW6dHch8dw1/JrOOzbNBQGUF+X+76A0B5+
	 0NYweWBBNmqQtr4cCt4WjG3A8bSRSl35sxjXkjCAX8IPANN+PXF/T9soAEHN0/zr51
	 EGpCLpl5q3OSHO0AWdsbkFv+OtGyFOxYw1AswpRmeXz6/Ddsewdo0EsUAYcOByhrON
	 Mqv6tpKybG1qw==
Date: Fri, 4 Apr 2025 09:09:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: compute the maximum repair reaping defer intent
 chain length
Message-ID: <20250404160930.GC6283@frogsfrogsfrogs>
References: <20250403191244.GB6283@frogsfrogsfrogs>
 <ce1887ca-3b05-4a90-bb20-456f9fb3c4f5@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce1887ca-3b05-4a90-bb20-456f9fb3c4f5@oracle.com>

On Fri, Apr 04, 2025 at 10:16:39AM +0100, John Garry wrote:
> On 03/04/2025 20:12, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Actually compute the log overhead of log intent items used in reap
> > operations and use that to compute the thresholds in reap.c instead of
> > assuming 2048 works.  Note that there have been no complaints because
> > tr_itruncate has a very large logres.
> > 
> 
> Thanks for this, but I have comments at the bottom

<snip>

> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index 89decffe76c8b5..3e214ce2339f54 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -77,6 +77,11 @@ xfs_rui_item_size(
> >   	*nbytes += xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents);
> >   }
> > +unsigned int xfs_rui_item_overhead(unsigned int nr)
> > +{
> > +	return xlog_item_space(1, xfs_rui_log_format_sizeof(nr));
> > +}
> > +
> >   /*
> >    * This is called to fill in the vector of log iovecs for the
> >    * given rui log item. We use only 1 iovec, and we point that
> > @@ -180,6 +185,11 @@ xfs_rud_item_size(
> >   	*nbytes += sizeof(struct xfs_rud_log_format);
> >   }
> > +unsigned int xfs_rud_item_overhead(unsigned int nr)
> 
> I guess that it is intentional, but nr is not used

Eh, yeah, I suppose these parameters aren't necessary.

> > +{
> > +	return xlog_item_space(1, sizeof(struct xfs_rud_log_format));
> > +}
> 
> I just noticed that this function - in addition to xfs_cud_item_overhead()

Hmmm.  Scrub uses tr_itruncate for transactions.  For reaping, it allows
up to half the reservation for intent items, and the other half to make
progress on one of those intent items.  So if we start by attaching this
to the first reap transaction:

RUI 0
EFI 0
...
RUI X
EFI X

Then on the next ->finish_one call, we'll finish RUI 0's deferred work.
In the worst case all the items need relogging, so the second reap
transaction looks like this:

RUD 0
EFD 0 + EFI 0'
...
RUD X + RUI X'
EFD X + EFD X'
<pile of rmap btree buffers>

So I guess the computation /does/ need to account for RUDs, so the code
at the top of xreap_agextent_max_deferred_reaps should be:

	const unsigned int	efi = xfs_efi_item_overhead(1) +
				      xfs_efd_item_overhead(1);
	const unsigned int	rui = xfs_rui_item_overhead(1) +
				      xfs_rud_item_overhead(1);

Thanks for pointing that out.

Thinking about this further, reaping doesn't touch the bmap and it only
processes a single logical change to a single extent.  So we don't need
to save half of the tr_itruncate reservation for the actual btree
updates; that could instead be:

	/*
	 * agf, agfl, and superblock for the freed extent
	 * worst case split in allocation btrees for freeing 1 extent
	 */
	upd = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
	      xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1), blksz);

	ret = (sc->tp->t_log_res - upd) / per_intent;

Note that xfs_allocfree_block_count allows for two full rmap btree
splits already, so upd covers the btree buffer updates for the RUI case.
I would conservatively double upd because rolling to accomodate more
intent items is better than overrunning the reservation.

> and xfs_cui_item_overhead() - are not referenced in this patch, but only in

The refcount intent items aren't needed for online fsck because xreap_*
doesn't mess with file data.  They're provided entirely for the sake of
cow fallback of multi-fsblock untorn writes.  IOWs, it's to reduce churn
between our patchsets (really, this patch and your patchset) assuming
that part of untorn writes actually goes into 6.16.

> the rest of the internal series which this is taken from.

I wish you wouldn't mention internal patchsets on public lists.

For everyone else who just saw this -- this used to be patch 2 of a
3-patch series that I sent John to support his work on the cow fallback
for multi-fsblock untorn writes.  The first patch was buggy so I threw
it away, and the third patch wasn't really needed but I didn't figure
that out until the second re-read of it.  This is the only remaining
patch.

--D

> > +
> >   /*
> >    * This is called to fill in the vector of log iovecs for the
> >    * given rud log item. We use only 1 iovec, and we point that
> 
> 
