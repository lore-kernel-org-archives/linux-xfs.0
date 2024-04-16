Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ABA136E3C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293257; cv=none; b=dmuYZLzfQ649mEcisymdWTsFSyDwhGlEC9QV0U8D4HJvvPpFiukA+RukRuBYsECsJX711wESczTQs1bAvY0Pgw1mzora50Ic6L3Tdr17acVboDQoL7P+WV+601hGnhM0E+Yjw77uz8cMKHZHQFsxjIqdiD8gZ65QqtW7eLAi3Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293257; c=relaxed/simple;
	bh=cEUEjv1rIDSDmVk1O7hhe9a8xYxpPqarKURCOaYF+Fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXZniQlVTXIQqpZRqpZeXdPWUepSKPc0VVJjuaavdAROZIVN3gt3DwQO8Ec7zWo32agkbq4jSyaoUhQwU/R/rMFU+zGYUiO1d50U1pYPczXtu0be85M3ypSuefLghAKTB+vIMWIZEeKEjfRdAT31xgWxbUhxCanj9/Hovww9yzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IGe/fyP0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IGe/fyP0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6m4p+l1+jUxontibYfjw0pC0DSx8G4zXxE3KXqVAs7g=; b=IGe/fyP0l3QycCArMTyECuCpI9
	QCWEN422htMEuRayukyqkCncvHaUia8X31vZO7R43Rzakvzp/FooIJ5YulGonXz+J8dqq55cevTmN
	v185lxKDQDVSca27XbDbqlTsTNBU1uFu7Cl/8mBeBLqf9EwbA6tjdMrrze0ENzCo+DS9p/TvPO6n2
	j2uFKi2uC1MfieOTRm4E6tS6TfCNqHmG/YvMGlEzh4CnSlaue18fnMpVEnFe9QihWn4skVkQBWRqG
	U3RyRTzzKF6WPxRyJfb1vB6WV3aVQul9ihQVxHBgNJfuWYg7gFIF8mDDan/ZvH/KWUgQDqId67Ez8
	/YyX2LNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwnqB-0000000DOTe-38N2;
	Tue, 16 Apr 2024 18:47:35 +0000
Date: Tue, 16 Apr 2024 11:47:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 090/111] libxfs: partition memfd files to avoid using too
 many fds
Message-ID: <Zh7Hx2VFFn-M1uuX@infradead.org>
References: <171322882240.211103.3776766269442402814.stgit@frogsfrogsfrogs>
 <171322883514.211103.15800307559901643828.stgit@frogsfrogsfrogs>
 <Zh4EpDiu1Egt-4ii@infradead.org>
 <20240416154932.GH11948@frogsfrogsfrogs>
 <Zh6nVRlJXXN87tho@infradead.org>
 <20240416165741.GP11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416165741.GP11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 09:57:41AM -0700, Darrick J. Wong wrote:
> cloud-init is a piece of software that cloud/container vendors install
> in the rootfs that will, upon the first startup, growfs the minified
> root image to cover the entire root disk.  This is why we keep getting
> complaints about 1TB filesystems with 1,000 AGs in them.  It's "fine"
> for ext4 because of the 128M groups, and completely terrible for XFS.
> 
> (More generally it will also configure networking, accounts, and the
> mandatory vendor agents and whatnot.)

Yes, I know cloud-init, but between the misspelling and not directly
obvious relevance I didn't get the reference.

