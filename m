Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D39556440
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367860; cv=none; b=YV8ArmRk7zDo/57y4EPnlUzFdGQLOEe4r4CGdrdQ46GwcgQ5++lV2MhLfzTIQfLLdnAnfGlAEZf7XRJJO+wiRaG9TYAkeMhqxAeasQMgCIfHdGIJ6akJw4aui7HkBf2up99mAPv2d43uDwCKcitp8mhOtkMHZFzAQZ0AnmdM4Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367860; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QxSHTKLYm8pQ72P3NFgWaP1OGag80QiROppeED4r7OlSv7RpCAFfn33WAQ3nqAROeOqj0wo5chqVrOPTJwgsUAz7gf4jq2gR6m3jNZueAnngsEDAm2jTESPDQHtzcUBih4WGCHpwsDJdsJh4GALhUU+XA8N2BpM+SfAP+OdrTys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dgSxMP6G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dgSxMP6G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dgSxMP6GZJ3QjSp9uYoMgIXLWa
	bF3uKkTh5Z+aDpOVE0feyZYzzHTPDVLeQT6JF8RGqXcT3eu0M2AjNUjNQOTxES2CtATjBt0i6XMcd
	bY7TSS6Kh66KsLMVxFqcQqKrGkRI/t/CjkaKLM+ft5lu5jDxkaHFzgFT/lr1gUQTT7rILRDHt+FZx
	jLqhRMKxOCX76VOqjz9IORKQAAA4RNj5ln2gg641ApZDa2r41dEstcLvieWpn2mOCf/CzZFWi6ngn
	2csKs5t4AwI7PQFxsTGy3DJgtooeZV2m/FTY+/jJWOM6qrrYyckzddF2afVYtyDoWp3atR1MzU0Xs
	oKNeqgNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWoM-0000000C5p4-2MHV;
	Wed, 13 Mar 2024 22:10:58 +0000
Date: Wed, 13 Mar 2024 15:10:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: push inode buf and dinode pointers all
 the way to inode fork processing
Message-ID: <ZfIkckFZTpzsVJJj@infradead.org>
References: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
 <171029434340.2065697.11904740279941887091.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434340.2065697.11904740279941887091.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

