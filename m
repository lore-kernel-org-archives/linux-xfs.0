Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312E9485513
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183486; cv=none; b=HN+fXyiWmkkrDnQ8o9S48mRaKM4Xwp3NSdpDKhmEhUFRuPutINMhfzjdUKxhvP/2No44dGq/VpOLGAKQ61lC8VE4ka/tqLblbmR+BTas5LnxGMJGcwaX9H4atDXih3Dj/HMu1GhI1Fu3PodFWAFmKlkp5vKd8RiEyaJgZDrsRE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183486; c=relaxed/simple;
	bh=swZmhb+G6d4AE8sFhhtWWiwzuam7hBDj9u5fKz+ES8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxRnHPOiToEIqNNsELzkEMeDOoa/fZ/Tla8aDMuWlIgMy7H04vhcyRemy6W6JLuV0nDE/lBafYVKaKshRZZjz+R0z7tloIYw89bozAHuE7Fe8hGEnX/IN1wAB/jgpc0oeWhpNiDDlOgX2v2MnbUl3Mbz1t3O0EPUIPRE+FcVHFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XiLKKuHf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XiLKKuHf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vRzG+1E9r6+iikh8o4EciuXSNlr4KoNSJTqFjfujj+A=; b=XiLKKuHfgGqfm3A9NWSmmgWGeD
	fS/D2MVkNWOf9IL/9QThGvJHNteDQHlPLVW/e7TXsAAlUMOQFNcS+a9ZuNKkPP3+fwMqsrVeMRkl/
	1ukohnltx+x2sv/rR/d++7/BnnyhrceYrAUpal+1iEVQjbp9zfZLD/4XHPsl5D8S9mzuCTZzDgmTo
	EECAQFdcazsS/0mmQ95TKptWWAIYiPgCbrYIhhpnN7yKRhVxPt2TmkHaaDW1DcKf7B3NcoJMbEBcI
	HzGfiTZT3l7waiIDkDGkRGlXNPoDxSIaAD9/1/mOJDiue0renTOeEueThaKhLoGr/hGRI3WcOfc8c
	y/GSpw1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12D5-00000009Re5-30Km;
	Mon, 31 Aug 2026 13:38:03 +0000
Date: Mon, 31 Aug 2026 06:38:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] libxfs: don't corrupt a delwri list when a buffer is
 queued twice
Message-ID: <apWDuwumraY7BV1z@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <2bc415d28f12b661f5286c282cba597a33b9b0e8.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bc415d28f12b661f5286c282cba597a33b9b0e8.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 20, 2026 at 05:26:22PM -0700, Chris Wedgwood wrote:
> The kernel avoids this with the _XBF_DELWRI_Q flag.  There is no such
> flag in userspace, but list membership is an accurate substitute here
> because both xfs_buf_delwri_submit() and xfs_buf_delwri_cancel() remove
> entries with list_del_init(), so a buffer that is not on a list always
> has an empty b_list.

We could add the flag and make the code closer to the kernel, though.
Did you consider that, and if so what speaks against it?

