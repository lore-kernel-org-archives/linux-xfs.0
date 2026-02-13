Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F8BF513;
	Fri, 13 Feb 2026 07:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770966823; cv=none; b=LPtvptKRXz0562GeV7R0L+8zDztsjuNwRf+FzyblEset5sMVcp4fGAUFtaOqkgaRFD7AWBhM7J3gPDo351XzyMoLNY0ZijXnjkc+j5iPE6SlKLP8Bk8iHuTPqmq3GhZkPNMCkDkXvMF+vh4H8xkEOodFEztLvzVGfo9JAwAZHZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770966823; c=relaxed/simple;
	bh=fZqPeNPPGpejasboz9ZWvZonD+HEUMiLeVI3P/fnpbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IDhCc2lL/hENBYAuzcwzh7cTm5PLsGBjSuoqgBF7I69u0CsfAS6L1vsS1ZPDKRItZ514h2pqLNpY5N19PsSc/Z2R7QCeRWN2qtawQVwSnetiErzN5a7Gf0rM0m/K310fT75IyvCRaorJ2i5kA4dhrA8WVznJwxjCvqRBBCXRXDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KQwjb9sw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KQwjb9sw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fZqPeNPPGpejasboz9ZWvZonD+HEUMiLeVI3P/fnpbM=; b=KQwjb9swjWEbkZfIq92ZwtIQum
	CGWEI0DhMlUN1BNaZ3vecTm5TRmBraVQEGUn9Jp7YZQ0GOSpRzIibJhtTxh55sog6skJ3pz1jeNSe
	wQ5WA6kQ1DXuxTPI+Vbwcn6HT9pJtfLdiygfMaPq/dFd08DjyhntW/zqnaUTIrW0mVaLRY17Y78NK
	ap/DhhlAOqpXDO7lsaSt2GWQezSdA0zz3PPh/fl6oyTjQcMSxQ0Dar3ofhEWQEjLk2lTQiSlD4d6t
	iJqwEMb3Znhx4R8HVBiePLC/QkAx0AB1+OKnylD/FN/qTwA/TbAiZY6tM4g61UzWEPzuVlFEgHz7d
	qTcXh0bg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqnMz-000000035cs-3SW9;
	Fri, 13 Feb 2026 07:13:41 +0000
Date: Thu, 12 Feb 2026 23:13:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] fstests: use _fixed_by_fs_commit where appropriate
Message-ID: <aY7PJb_J9NPII1tI@infradead.org>
References: <20260213070148.37518-1-johannes.thumshirn@wdc.com>
 <20260213070148.37518-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213070148.37518-3-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Nice!

Reviewed-by: Christoph Hellwig <hch@lst.de>

