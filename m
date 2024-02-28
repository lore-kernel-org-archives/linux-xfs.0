Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684FD31A81
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709139980; cv=none; b=d0F4Gt0vgQGQ8rubHDsz2l4Fcz0fj6hSP+70X6NSOUH5ipn5Y5a9PPxW9DuUK2GATsqCBws+QDvHTyaAI+Hxek8DKnVB2ACn0Ca/yRE4tB9MmVay27GrlnT46+n/LdcbR1uZlm1O3Da9RrSuij2Ze/Z3JeSLMqe7gJJZ3isMLHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709139980; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmleQPPYFE/IJKPOLbTiH16NuSfOEe2grsd4BOeBLl0iDXk9kpHoOpqEg/L7kKQexVfcKuTwoaDDAEpXlC+bVO+bKUBfRbWnp8sg28l+i1ujncrKYcrFNloEWX3PPOl6dXPLlFfOQGA2wiJOPD6K8VvogttnOZcxjongX3TWUXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UCbDH7rC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UCbDH7rC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UCbDH7rCG+UbXrNPFcq+pCvEPW
	j+VS1A5d+VorFeXS1Agh2nFyMZilswgzVgQTIbC1WujMn8HeN0xKkC8v6+SOM2dFT3OG1wLTCJbB8
	rlb+d6ANj6POwfvDjUb5x0H1JtN1v8RO76bObXlG8MQEyvR8ILb1SAnayy7MpoA3HdWgxlMiedv96
	2MrVEiGrYVZkTLKDmoJT9NIcZjmFw/wa0GgeCorG1ICCxZHQa9UkKGjCu2o9G2SW/nstxz1RrKMTS
	qVlm8kNZaE19IdVrVcEvs9Rh+5PCxkmub4z4UBD+ze+L3KsQAMtLuC0ZVbb6AEzE2NcfahhIgDkY4
	TbmxkQQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNNr-0000000AE76-0COe;
	Wed, 28 Feb 2024 17:06:19 +0000
Date: Wed, 28 Feb 2024 09:06:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/6] xfs: flag empty xattr leaf blocks for optimization
Message-ID: <Zd9oC8qpfCNJE_Q1@infradead.org>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
 <170900013712.939212.17272210848443405734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013712.939212.17272210848443405734.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
