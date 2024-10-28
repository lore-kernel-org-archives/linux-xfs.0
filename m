Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A94190692
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104959; cv=none; b=Q7mQLcis08X5oBIyjIFzfAe+6Ak2RJO4MvXXD4KO1g0jmgqFIJ0O4SF6ogDAVUYr8D/3UwTCcMvFd4NJkwYM/+LDeMClIuJUJY53isAmnZQCfDrG6Elk/kSNT65sCLVahVhykopL6vwehH77D8vtCuv43QpqkwDCoNgiOM3xKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104959; c=relaxed/simple;
	bh=hh7fa8sNgmSmlReGmrWvotk7NBNA0wTG7uWEnnqNDV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOppq0Q/kiQKpbFnTOIHfe7Y+re/HWfdBvC9iYnvjPxTHF5mQJEs7LBZ+gcHFDiCFHpnjfrw0ZGD0+1Pxo8AD55Sif3KRN32dmNPtCL3yka1Ry49mzZLGGeEWWWOTBIB1FFgTdk0vZtr49kNkx8mBklf6d2vwA17cmrMbIRxUPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mVN0L98G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mVN0L98G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hh7fa8sNgmSmlReGmrWvotk7NBNA0wTG7uWEnnqNDV8=; b=mVN0L98GuRsTwUtj2hgKYG6293
	JSbceNC4Q7Exsgg6Bapi4DACjLA/BDySxEW0DOluyKHS2pwwocyCrB3Ggdhr/C3JMlZP4BaRc3qR/
	yDYy2guc9RYlxOVCoxAoIKUBks/eyaXkpGBR/X8x87WqX+44YnJwgQ+qm0Trx2gDQ0qqZYiVcTh8Z
	mb1UgsFk+STtXTBjI7NJOZPKKitkFVJVUNN33qk0XWeI4m+UgGsfNRqQWzCUxRIJBdKNiCDWURAKe
	iGMPeH00bcz6jkQt8aG/i2+2plFQwFfHkqFQa+4ZcT26rFBjOKUh/AE1mg8uZ9gZHh9oIr+8+Yrzd
	hvhQ3w0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LKf-0000000A7yG-0r7F;
	Mon, 28 Oct 2024 08:42:37 +0000
Date: Mon, 28 Oct 2024 01:42:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs_db: convert rtsummary geometry
Message-ID: <Zx9OfSuGNzlOIRCK@infradead.org>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773849.3041229.954557022627805523.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773849.3041229.954557022627805523.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good modulo the whitespace nitpick from a few patches earlier:

Reviewed-by: Christoph Hellwig <hch@lst.de>

