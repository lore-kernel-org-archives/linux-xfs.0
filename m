Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEB5371054
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 14:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719410; cv=none; b=nhd/e3OLoz+tr5hghSGGE/Lp0DK8ZRyLFLdExlRD79H7UlndQ785yB86oFo7ThKpz394NXqFc571Qn/ayia6EiRZ+xN1vHUAXNkkcVEKuVAyO6Atgj0ssz1raICVFOD7B9EP0OAMLKi/xge4nf2I2+IrtkKFYLBViFMMQPhioOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719410; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rg0JSH/dPmPCMlsRUzAJ/5cZkXG7eZbuZxFtKrdwtmIkqsEQ2Rtt1lzyUFEDKFzBSxITQzx65uQ91D2E2+x9R3eUD6dSZipz10ntnZuT9I0p2mx0g5TXihHoYiSKjqg9N5BtkeX4/PAhwgHEDe6NvED9+952OjwXUJ4ukJOZN0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3/9NKC6s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3/9NKC6s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3/9NKC6soOPf56DE4Sc11wwbCz
	lUCEF+v0RTfVOe9FH7kWC7Shgn2dnhsS2nOEvJBuzGAn8v5rDQ+xLUtgG5HBwxut6zrkaQ1OXFMjO
	HovU3RigsP/Msh2rRhwUVleaYN4806fqhp4GQ6QWnR9ZEyjG0LfCwlqeq7W2LetB+EHRnP2D7KzW0
	ITLAEqHE3qkwTT83avMmRE9MwTyC+vtYfH8JLQ7dwsKwcLDkGWdwI73QsCizvqQFW9CjJJPQktUkT
	RpCMw3FZ1lCiDiBy1TevfoBrhthOwtVITJshDugBsjRPnlIhRd3nJYaKgp06YuXH/RHkrZGgpx4O6
	fRWzX0fA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9IW-00000001vAf-3XBC;
	Thu, 05 Mar 2026 14:03:28 +0000
Date: Thu, 5 Mar 2026 06:03:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] misc: fix a few memory leaks
Message-ID: <aamNMAEbccYrThEv@infradead.org>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
 <177268457028.1999857.17585481929890297782.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177268457028.1999857.17585481929890297782.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

