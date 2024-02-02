Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601F917994
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855104; cv=none; b=VSQ29v8KlLu++KukXKMCbFBO2OATgsrCwaN0B/tKGyEWDWruwWdBHGaxChX2VWhknpj3F618+b6YdrEJI0GMrel/HpwPZHkitK2pzzYSC0NlDCP9NkgtfqoOkRAjhA6lICYYHk3YdyqmDv8HiruDCdn1SVpn/evFXReBYSLZ0qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855104; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwrI27GtgvxB8QXQJ+ByBE2IexNYpL0gO934rkgTM0WJuo0VeNWzQezDJO1Hsf2N4gQ2gmCLJHRnJ2PFaZZR4gBTYABr6G4BJlHN8emrKwHvnRCmwaGv34OMqIXNchCrwPER7Jv4BVasL9F/eFHM5bwkd9kU7P4U+4Ao8E6x6Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N9tqBfQP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N9tqBfQP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=N9tqBfQPPutYesoYb2zRpNFit9
	6cLGn0WYJ/KmL64eBwXWGtRhmvOB683ZCY/y3/SWYDZ3CrzHFvvi9u3y6IlEhULnwFBYJyRupEpf6
	5K1lOka+mT+vptEDHcTcdUKkVSpgeM8jnZCwAIPEnC4t0GyM9lcCNfju+i54IEaSaY1Rqi3Fty2NP
	Yr6jHtLWnF4yfoyvUWAz6QZgGcEUp022f72I0OafLHwpFeFcEZwznEM0JQblLYrIEyODzfnhOqYng
	A7jpO1fiF+NmUEsYgxBU/S7YSzmc6HQm9Szk2cD9/6f0DvjpMnJYr2wZTR4t+br7TplWRJK+MGc4m
	lrxV405Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmz0-0000000APWE-4BX4;
	Fri, 02 Feb 2024 06:25:02 +0000
Date: Thu, 1 Feb 2024 22:25:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/27] xfs: make fake file forks explicit
Message-ID: <ZbyKvrEQgNvrz-iN@infradead.org>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
 <170681334995.1605438.15565130234166131675.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681334995.1605438.15565130234166131675.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
