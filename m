Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D565382
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710382041; cv=none; b=GTvBEgk1Nolmcb+NRgkh8ztwFPtgnf88T1pYcMUv5hgG4Mj58nMyiXGMYmwnR06+ZSD74cZq23nPVusuPxuFZzvgPfdHY9T51rmlBMBsMp35spDWpHejeh8FhDzaWtX3AbCzV3hcsMOYJmzED0lwlrgMhvzW/CZnW6okHQcmX4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710382041; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F4u8hvaaH6XAUca+n4lhhYo9UfVf/ACx/TxiPuEAwyXPuacE2OuWVQukI9Y6kXzLm+zUQiitv5rG0mzUg+/5gNL8x7sih/c7muZoFc4wUkgm+NL+xlwUih1nbHRSBFh/QX8+TGDjcHUI7dzlo2UJYOOk0AZYlGRTYu/GL6tTrDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ffk+m/lf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ffk+m/lf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ffk+m/lfOGIJV14dKQUOmUtnhQ
	Zin7oecX8tDDAA6qKlGATS42PnG39fowj8zNtK/oA0NoxB5iHkG4IlSmmNd42PBCMLEst4bOO64Ot
	bhBOldiGcvikJ2coTW5BW6BPw2sDP6kHTkC5Uwy4RPQANHW+hK7viXWKu0k4vd8bwgzlFlToCOcCD
	pMjJNJjOy1WzVjzLnbMLkcR+D/PGOJUJHGDe64STfEMf5p5ajTVdoD7xa+iIYVUxT4RO03cy2PDxe
	NvrQc+a4Gihys5G/F4OuL1Ugvjs/LWtpS1WTqLijEANqUSUQXpB/ue1tbTW0s1/JoKMFoKCKwynor
	5DNLuNlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaV5-0000000CdpC-2Et8;
	Thu, 14 Mar 2024 02:07:19 +0000
Date: Wed, 13 Mar 2024 19:07:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libxfs: actually set m_fsname
Message-ID: <ZfJb13rnHTVlIjMx@infradead.org>
References: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
 <171029435189.2066071.4364534770813261790.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029435189.2066071.4364534770813261790.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
