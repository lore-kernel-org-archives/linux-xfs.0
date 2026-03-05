Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E4327E05E;
	Thu,  5 Mar 2026 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719373; cv=none; b=o4bLpVclXoSnRKCQM9Q+1/K5ja1c19RX+CHj3vaY6BT8WfZ7QbQNAR+4I6893C47fcb+GYpPGHUUCGVViRgpjNKGc/XTUNhEl8PsHNF+eZ1USgAozcAZkZReEHUz1YuQ2tMPjjqckyIi7XfRkIR4YBWW2XwcFEl2bmtc7FhAnPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719373; c=relaxed/simple;
	bh=tvYcEb1/lB6C5aOwX4E1voqNmbjCBDG5w+d2D0dCl5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7I5vZm7Ysu7ae5GPwlCicWS6xlBFf4b8+PDQGSCltGBn9OTjQajnI8YdIiDvFcyx2dp4CS0eczMxH6hrt/dQdTaNb80jpL+2EiqgDoNXtVfntAro9eeFEva+FkMLPyJ4VNhfL1xYgTfMQNFHB+sYSV10mHKHSbVZUCZsPkeWS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oG13kGYi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oG13kGYi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4dkdyfkgE8qmIGYK7Ehi2WnX+a7d1YR4BNdV4t2NKLU=; b=oG13kGYikkwjUwUIu9y+AcxTur
	+VWYqggMwbIWj3Paik9vbkXbCkaoPWJTwBIB7ErnVitsbvyc1hq9w1Idgb5GuSXu1uAAELGSmyMxi
	cHQrdvrNkVtN/x24zxhduYzCbsaBZD+d2PIqVEXlwQuLtO3528lptTBbQ+DbNdpKg0Ee0UxMeVUf5
	UjFugkMypinoIjlLk/DpcXuyzFZ/GH4/2BE7cE5QX27lHxUXvvGDP+ABrm4KmLmIONKsnu0toWOef
	NoX7km3D/MTmKd8cmJbiBShh5+hTy+fnzxNWIWpbMt/sCFCAYBL8KpZWFcs2NoY47j4XRjkrOmjRP
	tbKNaVsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9Hv-00000001v8s-2m1b;
	Thu, 05 Mar 2026 14:02:51 +0000
Date: Thu, 5 Mar 2026 06:02:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
Message-ID: <aamNC9JwxBNBBTmW@infradead.org>
References: <20260304185923.291592-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304185923.291592-1-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 07:59:20PM +0100, Andreas Gruenbacher wrote:
> Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> calls bio_io_error() which overwrites that value again.  Fix that by
> completing the bio separately after setting bio->bi_status.

Looks good, but can you drop the pointless goto label renaming?
I'd also be tempted to just open code the split error case instead
of adding a label for it.

