Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500A5363C6A;
	Thu, 11 Jun 2026 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186360; cv=none; b=H65gvEmE9rapP1KgZ0c7E209pPD/JLWtrOVY6lNKH4IKcfL8VAHVzP4HkMgIh962Wg102lhXqv4Y1N+1jI/UPyqkCkd8wT0p4Y9DXIkcuMWeBacx6GiBzHjQ3nLbmLdsKD/VF7qpNtdpmhgXAnSnQkim0SUxjpv0fypxHppeyNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186360; c=relaxed/simple;
	bh=HMmwgd3nwaiNzarEg504bTsefaPNJTYio8H/JpI9o4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dK9v86gaHFWunZbrtCv9q+SIenAAEIKwCZcgyydpKC8OF/57KjJvnLCKETDQLdLjAhKSGTwMnAXuZ1Jq7YK0zwbvGaANOcjSsfn+67zoX1kFGWmRyLQnBq81SXoOtjo+u5Tv45znwz6qjXPEtPW77ZW7nUoOfj3vNAL2Ai/hw3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L+RzyONk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L+RzyONk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AZPmUi9zLagNzdr6Mt23+dm7+NkFzJ5SnX0lPsFTiLM=; b=L+RzyONkJ6mPSRHc0gXPJZ4HEP
	xpIBHmnbE95NQVvq7sVJmixRQ+Rmt1AiNSH5a5DM1sJAzl47YVW/jm9xIBRTaBaBFZRsc4t2sclfW
	QlJM0VFvLIUj8PeOMtALRrpsC/0N9+cxHj8QhjD4OnyxJ4m/ib5ez9E9J4H+IvDbVeUVlcZcQpZqU
	RPcObl68wQfSONMhufgKDnEloS3BamGTnq6+RRGfvVhd4jnnz8p97MHt1YxKdlm/HuonuH5ZtxfED
	5M+XF2TMnevYOdO+Z3HP2gfU6a8UYVN7lljUxLV7D68zfAHglbBTFXbXw61YhzyICeakT6TJQOQi/
	27jqUDZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXfwC-00000009Z8w-0ssE;
	Thu, 11 Jun 2026 13:59:16 +0000
Date: Thu, 11 Jun 2026 06:59:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: hch@infradead.org, cem@kernel.org, djwong@kernel.org,
	david@fromorbit.com, hch@lst.de, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v4 1/2] xfs: skip inode inactivation on a shut down mount
Message-ID: <aiq_NElV0lVC6j03@infradead.org>
References: <ailUyXryJh3gFZJR@infradead.org>
 <20260610192538.13202-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610192538.13202-1-m.lobanov@rosa.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 10, 2026 at 10:25:38PM +0300, Mikhail Lobanov wrote:
> Hi Christoph,
> 
> > we'll probably want another patch to exit early in xfs_qm_dqdetach for
> > that case
> 
> Before I send that, I went looking for a path that actually reaches it and
> couldn't find one in the current tree - so I wanted to check whether you
> had a specific case in mind or meant it as hardening.
> 
> xfs_qm_dqdetach() only touches the quota subsystem (the final
> xfs_qm_dqrele() puts the dquot back on qi->qi_lru) when a dquot is actually
> attached, and a dquot can only be attached if m_quotainfo was non-NULL at
> attach time.  That leaves two windows:

You're right.  I did rememer review tools comments about this, but
they do look bogus.
