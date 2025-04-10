Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089B31372;
	Thu, 10 Apr 2025 05:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744263415; cv=none; b=Npq2Fo56fjMka/40SbyWeqg/bKuotnYSHpg2B3vxuMCgXGlEdf+44yFWv0aKrFhTwmCHb2fS26s7RSGX5hhnr2dfFIlu72yZK6KPE1E9Bxi7k/sy+xi5UnbFF84Om9kNyS2FTMPh60Du+dDWyPBLJnvxoNFQ1WN7TOV0JD9YJh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744263415; c=relaxed/simple;
	bh=Hl1N1Bte9PfCkzE50+BZ1+BnFMQcJzWxwzdzT8jRwlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhYV4H47wEhcGOlwdQ44zDgjRpw0e5rtDT2j5Izw9wbRWyCkrOVTYtH5UNG3mRczgoiL/r63WmgCG+wevA9c4xFMv50eZv+jPRnEp34/0CpFvRwhenUlsZjcQQf3P/jgKaxN9eas7FA7Hl/65GKhU0quOl7YnWXyVVAnNU/+yzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t8Ya/5OG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t8Ya/5OG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tBeAOOfulm2vca7SNjFJ7tuuhx+1DTdxXm/ahl7PTfA=; b=t8Ya/5OGV/MUNiURuMEpNS8pbn
	Vqc2BDZSVTjbS8bstMrNT+tutljdvg5Q5A9i0lhAFYTvvV6lwYaH8/58gygfzagZZEpveiq6J7bdD
	/ewFmUO0k+3R5xbjddBzvJYbshPdofkNS6/2SJGdraj+SVjD3pReeDGDkufVXHio/BL5VnP2TNemX
	ARECCdHgfiXafMByNllcrLhwV/vxfI8IFTfq4vP3kk/TIY7/1Cw/RGSRjlNblVooSdSiZyOyDdh8v
	1e1JPyTTbnhrxRqkkxS3x20Bgarpp2megtlkYDFPOS5Y2wFWb4hrIOU8sPA/3P5AMT/yyluslx7mu
	4qdw7NOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2kar-00000009IFL-2hOY;
	Thu, 10 Apr 2025 05:36:53 +0000
Date: Wed, 9 Apr 2025 22:36:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/801: provide missing sysfs-dump function
Message-ID: <Z_dY9WyhMrj5EM9o@infradead.org>
References: <20250408181732.GH6274@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408181732.GH6274@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 08, 2025 at 11:17:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test uses sysfs-dump to capture THP diagnostic information to
> $seqres.full.  Unfortunately, that's not a standard program (it's one of
> my many tools) and I forgot to paste the script into the test.  Hence
> it's been broken since merge for everyone else.  Fix it.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

