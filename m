Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C7218A6C4
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074161; cv=none; b=ja31UOqf5BrKGgT454Ki8zU+ckLE8wwmZYlb2g6+2euopRR0o4T23/5vis4HuVDbajMHoAcfsQ5sOaFdjFF20jjQepDe/TzIImiGukNgWqMrmpbcPImVMntTIb+SloZARzTWUSXajAv41ucyB9s2UbEYqYkzI5n/MLs4z/Tu7QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074161; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvtChFumTQz7DZUKoki/a4/dQYiBhMdHUybVOzlQ189tqw+HU0cq40ZheUibYCY6bRnJD0AgDENYDLC9wgbDNI5sXFC8OfwEChLOqYILgTDoxFc4FRL3rv7DmzqbORmuUocCnMD5iQCAgPbEgEtrcMi/dgjlTjNf7NwPwZujL24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=41Rz+91N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="41Rz+91N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=41Rz+91NLMmS8KO9eDupfIdJCl
	K7B2tBS6CeavfG/NqfWhn0TsP1aiAyC8n9RT+Rocz5L/UvPUlaDKHmp082UxvoLIScCRFxsu7HvXu
	Rre/CVYHyJKBRsOCzI2fuPsgljCyjmW7wpRPl0fSiIYnp8cY5JiBgLA/3vNr8K2ZDSSch3YA+zJop
	3x8TQ5HBsNZMyjG7bplugdZ70TGvfrvWTfW268bQj9xcrhbMcC4RfOXzLXFHWRuLnqUgs+u0/IAto
	JT4ncki6zmrfLOWnbph9H5W9mOAXTTdYYuNpe4D+awNpn5HtycCNKEtrhU9w3LsPTRokv5fP/iyVV
	B9ruFF8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzu3-00000002wXe-3H6R;
	Fri, 13 Dec 2024 07:15:59 +0000
Date: Thu, 12 Dec 2024 23:15:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/37] xfs: cross-reference realtime bitmap to realtime
 rmapbt scrubber
Message-ID: <Z1vfL8rwxrTh28Bb@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123693.1181370.6852059995633084822.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123693.1181370.6852059995633084822.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

