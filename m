Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6247C8F40
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 04:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xOvgQB3Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BMuH8xqFB2CDw1OpF9RGd7ucmDEytYzUuXfUGCENfkA=; b=xOvgQB3QI/2oJFqt7sx7n11gHj
	B3m5IKzukRRhtmGzMD6XCDavbInwjFhTgYTV+4DRJIn3Lldn+nvI9+DnaCJTUph+iF+wEySIA3aP/
	qEEsyExdsUMLcrwwhxc4Bqm/wpnZD2Vm374ZiooPVxGBUfBEi9w4pJzUwnydeQ+oSY1jxzRIjz3fg
	GRLPiTON8XXlsF/ztFFqN/yDzZzqyvTgtVOXhiV+rbpQAFcMTKsetHbbnIATUGQ0TOHfJyBvWeXEH
	hXbScroIKp8yQZNxaLtsR4gy53IcIYtCDRwizMPN2RVxOGMqS6rluLOPG2b+SyKwCmCtb1QE7b/rP
	eVEwNQaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rN3pv-006uvu-1q;
	Tue, 09 Jan 2024 04:35:35 +0000
Date: Mon, 8 Jan 2024 20:35:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: implement live quotacheck inode scan
Message-ID: <ZZzNF26qgjnq5phe@infradead.org>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827425.1748002.12122438465318717193.stgit@frogsfrogsfrogs>
 <ZZeTrHqhROxcLKEA@infradead.org>
 <20240106011650.GK361584@frogsfrogsfrogs>
 <20240109012346.GA722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109012346.GA722975@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 08, 2024 at 05:23:46PM -0800, Darrick J. Wong wrote:
> > > > +#ifdef CONFIG_XFS_QUOTA
> > > > +void xchk_qcheck_set_corrupt(struct xfs_scrub *sc, unsigned int dqtype,
> > > > +		xfs_dqid_t id);
> > > > +#endif /* CONFIG_XFS_QUOTA */
> > > 
> > > No need for the ifdef here.
> > 
> > Fixed.
> 
> ...and reverted because I forgot to remove the #ifdef around the
> tracepoint in that function.  I tried to fix that, and got a ton of
> macro spew over ... something not being defined.  In the end, I decided
> that it was better not to waste memory on !CONFIG_XFS_QUOTA and not to
> waste time on minor things like this.

Note that I only meant the ifdef on the declaration in the header, not
for the function itself anyway, sorry.

