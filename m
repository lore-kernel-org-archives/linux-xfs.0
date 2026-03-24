Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6915E3AB277
	for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2026 06:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774333005; cv=none; b=oolz0j9cMcw4CUI4/rKnf5Rirse5ViGXur4LoC9OY1y6ub6UIQM5WKG8daNEqrkfP1s4tdnet+tMDEpKUFIieDWDuOFVi9jg6IKomekIe0Q4FsyiDuBE9TB27ioA7fFYv6PBsv7CBVO9PP2tN5zvtwwLT0n5FDJZHCJxGBjBKw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774333005; c=relaxed/simple;
	bh=nFP+AsLI1AzAZeLgAJqBKDaNJDej4VCJItHrzONnW7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evUQNrcmia+9RQ42pN6Dvh1h9jDsxMcnyCOv/tajRvOvmLTrYCVWCWESJbnb3gn0//6yuxFwvJ4Fx1b9e0UqcwlcjB/wFndttvOMIrq6sbhReQcV9535foyJrThOv3k6O6IaxKoD7oRQ1l6AzP1z9Ly4r2DkelF+Htj/H0liJeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qUU/GAdH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qUU/GAdH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PqHCzvNAKDaoBzXppF65A2MIheyfckNwP5BxAEHDd4k=; b=qUU/GAdHqeZJ1frU2yAZiDFryt
	wensNzKj7NhWu5f+tDJqlGA4NsMRWb+D6VbNhtmlaruMUTyI2yku43ZxbAPt8F6XNnhKEitSWVgRH
	7S6uGKKXVgmC7p04sTnJW61C0x7mT66RBf7C3Ep3DCrqvwDTMiYcoLEs5BlK1KyvT6d+98fwg0FpG
	xqH/Eh8Coo1u1mGejs3pzk2YXW+66sjxQTtU5GiO1KTp6NgkdFxPUtJw2IOo79mA2589vAv/BNHLu
	zATSB1bAGe7tv6gt/eB1sW4WN2lFog7NM/UMfkYpdGTll2EeuyQ92eZ/LJ79l28ytN1atVfugdftG
	VMiKLMjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4v4D-00000000fw6-2Azm;
	Tue, 24 Mar 2026 06:16:41 +0000
Date: Mon, 23 Mar 2026 23:16:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/40] libxfs: port various kernel apis from 7.0
Message-ID: <acIsSch9HdMG0P64@infradead.org>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
 <177429120775.2266274.16124276962731944084.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177429120775.2266274.16124276962731944084.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 23, 2026 at 11:41:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Port more kernel APIs from Linux 7.0.

A little nitpicky, but this suggeste they were all added in Linux 7.0.
At least kmalloc_array is much older than that.

> +#define kcalloc(n, size, gfp)	kmalloc_array((n), (size), (gfp) | __GFP_ZERO)

Overly long line.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
