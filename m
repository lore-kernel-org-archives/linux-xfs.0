Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556CB38239F;
	Tue, 24 Mar 2026 06:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774332854; cv=none; b=jWgbCd76MRzrtA7bjQlerFHp18bQO4WK6KwD1jChHAcq94CIUCNuBZFRBHLM4gHPcK2NlpZvtTS5vVcvJMw0wA/nEa1hGgjV7U0BA4hFlQ5ox9EoSj6iB/PbRxl+0IRO6IFVH/MfocPAD2r1A/VlPNqU3I7SdobBhQegxwbu+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774332854; c=relaxed/simple;
	bh=fKeFWp32Umkk6X74Q7wF1usE9xg1tJTJL4OuOegHo/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ookwoZG7d18B2ub7AaG3fDVneFWp9/d+N8KJYHAM8NhAbI0kKjnC6AL0m/hkmxiTznBE9Mdli8wQmeLSS3Uo7jZqdlAAQlEQWvQVwNAHvhDnkIhCrQiayVK5gVMCA7cADehFOuqoR9GqIvV2neGNWB6kuCkOmM7wi5zJM/j7Wzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NhSC/ruv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NhSC/ruv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Crr+X6KwjNL0HCNmaM8qbxRjBmp1XbbViBei2eWk5v0=; b=NhSC/ruvxC0kYketPGWJoUfPmv
	wVyvaHr9vZuAXbdeRDeCmBgbEZL9pQZLJ9P/A15468W6K56ER69m5ACsPQtKB1mvgyxqy06BnANTU
	dWmu0YuK8GAdi9RAmJ1uRY5B2MIP7P1HtdqAocqKgXWpnB7iO8Gaq+j4g/y5HSo+D+B3UVG7EKRsV
	pf1VAPLhNnSX165Nh5pa/iaAKPKdGnKReX1uFKdYShMTnlweYPGcVLhFkHDTIcfS3N0f74E7RIgar
	JlSwf7CVxAiHskkEYZ1kHSi3E4tKo7FFHTSHdN0+rqtKyp1EsNJlQO4abterIBYd97zWri8SWbn0y
	vMJROn3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4v1o-00000000fLT-2GCF;
	Tue, 24 Mar 2026 06:14:12 +0000
Date: Mon, 23 Mar 2026 23:14:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	Tal Zussman <tz2294@columbia.edu>, axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] iomap: fix lockdep complaint when reads fail
Message-ID: <acIrtFpASaBmFZPU@infradead.org>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <20260320163444.GE6223@frogsfrogsfrogs>
 <acDbFtQw0mom798e@infradead.org>
 <20260323152231.GG6223@frogsfrogsfrogs>
 <20260323210017.GL6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323210017.GL6223@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please reword the subject - your are not fixing a lockdep complain,
but the underlying issue of calling code from the wrong context.
Lockdeps as usual is just the messenger.

> Zorro's diagnosis makes sense, so the solution is to kick the failed
> read handling to a workqueue much like we added for writeback ioends in
> commit 294f54f849d846 ("fserror: fix lockdep complaint when igrabbing
> inode").

The code looks ok, although I'd much prefer generalizing it.  I guess
we're too late in the 7.0-cycle for that, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

