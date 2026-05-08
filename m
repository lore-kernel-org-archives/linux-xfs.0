Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A64382F08
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230600; cv=none; b=dGwxnRB9WHrmc8B7bnW45f7ooEuJFZj3W6WppD7g9pdWpD7zEv5g1kwM7Eue5ACmB4GUpZvN9PeY3StmYlSPSoiNrAdPUTAo5xJ0DW99u7MFJcdtYOWgGty37GNkh/C/dJ5B54cCjSM1QmB2V2/GUj+bO60/J3I1qi255J8lbwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230600; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyfQE8VYLc1fvlc24uvfO9+LtNgIvtk9TFt725SGpMVctGWkMhuvUtexiDvoewBL+rBmv+i2PR7Bu9KSGCH5DPkNbJOsG3vZXxg/u4tfZJbPwx9x8wPMn3quMGY4gZo+TnoDb+knn/MudYc7vLNFTQLj/I+DsGt8R/FhguIhtPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=43rRADdw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="43rRADdw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=43rRADdwmHbtZCpcUztKsinm2h
	PF+iX/gJmlQu3+H1ktLxu4gIZeror8FoZKuGIP+ziu3kmDZ91oNJMRXV/zBXNPRrqgj9okhu3SYsa
	iruws6efdFa79xjA8lwXYJkGM5Stj5GnexIGC/SkVNmlCx1wCwhKzu11WkJG9gn7IAq3K7j+/Vt37
	TA4l6XD22GpC1b+PU4K56SoSGj+tImYbAVCvg78/G+r7L9PWXckrF0u7Inj5Qsu7MTep/pnyvZ4t9
	/wvBL7yxo0lTH3b/mminnmk0XmJ7BXlilzHXKYRPzCXOu0RZvkxdP/Z9jHkZj44+KpzYsxZvGbJGO
	08Z+saAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLH0g-000000063Iw-3Fnj;
	Fri, 08 May 2026 08:56:38 +0000
Date: Fri, 8 May 2026 01:56:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_scrub_all: remove dead code
Message-ID: <af2lRrDe5QxHNYKl@infradead.org>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
 <177819182677.3486034.15107252496396170007.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177819182677.3486034.15107252496396170007.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
