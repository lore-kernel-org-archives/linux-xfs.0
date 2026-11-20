Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192897;
	b=yGPM4lrgQrAc5EbVW0XcTm11FDgHrXhHIRHq4/8Yherim+MBJ6IxTiBqYJ+M565hscgk
	 ukcAIhuBI8VlOVyDzIOxwmc52ifkMF/9tKzxDQ7q1WVL70TELeVEc976ri/vjiCSGKQ5J
	 e+mql3SgTHTRj2LLbBHY6voqDMeNStjvUHxmMtuJq9+kG4+sIPeo0dMuZQvHgSDdeCRgv
	 TjJHAecHRaql20Vbs5YkFD8K60QS6sg16CEI/+5G1i/45QxioDN1D6IPtZRTFdA5CyqOD
	 iUY+d9yAccX2ajMjGTlLQPpCuA4H8qewz53QiTWdGbp3h0gfP5EF/hNIvFQ1LWkg0/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192897;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=1Hq+hojdoxw+/v4KlDxYaB6PBI4yggOzHf2YZeSElgU=;
	b=u4eswtsh8X2MXP8hMAZNcszlj+0LqnsGOnRbtzMIQECxCh6gynQUfuFzrFWaHhGkT/Jo
	 8xI0pUgxGieYHGLtm2BcFfEmeN+4JOuEYW39z3Iqo/U42rOJ+jVYVHGzOdsqP2wIoyS82
	 Y+s0qiP0SXjrj3u0W1egCeQVH/RN/qagGs7tt2sJ9gu00E1JJnnOoj0flE++7u4jlxBiE
	 XIvjQhoZXLFgppF54X/kaCqO38ILGHSDvQUgb3GBp7MMQjoIoQvBq0jEWSCXw3883DVym
	 65ebhlseNie6RooJxqBjSqGasct01bZcxrP9j0hdNnoY+bNrRrSLERqN/kshuf5p6RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=B5yvfzUS;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD5D606A60B
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 16:41:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADD5D606A60B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=B5yvfzUS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1Hq+hojdoxw+/v4KlDxYaB6PBI4yggOzHf2YZeSElgU=; b=B5yvfzUSXEO1sRWrtdkx9XPhiY
	5mZG3aVuHhGrYg9Vcv8LIMlwj9Xxx1nsKmXoaODTH2uQtOCL0X/dWSgfHFrsiXHFjoVRkysZqO+h1
	y2FXAcwqfX+S8r3OzvzgzAt5+fksbhBryg8Fs1gr8gGXzknF+08AS573SE4hM2451fQ09CpSPGvlR
	mLdTE2mINSDX0Bvs3SoohnIrAyDaYuvrcRFr5eDvIU6GdnoflSoLtvUa0jxnZgzxL2lDy5aRvSMOm
	59UXwZPCWmA4wFiniuVEKfBVVn/bpiK9BFLBp0qmgv2KKMe99Yb3ezsgfFuWAPZpdjr2Nb9jMP7n8
	jh6582bQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURg8-0000000FZrq-0gu6;
	Fri, 20 Nov 2026 16:41:36 +0000
Date: Fri, 20 Nov 2026 08:41:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [V2 PATCH 00/59] Validate journal log items during log recovery.
Message-ID: <awB4QFBLZF6fQzEG@infradead.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please try to get this going by splitting it up.   The first 11 patches
have nothing to do with your design and framework, so let's get them
out first, Ccing people who touched the area etc.  And the apply
geometry at log recovery bits are scary.  Yes, we probably need them,
but without testing I fear they might create even more problems than
they solve.  So let's get coverage for that.

Once we get the initial bits in I'll try to move on to the rest, but
even there it would really help to chunk it up, i.e. do a series
just for the generic log recovery changes without item-specific bits
to keep everyone focussed and speed up the iteration.

