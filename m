Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0881826ACB;
	Wed, 19 Feb 2025 06:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945250; cv=none; b=byteEgJE/pv1D0vTb80WpS4keDN3pvEI8pu859PnDx/FG4qgqFni9b+YYKNfywPnSrQdDDxyktHOcFPbUgWV10mqfWkz+8wtSSKDe0IgUorshnizC7jSgakNn5ZtGps5qHTllq2NeKAW52a63qbhs9Mk5L3krSR0Jpy5y1ZtK6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945250; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=es9fgs0XMUqgv9P8tVCToBNeL650kWGaLV0/EnG5VwEJje5cxFd/WSFcQWCzmC4mybC/VK/nUCEEDPyT1y+rfPp51woVqYb0rdbB54TK02ZoqC9tmFVhjrKDL7Jcu0wj0bl0FNYITbog+Ba3vsedxeuCu8mCnHXBHWuMEq6WWAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b5Idm5mi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b5Idm5mi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=b5Idm5minLpL8PyFDqso6ldzkY
	Jf25vrtCmEJFrcrzm8Yc+tA5V2vhxc2g+mwnWYb7+pDpEiqcaOmaYiQuwdNE1FJbTOdSQoBJEGrI5
	IJbLoTooAVv+eL6dkwZSk8qYVzeyutvqiihSJMYDJI+ez/ZPmIPc9emF3k/Ett7qETv+/VOUjQ502
	dHMB7V/+7z4lwJntBkTuXiUAYAF9nmkMFuMEdpllLPLtSCKE2z1PrnF53oARxkVP8nitm1Z2FNSJC
	OodsRCijIEBecq6v0wFy43VrzNHO2OE0CGzEHVjI8FYffZxWwLJ5eHwLGW2fnrWVFHpbCPL55uGwG
	zX+mJD2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdF2-0000000Azxk-2yIh;
	Wed, 19 Feb 2025 06:07:28 +0000
Date: Tue, 18 Feb 2025 22:07:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: test metapath repairs
Message-ID: <Z7V1ICk2cW3wLiFb@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588278.4078751.17076800480211311441.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588278.4078751.17076800480211311441.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

