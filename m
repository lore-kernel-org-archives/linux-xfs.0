Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618A67E9;
	Tue, 26 Nov 2024 05:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732598049; cv=none; b=IG/wkcVdUf5l3jGID+8S1G6vTr4N2YVdCIj9NhjeIkodpe5TwJcpk0TMjiQWDbQXnVJZhKTLRPXRD8xmz999SzFYKR0vO5yAsGpCapv2Wm/aQvNA/Udezh7bT04n1tBFl9zp8mN91JR7vpTBFKqnV1Jy372FHEjr7Ek+K66AOGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732598049; c=relaxed/simple;
	bh=3Ktpy2W8n/6hMuwXJjn0ModHoQ5AjORyR4Kol/DZFpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBWMGyOOhkimZxPyuFSeuu6e491/NbY9Db3nw/SYVvNZ/ZQ9QZpjMJEhpv0MzBP8KxJskxvieVSuC9sg7hGpQ06gILUjt1Olkp4JNwOZm6DcoXfEzT7s8KKzqcFkL7FTrg58j9gOMAr4eFn6IXv49v4o8bLYH2z3qf8/A2/RRV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=frdS5mgt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="frdS5mgt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=woMkcs0jhmMIBpRBuyVxUn1/pog0E518gOYUYyVWVj8=; b=frdS5mgt646jPzYgfIkObGLA/r
	W9n/i1MSqZVGnzX33spwsa1SVy2apJR/lMHWbQgk3kNGYC/RqWgx+N8/Np4w2b/Gma6EpEKpHbrhe
	nDE4LEA7cOa4KrkNM+uq2H/2BZFmEKlvq31vh/c34HvRMJaqx8/gs3iy//DzTakDWrxlsXMumxcfj
	dfu0arqSj5/FsazxDJMGWwA5eQOpqOShE0raLTnezvayv+I4OoIlG83vJxJa+lzWveFIAlH2f/OJL
	SPK0V4wS3nueZPYn+hgnj4ELmbawUqj9TIw3TUJJytgHDzZW8lICqx7a5jQAAPdBx1joFanbOFrml
	edWQPoXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFntn-00000009env-3oo2;
	Tue, 26 Nov 2024 05:14:07 +0000
Date: Mon, 25 Nov 2024 21:14:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/21] xfs: don't lose solo superblock counter update
 transactions
Message-ID: <Z0VZH45ZY44o4Bjq@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398074.4032920.16314140758572044747.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398074.4032920.16314140758572044747.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 05:28:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Superblock counter updates are tracked via per-transaction counters in
> the xfs_trans object.  These changes are then turned into dirty log
> items in xfs_trans_apply_sb_deltas just prior to commiting the log items
> to the CIL.
> 
> However, updating the per-transaction counter deltas do not cause
> XFS_TRANS_DIRTY to be set on the transaction.  In other words, a pure sb
> counter update will be silently discarded if there are no other dirty
> log items attached to the transaction.
> 
> This is currently not the case anywhere in the filesystem because sb
> counter updates always dirty at least one other metadata item, but let's
> not leave a logic bomb.

xfs_trans_mod_sb is the only place that sets XFS_TRANS_SB_DIRTY, and
always forces XFS_TRANS_DIRTY.  So this seems kinda intentional, even
if this new version is much cleaner.  So the change looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I don't think the Fixes tag is really warranted.

