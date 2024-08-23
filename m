Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B003A4D8B7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388002; cv=none; b=EdLDaaLlSMhFYoIZWlzV6SNSOi4mVyRzqKCYrV1NWu+9ckcJ85J2kqsKYGYGMO6Uxz0v1g5fi2fccBXUnW8JmwrwsrVIAcwB/dgU0HZSdjsUnPCR+5qgKi5/Sg/wFGfYqN8dOdXoRHohw9/gi5+dgY3qzsmN6aN+OcJpR9+5m4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388002; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lX7gIuJIKlXM6CGQXkjCUohIfROArVuwLqbQAlzWDE7lv8rp3vPdJ7MsDTN5RbBn1NKMIMFFc/CmOqHP6fTsatbNrz+snIm8i4MI+STjLjHTVGZUv+yA6OfkLpoCIytj4TDS1vT8KPM2QnYurUG4HN3+dmYA1kEebc/1XK9cjvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v4xpWVFP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v4xpWVFP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=v4xpWVFPgWdC2nsoD0m4/R3rLM
	Z8Hl02HiJEiIlDn7LdDqwmyFx2rWWz6219muQNvqyYt6av1dTM8VsWMscBQdBKXTbUo5xGZhzhJ7q
	mu9ybeen+Vi1ytUDjd0q9QFgzrPRC6/xVIeQCWl7T1zxMNPktdP3IHntMicOfRa3W4TuunPDCdrdO
	26HMJrCLa+YyXnCjF5W6ucTX7bJxgsFakxZECmyGzjxz4ydhSwqm99M4dD3flbU7FvYzYuMSP9nhT
	UhNXLuZvv2UvhpcOHWJmu+cEEmHm6b9m/Eomy+DWt1ZHDn2QW1t5xE1rcNbYFSNeL1UG4zzvtKIc+
	6oUrqPdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM5f-0000000FDJu-0aqu;
	Fri, 23 Aug 2024 04:39:59 +0000
Date: Thu, 22 Aug 2024 21:39:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs: disable the agi rotor for metadata inodes
Message-ID: <ZsgSnzm0N42wSryX@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085295.57482.10452896060816611340.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085295.57482.10452896060816611340.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

