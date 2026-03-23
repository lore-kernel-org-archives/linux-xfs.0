Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47212C3268
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 06:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246240; cv=none; b=oI7XMMlFSDB7fnfT0anoauu4uBT3QtweHM++vBmfDtnT1DsfjX78H8MoGHAQZ/yLBZd2w79osTwe5ClPX9ZJA8PMgjBuYwXRfJofQ4N1bPxvRyHxiPwD8tLwCqk2OVZC/rO1NtpbPQQyWCU89ivZQZ0lt2Raun105UsrL7UuNsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246240; c=relaxed/simple;
	bh=6sORPr8wyxcyZw1ZCg+ZJX0V9fexeZtYC4lKK1EVeIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5HS+eg6q3wxzP0WaVOhqSWbkbREGZuvug5XGSjI5nuv+oBl0+IMsgkbTULONMciI37y6MolrBFHD5Q4ltYvTJW+b7fwPWS/+W2izYjX5/6P1JChTf6CCBT5M8VK2iUD+yDXyUFzd+UoS7FmDXev2d2VkZip0ehvVKKDfPPfNKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=us3q45WB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="us3q45WB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DnRd9MfpDoyaB9Sg3zP9SivDg+6DUf7pFW90R1r4Vuw=; b=us3q45WBmJPMvlSDl1sAnkgsEs
	c3qp6wuDpj9u1nbHIMlSujc1OPd0EmwVDvVrjHDAUEWEe4kQbzIPWMqVUEwj4NRogHOY32aPYbm3f
	4ib9a04PsPq9brAGy710bUczE5p8vHzqWcoWlP87To+nlhgFH26hPoBfzfQfFeUvdVaFpHg5CyD4B
	oO6/ZLTCb9Q/px8FRZe2IpTnTM+ZALmHdUW+jPVyL2kPnKttDAvQqZGDqIeENj/iedn+RPS+VpC5b
	dvAvNR9Qu0L1kJaFJJWfOs+h0WmcWaY86uSoBpqX/mYWO3t4YdhN4NjF5TWsFVzegw0NDmj4hFS0i
	r0Z38udA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4YUp-0000000G6kH-1ZK4;
	Mon, 23 Mar 2026 06:10:39 +0000
Date: Sun, 22 Mar 2026 23:10:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jorge Bastos <jorge.mrbastos@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: OK to use XFS with a 4K sector size with a 512n device
Message-ID: <acDZXyVJiEzlkEUm@infradead.org>
References: <CAHzMYBQ8NiXOTpKn5cBtSmb5ObMNdqhnXjbiZxi7wTdd=aA3WQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHzMYBQ8NiXOTpKn5cBtSmb5ObMNdqhnXjbiZxi7wTdd=aA3WQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Mar 21, 2026 at 10:29:56AM +0000, Jorge Bastos wrote:
> Are there any known or expected issues, if I were to use XFS with a 4K
> sector size with a drive that is 512B native other than possibly some
> wasted space and write amplification?
> 
> Mostly interested regarding any possible data integrity issues,
> 
> This would be caused by using an intermediate block device that always
> reports any device as (logical/physical): 512 bytes / 4096 bytes, and
> this results in XFS using a 4K sector size when creating the
> filesystem.

Yes, this is fine.
