Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D52342524;
	Mon, 25 May 2026 05:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687062; cv=none; b=BkbDCM2gzbKPFbRwlo5LYEXXMUz+G02I9g5FQ0GNfaTkmt41v1tlBTNuK+Z65IbEzlO8FMxEy2QPempfDPvrDZN3/sjoXrG5DSZTSl7T7WRoNe/wyX8KOaeNm9cucAVCHypQ0yotgS04l2f7i/IwsmHkAq5bf4tNZ5gtnFKw3L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687062; c=relaxed/simple;
	bh=mneTr/PT7L8IGptiANNpugHuM64luBmMlC8aVKGJ8E0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfMTg4Dzjsk2DSNGMn+8NdAsYLZSN6JoD1bgkOT1o15TD8JsHW0RQEKXHkOGCQM2TT30jdsariUrzvsD+oLThDSlf6TqwLm+7UNO/E5rPAgIMRrZ4gghftyOCm29kspRxYoavQupCITPo53zOrEu6tSJgfJmPZUAIwv9bgyDghY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g4ON/0Fn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g4ON/0Fn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2U0I91EEn9zktr/NrB5JNMRj3jME1frv7H4DRKlkkao=; b=g4ON/0Fn2ZnumYYz2ZJB1T88cU
	rNHpVEomEVsJ1cxLFOKfkJusvgNbjI14ra30px6ASSOkgnAncCdx1EA8wpz5/7p/1AsnKtwKqlV6I
	9e9gIYLIifhVrQPuTGuIw0WSjFlSiqE27GCrGUkXo0zNRG6mnAv2cvSVoOM2ADeuTQ/A0CpP0E+GK
	cWVO9QKrA3z/8kpOdxQB+eBHDBYZlzyiRaukyYZP7CfTKl0/yONePwuuCWVo0ttW42wxXQGikkP2T
	dIKdMDBG+1ZRyYKO7UEM2j/7KJsUjYLGzL2eXOduhNg10pRUUA+L75zygat6xSUFHxJlExZTn/1b/
	V/+d1fLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNtu-0000000GKEh-46lr;
	Mon, 25 May 2026 05:30:54 +0000
Date: Sun, 24 May 2026 22:30:54 -0700
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
Subject: Re: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
Message-ID: <ahPejprWrEjsh7aC@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
 <f8d509c7-c0c0-4196-9a82-a6f8ae24ffc2@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8d509c7-c0c0-4196-9a82-a6f8ae24ffc2@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 22, 2026 at 07:17:15PM -0400, Tal Zussman wrote:
> A: So this actually seems legit... doesn't look like anything actually calls 
> blkdev_write_begin() or blkdev_write_end(), unless I'm missing something.
> block_write_begin_iocb() usage seems necessary for bh-based filesystems, but
> block devices seem to use iomap for writes unconditionally.

Yes.  Maybe send a separate patch to remove these now unused methods?
Or I could do that since I forgot to remove them when I should have.

