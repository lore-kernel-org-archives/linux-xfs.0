Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D3213959C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367217; cv=none; b=blco/AaxMOwk9sIHlISRY8sattnz1bBBL9auhvW+Bsh5eEGQMYHmg4tDETF4l9FDY0u1zimhrN2KoIAcIY7XZofIUmd+cvL/aUJ/4hJ/7dkYqOHBDvcnhy+U7L/oNwl6ctx4TY1sWer0jeQaaM43CWnMOXUsL2X+gWWpftcgGPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367217; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=st+b9bICqaLP3rj/1WpU0RHwsX2ZBRGrbvn2aiHlheuNz+9o2qnVdWwMIDsg4NfP8WCTpWcgq9WwG9S6MUU9mLxTdMWW6iHNrHvANLYcNqAWR6VTOFg47ypWx/TXiLeaqGchCx5qpijU3obqNvGdW3lj7UM+hqLWlM2GxVjNH9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UQJlXKzf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UQJlXKzf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UQJlXKzfNv9zRe8FEzoUOeWPlt
	sXUeqBoUJP7wFJmMSJUwbeEr4hqAO1/Om6JK9Sziak75vJFxD50OrzRQ9DTuompSZod/+x0pExYWw
	mJCLJ7ONKaYns3r0anRMIRfuu6mGOlvABEnPWeqKZZw2IqAoA28kXAm2g0a7GXcrtiPj2ynMuNDk7
	/EvLTD2TKBQt1cWnY42ND2ki8iLofiPZMXzaegtv1Odq5ixVI2b4mvz0SwbXJ77baOKYFPN6fhbln
	IA0H3Ab/F8A5C7RgFvNcreS2jaVWTZ5fMZUhu1V9DQ+wHY7q4RPcx8OOFlR77QwCuBqPJm3Wh4cAx
	MK1UW8Cw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rx755-0000000GYZY-1xHV;
	Wed, 17 Apr 2024 15:20:15 +0000
Date: Wed, 17 Apr 2024 08:20:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: Re: [PATCH v3 1/4] xfs_db: fix leak in flist_find_ftyp()
Message-ID: <Zh_or2HGs_9tEGJL@infradead.org>
References: <20240417125227.916015-2-aalbersh@redhat.com>
 <20240417125227.916015-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125227.916015-3-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
