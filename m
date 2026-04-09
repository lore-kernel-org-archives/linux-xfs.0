Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173C33B6E3;
	Thu,  9 Apr 2026 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750923; cv=none; b=sUbZ6iJjFzp7kXwxQ/HTFEwyc/EiOCofvrD3/b4pgshHREhL+JaEQ3akgHs/rjtlUJy9erpoVkptCM8bmldInvx/RgwYfBpxqTevVdCAoyon5npKMGuJA0nH4PpJJtoFo1suMxdb1KujEJdS2yyw+3BCFp0XLj2s3pIAA15i0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750923; c=relaxed/simple;
	bh=mMID+rgsxew0RkSvMccqhsuu47v+LeaQSeiwdBrG0Ok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdWunqXbfT2o7i79T/i3c1EGvsj4PmBpBFmP2Wj+DiKnJoXqDBR5ubwpMA+j1u6d3cVzBEsZHVdrV1OGKigD2PwJ+BX1bsrl8rRX4HTCykOMnGeV0GAcfT/bnvlSff7dLHsnIySwWULSuCGT+dP3HBAIAynEcvi5Cmea4+dNSJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r59KVE9i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r59KVE9i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mMID+rgsxew0RkSvMccqhsuu47v+LeaQSeiwdBrG0Ok=; b=r59KVE9iRbfkYyt/uwNAp4hwIq
	gDKUAovMFJTRw07vQWwoYJazbbJyxyDXiQBouxmlEPXACR7CjHDC2ykHfr5yD2dWPQvU2yST+kNuw
	IDmZEFqKgL+k4UlgUrZsc6it3JpycnjJYh4MOup2Z97w736aFWt8yWKUEnetiKfa2OVM17VemusRo
	SaIPZvWXrQw37w2Ya2O5wwUa4EJNWWYwmgcAGSSyriMKWhzkjE0rizC3Nf1fNrOFY6Jx1dMljzFxu
	iSP4Dun+RWNHh5QlICAdg3XjmXUc/+QhhpwkvTcdkcstgumvHBz3Z7PYcPdrmomeL4ZpD9CRt4WJk
	gSjazsBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArvn-0000000AtTF-3Uka;
	Thu, 09 Apr 2026 16:08:35 +0000
Date: Thu, 9 Apr 2026 09:08:35 -0700
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
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v5 3/3] block: enable RWF_DONTCACHE for block devices
Message-ID: <adfPA0_U312XhCYF@infradead.org>
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
 <20260408-blk-dontcache-v5-3-0f080c20a96f@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408-blk-dontcache-v5-3-0f080c20a96f@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For the next round please split this into the buffer.c parts for
the infrastructure and the use in the block device file operations.

