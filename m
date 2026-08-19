Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3726A1AC;
	Wed, 19 Aug 2026 06:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120698; cv=none; b=INx91aZN177Ixr26k+2Pb5RGBBvnPs42MQZRBYfQrb1bmOsKjcscz5nl5KnnwsorYJdyemmG3d+bESJfdwM3tEtgREEbe2w/avN3HpF/8JML3xoSx2FbXzlUQYkQR0GZ/UY9bpnKBe64VsO0SbCIaF6RBSKcZawOpTXktj+eOgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120698; c=relaxed/simple;
	bh=Nqm1JcVEbOzWDFozgj3DPQHlx6BRNoGhUoL2Dwphh1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hoUu/i0ZNlYQHjMkOW47aanbkpnIdWTJMUmkxB+UrL3ap1tR7LdV7X+b1MHJeTfLS7rHT7US7c4/rgR8MktlZccOkvylp9Rw9y+U42H3s0MxgGBrIGRfEwiZ9Y2w8CKNvihEZUp6rEdZbisySUPyJMIKugEn52eGUY25+QFYSFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hk4zlAF/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hk4zlAF/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NL9w9W/oPo0M5ZdeIDoObDAdHziLKBHbCH3HdoWhff0=; b=Hk4zlAF//BxJhmDXbS2EhXY2Ul
	0XkiwOKYsMODQHf9CNON3E8nWvQdmp4iS/GRuTECWD7Eula4k1azEkMgwXOrS+1g8xzXTPhWNQu7N
	ecffkMxGbjv/yyMq1t3DM4kUPEWUSyZcdDfDlt+h05FUaCwsaXtS6lrzq59ELJcLCU1R+BUpGtzLP
	nvxEmOJkMvToa8vZc1ipG98lga+ErC2ulFrG7n7Jkc3kRJn3/E2TW8pSdSP+we22NyboPQ5tY73I4
	spPXkA+2qaVimn02OVhHs3/bPVSv5lu7KG2W30/gESbO3zNcnsYUTqv3lAs0jXa81uK68RuMFXoDa
	rQ4fe9lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZjM-0000000965i-0qNH;
	Wed, 19 Aug 2026 06:24:56 +0000
Date: Tue, 18 Aug 2026 23:24:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: fix bnobt repair space reservation disposal
 failure
Message-ID: <aoVMOJX0jvb_vMYB@infradead.org>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659862005.833922.13291793696473888206.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178659862005.833922.13291793696473888206.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 12, 2026 at 10:26:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that we don't bubble failures from xrep_abt_dispose_one
> upwards in the callstack.  A failure to clean up the space used (or
> reserved but not used) by the new bnobt/cntbt should be reported.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

