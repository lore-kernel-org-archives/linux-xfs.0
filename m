Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B613A8F5E
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 07:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736408112; cv=none; b=WYCWkxOSO1QjyA7Lf6AVqRg9AsAMu1QNruOBh4fk3cETHMgD/pqIvhE80SJN2ByWKphxcBR2QZ435C3EkBHA0KCmtnyUIPc+L5bDrBXVtBHB+9Xmq8wdlBgI5cKMecFbjwugjTJAe0JML6lzMrhYDMK+A2lYDWlUM9besMvkEzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736408112; c=relaxed/simple;
	bh=e0NFOjJ5wXR9PaNpuBCIi3YOpJUX7DR/E3kUPuItWHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGOBwMf4B0md/NtofxyPj941CZG1VkjaNCIDbG3jCBWrOQWkDvSGuyTgOTJNI3AWg1J8k6zuZzXbLcTTxmlne1nGOauXIhDJralgFHMzBmC0CwlvZZWGTQ72cgE+r9VWfqO0R20ZlYhHoedqG7v1rhEdBotsNZYKZMFmAMa0Y/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sjsS3NdH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sjsS3NdH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bpbP8LddktbORolKAOpTBhkauzXxjBY+ChLCNpGWzGg=; b=sjsS3NdH9YJkDICaA165OSNNy/
	JaVWsxmBEWNlW+T73nDnn1YPVjuS8Z8wkBtrA6koOokIUoSvrunCJdYNBWoPsFSjYhnqLmg01fLYp
	78BJIO5UJUjCTJp0WtCbl2RisFPbQixIXpdy9K5TwQZ317/NNI2LnbMBVLjMdQAYSzvr4h1/UyIAz
	BDXBq4pF9InSQM4YGqVFa/gdox9IOxih/onoprgYgWPdJ5uwPwxDl3dUJiSoDQv3hP1yRUEH4LXsV
	VOj/N266AfjUB+7aMDzbtZVG/z32ltJG0kaa9Y/u+hsak07wN9ni7SrUOt8E7cUihlT3AnLxgvlUh
	Fl8cHWYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tVn4Q-0000000B3xv-0y9V;
	Thu, 09 Jan 2025 07:35:10 +0000
Date: Wed, 8 Jan 2025 23:35:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: lock dquot buffer before detaching dquot from
 b_li_list
Message-ID: <Z398LpeqlDKePkEr@infradead.org>
References: <20250109005402.GH1387004@frogsfrogsfrogs>
 <Z39nxRk8AdTR3BCR@infradead.org>
 <20250109071718.GO1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109071718.GO1306365@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 08, 2025 at 11:17:18PM -0800, Darrick J. Wong wrote:
> > I did look a bit over how the inode items handles the equivalent
> > functionality, and AFAICS there is no direct one.  xfs_qm_dquot_isolate
> > is for shrinking the dquot LRU, which is handled through the VFS
> > for inodes.  xfs_qm_dqpurge tries to write back dirty dquots, which
> > I thought is dead code as all dirty dquots should have log
> > items and thus be handled through the log and AIL, but it seems like
> > xfs_qm_quotacheck_dqadjust dirties dquots without logging them.
> > So we'll need that for now, but I wonder if we should convert this
> > last bit of meatada to also go through our normal log mechanism
> > eventually?
> 
> What if we replace it with the one in scrub/repair_quotacheck.c? :)

Yes, that's a much better implementation.  It will probably be a while
until we can get everyone convinced to actually build the online repair
code into their kernels, though and I'm not sure if it's feasibable to
have a subset just for quotacheck.

