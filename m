Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20F455887
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724387520; cv=none; b=dHmfDv1b5xYU00wnoi2zIwWeTMnWdp2sWSBfSqUPgZGvifAzoled/QMX0oOg5Xpg5/Qoc5DFE2NwHmUbU9NdH0GlopHbOvT/p9+qMkthPQkXEeORD78DaLnXvMTWYDvUNvNqE6/kEt+RtmXADekesib4kcDznN3HV6wbEXmLTQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724387520; c=relaxed/simple;
	bh=OU6kIUDwhBxGlxxfNYtIEVbtnfKYhP6fS0ajQIml5eQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDuQD4Ep/qFwoH/F17k5thBVMvYgEnRNWHBuU4QhHe0+GkldIrOU7yExuoELML9tz8jPmr29luY12jEvQ+FotisYdv7OmP82Qg1OF5fR+6JlL8hPrcfe5UaveZqIKP7ddAlIStOwO7Y6j8cC92JG9syZd7uzs811xaYMQTJZ3gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j4wSW3vy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j4wSW3vy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dxOt4OTXLH6RQ4GlRDAl1905H0sMERqo25RZMPMfkg4=; b=j4wSW3vywUWFDRnj8C5D45O8O4
	wgm18AhgQ3q71LnjK1DiBG7T4LHnqCbeKI+dhgh6iDXyj0bST2e8jnOfrSvOyAyRwRDJaYZy/P3oA
	oaaGqo0Y028QpQSYwShPPMXYSNqmUbLMQkoolqnAR3Mu/8CuJg4nK4BhLU8+dz59D84FSDmVKUwLg
	G9TuLeFSdDO15+CYh2MR6BOvtvqcf4wUPrSd//957M5DOksNPSCqcIAjMqIF3WPZF+9mJYyzLB5so
	FtUYYfe5DJdL/ruvv9qg6fEvtGi5YaANkBMc/KRQDfq2uqBXfuSQiv2U5QzXeU8TJ+Gv0c3bKGdHW
	luwh9xNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shLxu-0000000FCZ9-0djv;
	Fri, 23 Aug 2024 04:31:58 +0000
Date: Thu, 22 Aug 2024 21:31:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/26] xfs: refactor loading quota inodes in the regular
 case
Message-ID: <ZsgQvof8gWadH7Hf@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085206.57482.3726157833898843274.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085206.57482.3726157833898843274.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	xfs_ino_t		ino = NULLFSINO;
> +
> +	switch (type) {
> +	case XFS_DQTYPE_USER:
> +		ino = mp->m_sb.sb_uquotino;
> +		break;
> +	case XFS_DQTYPE_GROUP:
> +		ino = mp->m_sb.sb_gquotino;
> +		break;
> +	case XFS_DQTYPE_PROJ:
> +		ino = mp->m_sb.sb_pquotino;
> +		break;
> +	default:
> +		ASSERT(0);
> +		return -EFSCORRUPTED;
> +	}

I'd probably split this type to ino lookup into a separate helper,
but that doesn't really matter.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

