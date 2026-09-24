Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949FC3B7769;
	Thu, 24 Sep 2026 05:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790228953; cv=none; b=BEcuU8oIu2uiS0OMORfWt78SW5wfeZzXOGqFb2bjtrFkC0fCcRf9iUeAyL1gV9UV3u4spHQ/trb4kHXr/K5ezbjIaYFXsOZcnQVLjnehm+6DxEONn8QpXh4p/4ZwsQnePRorYnkdA8jes+NitCiGuNAM78r63dpk3JQRNr50bt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790228953; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rnwTMUCEiMro1r8qHjRQL2HlSjZgRWxEHROuUj5H0dYoDDaxFUTS3utPkh2uLie53+tWGw+eRrzlJmKt7KR5qtKAS+q2d3hJ2OCNQa6zoFU/Uutlf2aATLhUsyGFfTaPnQwA2qiWTggLiiB9WRARol97qJuVZomC4NeUCpR888Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=45BsPxAB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="45BsPxAB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=45BsPxABztNqXx2FaepeHgynDC
	AZTl/Ya3+sF6MYFKlcyfWUJT+TEi+cZxCFp1Xnphuj8AIumLJjQO0xM1zcOEmp6fISu20QRBZMHsc
	r+HOch56OMZUkhWZDvMguhuvOiUzrkxCAGUCQnr3+Nae2YzBbJU4JjdyCvi0QO3qFYE1MNI38nDTe
	qhaQJqvbe+I9QzQE2DjQQCfek/wDhdA+3SA1dP8erZ6eORTXzHIwY283qxuTSNoty/3d+jqP6tFzH
	+r2Qdk1xX9YrIXaGKdUdd8N46hP9xBTHaDL1y+p4CXtRCYl8d25Ogs0053ML50yIPrDv1YuzBowkj
	0KAckr4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cKK-0000000A5HC-46Li;
	Thu, 24 Sep 2026 05:49:00 +0000
Date: Wed, 23 Sep 2026 22:49:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: mark cow extents bad if there's no rmap
 mapping for them
Message-ID: <arS5zAu0s3qlUsbZ@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159586.1875436.14436067546937024850.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159586.1875436.14436067546937024850.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

