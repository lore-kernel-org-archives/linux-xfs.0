Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4072054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420509; cv=none; b=ilMaQDW2lmOAB3fIumZt64rfQzd3VQKaGasZMFB/jKt5W1drzYb8JxBluX3DBp7TUXX3UxYD0YP4wG6caNtyeib8GdUhLHdWzerky57of1eDRMwQwcEY1jAwOHCtLtSvRhI9qGIKuTM/MldPyh5FkZQfuyHmcc7J0OQZSXhZ3+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420509; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cs8p6S8C6ZCXuEQYfoSjtbyhzGJUKP/XVGHDT+ITzyRarktVJ6k/jFp9Ieo67Yk5HymkC/UQrTGmhq89v/whb76/tJMLvzxP7LFRNqc5RoZc43dopc8/6HTPeGCTb/TJjrHZI7Xa3cLzyoKSPTIKZbJ0r+7IjuITSvgcnSm8Erc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RqtinIEf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RqtinIEf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RqtinIEfMzGZ1yuYHf6hgSbm87
	HSAqJ9MEGzUCWPxNUnur/pHGMhcm2vPzJsi9tf47Rz+HxjWPqgw4gnsKYSMiWpjdsRnwxUJMI2+87
	S8jz7IU8XQtfx+3ZpW6BKAGm5vAu/Qvd08pauPWjuaF/tiCtIWC4tCcaD3CaFXBUf4IYbeC7IMAS1
	vzHyrTw69xqR/mn5x7SXdh0L0tkJdW4UCn9nUNCAVtFmy4h2QjGGwITGj62HdLf9nnKVcnibJFrGq
	+gDfK/pvqwrroJJWc7D/qH1UON22jqEscdArCtGQRkMxcBXBzshvOvrK3/PMStUCpv83GmAoNHr95
	nnbXyYCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQjU-00000009hww-0dMF;
	Thu, 13 Feb 2025 04:21:48 +0000
Date: Wed, 12 Feb 2025 20:21:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/22] man: document userspace API changes due to rt
 reflink
Message-ID: <Z61zXDfI9dtEuxtp@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089011.2741962.7359133860691988618.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089011.2741962.7359133860691988618.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

