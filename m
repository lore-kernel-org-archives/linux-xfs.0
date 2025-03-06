Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBC21804A
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 00:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741221338; cv=none; b=bNxpUKBGEQGA9ERqND8a8slidK4fzo0uoSplmoaGRILbgS5GWGFskdSKfaUsHG6ozEPFItbxmPzIHyP1HwC16qAhj9oxpZ+KKgqWuH73lvJ/FU9UR5LOm8o2A8ybrP2HyC3HX3B2BI6fv4X504/jBV6Z77u3MRDrUVirnaItSa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741221338; c=relaxed/simple;
	bh=CGV1wf7N1EvOuzw739cy6wIdVUDguYNcmcVVqPraSZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nf48JBHjF4CRm3zsChS9vhi7HT8P3efcxFKvFwVhoDdrbIfa3EGiaNUFCRCDO85YQsZItrlioLqraF0SQhwalPPptZGb07S2jK47v7lR8jsC8c+ke+ueuK6SdyIz11cHo/guBidOeyQXM3HJi8NWhUVqZkDwSe9Dzil/zuPMHMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4YVMkyXy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4YVMkyXy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=scSmq7+qVxiCAlt+ZlA2UGQSuRsmoJYMxA220bI3LvQ=; b=4YVMkyXyVlZqTNaRElaAdylnn6
	JvL/qlg02mQEg7hONLhD36UqdmCvXva85NqltxHtqlUVGDBVgnu3vsxKnrpHNb0f5nbHprCiYbhM+
	YeN70wPeWU5dGaZuDr1RnBWHtNFGfm/EXSx1NE1T8v0Wb1ye1XymlL4WKNBDqQ4efCmm0BZTtb99y
	jsCYHFpVDlxxxznHHAOLD5iuRzJO0bSp/a6v6Wp1F/mWtp48uH3Wf0zXmrUE1538B02yJ80W/+DJA
	Ux8HE9nXnRs2QszUrDShHUy0jasW7Sy+vqyX5O78MeWTitQnDlJF0tsgVh7une9S09QkaSjKIYvn7
	cuw4tJTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpzD4-00000009i1M-0q7K;
	Thu, 06 Mar 2025 00:35:34 +0000
Date: Wed, 5 Mar 2025 16:35:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Slow deduplication
Message-ID: <Z8jt1jokQtZNUcVm@infradead.org>
References: <20250302084710.3g5ipnj46xxhd33r@sesse.net>
 <Z8TPPX3g9rA5XND_@dread.disaster.area>
 <20250302214933.dkp743wxlo624aj7@sesse.net>
 <Z8W2m8U9uniM8AAc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8W2m8U9uniM8AAc@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 03, 2025 at 06:03:07AM -0800, Christoph Hellwig wrote:
> The right thing to do it to just issue readahead in
> vfs_dedupe_file_range_compare.  The ractl structure is a bit odd so
> it'll need slightky more careful thoughts than just a hacked up
> one-liner, but it should still be realtively simple.  I can look into
> it once I find a little time if no one beats me to it.

I gave it a quick try yesterday, but it turns out XFS hold the
invalidate_lock over dedup, and the readahead code also wants to
take it.  So the simple use of the readahead code doesn't work.
But as dedup only needs a tiny subset of the readahead algorithm
it might be possible to simply open code it.  I'll see what I can
do when I find a little more time for it.

