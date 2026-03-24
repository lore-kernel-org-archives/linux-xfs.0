Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576323AEF21
	for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2026 06:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774333077; cv=none; b=FCaO8woF1a5W6EELMiDU+3Vq0zqcUVvccihTARfbeWz2bkTIfifwIG/toAEWo8zveu6yPE3BSLKC9moGCvq1710KTYaA7CKlBaIZKeKhXRaaPYDRdL48ib74owy5EfbxOg8r4A3K2JYd3ohZWiXiTaWX4UZ12oFEOpr78JZy3Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774333077; c=relaxed/simple;
	bh=tpBummi47g/nNpeG8hQrGi9Q4RcTz6qnxvii+yVB/h4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUBgKQUYGvc7MUO6vSx+nMWiRkJRnN0tsPWjV9KHyjEI7uIV4Kd26yZYhu52YTVfBjwgpPoK0mYvum0Jw7xtBK5Lb2wjOh7TWtE1BSpahZTiYfSOHUYRAlpScXYaeDDBA/UyVK51SjoanrmbUl5lxvNcikK/5JaVJef3YyjAi/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cj8wirM+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cj8wirM+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=czLqBqBZo/N34wMZZrr6LfK228H/LuVNj6+x9GfFAwE=; b=Cj8wirM+HBapsWTFHkElP5vTPp
	04ME6JFo/Dj3K7kQ71pcf//izlbwVD06NmSX17bciUzdM3UECLyS/4VeirTfnS90JsyfTnm+KBPxX
	4RDWqgKj8rbbNDwKMOysGLu2eq/P5BlKU+6dbYCePIV1J3GHXGioVtTGGmRT5PmhJiPxK7HJYoXfO
	CpUcwag9RmYbujtJe6PmrJCDKgjrxy6Oi3IAl0WPQHxT61qCLwxvfIC7UmWI/cOut+R3F298t5vkX
	mMPHkFU99o+CEHQqSCAYj0+3BIVI1yjr3IDFeso/dBzRQGHO76T5aiUG4PyWKdwNGEWoobzP4QZDF
	PZPesKxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4v5L-00000000fyi-3gv5;
	Tue, 24 Mar 2026 06:17:51 +0000
Date: Mon, 23 Mar 2026 23:17:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Long Li <leo.lilong@huawei.com>,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs: don't expose stale pointers to callers of
 xlog_recover_iget
Message-ID: <acIsjx8FMnv1tDVY@infradead.org>
References: <20260323210157.GM6223@frogsfrogsfrogs>
 <20260323210351.GN6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323210351.GN6223@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 23, 2026 at 02:03:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this function to avoid exposing a stale pointer to the caller when
> returning an error code after dqattach fails.

I still think this is silly.  

> Cc: <stable@vger.kernel.org> # v5.15
> Fixes: 4bc619833f738f ("xfs: refactor xfs_iget calls from log intent recovery")

.. and certainly does not actually fix anything.
