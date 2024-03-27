Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B7552F7B
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538016; cv=none; b=u5u/TyLrf/LefQrRIfSdQ3hBMw24mm8Yh6Rqslzz8FMu2TP+IZ7A2WRNqiVL8tGFhQOEeRr2jLRS0Z3ijvOsvKc6Ww70Fqrw0Z+CfG5yngZY6bn5wtcfBgmcBoCU+TxQC5PiLJXMBIvWKNn1D1uN8eB6fkJKpTyYo6+h8BgeddU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538016; c=relaxed/simple;
	bh=r3YshpDeDaMr/uF/mh6lbOHMCEJhgCc+ZapCK+kxnJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmGYk+BCdBmmBRvF4R3Qcrf1/Ew00Yo0Vq8aI7w4awooBfM+qyNF5SKBxkUqSBLSImNn+upm9rmCgqEFQN+kQdQ/sBYNUshwEc179z+4KFxN/2H+zlSuCGaZf4J/XfEXpJDDaN8Ao3+qFCzF4DW1XqkUvPANv3dQmFjKDRo63+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xvwb8g/0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xvwb8g/0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v1hrEW/Upl8yutHNqurM4O3V/Ghy1hcySkjTvuVX5H4=; b=xvwb8g/0WQn2YsVolaxjGL3FHi
	L5+1ybXFECV9rXI/3ZofsrsP3L4qy7iaSOi2rzVCavn+WcSzlIr0FFwor74MRJYNXDIhSH+RQr6Pb
	g7QuyAoFOkxLGQYq3nTPulCA7RD4HpvOyby9ubpCUk6nQNhUHYtEKZs0g4QDiyDrLOAQsYSxiNf82
	QLRLsiJZuiYXSpdkyg6AGdI84UniWxCK6rRPy5ZWerqFC4IiqA/ljpH5xmA5oait1TkPwbu/h2Pzi
	SodCdY1v0kODMd8lVIRGkTt7YsmpniYKRNx4YELyLTmcMJi9SuM2gdC8+7g1ntXKaQhYG+Kx63egF
	3A/iyDQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRDq-00000008Z6p-2OBU;
	Wed, 27 Mar 2024 11:13:34 +0000
Date: Wed, 27 Mar 2024 04:13:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: reduce indenting in xfs_attr_node_list
Message-ID: <ZgP_Xn6zkn0TY7nm@infradead.org>
References: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
 <171150382175.3217370.15842303765544950135.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150382175.3217370.15842303765544950135.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 06:59:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reduce the indenting here so that we can add some things in the next
> patch without going over the column limits.

Wouldn't you normal say 'reduce indentation' and not 'reduce indenting'?

Either way the change looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

