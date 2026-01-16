Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A223302CDE
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768579895; cv=none; b=hQPa4k37la5RwcG4Yv0lmB8SjK5Qlzcl2rjSQlj7O1k/1DgwJGxg+IISb57vdlUxZkThzObDuRQOHJo2wrEq4u1HLF6SlZDEdCf1iy8hr8+tk91eP1nQJ/3oR75kFPbCD3nD7li4EWf9yoJRjtk0K/9kaIS97QnrHeZCBaB/mnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768579895; c=relaxed/simple;
	bh=QMdDY6ID6R0W7k/DIV0OonCUlBlTFudVoqyhbZz4mYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZQ6iA/s+Xk0tIS493MCEU8miIw2LE6qxA69GuOlwGmrMfY7HFbq8YQmcMe8zjJ5jv6oHQFp0sRBVwJkna/MaGjUyTbkd7tXZwD247EMaucQprJiqUBKnF8nsnNebsT/eK0jYAYZJDBHCu6lKBTBJd/wCGdrssZM3FmeVGlXdyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJEvtDMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJEvtDMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89693C116C6;
	Fri, 16 Jan 2026 16:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768579894;
	bh=QMdDY6ID6R0W7k/DIV0OonCUlBlTFudVoqyhbZz4mYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJEvtDMK6JSlTAzn3rEC0y29hDtdICkGeD1newPsj2EQR1wJqOEsJ4ZiBx8WW5d1m
	 wyexuc6T6GSwmEObzpPZNF4b1DpsByviHsR3yb41u3bGMjLHwLOyybw6u0kNTAmjJ2
	 NugUThOkThjLFrjpWSPdl6/zwDmyuqnKhWNPqSg8ysa6uDGeH4wADWrOIrrn/CV4aG
	 A5LDK45WvxuQXhxLphfjPjEGi1c+j7uHYNk346ix64EJn5MTx9n1hxq5KQrcidfMw5
	 KA5vWOwy9PB/pAkJ7Xn4UaQmc4UtF/r6+6DyDc+3ZQBxYDebYNkkfRA5/YPr3Auk4c
	 3U+oVz/A5lMBg==
Date: Fri, 16 Jan 2026 08:11:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Wenwu Hou <hwenwur@gmail.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org, dchinner@redhat.com
Subject: Re: [PATCH] xfs: fix incorrect context handling in xfs_trans_roll
Message-ID: <20260116161133.GW15551@frogsfrogsfrogs>
References: <20260116103807.109738-1-hwenwur@gmail.com>
 <aWpYhpNFTfMqdh-r@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWpYhpNFTfMqdh-r@infradead.org>

On Fri, Jan 16, 2026 at 07:25:58AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 16, 2026 at 06:38:07PM +0800, Wenwu Hou wrote:
> > The memalloc_nofs_save() and memalloc_nofs_restore() calls are
> > incorrectly paired in xfs_trans_roll.
> > 
> > Call path:
> > xfs_trans_alloc()
> >     __xfs_trans_alloc()
> > 	// tp->t_pflags = memalloc_nofs_save();
> > 	xfs_trans_set_context()
> > ...
> > xfs_defer_trans_roll()
> >     xfs_trans_roll()
> >         xfs_trans_dup()
> >             // old_tp->t_pflags = 0;
> >             xfs_trans_switch_context()
> >         __xfs_trans_commit()
> >             xfs_trans_free()
> >                 // memalloc_nofs_restore(tp->t_pflags);
> >                 xfs_trans_clear_context()
> > 
> > The code passes 0 to memalloc_nofs_restore() when committing the original
> > transaction, but memalloc_nofs_restore() should always receive the
> > flags returned from the paired memalloc_nofs_save() call.
> > 
> > Before commit 3f6d5e6a468d ("mm: introduce memalloc_flags_{save,restore}"),
> > calling memalloc_nofs_restore(0) would unset the PF_MEMALLOC_NOFS flag,
> > which could cause memory allocation deadlocks[1].
> > Fortunately, after that commit, memalloc_nofs_restore(0) does nothing,
> > so this issue is currently harmless.
> > 
> > Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
> > Link: https://lore.kernel.org/linux-xfs/20251104131857.1587584-1-leo.lilong@huawei.com [1]
> > Signed-off-by: Wenwu Hou <hwenwur@gmail.com>
> > ---
> >  fs/xfs/xfs_trans.c | 3 +--
> >  fs/xfs/xfs_trans.h | 9 ---------
> >  2 files changed, 1 insertion(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 474f5a04ec63..d2ab296a52bc 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -124,8 +124,6 @@ xfs_trans_dup(
> >  	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
> >  	tp->t_rtx_res = tp->t_rtx_res_used;
> >  
> > -	xfs_trans_switch_context(tp, ntp);
> > -
> >  	/* move deferred ops over to the new tp */
> >  	xfs_defer_move(ntp, tp);
> >  
> > @@ -1043,6 +1041,7 @@ xfs_trans_roll(
> >  	 * locked be logged in the prior and the next transactions.
> >  	 */
> >  	tp = *tpp;
> > +	xfs_trans_set_context(tp);
> 
> It took me a while to understand this, but it looks correct.
> 
> Can you add a comment here like:
> 
> 	/*
> 	 * __xfs_trans_commit cleared the NOFS flag by calling into
> 	 * xfs_trans_free.  Set it again here before doing memory
> 	 * allocations.
> 	 */
> 
> I also think we'd do better without the xfs_trans_*context helpers
> in their current form, but that's a separate issue I'll look into
> myself.

Those helpers were more useful to contain things back when they also set
current->journal_info but now that's gone, I think it'd be clearer to
opencode the memalloc_nofs transitions.

Also it might be a nice cleanup if we could avoid touching the PF_ flags
at all, at least if the transaction can be rolled successfully.

--D
