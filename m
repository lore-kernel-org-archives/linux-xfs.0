Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C56F2561C5
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758293253; cv=none; b=WGVPJxJAiK35pt7YYVc2U+O5gqVrvdkW1yJq7K4bIFqRcd2NS4Xnq55xqCNYcL7K84nft0nnsxsBx2bVDq6gL0XgxRqyw32WLquFjsR7ufcxMuCSFh83XVWDWVvb04pXGEWnUF1opUMLeQwtukIgBLcLzKd4ZU49Cj2FqvkWTNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758293253; c=relaxed/simple;
	bh=FwewmZx4rUF+vnyNk6dob0CY0kTNuzvetP2Ut7M/rO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvwlbMb1ZurNu6744aP5g9kcBYqFU+ZzRZ3LSwBPMzdD95ilboz7S2IqQv9AvKgB7vSLCa9oJ6UWILOcF7Onv0EhiFsYCIzERyfjqeqLUHfI7VDrH9yciMOUX00BHJ3cy5YyYTRSlqrxU48Qjh3ImSo0i5YaKTqfn61j4H6b6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=odpU5R5t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="odpU5R5t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=336NqJI/GH5YWM1P8rVNLkwkzInxX2dFPmoXzBZ4l1U=; b=odpU5R5tNOQUu9yF4J/MmWbgHB
	yzJYymWXiierLOeX+Zpq2U0Ilg8ZZjM8SERqpwpkrDZti7Y/ine1OZyuekYdm+7Mkf3iJqapJ9cEg
	cCdLDkW50VgFexYYdmcD3hji7mnMaxVEsoNS5iFwEUjNkWkGDlp2+H6O5+12uz6C5rOrdh0aoGLSG
	KZ/lsn7NgdkF5jFrmTr0QgIaarUJZtmxJqEPChnbS9Ma0djMVeJG8wp4mf45lX+tLtASnBhUHtdy7
	A9f+X/er2JsvvN1lL8lppprwHngGsuI44x9lFE1Ku1bBSQdUSwXgrdC49d6mmvzXhTbQoswMx9Nwc
	TaF5ckLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzcOY-00000003Cac-3h8r;
	Fri, 19 Sep 2025 14:47:30 +0000
Date: Fri, 19 Sep 2025 07:47:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "A. Wilcox" <AWilcox@wilcox-tech.com>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: fix strerror_r usage yet again
Message-ID: <aM1tAlLshkg7Hi3b@infradead.org>
References: <20250918194836.GK8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918194836.GK8096@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 18, 2025 at 12:48:36PM -0700, Darrick J. Wong wrote:
> "Fix" this standards body own goal by casting the return value to
> intptr_t and employing some gross heuristics to guess at the location of
> the actual error string.

That really makes things worse.  I think we'll just want ifdefs for the
two versions if there is no better option.

