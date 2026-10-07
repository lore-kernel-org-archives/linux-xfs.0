Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A685847CC82;
	Wed,  7 Oct 2026 13:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378379; cv=none; b=u55LR4URM7TeEm5h1fq5P+8IxWLkgT5cr5rcF90r/+X70DcAGNnawZZhUhmb7hvKKWOf6NIqvqKhCnYcjoew5edEIpl5rEI3BEePuVr8HnOL1hFDU/7ynxzUyovmHvh8K6kPdFOztLTT3+sOTvrIKK4OSqsmoF40++fGGGcuJT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378379; c=relaxed/simple;
	bh=wn1HFViaC661Vt6oQLnuA4fyRudBsbFNYaWnkHCvYuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sjzg1Amb2212kgkVPYO6Nb2k8J0ZS595OpO58/Fnj5BA3qcG1h422MicgVNfGIXw0ZTqaRBijFF+YPUlamDcYSwI5m7EIShpADCNEWjIEtV/juCDeF058gpemDOxXucrcl+Wc7FDXzH0NMtEoj8MYgtVbhhi+uYOn2TYfpUKcvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q0RDARWY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q0RDARWY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xVJGQikahUDnCQVjF8W+DnSfztfX4JmTxlkKMUcDUlw=; b=Q0RDARWYvefveFsTYPJdIWD51v
	40NjwM4aeS0tu+zkwK0Bw2zcVtgg/SUEtBCRIhjjyHNeb+F0+elWgAdD0HBOw1s077+BKqWNMoQn9
	vGBUGHI6qzIoOFyCu2zM0srhjYf3m+LbLLQ4402O+yCsGAWmlXm68Onq9/C650gMkgi+5epNVvIzf
	ZQMro2Nl+TmXj5j48kT9b4N83t/4Zkwcqwb0qpr1SVWM+1YWT5qxv05tqb2o8HfLhZhpOMrpEfu52
	C1Xr6mepH6A+r8Yb+wNBxkVKHmY2wfd9kWYw42BmEGLU0VBXByPoTqRaJ6raYCjwoKlrXMRnPpfNl
	bjmCwVNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERLS-00000002VI7-3TxL;
	Wed, 07 Oct 2026 13:06:06 +0000
Date: Wed, 7 Oct 2026 06:06:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: init inode number for tracepoint
Message-ID: <asZDvpL5haUXDh1V@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965202.614350.9924309515501263825.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965202.614350.9924309515501263825.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:57:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that if the xchk_dir_lookup call fails, it won't set ino
> to anything.  ino is then passed into the tracepoint function, which
> means that it reports random stack garbage.  Set it to NULLFSINO instead
> so that the circumstance is more obvious.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

