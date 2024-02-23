Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D3311CB2
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708671955; cv=none; b=RqPcAg8WyJwssiETJGpzTh1Fbi5VIFslxKDdYm4uuD4R46xlKFtxP850BNBFo6RAeK0svYhaFxAAkobgup2zHPSkGB67tbDKFP08NR13Kt6KLE55Cg9kecRjVKnreYhiXkrH1z7F6MzcElbFf8m4VIaG/fOIHuVy4IU04ZaExGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708671955; c=relaxed/simple;
	bh=U6yTnMBlZorWYylVdfw+RZmYXy92hpMrDkM2IcenaOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EFmnE7S2t2y2melDOqz7CWJYi5lv8OWu60J9eAItj2xJ9Xz1q/Ds0V98XL8QqC6F5zQOe3eBvl3ml2aEMcwZ6+zpA3hn5BCj1ZpciDgSfZeO1lJdsZ5QOqa7uh1rreCDvK34UQjKCtMn/4zcS6joqDqXM/hD+S+/aUtLP/RRf20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U2fmISzq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U2fmISzq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h2uV152jnmLHd4pmCOI4QSfusEhyzLNPErHMOgx3TuY=; b=U2fmISzqzZISBB5VRBl+4pQtSa
	HCDeKTa4rBQzWIdf2usbHxgDUgV2QrT6Al+4l2VbPyh3fFeICW6VpEItaz3vEzC6A+jZV2oqQJhco
	HmFM9ZPrJLSEyGwoKyyMbt+ZJOAFV0J4i5cEQd93ZHLoBctxkTOT8ymQt6N9oSCBT8nmkXmrPRJao
	qbOW8GJiJxmRh6lrpOX7xg/+/9/OVtK5onvOz7js/L3OpuNYoFd3dlyVeWBRT6VIREW0tqeO+UgUV
	GUkG2cvTQyAv4t6hzYq4I7oJZvMt2Glz3JFQ6czE+jDvPdYLIuRcGNCqcJ0oHwnBGmrQxuP742Git
	Or+PmNbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPd0-00000008Fgy-0eDz;
	Fri, 23 Feb 2024 07:05:50 +0000
Date: Thu, 22 Feb 2024 23:05:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: fix log recovery erroring out on refcount
 recovery failure
Message-ID: <ZdhDzq3dmhsUwq3w@infradead.org>
References: <20240223054817.GN6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223054817.GN6188@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 22, 2024 at 09:48:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Per the comment in the error case of xfs_reflink_recover_cow, zero out
> any error (after shutting down the log) so that we actually kill any new
> intent items that might have gotten logged by later recovery steps.
> Discovered by xfs/434, which few people actually seem to run.

Talking about xfs/434, it just caused me some nasty debugging headache
last week.  It is the first of only three tests requiring a loadable
xfs module, and when there is an xfs.ko for the uname around but xfs
is built into the kernel as it is for my usual test configs it fails
in completely weird and hard to debug ways.

The fact that it requires a modular xfs might also be the reason why
it's rarely run.

The fix itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
