Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4571C84BC
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990948; cv=none; b=CuZTEg274G5wSAHouefDS2eA9AiJH+A7Hzb+/vq5UmrV9c9Zf4c0Ic5KNKeeqIPqtno4fR6mzzs1XoBrRfU7zLk0P73m6tamMHkMJXRRuJ2Wymf6sdTUSqM1FXI0tP2Z7hsptdQgS3GAIt7DMcHO3jg0j0Ou0KYvHZGakF4mYDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990948; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=seJxCjnsZtuPiUg1fz3IA6Zng8VuUhspFA2MdB5Z3UqeYAZv/eRdKY/iv40hg7okxWwugLBk++7opl+1/+lsvJO1VPfLmvA7fgTc8UurR8zEwGDruM5ivDlGZ51pXE5ByXMvZKpbDd1F497B1YY1O9h+bKsMszzCNUBzABkjTJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PQ3BCpKy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PQ3BCpKy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PQ3BCpKykMYPk52rDlyY37QxmO
	11qI++EB6rhHhf/xMBuYJXp3dF1XPM7tZzdU9PoEPuFlD8KR9O6hNsAdtguBSELam0cqYDT3lpjRA
	PP5iHRGF2fedmOjS4X7BkUteczAE+tKbroynPHqeptlMhBzK+v2KqbPLNYQNNy9alNCC6ES0QGBh0
	Xy//f7ShhmhWl7u7Xb9ZGNemzQIrOkTjnAQhIiI0Wg2Iq0P/AsoYBaB3V/uhowXLsbC03aZbn4LDm
	j2Th8wsM6Sj0zTjU9tuDFfBNFtIe23qkmoPV0/2xsL2Z7EhMY30UcR6seuA0tSgVsHypnS3s3d4HB
	hrdzT1yA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U5D-0000000CDgh-17Lu;
	Fri, 20 Mar 2026 07:15:47 +0000
Date: Fri, 20 Mar 2026 00:15:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs_scrub: move failmap and other outputs into
 read_verify_pool
Message-ID: <abz0IxtqaKhJWKnn@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507271.3681140.5292119981731389533.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507271.3681140.5292119981731389533.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

