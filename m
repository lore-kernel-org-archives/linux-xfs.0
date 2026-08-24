Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B3A493646;
	Mon, 24 Aug 2026 04:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546894; cv=none; b=lYxbxekORRX+MeIWdxn0Mp+VrPMei2UPKpFSBwi5ebk9uDXQ4LLlFlTPIIXScJlodhCusEWbQWaZBtK7G7LZ3zvOZgcrYLzZXcMIxzRs+jL3mcMOQqsSGheF7Bp2FThEDsDwb+puAalT/tNQnD/WSty4h6/hwv03OngqKfyHK/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546894; c=relaxed/simple;
	bh=kSh8VZ5n5RSlE1dJ9L1kbjCCsJOkib4L1c3HfEj74Dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEqsplwBp7A/LE6q7i3ATD5hSLZEoQ/guBmiHvY1SCF/GsGUD7vC2tD+lmUZs4UqiD/HHdFJACPjjmILkVhzaqb9JBErP8MSRu/ye6po3870wccVxFEib4Tk+J8Ant2UAZthHD23OJdxMzuH89007bd7c/XSCX/ykDxtSf6ESlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zxkmnsjp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zxkmnsjp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zQ2WYiA7nw9ST8ZZTo3/t3CeNOTOB+UESBq5hdBVPtE=; b=zxkmnsjp2IboQMMHAaxGYvb++w
	ePBx0ZzBEu4FLDbuDKO2Nxp6M3a3Yt03WxfVYisCgWkl71VecLjZlLu6YeUekOJFnuDxNykSScC0L
	6/23QvUzAo5380BFY4oyqXo6kYAB4tkCOIs/D+SWwhGFKakNbozaVOYyGKMXsMOlJ2iOcmm72ap/W
	So11j9bi9S/04kmsKy4YBSs4tCcvAeZ+p4hQ6mCfblasIXhIBFRDjvwyvFJBw+/1QIwTZUsvLWRrX
	lhAtRvJAbu1Fz4vYNICrqTuRiytmMF5hj7+2PbK1PjurejA559OQzjDuDRHfvxhZqF/VImjSQsHUa
	qZWx8liQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyMbT-0000000FuzF-0hL1;
	Mon, 24 Aug 2026 04:48:11 +0000
Date: Sun, 23 Aug 2026 21:48:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, qsa@qualys.com,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] generic: regression test for refluxfs fixes
Message-ID: <aovNC5JeOiA2L56R@infradead.org>
References: <20260821235155.GK839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821235155.GK839663@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 21, 2026 at 04:51:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Regression test for refluxfs as found by Qualys.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

