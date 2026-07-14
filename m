Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7613FF1DC;
	Tue, 14 Jul 2026 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784052950; cv=none; b=aRvrHTj72Lu/uHyyuLkVYOYl0HwsLaqnN6tGEHfZEvk90morP7P5jj5CH3g9X9ce8HlYvFgb9XS7woYZHpevYpnjsdBIL0l6BVINbbAfrvs7guoVLfXvbSK3Vjg9GjzbqILowWwT62cWj2nHrvRlt2cMPQoRvFGIiUB29U9T7tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784052950; c=relaxed/simple;
	bh=xPvfxje7YaR5IdNM0CRKeHs3gY2YZCsaN6aLpX5bdxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWFC6W4xj4+90FFCWvZLTLGK7bFDhDqDxOECdZfLZxxi8ft+nqRSfudLTnw+fUrFDl851naLhSbP4q+Qk/oksy9SAlbJZy6dBDfwr7ET+TexmMzSFAPZDn0jBgSb0czGmgTGkOl7IDGt9vyyFmDPDaEXD/h3JadAh3ZgqzOFRK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BpLqAf/g; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BpLqAf/g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=BDRfQDib/z9B1BsarbaLihpCO5f0Vdj9FB1+83Vr95w=; b=BpLqAf/gO0vW/sEagFo1t6DWEf
	9dODVxX1zB/7fgFD/d0kyQU7sTxjnp+F9IYIW3fq8j7KBjyaV9AVmymf21qbT3DyzTyJpZM0kb7Yc
	bKSaqWluPkYcU/itC3TapdjKEwSFZPBKvqOVu18vxK14KHrOxG4kxfshHjRs58a9uR0I62q3ztLKM
	JDhbJiP8IE6Y3GxbQLFgqSdgce9V35JiyggQXClRMzRhHAwbu84Wi0iCiaRE5fI3EotjmwnWzdnH9
	WqtxizescJ71/RRb92HX6gdkZrTQZw+RSKBQ46GvLr3BPbftVnEj2ddINiJiR/ez6n4CxcP73xJVD
	h5N4WPmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhfU-0000000FfbE-2muA;
	Tue, 14 Jul 2026 18:15:44 +0000
Date: Tue, 14 Jul 2026 19:15:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Zhou, Yun" <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <alZ80Dv4uNWWhrDk@casper.infradead.org>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
 <alToBmAN_HyeXth9@infradead.org>
 <20260713230420.GN7195@frogsfrogsfrogs>
 <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>
 <20260714175528.GG7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260714175528.GG7380@frogsfrogsfrogs>

On Tue, Jul 14, 2026 at 10:55:28AM -0700, Darrick J. Wong wrote:
> [add linux-mm since we're talking about memalloc_nofs_save]

Thanks!

> On Tue, Jul 14, 2026 at 10:15:53AM +0800, Zhou, Yun wrote:
> > On 7/14/26 07:04, Darrick J. Wong wrote:
> > > On Mon, Jul 13, 2026 at 06:28:38AM -0700, Christoph Hellwig wrote:
> > > > On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
> > > > > On 7/13/26 17:09, Christoph Hellwig wrote:
> > > > > > On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> > > > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > > > index 7bfbd9f6f0df..1b36cf12d4e3 100644
> > > > > > > --- a/fs/xfs/xfs_trans.c
> > > > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > > > @@ -1029,6 +1029,15 @@ xfs_trans_roll(
> > > > > > >          * duplicate transaction that gets returned.
> > > > > > >          */
> > > > > > >         error = __xfs_trans_commit(tp, true);
> > > > > > > +
> > > > > > > +     tp = *tpp;
> > > > > > > +     /*
> > > > > > > +      * __xfs_trans_commit cleared the NOFS flag by calling into
> > > > > > > +      * xfs_trans_free.  Set it again here before doing memory
> > > > > > > +      * allocations.
> > > > > > > +      */
> > > > > > > +     xfs_trans_set_context(tp);
> > > > > > 
> > > > > > The tp assignment above now returns the incorrect transaction when
> > > > > > __xfs_trans_commit fails, so you can't do this.
> > > > > > 
> > > > > > Otherwise yes, this call should move up.  I don't really see how
> > > > > > it fixes the syzbot report, though.
> > > > > 
> > > > > Thank you very much for your reply. The tp here is a local variable only
> > > > > used for convenience within the function. The caller always gets the new
> > > > > transaction through *tpp, which was set by xfs_trans_dup() before the commit
> > > > > call. Moving tp = *tpp before the error check doesn't change what the caller
> > > > > sees - *tpp still points to the new (dup'd) transaction regardless.
> > > > 
> > > > Ah, right.  Tis should be fine:
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Why not move tp_pflags to the new transaction in xfs_trans_dup like we
> > > do for the deferred item list:
> > > 
> > >          /* move deferred ops over to the new tp */
> > >          xfs_defer_move(ntp, tp);
> > > 
> > >          ntp->t_pflags = tp->t_pflags;
> > >          tp->t_pflags = 0;
> > 
> > That's what the old xfs_trans_switch_context() did before a1ca658d649a
> > removed it. The problem is that setting tp->t_pflags = 0 means
> > xfs_trans_free() calls memalloc_nofs_restore(0), which relies on that being
> > a  no-op — an mm implementation detail. A fresh memalloc_nofs_save() on the
> > new tp keeps the save/restore pairing correct unconditionally.
> 
> So add a new helper.
> 
> /**
>  * memalloc_flags_take - move an implicit __GFP_MEMALLOC scope from one
>  * tracking structure to another.
>  */
> static inline unsigned int
> memalloc_flags_take(unsigned int *old_flags)
> {
> 	unsigned int ret = *old_flags;
> 
> 	*old_flags = 0;
> 	return ret;
> }
> 
> and then:
> 
> 	/* move deferred ops over to the new tp */
> 	xfs_defer_move(ntp, tp);
> 
> 	ntp->t_pflags = memalloc_flags_take(&tp->t_pflags);

I might stick with the 'move' wording?  ie memalloc_flags_move().

And I think you should bury the call to memalloc_flags_move() inside
xfs_defer_move().  I don't think there's a case where you'd want to move
from one transaction to another without preserving the nofs state, is
there?  Bit hard to tell since there's only one caller of xfs_defer_move()
in the XFS code base.
