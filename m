Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57F9481FCE;
	Wed,  7 Oct 2026 13:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378341; cv=none; b=NjRArOinn9QgRjmnHfcDFgSYy4kZvPEsTFFhY/CG/9cXzv2k089qLQII0aSzZCHx7N/ZESK7BLsWuvllNeuJ80atLAGYfMr1I+Ty9kPUyFm+508pU2w904LUrz7jmd3oaT7p8SFhzERq3GHVbAbhKl6KgP6ZOrA5mti8rdzfbMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378341; c=relaxed/simple;
	bh=bn+e/JaCNqHVJIcZ1/cBe2Z5tkzONvKDWwEq9SYqBcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPcgr8unh8/h7dP3obCLPOBwF8X3aeFc1sD3OMBG6Z5QBkKai4/FfguumZCYjlBaMQ1HQit9akftzxfWWMshB4Vzf5wp4bwxcpx89RbDBMev3IQgTXjBMy1Zoq/74qeG+dA24r2AXDncKGP9810FoOSVVfeixoEhQW1654ijuc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N5HOMj/k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N5HOMj/k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fI1RC60Q/kzCmAOnYiPOWJelgMFXG+87u3TlBiC6ERk=; b=N5HOMj/kY7V6GMXSOCgDcmgbis
	4RC9AGt4jPCqQh3RpW9nsV92A9hloo1hcKUEs2BaxO40j4oCEbA0y/Zrhm0pFja2xzq7yuVN6zSj5
	Lvr0Mdolxfi4OXteiK7/alToFP9CEbH/djxvKR8rZy5UwgumRCgIOWRyvnNpUXE0pq080PVL7Wu9z
	1FqNdH4OmTW2HVPm7O4Z2J+UVTgIAPBphD09UABFJbZ9ViBLrNdxoU3OqAJ6muS2ok7hBmj44/u1g
	2TOpKLpFqRUp2GCNrGMrMkDCk1rCR4MmRMNDMH0H1+EBxcctx8Eh+UIKN9zU2oXd4i5ampavqacmA
	NNot7K6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERKv-00000002VFo-0LUt;
	Wed, 07 Oct 2026 13:05:33 +0000
Date: Wed, 7 Oct 2026 06:05:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: don't try to scrub self-referential dirent in
 metapath checker
Message-ID: <asZDnfhPu2zvFE8G@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965159.614350.4466564726537723655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965159.614350.4466564726537723655.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:57:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observes that the _ilock_both helper will loop forever trying to
> double-lock the same inode if mpath->dp == sc->ip.  Callers are not
> supposed to call us with parent == child because that makes no sense.
> Trigger an assertion, mark the scan incomplete, and return IO error
> so that this fails noisily.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

