Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E82D26ACB;
	Wed, 19 Feb 2025 06:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945233; cv=none; b=lzbEIO6MGa4gcWqYEemMaCaf1SsIMncrAeNo0hGZGyet6TQklzJLVNs+vVRATXwNVpb1O+u4p5rzEW9Za23usQyTJA2xBPE1cBLxbmeosoZjNb5ndQAiwmR3+XaG/kVSDEH59lI1PzJTrnbt1VrPNP3gfPR/j9aGhP68bfvlZl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945233; c=relaxed/simple;
	bh=oPLjCEPZTlF48XyHC7oo6iB2MJp3f7XaeuLrhUdbfF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVlIGFLBCnKwJuLpMVonvEPLYVQcios8hLmqQwT2ygOTdofvVgATbhYeXnnzKgtoEEFZOj/Hddn0rMABdtRr054nTmpYgxP1AFCJzUr6p7oMZcN9ZNgYE05SUrlQPj4dJMCTbNOpKdALkQ4KHMun/5XsQ8s9F3NXq/SRBfn6VHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ca0/+E3c; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ca0/+E3c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WOd5aFmM0bualxlCrroCY2n8HtdccvkqNEIulOl0qtQ=; b=Ca0/+E3c7bzPObwJIJYidfYFtS
	ynyANNO5QLgIT81AKyTxV3fMD8gR+Z1DBZAazPWcFNoVfzbpF9/CH7CNJSD639qWp1GePHZVR5z3I
	RRE3GwHTAeMb3jfiKvQl++K5kqhFP8MlGZ71wBw+VjxZUi8tEknmwl9ttiF/vx7huXqjWboN+PwCW
	a3VVm2foCzHUJZwLB4Q96+Qbtik3ZufMix3agtfknIHd6sxrM4PSwiApzjPPOTImlPTju37bTDGdc
	UObkuQXsez//oYGlAtN0g2dhwBf+d9Gzp7mx2m4MjTMBEYvMuKVu4ehrySp0OOslfN/k14LZvmLrd
	UqdL6PeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdEm-0000000Azw8-0imb;
	Wed, 19 Feb 2025 06:07:12 +0000
Date: Tue, 18 Feb 2025 22:07:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 11/12] scrub: race metapath online fsck with fsstress
Message-ID: <Z7V1EJrpL5MS9hPq@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588262.4078751.10550660785587990131.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588262.4078751.10550660785587990131.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:56:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a pair of new tests to exercise fsstress vs. metapath repairs.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

