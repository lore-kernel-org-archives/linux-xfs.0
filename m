Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F253D9028;
	Mon, 15 Jun 2026 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781535960; cv=none; b=CsugNIn+HmiYwrYdv95Hf2TVIlJ/DB9rmTK/6BTI8NviPdk5xa6DlCvQ35zZPFqfpJ5C/lhCvVFIwe3KPLyBc1RpUHPXQNdjSCqrk/jz4wVH6afzNnVKarmCu9orly/fxtItVs6Q/cq7NkpOvzJPBczxLxHi9bsAD8jDERT7d9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781535960; c=relaxed/simple;
	bh=i3Oa1SvcqPQmZQwhd4snXFh25HgrJ6dnAxwKziTN6po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsbT1ayCTd+47VnFffb0tAXDBYKn+hsXEluI2YUV5Ky6xLHSf/b/oCgo84YbcG9Dx564JWHkc+I6gtfshAOnJvQc4qajDa7LcwWiHiWipwquBcdk18Z3RvTLpRfVPWswSQCUF39u/jRO6BPmQ+iwX2mJAhi2mDJESOHuacZ5h/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kumsowi3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kumsowi3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GdyZOyXydMikhzAYF55WMP5vDpNHFAUSq7+hJbHZ28Y=; b=kumsowi3PJw/kkp86LIw86azBx
	whlnIOsjMKv38B5I9Ekf1CTd0rsMnku+zJ/OSyDtNkey0xOdJCkIT9Q4lkiqlG86bRNp9ein06UDF
	M9vox8qqtNlY2XAMcnN8ZtTrJ1mg/LTnXrnne8i+9LXVxNFraq8heM6aVIjQ1rXW3Rdi2n6Bpm6Yc
	5VHOGIH8k4oz81kGOU24sD/MiP6S/3Qquwswhgohj8mfVioN/p4e4C2hx17FxVibaD5QmZvGGVYLv
	QHM24kT5gmIvLXOOjEmcpoL80D+6Ys1bjsjQUs2ysZ4LoAD3LliShnPXbJA2C5bBslbSyomVplYBU
	7eXy0BCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZ8sx-0000000ETda-0AUi;
	Mon, 15 Jun 2026 15:05:59 +0000
Date: Mon, 15 Jun 2026 08:05:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] iomap: reject NOWAIT and BOUNCE direct IOs
Message-ID: <ajAU1yLd32BCiCNj@infradead.org>
References: <cover.1781253428.git.wqu@suse.com>
 <3d739b6dc37e34ca2a2a3780d12d0288a4060d57.1781253428.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d739b6dc37e34ca2a2a3780d12d0288a4060d57.1781253428.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 07:21:14PM +0930, Qu Wenruo wrote:
> If a direct IO requires bounced pages for stable buffer, it will always
> allocate memory, and both bio_iov_iter_bounce_write() and
> bio_iov_iter_bounce_read() are allocating pages using GFP_KERNEL, which
> can sleep and break NOWAIT requirement.
> 
> So we need to reject such NOWAIT and BOUNCE direct IO in
> iomap_dio_bio_iter().

That's a bit heavy handed. Just do a noretry allocation.

