Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBF037152
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243213; cv=none; b=at/5e1vZmx2GWTOCy6wJnMOQSsHBSEh2ebh77VMh+2pYmAyj81Vfp049oM85aZq2sKdm+S8QsrNA0EPwIyFOaRJOIC2A3IrKq0Q2LQ7B0PTXsPOhmunEO2IyWIusWCvY/ctVSleVHBR8D1i3VWghKsildvcBnQCCp/iu/ucMvJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243213; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UF3KKCHDHdLOD3XZtcSA14NQ22KBmIScH5xckkU5Yx5hyfrP6OT8jXw758iZrF3AragTUG1H8MADYkc61hmpH9MVjJhvllHPpG0YRunh5VNEMMzA/HKdG9fr95C/g5m72oNGeCeZOPoKz5VcqMitBfqCiuedbBEXJH8KzN2ueD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1M+Gl86C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1M+Gl86C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1M+Gl86C0nf9hXAsPLKCZk1J9c
	IlsTgkL+ABLsphPW8DJjTM/B5xWCobVuoEz+aQC3NZwQuPbFx3J7P7G1U2z2qhHdbKe8IkRY08GNA
	Fm0p42HYSUIG8y9YnZBK3X67KixlKTrzbftV9sXvR3JNZPbH8CYjtNZTRSH8AwWeRwe/XRRBK/lFb
	wq8Vc0pRLVofl9HF6T5bXms7UYyXVWU1lMDQCV5yRiWZJzid9ElHeQoHcmW1aCI75E/7T9Gg6zaSQ
	tPTMSmf6zOdMMBw6eGFGziNGwhCWC5f3r7C9EGzinoZTm/Xa5Ac+9znXHX0aWCayx59sPEpQhi4sE
	zv9tMDYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwap2-0000000Arpo-0DM1;
	Tue, 16 Apr 2024 04:53:32 +0000
Date: Mon, 15 Apr 2024 21:53:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 3/5] xfs_scrub: fix threadcount estimates for phase 6
Message-ID: <Zh4ETPZqaaIQk4eD@infradead.org>
References: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
 <171322881848.210882.8785564010758627318.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322881848.210882.8785564010758627318.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

