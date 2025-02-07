Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9B5EC2
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738907870; cv=none; b=c0RVrIFyqRHNEDvnnM/vT/LooOgmlSsiJ6EuoimBIQVf349Dz+WNcx2KZTSshRfJE+UB8jNKzVeb8/WrRz5Dgpf82zHFk3qZdUUHFflKlPLkbFP4ZN7HbpdLynCIWLPoffKLfdV7hUKORhKapIh4AL/qaF723Wp6sC1AvGF9S8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738907870; c=relaxed/simple;
	bh=HEbZTjDQhAIVZnod/Wy8V8PDQ6lBIa4XdUHCRehSFA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZRzMkNR0+Or03vjZ9+fWGR2cFLouUN1PV7agWRs5ZK/YWSMN2LaruaRzMnfaY/ONt9pvKoDRN3ysBlxgMdbDDjx/QNf3CZzUAFyvj37NlvXAa5rEDi1H6agd2J99FA9L/MjQlZYxn1/wy+rPwIXyydbVOBpc9y5jMmXmoamPpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uDcd0M57; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uDcd0M57"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zVxA1yk9HtpFIOfzBfzx+irKz31ganj4jl5SGmGgNGk=; b=uDcd0M57Vhc+gcqoblQg87f6Pr
	GsbSb5QGSNIRo/8REcZvN2i5rDdS91a8PRt3bcgcLIfxeB3rlcDGPQ08l0Wqt+0XFo0N9tgag2lfH
	xNMzJzPNj2M/PONbpIfd1odyIGMTONOljynWARX3YREFipDwFn1tvOvPfh8jW85dRb8JRaXVY+I5E
	x1H1hEtRDZE94xP50HzwKrQAPTFuWONEWHryofhhtTE8DgTBFLJWVsBDGwsotswO3tBgorVybbcLL
	JbbPsPnyhu2wQAJLx3X6U+R0QKv4PqJNV/PYGwFz/GotAymCLFd3Ixn0zZD/Yc8k9Kq0+2RFDtw30
	YQNQJPZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgHN6-00000008R5s-3Rhs;
	Fri, 07 Feb 2025 05:57:48 +0000
Date: Thu, 6 Feb 2025 21:57:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/27] xfs_repair: reserve per-AG space while rebuilding
 rt metadata
Message-ID: <Z6Wg3Dz_fiD0pEwL@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088464.2741033.2066305894736213498.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088464.2741033.2066305894736213498.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:55:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Realtime metadata btrees can consume quite a bit of space on a full
> filesystem.  Since the metadata are just regular files, we need to

I think there is an inodes or btrees missing after metadata above.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
