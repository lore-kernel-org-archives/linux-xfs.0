Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765DC157E82
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894316; cv=none; b=nPXi0kvksB6CHq9Sm+V98oskw6IF5+ZgWr88OMVqg2U8cIJWvCzXzHdByICxegGqfftII+jEnzgXLCgEwvizOBhDgPHfAaKNtNBtOE3LniFj1SJtl9/0yNquggtera+Jzxrxw0X+fMWVF5X4rhdtSrR1GU7ER18s8Se3zXVKJwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894316; c=relaxed/simple;
	bh=HUz0R9IcmRHEP4ZSTEcxlCativFzut4Al8aXaAT8eZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnClzdFj0s4/wUbpJh8zaDp6hnxw7xita3zMecLhkf1fPVsk9/Wi97bbIDUX8n38Lhq7jSuD3Pj2BQm5v7tYz94mJ2QdH1QKtuWreiAlEebSEainQ9bgCc7wTUkuVnQziaB8jw3udtna9UetBljVwKo8gqpS/XDlKetJOvo2cmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nlVT0gPk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nlVT0gPk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i+fupYFYUktg2j1q0AAuIqCx7S2/YG/M4fZlsXyPtsI=; b=nlVT0gPknHq3KfZksb8Rloqa2Z
	No7blQAM9Ox6Zm4C9z/wa1tx4spO4cb67uOGAMetVgGjp26onTYJ7yicGH2Crpx99waBmaIaAq1SK
	0e5GDlV6OxTIYl9T+FGO8Upt+nqn71EWGyODxgsuTlJkHGmP0kTzhhBgbiq28ToSUT4t0emfNDrs1
	UpZi007y1PlWvnaLXRFXUFX3Y4Tyvltg8Zxt7phLurGPTkA2U1kXrk1WVGRmaDtoi+YTv08BwNuHZ
	elPhqrPRvnDPh++5pXD2Ng6K8r1yjKSneZyL46tlDhzb0EGOt1suXFUJ+2lZPcIO3vPR9nh9BTzg6
	RMUa+Jyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GOA-00000004Gcr-3eaF;
	Mon, 14 Oct 2024 08:25:14 +0000
Date: Mon, 14 Oct 2024 01:25:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/6] xfs: advertise realtime quota support in the xqm
 stat files
Message-ID: <ZwzVahNfQbJywQjF@infradead.org>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
 <172860645712.4180109.12939301427402294508.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860645712.4180109.12939301427402294508.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +#ifdef CONFIG_XFS_RT
> +		   1
> +#else
> +		   0
> +#endif

This should use IS_ENABLED()

