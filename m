Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C690C3368B1;
	Mon, 13 Jul 2026 23:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783983862; cv=none; b=StlctkPN+AiDXW7tzYsSu/y85Np1XmRvMRjmG8/qMweZGp5qPU1OEzrKt87522KAkiUXJDBQ1vNPNFboj8u1SOxGRFKNhb9GBFL0BCTxgYUaK2o73itZ0LRxCygYL5TOU7CvjDDqCO1bT3I5+zNNjSIRNe+w/CMnJZHWUTwgzEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783983862; c=relaxed/simple;
	bh=Q+MQ6n0HtAyWSJWdLcS/g7W/x11B97KxTUTRVbGmsfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wkm9e28r95kDGHx8JYlGOTmgWw0C4W++vEFtFKcEihB95PAFYzM/au/P5w2G4fya9j658k1b4LlDcIkFeApVw2q0qTNESFLTfnvhjcZe6hCdB3Xg7GSDvRiHsbGrW1Jzvx6CN1b4O01QkpJWeoqhlfIPMMx2i9OQv1df7Cq5fHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kflj9geb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kflj9geb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D5411F000E9;
	Mon, 13 Jul 2026 23:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783983861;
	bh=wVp8ZBt+RLbtyaMAlSf35ge6frqAuwoaCc6YVJfVBC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kflj9gebiRTYDdzdu18y64PSsi7yDk/9xQzlGi9b9sy8ha/tBm+r7xBK3wZIXBKVr
	 r3An+a23HdLOQeMADMy2xTwDaZbNrjhl/W1mcq5dEJo9MZQKPwSkk6F7oD6NMaDIht
	 3GLYNv/qVrWn0VQfDqP4Gh8JyWdHYNam04+ed7580aj6zTyTBnTlEKhoyXSvowJ111
	 rmsYC2ZOpHsSakUr0G9wwu2xSeyOeJ10ubBPDRXCx+49I0Ma8fk7fQzGrJmZi91AnK
	 1tmzHgSljNflU5WD+t7mDpFX+5vxyOK1OpN248+zF+2ybbEbQw5jMEmgOJYJ3quRcm
	 dHSQcBAZ7hURQ==
Date: Mon, 13 Jul 2026 16:04:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Zhou, Yun" <yun.zhou@windriver.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260713230420.GN7195@frogsfrogsfrogs>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
 <alToBmAN_HyeXth9@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alToBmAN_HyeXth9@infradead.org>

On Mon, Jul 13, 2026 at 06:28:38AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
> > 
> > 
> > On 7/13/26 17:09, Christoph Hellwig wrote:
> > > 
> > > On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> > > > 
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index 7bfbd9f6f0df..1b36cf12d4e3 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> > > > @@ -1029,6 +1029,15 @@ xfs_trans_roll(
> > > >         * duplicate transaction that gets returned.
> > > >         */
> > > >        error = __xfs_trans_commit(tp, true);
> > > > +
> > > > +     tp = *tpp;
> > > > +     /*
> > > > +      * __xfs_trans_commit cleared the NOFS flag by calling into
> > > > +      * xfs_trans_free.  Set it again here before doing memory
> > > > +      * allocations.
> > > > +      */
> > > > +     xfs_trans_set_context(tp);
> > > 
> > > The tp assignment above now returns the incorrect transaction when
> > > __xfs_trans_commit fails, so you can't do this.
> > > 
> > > Otherwise yes, this call should move up.  I don't really see how
> > > it fixes the syzbot report, though.
> > > 
> > 
> > Thank you very much for your reply. The tp here is a local variable only
> > used for convenience within the function. The caller always gets the new
> > transaction through *tpp, which was set by xfs_trans_dup() before the commit
> > call. Moving tp = *tpp before the error check doesn't change what the caller
> > sees - *tpp still points to the new (dup'd) transaction regardless.
> 
> Ah, right.  Tis should be fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Why not move tp_pflags to the new transaction in xfs_trans_dup like we
do for the deferred item list:

	/* move deferred ops over to the new tp */
	xfs_defer_move(ntp, tp);

	ntp->t_pflags = tp->t_pflags;
	tp->t_pflags = 0;

--D
