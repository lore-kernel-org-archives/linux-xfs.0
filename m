Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7D58BEC
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 03:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712806558; cv=none; b=LyiIF2K1CFCeVEilFITDNlzTMvwn0YJ0hkAi7vsKLhhuPFYvVTkY+xnDWIqa2cLEvVJwn0SjX2xeNVeunuOpTKyRr0W+08oNhFnF1j0LV6f+StW9cFRI1vlxGXLaUDBkQ0+d+gT8UahNcKo5pT0so551ChigyyYOWaom85jHyVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712806558; c=relaxed/simple;
	bh=FLsOHwomLf7uNCCzVismueP2wELOukwi+H3hT7oq4nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EdYKcW1IeK1S4/BQZIb+/Xm0GtGtrjN9xp+KzOZow2b3YTybV/o9RJpp0AyTx95sm6aWEPWU99Rq61zVsTkVGjsr0Dw0Nve1cPWEz0IRJdEDucSgiDMPBDhRfNeUxIgCatLanib558zELfB6LE3OlBZvsb9YYbA7WM6X+JYsJuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uHETCBu4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uHETCBu4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9jlr+pddrQ/KGF8/vp3nB8R/LoNinlImTJreUPSnWD0=; b=uHETCBu4nibOQq1YsdHLU/QyTk
	H86GyUnub+Xnmblrp3XOG2gBLCF+mHkRYW73gLxgCyrKQMM0cXQPinBgp+jR1J8yYrfMT5j9LsN11
	wW0/+JGd6RCUBMQnOTJKRTD8V7mESq7q5M8+8lvtztmV1qUASRPkcnC6e9Ow+8vy+uevn/Xv1UZg8
	bS/Jv4BQ2DQNuujmbEPYF+iloq0A6Zj7/7lrNFjOiO13LcEw2UFU5TZUfp8Td3bih6tqZTuMwnysx
	mQyfNUdApT48D9WQq0Uw58BvHiDoiNV4tn4aWOtH/wBhNKeiOox1v63qh8eq2r8hR/ksP7kNsAKRA
	ACBoZe+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rulEB-0000000ABLZ-3LVd;
	Thu, 11 Apr 2024 03:35:55 +0000
Date: Wed, 10 Apr 2024 20:35:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/32] xfs: log parent pointer xattr replace operations
Message-ID: <Zhdam609RlgkX4hF@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969740.3631889.12974902040083725812.stgit@frogsfrogsfrogs>
 <ZhYi73ThMtCUVrF5@infradead.org>
 <20240410230724.GN6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410230724.GN6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 04:07:24PM -0700, Darrick J. Wong wrote:
>     xfs: create attr log item opcodes and formats for parent pointers
> 
>     Make the necessary alterations to the extended attribute log intent item
>     ondisk format so that we can log parent pointer operations.  This
>     requires the creation of new opcodes specific to parent pointers, and a
>     new four-argument replace operation to handle renames.  At this point
>     this part of the patchset has changed so much from what Allison original
>     wrote that I no longer think her SoB applies.

Sounds good.

