Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAECE3FBB6
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140351; cv=none; b=ZZ52cVNkfx6Yt5YKZLQbN1CakDnsAxKP2RGtuaG1C5EXIWz2Cvt9wzyfMvp8ganILdVGA9dLoDwAVSNYwxgFHBzMOcxZ4wm1SmPNDKhtjXtKnkY8R60eJCx3pCN7HqseBofIgx07fJbmo0qyhySJtmYnwAoBdxpP/VN/vYGUGk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140351; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h44YGUBf4TnbfUmLRBlPnCT/5fU+2k9JHetd6zPZRngV3E3QB9Oo/XSHv+IkBqsSHwXiM9/Z2QI4uSJNOnFwbZxlK+gPUzzcNHcdhNimIN5F7FrnITzzQq+8aWAqJmwMMFbsZ3x8evePGYAkvmlLeqk72gMj/Y3drvXFY4tspsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o/Y8sMHA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o/Y8sMHA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=o/Y8sMHAwyqQKdYEMHGEpPjjlC
	GH4bfJ5ESEh6/y6um3hbtqwVju4t7TXNIkzZVb6RBywezSn+UoC1+GM+ogQuW9VgShR9Pb1iKDZlV
	ym5QysonVYTVDjrne/2OCJnjA/zsDWPYjtWP7uSocBy4w+Sj3f+xs56F0OG000RhasrH6DWdyROaP
	jVl9xdmYlNxSEiwf29fkMgnLw30Nc/SPLtDC6EPAnFD4Y+NOPb5uWU9Nz7KeSJxKtqYvFQU97hKWB
	/NzHlTXp1OhR4RljvLnq2FzemQxcBsmTKj1Azye4o//EQZoShT8Y10ms0H1eg19xgvprEhRlVBXEJ
	Bm1EC8PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNTp-0000000AFS8-1JOn;
	Wed, 28 Feb 2024 17:12:29 +0000
Date: Wed, 28 Feb 2024 09:12:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: update the unlinked list when repairing link
 counts
Message-ID: <Zd9pfbWahhqUXmB_@infradead.org>
References: <170900014056.939412.3163260522615205535.stgit@frogsfrogsfrogs>
 <170900014093.939412.14688993267476099238.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014093.939412.14688993267476099238.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
