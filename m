Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06D4EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944814; cv=none; b=hkKVoOO9g8za9QWgb11lCVqTh6OoE7ezPt3H28ycVFmUXbROyFaey1tJKfv9YG6YHQCwPU/uYDyD9+qsjgzJEQ8oQ0Jl6P8UQBZotszOgV2yc77UpWRJ+OEUSu1Q+S1jHZWlfg43u4DNZ2DpkDbSC7Uj+Mm5wrFtoWEtKr3QAVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944814; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTK5hAqpMNob29LO1a2LZ+HcXiRImQiUuR96fPv1Lsmzp3kgop2MTcF2v4WCDeTwJZXTZciVKD2F3SOszybPsWmEM6SB4myG+qDZEbZ4f5Og496ctUmRAaxV3dpMj04mjmaEXK4Dd9t8WfbOrhNekI7ks3YuWXyZyMz2velY8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CXMKi3Yr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CXMKi3Yr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CXMKi3YrduHXz5GPO45j3UuLuC
	iq3cYR2oGHGhRBRkZzeEmyQbjtKsrZ8jFtRcSg8cyAuKf8iPbaJ+VSgb7a7V5UdtoIwXB028Jyb0j
	8kf+2uJyGOHaj2LJTuUw4UqK0t1BKvbO05UwvlGWuqiJ/MV8w9GMfimigiUZVRMQT70Xkx9Q/cWub
	6vp3XpXeLATCopPF0cZwKtg1DZGiCZs9zLEzwFwHphccgONDbaFFmOHJN89xe2JFX0jBN7qMztNas
	OhVuYGdlFUW/liM+uIMV7UkBPJM8hykaVsXUokLxP10s+iHjfHZ4yWnBC6nm0fiXGXhVjqNmdqgIY
	Wumtc85g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW4L-00000007fZA-0KtD;
	Fri, 21 Jun 2024 04:40:13 +0000
Date: Thu, 20 Jun 2024 21:40:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/24] xfs: split new inode creation into two pieces
Message-ID: <ZnUELXqrWcsxlDeJ@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418050.3183075.11885704254562561755.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418050.3183075.11885704254562561755.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

