Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40053CF050;
	Tue, 16 Jun 2026 05:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781587188; cv=none; b=KqKFb4GAW233PowwxnbK3SlQA7q/tRR4IlCsTRBBxoEnzdIBImFHhObf54apA9o34uYjjbrSfYfov36pknCfwa/JaKY+FKk96O/ytszmAPf5gBuS8/9rhca6VVuLJvatoYFyclpcZRNePrxHSXyxWgcdbnQT+4QO3LQWAd0iqko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781587188; c=relaxed/simple;
	bh=sixLjN0FDVO4HUjbBLP7jyXMbln2zQW1kQtx0+j4WBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S9Ttziy4GMW403ZoOq7eEEQTxSxcvnE5EPcHa3ohM3huK6rRQQtpmRw1wrpTSaS20h/Wz1Ntii2OBhMF4FAtPP80AQyP5saCy7nJ6M6oROGHpgsEiAnCuTPuwaEI8YiAVelHnx2xLYlQ3wmpGJfW4TtBKPkAD/96L8PNyCY+nuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qr5Owso0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qr5Owso0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lJY3rUCqFWGxeFm4eh9bZ4MnNqzzDeT0NZZ7p/99HHs=; b=Qr5Owso0HsiVXkL0WsUdgjCwX0
	CbxL8zqgWyoOWKucMhuD8d/aELfkNc/mAtcXlcukfeE8Pkud+j/GzXnX/iMvfgDML3euZfu1I5APo
	nsEHdJyqZk1PdZAqzfbSj8MEIhriKDOf3X2C4eVJCWANlbPvV8w+UiMhoHyTtOLEDSp0qEPTAaIu8
	0OhvlDY/1a97WybQO7T5LuAz+4SIn/ALqjgLRt6MvqQeNSHQ6+7w6u6F3tW0MNHiR0tzY/zriM8AO
	v1iZZVAnVnQgNiG7Ocdv1IAKdm8X/4B/YSWa7XKZDt+TiTobkJJKEqE22FSSKZcGHHhB93UVAhrxX
	cP1iUxcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZMDC-0000000FF3y-0et2;
	Tue, 16 Jun 2026 05:19:46 +0000
Date: Mon, 15 Jun 2026 22:19:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] iomap: reject NOWAIT and BOUNCE direct IOs
Message-ID: <ajDc8nFYyiQ66TOR@infradead.org>
References: <cover.1781253428.git.wqu@suse.com>
 <3d739b6dc37e34ca2a2a3780d12d0288a4060d57.1781253428.git.wqu@suse.com>
 <ajAU1yLd32BCiCNj@infradead.org>
 <efa3f1f9-20c2-44c0-914c-5e34a40235a1@gmx.com>
 <8a0e1881-fe73-4912-95f9-8eac998840d5@gmx.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a0e1881-fe73-4912-95f9-8eac998840d5@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 16, 2026 at 10:30:27AM +0930, Qu Wenruo wrote:
> After scanning the code for related memory allocation, there are some other
> locations doing memory allocation, including but not limited to:
> 
> - iomap_dio_alloc_bio()
>   This one is a little tricky, if we pass GFP_NOWAIT, we can break the
>   old assumption that the function will always return a bio.
> 
> - fscrypt_set_bio_crypt_ctx()
>   This one is fine so far, as neither XFS nor btrfs support fscrypt yet.
> 
> And any memory allocation failure in NOWAIT mode should return -EAGAIN, not
> -ENOMEM so that the caller can retry in blocking mode as a fallback.
> 
> To me, considering NOWAIT itself is only an optimistic flag, and caller
> should always have a blocking mode as fallback, I'd prefer to reject NOWAIT
> + BOUNCE direct writes completely inside btrfs for now.

If you want to do that in btrfs please do it there.

> And leave all the missing NOWAIT handling in iomap in a dedicated series.

This might be worth looking into.

