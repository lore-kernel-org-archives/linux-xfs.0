Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE3C184;
	Wed, 17 Dec 2025 10:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966898; cv=none; b=SMFAiQ0Ua1i9ZhycFl0iE0KCNnpq1JGKMvZcYO32cmy08Z1aZIHOrfGmaRduNK1g0dyiIq03I5Iq8tgsXDMcyvv0gg41zd4EsC9Exa5QjKQVgIfPbr5wSnnRfLigadBlusdeVHNYGKgnOH9skzVldqw28iGqfTuCsaSDr4TkH4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966898; c=relaxed/simple;
	bh=ANOvcozK8eWFLwOeyvSQ9Fshz9Dg84EcB19LObAbmfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PomB5P+T+9YtinHKG7Mi/ZlKrSkAtmLcWDc5F7cpVfOIiyHaWCw3wYEs4m0wa8UvRunbGm+7YR3ZlOqVWArVOWVFUCKv+Hq9PA7LMRmulhPU0HYrP4pHUL8y3bj+lAPKJXziBML0Y4FUIThCvHoJsQtdhqRBkPMogkN9HaCWm6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=brC0Oepy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="brC0Oepy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fpkm6EceW2lwEfW+KYaLXqwTZ2Rbo+YFDFZ8IaZPUQ4=; b=brC0Oepy95i++1L8OFRk9OkCIB
	W8MhMK/rHJYupP0vWuNpItVDKom1L+n3vjiWCT5XW5ncGtMSRX+MrSkJXiNGuFq7AJHPXuU4zvk2X
	4u/5nk1H+ouK6PocSwQcsKuKUwaLSSqebJijLofCJixZV900Ye6b9xcMJfJOSmpxnhT+g5RlDidaE
	B3bQ5Qhe0s+fLbbvMSntyYe3xSakDczx+yxEcedeoQORsUVuMqVLZAdSX6Ljrx4C3Wr6A5u1DsnY+
	wKfs8+9u5uUxmxV69vonDVpFFdTxfYF7DkpDTgH2vsovbkQwplhctNy4BD876fBfa9oAC91j38Y8f
	BFEVALRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVof2-00000006d9g-1ohV;
	Wed, 17 Dec 2025 10:21:36 +0000
Date: Wed, 17 Dec 2025 02:21:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] check: put temporary files in TMPDIR, not /tmp
Message-ID: <aUKEMFM_a8yU4CJb@infradead.org>
References: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
 <176590971736.3745129.17863225958624907500.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176590971736.3745129.17863225958624907500.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 16, 2025 at 10:29:25AM -0800, Darrick J. Wong wrote:
> Allow system administrators or fstests runners to set TMPDIR to a
> directory that won't get purged, and make fstests follow that.  Fix up
> generic/002 so that it doesn't use $tmp for paths on the test
> filesystem.

The second part feels like it's worth a separate patch to make it more
clearly stand out.  Either way all the changes looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

