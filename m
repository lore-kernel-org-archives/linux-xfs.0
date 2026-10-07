Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F47643744A;
	Wed,  7 Oct 2026 13:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378208; cv=none; b=W4NbC41T/nBY9ypOUv3+3BkCoRft7CtN2QURHPKclcxtZ1hAvptt+7aIuTXO2ahGtHhR24z2XQTREMB9G2D+KYx7sT9WNe9PcengzBj9aDv+FAYDnEeBZTNzal14EL961jm2pM/DH6K2cGGcuFXRHI5szIBrx2Gj969mgp+dAPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378208; c=relaxed/simple;
	bh=vlqZEELR4NSLW/D47HQpKzPby0PSBWXD8QFZwUT/TVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PAGapw+6tSwLMrp5CiaDNtTzpq1hkFe4yDiyiVejpj0MasR6yGBKq45CmQiq+oNmEd28Q/OQQVPP44SrCWhrSwnYFH/GTn60MYZe0YV8y6cYRRO/8gk6SCy7isYJzMlYFATwUkR3AY24aq+UIwymjo3/0SPBiMUVuadZzUJ4Cvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n57Pwmw1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n57Pwmw1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mOn+mqJeurC98z3/wQXnR1pvYYjsQqhe66N02S52vl4=; b=n57Pwmw1VfDWB3mQGCQO565ZkY
	WuBkmPNC81VawJh1KMw9vsP+NpN/8/Eq/ynRWbJ8F7pVe/YsNiaOrvwKoKE0o8P3wBgAYe0kjrXDP
	8+08Hk7lmqVRuR/bLzHEuuLKvbU5Y1sBEIjcvcqOo4bIKaAteLJ0XOntgT1CT2bUsxzl/LIDUjZW5
	ZrjD8PB8BLIL2XoA7IaRx1iBTLLGemnN67yngpbWnwSbqfgQ8Z1k2GfP0p8/xLiOVQrUisuYmZ1GY
	w7oN6Ewx6D4KYq/DbbNVfkz/f3v68jFzKYD1hIVgGrOci2tfNRPUJtLwlHf6o5WyR1675yMTuTUTm
	amrtCPTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERIk-00000002Uzm-3Gmr;
	Wed, 07 Oct 2026 13:03:18 +0000
Date: Wed, 7 Oct 2026 06:03:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: zero out di_metatype when removing the
 metadir file iflag
Message-ID: <asZDFkqHHvNFCRq6@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965051.614350.759924722702194200.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965051.614350.759924722702194200.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:55:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM pointed out that we should zero di_metatype (fka di_onlink) when
> we're clearing the METADIR inode flag because the file is no longer a
> metadata file.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

