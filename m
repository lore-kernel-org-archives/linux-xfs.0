Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369B13BAC3
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 03:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712807381; cv=none; b=JqO+olRwEmFOMiHQgWdpji1OwxdLwNek43U4NPw4e3rYGsGKG/VX+PE51yf//MAefaPIqILnnWJb28N1jjkKjN5OLehsHrdwx7arSdy2BhzjEwLd7ef0vL3CAgOaKoHc8uDamzH1GG5kb9uzWjs2hjS1AzTakaTw1FOqI4UBPdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712807381; c=relaxed/simple;
	bh=4ehmx0nHuN6tzFjefs3xzyVKodhxD/McAg9Z9Iz6S5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SnD6JRlN8MrPq43Kv2jxBE26ydMsBq4EvZh3lnqgmqSDrXlYwbhWStSnt9NgUaTkss+2mgzy3EPkYt8olg6n/DQlFqcdmfG6scIYTKQgX1VE7ijAYvyCq642LKeVJ0TpODPRlHrKs8n0UNwPcfclOxRulOJ8Nvl0xKkQ+gpomXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gdwsFSDb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gdwsFSDb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jHPnKnVSM0Z9f6m98A6cf5ruoVNckyf0bx7k2Gu1WN4=; b=gdwsFSDbV6+volV/ZO4BMLdu+U
	5d8ccyo/cloI+vih0syhLyy8EpJIQmPBe18FMayZD5IGZkQPepTevD5r9kOtI9esbxfB9nisEJ0qZ
	4KjIKTgUhGp3QDM0E+LzAm6lq5BdEMEJOeeI1hPWWPYCWnd8m44RuBWtJcOVRdI+Jnq7O2n2hjj19
	QcIXms6X5E6tXW4KYvm5vcWuq2Ky8FQm5KnJT69ikXPnvue88hOfIAOQFLAso6P6G8QE9wqoYAjiZ
	i0Y61ivJsF9/Vn5B8GfqY5OfxBZVq4fw1AN3WdyK/VU4pbv9kKPRQA8OeCtGwyot13NGd+dhYTWX4
	9/gfalYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rulRT-0000000ADaO-1cC9;
	Thu, 11 Apr 2024 03:49:39 +0000
Date: Wed, 10 Apr 2024 20:49:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <Zhdd01E-ZNYxAnHO@infradead.org>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
 <20240411011502.GR6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411011502.GR6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 06:15:02PM -0700, Darrick J. Wong wrote:
> > This looks a little weird to me.  Can't we simply use XFS_IGET_DONTCACHE
> > at iget time and then clear I_DONTCACHE here if we want to keep the
> > inode around?
> 
> Not anymore, because other threads can mess around with the dontcache
> state (yay fsdax access path changes!!) while we are scrubbing the
> inode.

You mean xfs_ioctl_setattr_prepare_dax?  Oh lovely, a completely
undocumented d_mark_dontcache in a completely non-obvious place.

It sems to have appeared in
commit e4f9ba20d3b8c2b86ec71f326882e1a3c4e47953
Author: Ira Weiny <ira.weiny@intel.com>
Date:   Thu Apr 30 07:41:38 2020 -0700

    fs/xfs: Update xfs_ioctl_setattr_dax_invalidate()

without any explanation either.  And I can't see any reason why
we'd prevent inodes and dentries to be cached after DAX mode
switches to start with.  I can only guess, maybe the commit thinks
d_mark_dontcache is about data caching?

> 
> >                Given that we only set the uncached flag from
> > XFS_IGET_DONTCACHE on a cache miss, we won't have set
> > DCACHE_DONTCACHE anywhere (and don't really care about the dentries to
> > start with).
> > 
> > But why do we care about keeping the inodes with errors in memory
> > here, but not elsewhere?
> 
> We actually, do, but it's not obvious...
> 
> > Maybe this can be explained in an expanded comment.
> 
> ...because this bit here is basically the same as xchk_irele, but we
> don't have a xfs_scrub object to pass in, so it's opencoded.  I could
> pull this logic out into:

Eww, I hadn't seen xchk_irele before.  To me it looks like
I_DONTCACHE/d_mark_dontcache is really the wrong vehicle here.

I'd instead have a XFS_IGET_SCRUB, which will set an XFS_ISCRUB or
whatever flag on a cache miss.  Any cache hit without XFS_IGET_SCRUB
will clear it.

->drop_inode then always returns true for XFS_ISCRUB inodes unless
in a transaction.  Talking about the in transaction part - why do
we drop inodes in the transaction in scrub, but not elsewhere?

