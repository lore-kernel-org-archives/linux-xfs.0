Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E0D34D395;
	Thu,  9 Apr 2026 06:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775717618; cv=none; b=F8E3U6KoxqjjbuRukFcvLsPO2ez5i+5xO3DvZlW4ykMiyNQX330TXl9o/obn6lA2G4jJ4GOr8Vtf3GqQX94jDKxTNqWE0G0UXxzQ8JKmzykhnU2sV3VVCYlwedreSsF5Sa4usJGIqLlioYZ6NOodnnEJq34lncMFccQ+9RFAeWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775717618; c=relaxed/simple;
	bh=55ZSXrKPHfiTKGraJLFHw/MtkwJfaZhUMvIbUqgg1OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NpRECtWvqSbO6acDkBPRk2e5MDkEmMZTZliPdzU76HnQ0CeqYv2mrV/2UoGvgGpkx1qJC37Hk/njRScJyYi9Jf4JXWiyH/JQCeVH5S0J9kBaky20jGUgXsbZ9nDOOb0Gg68iLmg1B2NAzS/nMdd0mX4U7Ha89+Ha6w0RvXeOrLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RElT7W5v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RElT7W5v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=awI3HxktvHX0X5JFb+ssDeojgiSz+qfk8i/fUaGh0ms=; b=RElT7W5v/P5dXLnSR2pjDxKJXg
	2mfHJZXMnkMqkFX+l1BRM020vGT82OolnrWBoJdZy8I1vOBe5UmumVFgxUq0afMh/9OyvDToFE6df
	K+HDWKWi6A53qrbB2A/Ot8hpsvkH4UAwNy70GMJslSU3uXNGRze8LyuAvmeLb97UW0IlhXj1jsQu3
	ol7sAnZaRiWvzs6LujLL9L0ONUsVWvsPaOenjOvXjteicORYxlSIjQto3puH2TObnjYEq36KWS6hi
	FLxFxRqwZkt0BRmtfmuGurGuY36YZF+Ej9P4D+dBLf/eMkmWnmK1tHHCeENj8rBJv8y9uRilVhy7U
	zoO/Rb9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAjGb-00000009nGI-1ANh;
	Thu, 09 Apr 2026 06:53:29 +0000
Date: Wed, 8 Apr 2026 23:53:29 -0700
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
Subject: Re: [PATCH RFC v5 0/3] block: enable RWF_DONTCACHE for block devices
Message-ID: <addM6bkKKtoMvDIG@infradead.org>
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

What tree is this against?  I tried Jens' for-next and for-7.1/block
trees, linux-next and current mainline and it does not apply to any
of them.
