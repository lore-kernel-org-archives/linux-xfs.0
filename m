Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B6A168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808076; cv=none; b=Y6Waz3/N9BWg6UVWSbTL0MxSvAEw4ACXh9qtu2eGBWFuZ+Zzim/lKYw+O97buN1aQx2t7QbZYt2U31PPrCe6pyuID91PtoczEUke4hRHCEuL6RzRqcP7P2+dmTr2zr/fXKIzodhVrRJNpIW/Mzr1ZVXCr1Z6XIwO2dMzZCVrdmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808076; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMNEEoS5MlfDZcLMYW0KwUOuC6hcK2ZIQaGQKywLWS66wVIXJ7ziCfUoJPxrqObBorqOi8iPc71NTziFuGN8tsBkpZQmNksK7+GiwrlveCuZNOqo/nqlfONY3gEKqrfxZizO2o+Lu8oybvII8h62CRusxY9fvn/vFBVERqSPGeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VUS/SPkB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VUS/SPkB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VUS/SPkBYJHgXneCX6h5hhLukn
	X1HR1wl1b9zJrcqfwQIFojIEJKv26DsZyK+CDbSKqHI3mtd44LekeVqVb3NkNm7PtF0qkgsP5raLP
	mT9hJoiUtZsHzgzpKiEnDEytebmXJw13J4EAD2NlHOolCL7D5mxDNsncrl4Uhvvx4M5hQ5xQ+CoMV
	EaAT82sIC+ztjQzem6+YDOI4EkGz/2UVKwbmunLk0KZAOT4ofWQQ4Wukk2v85b9RyMjHAGMsltB9F
	Q+dXLA87RLAOQwVnryIDaKPs6eMPUe2mi1KckZv7RJq3jnyb5caeQzeiikUA3TiX5DQaFu67IDlom
	DCar03lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsgM-0000000AGZy-2oUr;
	Tue, 10 Dec 2024 05:21:14 +0000
Date: Mon, 9 Dec 2024 21:21:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/41] xfs_repair: do not count metadata directory files
 when doing quotacheck
Message-ID: <Z1fPyuEhBevJ_0bW@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748816.122992.7674899898311669166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748816.122992.7674899898311669166.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

