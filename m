Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA853ED5C3
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772556854; cv=none; b=YhAr9QabS343MIM89Jvj9p0AMqKLBb+dTTDvAg/be7qtcjuCBoZbvKbnQHczpuBetVkIr5b7os3PdPC+XYvihmYcwYMKqi+izlIjyHQZpjPsweSvtLFPAytx5fFO0eLGOM6FzpAy93qCo8oNb07tYGVeqmU1yk9ehLIvWLi4rCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772556854; c=relaxed/simple;
	bh=1zv8la/yle8KdLjMwifu13Od2xvaI1jcG2U73Y8QWsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kIc1CvmKnfe7ODikCcJdeb33m1yqHbR1h0a69nEiSzdmwSCy7IPIKgfoZA9OZ3/Iv2y/72coCF6c8EajkrlkWnQJ43m7+XtcplA91tofudk4gGeZh/RiRh5Vv0SkX6US+m0rEcZHxoATqIN4WaU83xJeQimwup9cePzfAEGHNBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d8SsOft4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d8SsOft4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=mI3RKCxL2BpwfMx/iNqmS+Tyft+G5GLGGzSspt88tBg=; b=d8SsOft42msB36Y5WtLNHDe4Ln
	8iwluP21jPi5ixZQsuHhiWwUkP9PaJ/6FUQLS2Tgehf8d2ASGt17v9fetLmm6VPLaP7xFqnrWfbt+
	1ql+Pq3ZAycLsquXIhWWCCj/upak1RrggBtrEuqg+Lre9hFEpKUdvCr6pF4JUfd+3CK4y10l3mbgn
	E5D3v3njaWM0hefW8y5Mpqu7twCTmpUvLp2/GoMMsyOCecUXkRdaB4HQwSYNnxBVNxJP+UizBA7OF
	+cENHmYv0uMGXC8VEgjVGBcGyTcbyMp1YHOVHGHKGdOO2TBVRqwyrFezh6L9cUC3ZO9FJEiKqkFQS
	i8tK7/jQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxT0e-0000000Fbyg-35WO;
	Tue, 03 Mar 2026 16:54:12 +0000
Date: Tue, 3 Mar 2026 08:54:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/26] xfs_healer: create a service to start the
 per-mount healer service
Message-ID: <aacSNL9qWjo8NIo-@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
 <aacDDXudwf9ygIkQ@infradead.org>
 <20260303165221.GK57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260303165221.GK57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 08:52:21AM -0800, Darrick J. Wong wrote:
> > > +	while ((ret = syscall(SYS_listmount, &req, &mnt_ids, 32, 0)) > 0) {
> > 
> > Should this use a wrapper so we can switch to the type safe libc
> > version once it becomes available?
> 
> What kind of wrapper?

For calling the listmount system call.

> or did you have something else in mind?  The manual page for listmount
> says that glibc provides no wrapper[1].

Ånd there are no plans to provide one? :(  Even if so having a libfrog
wrapper would be nice rather than open coding syscall() in at least
two places in this series.

