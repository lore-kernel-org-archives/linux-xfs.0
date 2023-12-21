Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F30B641
	for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 05:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JKs1AEVb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QSaVtLEGdSneuUtvrvfwH1rQNTz5ZMlBozXDpot4oD0=; b=JKs1AEVbqmq6EGcuwVKDhUddfR
	VAK7uo+2rNCSF7LSneqcCeeEi4/pZVGHHyHSoBlYfJl8msaM4BZtbvHWO2cWSzZwYFK6FEiV43R7/
	5NQLEUtTKlbAqKWZQSpagzK33Ak5YA4602U8zezMP/vnYb1GECgM1kw5lDxzYBVR1A+KrJaKWexp0
	PL6AOAwm+2ZHbdxkPwdjzGDOSsyGYf2wTLy4PRIG0NsnHgcdGYl+8LyphBcpMrW2hdm2OuhKGmVIz
	0sTTEDAVsTfRRWyAlQiuabd7NTOED3fSFIxSUhzb7B/Zz66onxBQe3kBwmOuViLSmNMk+5qUfpomn
	8gnpEaUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGBwi-001lzy-1Q;
	Thu, 21 Dec 2023 05:50:12 +0000
Date: Wed, 20 Dec 2023 21:50:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_io: extract contorl number parsing routines
Message-ID: <ZYPSFKZ2cMddlOIJ@infradead.org>
References: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
 <170309219120.1608142.14150492359425333052.stgit@frogsfrogsfrogs>
 <ZYPR6LYTefX5ILfs@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYPR6LYTefX5ILfs@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 20, 2023 at 09:49:28PM -0800, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Oh, and s/contorl/control/ in the subject line.

