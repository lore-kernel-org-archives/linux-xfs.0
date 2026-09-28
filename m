Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703173806C4
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 06:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790577286; cv=none; b=Re9+uoMEqQ0ColtxMA5Kx/dKWkyR9zK7sVPzXBYs+mbokLBQeKeVHwG+M5EBVEGb8VjBMe26LPqFzYltQC6e26eAddelramESqykgWMZaGljiND/eqKHj5TrGZMAHCIAd4EGMNYKrwb728mJxAGxhq5ZJhAaBgvC98KJrlfONZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790577286; c=relaxed/simple;
	bh=2Q60G5QVlxuSPP0iUV+JrCe0usrHcbVCAao0i/ruOyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XR/1HYcPjbWS7j/5CvubLLsQhCTOEo1X5uqsnjcUOYM7lsqPIR1bNG3FXcVYyezU7kgprMzTSuEWZzQHYMfKQGMD0HDM7I1vQ8AuKyh2E0QvruAzyEntMfJaJtAlwaq33znZ48XRzkDqzSKBSy1H9pDkG2R10NP0Ob5Ll8mFvfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U6Adcynp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U6Adcynp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pdWV22/jdwuSjJsTUFb+rP7ou+NIN0Qts7sG2GYFITU=; b=U6AdcynpDyHAARPK4BT7fobjv5
	2yfS/nZbwQTNAxNcpaF9DEcFusX6AFM0AHHbYNkWIPoeghuOUUffg9dBgKRm8YsY54PP0bIfMZAtt
	TSjJREkWif7ILHgC3K7flZOIg2G4+owQU51ACg+AN78wjWzqx/l7zoqpA+uu5At5kEJaX/661aYR+
	7GYWGwpCobG2/7smLPfUiJWgBAhH9DYL2Zgu+uHyfdpE2z6d7jmIxapYBvqw12mnRxG/qZIMaBWow
	wUwXL7t/Bbqa9An5a2yOTmvDoYn6eIhmC2z+l2SkOBKX/bH44xKTneofMUPOzSY4jEtWtm7ERjoCG
	eP9RqmHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB4wl-0000000HSUe-022Y;
	Mon, 28 Sep 2026 06:34:43 +0000
Date: Sun, 27 Sep 2026 23:34:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: be extra careful about replacement directory
 construction
Message-ID: <aroKgvEG5maAmXg3@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612618.479634.3835896628058983547.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612618.479634.3835896628058983547.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 11:16:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the directory repair code, we have some debug calls that check that
> we never add a duplicate name to (or remove the wrong entry from) the
> new directory structure.  LOLLM thinks that we should actually be
> careful about that all users, not just the developer's system, so let's
> do that.  We already had ASSERTs in the bailout cases to make problems
> more obvious to the developers.

Does it also explain why?  The code does look obviously ok, but a
rationale why we do extra lookups would be kinda useful..

