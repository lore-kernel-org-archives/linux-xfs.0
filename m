Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245DA3A1D2;
	Tue, 25 Nov 2025 06:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764052286; cv=none; b=WgbAIz8uFSEDreCWexic7Kxo/8SkKE6kB38S/YFdbLKDyqjcC2vq09XyaHXaFr8D+V1a2+4iHtXyPrMe22D/MhY1lRe8GzpBrdc4qUXb9R4W7+N12UKmGdRbCaUa5atfH9v9R2zPv8H8VCDZgn9Wyi36chiUNXyJJp8386o+jZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764052286; c=relaxed/simple;
	bh=Q5CVO20hx5wq+EystQMLKMhxzXdO8zkqbeFQhRzMWgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIB7WhCufgaM14C+Wf8ArBltrHk7hR5wx+b2BbtsfZQN9I4kDB7OmxccC9DzLWGQ7Zmf7hiOBEACKbQeuL6GK9kRYZRc+UbMJmCZ2IdRl/uiobT0WL8hWLre5kWRtfGn4iDz2aGyMS66ZVS2A5YLT6Z3Z9FESUYGsqS0JJSaEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Er4/Loth; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Er4/Loth"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qLIr/5g/S2BaUssc3LhMZHZ7o1wXWd7qBh9Mv7hNyss=; b=Er4/LothUf5nNvmv2y323fuBL0
	UDpDfPjv2tMSLyYw7YF8dHxRRbt4JK6Cr7UozBCou1JkJdhQCh0lhTM/Xws5Iy8xzj3QtkosaELA5
	HxzPyRUV7uOLWcSnxJsjjhie1JB8AqBRIIt/zPkBjSV26f+xKncMbtuGy6CTnUPaJlXw1s9GKBfa1
	aHepXpM4C7taFPSCw4IFM6u8nJ28ivaATb9Fap1Uvf+GGrqt3FkQJLe9FHbvIZ+QpWVN77La7ZmbA
	lvvxlV9f+Dt55IqnnAgC800sMCbjX5S3wKmZJSiV8D0axD/+xrLOt1N5rtwRAEAvzNyIAOzb8ZlwX
	RxoFuvIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNmaA-0000000CpLG-10Po;
	Tue, 25 Nov 2025 06:31:22 +0000
Date: Mon, 24 Nov 2025 22:31:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>, cem@kernel.org,
	chandanbabu@kernel.org, bfoster@redhat.com, david@fromorbit.com,
	hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] xfs: validate log record version against superblock
 log version
Message-ID: <aSVNOhcK3PvdlSET@infradead.org>
References: <aR67xfAFjuVdbgqq@infradead.org>
 <20251124174658.59275-3-rpthibeault@gmail.com>
 <20251124185203.GA6076@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124185203.GA6076@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> Hrmm maybe we ought to reserve XLOG_VERSION==0x3 so that whenever we do
> log v3 we don't accidentally write logs with bits that won't be
> validated quite right on old kernels?

Why do we need to reserve that?  The code checks for either 1 or 2
right now based on the log feature flag.  If we add a v3 log we'll
have to ammend this, but reservations won't help with that.

> > +	if (xfs_has_logv2(mp)) {
> > +		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_2))
> 
> Being pedantic here, but the kernel cpu_to_be32 wrappers are magic in
> that they compile to byteswapped constants so you can avoid the runtime
> overhead of byteswapping rhead->h_version by doing:
> 
> 	if (XFS_IS_CORRUPT(mp,
> 	    rhead->h_version != cpu_to_be32(XLOG_VERSION_2)))
> 		return -EFSCORRUPTED;
> 
> But seeing as this is log validation for recovery, I think the
> performance implications are vanishingly small.

Yes.

