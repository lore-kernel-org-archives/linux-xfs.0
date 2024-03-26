Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34161823C7
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431880; cv=none; b=DaWPih7PMAVhKAdfGeCwSv5v3UjjBLUPir//ClLMN49sJS4JbGc9pTq/6rCb9/N2kb3H9O8g8nPHKTXegpc4APT1C/+66T07t2KyHpWhUOYjWZW7/Er1Ba9dtxD8PLWU3FkNyNzvJt+INxFxjzlYCMsCvXQeBIpDm2ZpKUEScUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431880; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyfhCLhy4j+Ztp+ijZCq8HUCL9oYG83h2tJb83FVV7fXXfz9E+qZrSr8xAeWo3vPdm7tQk2i7TZKz44LXQASXD0fcX9pWOpDbpQoA1dD12nluA9elYlgfUem79pySgt1LA5uX39xoJlMdOWNnpyhDJ1LGnXFHuYujLij7FLFmDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dsyZMX+A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dsyZMX+A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dsyZMX+AO3QpPy3U6HMrgE8ghF
	r4fHVFyX8Yy71K3Y3vOHw7tbDMrVuZCjvEthcQuS09uR4iBx2Io9xwoCf1x5boHtOuhJGg68bux6Z
	Cz3txH4wintvLv2mK5cAyUfupmGWqi0rAbdlTo5bcFb1Hu0MIO8UM4w3SYYML2UxRuO0/YNiq6TVp
	IqhOvSkdtdk5aT/z8hde5owafLfKKVBkHhfd1J653nDBsk5ZLZMcS9mEykThmQNW30AwPvmW5o6pw
	k1/K5NpYHxzvtf5amQ1dkTNxyRYEoAa75GbJnXqvzCZDTmdjGgsMEsJzPcRViZwdaCrqXZl4cDmxR
	uYtDNE1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozby-00000003Af9-3QL2;
	Tue, 26 Mar 2024 05:44:38 +0000
Date: Mon, 25 Mar 2024 22:44:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: update health status if we get a clean
 bill of health
Message-ID: <ZgJgxr5UTxxz2vVN@infradead.org>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
 <171142134352.2218196.1061886253403832667.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134352.2218196.1061886253403832667.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
