Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E9EF9F8
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104324; cv=none; b=YmaZbWo5pruGSoH0whYRXHZAZMrpDDMmMHqH9tuRzFWDdLrQoYXEe/jxF8JTSn+0c39h8mUU6zXMXCUjZVfL/f9E2AMHmCYWCinXFjSWBydC4I2eESAGLB0Pr1JyselifXSu5vtoPnBqtIpbhQZQogd1m7dENTfKlWMg5yuP9IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104324; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WljBdIoUC/joGndVr7QjauUcSwPguicqQwLs9kCm/Lxip8U3Ldo7LMKklwQf0XKk6/QzQN5bp0ycn23pp3Pb937+YpVlcA70AR02TjZp+VVP33ERIqbCgODJXDbtrkKPbkgyEPbeR5NH7iFuJst8aQId9DMmCdR1WW36vWZ/3DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W2pJcWVo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W2pJcWVo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=W2pJcWVoKub8UMU0ZegRV8hu4N
	HRjM4+RzY/Zj4EgRhXcLJgSkixr3awcPl4rUTNGdQvuT3mQuPJxW+wZHY6FtKhZIcXQtTpEYlEfTm
	arsUUgtGkWnFHfgbhXV6igYknJsGRpqmoeX9y5CVcxAym3ofc9eZ/rAQ79R5hXLoYxmcrVmLlwRnp
	wVz3EP9vMbUkw6pkPVDJRK4pYVIx4D7N1TWtXF/5W4qW0ZQKsb0+KVZ6DHz7fcMfIIwM7N+X01L8B
	sLqPGPHJL41wyzGlPZL0ourB2GDBCXIwl1SfVw8db/pJbF+idmvTbyY9SgE2mmW8/QNvNDuf7C5LP
	o7m5RcNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LAP-0000000A6c2-3lfg;
	Mon, 28 Oct 2024 08:32:01 +0000
Date: Mon, 28 Oct 2024 01:32:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 2/7] libfrog: add support for commit range ioctl family
Message-ID: <Zx9MAQ0F0Rn51XRO@infradead.org>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
 <172983773360.3040944.3327362870969316613.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773360.3040944.3327362870969316613.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

