Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8141112BF21
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 12:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714047482; cv=none; b=C//2GLVixoJvFhqMDvbooL7xNDG7xsJkb04xmxUPgV56y2XSsoZWySmIzsQN4wVVQjYEbAPpga5OPsUdJdFqpKo33pv4kPeINsy5AbE6QyYUvWYOS9grCJzYA2Z8YUq942D2Auz7e4HA4tYux2YPCW/CrkMqkSxfQqjb7HQgBPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714047482; c=relaxed/simple;
	bh=XVLyOrl/vAp93gMFTLIt/aF1VduUuK+paFQIQ6+r6Mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jbqijtnoxuq9y2FjSNPnMDS/BDpAxsFW2TvPeYR1TcWBI3WnZtAGlcWUSjsTsi1i9VSm/HdKAzpVqllqIoBVMBfIYnXPW7o4OQaYUSm+v3QLUfmWGBhNg21LlviZytnUrvIUeHnpOyeEWiCqrYE90h+MEkLAkCpitMBRbYtzJR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aj6l/+rM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aj6l/+rM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p/+ZMg2mn8BFZjEBN7fZ3aX1VQNOPix8A4Ax+ln3F7E=; b=aj6l/+rMgpfYdCmRtBtN+8Mbd/
	7O9AlYzdhFYsxxwV1nQ5UrxK4gITmFRz6HegNeC3suewLKZG9gYDpEBtSYaVDe6pKFuJ6kBiFtwe2
	dc0PRPQJ0P6+KE/WcrAkHxyCuTz8gmepJM0wmZV17Ia63feA80XKZRC8SEVyuD75JdetIh67deKZj
	UFghgIVSv3nX96+eOhIAM8y9wOJXIL4JPFJWG+EZrkpbWygo/NIkmcxx5ulFCvHaX2GendNhSWDM7
	SuCaFSihwnM7ctpRo5XJofugKpv1/opWzI8QwqNeQ+FLlMKMRdP3wc+jFxua4If5ZUqqtO781AE2s
	l8vWcUdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzy36-00000008BKQ-0OOi;
	Thu, 25 Apr 2024 12:18:00 +0000
Date: Thu, 25 Apr 2024 05:18:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Clear W=1 warning in
 xfs_trans_unreserve_and_mod_sb():
Message-ID: <ZipJ-GWpbqQ00Cib@infradead.org>
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425120846.707829-3-john.g.garry@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	int __maybe_unused	error;

error is gone in for-next.

