Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE79110A3E
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725475; cv=none; b=Z7z9Lwk7siB3wZBGVHEoYw2gglGlZIEXV/cHw43o06ZGriXojkB+beuXNNDsLomr83dkjjvumBTx8jDYmvZvdQHHbNSSzEqc7Az9HkJnI9GVYifHYD35rdzRjj5091AgJvQHnuYhfCxcTHDeaepOvrzycxkGIB2QglZyupYqplY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725475; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czV++GmnCxN1YefW1ePDsWph4FxoOKKgCTwk47kftHaEf03UPFlSV9CmaR7tNDyJbaRfFIYPqyRp6RbcoG0Wb/aFLenXDtRnoBVwTcPAOjdcUdZZ9L/SqCbanwxTa98g9dgLjWDW2clUCKZnAOX9BH9lefO1tXtQ1rv0LtlnOWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kx8yrteo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kx8yrteo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kx8yrteolRkiVbYIM/z2Lbj9b5
	1tg/dJxfmixtUhZGBxwS/vovWsfiF5EZcAyEDacuqgg1fROTXSvI3m7s7fgTs0/A252MAQVDAEuyM
	W5DbxmRvIdCagntSgq+iqP4eUjewFhS/YomP3GGbnkYcwQIalxNR8Z91xMS2DX4jmWX0AFxAkJQ7J
	5RmN0silqyFViChqUYnuY441UdU97OW/z83muaVQmftsMfL/7UdNrLGaZHMMvLToqmSQySAQBDE3X
	vVVy2MXFljBdMg3eAIOsY7rmNh/6crQgUmCTjZlqTyLcAwoy95gJO+hBeX/klvs2RkP1aK034ojA0
	bNOi6Z1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQ8P-000000057D2-3Ogl;
	Wed, 10 Apr 2024 05:04:34 +0000
Date: Tue, 9 Apr 2024 22:04:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for
 attr log intent item recovery
Message-ID: <ZhYd4TKJk8szpjGH@infradead.org>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968886.3631545.13705299860508916040.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968886.3631545.13705299860508916040.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
