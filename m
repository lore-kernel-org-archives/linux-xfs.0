Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C54836F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 02:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709087506; cv=none; b=tDwFLihaHd4bUCX+9HylzA58NvZjqdgwH+sHsPJhR+hfcqaE1B7cyyHni4uRE4e6LsBWoVoYd8KhYyZAViKNDN8ZigXIJ1SN+thSA9V85tOFqWOaOa/Hg82rLEvKTbZcyrRVRBz7SyyU0tTr4ghqxfaRd+jJZXh07V7BWz1Tn9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709087506; c=relaxed/simple;
	bh=y+kj0QFotw6g97v+87jOUvIg1mZqT48YhVneUBpl96U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsnBAahjKtq0rtGtFtg5/GjZ7YT4jYYlQmhmIeWWZFD+CaXkt8WV9THxnfq95gvn3pPshFJ8qLRjMvtSu4pHDyr6UmMruNsZd0tXuWBuX61nsqDLPZSH/wKzU2OYxlCrnWrp/xCrxWTZjAg0tmPCCtYPw5WlJMdGv9TJ61K4TXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmMhX2AN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmMhX2AN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C5CC43390;
	Wed, 28 Feb 2024 02:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709087506;
	bh=y+kj0QFotw6g97v+87jOUvIg1mZqT48YhVneUBpl96U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KmMhX2ANtgZ7Ql7lAChUYvRY/eoN/oBk27Aql9tkiY5AitcvzHWT66JjwWdP6ansS
	 52+qze11odIGZ0LuTWhnrI6DQgw/qMNPfnZ+eE6xdqh7kdT5HUBZSubEqF6Vmt/IT3
	 FcHjUlL+xHv0ai9jkjjZFGIv8vfMrV99M5TBGtDecWN+p/K4lI7xbffpD+Nr7dvEda
	 sjXe8Zh08HR/mMx5S2GRzJpMmASnS3XNT2pyf82O2HwA1Jk10+OSj901ajyhd8oBVi
	 bLdl0og6B2o7tTzxfu/RMh+pLIh1VGK8TcEtVLaqe6MMYxbJOLTJEWUfhvYff+Llpj
	 nHgrp3g0r+lsA==
Date: Tue, 27 Feb 2024 18:31:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH v2 2/2] xfs: use kvfree() in xlog_cil_free_logvec()
Message-ID: <20240228023145.GA1927156@frogsfrogsfrogs>
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-3-david@fromorbit.com>
 <20240227004621.GN616564@frogsfrogsfrogs>
 <Zd1QhmIB/SzPDoDf@dread.disaster.area>
 <20240227042537.GQ616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227042537.GQ616564@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 08:25:37PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 27, 2024 at 02:01:26PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The xfs_log_vec items are allocated by xlog_kvmalloc(), and so need
> > to be freed with kvfree. This was missed when coverting from the
> > kmem_free() API.
> > 
> > Reported-by: Chandan Babu R <chandanbabu@kernel.org>
> > Fixes: 49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good to me, will run this one through fstestsclod overnight...
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

FWIW I didn't see any further crashes after applying this patch, so:
Tested-by: Darrick J. Wong <djwong@kernel.org>

--D

> --D
> 
> > ---
> > 
> > Version 2:
> > - also fix kfree() in xlog_cil_process_intents().
> > - checked that kvfree() is used for all lip->li_lv_shadow freeing
> >   calls.
> > 
> >  fs/xfs/xfs_log_cil.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index f15735d0296a..4d52854bcb29 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -877,7 +877,7 @@ xlog_cil_free_logvec(
> >  	while (!list_empty(lv_chain)) {
> >  		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
> >  		list_del_init(&lv->lv_list);
> > -		kfree(lv);
> > +		kvfree(lv);
> >  	}
> >  }
> >  
> > @@ -1717,7 +1717,7 @@ xlog_cil_process_intents(
> >  		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
> >  		trace_xfs_cil_whiteout_mark(ilip);
> >  		len += ilip->li_lv->lv_bytes;
> > -		kfree(ilip->li_lv);
> > +		kvfree(ilip->li_lv);
> >  		ilip->li_lv = NULL;
> >  
> >  		xfs_trans_del_item(lip);
> > 
> 
