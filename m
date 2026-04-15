Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AD0352C34;
	Wed, 15 Apr 2026 07:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776237974; cv=none; b=M9bXolcA0UGwKeB0VZNQy4PEDqA7KjUjkodn+XHAjP4p0gJZSDsSSuRB0gcJrh7BIKtShh22hoao245hyfkklzfvqMRChXVjUbP/D1DgUa9H7RQr5MHq7ctJrbY9o11TOzbOvxMwbVAf0PhKZsBjFI2EAmeJEZkjqWmnaRKx86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776237974; c=relaxed/simple;
	bh=6lZpJoHKIJ6/6oJypjg4r2sjqkn0d0liLRXNab4eXvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmKtYkL8bO9neCTcvaNXlXn8RU/whH4T5swad3innp1P72JWSg0REafyaFUuES3AewmwOTBdx1W5aJjpTsSGZPZhyJjG49zmZ5slriykaUG45xzEZ69/5xD+engkC7QcGS/1i7Cd7K2rqdZN3wdlhpuxENlQfXAfczoKvEtx7N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zLo1Si75; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zLo1Si75"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oZ8fyoJAm6eOI2ri1NwiFXMTmjJFb8NFde3g4qAmHkc=; b=zLo1Si756Zk7pWZ6NU5zrbgJmN
	hPVmzuLGC3Fel+/jfB4v0qlKCvtxGYgCLWBYfnMdgZoNzpMBCFgHHn3Fqd6/6O4pM9ujDqUHqEKa9
	+EQA5rHdqI4Rp2aogB6ZgQMJkk3M+uF04ELolRCPUhFvMSFoeamzuv8pnL8TNAw7cLjE+DftJkBHw
	F1HegUQHBAfETyCFZqTJ7IUiVUBAHXEG4ZUnwPS7T52Df932BLnmMGZOW0elF3uLIkaJxIrc60wMH
	TyI3p/hRmqnKwxNhlBH2bFWj18mb5I+jXmXHdXsVms8rEzB93ATpwJfprUhvw0ckKNMC765kcE4Cv
	ZaIkPraw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCudX-00000000jJy-3kgh;
	Wed, 15 Apr 2026 07:26:11 +0000
Date: Wed, 15 Apr 2026 00:26:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: Re: [PATCH] xfs: start inodegc after quota initialization
Message-ID: <ad89k-qafk3jsx35@infradead.org>
References: <20260413004925.84518-1-pedrodemargomes@gmail.com>
 <20260413180940.GO1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413180940.GO1048989@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 13, 2026 at 11:09:40AM -0700, Darrick J. Wong wrote:
> > index ef1ea8a1238c..d6f75ab41337 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1057,7 +1057,6 @@ xfs_mountfs(
> >  		xfs_clear_using_logged_xattrs(mp);
> >  
> >  	/* Enable background inode inactivation workers. */
> > -	xfs_inodegc_start(mp);
> >  	xfs_blockgc_start(mp);
> >  
> >  	if (xfs_has_metadir(mp)) {
> > @@ -1143,6 +1142,8 @@ xfs_mountfs(
> >  		}
> >  	}
> >  
> > +	xfs_inodegc_start(mp);
> 
> Why is it correct to defer inodegc until this point?  Can any code
> between line 1060 and 1145 push an inode to the inodegc mechanism?
> blockgc can unmap blocks from files, so why is it ok to leave the
> blockgc_start call where it is?

Looking at this - I think actually performing inodegc before quotas
are up sounds dangerous, as we'd miss th quota accounting.  So I
think we need to defer starting the runners after that.  But we
should support queuing up inodes before that.  blockgc has
the same issues.

