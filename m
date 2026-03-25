Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384923502A5;
	Wed, 25 Mar 2026 06:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774419764; cv=none; b=upmXRYlOuW2mafrwQbac9OQZkkqTcc4kWAHzoS1u69h0B5v2AIpel3wkmLtuuNEc3N619t8Oc+8kaXcZbgt567nZhUhCgqfoiHSDHYCDZhqGiJu2+yocY4nXLJS1iJaCHRI/Wj0/FUYyHjbD4l61V/3KZzOCnImG+qC3GhklFE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774419764; c=relaxed/simple;
	bh=ihJZAOpELfWa72rz9zgkyCwNROmQ/BAXIqaNXEnrGHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPNRCFM2C5uyWYodBfBJKO5v7ia4OyHjnFr5i8KG11Q73ljzunu7XVBkynHYUUQlCrjnDfJ55givulXsyIwlqq4KAkwsbrHN49TttSJ0fhtuQg8qvZ/dxU2OvF4lWLlGtu2Cv8Mxa3CgmhUXLb2ktqXTf5IVsVoyqBMGSKmXInQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KF9NYGzS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KF9NYGzS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ihJZAOpELfWa72rz9zgkyCwNROmQ/BAXIqaNXEnrGHk=; b=KF9NYGzS3DUllcLHGy1y/jnCbd
	yts8n0s7FZU6p24z8Cba1gkmz9J7vTc99J9ZwuCUEdLKJcKPTkLnx2BzDvEVwGLt+L6yGnOBHHzvu
	0emaZeINwG89FevrersImEukc+AS1HtiqpVDmL6esrKy30ivJnxoUDORvA0sSoba3wW7G3hOps6We
	EJWlv/k989SZuc90BZd3v5AaUzwr92TOGEmwZIW/EePCFh+n67vZz0jTgIShbFjhBi4tsAJqK3W65
	m92uB4lvrLsDLm1tJdYE4ukTabi1t0taGsMQnNYsPVKEFaEBCLbLNFmkJQAOIWs4erE1ffO0ni6/r
	7DBadOQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5Hda-00000002mW7-3Eg5;
	Wed, 25 Mar 2026 06:22:42 +0000
Date: Tue, 24 Mar 2026 23:22:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, stable@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2] xfs: use xfs_trans_ail_copy_lsn for lockless li_lsn
 read in CIL formatting
Message-ID: <acN_Mh5I_auSv_VM@infradead.org>
References: <20260323070949.3769170-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323070949.3769170-1-zzzccc427@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good to me, even if the additional lock on 32-bit might hurt
that one person or two running performance critical workloads on
32-bit systems:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I'd really like to have Dave look over this as he's the resident
expert in this area.
