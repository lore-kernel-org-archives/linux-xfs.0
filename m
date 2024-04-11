Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716A813B7AA
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 05:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712811745; cv=none; b=s10Z6fGOBul02RwfU/Rn4KNPoBZppkzYyrNcu6SglNJxxBGfoQYAqaXmKvioZCwn6mrW3yqJDcTchNJb2z9y3PCftrX6/Ndrv6/+0vCHjYIbKrmuww91KR/+PWPHUigRMJoAl4H8Bz2jiltsY2Z2aQauX1XdY/jPgMndK8/xoAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712811745; c=relaxed/simple;
	bh=g+miYvhvaAjw6jpQ8tCJ1r7CeFCAV1CoKsGLrpXTNTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfDurT/91Hdd4TgiorIx92LzDMVw5XEY7bWGf/mXy8LqIASIWwaXS2SS+F5hyA+vNAmOk+vOn3zhvtsC0Fs1pZRHppI7wreP3MKcv83z2vEkQSioNsOt+5F2WwYUsJsccnLjYdGLHJ6CI+6QX76casSiVRot7RTG6TuWnAUmopU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WEgDBRCg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WEgDBRCg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Dekdbctv7fR6sPL3RXCdoRbseNe4J138GzCB9U3Bfxw=; b=WEgDBRCgU484jetoKquJAowwof
	Z5XHmBYgMoexIEas11zPd040HIbpmZKom91YWxGNPvKwXaR3CxJw/fe6bD487dGNOeFu11mEU7wc6
	Hsjf61Vm6peyRmCCsD1i95wGHkHsU9bDCCm66YaVXEc+mk1ZLyet0hPw5m/YGjDLTW2iLT5rhFPEj
	DrOOMeRH21W3Vw9EUCEidPHK7m9ClzX1VwdLp+BH88Q+0LWasnWqJy2toLnQsZhop0M/844OGdusP
	1HJ1v5HiKqWdP1rTp8k+Q1uQ+TWikoC2isgUkv7NJEVBDPj5H/mxZp+kjt2+EZ//v1/nYBAZCVtMy
	Qvp4R8VA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rumZr-0000000AN4G-3QFM;
	Thu, 11 Apr 2024 05:02:23 +0000
Date: Wed, 10 Apr 2024 22:02:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <Zhdu3zJTO3d9gHLO@infradead.org>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
 <20240411011502.GR6390@frogsfrogsfrogs>
 <Zhdd01E-ZNYxAnHO@infradead.org>
 <20240411044132.GW6390@frogsfrogsfrogs>
 <ZhdsmeHfGx7WTnNn@infradead.org>
 <20240411045645.GX6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411045645.GX6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 09:56:45PM -0700, Darrick J. Wong wrote:
> > Well, someone needs to own it, it's just not just ext4 but could us.
> 
> Er... I don't understand this?        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If we set current->journal and take a page faul we could not just
recurse into ext4 but into any fs including XFS.  Any everyone
blindly dereferences is as only one fs can own it.

> > > Alloc transaction -> lock rmap btree for repairs -> iscan filesystem to
> > > find rmap records -> iget/irele.
> > 
> > So this is just the magic empty transaction?
> 
> No, that's the fully featured repair transaction that will eventually be
> used to write/commit the new rmap tree.

That seems a bit dangerous to me.  I guess we rely on the code inside
the transaction context to never race with unmount as lack of SB_ACTIVE
will make the VFS ignore the dontcache flag.

