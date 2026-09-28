Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482763F7892;
	Mon, 28 Sep 2026 08:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582895; cv=none; b=sNM8/qG1gks0pMhpmnywATrrJyt87WjDkJeKBFwwJob9uQ7BGN2SJY86g58RwYnhINekQZ8tXvGuEtPdffQYCCiWqhooCrVXLo2pe2Nlzed4M6kOVrMGj2ygaOWE1RLXuhhB2t3TfY51lmpfMU0mu3qWVu00BWwt3aAxxFHalMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582895; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/fnEl2NGT3gAcOnBVDvZALnsZiJgc0h2O8DLglCxofCuvARjvBCdNGKEjPsPXSD9F4e9AxDNRtpcgN7ogfihAo4W0Jbv9/I/HddQRwSCLWqMH0VCZ7BDimYOtCfwcQlKd/onEzYiwDRkCkQDGIdIb9zZ8JyMXnZIvSLH5AY2S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GLFXswkE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GLFXswkE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GLFXswkEAt4MkitciDCsIL5GeI
	9BFAT+OvGdIIwnyNuJvUFecD58i9nKj9ZiRg3wT2JEpCSfJPYPWud8vHmXjmdXSRKNAvk8Nfd8Sd8
	Sb3I4yw5aB0dYa49gw64bpOJHOFht4b9l72CQjMtNd07L24hU+/0rwQ7u4fR/cw9hXwmd2gktjMRl
	dFQS+kiJk2QwINvcGxShZCE4tAljt60urF/bCGjw8dR0i0RLrzS8a8hFQlPu0T6cv1nSsTDlKvECY
	nRAAM0kL1ezu/iUDZ6PISM0QvLuwtnQxSVoii7qcq/EIEw5av20D+RaEPoaAUCLlg99G22lDzfszM
	WunxeUtg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB6PE-000000001Ns-0oUC;
	Mon, 28 Sep 2026 08:08:12 +0000
Date: Mon, 28 Sep 2026 01:08:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: fix revalidation of xchk_dquot_iter cached
 mappings
Message-ID: <arogbOkHFOpeUUR4@infradead.org>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612703.479634.7305483806642816212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179057612703.479634.7305483806642816212.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
