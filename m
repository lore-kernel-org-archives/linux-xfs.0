Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9CE343899;
	Fri, 25 Sep 2026 05:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314480; cv=none; b=opiANUkhHjG3VumWGpkCUiCL05cDjwCSOMQMGfRaVJKAAcNoxUZFeoD7IQoaURa0uZGvnI1hE6fuLreicKHc9owlVbdYyQdEl1iA2wKGo+JX+dQppBvYdX+n2hLSV2o9RJcIRKSJ8fX2sGzfpN26pCXKAXz4MlcfcO0hpiA7wgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314480; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqbuN33Zw9hsGMu6vhb1pREf2ekxSYglOB+6thSQaq0WpPI6jHXpQTa18N6btwEMvUcE8F3fhyX5ia9FSnnQ0PXWAVvzkpsNO27rNKUeRC1BJ6a2bQkRp3yUoHjL1aY+f4fYPKw2gN5OHWdUPB/a6fSs/brWWsVTbwmKNXFbuIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s5bKNnHe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s5bKNnHe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=s5bKNnHezBCVREncBo4C2wqGcX
	Ok8TtM0VoT75tvk3IS4NsEyseLTHo+SgDrRQ5nNOOjQbSmuNgIw1mZeLgsUtZ18P+E+4Wj9Hw0ySG
	G1sLU44wkzxrAWb0RMxY9Z1ZqKmby9Y6bwvOiQEGiyM4WvPIyj/3BCgwoZGS8DpRPwIywI4HjgP2o
	H/mWbzGmh4mqrJY1uPB4F/+5wEu7xS73vER71uqrG14IlND5+CS/MEsJGMUFLWO+p0FVtfqDJA6mP
	f9JSILTZH/TQuTN2u0P2GFWzYGgMqVOCdpVfbibeoozukTLlWjNj/yvpQsYqvUAx6Qon2AT4W4O0H
	f2SrU9Xg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yZy-0000000Chbr-3FQq;
	Fri, 25 Sep 2026 05:34:38 +0000
Date: Thu, 24 Sep 2026 22:34:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: fix xchk_stats_estimate_bufsize to allow for
 the trailing null
Message-ID: <arYH7uGdzRcIvLhm@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932113.3344850.7345584822446434482.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932113.3344850.7345584822446434482.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
