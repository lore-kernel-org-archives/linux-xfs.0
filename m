Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BAF3D2FFB
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 06:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787121367; cv=none; b=BPQa9Mi29l5QUskKc/MW3Xgun5mSpxU22FbVYCwN4MR8rKIAAil3OCcubWo0Oir7Q/6Q50anpO+hzBHtFJ0B0G8oEyGkKWqDmQAB1EBTUOxZVyqYBcgJFHcKRKXbIHKdIaOBkz7dS+MxtluXtARgYaBmJdkb9gW03CdOsYXzSWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787121367; c=relaxed/simple;
	bh=ZuqH8wvmZ7aH5LM2GRBnEAsJEwscTtDbsZfubVgBpy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thMlUXYpSOQ4GTUzYEsYgoTGyrcrhdwC50bhn9gl06ZO4PGYKU5blW1Fm2++R5zdnSzNCepLlO7NMBUP8ErKCCi2NnpIDFj1fnU5QAY01qhpQ8t1nTVN4TF9jcSTm7BD4HHk745MbCwK+ab4kKZ9SQmOYPl/tJfbPKZ+C5n2S/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e8Ce/Chk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e8Ce/Chk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WDqQ4QeDkj2jdnau+re4Xt1i0E1RWfWIdH2qpH4KkxM=; b=e8Ce/ChkZJS3iyI4y9vrzY0Wu3
	s7Cwz1YE/ssRd2EpHNohSoCEx08IQWbX6LmQuB8dDhe3oEkIGEh8ww5ICJnVSi5m+7YfzvOkxETq1
	P+Dg/Js1yVssDOigM7s181StQpASvJliurnUZKscNJYnSKWXEkjqOEsphTEVkwt2ZL0r5BFL7/YxC
	5HWFjVIhPyN+po3pJIYI85kX4hruN/FoNSXozjKFR6BgAfpZgO23o/ENSg0GuvkqXPd1SiiQjFQa/
	IZeavAS3h5uXkX+VP3122L4A71kEDLWNQwheCfikDnE3xwpWKL5AoJYScFnGA0A4xYT7VribAeQBV
	NxvTI/+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZu7-000000096gF-2Jlz;
	Wed, 19 Aug 2026 06:36:03 +0000
Date: Tue, 18 Aug 2026 23:36:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: adjust datadev sector count to reflect internal
 rt volumes
Message-ID: <aoVO0_jWpSlZZ1Xy@infradead.org>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
 <178659861593.833642.6889273918398598117.stgit@frogsfrogsfrogs>
 <aoVOIZqmmAI7FYlm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoVOIZqmmAI7FYlm@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 18, 2026 at 11:33:05PM -0700, Christoph Hellwig wrote:
> I still think messing with the kernel buftarg nr_sectors is wrong for
> this.  The kernel view of the buftarg should be correct and just include
> the part of the device that matters.  So I think the right fix in the
> kernel is changing xfs_verify_media to add the internal RT device offset
> before sending the bios.   We might need additional userland fixes,
> but from a quick look I think it should be fine (famous last words)

Btw: happy to look into this myself.  Just waiting if you have a
reproducer before I go off an create my own.
