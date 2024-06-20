Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB902B9BE;
	Thu, 20 Jun 2024 04:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718857461; cv=none; b=u0yrhYtfCs7mZ4q7y6uyp3OMsyuFv+HrOIsU0n/amgI2aOY4LmGSZPVYg+Fin8C1t+CbNQ7z+5mt4HjNYn0HbrLiW2wwFhB6EJLYIM4R4UxN9m+my5tCDpNSxjHF5ANcwS1uqlxWPMazMw400McWWSSvlI0bU4mxQom4D0V+otw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718857461; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0ttAXF33wfyNBACfFHx3uYPDzAzkeJxQTCP7EzLtYwWpve7Xq8iupTENAYN8tYr/GXdW+UeIWJv7+PrsXAmAmTY/K7dVumKW1EiLfLRZuemTHM6TjF7ojEISaFol7pr6kvlxT2KZtydmAnxBE8Aa6aPoHZRf6gJufRCeeEdr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Zt1xN9+v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zt1xN9+v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Zt1xN9+vIBd1H/6Tb13+fDTpqX
	8AgHp1bTG9ylgidXoMO22AeekgVoj4kHO171lHqzvmAZRO7HAlHyavN1F8HWfSJUwrCs1DAGPR92P
	LRjKUK06LLSic06G90Ojr1nuxR2GGuavsPH9aj45h1rfFqrMbXqTAp6ND3lnfDFS7I9aC01xmP3BE
	SUfDQtb6IA0w4XcKRcdQYUt8UehGvmPQwg7Zsu4K9njGaO1s0Wjz/47hRrwUdpMns+DVy6lBPDocS
	VhqMiPPyWtLAOpO3g27Oc/OUPaXdYWFWVhQlgaBV0SHCPqHPoFM7w85t2+tas6+9IIkvY4QElc3Zy
	ij9dy2Mg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sK9LP-00000003ZSH-1nCa;
	Thu, 20 Jun 2024 04:24:19 +0000
Date: Wed, 19 Jun 2024 21:24:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 1/1] xfs: test scaling of the mkfs concurrency
 options
Message-ID: <ZnOu8wT9MWszY8kz@infradead.org>
References: <171867144916.793370.13284581064185044269.stgit@frogsfrogsfrogs>
 <171867144932.793370.9007901197841846249.stgit@frogsfrogsfrogs>
 <20240619162906.GM103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619162906.GM103034@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

