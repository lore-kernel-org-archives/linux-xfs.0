Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34004175A7D
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 05:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775540326; cv=none; b=JnUsM5gO+pxjDHpPXIMi2CXXi/BVEErBA9gMlt1jPR0IltU3EIVki3Cbnd77AS3bFkA5ehxjiMc+cIvDZTWFnCKxE7mxE1VYrr9Q6tfUiOT55DGOGVRg8w8Cx/1z939j6JRCdJhJynBi4YwxkAE4vqjoVdE451j7IjGCM4uHTWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775540326; c=relaxed/simple;
	bh=qHinofWoXbwchhh2uCeqa47kdiYjqf4OSfuTnc8/vyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAFJYcr4U7wGRL+QwJWuMXlPn/oolheHp1AuW4FhH0o1kjisbmpZu5KxZuG2GZH5Ru5PkZ+fLACMgde4RvUibMh2HyNEbAbsIO2Bg5h84pI/6KzkhOlgCSO8R8WOz5BLmxiiLQuy/owd+ouPWdFxH1OuzNDnkSH/sV2EyHOTzhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U4Z6egDX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U4Z6egDX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=36Dpkfw57xA+ReIwLZuwmoKl8GEEM1YTQMgagrgLqRU=; b=U4Z6egDXDJqaGQHlCaaJwOa08q
	hNSbaQOPYGGymQ1CQ8FlOJE6HVszefrS2uf6bBWu55QJ696Q7Z+7zaxnFXNxPRjxgj7VuhZkjkxgu
	kbKPdJxoXYqtHgKzZuMKxY2EhrA05ZOpTb+bom4pH2wCH9zQ7e2tuoE7qW9z1K9j0c0yqPxi74cvk
	UT3mn+i3CNE8qo+EQOMPa/Nwcqfh2EXRheUl8grJmfunqWM9J0SzRsurhQjlGK9FVfC9OoOZngR+q
	foC5aO3g4pAYGhxJutlx2NbuCLypufl4sZAQ1cEKO8x1qBO2aeSAifQiLqEy3y8A3RVfZMr+jGSsy
	Bvo5VjDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9z9A-00000005vuu-27yy;
	Tue, 07 Apr 2026 05:38:44 +0000
Date: Mon, 6 Apr 2026 22:38:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] mkfs: unify validation behavior for data, log and rt
 dev
Message-ID: <adSYZMTNXGOy9E-2@infradead.org>
References: <20260404163640.1013997-1-zlang@kernel.org>
 <20260404163640.1013997-3-zlang@kernel.org>
 <20260406153726.GD1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406153726.GD1048989@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 06, 2026 at 08:37:26AM -0700, Darrick J. Wong wrote:
> I think this rearrangement preserves all the datadev validation checks,
> then makes the log/rt validation code look almost the same, except for
> which variables are accessed.  That change looks ok to me, but it's
> disappointing that there isn't a third patch that actually refactors all
> three into a single function, seeing as the commit message talks about
> unifying the implementations.

Agreed, it would be really helpful to share the code here.

