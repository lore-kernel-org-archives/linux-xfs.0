Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35E637F326
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788761161; cv=none; b=lMAeiiiYVch1ehowyIDf3GGzLpDF+SO069uftjICTaJN8EEI/M9PdIFS5WBwuDdZGkFPoNS83ZE1Sygn9qxtKst4hHv198zfLQSDRF29sNdNl/NJEwQfzyNUt36IdG2d6yuyhGh/YiSDQ0MERj36JuxOdTpq/CC21SxsBiqWyH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788761161; c=relaxed/simple;
	bh=LYbwyXOc/Gq4Rnp2NvWE/AQ0KzpnzugRYzxhh9SrXHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+feeLod4o97GQ3JBgnSWJJSd3UDvCFxh7X1zJIe7sXqhMrad4R9IsWFCPv6FMYuLCJiRpl4LxJ0vRgsrp/H6Ym2JdyT0CjajTABjgQZwCB1AJ+5Ck2mdOd2gAhrnFGduC5fwnFM08SfvnM5rY+KVOqJ5YQcHuRJ3egDRWOYfZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RgRDvw3D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RgRDvw3D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tcWru1TKRIFEbuNvE09cq2BqiwYxr8DORMQM8osVopg=; b=RgRDvw3D+0jSUTuw4ntZRhOVmY
	MJ0As8vMjq2Rwesxrp81tFOkbWkttyH07yY3lJDU/+/bHs+bcT79LIF8gT3XCtPfGMttdO5xQF3cK
	3xI/Zfy+mc1mH+XGiBcSx0dd2Oxr6gUAA39fbuUonnGbWZiU/bAvWEeEy0acrnzh7sgc9lpd6gzjH
	FoMGgv1Aj0MBCGFKmvp4Rkw2RykjWIy/lnAdoBTuCaBPVGhL4TBXoJ060eTxUMBqogmOu/3mZUvFT
	KjHZy4fJ+QzzdouVuaVDe22tvoBR2avYwNXFP7cTu1sO5XLrsbmO3lcXNCXc34Wed83SsbRcVAj4T
	VdGnLC1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3SUR-00000005zTt-0UnO;
	Mon, 07 Sep 2026 06:05:59 +0000
Date: Sun, 6 Sep 2026 23:05:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] xfs: enable xfs_trans_cancel() to report and
 error code
Message-ID: <ap5UR8Wlz18xKXFX@infradead.org>
References: <20260904113231.1408890-1-cem@kernel.org>
 <20260904113231.1408890-3-cem@kernel.org>
 <20260905011054.GF1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905011054.GF1933798@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 04, 2026 at 06:10:54PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 04, 2026 at 01:32:22PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Once in a while it's useful to know exactly what kind of error caused a
> > transaction to be cancelled.
> > Enable xfs_trans_cancel() to receive an error code to be reported.
> 
> Stylistically I think I'd rather have an explicit @error and some macros
> to avoid the va_args machinery.
> 
> 
> void __xfs_trans_cancel(struct xfs_trans *tp, int error) {...}
> 
> #define xfs_trans_cancel(tp) __xfs_trans_cancel(tp, 0)
> #define xfs_trans_cancel_with(tp, error) __xfs_trans_cancel(tp, error)

Agreed.

