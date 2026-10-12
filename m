Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8792246D2CC;
	Mon, 12 Oct 2026 12:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809083; cv=none; b=L8FKZ4IMTDEvQ88XHuqxol4kk3z5IZ1Y+2wtDOFe4n/VaMiQrpnINuxMLBmbWF1U4ac6yjRqchDDaNX26BhyMBjj9nQPmGazWaTGYmDRCP7IEV7X/NoQ4p0XcOxRfvWuguEVy8O81ppqzosLhLlhyJjZgX6wpXTk5ydcQjLaqdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809083; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4jNZfNBncC9jafBblrWq6MLuEWACgQY7hV5tq/+CsDznnRx3dJVDAXzpm2p549W+IUeU/NtXyusPvAqfQYu5RyawuVFS+LkbzwV9M0QrvReaxRAkZtrDCQKyPLYTH5uQMxt7hHZvzi38lko81S/nq5YDtY4wfgyBeobQqsaEA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=niGsfHDG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="niGsfHDG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=niGsfHDGi/O/aWZdcml1xCEsdi
	ahjpIHUdDoY5K7aI0nhKCNh2ZUrGxx78wrZf/MsY1a6+6HlqALbobobsFQFUnVuPVyFDOZ1JvoCoh
	m8RRsxnId9rqc6cF1SSZk1FcKhtolxTsyt42h7fnzaXgZWBbhkPvRxSCtaeEVD/Zfp5/eH5enY/5m
	RgD7/cHhqPks+UAgULFg8pnDk3z/fbaPxePtkRebMuJh7dCPTN2EJknIuGwQV/RU+Ei590rglZ71f
	kyAwrvx+NHqQwaOo3owkAtWluxbORm1hbTtJqmQzz1S9kHCNied8C2UNbiIv8AYEcB4PAOZ8mB1Lq
	t3v35TZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFOT-0000000AUhJ-0Fms;
	Mon, 12 Oct 2026 12:44:41 +0000
Date: Mon, 12 Oct 2026 05:44:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs: fix correction of unwritten extents in quota
 file data fork
Message-ID: <aszWOYirfRUPk-9X@infradead.org>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
 <179151614750.3163896.2873690969855180504.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179151614750.3163896.2873690969855180504.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

