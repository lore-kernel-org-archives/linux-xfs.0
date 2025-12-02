Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151784594A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661079; cv=none; b=N29cMtjTTcnBDFB9SGGCq7g709w3LE74pSx7dEr9QiUs9VMt617JLYwRNtDb1q0tt0cIArrV3nWH+xSkpeykBoI35nG2hb5qj5KsB0dIWnlNczkDp5FcY5qvRbSmKkh8Bs67GjdTBFdTSeau6My7ZTecUgYJTDiaBzKTlrnTkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661079; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNIgENPuK8/BKp6vquwupzxTv2uRWruP/C0lZtuH79CrnCdmm1vxZ8rFBZcT3LytVrUz8ziwV4shiOqSymc9GZ8p8H+lTqpfTnCNfaBSoE4xh/rDJSskicfogME4DQxCk5SOOOKfRHUQEnqxees2Io9w77nKO6fMtVzEnGRiWiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=piWjSAqd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="piWjSAqd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=piWjSAqdlsDg23qTTKbthyc4ZL
	WB3iNQY6EYF7/sK2OlPlHQUeuHwoGg3jty1u7MALXHUiwjZO0F68wweWRjfyPZA42Xxgpas1a2r+6
	zE6FMPe3cvVeilem9fCUH1bbbI0QQYynhUZfHu7SPuRBUeg03vRc5UJ361BOyk4cePxI+heAtn9D0
	Z+K6xygiAjLfm4sRV+JBd/04U9NqSa7x4+r0TJzXhSavABUhcgxXJAmHKjMZHQ7p4dEq6OKBqcCNr
	tQMu8X8MAbfOVGrRmteOI4cYfmSeFnEzeef5mIZaVAmlUgb8boBfWk72HoTh6XJtsZ8ASZxR4+uNU
	6BIP3qtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQKxR-00000004xo6-28n7;
	Tue, 02 Dec 2025 07:37:57 +0000
Date: Mon, 1 Dec 2025 23:37:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] man2: fix getparents ioctl manpage
Message-ID: <aS6XVczY8LzoVcJ3@infradead.org>
References: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
 <176463876154.839737.15121592187004060239.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176463876154.839737.15121592187004060239.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

