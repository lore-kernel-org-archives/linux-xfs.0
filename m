Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF6A331A53;
	Tue, 14 Jul 2026 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051731; cv=none; b=NhDgxhzfAHne+BRS5XLM4uW7bX5iic0gGeLC/91epUkXcrrtAlLwRDAUebyx4uvD4whruG+0A1gkS528ppwzApQJtFRxos1jV5kxjjhUubRRP/D1hDktsroEOxJHP4i4J/HXwboNX7J+MeeWpE+HVjcduOiab1QCoMczbj7LHTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051731; c=relaxed/simple;
	bh=hqhZ5fbL0jiyxiACcblyfKNhfoLlN2Hrs48VMQ1Q+/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2WCotjRX4WeURQH1+9WrvOE0a35Wd3FCEsIapmBBjrFmEuo+/pF6hj6BEGPBSeCAob9+9LdudpCOh9vNMzh6ipoS5exjlIiC7T+525JDCK/nEGXr9aLQp3mFNycpSJ3Ez1z2TXfaD23W3RxeIUZkbTtjPwrddP7hIj6j65C2ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQH+uGuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQH+uGuf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D8CDB1F000E9;
	Tue, 14 Jul 2026 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784051728;
	bh=kqPa6Awexo1sZ9NAhkSiBlt6klZOADUjfwrP4NV/fLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GQH+uGuf7cG6jloVA22oC1BzvBnCdLn6AaVkT11e9Pl4dlrZGqhSiKh/vPEmjkhUD
	 fF/zQxGSmJIehfWOBVrypqs9fxhp+3sTIWs8usgUkzwuvgPtVyGyiPtP4Hydrbq6OB
	 peDtP0/8RQIj1W4l1b7eHIe/XwxTNxh2/LBPllthqzyZHWcI1GfP6HPc4IZBwGWc5v
	 708AyWb9OC4FTGIlsNXG1VjviLyWmvxf7+P+bISXLDRNPGX8h5NbI3IHfNXjDfWet0
	 tpPgF0TWMHuCOj8/oxx7kqkTGJXEK8n7ykLKBviqU9GHH0HzdA4glcbugdTEuJlBmP
	 +vg20gZ1ZRRLg==
Date: Tue, 14 Jul 2026 10:55:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260714175528.GG7380@frogsfrogsfrogs>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
 <alToBmAN_HyeXth9@infradead.org>
 <20260713230420.GN7195@frogsfrogsfrogs>
 <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>

[add linux-mm since we're talking about memalloc_nofs_save]

On Tue, Jul 14, 2026 at 10:15:53AM +0800, Zhou, Yun wrote:
> 
> 
> On 7/14/26 07:04, Darrick J. Wong wrote:
> > CAUTION: This email comes from a non Wind River email account!
> > Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > On Mon, Jul 13, 2026 at 06:28:38AM -0700, Christoph Hellwig wrote:
> > > On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
> > > > 
> > > > 
> > > > On 7/13/26 17:09, Christoph Hellwig wrote:
> > > > > 
> > > > > On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > > index 7bfbd9f6f0df..1b36cf12d4e3 100644
> > > > > > --- a/fs/xfs/xfs_trans.c
> > > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > > @@ -1029,6 +1029,15 @@ xfs_trans_roll(
> > > > > >          * duplicate transaction that gets returned.
> > > > > >          */
> > > > > >         error = __xfs_trans_commit(tp, true);
> > > > > > +
> > > > > > +     tp = *tpp;
> > > > > > +     /*
> > > > > > +      * __xfs_trans_commit cleared the NOFS flag by calling into
> > > > > > +      * xfs_trans_free.  Set it again here before doing memory
> > > > > > +      * allocations.
> > > > > > +      */
> > > > > > +     xfs_trans_set_context(tp);
> > > > > 
> > > > > The tp assignment above now returns the incorrect transaction when
> > > > > __xfs_trans_commit fails, so you can't do this.
> > > > > 
> > > > > Otherwise yes, this call should move up.  I don't really see how
> > > > > it fixes the syzbot report, though.
> > > > > 
> > > > 
> > > > Thank you very much for your reply. The tp here is a local variable only
> > > > used for convenience within the function. The caller always gets the new
> > > > transaction through *tpp, which was set by xfs_trans_dup() before the commit
> > > > call. Moving tp = *tpp before the error check doesn't change what the caller
> > > > sees - *tpp still points to the new (dup'd) transaction regardless.
> > > 
> > > Ah, right.  Tis should be fine:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Why not move tp_pflags to the new transaction in xfs_trans_dup like we
> > do for the deferred item list:
> > 
> >          /* move deferred ops over to the new tp */
> >          xfs_defer_move(ntp, tp);
> > 
> >          ntp->t_pflags = tp->t_pflags;
> >          tp->t_pflags = 0;
> > 
> 
> That's what the old xfs_trans_switch_context() did before a1ca658d649a
> removed it. The problem is that setting tp->t_pflags = 0 means
> xfs_trans_free() calls memalloc_nofs_restore(0), which relies on that being
> a  no-op — an mm implementation detail. A fresh memalloc_nofs_save() on the
> new tp keeps the save/restore pairing correct unconditionally.

So add a new helper.

/**
 * memalloc_flags_take - move an implicit __GFP_MEMALLOC scope from one
 * tracking structure to another.
 */
static inline unsigned int
memalloc_flags_take(unsigned int *old_flags)
{
	unsigned int ret = *old_flags;

	*old_flags = 0;
	return ret;
}

and then:

	/* move deferred ops over to the new tp */
	xfs_defer_move(ntp, tp);

	ntp->t_pflags = memalloc_flags_take(&tp->t_pflags);

--D

> BR,
> Yun
> 
