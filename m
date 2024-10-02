Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB9C11187
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848338; cv=none; b=ZaFx6buea1rX6XmQyA2cjoU5gYi0IiZwMpXHcBDRzwL5KR6BlG5KCJoBJVcZgIDstQ1rYSIrL+I8Bb+KkdK7h9mZ40eHQnFIS+uKMm1TAYoNyKVt2ibNzi0ZSQM/36f1Ex+AwsvlcLknlBQuV09KVOYm//lcGn1R59/ZxvU8MUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848338; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2xh1KkGbxz92jNP0OVWKxo4Z1v0ZMW9cniUwhBalT3zNI1KkwUbtPjcH1JpiafcwIHFE92jsXNDfyUQ9qU2zZlSpc8eSRX50oLqxGA7Pe+xx8EeCgJbJwTNyLLDlTjYSBDuFBnxCjhypWqbFWu0Ksy0zRwpqwhJf9Q6j1NjjrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=omKO+2bV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="omKO+2bV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=omKO+2bVhF/z8M+WfPBSDkHIyO
	Qe9sK6QzuNcrP5qUgaYTdfEMOSVIU30/omaaRJXfTW+SkwriEJWJMjQhh0zeg4sQlK79wDTy/inZQ
	fw388s6jCqbeCVtw11lApkGRIKyCu/hDYMT4oN/Ru/CxAj2af+Gpwcs6hyYzzjeDd2RMMXAvZh0xd
	KoLdqoAAcwRFAYhkXvT9HX160NWP8cCCzC2FQ8zCGByKLanrN35wWTkxqbmi97icEqTUyTCd26Ot2
	ydNI2OIHDybdlJkfZDDt6njlhqOSfMgJ5eD8WnFzFhLP0LgJyorUh/GW0VsTNungjx2Sb+3JqghRq
	4NiULECQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsHY-00000004sCG-2T3z;
	Wed, 02 Oct 2024 05:52:16 +0000
Date: Tue, 1 Oct 2024 22:52:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_db: port the unlink command to use
 libxfs_droplink
Message-ID: <ZvzfkAJAUVelE6nH@infradead.org>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
 <172783103046.4038482.15065839752033832714.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103046.4038482.15065839752033832714.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

