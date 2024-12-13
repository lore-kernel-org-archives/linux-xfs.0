Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D80D18E377
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081200; cv=none; b=GqDb576kh+Hp+j159QYH41TJqktDPHBf/YF7BarIlJRrJhHgVHt/Yp+JU3Gx93pRb7NfVGt8JdM1808XmJSO3nGPus0JsDoGa99kwoK6SDAPufcdEl+kmXS1l2gI/wWsaFWe381+DgvLUPZWae/RyKz3qcTjdbVtPWcpz4RYK1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081200; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjhuTrp2cgCb67O/K8lAU6psgMBVrBCN8Q6dJB/yBRfuzUUxKxT5BRs2yHwLOKPTnhug95Hq5mLnoZuA5RUVR2vrCRglkm+cIs7twB1bsnSFxyuJ5TvskzKNEndsM09Bvr2oNtzs7xTP89kZkfQ5dA5O3I95RGlaZiD262lZeAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1yDYjF1M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1yDYjF1M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1yDYjF1Mt8XRkypqJIMtJAnO2H
	h+bShyt8UvrCBEuKSq5+Y5NzfCZzLWKqTEdtSx+zA5sf1nvmcE3MLdfEPwD7iGhW71w1T8EHyfH8d
	dYGX1JnAlPNRlbzvLyeF5gI8uvZDOyihZVLkRPw1Ie4rVLClVptmLATOfIUBC0ARagtCDP2dV/0dT
	cVjNl+PTvwxHGH/gJmPFU3LyQx/eKx5eTKLt3Vvux7JxnWxXMYfmLFFXFo0c2P1QjGRa4N3mM/83t
	PDHpg9SpQRw5KVIEG44dUCL3amWenQxF6fWGPlQZP2wGFSGxMhpHfUf2XuhtRB8atbMACSCmklso2
	kHUdOAEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1ja-00000003Cj8-3as3;
	Fri, 13 Dec 2024 09:13:18 +0000
Date: Fri, 13 Dec 2024 01:13:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/43] xfs: update rmap to allow cow staging extents in
 the rt rmap
Message-ID: <Z1v6ruzEYi6aE_W0@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124842.1182620.13179868316310661730.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124842.1182620.13179868316310661730.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

