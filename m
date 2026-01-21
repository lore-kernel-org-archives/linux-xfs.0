Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357113B8D5B;
	Wed, 21 Jan 2026 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769008134; cv=none; b=F79zZUY6DJQVl0uRnrFXiisD3emWpFrs6L/hZpjQCj0ZYgOUfDDZg6XKIoQuXjXmBzalDzs31WhhBeHSMHHFv/5tPUTY79ukf0RYJ6ACTS/qbsilPBo2gCQd7hR5sR2n4rA0YZB2LPVH/ozQSY6ZZyFoSdS1x1y4afC9dR6wW94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769008134; c=relaxed/simple;
	bh=2jlxnXQOuxkcWyQYaYYmzJvtjbtA7ODi/Nc7dFNMJpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gb1N3M+BB4EZBAbwBZeIQlXbXbEVKatvlKIc1SBOcjZBLQTkP+TF1tyO5zvpQtn0X443RzHxEPu9BwmlpsBxS+h53Z8q3cxdmN/ILyDlne42CuIjf4Qp3Y73+DbsGaYKWqoQJGK5KNM0b7JhT5c+WqOzGGeDeMZ3r12jcp8Y4vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IAEKa//S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IAEKa//S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ef98/rGETd1uDXLXy+oOQeWey3qqHGTFjW8uPfnb9dA=; b=IAEKa//SDuqqa4U8zzf5Eh76py
	nMs612ivpQfB/QlE4fZJnDlB91xAaOARMc15aias6v/kBbiddTPKDBTRZC0xSxZIAZrmo24ujkkgY
	khIhtPTOodN+0a5mCKuwlmBSMv5T4pbVuYuDrB1XQGs9uBXT/KhgkWaEXrmMcjl7tYQtBvWgL6UT/
	hcjeXW939+7dQNieYLNh3BTKLpt6OQoP7PHwLkqwZlsdjr/GNwFHdw65xXJDDcFGPmOSrbJR6PJgi
	LvFwHTIxTlLKwMGwfC/b65jwp0ai7eBSirEHZv4Pw4azlSLVJw/ciyzipaTi77ftg+mbnd03a+IQd
	Qc77k1rA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZpE-00000005hOB-1w4k;
	Wed, 21 Jan 2026 15:08:52 +0000
Date: Wed, 21 Jan 2026 07:08:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: fix remote xattr valuelblk check
Message-ID: <aXDsBBJCc5Kx7UwM@infradead.org>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
 <176897695685.202569.16435015345442663590.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695685.202569.16435015345442663590.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 10:39:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In debugging other problems with generic/753, it turns out that it's
> possible for the system go to down in the middle of a remote xattr set
> operation such that the leaf block entry is marked incomplete and
> valueblk is set to zero.  Make this no longer a failure.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

