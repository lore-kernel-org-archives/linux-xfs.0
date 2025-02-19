Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D56C192D7E;
	Wed, 19 Feb 2025 06:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945330; cv=none; b=OdT706CLyCNT1pOT17eGFyhm+PED9PNJ+sZ4EU8c2b65X5HkW7X6xdwHSy97ippqOL8nOpVGhF377Hu85q1f0T+wXm3FXHrl40MRUrURR276yaMyKjAOnruXxUGDW+uRl4x67qr5b0dBA/DXTn/SdfuzDfRDwhS3jhXUaC8emxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945330; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=piMUdDt9iz6enpBArHjU8RKVtNwZApjumIOwDkgkiToFh/gtMkGvKyFxyjohYAw7cYNKXjIFdV+bMTg3lQRor/dTc7gvFuBFOV8yyvsyoUYkFa32W1dVHuZYKIEYUvpKG/SPOUwH4R6+0d2rXl9wdwuZN267rYNoDsSYXjAbI/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OtPK87aY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OtPK87aY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OtPK87aYO2IF4DNj3TSxDBfVsM
	7W0KDBI1VRSH80KhXJ1vON42PlcjUP1/8/AJYUoi+R77OxubPbJBA8U6FDsl/1ncmUn9cFh9wh35c
	tDMtcbiC/ZqWr4ukCwUE88OVSDLpY019SNiik2VazWM+s+1vwensxBb/ARmQzK2yF03YZHspofBBK
	t8O2Ngpp4fv9qxPK/7HPqSkDiSgi8zSQTR15wwMQcB/R14CWcgWx63Qh5OUd264QK6KiSeDJOBHne
	rO1F/RZ+lJxgqc/SDakGbVpwa0kqkzMZwwqZQ9GNiVsUKDfA+JZjQYbjthuV+JwSG4Trrcv7f7bYX
	bsSm2Nww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdGK-0000000B0BF-3y1C;
	Wed, 19 Feb 2025 06:08:48 +0000
Date: Tue, 18 Feb 2025 22:08:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs/019: reduce _fail calls in test
Message-ID: <Z7V1cEFpm56x9ocl@infradead.org>
References: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
 <173992588668.4079248.2147316255223418497.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588668.4079248.2147316255223418497.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

