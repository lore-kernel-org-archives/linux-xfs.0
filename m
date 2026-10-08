Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4669748E0FD;
	Thu,  8 Oct 2026 11:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460645; cv=none; b=WVTBQn9g0BzA+/OwqlDjKB9wqz4kAYR24ahrBojIVYMgEUHNzW9CZRFbiu6HhEpk8sKyi7iLnnznXLfT5cimQXnpv6Uqi843IpnQ+RCchfEjCNPOqdlsTY2AWIiwDL5ORbsnwNWpnXlpDv40CtVstkKJZ+AZjwFWVHbraURu4Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460645; c=relaxed/simple;
	bh=m9osr7uDUOryv2fLRYbvWWBimCt90Lr4jfZUgwypHUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BaWFs4MeUWjyAcIh+3hgy3maebX9uXw4a2NfDI+hE3JaGrHKSpNkfq7c/XTRsCdL3DgVMF9A+9lzJQdjAfHN8F+08j1BacRHNxDln13CMaQX4JCpT8I6Y6QYPfky2YCTHkBiZjwA2b+dJW+bO8QLL+AMykyiHtYqcaslvL+xw4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fmB5org2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fmB5org2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=esYYkwkr2Qtn+YpnjtIVJZf80rqD1n4layRMxsTQ0Lg=; b=fmB5org2npZeIt/aPRssrKs26O
	9bOcntlQR19ETo6qJ0bedSNbdO95k1AFdVZ/p9EyBOjjYSKFEZn4xQyf7huXAhYHrLwzaab0swHl8
	1Vo1D3K87W4thTpsSNDvI9ygslahgVkJk6K5ha/kcPVxVl4OUJEJ4dkTKyhD0RijVjyo9si5Uaivn
	RnI4ZWQOzFmOuNU8eyRG9CxGAf/McvhUajq2kQ0YS8SlA7/s97yqlZKrxgA7yDl8v15vXQx+kH0GC
	u1L9JlCGB+0QGlNQx/czJNSZbHvNkvtMLQdgFTQV/jzinaniqKTUy/ulzbKJS0kDLS4dJxWmoPMz5
	xM+HiZ6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmkV-00000004J0J-1nvv;
	Thu, 08 Oct 2026 11:57:23 +0000
Date: Thu, 8 Oct 2026 04:57:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: never reset the default quota timer
Message-ID: <aseFI0A467vTHgWo@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521363.2728617.14276632684472536968.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521363.2728617.14276632684472536968.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:56:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that xrep_quota_fix_timer doesn't check the dquot id,
> which means that it can inadvertently reset the default quota timer when
> we really meant to ensure that a (non-root) quota overage timeout has a
> sane timestamp.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

