Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2E346C842;
	Thu,  8 Oct 2026 11:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460385; cv=none; b=j3P1lFQt8s7+kl/rHfQm94kKf7JgDfUgbsRCUurJgOwsW+/dG04S6vK/uGz7qksCMmLHfJzotkRFheMjgWhbckiw9kBx+chx/0FDFqZg27k78BQ+RIGQKZWZ4O8NjiYvbTTJdS8idbpEyJqmNi5IgrzArADkYvfPESTr099ugjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460385; c=relaxed/simple;
	bh=4648lm3dapgyahAzMKVewehx7HdPEAEHLcX60kbYwtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hurrMD+1+y++99XTUpE47+7wMjPhMfjA1DoltyZ0kYFykdtTbUNeNNExb55oCesDaMHvK0N6PO/Df/kqultcUCjHLghJgaNR5492sPce60hphpQ6ylyTB1DiNA/IOc7cVGooCFsH8jJ9F41LF6mhoiWMO4Yba2uRjnWJ7/aqOoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RaOuyRSU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RaOuyRSU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XlUZVRNQCg7sQwrdgGGDTXm0LgBDoHECSkkeY6HiJvI=; b=RaOuyRSUolv2poiLX5cqMjqS6k
	qancweUOXwagVIRxqgR0laNv3ena42HqwbU1Ca7jdYA4piLW8tkQs5mWhGlrP9y3V7XhiKObOWQaF
	/1o7nrdY43nJlk7ABVuq6OcxOt4gndmOi8lWDl0s3oILrkcKDyEgMh7Aq3hIIaz65QZYU25XMRyXr
	in75k3B8ic89NiqhkTSnCyGr7YfDyp9Jnq+5ob2rPbvkkuUEA0R7HH0S0HJ/5GCaoa9fzW7W5vn4f
	ENaVcxze1upstQEUNzf29Qus9VTgW6PKyJvak+qAeH1F1MXBKzuKfMada+16wcWIUzoZjecevqpqo
	Ioj7U96Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmgE-00000004IAA-3aOK;
	Thu, 08 Oct 2026 11:52:58 +0000
Date: Thu, 8 Oct 2026 04:52:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: check for termination during rmap btree walk
Message-ID: <aseEGniwKPu9TZRm@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521277.2728617.3453429073541203674.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521277.2728617.3453429073541203674.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:55:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that we should check for a fatal signal *every* time we
> walk a record in the rmap btree as part of rebuilding the free space
> btrees.  Fix that, and improve responsiveness to ^C of xfs_scrub.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
