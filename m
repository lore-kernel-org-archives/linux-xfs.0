Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6DB4457AF;
	Tue, 15 Sep 2026 06:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453818; cv=none; b=tH/eTtMky8AOFoHUjHqCmkDurDMVpv/u7PIwPvR+TZ5OEEcSoGoeFjtCyry2XpgGGoFIPok38dy4kah+muo4WnZyOD6GsGuxeyOpeTZ4gOlHxhjGjwj+fvuzCsaOAEk4dgmzHt8/MPDZPdt2eLY8qlrEg1ZkYe2zevYwOZdcRbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453818; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuR1+LFqbfIyGvPPDbabtgx4LIsZXTE17dv7o6Y4XWlMwvz0c1+d1hf4G6jDQyaAIfpPgDc1j/cIFipid7kZOtyNyGP6chEbM8ARDR4OeIUOK2EHIyqjrLPJeRwicWuy6xqscGE4jmnQnIrFxzomUn1CcOfNBgnj40odygn0x/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IFb3n8XH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IFb3n8XH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=IFb3n8XHZuS6l9aMc0THL6m7fy
	4r6866oVkMfDui4M9wnmuvjYg1FxcfYUbr+Cc0wtGRUTnYSYGCyCBT5x3972bZmW4bbEzAaHBd9/p
	hVoWFCPuHZmT3dxdC+3oxw+IJEk6Rbv4LWdHadIBGCt7P0rVoghjQ73T0/z/oTWN0XxvdJM0/kf16
	eTSYMiZvRE4D47noGQJ8hmm6FejdSXkxHEAfZJqNvyMCXSXh8tOsITqVe1xLLcETVp/UOeSIqAjS3
	TZuA6PuwfSneLLcE+r42d54fleqSg2n1YrDddQW0qcFVX0aTzaX6CtHwbS4FUPdvVcSRccbmpMkJZ
	P5gKFfXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6MgB-00000005LYh-2sX8;
	Tue, 15 Sep 2026 06:30:07 +0000
Date: Mon, 14 Sep 2026 23:30:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: don't let memory failures leak blocks and
 kill repairs
Message-ID: <aqjl722XC7SC0s2a@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048606.3061055.5801413647504627346.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048606.3061055.5801413647504627346.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

