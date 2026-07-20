Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD81438C421;
	Mon, 20 Jul 2026 08:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784536524; cv=none; b=tSzEIc92ZH3K1MCJRNqNKGACajOhzPT11t9oUilvHfK4JoeTsdLvZ1JrUlSnTRQsHdOhEzDIn3VhrXX+OMAzeZW0P80MfXoohYproB3Br3C3TkJ+mHQbKpnQ6mL/cY9ZWXOH1UPOvDZHrsCzBlfLt/kaxWfTIG3afPETgoAWccE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784536524; c=relaxed/simple;
	bh=29LjuKshS20IBMVfH9L7yid9efnvYxSTAwrjqCty46o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOGUI9Ep/n1r2AFBpCXB3b4tDY9esK9px0HILGuQmCFeLZoqKPUJ+YIrAT+S7NzUlNGWTUrFH+KrsUjNLYHvy9xMXFk4gmd6X6FBYIeHqlYusIvjAK+Lm4qMAvkpsBQ6Xh8ogd4avy/bdlQlhHRfkgV2U1IcRnTrgcJ5oSblaNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e+q9JmxU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e+q9JmxU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TbS4gQrpolnGHWdJuXWES4DEBaqfRl4XiEpbHfCEt4U=; b=e+q9JmxUXPNwoNu2tldYtnEx47
	0dZkufLBOswGMX5sP6HhQZKGuPmK1ygBz4P1TJDNHX4SiVBUO/X6FTsbduB3TUSbplx7AQlP8hl6s
	xRG8lmroe2eX45oF3mqeDyGKepZ/o6NhW+dMhlD+n98D4n4TLW+g41NIqthunUSkyKxbKKx4uF3bJ
	9JQZ1gjcnzZJ3G59gpHIwf5Czant3YmRrPIzb6FFhXtF+eLUY/JB/Lj5kooTle3BbdltcSfQDz25x
	LJdWBF04CxQ/Mj/69seEtXkuG3ZP0pyDPXDiK4RcgZiXeROXgbhd9Uq3lQEC3GQygDlugDAOMXTgn
	EUx9simA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wljT8-00000006D6W-0N84;
	Mon, 20 Jul 2026 08:35:22 +0000
Date: Mon, 20 Jul 2026 01:35:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] xfs: fix nofs context corruption in
 xfs_btree_split_worker
Message-ID: <al3dypUNu1VNZErK@infradead.org>
References: <20260720050522.3101824-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720050522.3101824-1-yun.zhou@windriver.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 20, 2026 at 01:05:22PM +0800, Yun Zhou wrote:
>  	current_set_flags_nested(&pflags, new_pflags);
> -	xfs_trans_set_context(args->cur->bc_tp);
> +	nofs_flags = memalloc_nofs_save();

Note that the above is the only user of current_set_flags_nested.

>  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>  					 args->key, args->curp, args->stat);
>  
> -	xfs_trans_clear_context(args->cur->bc_tp);
> +	memalloc_nofs_restore(nofs_flags);
>  	current_restore_flags_nested(&pflags, new_pflags);

and this is the only caller of current_restore_flags_nested.  Both
of which modify the task flags just like memalloc_nofs_save.

I think we'd be much better of just killing all these silly helpers
and do direct current->flags manipulations, which will both clarify
this code and fix the bug it caused.

Similarly xfs_trans_set_context / xfs_trans_set_context need to go
away as they were a part of this problem.  And to make this coherent,
it should be combined with your other flags series.

