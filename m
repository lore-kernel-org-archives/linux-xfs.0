Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798BF482D3
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367448; cv=none; b=rRZgOIPh5iTMGxQx0BhkNXDvBwSyTJ3YqB9HsOPt8MCPzOa6pSneyq7ADjff6OgH+IKgbSeYO50p4ohjaumMx23nsaAHZEuGPhMMy+lfPSpQdmctuq6Lt9Xo03c5nsDIpvmWBTi2blb6VNY7lwLkMqmICKsV7MITWjl0m3mvlhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367448; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6u6OvJ9AU6MVcyqaHMNbnC04VN5j3E+5DkdXtHy523HHZBwY+jQ1poAYBI0eieJuiBOXnCN/3K2MP01slygdcI+t15vznn5qkJZ/DhGZF2HDPnLwxPZx6M7Rj5+I2VKGD5LRc1uRLl0DJVn4YKQNRHalLKPgDVmin7reTNi/Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i57DfobB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i57DfobB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=i57DfobBBup3UFajBGEP4buMRE
	xHjShKv908+/PX5hBdL58Dw8UhmyDfh/++Wt+ZdchZTRuf1tZ18QhGFNayC1RpGNZSoqpD/yRDlxM
	y54K3pQ1ChNxRtKnh5rZn919rLs4ThgkUMu0kNXgfohSQTCGbBEeSFSvucrR1wjf9I75fEsgB0DLJ
	TJm+eK21sbg1GUwAeKvFmOpcs59b3ZqVcV6Iju7fhqzsnJPSGe5y4uB75wNYbi/KLOblE04rbmNgx
	FyJGcDS010GX4ih1Iul9sZiW/gjjsmBBniwHFmmzrCk2zYUkK1cTIFQUrnLJwO3c4p7XjunuJ0eAd
	VL/3aTWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWhj-0000000C4DL-0TfE;
	Wed, 13 Mar 2024 22:04:07 +0000
Date: Wed, 13 Mar 2024 15:04:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: adjust btree bulkloading slack
 computations to match online repair
Message-ID: <ZfIi1yrR_C7pczOJ@infradead.org>
References: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
 <171029432516.2063452.11265636611489161443.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029432516.2063452.11265636611489161443.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
