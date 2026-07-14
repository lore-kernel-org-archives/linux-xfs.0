Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ECE32ABCD;
	Tue, 14 Jul 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784055228; cv=none; b=c2GdUtlcz4ipKBvJo9UkWJnJOyDRHQV9KJZDmkJ0oe+jbEC2nRc/+4GNET8mlSzs9KW+Ss9PKmZfnxmUFLkflTdViC7n5l1fNPTnkMj/9VEBnrFuhZ+zNTazNCZuRxMWHYiFg6wLsmP873S9M7iXAGMF/2sDkc5fsqZd9Xu0T7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784055228; c=relaxed/simple;
	bh=AOw4CBhUpkfKQoSvbsHv14tv0NRLKUplmFUEo1x4nDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zs5/f8aJYbQemaJG9wSL+NxPQwhHr8+PEwma5bq6nAsLiK5Sl7lPfGkiN9c/UY7nOLuU6wD90DCsaxcFm9Bub4Z5ZgpF6hLeZc0+B/QEuTlIYfy2soMuFlLX6Hj7zRq7gO9Jb62wvzRrinpIQ61f8h6ckDbXZmzHUOjOZblU+CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsMeaVij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsMeaVij"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6A11B1F000E9;
	Tue, 14 Jul 2026 18:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784055214;
	bh=drFn20uL6NhR91DYLEIp22lK9ia3uqNE29xicoI1pdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UsMeaVij47APGwJcrPHXd7+hvVpqN+150v8Uoyo3YcdjZ3MCelNg1wwak+G7n+BBA
	 dDxZV64KRRxMoOkvybY2pS6s3+PN99UwHmTbuC9Fp2cN/GkTJWlQs3XVDQwDm0ZDpM
	 QENQggcZF9bYD7vQTVsOLF4jjxq2LMy+qTCTgZyjJlEvpyvlvRwR9GPmUealIC0OGl
	 Vz6ZCn4Ed/wghhnkGiDsAKyHglmHMWqAH+Sr6O9J5aQK2Q9Wv/0Skme15W5ZEbT+uW
	 afsqlsPnikFiDOlzluwuI2WiI9Q/05DzhmD0jmBMmnaDOviNUcjYa4ejwIWsouX4aB
	 HTexjKWSk9Q2w==
Date: Tue, 14 Jul 2026 11:53:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Zhou, Yun" <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260714185334.GI7398@frogsfrogsfrogs>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
 <alToBmAN_HyeXth9@infradead.org>
 <20260713230420.GN7195@frogsfrogsfrogs>
 <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>
 <20260714175528.GG7380@frogsfrogsfrogs>
 <alZ80Dv4uNWWhrDk@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alZ80Dv4uNWWhrDk@casper.infradead.org>

On Tue, Jul 14, 2026 at 07:15:44PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 14, 2026 at 10:55:28AM -0700, Darrick J. Wong wrote:
> > [add linux-mm since we're talking about memalloc_nofs_save]
> 
> Thanks!
> 
> > On Tue, Jul 14, 2026 at 10:15:53AM +0800, Zhou, Yun wrote:
> > > On 7/14/26 07:04, Darrick J. Wong wrote:
> > > > On Mon, Jul 13, 2026 at 06:28:38AM -0700, Christoph Hellwig wrote:
> > > > > On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
> > > > > > On 7/13/26 17:09, Christoph Hellwig wrote:
> > > > > > > On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> > > > > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > > > > index 7bfbd9f6f0df..1b36cf12d4e3 100644
> > > > > > > > --- a/fs/xfs/xfs_trans.c
> > > > > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > > > > @@ -1029,6 +1029,15 @@ xfs_trans_roll(
> > > > > > > >          * duplicate transaction that gets returned.
> > > > > > > >          */
> > > > > > > >         error = __xfs_trans_commit(tp, true);
> > > > > > > > +
> > > > > > > > +     tp = *tpp;
> > > > > > > > +     /*
> > > > > > > > +      * __xfs_trans_commit cleared the NOFS flag by calling into
> > > > > > > > +      * xfs_trans_free.  Set it again here before doing memory
> > > > > > > > +      * allocations.
> > > > > > > > +      */
> > > > > > > > +     xfs_trans_set_context(tp);
> > > > > > > 
> > > > > > > The tp assignment above now returns the incorrect transaction when
> > > > > > > __xfs_trans_commit fails, so you can't do this.
> > > > > > > 
> > > > > > > Otherwise yes, this call should move up.  I don't really see how
> > > > > > > it fixes the syzbot report, though.
> > > > > > 
> > > > > > Thank you very much for your reply. The tp here is a local variable only
> > > > > > used for convenience within the function. The caller always gets the new
> > > > > > transaction through *tpp, which was set by xfs_trans_dup() before the commit
> > > > > > call. Moving tp = *tpp before the error check doesn't change what the caller
> > > > > > sees - *tpp still points to the new (dup'd) transaction regardless.
> > > > > 
> > > > > Ah, right.  Tis should be fine:
> > > > > 
> > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Why not move tp_pflags to the new transaction in xfs_trans_dup like we
> > > > do for the deferred item list:
> > > > 
> > > >          /* move deferred ops over to the new tp */
> > > >          xfs_defer_move(ntp, tp);
> > > > 
> > > >          ntp->t_pflags = tp->t_pflags;
> > > >          tp->t_pflags = 0;
> > > 
> > > That's what the old xfs_trans_switch_context() did before a1ca658d649a
> > > removed it. The problem is that setting tp->t_pflags = 0 means
> > > xfs_trans_free() calls memalloc_nofs_restore(0), which relies on that being
> > > a  no-op — an mm implementation detail. A fresh memalloc_nofs_save() on the
> > > new tp keeps the save/restore pairing correct unconditionally.
> > 
> > So add a new helper.
> > 
> > /**
> >  * memalloc_flags_take - move an implicit __GFP_MEMALLOC scope from one
> >  * tracking structure to another.
> >  */
> > static inline unsigned int
> > memalloc_flags_take(unsigned int *old_flags)
> > {
> > 	unsigned int ret = *old_flags;
> > 
> > 	*old_flags = 0;
> > 	return ret;
> > }
> > 
> > and then:
> > 
> > 	/* move deferred ops over to the new tp */
> > 	xfs_defer_move(ntp, tp);
> > 
> > 	ntp->t_pflags = memalloc_flags_take(&tp->t_pflags);
> 
> I might stick with the 'move' wording?  ie memalloc_flags_move().

<nod>

> And I think you should bury the call to memalloc_flags_move() inside
> xfs_defer_move().  I don't think there's a case where you'd want to move
> from one transaction to another without preserving the nofs state, is
> there?  Bit hard to tell since there's only one caller of xfs_defer_move()
> in the XFS code base.

There's only ever going to be one caller, and it's the transaction
rolling mechanism.  I wouldn't put the memalloc_flags_move in
xfs_defer_move because userspace transactions don't have t_pflags
because NOFS is meaningless there.

--D
