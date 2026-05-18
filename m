Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA454380FF3;
	Mon, 18 May 2026 06:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779086951; cv=none; b=nRV003a9AphTfqh4RQ9yJCCV47RlgRtoxAk8+sxxwXZizrZPtMmbuWhXKXabfLgA6Iy3j4cSn+Z7h84a+woAfClvGcaXuyyvbab+P0BoqVhGIDponoWz7d6piqkAWqwT8rQQpnvY3sAwJlkY6HzR+GXO//mcUUXTRGbw+4NJatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779086951; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIeYxtOPpAyVKviGSmUxtiSbp6P2WRs2zWGdlAZnfscYiTNjzr5crSAzyOyWEfPMEOA6EiSbwhzCss3/QTk0Zlfh3+PXw5sqbwlLWebqd4FHdUrzcogkN8A9IDv9una93YSD0Kh/J3CBWdY6G0BJw+6lCeFDWMI9suw7MbJI+Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DdvWKG/C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DdvWKG/C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DdvWKG/CatSmbba1jyTEAK5yzY
	FymDJQmmWv7yROwQ7FrGSdJisZ+UryNak3HrG7tUtSQWR+5ckH893uLELNtDfZh52dlArszSGwjdC
	bN7QuJd/kS/mNGRdP4vi75nEUucPZ3Tq791ex3rnSAah+XAM4xJFvc7nlE5AuRtzcSeEwMYxh0NSh
	yaMkl1LyEzj/GFn3ateGMtLcFDhBaUaM47sNaARN/sJCQcWUkk8Hl/TzGWXf/h0zp3yfvQsBRPLp6
	LlPbtR8Q+yFzoe4cZ5/BUVcG+gvL15RMPc4zugHo/j12VnbpX/jXCeNKQmKvidgdad30cDlz2pFr5
	TBlUugPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrmn-0000000ETfw-00v3;
	Mon, 18 May 2026 06:49:09 +0000
Date: Sun, 17 May 2026 23:49:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 3/4] buffer: add dropbehind writeback support
Message-ID: <agq2ZAf7MUL3ap7N@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

