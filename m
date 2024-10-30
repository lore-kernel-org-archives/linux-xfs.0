Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46AF8F58
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 04:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730262975; cv=none; b=WEpQfb/QsVGCyTZuybrwHUxA4cRJDMyVF2UN8mr/o4KKgpt+ng9D0q86i3bZkW/JHxZTBXVzyJiMRjKHMBEyoiCtAeRl5twLy8Hr0o1+Dh8zs4xxpWx3eiwTdBkLVYJB8YXuiRIyQmBdsrK1bbMq4gWON7uEvkwGi4+/E96wrNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730262975; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OV1Zkb9YmZVPj/YjqwtH9lDzg7oG7EcAtWBDBxwVr+Qh6LOPXaCynUyT90w23NUo3YW0idRkKmvqU0r0TDKmHRDnE8VIRaT5niT7lFXG3QZnFxtwvuQMZiymuV09R7L0IjZiEgjTp/i1+W+9YwFJzlOHZDxa+hfT9K21xyiyBoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LmgCh0ob; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LmgCh0ob"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LmgCh0ob2h3LuYKGBu93oq04gx
	PWTnBTWK+r4jbjHH826hFxkdN3RNsgRt/UsySst9KA3xM2dpo70lBiwRsNN4vk+Ohjzyvl03aqZ2p
	7Ppw3SyRo6TVJBCJ14Ts6VpAovtSLIlUlhEIRiGU+Ufjh72ugiZp7NTdLQ6BfgQAHMHIZ5lkr2JKj
	1IE4V5kDNF8SloPC4mvXbhidS0KoUPoD4ThGsWEUrf7yesPJDyE+KQexNL8UodJHH+MMaeV7b/eKB
	0cORTyCfOCXtV6yhVJf9tGJWIswdnmOLDvOL8ynEZPK14X1lzkO77WilJ+EB7tKp3dLnFT73xRUCX
	qkYBWyAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t60RJ-0000000GgQ1-0ZeP;
	Wed, 30 Oct 2024 04:36:13 +0000
Date: Tue, 29 Oct 2024 21:36:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/1] mkfs: add a config file for 6.12 LTS kernels
Message-ID: <ZyG3vX-GHmYU-UST@infradead.org>
References: <173021673665.3129044.1694990541450985907.stgit@frogsfrogsfrogs>
 <173021673679.3129044.709345968312824752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173021673679.3129044.709345968312824752.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

