Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD993246F4;
	Mon, 18 May 2026 06:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779086978; cv=none; b=TLsyZ+pua7WpisRNUGTRfIUTaWZsa+qEpuJn27A5DN9AtcAB1Uto9iyKEy+hYw1m9BupVa5T630euGYBLTyTyd/WIOj+W64qzjsONpMZtzeiUIccQ7Y4tcZ/A9Y+7UKo6BeaylyuvBeiSTPRd8IUFKoLIQKkcTokKtwFkb/4gfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779086978; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hR7GCSnoeEG9jy0U37q2X0i+N8za9SHQeBRBLZT1W+GLjd46AzZrqeznlabe1lvreFvjaD343fEez43rYmS1Yk78Q9T/cmtIpc5ODVMLRlTdrA6lYOCVXDS73vsCuaoPWALfAnAbfBuecE1ejrPhuip4RuRLAEY2MgOqK5W4xZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y+ZQWG99; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y+ZQWG99"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=y+ZQWG99KWsb1eZb4FvaLqYaSS
	szp/N9NlUhi/oHPPTa2hbs+HFNsC6pOjGqv13yWoN1cyel2aVLKgAASEe2g9qGUha0HJrfzw8vm+4
	+O3Fv7vSZVw/V6K3TyE/YJoD92d/gTqp+kaf3C0SaqLpb5dFBP3Hpy0anT8uh1TebpfS3UvCN1O5K
	iXrDur0cowmlbMyD53As+vUPWRqIhaesPQ4ZuYT532qALCgd24hnumaBQQSOQq0kcCyETDTqRQ45F
	QJFl/qUuOyKLrXIUO0CxcaS7H/kpP+4fHXelfv/xrA5RufPPVZVeJCf43SHZybeVWNU+b1GZ4INhC
	lAYvz1nA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrnD-0000000ETmj-2usq;
	Mon, 18 May 2026 06:49:36 +0000
Date: Sun, 17 May 2026 23:49:35 -0700
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
Message-ID: <agq2f2ozYfAwwqcD@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

