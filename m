Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5062E23BF
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 03:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712806180; cv=none; b=DSkRmmIXbygmToDvsQr+fepsPPb316JqKfbIOU61AZBacczwQvJMOpB+NlzGKV7uL9+4ydtK8sSdem35hDxEyriKBAgJZZyxEH1rEEcuh0HcOCQMVXkzpADv7YIG9r3C3++I/d03DbGFTBKu57pBiVcIh+E3KRiRAItm0BbbaJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712806180; c=relaxed/simple;
	bh=duer+1EPrpMxE5/L5RHoKIlor2alCBOeo/HtlFsCays=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/l/1fxy8DLbNCXBKgo9rkGtWfjts6sdukWcfCkDUYAeuwn+SddOjOUnQy+45UBhH7YhVbLYKkB11ZG6Q1Mkz7elDX6s9Af+9twloL6ZE0sQZddjA+2ABvfUb/Q+cyWnOwKa9Hyb3hfnELawZKIcPELnf1T4AQbrXslld6j5w7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZlvdB2TW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZlvdB2TW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6UBqnLaKG/9xdIIygAAIP6C/gug0LDPDc4bRmO1zBDI=; b=ZlvdB2TW7A+kgdDjrheo6Ei6Fy
	d7Ebsfum+LBcyW/VdBWcgGhfBG7iXWgf2NCUEYsGAe2dIZqBXtMA9DNE+uKah3YWnhRTehMpKOe+n
	FirH+vQhfjLD8oEolIxq2eqZP7udg1hJa1QDrdry6t5EUAN1U4bEOP3l8cfJ8l1QG4//NCRuD3tP4
	ZmxQDDpFt2gmzHvl1icc2cp87zKsLLW+MtGUGBCzYEhOK5lpaaZmEUyS5phmLKWHaa3Bc9+T4YWef
	plIWTxtCwXFV6hLbgcCQBvAY6UJQs7Ai0x9cCl8JWzsPWxCn+UOckNaItX+rWVwc06nkknOfJjYzg
	DQX1/Ohg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rul85-0000000A9yq-2rU4;
	Thu, 11 Apr 2024 03:29:37 +0000
Date: Wed, 10 Apr 2024 20:29:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/32] xfs: Filter XFS_ATTR_PARENT for getfattr
Message-ID: <ZhdZIStaD--Hdk3g@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969941.3631889.11060276222007768999.stgit@frogsfrogsfrogs>
 <ZhYo1hcMYpYQ4gcv@infradead.org>
 <20240410215827.GH6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410215827.GH6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 02:58:27PM -0700, Darrick J. Wong wrote:
> "xfs: don't return XFS_ATTR_PARENT attributes via listxattr
> 
> "Parent pointers are internal filesystem metadata.  They're not intended
> to be directly visible to userspace, so filter them out of
> xfs_xattr_put_listent so that they don't appear in listxattr."

Looks good.

> > However I'd make it part of the top of file comment above the include
> > statements.  And please add it in a separate commit as it has nothing
> > to do with the other changes here.
> 
> Or just get rid of the comment entirely?  It came from the verity
> series.

Fine with me.

