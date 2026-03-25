Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65395314D07
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 05:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774417460; cv=none; b=SiSjgEJEVfL0DhcVbbOf2+g0CYYy+ClrX04l6w5pG4qWck0qClrCn17xe0PrLTN9fEq0NeawcIr/c/yMNC5CQXZd11oip4Lq+CqvNDzbBTwKZHHZ4BEaNxS6h3J34SoN+y3PDD7GolGiEfUzQaSlxQKxUPu7smrtxzNvD2QItfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774417460; c=relaxed/simple;
	bh=uG8KnVnekCrng941PfnP3F6s+7XoA4U0RiDUZ9Ft8aU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZmNpgyT00TJzPPM5hH9aREDLqtLnh6YyjnDDwy1NgUHao0HtXXDc/USe2fszzLBSBmGPu2hISYVW8j6vD8GUV97uyfzuFaGzsE1sWDXSuCHXwuaneYZSsBdSMXpdItrTBPRM4iEcaAyb9zPQFwatpAtoTvNcsssBo/W4DEriD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JO//LlwN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JO//LlwN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WCIkf7vRvLDkGI3yXOjS1uJDRfxIVm5oENGOAO+h03E=; b=JO//LlwNrmkwn187UikaMt+trk
	PMHMeN7Dsc5SF1H6g2akks8z+lUDUK10O92PZMZPu8HBv1xTZS4igOeQcua5aYb4ZOBFG0iqSQ0PY
	c+JC+qDr4Wr/CVZwR+4S8H9tuYEJ8rXw1A+X7yZCSCqMwvmMPRZcvnLi8LvhWStGtvHNTMWZi7Xk/
	tFHEMZLbX99Ly5b0hxHADGAz0UKbBZRKNDRp4cxoeTbZvV916tbMgBbrZfQCRHelR2qERX97iiUYX
	TUlwYvuzeOSdGiDEZZ3tKfolNWmIW2IoLuRrxF/iAf+vndtuiTNt7sPJ0t9OTU4JVwLwFuB/hoQUL
	Hc4wcDwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5H2P-00000002j8h-2Eju;
	Wed, 25 Mar 2026 05:44:17 +0000
Date: Tue, 24 Mar 2026 22:44:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 2/3] xfs: don't expose stale pointers to callers of
 xlog_recover_iget
Message-ID: <acN2MRBjSmN3mRSj@infradead.org>
References: <20260323210157.GM6223@frogsfrogsfrogs>
 <20260323210351.GN6223@frogsfrogsfrogs>
 <acIsjx8FMnv1tDVY@infradead.org>
 <20260324171513.GQ6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324171513.GQ6223@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 24, 2026 at 10:15:13AM -0700, Darrick J. Wong wrote:
> > I still think this is silly.  
> > 
> > > Cc: <stable@vger.kernel.org> # v5.15
> > > Fixes: 4bc619833f738f ("xfs: refactor xfs_iget calls from log intent recovery")
> > 
> > .. and certainly does not actually fix anything.
> 
> <nod> I'll let cem decide if he wants to trade more stack usage for
> removing theoretical bugs via this patch, then.

I don't think it even removes a theoretical bug.  It papers over callers
not understanding the calling convention assuming they also have a NULL
check which they'd otherwise don't need.  That's the kind of cargo cult
programming that makes it really hard to reason about the rules.

