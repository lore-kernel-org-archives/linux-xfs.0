Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA0D42087A;
	Tue,  7 Jul 2026 06:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405235; cv=none; b=f3Gz9F4vPCvAMuZXy1ceHHRQiU1WeFDmAMTR/fdAfNDCyqaswaGE8sy8oscZ7Su+rExXMNszb0zUfjTxI+F3DjZW3jJ42OTzrmziGYIg4diEkJLBGTgsubd26tCqJGWpgsZ/3Kopt6xgeBNKkYjGaQYW+jYitg7+YnuxFKFrVGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405235; c=relaxed/simple;
	bh=uBLj+O7ae78MuWEFiTnXUGVMIHs2wcKxvw+5+TpyEFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJqtpsiUq9WIzfDSbTMequF+rZtHqWH8AIMVFCxNJM4UvnqA3QnsSCBjL+1BhNdAA6ObRrBh24qf/GdprEHbCAdcoqaPAEjn8ix+firZyurewSdL2JzGWGQbDTZfWTYFJBrTW3WkKVnmE9N1Obamw2HO0kTJrGIzxr42qvQwYGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iz8MOvd6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iz8MOvd6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bGKz//BeLD4xvJKFzmzgRZsAXpkOeS6YBKYjVby6CDE=; b=iz8MOvd6s83QqX0PltqG4mG7qL
	Oyp1ZZKXVtoDwTAaFmVbjNp6b+NiYIh5gUeUTwExAp4cLq2KeAgJz4AUtv5SEl4SK73NNJvr9kkZj
	0V74ceUPy5SroCp/l5ZH8388ZVC8V4r0kwAKlbVuW2GHx6zW2vKUYnGGanLJ4K834PinwS94WVefW
	5NZxCP0QQocmpq2iz+Vz4AZU59gVIJlaf1cwJytw51kU9GKIIexxmOwIEmAzS+Gmy+lxjfeMhNHxD
	EJAUhVxsJMQFCFxziznf8lgqZdNKEaxU2kxkJ7mioz+Xnq7z6lAE5DBG7Iaht/zsS75WHSjWr4VIm
	afhF1zWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgzAO-0000000ECLu-3Ezc;
	Tue, 07 Jul 2026 06:20:24 +0000
Date: Mon, 6 Jul 2026 23:20:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matteo Croce <technoboy85@gmail.com>, linux-xfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: ftruncate() after FICLONERANGE costs 300-600us/file, ~10x more
 than the clone itself
Message-ID: <akyaqGkBmxt2JG5n@infradead.org>
References: <CAFnufp2NJj=eXCpfoU4ZzPwSX31oUbsUr=Kstz6NedTZ3dsqZA@mail.gmail.com>
 <20260707055651.GX9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707055651.GX9392@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 06, 2026 at 10:56:51PM -0700, Darrick J. Wong wrote:
> XFS zeroes the tail block when you truncate down, which causes an out of
> place write.

All the file systems do it (or at least should).  But somehow we
manage to be slower.

I wonder if we hit the filemap_write_and_wait_range case in
xfs_vn_setattr_size due to a non-uptodate i_disk_size for this
workload somehow?  Although reflink should update i_disk_size
properly.

> 
> Assuming src.dat is the fully written 90000 byte file, can you
> 
> $ xfs_io -c "reflink src.dat 86016 86016 0" dest.dat
> 
> to link only the eof-block into dest.dat and keep its file size at
> 90000?

Only doing the reflink block aligned and copying data for partial
blocks should indeed always be faster.  But I wonder if we have
some dragons lurking in the truncate down path.

