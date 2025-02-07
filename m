Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD9863D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905688; cv=none; b=XP2Zi6iud4/4nhAUVirCWGujVD5bZMEteC3PQtJGOf2nL0YPOLWYJMiae3LWyDbUiVl+PGEwhcm834IrI9yeno0Q5IXeZu+M1xeF1FqxFdQ6b/bgNzc+GL9w05bkWOZyIwsJr7GCQsUaOzlDEerj1w5UuA/4gg1EZMRIFEBOhuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905688; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZBZM1lJXNUumKB4D8+ot041V+8ZQyWnYvU+fD46SWuUq12ooM7jF1joatiYDC6rsx+QS/PkEM+Ty2ocpcucytY6QDpXFvYxwTDmG0NIOad+hWl1OguRsed1+hTvYf3E05X6Csj9r5jkH+TBT+F4b1E0+hlzLj3M8aQPf/71B2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0JOjnk5E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0JOjnk5E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0JOjnk5EqRUlJOTdBHa4R0zRIF
	3mYaTroH06Q5pU1MrowM37aK3FfpxW6Za7IsrjyTRPBZ6lnIzE9m9fel0mdW1mnprqWlYM41hW7iL
	2ELJnwOQPmIismGVNoEFJsN+Oa6CqEbQUIGNYHIzJHKabRVoKSOSg4i8/+Pir/p5ajPVO1ge4Rojc
	2oTB79rxPHEfDp1Za0yNm4dnZEVmd3BmJCtLw8OXmbg+UcuG7zTBwbCYxfodnIdKuGPtAd9NE3NbF
	GiJ5uYD6kvF4KzYb9vrc/Rg83c0XquYMyGunEnu1h2j3Of6ztsoW3ccBToX9PnjdDYB0DHaHWbm/D
	S4TbKi9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGnv-00000008MM8-0V9P;
	Fri, 07 Feb 2025 05:21:27 +0000
Date: Thu, 6 Feb 2025 21:21:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/27] xfs_repair: flag suspect long-format btree blocks
Message-ID: <Z6WYVxUBonH1Sho_@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088311.2741033.11494162687682570792.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088311.2741033.11494162687682570792.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

