Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EB63CF046;
	Wed, 19 Aug 2026 06:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120240; cv=none; b=GBQteXk7ef6PKExubc5I6LAeBcp08I9SkJu/HktCp8R8hL06zOQncGcfYgZhv0okXg6NAlPOzpKSo1aRsGmdpELWUBSPXqzbMrVOpeuCS9Ks+pCAngTDls2jkAr0ATM9cDfTD06Bfp/gapwRhJM1DC175YBUfEHAzYM/OPOLTWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120240; c=relaxed/simple;
	bh=5ZTDkdyeSpDdIQSObzXslFSGCSKHjcxN2XU07v3Pz8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSu5FqOueP3g3goP6Y6XZsminr6vtfmvFtgw3sMl8LJk2jZU087uUVq3/mZD0NR8kagqHoYx7o2phMusXvmqm2G8DZrLTskZtGf3OMgfcQ87sddwhKDM5PvB4I4nO1FbnYmHHPmI5x4xKkwCtCsDOTjUVV/TjVKgkC0Wc0mA+cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SFSdCpgG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SFSdCpgG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v4YxwDqDEjcqjgzAczrb9MeBz3aACjssWOk1acGaeKs=; b=SFSdCpgGxrLiWLpYL4lU8GdU7R
	H+fKvi1kt1Ms4evcFIdoM7iKO+Rzl+gkdckhoBRqIWOlvP6pWaEzy1llHl/pV5daGtozeVDDp/oLu
	zzGCUWMfiYbIuagGlbJZZiHkkxTSZeM2jUmx6IxB6HYaoTIkNACyJkPcjz4YoYbOVa0V2duYrE1CM
	HQRwI8mfTWnu6vbzysljDZ2agJ88II2hrwt/Gk1h5kgYJ8nlgMEiqYFU22NoI9xa9Z7+ehb9qa/FD
	VCjKPEd9l9Rj/EM4RTOCwBl8t3867cK53vRvt0LDAhwCvjP5K039Y2fMQ3XKo3he0orwylZA1uoYd
	hS4+TnuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZby-000000095Gb-1PqG;
	Wed, 19 Aug 2026 06:17:18 +0000
Date: Tue, 18 Aug 2026 23:17:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: preserve owner on in-memory btree creation
Message-ID: <aoVKbtxx1adqPkgi@infradead.org>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861918.833922.4826979543941017596.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178659861918.833922.4826979543941017596.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 12, 2026 at 10:25:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out a minor bug where a higher level function creating an
> in-memory btree is required to pass in an owner number, but the creation
> function erases that.  In-memory btrees are ephemeral so this really
> doesn't matter except for debugging.  But let's fix this papercut.
> 
> Cc: <stable@vger.kernel.org> # v6.9

Not really a stable candidate, is it?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

